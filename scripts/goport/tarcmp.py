import hashlib
import os
import sys
import tarfile


def _read_file(path, *args, **kwargs):
    with open(path, *args, **kwargs) as stream:
        return stream.read()


tar, root = sys.argv[1], sys.argv[2]
with tarfile.open(tar) as t:
    names = set()
    bad = []
    for m in t.getmembers():
        n = m.name.removeprefix("./")
        if not n:
            continue
        rel = n.split("/", 1)[1] if n.split("/", 1)[0] == "source" and "/" in n else n
        if m.isfile():
            names.add(rel)
            p = os.path.join(root, rel)
            if not os.path.isfile(p):
                bad.append(("missing", rel))
                continue
            if (
                hashlib.sha256(t.extractfile(m).read()).digest()
                != hashlib.sha256(_read_file(p, "rb")).digest()
            ):
                bad.append(("diff", rel))
    extra = []
    for d, ds, fs in os.walk(root):
        for f in fs:
            rel = os.path.relpath(os.path.join(d, f), root)
            if rel not in names and not rel.startswith("node_modules/"):
                extra.append(rel)
    print(
        "tarfiles",
        len(names),
        "bad",
        bad[:10],
        len(bad),
        "extra",
        extra[:10],
        len(extra),
    )
