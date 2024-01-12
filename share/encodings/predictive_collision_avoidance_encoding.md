# General Encoding Info

The cardinal directions are represented with:  
`0` - North  
`1` - East  
`2` - South  
`3` - West  

For this encoding to work the map needs to be '**complete**' - that is to say - cannot have any cell lead into an empty cell!

# Agents

**Agents** are represented with multiple terms:  
## `agent(I,X,Y,O,D)` 

Generic term, created for every agent during instantiation of the flatland environment. There exists only one per agent, as it is not dependent on time.  
`I` - Unique agent ID  
`X` - Agent X position  
`Y` - Agent Y position  
`O` - Initial agent orientation  
`D` - The earliest departure of the agent

## `agent_position(I,X,Y,T)`

Time-dependent term giving position `X` & `Y` of agent `I` at time point `T`.  
*Derived* from `agent(I,X,Y,O,D)`.

## `agent_orientation(I,O,T)`

Time-dependent term giving orientation `O` of agent `I` at time point `T`.  
*Derived* from `agent(I,X,Y,O,D)`.

## `agent_done(I,T)`

Time-dependent term, that states wheter or not agent `I` has reached its target.  
An acceptable model is one, in which this is true for all agents.

# Actions

There are two terms concerning **actions** in the encoding:

## Possible Actions

There are **5** possible actions:  
`0` - No-Op/ Continue the previous action  
`1` - Turn left  
`2` - Go forward  
`3` - Turn right  
`4` - Halt  

## `possible_action(C,O,A,OC)`

Generic fact that states what actions an *agent* can take given:  
`C` - A cell type  
`O` - Orientation of the agent  
`A` - The type of action the agent can take  
`OC` - The orientation change experienced by the agent when taking action `A`

## `agent_action(I,A,T,OC)`

Term generated during the grounding and used during the solving process that states an agent `I`'s action `A` on time step `T` alongside the resulting orientation change `OC`.

# Collision Handling

The encoding handles the two cases of collisions:

**Head-on collision** - in which two agents swap places, driving 'through' one-another.

**Cell-occupany collsion** - in which two agents attempt to share the same cell.

# Predictive Collision Avoidance

In order to improve performance and prune searches into models destined to fail we introduce the idea of **predictive collision avoidance** by means of **junctions**, **paths** and **connections**.

## `junction(X,Y)`

A **junction** is any cell at position `X` and `Y`, that is *not* either an *empty cell*, *straight track* or *curved track*.  
Namely, any cell in which either a decision can be made *beyond* halting and going forward, or where mutltiple paths of the railway network intersect.

## `path(X1,Y1,X2,Y2)`

A **path** is a pair of coordinates (`X1,Y1` and `X2,Y2`) connected by tracks. They lie between *junctions*, never including them.  
**Paths** are iteratively constructed and are used to generate *connections*.

## `connection(X1,Y1,X2,Y2)`

**Connections** are the unique *paths* between junctions directly neigboring one another by *paths*.  
They are represented by the two coordinates one cell ahead of their enclosing junctions at either end (`X1,Y1` and `X2,Y2` respectively).  
There *cannot* be any junctions on the path of a connection.

## `connection_occupancy(X1,Y1,X2,Y2,T,I,D)`

The `connection_occupany` term states that an agent with the ID `I` is currently occupying a connection going from `X1,Y1` to `X2,Y2` at time point `T`.  
It also states which direction the agent is going along the connection with `D`, taking either one of two values:  
`0` - The agent is traveling 'down' from `X1,Y1` to `X2,Y2`  
`1` - The agent is traveling 'up' from `X2,Y2` to `X1,Y1`

We can directly discard any models that have two agents traveling opposite directions on the same *connection* at the same time!