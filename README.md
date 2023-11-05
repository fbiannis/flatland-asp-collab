# Flatland ASP Collab

## About

This Project is a collaborative effort to apply Answer Set Programming techniques to the [Flatland](https://github.com/flatland-association/flatland-rl) environment using python enhanced [Clingo](https://potassco.org/clingo/).

More precisely Flatland will be used to generate the 2D environments as well as simulate the solutions, while Clingo is used for grounding and solving the specific ASP instances and encodings. Python acts as an interface to generate ASP instances from Flatland environments and to provide Flatland with solution candidates generated by Clingo.

## General Project Structure

- `asp/` currently contains written as well as generated ASP code
  - `asp/encodings/` hand written ASP encodings
  - `asp/instances/` generated ASP instances
- `examples/` examples for Flatland and ASP (Clingo)
- `src/flatlandasp` main source code of the project
  - `src/flatlandasp/core/flatland` Flatland related classes, schemas, mappings, static maps, etc.
  - `src/flatlandasp/core/asp` ASP/Clingo related instance descriptions, generators, etc.
  - `src/flatlandasp/core/utils` utility functions for files, images, etc.

### Sources

(The base for this project is (for now) provided by [Flatland ASP](https://github.com/VictosVertex/flatland-asp))
