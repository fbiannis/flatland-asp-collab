% Define junction points:= Points at which lines end/
% All cell types, that are not empty straight or curved tracks.

junction(X,Y) :- cell(X,Y,2..7,_).
junction(X,Y) :- cell(X,Y,10,_).

% Helper
dir_diff(0, 0, -1).
dir_diff(1, 1, 0). 
dir_diff(2, 0, 1). 
dir_diff(3, -1, 0).

% Define how junctions link between orientations using 'link(C,O1,O2)'
% C = Cell Type
% O1 = Incoming direction 1
% O2 = Incoming direction 2
% A link between O1 and O2 signifies, that the incoming directions are connected.
% To find the outgoing direction for an incoming direction simply turn the other incoming orientation by 2

% Simple switch - standard
link(2,0,2).
link(2,0,1).

% Simple switch - mirrored
link(10,0,2).
link(10,0,3).

% Diamond crossing
link(3,0,2).
link(3,1,3).

% Diamond crossing - Single slip
link(4,0,2).
link(4,1,3).
link(4,0,1).

% Diamond crossing - Double slip
link(5,0,2).
link(5,1,3).
link(5,0,3).
link(5,2,1).

% Symmetrical
link(6,0,1).
link(6,0,3).

% Dead end
link(7,0,0).

% Build paths between junctions. 
% First start with straight lines and curves.

% Simple switch - standard
path(XO,YO,XO+XD,YO+YD,O',0) :- cell(XO,YO,2,OC), O'=(OC+2..4)\4, dir_diff(O',XD,YD).

% Simple switch - mirrored
path(XO,YO,XO+XD,YO+YD,O',0) :- cell(XO,YO,10,OC), O'=(OC+0..2)\4, dir_diff(O',XD,YD).

% Diamond crossing (+slips)
path(XO,YO,XO+XD,YO+YD,O',0) :- cell(XO,YO,3..5,OC), O'=(OC+0..4)\4, dir_diff(O',XD,YD).

% Symmetrical fork
path(XO,YO,XO+XD,YO+YD,O',0) :- cell(XO,YO,6,OC), O'=(OC+1..3)\4, dir_diff(O',XD,YD).

% Dead end
path(XO,YO,XO+XD,YO+YD,O',0) :- cell(XO,YO,7,OC), O'=(OC+2)\4, dir_diff(O',XD,YD).

% Extend paths
% Across straight tracks
path(XO,YO,X+XD,Y+YD,O,L+1) :- cell(X,Y,1,O), dir_diff(O,XD,YD), path(XO,YO,X,Y,O,L).
% Across curved tracks
path(XO,YO,X+XD,Y+YD,O',L+1) :- cell(X,Y,8,OC), dir_diff(O',XD,YD), path(XO,YO,X,Y,OI,L), O'=(OI+1+2*(OC\2-OI\2))\4.
path(XO,YO,X+XD,Y+YD,O',L+1) :- cell(X,Y,9,OC), dir_diff(O',XD,YD), path(XO,YO,X,Y,OI,L), O'=(OI+3-2*(OC\2-OI\2))\4.

% Finish connections
connection(X1,Y1,X2,Y2,O,L+1) :- path(X1,Y1,X2,Y2,O,L), not connection(X2,Y2,X1,Y1), junction(X2,Y2).

% Predict collisions
% enter_connection(X1,Y1,X2,Y2,O,T).
% 
% 



#show junction/2.
#show path/5.
#show connection/6.
#show connection_occupany/7.