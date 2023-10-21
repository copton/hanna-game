module Update exposing (update_game)

import Playground exposing (..)
import Set

import Model exposing (..)
import Grid exposing (..)

innert_key_pressing : Computer -> InnertKeys -> ( InnertKeys, Bool )
innert_key_pressing computer state =
    let
        is_pressed =
            not (Set.isEmpty computer.keyboard.keys)
    in
    case ( is_pressed, state.counting ) of
        ( False, False ) ->
            ( state, False )

        ( False, True ) ->
            ( { counting = False, counter = 0 }, False )

        ( True, False ) ->
            ( { counting = True, counter = 0 }, True )

        ( True, True ) ->
            if state.counter < 10 then
                ( { counting = True, counter = state.counter + 1 }, False )

            else
                ( { counting = True, counter = 0 }, True )


keyToAction : Set.Set String -> Maybe Action
keyToAction keys =
    let
        go key dir = case dir of
            (Just _) -> dir
            Nothing -> case key of
                "r" -> Just (Move TopRight)
                "f" -> Just (Move Right)
                "c" -> Just (Move BottomRight)
                "x" -> Just (Move BottomLeft)
                "d" -> Just (Move Left)
                "e" -> Just (Move TopLeft)
                "t" -> Just (Shoot TopRight)
                "g" -> Just (Shoot Right)
                "v" -> Just (Shoot BottomRight)
                "z" -> Just (Shoot BottomLeft)
                "s" -> Just (Shoot Left)
                "w" -> Just (Shoot TopLeft)
                _ -> Nothing
    in
        Set.foldl go Nothing keys

movePlayer : Config -> Direction -> Player -> Player
movePlayer config dir player =
    let pos = moveOnGrid dir player.position in
    if partOfHex config pos then
        {player | position = pos}
    else
        player

moveShot : Config -> Shot -> Maybe Shot
moveShot config shot =
    let pos = moveOnGrid shot.direction shot.position  in
    if partOfHex config pos then
        Just {shot | position = pos}
    else
        Nothing

moveShots : Config -> List Shot -> List Shot
moveShots config = List.filterMap (moveShot config)

newShot : GridPosition -> Direction -> Shot
newShot pos dir = {position = pos, direction = dir}

update_game : Computer -> Game -> Game
update_game computer game =
    let
        ( new_innert_keys, key_down ) =
            innert_key_pressing computer game.meta.innert_keys

        new_meta =
            { innert_keys = new_innert_keys }

        player_action =
            if key_down then
                keyToAction computer.keyboard.keys
            else
                Nothing

        new_player = case player_action of
            Just (Move dir) ->
                movePlayer game.config dir game.board.player
            _ -> game.board.player

        new_shots = moveShots game.config game.board.shots

        with_additional_shot = case player_action of
            Just (Shoot dir) ->
                newShot game.board.player.position dir :: new_shots
            _ -> new_shots

        new_board = {player = new_player, shots = with_additional_shot}

        new_game =
            { config = game.config, meta = new_meta , board = new_board}
    in
    new_game