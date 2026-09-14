# Palomar submission

The public repository is [boonsuan/nivat](https://github.com/boonsuan/nivat).
The submission uses one immutable commit and the root-level files listed below.
The submission form is prepared for the maintainer to review and submit
personally; preparing the form does not initiate a Palomar submission.

## Statement of record

| Item | Value |
| --- | --- |
| Project directory | Repository root |
| Challenge module | `Challenge` |
| Solution module | `Solution` |
| Compared theorem | `NivatSubmission.nivat` |
| Comparator configuration | `comparator.json` |
| Formalization metadata | `formalization.yaml` |
| Responsible maintainer | Boon Suan Ho |
| Repository license | MIT, in the root `LICENSE` |
| Project toolchain | `leanprover/lean4:v4.33.0` |

The Challenge contains one theorem, with no project-specific definitions. Its
five imports belong to mathlib. The theorem explicitly quantifies over arbitrary
finite alphabets and configurations on `ℤ × ℤ`, counts distinct restrictions over
all lattice translations of an integer rectangle, and requires one nonzero
global period. Finiteness of the alphabet and rectangle ensures that `Set.ncard`
counts a finite set here.

The Solution repeats that exact statement and proves it using `Nivat.nivat`.
The modules compile separately and must never import one another. The only
intentional `sorry` is the Challenge's statement placeholder; the Solution and
the proof library must remain free of proof holes and extra axioms. The
configuration permits only `propext`, `Classical.choice`, and `Quot.sound` and
requests NanoDa checking. No definition is left for the Solution to choose.

## Compatibility branch

This branch pairs Lean **4.33.0** with the official mathlib v4.33.0 commit
`db584cd6d46c92f209a44c0f1c829460d327499d`, which belongs to canonical `master`
history. The official mathlib v4.33.1 release is one commit beyond that parent
on `stable`, so Palomar's canonical-branch ancestry check rejects it. Changing
only the mathlib pin would instead fail its exact toolchain-match cache check.

The two mathlib revisions have identical mathematical sources and dependency
manifests; only their `lean-toolchain` files differ. The project's proof and
paper sources are unchanged. The previous patched Lean **4.33.1** verification
is retained at [immutable commit d1901c2](https://github.com/boonsuan/nivat/tree/d1901c2bb6ae776e587f2351df3ed586aa5312b8).
That evidence remains available alongside the compatibility work. New 4.33.0
build, axiom, kernel, Comparator, NanoDa, and Linux CI checks are **pending**;
the prior evidence does not establish their outcome. Passing those checks would
also not establish a Palomar intake or editorial result.

## Verification

The normal project check is:

```sh
lake exe cache get
bash scripts/verify.sh --clean
```

This builds the library and Solution, audits their theorem types and axioms,
compiles expanded semantic statements, checks source documentation and imports,
and replays the project modules using Lean's `leanchecker`. The checker uses
Lean's own kernel implementation; it is not the independent NanoDa check.

For metadata validation, use Python 3.11 or newer and a local virtual environment:

```sh
python3 -m venv .tools/metadata-venv
.tools/metadata-venv/bin/python -m pip install -r requirements-checks.txt
.tools/metadata-venv/bin/python scripts/validate_metadata.py
```

The validator checks the pinned official v0.4 schema and selected Palomar
requirements, including classification codes, source relationships, nonempty
maintainer names, and the standard MIT license text. It downloads only pinned
public taxonomy data, not project data. After the first run,
`--offline` reuses the checked taxonomy cache. It does not verify identities,
source authorship, or semantic fidelity.

For Comparator, the project compiler is Lean **4.33.0**, and `lean4export`
uses that same compiler. The pinned Comparator itself requires a separate
**4.34.0-rc1** compiler. These checker prerequisites do not change the project's
`lean-toolchain`, mathlib revision, or global defaults. Tool revisions and
archive checksums are fixed in [scripts/palomar_tools.json](../scripts/palomar_tools.json).
NanoDa is compiled with Rust **1.90.0**; Linux additionally uses Go **1.24.0**
to build Landrun. Git and Python 3.11+ are also needed. Build products stay in
ignored `.tools/` directories.

On this Apple Silicon Mac, the explicit local prerequisite bootstrap and check
are:

```sh
bash scripts/palomar_bootstrap_macos.sh
bash scripts/palomar_setup.sh
bash scripts/palomar_check.sh --development-unsandboxed
```

The bootstrap downloads checksummed official checker-compiler and Rust archives
under `.tools/`; it does not install or register a global Lean/Rust toolchain.
The macOS option uses Comparator's own development process adapter because
Linux's Landrun confinement is unavailable. **Both actual proof kernels still
run, but this is not a sandboxed Palomar verification run.** The option is
explicit and the runner refuses to use it on Linux.

On a compatible Linux host with the pinned compiler and Rust/Go prerequisites
available, run:

```sh
bash scripts/palomar_setup.sh
bash scripts/palomar_check.sh
```

The Linux procedure uses the pinned Palomar Landrun adapter and systemd
confinement. It fails if confinement is unavailable. The
[CI workflow](../.github/workflows/ci.yml) provisions these tools, runs the proof
and metadata checks, and performs this Linux comparison. Its actions are pinned;
it has no publication or deployment step. Remote runs are recorded in
[GitHub Actions](https://github.com/boonsuan/nivat/actions/workflows/ci.yml).

The setup writes `.tools/palomar-tool-build.json`, recording source pins,
compiler versions, and binary hashes. Comparator writes separate mode-labeled
logs and a report under `.tools/`. These distinguish the local development
check from Linux confinement. [STATUS.md](../STATUS.md) records observed results;
a passing local check is not a Palomar mechanical report or editorial decision.

## Retained Lean 4.33.1 results — 14 September 2026

The following records describe the prior 4.33.1 revision, not a completed
verification of this compatibility branch. Its [complete verification log](https://github.com/boonsuan/nivat/blob/d1901c2bb6ae776e587f2351df3ed586aa5312b8/logs/verification.log)
and [version record](https://github.com/boonsuan/nivat/blob/d1901c2bb6ae776e587f2351df3ed586aa5312b8/docs/versions.json)
remain immutable.

| Check | Observed result |
| --- | --- |
| Clean library and Solution build | Passed; 2502 Lake jobs |
| Principal axiom audit | Passed for 36 declarations; only the three standard logical axioms |
| Expanded semantic statements | Both compiled and passed the axiom audit |
| Local v0.4 metadata and MIT license checks | Passed, including offline taxonomy-cache validation |
| Comparator statement and axiom comparison | Passed |
| Independent NanoDa replay | Passed |
| Comparator's Lean kernel replay | Passed |
| Linux process confinement and GitHub CI | Passed remotely for the unchanged proof/configuration at [da92ad4](https://github.com/boonsuan/nivat/actions/runs/34796906668) |
| Palomar intake, editorial review, and registration | Not established by these checks |

The actual local checker command was
`bash scripts/palomar_check.sh --development-unsandboxed`.
The retained [check summary](https://github.com/boonsuan/nivat/blob/d1901c2bb6ae776e587f2351df3ed586aa5312b8/logs/palomar-check.log),
[actual checker output](https://github.com/boonsuan/nivat/blob/d1901c2bb6ae776e587f2351df3ed586aa5312b8/logs/palomar-output.log),
[machine-readable report](https://github.com/boonsuan/nivat/blob/d1901c2bb6ae776e587f2351df3ed586aa5312b8/logs/palomar-check.json), and
[tool and binary manifest](https://github.com/boonsuan/nivat/blob/d1901c2bb6ae776e587f2351df3ed586aa5312b8/logs/palomar-tools.json) record its mode, source
hashes, tool revisions, and exit status. This run substituted only the process
sandbox adapter; the genuine pinned Comparator, NanoDa, and Lean kernel ran.
No kernel check was bypassed.

The retained [metadata log](https://github.com/boonsuan/nivat/blob/d1901c2bb6ae776e587f2351df3ed586aa5312b8/logs/metadata-validation.log)
records that revision's metadata check. Root `LICENSE` has SHA-256
`97182fa2b484a3bda028b0eef349d2b2a8e321a4b4234a4f63922546477bcea5`.
The validator also rejects malformed metadata in targeted negative checks;
that is validation of the local script, not an additional review of the proof.

## Disclosures and scope

The README and `formalization.yaml` explicitly distinguish model-generated
mathematics, mechanical verification, and human digestion. GPT-6 Pro is credited
with finding the proof in response to the maintainer's prompts. AI agents in
Codex produced the Lean development and documentation. The maintainer is
responsible for the project but claims no human authorship of the mathematical
proof or paper. No human expert review or digestion is claimed.

The source manuscript is included at `paper/nivat.tex`; its hash is recorded in
`formalization.yaml`. The paper is available as [PDF](../paper/nivat.pdf) and has no separate
public preprint identifier recorded here. The
bibliography records the antecedent algebraic, boundary-counting, and dynamical
methods. No claim of priority or comprehensive literature search is made.
`related_formalizations: []` means none are identified in the metadata.

## Preparing the submission form

1. Select the full 40-character SHA of the published commit to be submitted.
   Inspect its [CI run](https://github.com/boonsuan/nivat/actions/workflows/ci.yml)
   and ensure that the PDF, source, manifest, license, and submission files are
   present at that commit.
2. Open [the submission service](https://submit.palomar-registry.org/), using
   the current [submission instructions](https://palomar-registry.org/how-to-submit).
   Enter `boonsuan/nivat` and the full commit SHA. This is an ordinary root
   project: the configuration is `comparator.json` and the metadata is
   `formalization.yaml`.
3. Record that Boon Suan Ho is a responsible maintainer of the substantive
   formalization. Complete the service's GitHub authorization if required.
4. Leave the form unsubmitted for the maintainer's final review. Only the
   maintainer should initiate this submission.
5. After submission, read Palomar's mechanical result and automated editorial
   review. Registration is a separate decision after those checks.

Palomar assesses an immutable public commit and performs its own mechanical and
automated editorial checks. It is a registry, not human peer review or an
endorsement of the result. Local logs do not replace those checks.

## Requirement sources

Preparation used the [Palomar announcement](https://terrytao.wordpress.com/2026/08/18/palomar-a-registry-of-lean-verified-mathematics/),
[registry explanation](https://palomar-registry.org/about),
[submission instructions](https://palomar-registry.org/how-to-submit), and
[submission policy at commit e9c8c23](https://github.com/PalomarRegistry/PalomarPolicy/blob/e9c8c238f5695b10f75db7175648a1d0195352c1/CONTRIBUTING.md).
The local metadata validator pins the official
[formalization.yaml v0.4 schema](https://github.com/mathlib-initiative/formalization.yaml/tree/99c678e569c7c4c0772db297c5ddd5e4c9b6322e).
These sources were inspected on 14 September 2026; Palomar may change its intake
requirements before a submission is made.
