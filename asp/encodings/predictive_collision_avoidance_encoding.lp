% Define junction points := Points at which lines start & end + stations.
% All cell types, that are not empty straight or curved tracks or contain a station are junctions.
junction(X,Y) :- cell(X,Y,2..7,_).
junction(X,Y) :- cell(X,Y,10,_).
% Stations = Junctions
junction(X,Y) :- agent(_,X,Y,_,_).
junction(X,Y) :- agent_target(_,X,Y).

% Helper
dir_diff(0, 0, -1).
dir_diff(1, 1, 0). 
dir_diff(2, 0, 1). 
dir_diff(3, -1, 0).

% Define how junctions link between orientations using 'link(C,OI,OO,A)'
% C  = Cell Type
% OI = Incoming direction
% OO = Outgoing direction
% A  = Agent action 

% Straight track
link(1,0,0,2).
link(1,2,2,2).

% Curved tracks
link(8,0,1,2).
link(8,3,2,2).
link(9,0,3,2).
link(9,1,2,2).

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
link(7,2,2,2).

% Build connections between junctions by using paths. 
% path(XO,YO,OO,X,Y,O,L)
% XO,YO = Origin of the path (starting junction)
% OO    = Original departure Orientation (on leaving XO,YO)
% X,Y   = Destination of the path
% O     = Orientation on arriving at X,Y 
% L     = Length of the path
% First start by initializing paths going out from all junctions.

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


% Then: Extend paths recursively

% Across straight tracks
path(XO,YO,OO,X+XD,Y+YD,O,L+1) :- cell(X,Y,1,OC), dir_diff(O,XD,YD), path(XO,YO,OO,X,Y,O,L).
% Across curved tracks
path(XO,YO,OO,X+XD,Y+YD,O',L+1) :- cell(X,Y,8,OC), dir_diff(O',XD,YD), path(XO,YO,OO,X,Y,OI,L), O'=(OI+1+2*(OC\2-OI\2))\4.
path(XO,YO,OO,X+XD,Y+YD,O',L+1) :- cell(X,Y,9,OC), dir_diff(O',XD,YD), path(XO,YO,OO,X,Y,OI,L), O'=(OI+3-2*(OC\2-OI\2))\4.

% Finish connections - paths that start and end in junctions!
connection(X1,Y1,O1,X2,Y2,O2,L+1) :- path(X1,Y1,O1,X2,Y2,O2,L), junction(X2,Y2).

% Initialize agents on their junctions and positions
chosen_connection(I,-1,-1,O,0,X,Y,O,0) :- agent(I,X,Y,O,_).
agent_position(I,0,X,Y,O) :- agent(I,X,Y,O,_).

% Choose 1 possible path from every agent's current junction
% chosen_connection(I,X1,Y1,O1,T1,X2,Y2,O2,T2)
% I     = ID of the agent
% X1,Y1 = Starting coordinates of the connection the agent will enter
% O1    = First orientation of the agent on entering the connection through the junction at X1,Y1
% T1    = Time of departure from the junction at X1,Y1
% X2,Y2 = Ending coordinates of the connection the agent has entered
% O2    = Final orientation of the agent on arriving at the junction at X2,Y2
% T2    = Time of arrival at the junction at X2,Y2
1{chosen_connection(I,X1,Y1,O1,T,X2,Y2,O2,T+L): 
    connection(X1,Y1,O1,X2,Y2,O2,L),
    cell(X1,Y1,C,OC), 
    link(C,(OA-OC+4)\4,(O1-OC+4)\4,_)}1 :- 
    chosen_connection(I,_,_,_,_,X1,Y1,OA,T), 
    not agent_done(I,T),
    step_limit(TL), T<TL.

% Define agent end state and constrain models to agents having all arrived
agent_done(I,T2):-chosen_connection(I,X1,Y1,O1,T1,X2,Y2,O2,T2), agent_target(I,X2,Y2).
:- not agent_done(I,_), agent(I,_,_,_,_).

% Generate agent actions from chosen connections
% agent_action(I,A,T)
% I = Agent ID
% A = Action of the agent
% T = Time step of the action
% At junctions:
agent_action(I,A,T):-
    chosen_connection(I,X,Y,OO,T,_,_,_,_),
    chosen_connection(I,_,_,_,_,X,Y,OI,_),
    agent_position(I,T,X,Y,_),
    cell(X,Y,C,OC),
    link(C,(OI-OC+4)\4,(OO-OC+4)\4,A).

% Between junctions
agent_action(I,2,T):-
    agent_position(I,T,X,Y,_),
    not junction(X,Y),
    not agent_action(I,4,T).

% For waiting by choice
{agent_action(I,4,T)} :- 
    agent_position(I,T,X,Y,_),
    cell(X,Y,C,OC),
    link(C,_,OO,A),
    dir_diff((OO+OC)\4,X',Y'),
    junction(X',Y').
% For waiting on standing train ahead
agent_action(I,4,T):-
    agent_position(I,T+1,X,Y,_),
    agent_position(I',T,X,Y,_),
    I != I',
    agent_action(I',4,T).

% Update agent positions based on generated actions
agent_position(I,T+1,X2,Y2,O2) :- 
    agent_action(I,A,T),
    agent_position(I,T,X1,Y1,O1),
    cell(X1,Y1,C,OC),
    link(C,(O1-OC+4)\4,(O2-OC+4)\4,A),
    dir_diff(O2,XD,YD),
    X2 = X1+XD, Y2 = Y1+YD.

%:- agent_action(_,_,T), step_limit(TL), T>TL.

% Two agents cannot go onto the same connection heading in opposing directions at the same time
%:- chosen_connection(_,X1,Y1,O1,T,X2,Y2,O2,_), chosen_connection(_,X2,Y2,(O2+2)\4,T1,X1,Y1,(O1+2)\4,T2), T1 <= T <= T2.

% Two agents cannot occupy the same cell simultaneously
:- agent_position(I,T,X,Y,_), agent_position(I',T,X,Y,_), I != I'.

%#show junction/2.
%#show path/7.
%#show connection/7.
%#show agent_position/5.
%#show chosen_connection/9.
#show agent_action/3.