Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792614718;
	b=RKRCmE9RC2h8nn9Czuy/dLKtsRahZg5KRwiMPA+jBUcXXOHq5Q9YzVDKiG5tSYMoEan/
	 OTbzaJy+75RyrYCFgoF/4U0jDNC/os7b8eYhMiOcDvPw0LozxwXGMwYaGqJE/u+MIo1qn
	 +MYsqxldOyiO2/OllanXStkO70GGIEpnIs3ow3oe8XUX7j4/+0IZR5nmXXR23GYnw5bS0
	 RUgEllDFcf78B3nBAR4F/mntjA0Dr3ZQxqahXbQXNWQxhb5yDhE9spAglZXCP00AnKTI+
	 hSiy9xqJqfgujDlVk13DIcfXyXIrnGL7cRUzkF7AyFtbW6QdgZeu1RU05N6zmC9YHDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792614718;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=zBT6hoaq0mk2ig/axQ0e0ocxFB4zCVJ9cVtdjRym9L0=;
	b=3ZH5ImbWs5Y+drHe6aJT5T77tHNKt2EY1btTImPhPDuj5c2Ffqv+ORd14lsggsbojZDZ
	 Z4zBkYm8RLrt0uChWQYsRb0jZLdsMnq7L68AxACeUMUfp048P0O9WdWlH7NsaNbwsD67O
	 Mw+b+DV/Zig7R0wtqnTvzyZCp4NDHZcPnAJfsA+NiW47vjdxOG5p7wylTqtyB3n6Sm6TI
	 PVLg+poGxee6ZfrUHU1K9o0k3OBDoWpPyN5u4qbMDuda1Uy2mcebmWjDMWwq8XBOepMS8
	 fPa80EH7RW+AyLi0vt+w2LGmR+bnxxVgd1WVR1S91bBokoHh9LIHhxCaioF2x1DjZ6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AOQuZsRp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C4C606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 20:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AOQuZsRp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F69C1F000C1
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 20:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792614717;
	bh=zBT6hoaq0mk2ig/axQ0e0ocxFB4zCVJ9cVtdjRym9L0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AOQuZsRp6/GxwFi8Tc9piY3REENAv6f4Zb69vJbKTnOlH1OP/xl1TLfL2CmNDmpuW
	 IQSRx8rUo7WU95r04Khgtl84PZrQNczyb1f97X9pY3t5HdbrD12zmC/saYkjv9qnOH
	 /31Ph+F21P9CWG9CxsU6cdpjA0ZuHsjbjlck25XHPYRRndWSEKTvyK2ffHn8mdOWBX
	 7ZViz+FGgqkC09HfTXPd4iHgpad5vSWdirgMNRUTvVoMZ7qBAAY9VX1vFOICyucl2h
	 KRn3GHPra71BLRVC86WdjT/QtCdHso1tA4/0JW5oP0/ppGnrL/np74+1fwEh3RQG73
	 J1bMvMBzvOwvQ==
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-97ca72f2cd9so755380241.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 13:31:57 -0700 (PDT)
X-Gm-Message-State: AFq9FYIJH5kRDSDeVLDalkeZ1l8MOt3wurUeg9c2SvC2Bih0DJDvO/pE
	Za3J86KgbiBe01H41J5Flwtivvsfekw0PK5ddrvSp4XgnlJuNcxiYX2kajZYNrs4VCNmpC9IQsi
	19/6zYIkGqrew1RJX3QgNyouG1o7PQMc=
X-Received: by 2002:a05:6102:5801:b0:7c3:7286:c28a with SMTP id
 ada2fe7eead31-7cc926b1527mr1332256137.19.1792614716282; Wed, 21 Oct 2026
 13:31:56 -0700 (PDT)
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
 <CAL3q7H4JL0pWbGN-sQG7XCXeX60=fmxhSM-c-1xDka0eUbigKg@mail.gmail.com> <CAFoLKK+msAgM5tFx3w1n_i6TqHEWoSqULhidsNQA4qncK9weGw@mail.gmail.com>
