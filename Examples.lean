-- Lean computes both sides to the same natural number.
theorem two_plus_three : (2 : Nat) + 3 = 5 := by
  rfl

-- This holds for every natural number by the definition of addition.
theorem adding_zero (n : Nat) : n + 0 = n := by
  rfl
