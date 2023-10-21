module Grid exposing (moveOnGrid, across, partOfHex, theGrid, onScreen)

import Model exposing (..)

moveOnGrid : Direction -> GridPosition -> GridPosition
moveOnGrid dir pos =
    let
        (delta_up, delta_down) =
            case dir of
                TopRight -> (0, 1)
                Right -> (1, 1)
                BottomRight -> (1, 0)
                BottomLeft -> (0, -1)
                Left -> (-1, -1)
                TopLeft -> (-1, 0)
    in
        {up = pos.up + delta_up, down = pos.down + delta_down}

across : GridPosition -> Int
across position =
    position.down - position.up

partOfHex : Config -> GridPosition -> Bool
partOfHex config pos =
    let test x = abs x <= config.n in
    List.all test [pos.up, pos.down, across pos]


theGrid : Config -> List GridPosition
theGrid config =
    let
        ups = List.range (-1 * config.n) config.n
        downs = List.range (-1 * config.n) config.n

        mkPos up down = {up = up, down = down}
    in
        List.filter (partOfHex config) (crossProduct mkPos ups downs)

onScreen : Config -> GridPosition -> ScreenPosition
onScreen config pos =
    let
        x = 0.5 * config.s * toFloat (pos.up + pos.down)

        a = 0.9 * config.s
        y = a * toFloat (across pos)
    in
        {x=x, y=y}


crossProduct : (a -> b -> c) -> List a -> List b -> List c
crossProduct f xs ys =
    let
        go x rs = List.foldr (go2 x) rs ys

        go2 x y rs = f x y :: rs

    in
        List.foldr go [] xs