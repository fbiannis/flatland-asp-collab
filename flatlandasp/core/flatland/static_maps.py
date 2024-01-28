from typing import Any, Tuple

import numpy as np
from flatland.core.grid.rail_env_grid import RailEnvTransitions
from flatland.core.transition_map import GridTransitionMap

from flatlandasp.core.flatland.schemas.cell_type import CellType


def straight_map(*, length: int, padding: int) -> Tuple[GridTransitionMap, dict[str, dict[str, Any]]]:
    transitions = RailEnvTransitions()
    cell_types = transitions.transition_list
    empty = cell_types[0]
    sn_straight = cell_types[1]
    we_straight = transitions.rotate_transition(sn_straight, 90)
    s_dead_end = cell_types[CellType.DEAD_END.value]
    w_dead_end = transitions.rotate_transition(s_dead_end, 90)
    e_dead_end = transitions.rotate_transition(s_dead_end, 270)
    length = max(length, 2)
    length -= 2

    grid = np.array(
        [[empty] * (2+length+2*padding)]*padding +
        [[empty]*padding + [e_dead_end] + [we_straight] * length + [w_dead_end] + [empty]*padding] +
        [[empty] * (2+length+2*padding)]*padding
    )

    print(grid)

    grid_transition_map = GridTransitionMap(width=grid.shape[1],
                                            height=grid.shape[0],
                                            transitions=transitions)
    grid_transition_map.grid = grid

    city_positions = [(padding, padding), (padding, padding+length-1)]

    city_orientations = [1, 3]

    train_stations = [[((padding, padding), 0)],
                      [((padding, padding+length+1), 0)]]

    agents_hints = {'city_positions': city_positions,
                    'train_stations': train_stations,
                    'city_orientations': city_orientations
                    }

    optionals = {'agents_hints': agents_hints}

    print(optionals)
    return grid_transition_map, optionals


def example_basic_static_map() -> Tuple[GridTransitionMap, dict[str, dict[str, Any]]]:
    transitions = RailEnvTransitions()
    cell_types = transitions.transition_list
    empty = cell_types[0]

    sn_straight = cell_types[1]
    we_straight = transitions.rotate_transition(sn_straight, 90)
    se_turn = cell_types[8]
    ws_turn = transitions.rotate_transition(se_turn, 90)
    nw_turn = transitions.rotate_transition(ws_turn, 90)
    en_turn = transitions.rotate_transition(nw_turn, 90)

    number_of_straight_rails = 15

    grid = np.array(
        [[empty] * (4+number_of_straight_rails)] +
        [[empty] + [se_turn] + [we_straight] * number_of_straight_rails + [ws_turn] + [empty]] +
        [[empty] + [sn_straight] + [empty] * number_of_straight_rails + [sn_straight] + [empty]] * number_of_straight_rails +
        [[empty] + [en_turn] + [we_straight] * number_of_straight_rails + [nw_turn] + [empty]] +
        [[empty] * (4+number_of_straight_rails)], dtype=np.uint16
    )

    grid_transition_map = GridTransitionMap(width=grid.shape[1],
                                            height=grid.shape[0],
                                            transitions=transitions)
    grid_transition_map.grid = grid

    city_positions = [(1, 2), (number_of_straight_rails +
                               2, number_of_straight_rails+1)]

    city_orientations = [1, 3]

    train_stations = [
        [((1, 2), 0)],
        [((number_of_straight_rails +
           2, number_of_straight_rails+1), 0)],
    ]

    agents_hints = {'city_positions': city_positions,
                    'train_stations': train_stations,
                    'city_orientations': city_orientations
                    }

    optionals = {'agents_hints': agents_hints}
    print(optionals)
    return grid_transition_map, optionals


