Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.227.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792579131;
	b=YQ8hSd2miDS3+Uo74cXnu3inSnCnD0LFwBQixKjnPni4xIPDWofC47srLf+3XjgAQcdw
	 NS9K5LZDOPaqUaan4g3qfo1Rw+dN+830PdCOXqZPu6mkGf8j5ADdrCDqg1NbNaXyzXugC
	 WDNDVUfF9s/efD7PIpsZQmybEVB2W2CfEtuIH0BlMc9zXZOi36XzUWZ7bNilFFA5hkka9
	 6Ic1Y1ldyyMo7JAPzukABORlnR+NTyqX6nrN8vHMYEx5mT26OcZ1CsCSZYCTu9s6McGN1
	 NREA1q981NCCPiDqMVR/q8jOyvu24FIL9aLuGNO1k5iT7ptFgMGUfeT2P/mk21vH0aw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792579131;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Content-Type;
	bh=E62B4bZoWAmtZ4DnaAkSHjBkyEA75BITqw3Y+Qm5Jz4=;
	b=m5NlP/Lewp6QcDvrqesGCyMhX/CvK+QlNd0LQGpcrbBLTJY5daP7tux80fQNb8mw1p6q
	 Xlj6ZQHah5HJXILZGzRTL4M8SloD8mXyEwKCr8Q76ohXWwAlRdAmyj916YFK124w/qV9L
	 N08oybY4qB3vRC/aQgtkcbAj12IYoj0FptTEy55gv0J7/JYIpL+5h99OOuIXxgL8GJq3w
	 DYeF+QZIPA7fzw/xLwp/HMb9WkOzmmpah2C9oxD/zLcl+WTNTH1oFjUlMQYu2pbfxws6L
	 cmMcQbebDbsEWheIePQ/+B+hqEXNaurzM2RQn/VAuTWCjltPZiDqo845XbEe/Ax6pMA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YjAE1T9D;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.227.5
Received: from mail-vs2-f5.google.com (mail-vs2-f5.google.com [74.125.227.5])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ABC606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 10:38:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48ABC606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YjAE1T9D
Received: by mail-vs2-f5.google.com with SMTP id ada2fe7eead31-7c326adb66eso610641137.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:38:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792579130; cv=none;
        d=google.com; s=arc-20260327;
        b=ODJ3kgauDO1hZuk5Hd7h5QYHkMYmBjXNSQDbMHXXybZK8iMY/mzXADXVadzm6GsvlF
         ixzwMci0Yrby7BSWTyXeEBdzC5YmWi6P0k2Nt+3ZRjG7P69IkQvR9lWly1jTkPAOePUZ
         rWMaJTN24H9jq4LaWzR4YL/Q9vySbk6pRxIGwyZ2nwIVJR38RShK+bFHViYv3oOGW9gk
         4YaA31ZLPBqlgygeBSnwI1ntX/KiozWQFWXFuFnROY7CQ1d6IdTUgN5HX/IVCAZuoSnV
         BzVRnk9k/6rpf8eKpzcgggZhSP+QZCIFlZ+IogBJnTqf+3hODjC3pE/UXpssR5XF7uVX
         4UUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=E62B4bZoWAmtZ4DnaAkSHjBkyEA75BITqw3Y+Qm5Jz4=;
        fh=IOI3BSFtc4S+mY5yRaEOyEQVEbaexZFmwOG7FNW1hpE=;
        b=eQEjK/x66RXGF0ZGNtgyQRt0A22cGg4ikBEIrn1fjZNIrEh1vGfEAL6cB4HgOlZoRF
         p2Haa5PkzP6/M/5jTCV6/GnATLo0nuHGjTLUEjI4F+ULSwf44hVrAq8w0YxR0dyMGQbL
         wh5fZvFNTQy9OIVp6k4eYtRr8Nqp3Wx4r0TfMRkawr4xLL4ZzP4GBp8Pi1dfcJvmXBrv
         ymmCm/PVZfoa9REO16JH0aX64jiRUKdujOyTsu6lYvoJzHdBRl/7cYpTtRfn87ahGWPR
         atvL9GYQaxshXQ/f1f9h/HBWZZxuyg2xKOqurQarPB7D+Im96+GCfAffa3b1qxE6Hu1r
         3Qwg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792579130; x=1793183930; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=E62B4bZoWAmtZ4DnaAkSHjBkyEA75BITqw3Y+Qm5Jz4=;
        b=YjAE1T9DqcGw63UVchcuywn0AhW0xYjFlMGPEXPjBkT/q+6wQQz5kGMXvd3ql8e9Xr
         qILTxv5yuGzKXgZpsAmHiynP41Z/91fC2/Sq8/KC6EsYvHDeHyRqEY26xM9rrADiXeQu
         QZWmwWGKizQYkDGswNrjFpRcONDISkz7BFq0ehXJbmgDiiVFCgGqMlQRt8qXTThBGOCh
         A1wSFRsQwRLEngpxISSK7ptf3DkpSdmTDwDfpdnpe6Krg9Wb2xIdi0tM/OKHnQTvFvJb
         3Hd+c2Zcku07Al0AE/VVIKayLEbU7IIO0PQyX+DnzxQvbIn50PiJbMlk1FBWSNw9AGuz
         RMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792579130; x=1793183930;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E62B4bZoWAmtZ4DnaAkSHjBkyEA75BITqw3Y+Qm5Jz4=;
        b=SjDbFBdX3YOHmnVed4YnF9VP7h0lAqOpqopEHGH6Qob9EAFzqZ1OXpS51FV3tDmCQT
         eNS+cZgEm3YfsADqn8WfkywTt/MP24LXA8Qt3W5y3PYAb2rKVvwbvSvtJw/zU4Wgm8Sw
         b9Y2wrMBz8EKr4c3HSby7owQk932j9nAYOnjqx9oSw7RhdcK1RBhWQzN6iCXI3UvPDgs
         zq2F7B/8Fk1wxaSK0G9HW6cO8hAl7GlZFaUZxPF2muW18miz7dmCYVEk74sCWmgSpqn8
         CiCw2ToY2u3Nv2L8aIrwhOZ0qjVxcccW9vLjtoCO5SJ5STnzLqhr3NCjbTVxNCCEBRbg
         QfLw==
