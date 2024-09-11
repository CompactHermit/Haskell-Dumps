-- TODO:: TO GHC OPTION
{-# LANGUAGE GADTs #-}

{- Chapter 1 Example Problems-}
module ExcercisesUn where

-- From Sandy Maguire "Thinking with types"

-- 1.4.1 find some function `fn` s.t:: `(b->a) -> (c->a) -> Either b c -> a` and another s.t:: `(Either b c -> a) -> (b->a. c->a)`
-- Aside:: When we have `prove x = a`, we simply show there's a mapping x->a, then show there's a mapping from a->x, asserting their's isomorphic (as the former shows injection,
---- and the later surjection, and as both will gurantee uniqueness for inputs, we get a classic isomorphism)

_solution14a_TO
  :: (b -> a) -- a^b
  -> (c -> a) -- a^c
  -> (Either b c -> a) -- a^(b+c)
_solution14a_TO f _ (Left b) = f b
_solution14a_TO _ g (Right c) = g c

-- NOTE:: (Hermit) I'll disable this to ensure Pre-commit doesn't shit itself
-- Inputs are tuples. as ee can have k*n inputs, given that they are disjoint. Hence, we often don't require inputs to be in brackets, as they're assumed to be by default
-- This yields to redundancy and incompleteness, as seen here
-- _solution14a_TO_ALT :: -- Equivelant to _14a_TO
--     ((b -> a), (c -> a))
--     -> (Either b c -> a)
-- _solution14a_TO_ALT (f, _) (Left b) = f b
-- _solution14a_TO_ALT (_, g) (Right c) = g c

_solution14a_From
  :: (Either b c -> a) -- a^(b + c)
  -> (b -> a, c -> a) -- (a^b * a^c)
_solution14a_From f = (f . Left, f . Right)

-- Show:: `(a x b)^c = (a^c x b^c)`
-- Hint:: using (https://hackage.haskell.org/package/base-4.19.0.0/docs/Prelude.html#g:3)
-- fst:: (a,b) -> a
-- snd :: (a,b) -> b
_solution14b_TO
  :: (c -> (a, b))
  -> (c -> a, c -> b) -- F is a tuple, we can return 1.f and 2.f
_solution14b_TO f = (fst . f, snd . f)

_solution14b_From
  :: (c -> a)
  -> (c -> b)
  -> c
  -> (a, b)
_solution14b_From f g c = (f c, g c)

-- NOTE:: It's just curry, but spicier
{- TO::(c -> (b->a)) -> ((b,c)->a) -}
_solution14c_TO
  :: (c -> b -> a) -- f
  -> (b, c)
  -> a
_solution14c_TO f (b, c) = f c b

-- NOTE:: It's just uncurry, but spicier
{-FROM::((b,c)->a) -> (c -> (b->a))-}
_solution14c_From
  :: ((b, c) -> a)
  -> c
  -> b
  -> a
_solution14c_From f' c b = f' (b, c)