In-Reply-To: <CAFoLKK+msAgM5tFx3w1n_i6TqHEWoSqULhidsNQA4qncK9weGw@mail.gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 21 Oct 2026 21:31:18 +0100
X-Gmail-Original-Message-ID: <CAL3q7H538OKkxD93rMZYgiwiZ+4VWwaEw4Nf+o1XDT5OYUeEeA@mail.gmail.com>
X-Gm-Features: AclHuK8ySlkZdP0moCvT-wu-5wf-yySmAmygDH-BRWgLJ6e7-WLbgiu2evZDcEw
Message-ID: <CAL3q7H538OKkxD93rMZYgiwiZ+4VWwaEw4Nf+o1XDT5OYUeEeA@mail.gmail.com>
Subject: Re: [BUG] incremental send omits hole after trimming the tail of a
 leaf-last file extent item (receiver keeps stale data)
To: Tristan Elvers <tristanelvers@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 12:25=E2=80=AFPM Tristan Elvers <tristanelvers@gmai=
l.com> wrote:
>
> Hi,
>
> thanks for the reply. Here are some more informations, I hope that helps.
>
> A follow-up after reading fs/btrfs/send.c (current master). I have not
> built or tested a change, so please take this as a pointer only.

Don't worry, I am familiar with the code, wrote large chunks of it as well.

Fix here:

https://lore.kernel.org/linux-btrfs/25a6b104e8af433508c425cd7470426470f811f=
2.1792613378.git.fdmanana@suse.com/

Thanks for the report.

>
> Holes in an incremental send are detected in maybe_send_hole(), which is
> called for every file extent item that btrfs_compare_trees() reports,
> CHANGED as well as SAME (changed_cb() forwards SAME extent items there).
> It checks the gap *before* the reported item, from
> sctx->cur_inode_last_extent up to key->offset, and then sets
> cur_inode_last_extent to the end of that item.
>
> SAME items are only reported from leaves that differ between the two
> roots. Leaves that are shared are skipped as a whole, so their items
> never reach maybe_send_hole().
>
> In the failing case the shortened item is the last one of its leaf.
> Its new end is stored in cur_inode_last_extent, but the gap behind it
> is only checked when the next extent item of the inode is reported, and
> that item is the first one of a shared leaf, so it is never reported.
> Two places could still catch it, and neither does:
>
> - If a later leaf of the same inode differs, maybe_send_hole() is called
>   at slot 0 there with cur_inode_last_extent < key->offset and
>   recomputes it with get_last_extent(sctx, key->offset - 1). This
>   replaces the pending end with the end of the item just before the
>   current one, which is in the skipped leaf, so the gap behind the
>   shortened item is lost. (If the shortened item's leaf is directly
>   followed by the changed leaf, the recomputed value is the shortened
>   item's own end and the hole is sent, which matches what I saw: only
>   the extent followed by an unchanged leaf was received wrong.)
>
> - finish_inode_if_needed() calls get_last_extent(sctx, (u64)-1), which
>   looks at the last extent item of the inode, so it only checks the
>   range up to i_size.
>
> So a range between the end of a changed extent item and the next
> extent item is never checked when that next item lives in a shared
> leaf. One way to close it might be to check the gap behind the last
> reported extent item before cur_inode_last_extent is replaced at slot 0,
> and in finish_inode_if_needed(), against the next extent item in the
> send root rather than the last one. But you will know better where this
> belongs.
>
>
> System information
> ------------------
>
> The bug reproduces on a fresh loop filesystem with mkfs defaults (see
> the reproducer in my first mail), so the filesystems below are not
> needed to trigger it. For completeness, the real case was sent from
> /data/vm-ssd to /data/nas:
>
> $ uname -a
> Linux Nas-Server 7.2.11-200.fc44.x86_64 #1 SMP PREEMPT_DYNAMIC Thu Oct
> 15 15:58:58 UTC 2026 x86_64 GNU/Linux
>
> $ btrfs --version
> btrfs-progs v7.1
> -EXPERIMENTAL -INJECT -STATIC +LZO +ZSTD +UDEV +FSVERITY +ZONED CRYPTO=3D=
libgcrypt
>
> $ btrfs filesystem show /data/vm-ssd
> Label: 'vm-ssd'  uuid: 00e062ee-8a8a-4e14-a536-2b7c2c9d9c0f
>     Total devices 4 FS bytes used 111.63GiB
>     devid    1 size 238.46GiB used 64.03GiB path /dev/sdg
>     devid    2 size 238.46GiB used 64.00GiB path /dev/sdh
>     devid    3 size 238.46GiB used 63.03GiB path /dev/sdi
>     devid    4 size 232.89GiB used 63.00GiB path /dev/sde
>
> $ btrfs filesystem df /data/vm-ssd
> Data, RAID10: total=3D124.00GiB, used=3D109.94GiB
> System, RAID1: total=3D32.00MiB, used=3D16.00KiB
> Metadata, RAID1: total=3D3.00GiB, used=3D381.98MiB
> GlobalReserve, single: total=3D221.23MiB, used=3D0.00B
>
> $ btrfs filesystem show /data/nas
> Label: 'nas'  uuid: e02b9bf4-3186-40c3-ab60-f9cd85ae7a97
>     Total devices 3 FS bytes used 38.99TiB
>     devid    1 size 10.91TiB used 5.76TiB path /dev/sdk
>     devid    2 size 21.83TiB used 16.68TiB path /dev/sdl
>     devid    3 size 21.83TiB used 16.68TiB path /dev/sdm
>
> $ btrfs filesystem df /data/nas
> Data, single: total=3D39.01TiB, used=3D38.94TiB
> System, RAID1: total=3D8.00MiB, used=3D4.36MiB
> Metadata, RAID1: total=3D54.00GiB, used=3D44.14GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>
> Mount options: /data/vm-ssd noatime,compress=3Dzstd:1,ssd,space_cache=3Dv=
2;
> /data/nas noatime,compress=3Dzstd:10,space_cache=3Dv2,autodefrag.
>
> dmesg shows no btrfs warnings or errors around the sends; send and
> receive both exit 0.
>
> Thanks,
> Tristan
>
> Am Mi., 21. Okt. 2026 um 13:12 Uhr schrieb Filipe Manana <fdmanana@kernel=
.org>:
> >
> > On Wed, Oct 21, 2026 at 11:42=E2=80=AFAM Tristan Elvers <tristanelvers@=
gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > First of all, I found this bug with the help of Claude. The problem
> > > occurred in the production environment; we weren't specifically
> > > looking for an issue.
> > > Unfortunately, I don't know much about coding myself, so I can't
> > > contribute much personally, on this matter, but I hope this issue
> > > doesn't turn out to be a false alarm and that it can be resolved.
> > > Please do not hesitate to contact me if you have any queries.
> > >
> > > Here is the Information I got from Claude:
> > > An incremental "btrfs send -p" silently omits a hole when the tail of=
 a