def passing_siding_map() -> Tuple[GridTransitionMap, dict[str, dict[str, Any]]]:
    transitions = RailEnvTransitions()
    cell_types = transitions.transition_list
    empty = cell_types[CellType.EMPTY.value]

    sn_straight = cell_types[CellType.STRAIGHT.value]
    we_straight = transitions.rotate_transition(sn_straight, 90)
    se_turn = cell_types[CellType.SIMPLE_TURN_RIGHT.value]
    ws_turn = transitions.rotate_transition(se_turn, 90)
    sw_simple_switch = cell_types[CellType.SIMPLE_SWITCH.value]
    en_simple_switch = transitions.rotate_transition(sw_simple_switch, 90)
    se_simple_switch = cell_types[CellType.SIMPLE_SWITCH_MIRRORED.value]
    wn_simple_switch = transitions.rotate_transition(se_simple_switch, 270)
    s_dead_end = cell_types[CellType.DEAD_END.value]
    w_dead_end = transitions.rotate_transition(s_dead_end, 90)
    e_dead_end = transitions.rotate_transition(s_dead_end, 270)

    grid = np.array(
        [[empty] * (14)] +
        [[empty]*5 + [se_turn] + [we_straight]*2 + [ws_turn] + [empty]*5] +
        [[empty] + [e_dead_end] + [we_straight]*3 + [en_simple_switch] +
            [we_straight]*2+[wn_simple_switch] + [we_straight]*3 + [w_dead_end]  + [empty]] +
        [[empty] * (14)], dtype=np.uint16
    )
    print(grid)
    grid_transition_map = GridTransitionMap(width=grid.shape[1],
                                            height=grid.shape[0],
                                            transitions=transitions)
    grid_transition_map.grid = grid

    city_positions = [(2, 1), (2, 12)]

    city_orientations = [1, 3]

    train_stations = [
        [((2, 1), 0)],
        [((2, 12), 0)],
    ]

    agents_hints = {'city_positions': city_positions,
                    'train_stations': train_stations,
                    'city_orientations': city_orientations
                    }

    optionals = {'agents_hints': agents_hints}
    return grid_transition_map, optionals


def multi_passing_siding_map() -> Tuple[GridTransitionMap, dict[str, dict[str, Any]]]:
    transitions = RailEnvTransitions()
    cell_types = transitions.transition_list
    empty = cell_types[CellType.EMPTY.value]

    sn_straight = cell_types[CellType.STRAIGHT.value]
    we_straight = transitions.rotate_transition(sn_straight, 90)
    sn_dead_end = cell_types[CellType.DEAD_END.value]
    we_dead_end = transitions.rotate_transition(sn_dead_end, 90)
    ew_dead_end = transitions.rotate_transition(sn_dead_end, 270)
    se_turn = cell_types[CellType.SIMPLE_TURN_RIGHT.value]
    ws_turn = transitions.rotate_transition(se_turn, 90)
    sw_simple_switch = cell_types[CellType.SIMPLE_SWITCH.value]
    en_simple_switch = transitions.rotate_transition(sw_simple_switch, 90)
    se_simple_switch = cell_types[CellType.SIMPLE_SWITCH_MIRRORED.value]
    wn_simple_switch = transitions.rotate_transition(se_simple_switch, 270)

    grid = np.array(
        [[empty] * (14)] +
        [[empty]*5 + [se_turn] + [we_straight]*2 + [ws_turn] + [empty]*5] +
        [[empty]*5 + [se_simple_switch] + [we_straight]*2 + [sw_simple_switch] + [empty]*5] +
        [[empty]*5 + [se_simple_switch] + [we_straight]*2 + [sw_simple_switch] + [empty]*5] +
        [[empty] + [ew_dead_end] + [we_straight]*3+[en_simple_switch] +
            [we_straight]*2+[wn_simple_switch] + [we_straight]*3 + [we_dead_end] + [empty]] +
        [[empty] * (14)], dtype=np.uint16
    )
    print(grid)
    grid_transition_map = GridTransitionMap(width=grid.shape[1],
                                            height=grid.shape[0],
                                            transitions=transitions)
    grid_transition_map.grid = grid

    city_positions = [(4, 1), (4, 12)]

    city_orientations = [1, 3]

    train_stations = [
        [((4, 1), 0)],
        [((4, 12), 0)],
    ]

    agents_hints = {'city_positions': city_positions,
                    'train_stations': train_stations,
                    'city_orientations': city_orientations
                    }

    optionals = {'agents_hints': agents_hints}
    return grid_transition_map, optionals


def simple_switch_map() -> Tuple[GridTransitionMap, dict[str, dict[str, Any]]]:
    transitions = RailEnvTransitions()
    cell_types = transitions.transition_list
    empty = cell_types[CellType.EMPTY.value]

    se_turn = cell_types[CellType.SIMPLE_TURN_RIGHT.value]
    sw_simple_switch = cell_types[CellType.SIMPLE_SWITCH.value]
    en_simple_switch = transitions.rotate_transition(sw_simple_switch, 90)
    sn_dead_end = cell_types[CellType.DEAD_END.value]
    we_dead_end = transitions.rotate_transition(sn_dead_end, 90)
    ew_dead_end = transitions.rotate_transition(sn_dead_end, 270)

    grid = np.array(
        [[empty] + [se_turn] + [we_dead_end]] +
        [[ew_dead_end] + [en_simple_switch] + [we_dead_end]], dtype=np.uint16
    )
    print(grid)
    grid_transition_map = GridTransitionMap(width=grid.shape[1],
                                            height=grid.shape[0],
                                            transitions=transitions)
    grid_transition_map.grid = grid

    city_positions = [(1, 0), (1, 2)]

    city_orientations = [1, 3]

    train_stations = [
        [((1, 0), 0)],
        [((1, 2), 0)],
    ]

    agents_hints = {'city_positions': city_positions,
                    'train_stations': train_stations,
                    'city_orientations': city_orientations
                    }

    optionals = {'agents_hints': agents_hints}
    return grid_transition_map, optionals


