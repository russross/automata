%% Macros for Computational Theory diagrams
%% by Russ Ross
%% Last revised September 2015

verbatimtex
\documentclass [10pt]{article}
\usepackage{amsmath}
\begin {document}
etex;

% set up for huge nodes
def hugenodes =
    node_radius := 0.5cm;
    final_radius := node_radius-.075cm;
    loop_size := 0.7cm;
    loop_emerge := 9;
    ahlength := 4bp;
    edgecolor := black;
    edgedash := 0;
    edgedirected := 1;
    curve := 25;
enddef;

% set up for big nodes (default)
def bignodes =
    node_radius := 0.35cm;
    final_radius := node_radius-.05cm;
    loop_size := node_radius * 2;
    loop_emerge := 9;
    ahlength := 3bp;
    edgecolor := black;
    edgedash := 0;
    edgedirected := 1;
    curve := 25;
enddef;

% set up for medium nodes
def mediumnodes =
    node_radius := 0.25cm;
    final_radius := 0.2cm;
    loop_size := 0.5cm;
    loop_emerge := 9;
    ahlength := 3bp;
    edgecolor := black;
    edgedash := 0;
    edgedirected := 1;
    curve := 25;
enddef;

% set up for small nodes
def smallnodes =
    node_radius := 0.15cm;
    final_radius := 0.1cm;
    loop_size := 0.5cm;
    loop_emerge := 9;
    ahlength := 2bp;
    edgecolor := black;
    edgedash := 0;
    edgedirected := 1;
    curve := 25;
enddef;

% set up for tiny nodes
def tinynodes =
    node_radius := 0.1cm;
    final_radius := 0.05cm;
    loop_size := 0.1cm;
    loop_emerge := 9;
    ahlength := 2bp;
    edgecolor := black;
    edgedash := 0;
    edgedirected := 1;
    curve := 25;
enddef;

% set up for mini nodes
def mininodes =
    node_radius := 0.05cm;
    final_radius := 0.05cm;
    loop_size := 0.1cm;
    loop_emerge := 9;
    ahlength := 2bp;
    edgecolor := black;
    edgedash := 0;
    edgedirected := 1;
    curve := 25;
enddef;

% to change all lines (including boxes):
% drawoptions(withcolor blue)
% drawoptions(dashed evenly)
%
% to reset:
% drawoptions()

% change edge colors
def rededges = edgecolor := red enddef;
def blueedges = edgecolor := blue enddef;
def greenedges = edgecolor := green enddef;
def blackedges = edgecolor := black enddef;

% change between dashed and solid edges
def dashededges = edgedash := 1 enddef;
def solidedges = edgedash := 0 enddef;

% change between arrows and lines
def directededges = edgedirected := 1 enddef;
def undirectededges = edgedirected := 0 enddef;

% set up some handy labels
picture A, B, AB, C, E, K, N, X, Y, Z,
        ZERO, ONE, ZEROONE, SIGMA, EMPTYSET, CDOTS, VDOTS, SQCUP, BLANK, BIGGEST;
A = btex $a$ etex;
B = btex $b$ etex;
AB = btex $a,b$ etex;
C = btex $c$ etex;
E = btex $\varepsilon$ etex;
K = btex $k$ etex;
N = btex $n$ etex;
X = btex $x$ etex;
Y = btex $y$ etex;
Z = btex $z$ etex;
ZERO = btex $0$ etex;
ONE = btex $1$ etex;
ZEROONE = btex $0,1$ etex;
SIGMA = btex $\Sigma$ etex;
EMPTYSET = btex $\emptyset$ etex;
CDOTS = btex $\cdots$ etex;
VDOTS = btex $\vdots$ etex;
SQCUP = btex $\sqcup$ etex;
BLANK = nullpicture;
% other letters will be put into a box big enough for
% this letter when using tape squares
BIGGEST = B;

