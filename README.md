# Hello Lean

Two simple Lean 4 proofs in `Examples.lean`:

- `two_plus_three`: 2 + 3 = 5.
- `adding_zero`: n + 0 = n for every natural number n.

No external libraries are required.

## What does `rfl` mean?

[`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/#rfl)
stands for **reflexivity**: something equals itself. In Lean, it
proves an equality when both sides reduce to the same expression using
definitions and computation. This is called *definitional equality*.

In the example below,
[`by`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Running-Tactics/#by)
starts a tactic proof. A *goal* is the statement still to be proved;
the commands inside the `by` block, called *tactics*, solve it or turn it
into smaller goals. Here, `rfl` solves the equality goal immediately.

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
theorem `Nat.zero_add`.
The [`exact`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/#exact)
tactic finishes a goal using a supplied proof whose type matches that goal:

```lean
example (n : Nat) : 0 + n = n := by
  exact Nat.zero_add n
```

### Proving `0 + n = n` by induction

`Nat.zero_add` is an existing theorem with the type
`∀ (n : Nat), 0 + n = n`: for every natural number `n`, adding zero on
the left leaves it unchanged. `Nat.zero_add n` supplies a proof for a
particular `n`, and `exact` uses that proof to finish the goal.

See the [upstream proof of `Nat.zero_add` in Lean v4.34.1](https://github.com/leanprover/lean4/blob/v4.34.1/src/Init/Data/Nat/Basic.lean#L135-L137),
the version pinned in this repository. It uses the same zero and successor
cases shown below, expressed as a recursive proof.

We can prove the same statement ourselves by induction:

The new tactics in this proof are:

- [`induction`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/#induction):
  splits the goal into the zero and successor cases. `with` introduces
  the case branches; `| zero =>` and `| succ n ih =>` name each branch
  and its available variables. `ih` names the induction hypothesis.
- [`change`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/#change):
  replaces the goal with a definitionally equal statement, making the
  computation explicit without requiring a separate proof of equivalence.

`congrArg` is a theorem used as a proof term: given `h : a = b`,
`congrArg f h` proves `f a = f b`. Below, `exact` uses it with
`f = Nat.succ` and `h = ih`.

```lean
theorem zero_add_by_induction (n : Nat) : 0 + n = n := by
  induction n with
  | zero =>
      rfl
  | succ n ih =>
      change Nat.succ (0 + n) = Nat.succ n
      exact congrArg Nat.succ ih
```

`induction n` splits the proof into two cases:

- **Zero:** the goal is `0 + 0 = 0`, which follows directly from the
  definition of addition, so `rfl` finishes it.
- **Successor:** `ih` is the induction hypothesis, a proof of
  `0 + n = n`. We must prove `0 + Nat.succ n = Nat.succ n`.
  The addition rule reduces its left side to `Nat.succ (0 + n)`.
  `change` writes the goal in this equivalent form. Then
  `congrArg Nat.succ ih` applies the successor function to both sides
  of the equality in `ih`, proving the required equality.

The successor step can also be read as:

```text
0 + succ(n) = succ(0 + n) = succ(n)
```

The first equality follows from the definition of addition; the second
uses the induction hypothesis. Together, the zero case and successor
step establish the statement for every natural number.

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
errors, so unfinished proofs using
[`sorry`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/#sorry)
fail the check too. `sorry` is a placeholder that lets Lean accept an
unfinished proof while emitting a warning.
