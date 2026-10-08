# Hello Lean

Two simple Lean 4 proofs in `Examples.lean`:

- `two_plus_three`: 2 + 3 = 5.
- `adding_zero`: n + 0 = n for every natural number n.

No external libraries are required.

## What does `rfl` mean?

`rfl` stands for **reflexivity**: something equals itself. In Lean, it
proves an equality when both sides reduce to the same expression using
definitions and computation. This is called *definitional equality*.

```lean
theorem two_plus_three : (2 : Nat) + 3 = 5 := by
  rfl
```

`Nat` means natural numbers: 0, 1, 2, and so on. Lean computes `2 + 3`
to `5`, so the goal becomes `5 = 5`, which `rfl` proves.

It also works with variables when the equality follows directly from a
definition:

```lean
theorem adding_zero (n : Nat) : n + 0 = n := by
  rfl
```

### Recursion on the second argument

Lean defines natural-number addition by examining the second argument:
in `a + b`, that is `b`. It uses two rules, written here as mathematical
notation:

```text
a + 0       = a
a + succ(b) = succ(a + b)
```

`succ(b)` means the next natural number after `b`, so `succ(2) = 3`.
The second rule reduces the addition to a smaller problem, until the
second argument reaches zero. For example:

```text
2 + 3
= succ(2 + 2)
= succ(succ(2 + 1))
= succ(succ(succ(2 + 0)))
= succ(succ(succ(2)))
= 5
```

This explains why `rfl` works for one order of addition but not the other:

- For `n + 0 = n`, the second argument is zero. The first rule applies
  immediately, so `rfl` works for every natural number `n`.
- For `0 + n = n`, the second argument is an unknown `n`. Lean cannot
  choose a rule until it knows whether `n` is zero or a successor, so
  `rfl` alone cannot finish.

The latter is still true: `rfl` simply does not prove every true equality.
Proving it for every `n` uses induction, already captured by Lean's
theorem `Nat.zero_add`:

```lean
example (n : Nat) : 0 + n = n := by
  exact Nat.zero_add n
```

## Check the proofs

With [elan](https://github.com/leanprover/elan) installed, run this from
the repository directory. Elan selects the Lean version pinned in
`lean-toolchain`, downloading it if needed:

```sh
lean -DwarningAsError=true Examples.lean
```

A successful check exits without errors. Changing `5` to `6` in the first
theorem causes Lean to reject that proof.

## Continuous integration

The [Check Lean proofs](https://github.com/yujunz/hello-lean/actions/workflows/lean.yml)
GitHub Actions workflow runs the same check on every push and pull request.
It can also be run manually from the Actions tab. Warnings are treated as
errors, so unfinished proofs using `sorry` fail the check too.
