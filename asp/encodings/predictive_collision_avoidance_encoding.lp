%%%%%%%%%%%%%% TEMP %%%%%%%%%%%%%%%

step_limit(20).

cell(5,1,9,3).
cell(6,1,1,1).
cell(7,1,1,1).
cell(8,1,9,0).
cell(5,2,10,0).
cell(6,2,1,1).
cell(7,2,1,1).
cell(8,2,2,0).
cell(5,3,10,0).
cell(6,3,1,1).
cell(7,3,1,1).
cell(8,3,2,0).
cell(1,4,7,3).
cell(2,4,1,1).
cell(3,4,1,1).
cell(4,4,1,1).
cell(5,4,2,1).
cell(6,4,1,1).
cell(7,4,1,1).
cell(8,4,10,3).
cell(9,4,1,1).
cell(10,4,1,1).
cell(11,4,1,1).
cell(12,4,7,1).

agent(0,1,4,3,0).
agent_target(0,12,4).

% Define junction points:= Points at which lines end/
% All cell types, that are not empty straight or curved tracks.

junction(X,Y) :- cell(X,Y,2..7,_).
junction(X,Y) :- cell(X,Y,10,_).

% Helper
dir_diff(0, 0, -1).
dir_diff(1, 1, 0). 
dir_diff(2, 0, 1). 
dir_diff(3, -1, 0).

% Define how junctions link between orientations using 'link(C,OI,OO)'
% C = Cell Type
% OI = Incoming direction
% OO = Outgoing direction
% AA = Agent action 

% Simple switch - standard
link(2,0,0,2).
link(2,2,2,2).
link(2,0,3,1).
link(2,1,2,2).

% Simple switch - mirrored
link(10,0,0,2).
link(10,2,2,2).
link(10,0,1,3).
link(10,3,2,2).

% Diamond crossing
link(3,0,0,2).
link(3,2,2,2).
link(3,1,1,2).
link(3,3,3,2).

% Diamond crossing - Single slip
link(4,0,0,2).
link(4,2,2,2).
link(4,1,1,2).
link(4,3,3,2).
link(4,0,3,1).
link(4,1,2,3).

% Diamond crossing - Double slip
link(5,0,0,2).
link(5,2,2,2).
link(5,1,1,2).
link(5,3,3,2).
link(5,0,1,3).
link(5,3,2,1).
link(5,2,3,3).
link(5,1,0,1).

% Symmetrical
link(6,0,1,3).
link(6,0,3,1).
link(6,1,2,2).
link(6,3,2,2).

% Dead end
link(7,0,2,2).

% Build paths between junctions. 
% First start with straight lines and curves.

% Simple switch - standard
path(XO,YO,O',XO+XD,YO+YD,O',0) :- cell(XO,YO,2,OC), O'=(OC+2)\4, dir_diff(O',XD,YD).
path(XO,YO,O',XO+XD,YO+YD,O',0) :- cell(XO,YO,2,OC), O'=(OC+3)\4, dir_diff(O',XD,YD).
path(XO,YO,O',XO+XD,YO+YD,O',0) :- cell(XO,YO,2,OC), O'=(OC+4)\4, dir_diff(O',XD,YD).

% Simple switch - mirrored
path(XO,YO,O',XO+XD,YO+YD,O',0) :- cell(XO,YO,10,OC), O'=(OC+0)\4, dir_diff(O',XD,YD).
path(XO,YO,O',XO+XD,YO+YD,O',0) :- cell(XO,YO,10,OC), O'=(OC+1)\4, dir_diff(O',XD,YD).
path(XO,YO,O',XO+XD,YO+YD,O',0) :- cell(XO,YO,10,OC), O'=(OC+2)\4, dir_diff(O',XD,YD).

