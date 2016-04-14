Automata diagrams for LaTeX
===========================

I wrote these macros to make it easier to create diagrams of finite
automata (DFAs and NFAs), pushdown automata (PDAs), Turing machines,
etc. I use LaTeX to prepare my slides and problem sets, and I
require my students to use LaTeX in writing up their solutions.
This package makes it simple to create figures using Metapost that
can easily be included in LaTeX documents of all types.

To get started, look at `figure-examples.tex`, which contains a few
basic examples. For those conversent with LaTeX and Metapost, the
macros are based around the Metapost `boxes` package. Simple
wrappers make it easier to create nodes with consistent sizing and
to mark start and accept nodes.

The edge command makes it easy to draw straight and curved edges
between nodes. It also places labels intelligently, halfway between
the end nodes and adjusted so that larger labels do not overlap the
edge.


Inline figures
--------------

The example `.tex` file also shows how to use the `emp` LaTeX
package, which makes it convenient to write your figures inline with
the rest of the LaTeX code.

In the prelude of your LaTeX document, include a few packages:

    \usepackage{emp,ifpdf}
    \usepackage{graphicx}

Metapost produces embedded postscript, but it happens to also be
valid PDF code, so we instruct LaTeX to do the conversion
automatically (the result will work with `pdflatex` or regular
`latex`):

    \ifpdf\DeclareGraphicsRule{*}{mps}{*}{}\fi

To include the macros and the `boxes` package that they depend on,
have LaTeX put a header in the Metapost file it produces:

    \empprelude{input boxes; input theory}

Next, inside the document itself start a Metapost file:

    \begin{empfile}

At the end of the document (any time after the last figure) close it
with:

    \end{empfile}

Each time you want to create a figure, do so in an `emp` environment:

    \begin{emp}(0,0)
    % figure goes here
    \end{emp}

I usually center my figures by nesting them in a `center` environment.

Where I've put `(0,0)`, you can specify the size of the figure. All
it does is define variables *w* and *h* with the width and height,
respectively. You can use those in your figure definition to make a
scalable figure. I don't usually bother, so I just declare each one
with `(0,0)`.

One caveat: the `emp` environment uses `verbatim`, which makes this
fail in some circumstances. Notably, if you use the `beamer`
package for preparing slides, you will need to start the frame with:

    \begin{frame}[containsverbatim]{Title of slide}

or it will fail with mysterious error messages.

You can also define a named figure and include it later. Only the
definition uses a `verbatim` environment, so you can include the
figure itself anywhere, including as a parameter to a macro. To do
so, define the figure in an `empdef` environment:

    \begin{empdef}[figurename](0,0)
    % figure goes here
    \end{empdef}

Then when you want to include it, use:

    \empuse{figurename}

One more hint: when including small figures inline with text, it is
often nice to be able to shift it up or down a bit to line it up
with the text. To do that, create a named figure, then use
something like: `\raisebox{.25em}{\empuse{figurename}}`

When compiling the LaTeX file, you must instruct it to permit
external programs to be run:

    pdflatex -shell-escape myfile.tex

You also need to run the command twice. The first time dumps the
figures into a file and runs Metapost on it, the second time
actually includes the rendered figures.


Tutorial
--------

Inside each figure, I usually define a size unit and specify all
spacing in terms of that unit:

    u := 1cm;

Then I can tweak the size easily. This does not scale the size of
nodes, tape squares, or labels, but it is helpful even so.


### Nodes

To create a DFA node, use the `node` macro:

    node.q0("label");

This creates a node with the internal name `q0`, and displays the
given label inside it when rendered. The label can be omitted.

The label can be a simple string, or you can render something using
LaTeX:

    node.q0(btex $a$ etex);

I have defined a bunch of common labels already, which can be used
as node labels, edge labels, or anywhere else. This example could
have been written:

    node.q0(A);

Here is the complete list of pre-defined labels:

    A, B, AB, C, E, K, N, X, Y, Z, ZERO, ONE, ZEROONE, SIGMA,
    EMPTYSET, CDOTS, VDOTS, SQCUP, BLANK

If you are unsure about what any of them are, look at `theory.mp`
for the definitions or try them out.

Nodes use the Metapost `boxes` package. It provides anchor points
at the center, north, south, each, and west points on the node,
accessible as `q0.c`, `q0.n`, `q0.e`, etc. You must specify one
such point for each node, and the rest will be computed
automatically:

    q0.c = (0,0);

You can anchor additional nodes using absolute positioning, or you
can place them relative to each other:

    node.q1();
    q1.c = q0.c + (2u,0);

Up to this point, nothing will actually be displayed. The basic
rule is that Metapost must be able to compute absolute positions for
each object before it can be rendered. When you have given it
enough information to do so, you can draw one or more nodes using
the `drawboxed` command:

    drawboxed(q0,q1);

This draws the nodes and their labels. If you only want the nodes
(without labels), use:

    drawboxes(q0,q1);

And if you only want labels but no boxes, use:

    drawunboxed(q0,q1);

This is occasionally useful if you want to use different colors, for
example.


