import hashlib
import subprocess
import sys


def _read_file(path, *args, **kwargs):
    with open(path, *args, **kwargs) as stream:
        return stream.read()


root = sys.argv[1]
files = subprocess.run(
    ["git", "-C", root, "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
    capture_output=True,
    check=True,
).stdout.split(b"\0")
files = sorted(f for f in files if f)
h = hashlib.sha256()
import os

n = 0
for f in files:
    p = os.path.join(root.encode(), f)
    if not os.path.isfile(p):
        continue
    h.update(f + b"\0" + _read_file(p, "rb") + b"\0")
    n += 1
print(h.hexdigest(), n)
