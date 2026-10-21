Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792581135;
	b=eOUTN9fIPmCzpgKJdAnRRSrjFdI4HNPuIq62YSGdFFjm56qDD66Rg99OKZTFCKQb7ESA
	 2HcKYyAObP90eFLFvbKRh+6fF99NgJjuGfKcqwz3rNCKepXwq86bpxgyvIMeJytWhGTXl
	 UsxgdOfI/loKlbS45l+kxApR9pvRo3GMSGbFR0/2smP821+f9WsdSeUfTCbWRwX8FdAYT
	 qcdi7xWODh1ZdsjrA1ziE07ufWDBZCLZ0KGZBnwxO2EMkPcv4QUZH3h1qvS7zRv/WQcJV
	 IshAVgADf79YuUEjhKSQ3PJGvXmEch/10X36FS26MB5miEh32pJn16id9v1xK7uaqQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792581135;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=Iy7z8NCiSutV/p4JXkrwJFK/GPFtvyw5FyY10nlD4Ww=;
	b=l/2R2JlVRzRntZYCtK1FTa3o4QeUnp5qFLL32fSFV9b34ovZyY0dzThOYkOprZTDMCjD
	 ijdQbBOOmupdqIszoO7Y1DO8xNVgDTqqke+vZAJHJ5852/S8hNR9wTHPSon0BVDpkcJyv
	 5Yp3NpjVunoEfUUaW3a2wILHg46UrskC60YEB7dfTsw+KYyQr/zT2HlOx/ihkqilVDhh9
	 FNG1oW+0oKT8xqMhfgOJElKTZNnbWQXLT2IX3mE4r31iK4y1kNax356RAvCCyAdZT7Fxx
	 g7fFz821ml0ly+pz+FQ+/8c6CCyrJbISJfgd/HGMcgXopN3Q0vvhiRcXG+Dc1U7s1bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i9oAvcYr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894C8606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 11:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i9oAvcYr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373921F000C9
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 11:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792581135;
	bh=Iy7z8NCiSutV/p4JXkrwJFK/GPFtvyw5FyY10nlD4Ww=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=i9oAvcYrToCCNs/hpUfy89VrtDBCR/j5pJq5GOnbniKX9jIdwYr9fnlGBmQufpGSG
	 da9hWd21637K81LHU40wQF348IjJKHEeD435N+bUyzEt13QhkZ6ON0uZBdRooThrQt
	 4svMclwnZQuEallYzkcGPmn2UxMQbxk2UbMx4jfQZV/H9eGZ2U6+Ts4qcvyx8txIsb
	 un4kaulzRuRx1rBpGRmnYKpevNEgqrOQwJd4yzalDYqDBSyezni+ZN/8LTCMxIteXd
	 3vIp7YIL3npfcxDq2YXdpWwMzBHGZsiorS+YAnexIHdeRwjtJ+lc0fYK3z17FCJMbH
	 Ty9QNzkrNkwRg==
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-98c8cbdb9daso155523241.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 04:12:15 -0700 (PDT)
X-Gm-Message-State: AFq9FYJA03JCbyxchfStsr1ULEaUWdJsZJS0XsbkEK4PLdWSYqvyHK0V
	/zLhGUDjMVfsr14BdNynvZ6bUFNDiepeUmxMQSoUwVkNzniDykPvPTrKYxDiMkcMtccvoGw8l6e
	/d9P/Z8XDJbTbPhwjNr/Rnj5p1IfdRWE=
X-Received: by 2002:a05:6102:5111:b0:7c3:7286:b7ea with SMTP id
 ada2fe7eead31-7cc9265da0emr504046137.17.1792581134342; Wed, 21 Oct 2026
 04:12:14 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAFoLKK+aErV4p6ZJPnVeH5SHQ5++0f=8ZgxPWe-E-CkeKBs8PA@mail.gmail.com>