% create (but don't actually draw) a node, e.g.:
%    node.a("a");
% The node is a circle from the "boxes" package
% use drawboxed(a,b,c); drawunboxed(a,b,c); drawboxes(a,b,c); to render nodes
vardef node@#(text tt) =
    circleit@#(tt);
    @#e-@#c = (node_radius,0);
    @#n-@#c = (0,node_radius)
enddef;

% draw a smaller circle inside some nodes, making them final states
def makefinal(text t) =
    forsuffixes s=t:
        draw s.c + (final_radius,0) ..
             s.c + (0,final_radius) ..
             s.c - (final_radius,0) ..
             s.c - (0,final_radius) ..
             cycle;
    endfor
enddef;

% draw a start symbol to the left of some nodes, making them start states
def makestart(text t) =
   forsuffixes $=t:
        draw ((-.8,.8)--(0,0)--(-.8,-.8)) scaled node_radius shifted $.w;
    endfor
enddef;

% draw a start symbol above some nodes
def makestart_top(text t) =
    forsuffixes s=t:
        draw ((-.8,.8)--(0,0)--(.8,.8)) scaled node_radius shifted s.n;
    endfor
enddef;

% internal macro used for placing a label
% the label is placed at p, pushed along
% the direction vector far enough that the bbox
% just touches p
def put_label(expr anchorpath, anchorpoint, movedir)(text lab) =
    begingroup;
    save pic, nudgedir, shiftedpath;
    picture pic;
    pair nudgedir;
    path shiftedpath;

    % move the path enough to create a bit of whitespace
    shiftedpath := anchorpath shifted ((unitvector movedir) scaled bboxmargin);

    % start with a centered picture
    if string lab:
        pic := lab infont defaultfont scaled defaultscale;
        pic := pic shifted -center(pic)
    elseif picture lab:
        pic := lab shifted -center(lab)
    else:
        pic := nullpicture
    fi;
    if length (ulcorner pic - lrcorner pic) = 0:
        setbounds pic to (1,1) -- (1,-1) -- (-1,-1) -- (-1,1) -- cycle
    fi;

    % xpart of movedir scaled by the width of the label, ypart scaled by the
    % height of the label
    nudgedir := unitvector (xpart movedir * xpart urcorner pic,
                            ypart movedir * ypart urcorner pic) scaled 0.1bp;

    % shift the center of the picture in the requested direction
    pic := pic shifted anchorpoint;

    % now nudge it repeatedly until there are no more intersections
    forever:
        exitif (-1, -1) = shiftedpath intersectiontimes
               (ulcorner pic -- urcorner pic --
                lrcorner pic -- llcorner pic -- cycle);
        pic := pic shifted nudgedir;
    endfor;
    draw pic
    endgroup
enddef;

% draw an edge between two nodes.  A few ways to use it:
%   edge(start,end,curve,"label"); % curved, labeled edge
%   edge(start,end,45,"label"); % curved edge with a specific angle
%   edge(start,end,left,"label"); % straight edge with the label to the left
%   edge(start,end,curve,BLANK); % curved edge with no label
%   edge(start,end,left,BLANK); % straight edge with no label
def edge(suffix from, to)(expr direction)(text lab) =
    begingroup;
    save pth,z;
    save edgedir;
    numeric edgedir;
    path pth;
    pair z[];
    z0 = from.c;
    z1 = to.c;
    z2 = z1-z0;

    % "direction" is an angle for curves, or the direction to shift the label
    % for straight edges
    if pair direction : edgedir := 0 else : edgedir := direction fi;

    pth = z0{dir ((angle z2) + edgedir)} ... {dir ((angle z2) - edgedir)}z1
        cutbefore bpath.from cutafter bpath.to;

    % half way along the curve
    z3 = point .5 of pth;

    % direction to shift label (as a vector)
    if pair direction:
        z3 := z3 - unitvector z2 scaled
            if edgedirected = 1: 0.5 ahlength else: 0 fi;
        z4 := z2 rotated ((angle direction) - 90)
    else:
        z4 := z3 - (1/2[z0,z1])
    fi;

    put_label(pth, z3, z4, lab);
    if edgedirected = 1: drawarrow else: draw fi
        pth withcolor edgecolor
        if edgedash = 1: dashed evenly fi
    endgroup
enddef;

% draw a straight edge between two nodes.
%   sedge(start,end);
def sedge(suffix from, to) = edge(from, to, left, BLANK) enddef;

% draw a loop:
%    loop(node,up,"label"); % labeled loop going up
%    loop(node,right,BLANK); % unlabeled loop to the right
def loop(suffix from)(expr direction)(text lab) =
    begingroup
    save p,z,n;
    path p;
    pair z[];

    z0 = from.c;
    z1 = unitvector direction scaled (loop_size + node_radius) shifted z0;
    z2 = unitvector (direction rotated loop_emerge)
        scaled node_radius shifted z0;
    z3 = unitvector (direction rotated -loop_emerge)
        scaled node_radius shifted z0;
    p = z0...z2...z1...z3...z0 cutbefore bpath.from cutafter bpath.from;

    % draw the label
    put_label(p, z1, direction, lab);

    if edgedirected = 1: drawarrow else: draw fi p
        withcolor edgecolor
        if edgedash = 1: dashed evenly fi
    endgroup
enddef;

% start a group of boxes joined left-to-right
def begintape = boxjoin(a.e = b.w) enddef;

% start a group of boxes joined top-to-bottom
def beginverticaltape = boxjoin(a.s = b.n) enddef;

% end a group of joined boxes
def endtape = boxjoin() enddef;

% create (but don't actually draw) a tape square, e.g.:
%    tapesquare.a("a");
% The node is a box from the "boxes" package
% use drawboxed(a,b,c); drawunboxed(a,b,c); drawboxes(a,b,c); to render nodes
vardef tapesquare@#(text in) =
    boxit@#(begingroup
    save l, r, t, b, p;
    picture p;

    % make sure we have a picture
    if string in: p := in infont defaultfont scaled defaultscale;
                  p := p shifted -(xpart center p, 0)
    elseif picture in: p := in shifted -(xpart center in, 0)
    else: p := nullpicture fi;

    % put the picture in a square box, or one wide enough to fit the label
    r = -l = .5 *
        if (ypart ulcorner BIGGEST - ypart llcorner BIGGEST) >
                (xpart urcorner p - xpart ulcorner p):
            (ypart ulcorner BIGGEST - ypart llcorner BIGGEST)
        else: (xpart urcorner p - xpart ulcorner p) fi;
    t = ypart ulcorner BIGGEST;
    b = ypart llcorner BIGGEST;
    setbounds p to (l,b)--(r,b)--(r,t)--(l,t)--cycle;
    p
    endgroup)
enddef;

% add an open-ended square with CDOTS to the right of given square
def tapecontinueright(text in) =
  draw in.ne -- in.ne + (in.ne - in.nw);
  draw in.se -- in.se + (in.se - in.sw);
  label.rt(CDOTS, in.e)
enddef;

% add an open-ended square with CDOTS to the left of given square
def tapecontinueleft(text in) =
  draw in.nw -- in.nw - (in.ne - in.nw);
  draw in.sw -- in.sw - (in.se - in.sw);
  label.lft(CDOTS, in.w)
enddef;

% draw a line across the bottom of the given square, extending out
% beyond the edges to mark the bottom of a stack
def stackbottom(text in) =
  draw in.sw - 0.5(in.s - in.sw) -- in.se + 0.5(in.se - in.s)
enddef;

% draw a box with the given left, right, top, and bottom positions
def drawbox(expr l,r,t,b) =
    draw (l,t)--(r,t)--(r,b)--(l,b)--cycle
enddef;

% draw an arrow with the ends clipped
def shortarrow(expr a, b, eps) =
  drawarrow a -- b cutbefore fullcircle scaled eps shifted a
                   cutafter  fullcircle scaled eps shifted b
enddef;

% set default starting values
color edgecolor;
numeric edgedirected, edgedash;
bignodes;
