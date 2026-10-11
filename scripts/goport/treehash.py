import hashlib
import os
import sys


def _read_file(path, *args, **kwargs):
    with open(path, *args, **kwargs) as stream:
        return stream.read()


root = sys.argv[1]
h = hashlib.sha256()
n = 0
for d, ds, fs in sorted(os.walk(root)):
    ds.sort()
    if os.path.relpath(d, root).split(os.sep)[0] in ("node_modules", ".git"):
        continue
    for f in sorted(fs):
        p = os.path.join(d, f)
        rel = os.path.relpath(p, root)
        if os.path.islink(p):
            continue
        h.update(rel.encode() + b"\0" + _read_file(p, "rb") + b"\0")
        n += 1
print(h.hexdigest(), n)
