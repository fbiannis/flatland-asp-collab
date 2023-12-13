% This is a basic variant of the naive encoding
% it is specifically for straight line maps, 
% so it only contains rules for straight tracks.
% I = Agent ID
% A = Action 
%   0 = No Action
%   1 = Left 
%   2 = Forward
%   3 = Right
%   4 = Stop
% X = X Coordinate
% Y = Y Coordinate
% O = Agent Orientation
% O' = Cell Orientation
% OC = Change in orientation of the agent after taking action A
% RO = Relative Cell Orientation (between Cell and Agent)
% T = Timestep
% C = Cell Type
% L = Step Limit
% Initial position of the agent
agent_position(I,X,Y,0):- agent(I,X,Y,_,_).
agent_orientation(I,O,0):- agent(I,_,_,O,_).

% At each time step the agent has to choose one
% action from all actions possible at the location
% of the agent given its orientation and cell type.
{agent_action(I,A,T,OC):possible_action(C,RO,A,OC)} = 1:-  agent_position(I,X,Y,T), 
                                                    agent_orientation(I,O,T), 
                                                    cell(X,Y,C,O'),
                                                    not agent_done(I,T),
                                                    step_limit(L),
                                                    RO=(|O-O'|)\4,
                                                    T<L.

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
% To find the outgoing direction for an incoming direction simply turn orientation by 2.

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
connection(X1,Y1,X2,Y2,O,L) :- path(X1,Y1,X2,Y2,O,L), not connection(X2,Y2,X1,Y1), junction(X2,Y2).

% Update orientations according to action taken and current orientation
agent_orientation(I,O,T+1) :- agent_action(I,A,T,OC), agent_orientation(I,O',T), O=(O'+OC)\4.

% Predict collisions
connection_occupany(X1,Y1,X2,Y2,T,I,0) :- connection(X1,Y1,X2,Y2), agent_position(I,X1,Y1,T).
connection_occupany(X1,Y1,X2,Y2,T,I,1) :- connection(X1,Y1,X2,Y2), agent_position(I,X2,Y2,T).

connection_occupany(X1,Y1,X2,Y2,T,I,D) :- connection_occupany(X1,Y1,X2,Y2,T-1,I,D), not agent_position(I,X2,Y2,T).

% Update positions
%
% If the halting action (4) is chosen
% then don't change any coordinates, simply advance the time step.
agent_position(I,X,Y,T+1) :- agent_action(I,4,T,OC), agent_position(I,X,Y,T).

% If any other action is chosen
% then move one step forward into orientation direction
% and advance time step
agent_position(I,X',Y',T+1) :-  agent_action(I,A,T,OC),
                                agent_orientation(I,O,T+1), 
                                agent_position(I,X,Y,T),
                                A != 4,
                                X'=X-(O - 2)* (O \ 2), 
                                Y'=Y+(O - 1)* ((O+1) \ 2).

% The agent is done as soon as they arrive at their target
agent_done(I,T) :- agent_position(I,X,Y,T), agent_target(I,X,Y).

% Every agent must be done.
:- not agent_done(I,_), agent(I,_,_,_,_). 

% Two different agents can not be at the same position
% at the same time
:-  agent_position(I,X,Y,T), 
    agent_position(I',X,Y,T), 
    I!=I', 
    agent_position(I,X',Y',0),
    (X-X')**2+(Y-Y')**2!=0.

% Two agents can not swap places
:-  agent_position(I,X,Y,T), 
    agent_position(I',X',Y',T), 
    agent_position(I,X',Y',T+1), 
    agent_position(I',X,Y,T+1),
    I != I'.

#show agent_action/4.
#show agent_position/4.
#show agent_orientation/3.
#show agent_target/3.
#show junction/2.
#show path/5.
#show connection/6.
#show connection_occupany/7.