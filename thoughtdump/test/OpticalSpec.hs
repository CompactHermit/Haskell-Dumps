module OpticalSpec where

import Test.Hspec.Hedgehog -- actually fucking cool

import OpticsPrism
import Test.Hspec

spec :: Spec
spec = do
    describe "Should return true and false" $ do
        it "is a tautology" $ do
            True `shouldBe` True
        it "assumes that 2 is 1" $ do
            2 `shouldBe` (1 :: Integer)

    describe "Actual Optics Test" $ do
        it "Test Lens Composition" $ do
            _x (_point (shiftAtomX atom)) `shouldBe` 1.1

    describe "List Sanity Test" $ do
        it "only contains one test" $ do
            sum [1 .. 17] `shouldBe` ((17 * 18) `div` 2 :: Integer)

atom = Atom{_point = Point{_x = 0.1, _y = 0.5}, _element = "Starting Camera"}