In-Reply-To: <CAFoLKK+aErV4p6ZJPnVeH5SHQ5++0f=8ZgxPWe-E-CkeKBs8PA@mail.gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 21 Oct 2026 12:11:37 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4JL0pWbGN-sQG7XCXeX60=fmxhSM-c-1xDka0eUbigKg@mail.gmail.com>
X-Gm-Features: AclHuK8rZodcKxO4gBjfmdkesA7G-slrvGZonsHwlpxwoef5qo8ESifd6E9Mej8
Message-ID: <CAL3q7H4JL0pWbGN-sQG7XCXeX60=fmxhSM-c-1xDka0eUbigKg@mail.gmail.com>
Subject: Re: [BUG] incremental send omits hole after trimming the tail of a
 leaf-last file extent item (receiver keeps stale data)
To: Tristan Elvers <tristanelvers@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 11:42=E2=80=AFAM Tristan Elvers <tristanelvers@gmai=
l.com> wrote:
>
> Hi,
>
> First of all, I found this bug with the help of Claude. The problem
> occurred in the production environment; we weren't specifically
> looking for an issue.
> Unfortunately, I don't know much about coding myself, so I can't
> contribute much personally, on this matter, but I hope this issue
> doesn't turn out to be a false alarm and that it can be resolved.
> Please do not hesitate to contact me if you have any queries.
>
> Here is the Information I got from Claude:
> An incremental "btrfs send -p" silently omits a hole when the tail of a
> file extent item is punched away, the item is the last item of its leaf,
> and the following leaf is unchanged between parent and send snapshot.
> The receiver keeps the old data in the punched range, so the received
> file differs from the source without any error. Full sends are correct.
>
> Seen on 7.2.9 and 7.2.11 (Fedora 7.2.11-200.fc44.x86_64), btrfs-progs
> 7.1, no-holes enabled (mkfs default). A self-contained reproducer is
> included below; on a fresh 2 GiB loop filesystem it gives:
>
>     leaf-last extents trimmed: 7
>     7 of 7 trimmed extents differ on the receiver
>     whole file: DIFFERS
>
> The result is the same with "btrfs send --proto 2", so this is not the
> v1-only zero-writing behaviour discussed in btrfs-progs issue #1001
> (fixed by "btrfs: send: use fallocate for hole punching with send
> stream v2"): with v1 the stream contains no command for the punched
> range (checked with receive --dump, see below), not even a write of
> zeroes, and with v2 the receiver keeps the stale data just the same.
> The hole seems to be missed before the stream format comes into play.
>
>
> How it was found
> ----------------
>
> A nightly backup sends read-only snapshots of a VM disk image (qcow2,
> qemu with discard=3D'unmap') incrementally to a second btrfs filesystem
> and compares checksums afterwards. After the guest ran fstrim, qemu
> punched a hole at the end of an existing extent. From then on the
> received copy differed: 8 MiB at offset 12463964160 were a hole in the
> source snapshot but still contained the parent's data on the receiver.
>
> "btrfs send -p PARENT SNAP | btrfs receive --dump" contains no command
> at all touching that range (79480 write and 311 clone commands in
> total, none overlapping it).
>
> File extent items of that inode (dump-tree of the snapshot roots):
>
> parent snapshot:
>   leaf 935723008 items 174 free space 2711 generation 41670 owner 257
>     item 172 key (257 EXTENT_DATA 12454526976) itemoff 7114 itemsize 53
>         generation 18 type 1 (regular)
>         extent data disk byte 26447552512 nr 67174400
>         extent data offset 73728 nr 5242880 ram 67174400
>     item 173 key (257 EXTENT_DATA 12461342720) itemoff 7061 itemsize 53
>         generation 18 type 1 (regular)
>         extent data disk byte 26447552512 nr 67174400
>         extent data offset 6889472 nr 11010048 ram 67174400
>   leaf 350879744 items 208 free space 59 generation 41657 owner 257
>     item 0 key (257 EXTENT_DATA 12473139200) itemoff 16230 itemsize 53
>         generation 18 type 1 (regular)
>         extent data disk byte 26447552512 nr 67174400
>         extent data offset 18685952 nr 720896 ram 67174400
>
> send snapshot:
>   leaf 126293196800 items 173 free space 2789 generation 49841 owner 257
>     item 171 key (257 EXTENT_DATA 12454526976) itemoff 7167 itemsize 53
>         ...
>     item 172 key (257 EXTENT_DATA 12461342720) itemoff 7114 itemsize 53
>         generation 18 type 1 (regular)
>         extent data disk byte 26447552512 nr 67174400
>         extent data offset 6889472 nr 2621440 ram 67174400
>   leaf 350879744 items 208 free space 59 generation 41657 owner 257
>     (same leaf as in the parent)

Thanks for the report, I'll send a fix for this soon and let you know.

>
> So the item at 12461342720 shrank from 11010048 to 2621440 bytes (same
> disk extent, same offset); [12463964160, 12472352768) became a hole.
> The item stays the last one of its leaf, and the next leaf (350879744)
> is shared, so the tree comparison never reports the following extent
> item.
>
>
> What does not trigger it
> ------------------------
>
> All of these were received correctly on the same kernels:
>
> - punching a hole in the middle of an extent
> - FALLOC_FL_ZERO_RANGE (prealloc extent)
> - trimming the tail of an extent followed by an existing hole, small file
> - the same with 5000 extents, every extent trimmed (all leaves changed)
> - trimming a tail, 2000 unchanged extents, then a changed extent later
> - trimming the tail of an extent in the middle of a leaf
>
> In a variant that trimmed leaf-last extents of 14 consecutive leaves
> (plus one mid-leaf extent each), exactly one was received wrong: the
> one whose following leaf was the only unchanged one.
>
> My guess, without having read send.c closely: the hole behind a changed
> extent item is only detected when the next extent item (or the end of
> the inode) is processed; when the next item lives in a leaf that the
> tree comparison skips as shared, nothing ever checks the range between
> the shortened extent's new end and the next item.
>
>
> Reproducer
> ----------
>
> Needs root, python3, btrfs-progs. Creates a 2 GiB image in a temporary
> directory (default /var/tmp), loop-mounts it, cleans up afterwards.
>
> #!/bin/bash
> # Reproducer: incremental btrfs send omits a hole created by trimming the=
 tail
> # of a file extent item that is the LAST item of its leaf, when the follo=
wing
> # leaf is unchanged (shared between parent and send snapshot).
> # The receiver keeps the old data in that range.
> #
> # Runs on a fresh loop-mounted btrfs (default mkfs features, i.e. no-hole=
s).
> # Usage: sudo ./btrfs-send-trimmed-extent-repro.sh [workdir]
> set -euo pipefail
> [[ $EUID -eq 0 ]] || { echo "run as root" >&2; exit 1; }
> W=3D$(mktemp -d "${1:-/var/tmp}/send-repro.XXXXXX")
> IMG=3D$W/fs.img MNT=3D$W/mnt PY=3D$W/helper.py
> cleanup() { umount "$MNT" 2>/dev/null || true; [[ -n ${LOOP:-} ]] &&
> losetup -d "$LOOP" 2>/dev/null || true; rm -rf "$W"; }
> trap cleanup EXIT
>
> cat > "$PY" <<'PYEOF'
> import ctypes, os, re, sys
> K =3D 1024
> STEP, DATA, CUT =3D 128 * K, 64 * K, 16 * K
> cmd =3D sys.argv[1]
> if cmd =3D=3D "create":                 # n extents of 64 KiB data, 64 Ki=
B
> hole after each
>     fd =3D os.open(sys.argv[2], os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o=
644)
>     for i in range(int(sys.argv[3])):
>         os.pwrite(fd, os.urandom(DATA), i * STEP)
>     os.fsync(fd); os.close(fd)
> elif cmd =3D=3D "pick":                 # last EXTENT_DATA key of every
> other leaf that has a successor leaf
>     ino =3D int(sys.argv[2]); leaves, cur =3D [], None
>     key =3D re.compile(r"^\titem \d+ key \((\d+) EXTENT_DATA (\d+)\)")
>     for line in sys.stdin:
>         if line.startswith("leaf ") and " items " in line:
>             cur =3D []; leaves.append(cur); continue
>         m =3D key.match(line)
>         if m and cur is not None and int(m.group(1)) =3D=3D ino:
>             cur.append(int(m.group(2)))
>     leaves =3D [l for l in leaves if l]
>     for i in range(0, len(leaves) - 1, 2):
>         print(leaves[i][-1])
> elif cmd =3D=3D "trim":                 # punch the last 16 KiB of the
> extent at each offset
>     libc =3D ctypes.CDLL(None, use_errno=3DTrue)
>     libc.fallocate.argtypes =3D [ctypes.c_int, ctypes.c_int,
> ctypes.c_longlong, ctypes.c_longlong]
>     fd =3D os.open(sys.argv[2], os.O_RDWR)
>     for off in map(int, sys.argv[3:]):
>         if libc.fallocate(fd, 3, off + DATA - CUT, CUT):   # KEEP_SIZE
> | PUNCH_HOLE
>             raise OSError(ctypes.get_errno(), "fallocate")
>     os.fsync(fd); os.close(fd)
> elif cmd =3D=3D "compare":              # count trimmed extents whose 64 =
KiB differ
>     a, b =3D open(sys.argv[2], "rb"), open(sys.argv[3], "rb"); bad =3D 0
>     offs =3D list(map(int, sys.argv[4:]))
>     for off in offs:
>         a.seek(off); b.seek(off)
>         bad +=3D a.read(DATA) !=3D b.read(DATA)
>     print(f"{bad} of {len(offs)} trimmed extents differ on the receiver")
> PYEOF
>
> truncate -s 2G "$IMG"
> mkfs.btrfs -q "$IMG"
> LOOP=3D$(losetup -f --show "$IMG")
> mkdir "$MNT"; mount "$LOOP" "$MNT"
> btrfs subvolume create "$MNT/src" >/dev/null
> mkdir "$MNT/dst"
>
> python3 -I "$PY" create "$MNT/src/f" 3000
> btrfs subvolume snapshot -r "$MNT/src" "$MNT/s1" >/dev/null
> btrfs filesystem sync "$MNT"
> ino=3D$(stat -c %i "$MNT/s1/f")
> offs=3D$(btrfs inspect-internal dump-tree -t "$(btrfs inspect-internal
> rootid "$MNT/s1")" "$LOOP" | python3 -I "$PY" pick "$ino")
> echo "leaf-last extents trimmed: $(wc -w <<< "$offs")"
> # shellcheck disable=3DSC2086
> python3 -I "$PY" trim "$MNT/src/f" $offs
> btrfs subvolume snapshot -r "$MNT/src" "$MNT/s2" >/dev/null
>
> btrfs send -q "$MNT/s1" | btrfs receive "$MNT/dst" >/dev/null 2>&1
> btrfs send -q -p "$MNT/s1" "$MNT/s2" | btrfs receive "$MNT/dst" >/dev/nul=
l 2>&1
> # shellcheck disable=3DSC2086
> python3 -I "$PY" compare "$MNT/s2/f" "$MNT/dst/s2/f" $offs
> cmp -s "$MNT/s2/f" "$MNT/dst/s2/f" && echo "whole file: identical" ||
> echo "whole file: DIFFERS"
> echo "kernel $(uname -r), $(btrfs --version)"
>
> Thanks,
> Tristan
>
