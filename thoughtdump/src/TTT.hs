{-# LANGUAGE GADTs #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# OPTIONS_GHC -Wno-missing-deriving-strategies #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module TTT where

-----------------------------
-- The Inneficient solution
-----------------------------
data TickTackToeInneficient a where
    TickTackToeInneficient ::
        { tl :: a
        , tm :: a
        , tr :: a
        , ml :: a
        , mm :: a
        , mr :: a
        , bl :: a
        , bm :: a
        , br :: a
        } ->
        TickTackToeInneficient a

-- The inneficnet implemetnation
emptyBoardBAD :: TickTackToeInneficient (Maybe Bool)
emptyBoardBAD =
    TickTackToeInneficient
        Nothing
        Nothing
        Nothing
        Nothing
        Nothing
        Nothing
        Nothing
        Nothing
        Nothing

-- The better one
-- NOTE:: (Hermit) These are simple GADT, thing of rust generics, these are their inspiration
-- data Three = One | Two | Three deriving (Eq, Ord, Enum ,Bounded) -- (Intext)
data Three where
    One :: Three
    Two :: Three
    Three :: Three
    deriving (Eq, Ord, Bounded, Enum)

-- data TicTacToe a = TicTacToe2
--     {board :: Three -> Three -> a} -- (Intext)
data TicTacToe a where
    TicTacToe2 ::
        { board :: Three -> Three -> a
        } ->
        TicTacToe a

emptyBoard :: TicTacToe (Maybe Bool)
emptyBoard =
    TicTacToe2 $ const $ const Nothing
