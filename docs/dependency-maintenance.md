# Dependency maintenance

The maintenance branch updates exact compiler crate pins to the current stable
crates.io releases: rustc-hash 2.1.3, indexmap 2.14.2, memchr 2.8.3, smallvec
1.16.3, xxhash-rust 0.8.19, jiff 0.2.38, signal-hook 0.4.5, num-bigint 0.5.1,
ryu-js 1.0.3, and lzma-rust2 0.22.0. Both platform-specific jiff entries and the
wasm/build lzma entries stay aligned. Cargo regenerates the workspace lockfile,
including current compatible serde/serde_json and transitive dependencies.

Current GitHub action major versions are checkout v7, setup-node v7, setup-go
v7, upload-artifact v7, and download-artifact v8. rust-cache already tracks its
current v2 major. The release workflow uses stable Node 26 and npm 12.2.0; the
wasm package's supported consumer engine remains Node 22 or later.

Registry sources are https://crates.io/api/v1/crates/<crate>, action
repositories' GitHub release APIs, https://nodejs.org/dist/index.json and npm's
package metadata. The manifests retain exact compiler dependency versions for
reproducibility. The wasm npm package declares no external package dependencies.

The TypeScript-Go oracle commit, oracle Go toolchain and project-input commits
are conformance references governed by the compiler accountability rules. They
are preserved. The Unicode generator's Go 1.27.1 and x/text 0.42.0 pins likewise
define generated conformance tables and stay aligned with that workflow. Release
Rust 1.95.0 is deliberately paired with LLVM 22 and PGO artifacts; CI's Rust
1.93.0 is also preserved. Updating those requires the corresponding real
compatibility and protected-set evidence, rather than a speculative
latest-version substitution.

A dependency PR does not constitute an accepted compiler revision. Recover the
saved accepted binaries, per-name test results, gate/oracle evidence and
unchanged Query/Hono inputs before any required protected-set comparison and
independent acceptance review. A clean build or focused crate tests cannot
replace those records. Native validation does not claim a Windows, macOS or wasm
runtime result.
