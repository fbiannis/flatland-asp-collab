
import msvcrt
import time
from clingo.control import Control
from flatland.envs.line_generators import sparse_line_generator
from flatland.envs.observations import GlobalObsForRailEnv
from flatland.envs.rail_generators import rail_from_grid_transition_map
from flatland.utils.rendertools import AgentRenderVariant, RenderTool
from flatland.envs.rail_env import RailEnv
from flatland.envs.persistence import RailEnvPersister
import pandas as pd
import matplotlib as plt

from flatlandasp.core.flatland.static_maps import (multi_passing_siding_map,
                                                   passing_siding_map,
                                                   straight_map,
                                                   impossible_loop,
                                                   long_multiple_switch_map)

benchmarking = False

def plot_benchmark():
    data = pd.read_csv("bm_results.csv")
    df = pd.DataFrame(data)
    
    X = list(df.iloc[:, 0]) 
    Y = list(df.iloc[:, 1])

    plt.bar(X, Y, color='g') 
    plt.title("Predictive Collision Avoidance Encoding") 
    plt.xlabel("Maps") 
    plt.ylabel("Solving time") 
    
def create_environment(grid_transition_map, optionals) -> RailEnv:
    env = RailEnv(width=grid_transition_map.grid.shape[1],
                  height=grid_transition_map.grid.shape[0],
                  rail_generator=rail_from_grid_transition_map(
                      grid_transition_map, optionals),
                  line_generator=sparse_line_generator(),
                  number_of_agents=1,
                  obs_builder_object=GlobalObsForRailEnv()
                  )

    return env


if __name__ == '__main__':
    from flatlandasp.flatland_asp import FlatlandASP
    with open("bm_results.csv", 'a') as f:
        f.write("map_name,solving_time\n")
    f.close
    benchmarking = True
    maps = []
    
    grid_transition_map, optionals = multi_passing_siding_map()
    maps.append([grid_transition_map, optionals, "multi_passing_siding_map"])
    grid_transition_map, optionals = passing_siding_map()
    maps.append([grid_transition_map, optionals, "passing_siding_map"])
    grid_transition_map, optionals = straight_map(length=25, padding=3)
    maps.append([grid_transition_map, optionals, "straight_map"])
    grid_transition_map, optionals = impossible_loop()
    maps.append([grid_transition_map, optionals, "impossible_loop"])
    grid_transition_map, optionals = long_multiple_switch_map()
    maps.append([grid_transition_map, optionals, "long_multiple_switch_map"])
    
    for map in maps:
        env = create_environment(map[0],map[1])
        env_renderer = RenderTool(
            env, agent_render_variant=AgentRenderVariant.AGENT_SHOWS_OPTIONS)
        ctl = Control()
        env.reset()
        fa = FlatlandASP(env=env, env_renderer=env_renderer, clingo_control=ctl)
        with open("bm_results.csv", 'a') as f:
            f.write("{},".format(map[2]))
        f.close
        fa.solve()
    
    plot_benchmark()

def benchmark_solve(flatlandASP):
    if benchmarking:
        #solve 100 times and take the average time
        solvetimes = []
        for i in range(100):
            # Ground the program
            starttime = time.time()
            flatlandASP.clingo_control.solve(
                    on_model=lambda x: flatlandASP._on_clingo_model(x))
            endtime = time.time()
            solvetimes.append(endtime-starttime)

        avg = sum(solvetimes)/len(solvetimes)

        with open("bm_results.csv", 'a') as f:
            f.write("{}\n".format(avg))
        f.close
    else:
        flatlandASP.clingo_control.solve(
            on_model=lambda x: flatlandASP._on_clingo_model(x))
        
