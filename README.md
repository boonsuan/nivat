# Pattern complexity and Nivat’s conjecture

A Lean 4 + mathlib formalization of [*Pattern complexity and Nivat’s conjecture*](paper/nivat.pdf), proving that low rectangular pattern complexity forces a nonzero period.

Registered in Palomar as [PALOMAR-2026-09-14-000003, version 1](https://palomar-registry.org/entry.html?id=PALOMAR-2026-09-14-000003&version=1), with mechanical verification and automated editorial review.

**Update (14 September 2026):** I have just become aware of [Bryna Kra’s guest post on Terence Tao’s blog](https://terrytao.wordpress.com/2026/09/13/deep-theorems-were-scarce-and-difficult-and-so-became-an-effective-mechanism-to-identify-deep-thought-ai-has-broken-this-system/), discussing Nivat’s conjecture and AI-generated mathematics. It went up around 3 hours before my first commit to this repository, though I completed the proof-generation and formalization work reported here before learning of the post. As emphasized below, GPT-6 Pro found the proof; I did not. My role was prompting the model and arranging formal verification. I am sharing the material because it may be useful and interesting to some people.

**Disclaimer**
The proof was found entirely by **GPT-6 Pro**, in response to my prompts. The
paper was written by AI, not by humans, and it has **not been mathematically
digested by humans**. The Lean formalization and its accompanying documentation
were produced by GPT-6 Astra Ultra in Codex. I am making this material available because
the result may be of interest to others.

I am not an expert in this area. I do not regard myself as qualified to digest
the argument properly or give it the exposition it deserves, and I do not have
enough personal interest in the subject to undertake that substantial work myself.
My involvement in this project has focused on prompting proof generation and
arranging formal verification.
Experienced mathematicians who would like to understand, contextualize, simplify,
or explain the proof are very welcome to do so.

This distinction follows the vocabulary of **generation, verification, and
digestion** discussed in [Terence Tao’s writings on AI and mathematics](https://teorth.github.io/tao-web/ai-views.html): a checked proof does not by itself provide mathematical understanding or good exposition. This project addresses the first two activities and does not claim to have completed the third.

## Where to start

- **Audit the advertised result:** [Challenge.lean](Challenge.lean) states it using only mathlib concepts, independently of the proof library. [Solution.lean](Solution.lean) proves that same statement.
- **Read the paper:** [PDF](paper/nivat.pdf) ([LaTeX source](paper/nivat.tex)).
- **Follow the proof:** begin with [Nivat/Main.lean](Nivat/Main.lean), then the [mathematical reading guide](docs/READING_GUIDE.md) and [paper-to-declaration map](docs/SOURCE_MAP.md).
- **Check the evidence:** [STATUS.md](STATUS.md) records the commands, results, and limitations. [formalization.yaml](formalization.yaml) records sources, credits, automation, and review status.

## The theorem

Let $A$ be any finite alphabet and $c : \mathbb Z^2 \to A$ any configuration.
For positive integers $m,n$, put

$$R_{m,n}=\{0,\ldots,m-1\}\times\{0,\ldots,n-1\}.$$

Let $P_c(R_{m,n})$ count the distinct functions
$z\mapsto c(z+t)$ on this rectangle, as $t$ ranges over **all** of
$\mathbb Z^2$. If $P_c(R_{m,n})\le mn$ for some such rectangle, then

$$\exists h\in\mathbb Z^2\setminus\{(0,0)\},\quad
  \forall z\in\mathbb Z^2,\quad c(z+h)=c(z).$$

The public library theorem is `Nivat.nivat`. Its statement, inside
`namespace Nivat`, is:

```lean
theorem nivat {A : Type*} [Finite A] (c : Configuration A)
    (m n : ℕ) (hm : 0 < m) (hn : 0 < n)
    (hlow : complexity c (rectangle m n) ≤ m * n) :
    ∃ h : Lattice, h ≠ 0 ∧ ∀ z : Lattice, c (z + h) = c z
```

Here `Lattice = ℤ × ℤ`, `Configuration A = Lattice → A`, and `rectangle m n`
is the product of the integer intervals `[0,m)` and `[0,n)`. Patterns are
functions on the finite rectangle; `complexity` is the cardinality of their
set of distinct occurring patterns. This set is finite because the alphabet and window are
finite. The quantifiers concern the full infinite lattice. The conclusion
requires one nonzero global period; it does not require two independent periods.
There is no recurrence, minimality, or decomposition hypothesis on `c`.

```lean
import Nivat

#check Nivat.nivat
#print axioms Nivat.nivat
```

## Mathematical context and proof structure

The Morse–Hedlund theorem characterizes periodic bi-infinite words by their
block complexity: a word is periodic if and only if, for some $n$, it has at
most $n$ distinct blocks of length $n$. Nivat’s conjecture asks for the
corresponding implication in two dimensions, with intervals replaced by
rectangles. [Cyr and Kra](https://arxiv.org/abs/1208.4090v2) established
periodicity under the stronger hypothesis $P_c(R_{m,n})\le mn/2$, using
combinatorial methods and the theory of nonexpansive subdynamics.

[Kari and Szabados](https://arxiv.org/abs/1605.05929v1) developed an algebraic
approach in which low pattern complexity gives rise to polynomial
annihilators. They proved that, after an integer labeling of the alphabet,
a low-complexity configuration is a sum of periodic integer-valued
configurations, whose ranges need not be finite. They also obtained an
asymptotic form of Nivat’s conjecture: an aperiodic configuration satisfies
$P_c(R_{m,n})\le mn$ for only finitely many pairs $(m,n)$.
[Szabados](https://arxiv.org/abs/1710.05360v1) subsequently proved the conjecture
for sums of two periodic configurations, combining this algebraic approach
with the balanced-set methods of Cyr and Kra.

The proof here proceeds by induction on the area of a rectangle witnessing
low complexity, after labeling the alphabet by rationals. The main estimate
shows that applying a suitable Laurent polynomial reduces the number of
occurring patterns by at least the number of sites lost from the rectangle.
Its proof uses an exact description of the annihilator ideal of the difference
of two orbit-closure points agreeing on a half-plane. The estimate produces a
smaller rectangle on which the resulting configuration still has complexity
at most its area. Induction makes that configuration periodic, and a
mixed-difference identity reduces the final step to the finite-rational
two-factor theorem. A proof of this theorem is included, using boundary
extension arguments and the Morse–Hedlund theorem.

## Paper-to-code correspondence

| Paper | Principal modules |
| --- | --- |
| §1: configurations, patterns, rational labels | [Core](Nivat/Core), [Laurent action](Nivat/Algebra/Action.lean) |
| §2: supported multiples and complexity descent | [RectangleSupport](Nivat/Algebra/RectangleSupport.lean), [ExactDescent](Nivat/Descent/ExactDescent.lean) |
| §3: annihilators, half-plane agreement, tangent periods | [LowComplexity](Nivat/Algebra/LowComplexity.lean), [Dynamics](Nivat/Dynamics), [BoundedDifferences](Nivat/Core/BoundedDifferences.lean) |
| §4: exact annihilator ideal | [ExactLine](Nivat/Algebra/ExactLine.lean) |
| §5: two difference operators | [TwoFactors](Nivat/TwoFactors) |
| §6: induction on rectangle area | [Main](Nivat/Main.lean) |
| Appendix A: product annihilator | [RationalScaling](Nivat/Algebra/RationalScaling.lean), [ProductDifferences](Nivat/Algebra/ProductDifferences.lean) |

The 29 library modules contain 377 explicit declarations. Each has a
mathematical docstring locating the corresponding statement or proof step in
the paper. The [source map](docs/SOURCE_MAP.md) explains differences in interface
formulation, and the [reading guide](docs/READING_GUIDE.md) explains the
representations used by the formal proof.

## Build and check

With [elan](https://github.com/leanprover/elan) available, run from the repository root:

```sh
lake exe cache get
lake build
bash scripts/verify.sh --clean
```

This compatibility branch pins Lean to **4.33.0** and mathlib to
`db584cd6d46c92f209a44c0f1c829460d327499d`.
[lake-manifest.json](lake-manifest.json) locks all transitive dependencies;
[docs/versions.json](docs/versions.json) records the observed local versions.
The cache command downloads dependency build artifacts. The clean verification
command rebuilds the project while retaining that dependency cache.

The mathlib mathematical sources and dependency manifest are identical to those
in the previous 4.33.1 release; only mathlib's `lean-toolchain` file differs.
The project proof sources are unchanged. The prior checks under patched Lean
**4.33.1** remain available at [immutable commit d1901c2](https://github.com/boonsuan/nivat/tree/d1901c2bb6ae776e587f2351df3ed586aa5312b8),
including its [verification log](https://github.com/boonsuan/nivat/blob/d1901c2bb6ae776e587f2351df3ed586aa5312b8/logs/verification.log)
and [Comparator/NanoDa report](https://github.com/boonsuan/nivat/blob/d1901c2bb6ae776e587f2351df3ed586aa5312b8/logs/palomar-check.json).
The new 4.33.0 clean build, theorem and axiom audits, Lean kernel replays, and
local Comparator/NanoDa checks have also passed; see the
[current verification log](logs/verification.log) and [checker report](logs/palomar-check.json).
The [compatibility audit](logs/compatibility-audit.json) confirms that all 33
tracked Lean files and the elaborated theorem/axiom outputs match the 4.33.1
baseline. [Linux CI](https://github.com/boonsuan/nivat/actions/runs/34799652245)
also passed the build, audits, confined Comparator, and both kernel checks at
commit `50698318e864a3eee16e196ed4af22bb1709d568`.

The proof audit checks elaborated theorem types, expanded definitions, and axiom
dependencies. The proved declarations use only `propext`, `Classical.choice`,
and `Quot.sound`. The default `lake build` builds the full library and
`Solution`; neither contains an admitted proof. `Challenge.lean` deliberately
contains one `sorry`, following Palomar’s statement/proof separation convention. It is
excluded from the default build and is never imported by the proof.

The verification script also audits documentation and imports, and replays
project modules using `leanchecker`. That program uses Lean’s own kernel; it is
not an independent implementation. The separate Comparator procedure, including
NanoDa, is described in [the Palomar preparation notes](docs/PALOMAR.md).

## Palomar preparation

[Challenge.lean](Challenge.lean), [Solution.lean](Solution.lean),
[comparator.json](comparator.json), and [formalization.yaml](formalization.yaml)
provide the submission interface. The Lean 4.33.0 local Comparator and NanoDa
checks passed in explicitly unsandboxed macOS mode. The retained Lean 4.33.1
checks also passed, as recorded in the immutable report above.
[GitHub Actions](https://github.com/boonsuan/nivat/actions/workflows/ci.yml) records
the Linux checks. [docs/PALOMAR.md](docs/PALOMAR.md) contains the evidence,
validation commands, and submission procedure. No Palomar review outcome or
registration is claimed.

## License and contributions

The repository is released under the [MIT license](LICENSE), with Boon Suan Ho
as responsible maintainer. Dependencies and cited works retain their own
licenses. The maintainer’s role is prompting, project direction, and maintenance;
the AI contributions are detailed in [formalization.yaml](formalization.yaml).
Corrections, independent statement audits, and mathematical exposition are welcome.
