# Pragma hooks

Pragma supplies formatting, language linting and Kingfisher secret checks before
commits, and project tests before pushes. The portable wrappers resolve the
installation from `PRAGMA_HOME`, repository-local `pragma.home`, or `~/.pragma`.

Install the current Pragma release from https://github.com/zakstak/pragma, then
run `PRAGMA_HOME=/path/to/pragma scripts/install-pragma.sh`. For this rollout,
use the edition-aware core from Pragma PR 16 (commit
`08b33c574136dbc0853b3da2c7ab7be8aeb19d03`) or a subsequent version containing
that fix. Install the declared language tools with Pragma's
`tools/install-tools.sh --agent`. Put its tools and `prek` on `PATH`.

Use the checked-in `prek.toml`. Regenerating it with Pragma's bootstrap replaces
wrappers, so restore the repository wrappers and rerun
`scripts/install-pragma.sh` after regeneration. That setup installs the
public-history safety guard as `pre-push.legacy`, which prek runs alongside
Pragma.

Pragma's Rust lint and test commands use `.pragma-hooks/bin/cargo`, an adapter
that delegates to the unchanged `scripts/run-cargo-capped.sh`. Tests use release
binaries and the locked workspace; clippy uses release binaries and its complete
Pragma target/feature selection. The default toolchain is CI's Rust 1.93.0;
`RUSTUP_TOOLCHAIN` may select another installed toolchain. The adapter does not
bypass a missing systemd user session or relax resource limits.

Run `prek run --all-files` and `prek run --all-files --stage pre-push` for the
repository checks. These checks do not accept a compiler revision or replace the
protected-set comparisons, pinned Go oracle, gate, saved evidence, or
independent verdicts required by `AGENTS.md`. Compiler acceptance state and
project inputs remain unchanged.

Formatting preserves pinned standard-library inputs, intentional compiler
fixtures, codegen specification inputs, vendored license text and saved
accountability evidence. Fixture syntax is also excluded from generic language
linting; Rust crate linting still checks the implementation and Rust test
targets.
