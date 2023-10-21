-- Walk around with the arrow keys. Press the UP arrow to jump!
--
-- Learn more about the playground here:
--   https://package.elm-lang.org/packages/evancz/elm-playground/latest/
--


module Main exposing (..)

import Playground exposing (..)

import Grid exposing (..)
import Model exposing (..)
import View exposing (view_game)
import Update exposing (update_game)


-- MAIN

make_game : Game
make_game =
    let
        innert_keys = { counting = False, counter = 0}
        meta = {innert_keys = innert_keys}
        config = {s = 50, n = 8, debug = False}
        player = {position={up=4, down=-4}}
        board = {player = player, shots = []}
        game = { config = config, meta = meta, board = board}
    in
    game

main =
    game view_game update_game make_game