def impossible_loop() -> Tuple[GridTransitionMap, dict[str, dict[str, Any]]]:
    transitions = RailEnvTransitions()
    cell_types = transitions.transition_list
    empty = cell_types[CellType.EMPTY.value]

    se_turn = cell_types[CellType.SIMPLE_TURN_RIGHT.value]
    sw_simple_switch = cell_types[CellType.SIMPLE_SWITCH.value]
    sn_straight = cell_types[CellType.STRAIGHT.value]
    se_simple_switch_mirrored = cell_types[CellType.SIMPLE_SWITCH_MIRRORED.value]
    sn_dead_end = cell_types[CellType.DEAD_END.value]
    we_dead_end = transitions.rotate_transition(sn_dead_end, 90)
    en_turn = transitions.rotate_transition(se_turn, 270)
    ws_turn = transitions.rotate_transition(se_turn, 180)

    grid = np.array(
        [[empty] + [sn_dead_end] + [empty]] +
        [[se_turn] + [sw_simple_switch] + [empty]] +
        [[sn_straight] + [se_simple_switch_mirrored] + [we_dead_end]] +
        [[en_turn] + [ws_turn] + [empty]], dtype=np.uint16
    )
    print(grid)
    grid_transition_map = GridTransitionMap(width=grid.shape[1],
                                            height=grid.shape[0],
                                            transitions=transitions)
    grid_transition_map.grid = grid

    city_positions = [(0, 1), (2, 2)]

    city_orientations = [2, 3]

    train_stations = [
        [((0, 1), 0)],
        [((2, 2), 0)],
    ]

    agents_hints = {'city_positions': city_positions,
                    'train_stations': train_stations,
                    'city_orientations': city_orientations
                    }

    optionals = {'agents_hints': agents_hints}
    return grid_transition_map, optionals


def long_multiple_switch_map() -> Tuple[GridTransitionMap, dict[str, dict[str, Any]]]:
    transitions = RailEnvTransitions()
    cell_types = transitions.transition_list
    empty = cell_types[CellType.EMPTY.value]

    se_turn = cell_types[CellType.SIMPLE_TURN_RIGHT.value]
    sw_simple_switch = cell_types[CellType.SIMPLE_SWITCH.value]
    se_simple_switch = cell_types[CellType.SIMPLE_SWITCH_MIRRORED.value]
    s_dead_end = cell_types[CellType.DEAD_END.value]
    sn_straight = cell_types[CellType.STRAIGHT.value]
    
    wn_simple_switch = transitions.rotate_transition(sw_simple_switch, 90)
    en_simple_switch = transitions.rotate_transition(se_simple_switch, 270)
    es_simple_switch = transitions.rotate_transition(sw_simple_switch, 270)
    ws_simple_switch = transitions.rotate_transition(se_simple_switch, 90)
    w_dead_end = transitions.rotate_transition(s_dead_end, 90)
    e_dead_end = transitions.rotate_transition(s_dead_end, 270)

    grid = np.array(
        [[e_dead_end] + [es_simple_switch] + [ws_simple_switch] + [es_simple_switch] + [ws_simple_switch] + [es_simple_switch] + [ws_simple_switch] + [es_simple_switch] + [ws_simple_switch] + [es_simple_switch] + [ws_simple_switch] + [w_dead_end]] +
        [[empty] + [sn_straight] * 10 + [empty]] + 
        [[e_dead_end] + [en_simple_switch] + [wn_simple_switch] + [en_simple_switch] + [wn_simple_switch] + [en_simple_switch] + [wn_simple_switch] + [en_simple_switch] + [wn_simple_switch] + [en_simple_switch] + [wn_simple_switch] + [w_dead_end]], dtype=np.uint16
    )
    print(grid)
    grid_transition_map = GridTransitionMap(width=grid.shape[1],
                                            height=grid.shape[0],
                                            transitions=transitions)
    grid_transition_map.grid = grid

    city_positions = [(0, 0), (2, 0), (0, 11), (2, 11)]

    city_orientations = [1, 1, 3, 3]

    train_stations = [
        [((0, 0), 0)],
        [((2, 0), 0)],
        [((0, 11), 0)],
        [((2, 11), 0)],
    ]
    agents_hints = {'city_positions': city_positions,
                    'train_stations': train_stations,
                    'city_orientations': city_orientations
                    }

    optionals = {'agents_hints': agents_hints}
    return grid_transition_map, optionals

