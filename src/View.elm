module View exposing (view_game)

import Playground exposing (..)
import Debug exposing (toString)

import Model exposing (..)
import Grid exposing (..)

moveTo : Config -> GridPosition -> Shape -> Shape
moveTo config gridPos shape =
    let screenPos = onScreen config gridPos in
    shape |> moveX screenPos.x |> moveY screenPos.y

view_game : Computer -> Game -> List Shape
view_game computer game =
    let
        grid = view_grid game.config
        player = view_player game.config game.board.player
        shots = view_shots game.config game.board.shots
    in
        grid ++ player ++ shots

view_shots : Config -> List Shot -> List Shape
view_shots config = List.concatMap (view_shot config)

view_shot : Config -> Shot -> List Shape
view_shot config shot =
    let shot_shape = moveTo config shot.position (circle red 2) in
    [shot_shape]

view_player : Config -> Player -> List Shape
view_player config player =
    let
        s = 0.9 * config.s
        player_shape = moveTo config player.position (image s s "../res/unicorn.jpeg")
    in
    [player_shape]

view_grid : Config -> List Shape
view_grid config =
    let
        grid = theGrid config
        mkDot pos = moveTo config pos (circle black 2)

        mkLabel pos =
            let
                label = (toString pos.up) ++ "," ++ (toString pos.down) ++ "," ++ (toString (across pos))
            in
                moveTo config pos (words black label)

        mkHex pos = moveTo config pos (hexagon black ((config.s * 0.5) - 1.0))

        dots = List.map mkDot grid

        labels =
            if config.debug then List.map mkLabel grid else []

        hexes = List.map mkHex grid

    in
        dots ++ hexes ++ labels