% Diamond crossing (+slips)
path(XO,YO,O',XO+XD,YO+YD,O',0) :- cell(XO,YO,3..5,OC), O'=(OC+0)\4, dir_diff(O',XD,YD).
path(XO,YO,O',XO+XD,YO+YD,O',0) :- cell(XO,YO,3..5,OC), O'=(OC+1)\4, dir_diff(O',XD,YD).
path(XO,YO,O',XO+XD,YO+YD,O',0) :- cell(XO,YO,3..5,OC), O'=(OC+2)\4, dir_diff(O',XD,YD).
path(XO,YO,O',XO+XD,YO+YD,O',0) :- cell(XO,YO,3..5,OC), O'=(OC+3)\4, dir_diff(O',XD,YD).

% Symmetrical fork
path(XO,YO,O',XO+XD,YO+YD,O',0) :- cell(XO,YO,6,OC), O'=(OC+1)\4, dir_diff(O',XD,YD).
path(XO,YO,O',XO+XD,YO+YD,O',0) :- cell(XO,YO,6,OC), O'=(OC+2)\4, dir_diff(O',XD,YD).
path(XO,YO,O',XO+XD,YO+YD,O',0) :- cell(XO,YO,6,OC), O'=(OC+3)\4, dir_diff(O',XD,YD).

% Dead end
path(XO,YO,O',XO+XD,YO+YD,O',0) :- cell(XO,YO,7,OC), O'=(OC+2)\4, dir_diff(O',XD,YD).

% Extend paths

% Across straight tracks
path(XO,YO,OO,X+XD,Y+YD,O,L+1) :- cell(X,Y,1,OC), dir_diff(O,XD,YD), path(XO,YO,OO,X,Y,O,L).
% Across curved tracks
path(XO,YO,OO,X+XD,Y+YD,O',L+1) :- cell(X,Y,8,OC), dir_diff(O',XD,YD), path(XO,YO,OO,X,Y,OI,L), O'=(OI+1+2*(OC\2-OI\2))\4.
path(XO,YO,OO,X+XD,Y+YD,O',L+1) :- cell(X,Y,9,OC), dir_diff(O',XD,YD), path(XO,YO,OO,X,Y,OI,L), O'=(OI+3-2*(OC\2-OI\2))\4.

% Finish connections
connection(X1,Y1,O1,X2,Y2,O2,L+1) :- path(X1,Y1,O1,X2,Y2,O2,L), junction(X2,Y2).

% Initialize agents on their junctions

chosen_connection(I,X,Y,O,0,X,Y,O,0) :- agent(I,X,Y,O,_).

% Chooses 1 possible path from the current junction
% I = ID of the agent
% X1,Y1 = Starting coordinates of the connection the agent enters
% O1 = First orientation of the agent on the outbound leg of the connection
% X2,Y2 = Ending coordinates of the connection the agent enters
% T = Time of entry into connection
% O2 = Final orientation of the agent on the inbound leg of the connection
% T+L = Time of exit from connection
1{chosen_connection(I,X1,Y1,O1,T,X2,Y2,O2,T+L) : 
    connection(X1,Y1,O1,X2,Y2,O2,L),
    cell(X1,Y1,C,OC), 
    link(C,(OA-OC+4)\4,(O1-OC+4)\4,_)}1 :- 
    chosen_connection(I,_,_,_,_,X1,Y1,OA,T), 
    not agent_done(I,T),
    step_limit(TL), T<TL.

% Define agent end state and constrain models to satisfied agents
agent_done(I,T2):-chosen_connection(I,X1,Y1,O1,T1,X2,Y2,O2,T2), agent_target(I,X2,Y2).
:- not agent_done(I,_), agent(I,_).

% Generate agent actions from chosen connections
agent_action(I, 2, T1+1) :-
    chosen_connection(I,X1,Y1,O1,T1,X2,Y2,O2,T2),
    T2 - T1 >= 1.


%#show junction/2.
%#show path/7.
%#show connection/7.
#show chosen_connection/9.
#show agent_action/3.