X-Gm-Message-State: AFq9FYKXx3L+WHwpPaB4Mv176nqWzMMxnE5jvqS/9a6HLnQB04OYbQK/
	orGNRLhsQV4PypJyiJCAsEBjxYLhg4MqwzrAAv0KNKxLM9mzouSpxeuArjfo5aYHKKqXmEKi+pj
	ICIpKmTmQGR8z23Cc+dAt0ooWLVj3TEBgki2E16LSOQ==
X-Gm-Gg: AYBFou1UdvvEu5mGaQv/0bzdSyf61WN+eRTmwIUIVUTlDfzs+OAvBqHWCNdhXDb6R23
	e4Cu4ZzK+FcUkm2kO21Um79OO0ZNBf4BkEEwJN/oF+qfzsG3JnT4LmvLlTRwgkhYL1DAT+u/7lm
	FHgM9tgGe2nZAvJZg9mrKAMVsCu5zVHjea1gDf/IV78Vm1kp2VqNDS/FS92t0OF1KFnqohj1sYC
	lr5bvUNuRnTqJe66MrbOIzmnZhYE1e8EC62QJgHt7FXfyaRWbjkFiUMCQGn2nJqwaN3eQAVykV9
	Go5b8LCm7O33UIuUjyTnhwJl4wsTJ4U2yLk0thcBv2lHqqsDyE+ZT8hWvltguuOBmOnkpXibCep
	dT4/lZXMUyzldUYqjuru/4FA0R9Fi5zLeqIIvzE9agYrTyVX/Zkgs/vS8/mlXjcOSXfTikiPmJ/
	v4MK4FN+IiBfAC19I=
X-Received: by 2002:a05:6102:160c:b0:7cc:1a41:20fe with SMTP id
 ada2fe7eead31-7cc926de9b8mr638422137.25.1792579130074; Wed, 21 Oct 2026
 03:38:50 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Tristan Elvers <tristanelvers@gmail.com>
Date: Wed, 21 Oct 2026 12:38:39 +0200
X-Gm-Features: AclHuK983URVLBxXthr69w9bNiJbbtb88FpAROUej5yi1zvTPr1Va0mefRsyGjg
Message-ID: <CAFoLKK+aErV4p6ZJPnVeH5SHQ5++0f=8ZgxPWe-E-CkeKBs8PA@mail.gmail.com>
Subject: [BUG] incremental send omits hole after trimming the tail of a
 leaf-last file extent item (receiver keeps stale data)
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

First of all, I found this bug with the help of Claude. The problem
occurred in the production environment; we weren't specifically
looking for an issue.
Unfortunately, I don't know much about coding myself, so I can't
contribute much personally, on this matter, but I hope this issue
doesn't turn out to be a false alarm and that it can be resolved.
Please do not hesitate to contact me if you have any queries.

