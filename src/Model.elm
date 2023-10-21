module Model exposing (..)

import Playground exposing (Number)

type alias Config  =
    { s : Number
    , n : Int
    , debug: Bool
    }


type alias InnertKeys =
    { counting : Bool
    , counter : Int
    }

type alias Meta =
    { innert_keys : InnertKeys
    }

type alias Player =
    { position: GridPosition
    }

type alias Shot =
    { position: GridPosition
    , direction: Direction
    }

type alias Board =
    { player: Player
    , shots: List Shot
    }

type alias Game =
    { config : Config
    , meta : Meta
    , board: Board
    }

type alias GridPosition =
    { up : Int
    , down : Int
    }

type Direction
    = TopRight
    | Right
    | BottomRight
    | BottomLeft
    | Left
    | TopLeft

type alias ScreenPosition =
    { x : Number
    , y : Number
    }

type Action
    = Move Direction
    | Shoot Direction
