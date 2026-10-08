# Hello Lean

Two simple Lean 4 proofs in `Examples.lean`:

- `two_plus_three`: 2 + 3 = 5.
- `adding_zero`: n + 0 = n for every natural number n.

Both use `rfl`, which proves equality when the two sides reduce to the
same expression. No external libraries are required.

With Lean 4 installed, check the proofs with:

```sh
lean Examples.lean
```

A successful check exits without errors. Changing `5` to `6` in the first
theorem causes Lean to reject that proof.
