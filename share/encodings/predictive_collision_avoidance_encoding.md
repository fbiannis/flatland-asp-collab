# General Encoding Info

The cardinal directions are represented with:  
`0` - North  
`1` - East  
`2` - South  
`3` - West  

For this encoding to work the map needs to be '**complete**' - that is to say - cannot have any cell lead into an empty cell!

# Helping predicates

As part of our encoding we use multiple generic helper predicates. These get used at multiple points within the encoding to make work with it easier.

## `dir_diff(O,XD,YD)`
This predicate translates a movement into one of the four directions into its corresponding change in X and why coordinate, given by  
`XD` - X Difference and  
`YD` - Y Difference.

<details>
<summary>In code</summary>

```
dir_diff(0, 0, -1).
dir_diff(1, 1, 0). 
dir_diff(2, 0, 1). 
dir_diff(3, -1, 0).
``` 
</details>

## `link(C,OI,OO,A)`
This predicate gives the change in direction an agent experiences when taking a certain action within a given cell type.  
`C` - The cell type  
`OI` - The orientation upon entering (Orientation IN)  
`OO` - The orientation upon exiting (Orientation OUT)    
`A` - The action being taken

The orientations are provided for the cell at its unrotated state. Should the cell in question be rotated, it would have to be normalized to its b

<details>
<summary>Example</summary>

```
agent(0,12,2,1,0).
```
The agent with ID `0` starts at position `(12,2)` and starts facing east (Orientation `1`).  
The earliest departure is at time step `0`.
</details>

# Agents

These are the predicates directly concerned with **Agents**:  
## `agent(I,X,Y,O,D)` 

Generic term, created for every agent during instantiation of the flatland environment. There exists only one per agent, as it is not dependent on time. 
`I` - Unique agent ID  
`X` - Agent X position  
`Y` - Agent Y position  
`O` - Initial agent orientation  
`D` - The earliest departure of the agent

<details>
<summary>Example</summary>

```
agent(0,12,2,1,0).
```
The agent with ID `0` starts at position `(12,2)` and starts facing east (Orientation `1`).  
The earliest departure is at time step `0`.
</details>

## `agent_done(I,T)`

Time-dependent term, that states, that agent `I` has reached its target at time step `T`.  
An acceptable model is one, in which this is true for all agents.

<details>
<summary>In code</summary>

```
:- not agent_done(I,_), agent(I,_,_,_,_).
```
This is the integrity constraint, to exclude models that have agents which have not arrived. 
</details>

# Actions

## Possible Actions

There are **5** possible actions:  
`0` - No-Op/ Continue the previous action  
`1` - Turn left  
`2` - Go forward  
`3` - Turn right  
`4` - Halt  

## `agent_action(I,A,T)`

Term generated based on the agents' chosen connections.  
It states an agent `I` has taken action `A` on time step `T`.

<details>
<summary>Example</summary>

```
agent_action(0,2,0).
agent_action(0,2,1).
agent_action(0,3,2).
```
The first three actions of agent `0`:  
Go forward twice and then take a right turn.
</details>

# Collision Handling

The encoding handles the two cases of collisions:

**Head-on collision** - in which two agents swap places, driving 'through' one-another. 

**Cell-occupany collsion** - in which two agents attempt to share the same cell.

Both of these collision types are handled by our approach of predictive collision avoidance.

# Predictive Collision Avoidance

In order to improve performance and prune searches into models destined to fail we introduce the idea of **predictive collision avoidance** by means of **junctions**, **paths** and **connections**.  
With this we aim to make finding a model faster and to simply experiment with a different approach to the problem. 

## `junction(X,Y)`

A **junction** is any cell at position `X` and `Y`, that is *not* either an *empty cell*, *straight track* or *curved track*.  
Namely, any cell in which either a decision can be made *beyond* halting and going forward, or where mutltiple paths of the railway network intersect.  
The exceptions here dead ends and agent/station starting positions, which are also counted as junctions in spite of only allowing for going forward or halting. 

## `path(X1,Y1,O1,X2,Y2,O2,L)`

A **path** is a pair of coordinates (`X1,Y1` and `X2,Y2`) connected by tracks.  
The orientations `O1` and `O2` are the orientations the agent would be going in when going out of `X1,Y1` or into `X2,Y2` respectively. They are included to make pathfinding easier and to distinguish between two different connections connecting the same junctions.  

Every **path** originates from a *junction*.  
Going out from that junction, they are iteratively constructed until they reach another junction, at which point they become a *connection*.

`L` gives the length of the **path**.

## `connection(X1,Y1,O1,X2,Y2,O2,L)`

**Connections** are the unique *paths* between junctions only made up out of straight lines and curves and a *junction* at each end.  
They are represented by the two coordinates one cell ahead of their enclosing junctions at either end (`X1,Y1` and `X2,Y2` respectively).  

The orientations `O1`, `O2` and the length parameter `L` work the same way they do on the *path* predicate.

For every connection going from `X1,Y1` to `X2,Y2` there is another one going back the same connection in the opposite direction (from `X2,Y2` to `X1,Y1`).

<details>
<summary>In code</summary>

```
:- chosen_connection(I,X1,Y1,O1,T,X2,Y2,O2,T'), chosen_connection(_,X2,Y2,(O2+2)\4,T1,X1,Y1,(O1+2)\4,T2), T1 <= T <= T2.
```
With this integrity constraint we discard any models that have two agents traveling opposite directions on the same connection at the same time!
</details>

