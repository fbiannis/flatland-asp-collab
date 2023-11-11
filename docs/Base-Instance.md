The base instance aims to provide all basic ASP literals necessary to test various types of encodings.
Since the main idea of Flatland is to have **agents** choose **actions**, based on the **cell** they are on, to get from a starting location to a **target** location, the base instance will implement a 1-to-1 representation of these foundation elements of Flatland.

<details>
<summary>Table of Contents</summary>

1. [Cells](#cells)
1. [Possible Actions](#possible-actions)
1. [Agents](#agents)
1. [Example Instance](#example-instance)

</details>

## Cells

Cells are the most basic building blocks of Flatland, the base instance represents them as:

```
cell(X,Y,C,O).
```

- X - X-Coordinate
- Y - Y-Coordinate of the cell
- C - Cell Type represented as an integer
- O - Orientation (N=0, E=1, S=2, W=3)

<details>
<summary>Example</summary>

```
cell(3,2,1,2).
```

Represents a cell at position (3,2) (or (2,3) in Flatland) which is a straight rail (1) oriented south (2)

</details>

## Possible Actions

At each decision step the agent has to pick an action from their action space. This action space is defined by the cell type, cell orientation and orientation of the agent. Also each action may or may not result in a change in the agent's orientation. To make this information readily available it is condensed in one literal, that has to be present for **each action**, **cell type** and **agent orientation**.

```
possible_action(C,Oa,A,OC).
```

- C - Cell Type represented as an integer
- O - Orientation of the **agent**
- A - Action to be performed
- OC - Orientation change induced by the action

<details>
<summary>Example</summary>

```
possible_action(1,1,4,0).
```

Represents the halting (4) action an eastward (1) oriented agent on a straight track (1) can choose, which does not change the orientation (0).

</details>

## Agents

Agents represent trains which have the task to get from their starting position to a target station. To convey this idea agents in FlatlandASP are represented by two literals, the **agent** (which describes the **starting** properties of the agent) and the **agent_target**.

```
agent(I,X,Y,O,D).
```

- I - identifier (handle number)
- X - X-Coordinate
- Y - Y-Coordinate
- O - Orientation (N=0, E=1, S=2, W=3)
- D - Earliest departure (time step)

```
agent_target(I,X,Y).
```

- I - identifier of the **agent**
- X - X-Coordinate
- Y - Y-Coordinate
<details>
<summary>Example</summary>

```
agent(0,2,3,2,0).
agent_target(0,5,2).
```

Represents an agent with Id 0, at position (2,3) (or (3,2) in Flatland) oriented south (2). The agent may depart immediately (D=0) and has to reach the train station at location (5,2).

</details>

# Example Instance

Given the following grid of a Flatland environment:

<p align="center">
<img width="400" height="240" src="https://i.ibb.co/SVKRL9F/image.png">
</p>

The first row contains an **empty** cell, followed by a **right turn** and ends with a **dead end** orientated **eastwards**.
The second row contains a **westward orientated dead end**, followed by an **eastward orientated simple switch** and ends with a **dead end** orientated **eastwards** as well.

There are also two stations, one at (0,1) and one at (2,1), either of these could be taken as a start or target point.

The following shows a Base Instance (without headers) of the problem

```
cell(1,0,9,3).
cell(2,0,7,1).
cell(0,1,7,3).
cell(1,1,2,1).
cell(2,1,7,1).

agent(0,2,1,1,0).
agent(1,0,1,3,0).
agent_target(0,0,1).
agent_target(1,2,1).

possible_action(9,0,4,0).
possible_action(9,0,2,3).
possible_action(9,1,4,0).
possible_action(9,1,2,1).
possible_action(9,2,4,0).
possible_action(9,3,4,0).
possible_action(2,0,4,0).
possible_action(2,0,2,0).
possible_action(2,0,1,3).
possible_action(2,1,4,0).
possible_action(2,1,2,1).
possible_action(2,2,4,0).
possible_action(2,2,2,0).
possible_action(2,3,4,0).
possible_action(7,0,4,0).
possible_action(7,0,2,2).
possible_action(7,1,4,0).
possible_action(7,2,4,0).
possible_action(7,3,4,0).
```