> > > file extent item is punched away, the item is the last item of its le=
af,
> > > and the following leaf is unchanged between parent and send snapshot.
> > > The receiver keeps the old data in the punched range, so the received
> > > file differs from the source without any error. Full sends are correc=
t.
> > >
> > > Seen on 7.2.9 and 7.2.11 (Fedora 7.2.11-200.fc44.x86_64), btrfs-progs
> > > 7.1, no-holes enabled (mkfs default). A self-contained reproducer is
> > > included below; on a fresh 2 GiB loop filesystem it gives:
> > >
> > >     leaf-last extents trimmed: 7
> > >     7 of 7 trimmed extents differ on the receiver
> > >     whole file: DIFFERS
> > >
> > > The result is the same with "btrfs send --proto 2", so this is not th=
e
> > > v1-only zero-writing behaviour discussed in btrfs-progs issue #1001
> > > (fixed by "btrfs: send: use fallocate for hole punching with send
> > > stream v2"): with v1 the stream contains no command for the punched
> > > range (checked with receive --dump, see below), not even a write of
> > > zeroes, and with v2 the receiver keeps the stale data just the same.
> > > The hole seems to be missed before the stream format comes into play.
> > >
> > >
> > > How it was found
> > > ----------------
> > >
> > > A nightly backup sends read-only snapshots of a VM disk image (qcow2,
> > > qemu with discard=3D'unmap') incrementally to a second btrfs filesyst=
em
> > > and compares checksums afterwards. After the guest ran fstrim, qemu
> > > punched a hole at the end of an existing extent. From then on the
> > > received copy differed: 8 MiB at offset 12463964160 were a hole in th=
e
> > > source snapshot but still contained the parent's data on the receiver=
.
> > >
> > > "btrfs send -p PARENT SNAP | btrfs receive --dump" contains no comman=
d
> > > at all touching that range (79480 write and 311 clone commands in
> > > total, none overlapping it).
> > >
> > > File extent items of that inode (dump-tree of the snapshot roots):
> > >
> > > parent snapshot:
> > >   leaf 935723008 items 174 free space 2711 generation 41670 owner 257
> > >     item 172 key (257 EXTENT_DATA 12454526976) itemoff 7114 itemsize =
53
> > >         generation 18 type 1 (regular)
> > >         extent data disk byte 26447552512 nr 67174400
> > >         extent data offset 73728 nr 5242880 ram 67174400
> > >     item 173 key (257 EXTENT_DATA 12461342720) itemoff 7061 itemsize =
53
> > >         generation 18 type 1 (regular)
> > >         extent data disk byte 26447552512 nr 67174400
> > >         extent data offset 6889472 nr 11010048 ram 67174400
> > >   leaf 350879744 items 208 free space 59 generation 41657 owner 257
> > >     item 0 key (257 EXTENT_DATA 12473139200) itemoff 16230 itemsize 5=
3
> > >         generation 18 type 1 (regular)
> > >         extent data disk byte 26447552512 nr 67174400
> > >         extent data offset 18685952 nr 720896 ram 67174400
> > >
> > > send snapshot:
> > >   leaf 126293196800 items 173 free space 2789 generation 49841 owner =
257
> > >     item 171 key (257 EXTENT_DATA 12454526976) itemoff 7167 itemsize =
53
> > >         ...
> > >     item 172 key (257 EXTENT_DATA 12461342720) itemoff 7114 itemsize =
53
> > >         generation 18 type 1 (regular)
> > >         extent data disk byte 26447552512 nr 67174400
> > >         extent data offset 6889472 nr 2621440 ram 67174400
> > >   leaf 350879744 items 208 free space 59 generation 41657 owner 257
> > >     (same leaf as in the parent)
> >
> > Thanks for the report, I'll send a fix for this soon and let you know.
> >
> > >
> > > So the item at 12461342720 shrank from 11010048 to 2621440 bytes (sam=
e
> > > disk extent, same offset); [12463964160, 12472352768) became a hole.
> > > The item stays the last one of its leaf, and the next leaf (350879744=
)
> > > is shared, so the tree comparison never reports the following extent
> > > item.
> > >
> > >
> > > What does not trigger it
> > > ------------------------
> > >
> > > All of these were received correctly on the same kernels:
> > >
> > > - punching a hole in the middle of an extent
> > > - FALLOC_FL_ZERO_RANGE (prealloc extent)
> > > - trimming the tail of an extent followed by an existing hole, small =
file
> > > - the same with 5000 extents, every extent trimmed (all leaves change=
d)
> > > - trimming a tail, 2000 unchanged extents, then a changed extent late=
r
> > > - trimming the tail of an extent in the middle of a leaf
> > >
> > > In a variant that trimmed leaf-last extents of 14 consecutive leaves
> > > (plus one mid-leaf extent each), exactly one was received wrong: the
> > > one whose following leaf was the only unchanged one.
> > >
> > > My guess, without having read send.c closely: the hole behind a chang=
ed
> > > extent item is only detected when the next extent item (or the end of
> > > the inode) is processed; when the next item lives in a leaf that the
> > > tree comparison skips as shared, nothing ever checks the range betwee=
n
> > > the shortened extent's new end and the next item.
> > >
> > >
> > > Reproducer
> > > ----------
> > >
> > > Needs root, python3, btrfs-progs. Creates a 2 GiB image in a temporar=
y
> > > directory (default /var/tmp), loop-mounts it, cleans up afterwards.
> > >
> > > #!/bin/bash
> > > # Reproducer: incremental btrfs send omits a hole created by trimming=
 the tail
> > > # of a file extent item that is the LAST item of its leaf, when the f=
ollowing
> > > # leaf is unchanged (shared between parent and send snapshot).
> > > # The receiver keeps the old data in that range.
> > > #
> > > # Runs on a fresh loop-mounted btrfs (default mkfs features, i.e. no-=
holes).
> > > # Usage: sudo ./btrfs-send-trimmed-extent-repro.sh [workdir]
> > > set -euo pipefail
> > > [[ $EUID -eq 0 ]] || { echo "run as root" >&2; exit 1; }
> > > W=3D$(mktemp -d "${1:-/var/tmp}/send-repro.XXXXXX")
> > > IMG=3D$W/fs.img MNT=3D$W/mnt PY=3D$W/helper.py
> > > cleanup() { umount "$MNT" 2>/dev/null || true; [[ -n ${LOOP:-} ]] &&
> > > losetup -d "$LOOP" 2>/dev/null || true; rm -rf "$W"; }
> > > trap cleanup EXIT
> > >
> > > cat > "$PY" <<'PYEOF'
> > > import ctypes, os, re, sys
> > > K =3D 1024
> > > STEP, DATA, CUT =3D 128 * K, 64 * K, 16 * K
> > > cmd =3D sys.argv[1]
> > > if cmd =3D=3D "create":                 # n extents of 64 KiB data, 6=
4 KiB
> > > hole after each
> > >     fd =3D os.open(sys.argv[2], os.O_WRONLY | os.O_CREAT | os.O_TRUNC=
, 0o644)
> > >     for i in range(int(sys.argv[3])):
> > >         os.pwrite(fd, os.urandom(DATA), i * STEP)
> > >     os.fsync(fd); os.close(fd)
> > > elif cmd =3D=3D "pick":                 # last EXTENT_DATA key of eve=
ry
> > > other leaf that has a successor leaf
> > >     ino =3D int(sys.argv[2]); leaves, cur =3D [], None
> > >     key =3D re.compile(r"^\titem \d+ key \((\d+) EXTENT_DATA (\d+)\)"=
)
> > >     for line in sys.stdin:
> > >         if line.startswith("leaf ") and " items " in line:
> > >             cur =3D []; leaves.append(cur); continue
> > >         m =3D key.match(line)
> > >         if m and cur is not None and int(m.group(1)) =3D=3D ino:
> > >             cur.append(int(m.group(2)))
> > >     leaves =3D [l for l in leaves if l]
> > >     for i in range(0, len(leaves) - 1, 2):
> > >         print(leaves[i][-1])
> > > elif cmd =3D=3D "trim":                 # punch the last 16 KiB of th=
e
> > > extent at each offset
> > >     libc =3D ctypes.CDLL(None, use_errno=3DTrue)
> > >     libc.fallocate.argtypes =3D [ctypes.c_int, ctypes.c_int,
> > > ctypes.c_longlong, ctypes.c_longlong]
> > >     fd =3D os.open(sys.argv[2], os.O_RDWR)
> > >     for off in map(int, sys.argv[3:]):
> > >         if libc.fallocate(fd, 3, off + DATA - CUT, CUT):   # KEEP_SIZ=
E
> > > | PUNCH_HOLE
> > >             raise OSError(ctypes.get_errno(), "fallocate")
> > >     os.fsync(fd); os.close(fd)
> > > elif cmd =3D=3D "compare":              # count trimmed extents whose=
 64 KiB differ
