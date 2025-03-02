Tile = {
    snow = 1,
    grass = 2,
    tree = 3,
    hole = 4,
    rock = 5,
    ice = 6,
    carrot = 7,
    scarf = 8,
    coal = 9,
    hole_filled = 10,
    player_start = 11
}

Command = {
    nothing = 1,
    move = 2,
    make = 3
}

Bearing = {
    north = 1,
    east = 2,
    south = 3,
    west = 4
}

BearingVectors = {
    [Bearing.north] = { 0, -1 },
    [Bearing.south] = { 0, 1 },
    [Bearing.east] = { 1, 0 },
    [Bearing.west] = { -1, 0 },
}