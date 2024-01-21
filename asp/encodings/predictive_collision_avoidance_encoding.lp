
%cell(1,0,9,3).
%cell(2,0,7,1).
%cell(0,1,7,3).
%cell(1,1,2,1).
%cell(2,1,7,1).
%
%
%agent(0,0,1,3,0).
%agent(1,2,1,1,0).
%agent_target(0,2,1).
%agent_target(1,0,1).
%step_limit(20).

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

% Initialize agents on their junctions
chosen_connection(I,-1,-1,O,0,X,Y,O,0) :- agent(I,X,Y,O,_).

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
    wait(I,T',T),
    chosen_connection(I,_,_,_,_,X1,Y1,OA,T'), 
    not agent_done(I,T),
    step_limit(TL), T<TL.

% Create waiting connections up until the time horizon
1{wait(I,T1,T2):T2=T1..S}1 :- chosen_connection(I,_,_,_,_,X,Y,_,T1), step_limit(S).

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
    chosen_connection(I,_,_,_,_,X,Y,OA,T),
    chosen_connection(I,X,Y,O,T,_,_,_,_),
    cell(X,Y,C,OC),
    link(C,(OA-OC+4)\4,(O-OC+4)\4,A).
% Between junctions:
agent_action(I,2,T) :-
    chosen_connection(I,X1,Y1,O1,T1,X2,Y2,O2,T2),
    T2-T1 >= 1,
    T=(T1+1)..(T2-2).
% For waiting:
agent_action(I,4,T) :-
    wait(I,T1,T2),
    T2-T1 >= 1,
    T=(T1-1)..(T2-1),
    T>=0.
agent_action(I,2,T-1) :-
    wait(I,_,T),
    T>=0.

% Two agents cannot go onto the same connection heading in opposing directions at the same time
:- chosen_connection(I,X1,Y1,O1,T,X2,Y2,O2,_), chosen_connection(_,X2,Y2,(O2+2)\4,T1,X1,Y1,(O1+2)\4,T2), T1 <= T <= T2.

% Two agents cannot exit their connections onto the junction at the same time
:- chosen_connection(I1,_,_,_,_,X,Y,_,T1..T2), chosen_connection(I2,_,_,_,_,X,Y,_,T1..T2), I1 != I2, wait(I1,T1,T2).

%showing the amount of agents (A) on a connection (X1,Y1,O1,X2,Y2,O2,L) at each timestep (T) (idea not working/needs improvement)
%queue(A,X1,Y1,O1,X2,Y2,O2,L,T) :- 

%wait on the last cell, if a connection got delayed and continue after waiting
%agent_action(I,4,T..T'), agent_action(I,2,T'+1) :-
%    chosen_connection(I,X1,Y1,O1,T1,X2,Y2,O2,T2),
%    chosen_connection(I,X3,Y3,O3,T3,X4,Y4,O4,_),
%    chosen_connection(I,X3,Y3,O3,T4,X4,Y4,O4,_),
%    T3=T2+1,
%    T3<T4,
%    T' = T+T4-T3,
%    T=T2-1.

%#minimize { 1, I, A, T : agent_action(I, A, T) }.
%#minimize { T2 - T1, I, T1, T2 : wait(I, T1, T2) }.

%#show junction/2.
%#show path/7.
%#show connection/7.
#show wait/3. 
#show chosen_connection/9.
#show agent_action/3.