Here is the Information I got from Claude:
An incremental "btrfs send -p" silently omits a hole when the tail of a
file extent item is punched away, the item is the last item of its leaf,
and the following leaf is unchanged between parent and send snapshot.
The receiver keeps the old data in the punched range, so the received
file differs from the source without any error. Full sends are correct.

Seen on 7.2.9 and 7.2.11 (Fedora 7.2.11-200.fc44.x86_64), btrfs-progs
7.1, no-holes enabled (mkfs default). A self-contained reproducer is
included below; on a fresh 2 GiB loop filesystem it gives:

    leaf-last extents trimmed: 7
    7 of 7 trimmed extents differ on the receiver
    whole file: DIFFERS

The result is the same with "btrfs send --proto 2", so this is not the
v1-only zero-writing behaviour discussed in btrfs-progs issue #1001
(fixed by "btrfs: send: use fallocate for hole punching with send
stream v2"): with v1 the stream contains no command for the punched
range (checked with receive --dump, see below), not even a write of
zeroes, and with v2 the receiver keeps the stale data just the same.
The hole seems to be missed before the stream format comes into play.


How it was found
----------------

A nightly backup sends read-only snapshots of a VM disk image (qcow2,
qemu with discard='unmap') incrementally to a second btrfs filesystem
and compares checksums afterwards. After the guest ran fstrim, qemu
punched a hole at the end of an existing extent. From then on the
received copy differed: 8 MiB at offset 12463964160 were a hole in the
source snapshot but still contained the parent's data on the receiver.

"btrfs send -p PARENT SNAP | btrfs receive --dump" contains no command
at all touching that range (79480 write and 311 clone commands in
total, none overlapping it).

File extent items of that inode (dump-tree of the snapshot roots):

parent snapshot:
  leaf 935723008 items 174 free space 2711 generation 41670 owner 257
    item 172 key (257 EXTENT_DATA 12454526976) itemoff 7114 itemsize 53
        generation 18 type 1 (regular)
        extent data disk byte 26447552512 nr 67174400
        extent data offset 73728 nr 5242880 ram 67174400
    item 173 key (257 EXTENT_DATA 12461342720) itemoff 7061 itemsize 53
        generation 18 type 1 (regular)
        extent data disk byte 26447552512 nr 67174400
        extent data offset 6889472 nr 11010048 ram 67174400
  leaf 350879744 items 208 free space 59 generation 41657 owner 257
    item 0 key (257 EXTENT_DATA 12473139200) itemoff 16230 itemsize 53
        generation 18 type 1 (regular)
        extent data disk byte 26447552512 nr 67174400
        extent data offset 18685952 nr 720896 ram 67174400

send snapshot:
  leaf 126293196800 items 173 free space 2789 generation 49841 owner 257
    item 171 key (257 EXTENT_DATA 12454526976) itemoff 7167 itemsize 53
        ...
    item 172 key (257 EXTENT_DATA 12461342720) itemoff 7114 itemsize 53
        generation 18 type 1 (regular)
        extent data disk byte 26447552512 nr 67174400
        extent data offset 6889472 nr 2621440 ram 67174400
  leaf 350879744 items 208 free space 59 generation 41657 owner 257
    (same leaf as in the parent)

So the item at 12461342720 shrank from 11010048 to 2621440 bytes (same
disk extent, same offset); [12463964160, 12472352768) became a hole.
The item stays the last one of its leaf, and the next leaf (350879744)
is shared, so the tree comparison never reports the following extent
item.


What does not trigger it
------------------------

All of these were received correctly on the same kernels:

- punching a hole in the middle of an extent
- FALLOC_FL_ZERO_RANGE (prealloc extent)
- trimming the tail of an extent followed by an existing hole, small file
- the same with 5000 extents, every extent trimmed (all leaves changed)
- trimming a tail, 2000 unchanged extents, then a changed extent later
- trimming the tail of an extent in the middle of a leaf

In a variant that trimmed leaf-last extents of 14 consecutive leaves
(plus one mid-leaf extent each), exactly one was received wrong: the
one whose following leaf was the only unchanged one.

My guess, without having read send.c closely: the hole behind a changed
extent item is only detected when the next extent item (or the end of
the inode) is processed; when the next item lives in a leaf that the
tree comparison skips as shared, nothing ever checks the range between
the shortened extent's new end and the next item.


Reproducer
----------

Needs root, python3, btrfs-progs. Creates a 2 GiB image in a temporary
directory (default /var/tmp), loop-mounts it, cleans up afterwards.

#!/bin/bash
# Reproducer: incremental btrfs send omits a hole created by trimming the tail
# of a file extent item that is the LAST item of its leaf, when the following
# leaf is unchanged (shared between parent and send snapshot).
# The receiver keeps the old data in that range.
#
# Runs on a fresh loop-mounted btrfs (default mkfs features, i.e. no-holes).
# Usage: sudo ./btrfs-send-trimmed-extent-repro.sh [workdir]
set -euo pipefail
[[ $EUID -eq 0 ]] || { echo "run as root" >&2; exit 1; }
W=$(mktemp -d "${1:-/var/tmp}/send-repro.XXXXXX")
IMG=$W/fs.img MNT=$W/mnt PY=$W/helper.py
cleanup() { umount "$MNT" 2>/dev/null || true; [[ -n ${LOOP:-} ]] &&
losetup -d "$LOOP" 2>/dev/null || true; rm -rf "$W"; }
trap cleanup EXIT

cat > "$PY" <<'PYEOF'
import ctypes, os, re, sys
K = 1024
STEP, DATA, CUT = 128 * K, 64 * K, 16 * K
cmd = sys.argv[1]
if cmd == "create":                 # n extents of 64 KiB data, 64 KiB
hole after each
    fd = os.open(sys.argv[2], os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o644)
    for i in range(int(sys.argv[3])):
        os.pwrite(fd, os.urandom(DATA), i * STEP)
    os.fsync(fd); os.close(fd)
elif cmd == "pick":                 # last EXTENT_DATA key of every
other leaf that has a successor leaf
    ino = int(sys.argv[2]); leaves, cur = [], None
    key = re.compile(r"^\titem \d+ key \((\d+) EXTENT_DATA (\d+)\)")
    for line in sys.stdin:
        if line.startswith("leaf ") and " items " in line:
            cur = []; leaves.append(cur); continue
        m = key.match(line)
        if m and cur is not None and int(m.group(1)) == ino:
            cur.append(int(m.group(2)))
    leaves = [l for l in leaves if l]
    for i in range(0, len(leaves) - 1, 2):
        print(leaves[i][-1])
elif cmd == "trim":                 # punch the last 16 KiB of the
extent at each offset
    libc = ctypes.CDLL(None, use_errno=True)
    libc.fallocate.argtypes = [ctypes.c_int, ctypes.c_int,
ctypes.c_longlong, ctypes.c_longlong]
    fd = os.open(sys.argv[2], os.O_RDWR)
    for off in map(int, sys.argv[3:]):
        if libc.fallocate(fd, 3, off + DATA - CUT, CUT):   # KEEP_SIZE
| PUNCH_HOLE
            raise OSError(ctypes.get_errno(), "fallocate")
    os.fsync(fd); os.close(fd)
elif cmd == "compare":              # count trimmed extents whose 64 KiB differ
    a, b = open(sys.argv[2], "rb"), open(sys.argv[3], "rb"); bad = 0
    offs = list(map(int, sys.argv[4:]))
    for off in offs:
        a.seek(off); b.seek(off)
        bad += a.read(DATA) != b.read(DATA)
    print(f"{bad} of {len(offs)} trimmed extents differ on the receiver")
PYEOF

truncate -s 2G "$IMG"
mkfs.btrfs -q "$IMG"
LOOP=$(losetup -f --show "$IMG")
mkdir "$MNT"; mount "$LOOP" "$MNT"
btrfs subvolume create "$MNT/src" >/dev/null
mkdir "$MNT/dst"

python3 -I "$PY" create "$MNT/src/f" 3000
btrfs subvolume snapshot -r "$MNT/src" "$MNT/s1" >/dev/null
btrfs filesystem sync "$MNT"
ino=$(stat -c %i "$MNT/s1/f")
offs=$(btrfs inspect-internal dump-tree -t "$(btrfs inspect-internal
rootid "$MNT/s1")" "$LOOP" | python3 -I "$PY" pick "$ino")
echo "leaf-last extents trimmed: $(wc -w <<< "$offs")"
# shellcheck disable=SC2086
python3 -I "$PY" trim "$MNT/src/f" $offs
btrfs subvolume snapshot -r "$MNT/src" "$MNT/s2" >/dev/null

btrfs send -q "$MNT/s1" | btrfs receive "$MNT/dst" >/dev/null 2>&1
btrfs send -q -p "$MNT/s1" "$MNT/s2" | btrfs receive "$MNT/dst" >/dev/null 2>&1
# shellcheck disable=SC2086
python3 -I "$PY" compare "$MNT/s2/f" "$MNT/dst/s2/f" $offs
cmp -s "$MNT/s2/f" "$MNT/dst/s2/f" && echo "whole file: identical" ||
echo "whole file: DIFFERS"
echo "kernel $(uname -r), $(btrfs --version)"

Thanks,
Tristan
