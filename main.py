
import msvcrt
from clingo.control import Control
from flatland.envs.line_generators import sparse_line_generator
from flatland.envs.observations import GlobalObsForRailEnv
from flatland.envs.rail_generators import rail_from_grid_transition_map
from flatland.utils.rendertools import AgentRenderVariant, RenderTool
from flatland.envs.rail_env import RailEnv
from flatland.envs.persistence import RailEnvPersister

from flatlandasp.core.flatland.static_maps import (multi_passing_siding_map,
                                                   passing_siding_map,
                                                   straight_map,
                                                   impossible_loop,
                                                   long_multiple_switch_map)
from flatlandasp.flatland_asp import FlatlandASP


def create_environment() -> RailEnv:
    # grid_transition_map, optionals = straight_map(
    #    length=5, padding=3)
    grid_transition_map, optionals = impossible_loop()
    env = RailEnv(width=grid_transition_map.grid.shape[1],
                  height=grid_transition_map.grid.shape[0],
                  rail_generator=rail_from_grid_transition_map(
                      grid_transition_map, optionals),
                  line_generator=sparse_line_generator(),
                  number_of_agents=1,
                  obs_builder_object=GlobalObsForRailEnv()
                  )

    return env

def hold_window_for_input(env_renderer):
    print("Press any button in the terminal to exit")
    while True:
        env_renderer.render_env(show=True, show_predictions=True, show_rowcols=True)
        if msvcrt.kbhit():
            break

if __name__ == '__main__':
    env = create_environment()
    env_renderer = RenderTool(
        env, agent_render_variant=AgentRenderVariant.AGENT_SHOWS_OPTIONS)
    ctl = Control()
    env.reset()
    RailEnvPersister.save(env=env,filename="temp.pkl")

    fa = FlatlandASP(env=env, env_renderer=env_renderer, clingo_control=ctl)
    fa.solve()
    fa.simulate_environment()
    hold_window_for_input(env_renderer)