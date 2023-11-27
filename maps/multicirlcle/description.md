**Multicircle** test maps are a set of flatland environments.

## Design

<img height="200px" src="https://i.ibb.co/zSSDP4n/multicircle.png">

The map is **dynamic** (can have multiple versions) and can have between 1 and 4 agent per version.

The number in front of the **`xMulticirlce.pkl`** indicates how many 2x3 circle units the environment contains.

### Info:

**Green circles** indicate possible starting or ending points within the environment. Some starting points can possibly serve also as ending points, depending on the number of agents.

## Testing

The environment serves the purposes of testing how **ASP** implementations handle *performance*, especially in view of optimzing search through many possible models.