> > >     a, b =3D open(sys.argv[2], "rb"), open(sys.argv[3], "rb"); bad =
=3D 0
> > >     offs =3D list(map(int, sys.argv[4:]))
> > >     for off in offs:
> > >         a.seek(off); b.seek(off)
> > >         bad +=3D a.read(DATA) !=3D b.read(DATA)
> > >     print(f"{bad} of {len(offs)} trimmed extents differ on the receiv=
er")
> > > PYEOF
> > >
> > > truncate -s 2G "$IMG"
> > > mkfs.btrfs -q "$IMG"
> > > LOOP=3D$(losetup -f --show "$IMG")
> > > mkdir "$MNT"; mount "$LOOP" "$MNT"
> > > btrfs subvolume create "$MNT/src" >/dev/null
> > > mkdir "$MNT/dst"
> > >
> > > python3 -I "$PY" create "$MNT/src/f" 3000
> > > btrfs subvolume snapshot -r "$MNT/src" "$MNT/s1" >/dev/null
> > > btrfs filesystem sync "$MNT"
> > > ino=3D$(stat -c %i "$MNT/s1/f")
> > > offs=3D$(btrfs inspect-internal dump-tree -t "$(btrfs inspect-interna=
l
> > > rootid "$MNT/s1")" "$LOOP" | python3 -I "$PY" pick "$ino")
> > > echo "leaf-last extents trimmed: $(wc -w <<< "$offs")"
> > > # shellcheck disable=3DSC2086
> > > python3 -I "$PY" trim "$MNT/src/f" $offs
> > > btrfs subvolume snapshot -r "$MNT/src" "$MNT/s2" >/dev/null
> > >
> > > btrfs send -q "$MNT/s1" | btrfs receive "$MNT/dst" >/dev/null 2>&1
> > > btrfs send -q -p "$MNT/s1" "$MNT/s2" | btrfs receive "$MNT/dst" >/dev=
/null 2>&1
> > > # shellcheck disable=3DSC2086
> > > python3 -I "$PY" compare "$MNT/s2/f" "$MNT/dst/s2/f" $offs
> > > cmp -s "$MNT/s2/f" "$MNT/dst/s2/f" && echo "whole file: identical" ||
> > > echo "whole file: DIFFERS"
> > > echo "kernel $(uname -r), $(btrfs --version)"
> > >
> > > Thanks,
> > > Tristan
> > >
>
> Am Mi., 21. Okt. 2026 um 13:12 Uhr schrieb Filipe Manana <fdmanana@kernel=
.org>:
> >
> > On Wed, Oct 21, 2026 at 11:42=E2=80=AFAM Tristan Elvers <tristanelvers@=
gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > First of all, I found this bug with the help of Claude. The problem
> > > occurred in the production environment; we weren't specifically
> > > looking for an issue.
> > > Unfortunately, I don't know much about coding myself, so I can't
> > > contribute much personally, on this matter, but I hope this issue
> > > doesn't turn out to be a false alarm and that it can be resolved.
> > > Please do not hesitate to contact me if you have any queries.
> > >
> > > Here is the Information I got from Claude:
> > > An incremental "btrfs send -p" silently omits a hole when the tail of=
 a
> > > file extent item is punched away, the item is the last item of its le=
af,
> > > and the following leaf is unchanged between parent and send snapshot.
> > > The receiver keeps the old data in the punched range, so the received
> > > file differs from the source without any error. Full sends are correc=
t.
> > >
> > > Seen on 7.2.9 and 7.2.11 (Fedora 7.2.11-200.fc44.x86_64), btrfs-progs
> > > 7.1, no-holes enabled (mkfs default). A self-contained reproducer is
> > > included below; on a fresh 2 GiB loop filesystem it gives:
> > >
> > >     leaf-last extents trimmed: 7
> > >     7 of 7 trimmed extents differ on the receiver
> > >     whole file: DIFFERS
> > >
> > > The result is the same with "btrfs send --proto 2", so this is not th=
e
> > > v1-only zero-writing behaviour discussed in btrfs-progs issue #1001
> > > (fixed by "btrfs: send: use fallocate for hole punching with send
> > > stream v2"): with v1 the stream contains no command for the punched
> > > range (checked with receive --dump, see below), not even a write of
> > > zeroes, and with v2 the receiver keeps the stale data just the same.
> > > The hole seems to be missed before the stream format comes into play.
> > >
> > >
> > > How it was found
> > > ----------------
> > >
> > > A nightly backup sends read-only snapshots of a VM disk image (qcow2,
> > > qemu with discard=3D'unmap') incrementally to a second btrfs filesyst=
em
> > > and compares checksums afterwards. After the guest ran fstrim, qemu
> > > punched a hole at the end of an existing extent. From then on the
> > > received copy differed: 8 MiB at offset 12463964160 were a hole in th=
e
> > > source snapshot but still contained the parent's data on the receiver=
.
> > >
> > > "btrfs send -p PARENT SNAP | btrfs receive --dump" contains no comman=
d
> > > at all touching that range (79480 write and 311 clone commands in
> > > total, none overlapping it).
> > >
> > > File extent items of that inode (dump-tree of the snapshot roots):
> > >
> > > parent snapshot:
> > >   leaf 935723008 items 174 free space 2711 generation 41670 owner 257
> > >     item 172 key (257 EXTENT_DATA 12454526976) itemoff 7114 itemsize =
53
> > >         generation 18 type 1 (regular)
> > >         extent data disk byte 26447552512 nr 67174400
> > >         extent data offset 73728 nr 5242880 ram 67174400
> > >     item 173 key (257 EXTENT_DATA 12461342720) itemoff 7061 itemsize =
53
> > >         generation 18 type 1 (regular)
> > >         extent data disk byte 26447552512 nr 67174400
> > >         extent data offset 6889472 nr 11010048 ram 67174400
> > >   leaf 350879744 items 208 free space 59 generation 41657 owner 257
> > >     item 0 key (257 EXTENT_DATA 12473139200) itemoff 16230 itemsize 5=
3
> > >         generation 18 type 1 (regular)
> > >         extent data disk byte 26447552512 nr 67174400
> > >         extent data offset 18685952 nr 720896 ram 67174400
> > >
> > > send snapshot:
> > >   leaf 126293196800 items 173 free space 2789 generation 49841 owner =
257
> > >     item 171 key (257 EXTENT_DATA 12454526976) itemoff 7167 itemsize =
53
> > >         ...
> > >     item 172 key (257 EXTENT_DATA 12461342720) itemoff 7114 itemsize =
53
> > >         generation 18 type 1 (regular)
> > >         extent data disk byte 26447552512 nr 67174400
> > >         extent data offset 6889472 nr 2621440 ram 67174400
> > >   leaf 350879744 items 208 free space 59 generation 41657 owner 257
> > >     (same leaf as in the parent)
> >
> > Thanks for the report, I'll send a fix for this soon and let you know.
> >
> > >
> > > So the item at 12461342720 shrank from 11010048 to 2621440 bytes (sam=
e
> > > disk extent, same offset); [12463964160, 12472352768) became a hole.
> > > The item stays the last one of its leaf, and the next leaf (350879744=
)
> > > is shared, so the tree comparison never reports the following extent
> > > item.
> > >
> > >
> > > What does not trigger it
> > > ------------------------
> > >
> > > All of these were received correctly on the same kernels:
> > >
> > > - punching a hole in the middle of an extent
> > > - FALLOC_FL_ZERO_RANGE (prealloc extent)
> > > - trimming the tail of an extent followed by an existing hole, small =
file
> > > - the same with 5000 extents, every extent trimmed (all leaves change=
d)
> > > - trimming a tail, 2000 unchanged extents, then a changed extent late=
r
> > > - trimming the tail of an extent in the middle of a leaf
> > >
> > > In a variant that trimmed leaf-last extents of 14 consecutive leaves
> > > (plus one mid-leaf extent each), exactly one was received wrong: the
> > > one whose following leaf was the only unchanged one.
> > >
> > > My guess, without having read send.c closely: the hole behind a chang=
ed
> > > extent item is only detected when the next extent item (or the end of
> > > the inode) is processed; when the next item lives in a leaf that the
> > > tree comparison skips as shared, nothing ever checks the range betwee=
n
> > > the shortened extent's new end and the next item.
> > >
> > >
> > > Reproducer
> > > ----------
> > >
> > > Needs root, python3, btrfs-progs. Creates a 2 GiB image in a temporar=
y
> > > directory (default /var/tmp), loop-mounts it, cleans up afterwards.
> > >
> > > #!/bin/bash
> > > # Reproducer: incremental btrfs send omits a hole created by trimming=
 the tail
> > > # of a file extent item that is the LAST item of its leaf, when the f=
ollowing
> > > # leaf is unchanged (shared between parent and send snapshot).
> > > # The receiver keeps the old data in that range.
> > > #
> > > # Runs on a fresh loop-mounted btrfs (default mkfs features, i.e. no-=
holes).
> > > # Usage: sudo ./btrfs-send-trimmed-extent-repro.sh [workdir]
> > > set -euo pipefail
> > > [[ $EUID -eq 0 ]] || { echo "run as root" >&2; exit 1; }
> > > W=3D$(mktemp -d "${1:-/var/tmp}/send-repro.XXXXXX")
> > > IMG=3D$W/fs.img MNT=3D$W/mnt PY=3D$W/helper.py
> > > cleanup() { umount "$MNT" 2>/dev/null || true; [[ -n ${LOOP:-} ]] &&
> > > losetup -d "$LOOP" 2>/dev/null || true; rm -rf "$W"; }
> > > trap cleanup EXIT
> > >
> > > cat > "$PY" <<'PYEOF'
> > > import ctypes, os, re, sys
> > > K =3D 1024
> > > STEP, DATA, CUT =3D 128 * K, 64 * K, 16 * K
> > > cmd =3D sys.argv[1]
> > > if cmd =3D=3D "create":                 # n extents of 64 KiB data, 6=
4 KiB
> > > hole after each
> > >     fd =3D os.open(sys.argv[2], os.O_WRONLY | os.O_CREAT | os.O_TRUNC=
, 0o644)
> > >     for i in range(int(sys.argv[3])):
> > >         os.pwrite(fd, os.urandom(DATA), i * STEP)
> > >     os.fsync(fd); os.close(fd)
> > > elif cmd =3D=3D "pick":                 # last EXTENT_DATA key of eve=
ry
> > > other leaf that has a successor leaf
> > >     ino =3D int(sys.argv[2]); leaves, cur =3D [], None
> > >     key =3D re.compile(r"^\titem \d+ key \((\d+) EXTENT_DATA (\d+)\)"=
)
> > >     for line in sys.stdin:
> > >         if line.startswith("leaf ") and " items " in line:
> > >             cur =3D []; leaves.append(cur); continue
> > >         m =3D key.match(line)
> > >         if m and cur is not None and int(m.group(1)) =3D=3D ino:
> > >             cur.append(int(m.group(2)))
> > >     leaves =3D [l for l in leaves if l]
> > >     for i in range(0, len(leaves) - 1, 2):
> > >         print(leaves[i][-1])
> > > elif cmd =3D=3D "trim":                 # punch the last 16 KiB of th=
e
> > > extent at each offset
> > >     libc =3D ctypes.CDLL(None, use_errno=3DTrue)
> > >     libc.fallocate.argtypes =3D [ctypes.c_int, ctypes.c_int,
> > > ctypes.c_longlong, ctypes.c_longlong]
> > >     fd =3D os.open(sys.argv[2], os.O_RDWR)
> > >     for off in map(int, sys.argv[3:]):
> > >         if libc.fallocate(fd, 3, off + DATA - CUT, CUT):   # KEEP_SIZ=
E
> > > | PUNCH_HOLE
> > >             raise OSError(ctypes.get_errno(), "fallocate")
> > >     os.fsync(fd); os.close(fd)
> > > elif cmd =3D=3D "compare":              # count trimmed extents whose=
 64 KiB differ
> > >     a, b =3D open(sys.argv[2], "rb"), open(sys.argv[3], "rb"); bad =
=3D 0
> > >     offs =3D list(map(int, sys.argv[4:]))
> > >     for off in offs:
> > >         a.seek(off); b.seek(off)
> > >         bad +=3D a.read(DATA) !=3D b.read(DATA)
> > >     print(f"{bad} of {len(offs)} trimmed extents differ on the receiv=
er")
> > > PYEOF
> > >
> > > truncate -s 2G "$IMG"
> > > mkfs.btrfs -q "$IMG"
> > > LOOP=3D$(losetup -f --show "$IMG")
> > > mkdir "$MNT"; mount "$LOOP" "$MNT"
> > > btrfs subvolume create "$MNT/src" >/dev/null
> > > mkdir "$MNT/dst"
> > >
> > > python3 -I "$PY" create "$MNT/src/f" 3000
> > > btrfs subvolume snapshot -r "$MNT/src" "$MNT/s1" >/dev/null
> > > btrfs filesystem sync "$MNT"
> > > ino=3D$(stat -c %i "$MNT/s1/f")
> > > offs=3D$(btrfs inspect-internal dump-tree -t "$(btrfs inspect-interna=
l
> > > rootid "$MNT/s1")" "$LOOP" | python3 -I "$PY" pick "$ino")
> > > echo "leaf-last extents trimmed: $(wc -w <<< "$offs")"
> > > # shellcheck disable=3DSC2086
> > > python3 -I "$PY" trim "$MNT/src/f" $offs
> > > btrfs subvolume snapshot -r "$MNT/src" "$MNT/s2" >/dev/null
> > >
> > > btrfs send -q "$MNT/s1" | btrfs receive "$MNT/dst" >/dev/null 2>&1
> > > btrfs send -q -p "$MNT/s1" "$MNT/s2" | btrfs receive "$MNT/dst" >/dev=
/null 2>&1
> > > # shellcheck disable=3DSC2086
> > > python3 -I "$PY" compare "$MNT/s2/f" "$MNT/dst/s2/f" $offs
> > > cmp -s "$MNT/s2/f" "$MNT/dst/s2/f" && echo "whole file: identical" ||
> > > echo "whole file: DIFFERS"
> > > echo "kernel $(uname -r), $(btrfs --version)"
> > >
> > > Thanks,
> > > Tristan
> > >