### Start and final nodes

Final nodes are displayed with a smaller circle inside the main
node. To mark nodes as final nodes, use:

    makefinal(q0,q1);

This draws the line immediately, so you cannot use it until the
node's position has been established. Similarly, you can mark nodes
as start nodes:

    makestart(q0,q1);

This draws a `>` sign on the left of the node. To put it on the top
instead, use:

    makestart_top(q0,q1);


### Edges

Next are edges. Edges can be defined in several ways. A simple
straight edge with no label from `q0` to `q1`:

    sedge(q0,q1);

Edges are directed by default, but you can specify undirected edges
as well. The general form of edges is this:

    edge(from,to,angle,label);

`from` and `to` are nodes.  angle can be "`left`" or "`right`" to
specify a straight edge (with the label on the left or right,
respectively), "`curve`" to indicate a default curve, "`-curve`" to
curve the other way, or any angle (in degrees) that you specify.
When you specify an angle, you are instructing it to set the angle
(relative to a straight edge) at the point the edge leaves the start
node and arrives at the destination node.

If you don't want a label, use `BLANK` as the label. A few examples:

    % a straight, empty transition (labeled with \varepsilon) with
    % the label on the left side
    edge(q0,q1,left,E);

    % a curved edge with $a$ as the label
    edge(q0,q1,curve,A);

    % a -45 degree curve (negative angles curve right)
    edge(q0,q1,-45,B);

    % a right-curved edge with no label
    edge(q0,q1,-curve,BLANK);

Edges are rendered immediately, so both end nodes must be
positioned.

The `edge` macro tries to place the label in a good place. It starts
by placing it at the center of the edge on the outside of the curve
(or on the side you specify for straight edges). Then it starts
nudging it further out until the bounding box of the label no longer
overlaps the edge. The direction it nudges it is chosen based on
the shape of the label. It tends to give a good result even for
long or tall labels. It only worries about the edge, however; you
must provide enough space to prevent overlap with nodes.


### Loops

Looped edges are a special case. You must specify the node, the
side of the node the loop should be attached to (`up`, `down`,
`left`, or `right`), and the label:

    loop(q0,up,AB);


### Node sizes

A series of node sizes are predefined.  Declare the size you want
before you start making nodes. From largest to smallest:

    hugenodes;
    bignodes;
    mediumnodes;
    smallnodes;
    tinynodes;
    mininodes;

Note that changes in one figure persist to the next if you use
multiple figures in one file, so it is best to explicitly select a
size in each figure.


### Edge colors

You can change edge colors using:

    rededges;
    blueedges;
    greenedges;
    blackedges;

or you can assign a Metapost color to `edgecolor`.


### Other options

Similarly, you can turn dashed edges on and off using:

    dashededges;
    solidedges;

And for directed and undirected edges:

    directededges;
    undirectededges;

Note that these only affect edges.  If you want colored or dashed
nodes, use the metapost command:

    drawoptions(withcolor blue);
    drawoptions(dashed evenly);
    drawoptions(dashed evenly withcolor blue);

To reset such options, use the command with no options:

    drawoptions();

These commands affect all drawing, not just nodes.


### Tape squares

To draw tapesquares, first declare that you are beginning a tape:

    begintape;

Or for a vertical tape (a stack):

    beginverticaltape;

In either case, create a series of squares as you would nodes:

    tapesquare.a(A);
    tapesquare.b(B);
    tapesquare.c(X);

You must anchor a single point on any one of the squares; all of the
rest will be positioned automatically. In addition to the points
you can use with nodes, you can use `nw`, `ne`, `sw`, and `se` to
specify the four corners of each square.

The sizes of the squares are set according to the label `BIGGEST`,
which defaults to be the same as `B`. Each square will be big
enough to accommodate the longest dimension of `BIGGEST`. If you
are using custom labels, you may need to reset `BIGGEST` to match
your largest label (before creating any tape squares):

    BIGGEST := AB;

If you want an open-ended square at the end of the tape, use:

    tapecontinueright(rightmostsquare);

or at the left end of the tape:

    tapecontinueleft(leftmostsquare);

To mark the bottom of a stack with lines sticking out, use:

    stackbottom(bottomsquare);

Note that these do not actually create tape nodes, but rather
decorate existing nodes. The label and lines are rendered
immediately, so the tape square must be positioned already. For the
actual tape squares, you must use `drawboxed()` and its kin to
display the tape squares, just as you would with nodes.

When you reach the end of the tape (either kind), mark it with:

    endtape;


### Other helpful macros

A simple macro is included for drawing normal Metapost arrows that
are shortened a bit at both ends:

    shortarrow(startpoint,endpoint,2pt);

This would draw an arrow from the start point to the end, but
shortened by 2 points. Note that these are points, not nodes.

Finally, another convenience macro to draw a box by specifying the
left, right, top, and bottom coordinates:

    drawbox(0,2u,5u,4u);

For more information about Metapost in general, various references
and tutorials are available online. These macros are enough for
most basic diagrams my students need to create, but Metapost is
capable of a lot more.
