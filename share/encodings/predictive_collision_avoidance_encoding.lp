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

% Build paths between junctions. 
% First start with straight lines and curves.

path(X1,Y1,X2,Y2,1) :- cell(X1,Y1,1,O), X2=X1+(O\2), Y2=Y1+((O+1)\2), not junction(X2,Y2), not path(X2,Y2,X1,Y1,_).
path(X1,Y1,X2,Y2,1) :- cell(X1,Y1,1,O), X2=X1-(O\2), Y2=Y1-((O+1)\2), not junction(X2,Y2), not path(X2,Y2,X1,Y1,_).
path(X1,Y1,X2,Y2,1) :- cell(X1,Y1,8,O), X2=X1+((1-O)\2), Y2=Y1+((2-O)\2), not junction(X2,Y2), not path(X2,Y2,X1,Y1,_).
path(X1,Y1,X2,Y2,1) :- cell(X1,Y1,8,O), X2=X1+((-2+O)\2), Y2=Y1+((1-O)\2), not junction(X2,Y2), not path(X2,Y2,X1,Y1,_).

% Recursively extend paths, while removing duplicates.

path(X1,Y1,X2,Y2,LN) :- path(X1,Y1,X',Y',L1), path(X',Y',X2,Y2,L2), LN=L1+L2, #sum{1:X1!=X2; 1:Y1!=Y2}>=1, not path(X1,Y1,X2,Y2,_), not path(X2,Y2,X1,Y1,_).
path(X1,Y1,X2,Y2,LN) :- path(X1,Y1,X',Y',L1), path(X2,Y2,X',Y',L2), LN=L1+L2, #sum{1:X1!=X2; 1:Y1!=Y2}>=1, not path(X1,Y1,X2,Y2,_), not path(X2,Y2,X1,Y1,_).
path(X1,Y1,X2,Y2,LN) :- path(X',Y',X1,Y1,L1), path(X',Y',X2,Y2,L2), LN=L1+L2, #sum{1:X1!=X2; 1:Y1!=Y2}>=1, not path(X1,Y1,X2,Y2,_), not path(X2,Y2,X1,Y1,_).
% :- path(X1,Y1,X2,Y2), path(X2,Y2,X1,Y1), #sum{1:X1!=X2; 1:Y1!=Y2}>=1.

% Update orientations according to action taken and current orientation
agent_orientation(I,O,T+1) :- agent_action(I,A,T,OC), agent_orientation(I,O',T), O=(O'+OC)\4.

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