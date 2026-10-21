Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792581929;
	b=zyAlsYpnNTxzVqbtfN/sNDkJTbSQnlz9plIdsjZdt2A3+85uk5Cd/M9OFa4RtfwTafmW
	 xZRjvjNLu0fZsq2I9YMNixYb/YE1iFH+L35p9kmP7H62aPhbOHUgK6gSJ9SM80W/1JS4i
	 QbCdPE9v0g4M9W8rhahbtN9Yx4y0SNN/AfL0IYME8jbCWy/sOLtqs0Kg0K8ZiVb/GUjU3
	 aorud/puygw4siegxkIrVhZf8jOY8lW8BZqT2g83L5l5bxSeIUOX858k0XQXjbhitPtF7
	 ZZdrt7+5WtuiyUnK5dLI3i/k4WPLcS/1en6sXPC6fyHKXoeaelgBe2LF0Th90/+BzdQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792581929;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=BR6V1LBtSlpsteDZXpnc72JxiEOB0ujm+xXkUZkV3kQ=;
	b=uzwTLv8KTCBbaV9zuFB9idM1OukQyofVr58Pwn3HBBIQ7IUfWmvAmNiIIX20At6zbhly
	 FeglyaITd2yrkFrS8NrvAsmc9tgHNn75StzFEy06POS8yXqXzKKFs0wxnB/IsDWsMnJiu
	 wwv4Hf+djwVfE+JHiWF4S9CHtncM8BRIWwFEvpYeWGS8CRnWooCMnFKexP1avP10s6EYK
	 /GvmNspRs/tG1wg/Ms4ZC2VZnlTEari3fqqO1ItGUsSJdf/Jbsv4YeUDJcHW3c1joeOle
	 3qe3u9xbz58pG9I/j2SpJEPiG1WnF8uUdmdvbUCwlC8sd+4Xkq+nJI7VAWHBlm6HAlg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XX5r0VZW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.46
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B3F606A31D
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 11:25:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3B3F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XX5r0VZW
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-9908346255fso721956241.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 04:25:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792581928; cv=none;
        d=google.com; s=arc-20260327;
        b=HZqIWQPE6Ndea9ge7nE6oWxaTsy/NVc1TllUA681uLOjiLooqZvLTvUrW2kSjWDlaV
         s/gSg/XnJKJ68sxc95GxcAEZ3o/t3FdRVVULZ+KEcxCRtyxQCz/JRL+fLXWVVTTh/520
         oRJBJiG9KzjZ7C1nQZWjWPy8ZZITAbAiDrM3t/9xA9SUHLEVs5NG+0TGTSmt9UvAshwD
         Iid29OmLWM/7tKFMP27wbEl74LqkG/mlDOgz2pkRP44paLAX8032o2V2RvQGx4C+CaUe
         VKvdiXBu6HsSoB7UO+1uCEOu8pprW9a6/SvNUn7DaMZaKduUkVRS5YjURInpszHgSO7Z
         dC0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BR6V1LBtSlpsteDZXpnc72JxiEOB0ujm+xXkUZkV3kQ=;
        fh=v5SypDb7dwdS4FGwcK5CeDhaQb47iUab0gtYlsnNpvI=;
        b=nO0oUD0mooN2HE1HM5BtUZFt10aXawYNp9bBHMLJ5MrW6J9Gvwck/D24ntHIEuQ7pH
         Z38ZdWbnT6e33z6bvsitKQz4obiT8Us2yn8HHpwDfXYSprC9mI+tAgkhGlk7hH8eDBaz
         3iHjtaRd9grFkBFg69IHNORbH6V9M29WEiR1ubA7yJ+4UXDXw4U4q3JL5cI8V8t0l8cM
         OXEhaTUSfkSqvNMprV93ZIkAXD8bHaCxronHvHNL10SC76zm1zrHSC/qqf6YTvjc3eb5
         WI1fmWMJLQozZqAZTyZV9uU1dkKw6UoTb2Ie7irHzVqv7YECH93MGm1D92RIminmInWD
         /m/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792581928; x=1793186728; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BR6V1LBtSlpsteDZXpnc72JxiEOB0ujm+xXkUZkV3kQ=;
        b=XX5r0VZW2mcvOCE+edVV4z0IfPm0HrwoTWY/a0XGx0EBBGiyoMerVHD4S9u91NeOi9
         i43mX1SJkZ9dFCKLfNVPUT8S5jF7vVBbkQz+dJTIEB4zgN8mLuKDOHFgsOBcdQqYvwPK
         dCGQh1b9Mpsz7gA/ECoaGLNbQFrJZdPMYpcTHURVGzZ9X1OOW1TNBvSPCpBcRTb6FnNZ
         o4usi4lZBXXcKQCNQERFIMSM7eFDGDS8fubDhruyBaN3zc5g3/Y523uKLFkLDnpIMihK
         Lun3GnyaIm4iDskaSxl7JItkd3nHXlMTnHc36kgs8nZW25sMXXcXXwmQCCmVZKSoDH3E
         L3Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792581928; x=1793186728;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BR6V1LBtSlpsteDZXpnc72JxiEOB0ujm+xXkUZkV3kQ=;
        b=tS1LN5JkFt2t8I2n26bZ7cBlsHveaBtAM7WTX0rnRBVDtFz9TfhtEsX32e//P0EwSP
         WNPFQfPu6lA/bryxMCRoQVgW6Zpd4rOLwbAknkPSQIrZwgckM3gZS32qUgAA3Bg9fLKm
         Q4p7Y5OCIShBHAeIHWsGZ8/+sc7bQJVF+IO4zmiZSz78e4JaRnZ3FMGNkBZGJMvV1KPC
         2iJNaHGYuK1Oa1pg3+sWOv2LmXafCX8dnTZ7uQYx093aICbF7EhBcj8WQ8Pe4zn/Tfgw
         I9GDQ35tuKZyvgH1yOpCf+wsj843XqRRjtAMvJPxNRiuL9J+TC08xRU7ji4Ql329ZsUo
         xoXg==
X-Gm-Message-State: AFq9FYKswd7SkLJGKXZO3Yzht0fXLpr/NsAvUMH0yRMRR4yfYh7MJqRw
	OL4AWvRpedcgN/bT1Den2a6xtGnB/HoPut5VdNUnZ4tDxuj8/5Bld/hNmuAux8Dj+6CPIQYQ9st
	Nsc2MUt5BINeIq/Zh+zTOlVbCelE/BD7q+VOY8aMhpb7Y
X-Gm-Gg: AYBFou0WXtFmKTwmjt2Tq6dgywxKEWSYaxBzrcur4bGNHAngWJClT92GOEn4MC6XrWE
	jzFYSqa5wtHFpWZczwqB6y+04R3t77hQIvc/dvB+3B310EtnCwNvk1TjqiXt4n1jQLFRN9GEVrB
	RYgGv+0y5i+Y74zk6Bm1wuCawxBno5NLxXhBbiHJVWgQDwR5YXaXl/kPiE+3+sMCIPM6Q+NTG1s
	ivvyl6L08ZgnuM/ymDMI51HLs8+1Q2gHNV6JXoOK6GX3CAm7417ZFNxLildWLYyY+2KABa/HRK1
	Z3HeCxtZsxPuNQEiI17zPE3PnSrTUpQ7OypSXHWvYNKAdyTv7WanTGosfwQIizXzl5F+D3OBN3p
	b/mGP5Lqy9XtBx4g6CH+lM5u94eVI8Uc14rVO4RJGySGB7GYd9rwzX1x9PQhTW1/cc1nYGrmN2/
	wiuLcC3/SPWnwkwcHOg2I031ZBn9AHuhJ6qHuc
X-Received: by 2002:a05:6102:6a83:b0:7ba:95f3:8a07 with SMTP id
 ada2fe7eead31-7cc927fe1c6mr496454137.13.1792581927464; Wed, 21 Oct 2026
 04:25:27 -0700 (PDT)
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
 <CAL3q7H4JL0pWbGN-sQG7XCXeX60=fmxhSM-c-1xDka0eUbigKg@mail.gmail.com>
In-Reply-To: <CAL3q7H4JL0pWbGN-sQG7XCXeX60=fmxhSM-c-1xDka0eUbigKg@mail.gmail.com>
From: Tristan Elvers <tristanelvers@gmail.com>
Date: Wed, 21 Oct 2026 13:25:16 +0200
X-Gm-Features: AclHuK-sFxf2LF5KadGvJzKtvJUWJKSJTGx1nsl7gC4FUDxywJ8Ua7MLPB6MXS4
Message-ID: <CAFoLKK+msAgM5tFx3w1n_i6TqHEWoSqULhidsNQA4qncK9weGw@mail.gmail.com>
Subject: Re: [BUG] incremental send omits hole after trimming the tail of a
 leaf-last file extent item (receiver keeps stale data)
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

thanks for the reply. Here are some more informations, I hope that helps.

A follow-up after reading fs/btrfs/send.c (current master). I have not
built or tested a change, so please take this as a pointer only.

Holes in an incremental send are detected in maybe_send_hole(), which is
called for every file extent item that btrfs_compare_trees() reports,
CHANGED as well as SAME (changed_cb() forwards SAME extent items there).
It checks the gap *before* the reported item, from
sctx->cur_inode_last_extent up to key->offset, and then sets
cur_inode_last_extent to the end of that item.

SAME items are only reported from leaves that differ between the two
roots. Leaves that are shared are skipped as a whole, so their items
never reach maybe_send_hole().

In the failing case the shortened item is the last one of its leaf.
Its new end is stored in cur_inode_last_extent, but the gap behind it
is only checked when the next extent item of the inode is reported, and
that item is the first one of a shared leaf, so it is never reported.
Two places could still catch it, and neither does:

- If a later leaf of the same inode differs, maybe_send_hole() is called
  at slot 0 there with cur_inode_last_extent < key->offset and
  recomputes it with get_last_extent(sctx, key->offset - 1). This
  replaces the pending end with the end of the item just before the
  current one, which is in the skipped leaf, so the gap behind the
  shortened item is lost. (If the shortened item's leaf is directly
  followed by the changed leaf, the recomputed value is the shortened
  item's own end and the hole is sent, which matches what I saw: only
  the extent followed by an unchanged leaf was received wrong.)

- finish_inode_if_needed() calls get_last_extent(sctx, (u64)-1), which
  looks at the last extent item of the inode, so it only checks the
  range up to i_size.

So a range between the end of a changed extent item and the next
extent item is never checked when that next item lives in a shared
leaf. One way to close it might be to check the gap behind the last
reported extent item before cur_inode_last_extent is replaced at slot 0,
and in finish_inode_if_needed(), against the next extent item in the
send root rather than the last one. But you will know better where this
belongs.


System information
------------------

The bug reproduces on a fresh loop filesystem with mkfs defaults (see
the reproducer in my first mail), so the filesystems below are not
needed to trigger it. For completeness, the real case was sent from
/data/vm-ssd to /data/nas:

$ uname -a
Linux Nas-Server 7.2.11-200.fc44.x86_64 #1 SMP PREEMPT_DYNAMIC Thu Oct
15 15:58:58 UTC 2026 x86_64 GNU/Linux

$ btrfs --version
btrfs-progs v7.1
-EXPERIMENTAL -INJECT -STATIC +LZO +ZSTD +UDEV +FSVERITY +ZONED CRYPTO=3Dli=
bgcrypt

$ btrfs filesystem show /data/vm-ssd
Label: 'vm-ssd'  uuid: 00e062ee-8a8a-4e14-a536-2b7c2c9d9c0f
    Total devices 4 FS bytes used 111.63GiB
    devid    1 size 238.46GiB used 64.03GiB path /dev/sdg
    devid    2 size 238.46GiB used 64.00GiB path /dev/sdh
    devid    3 size 238.46GiB used 63.03GiB path /dev/sdi
    devid    4 size 232.89GiB used 63.00GiB path /dev/sde

$ btrfs filesystem df /data/vm-ssd
Data, RAID10: total=3D124.00GiB, used=3D109.94GiB
System, RAID1: total=3D32.00MiB, used=3D16.00KiB
Metadata, RAID1: total=3D3.00GiB, used=3D381.98MiB
GlobalReserve, single: total=3D221.23MiB, used=3D0.00B

$ btrfs filesystem show /data/nas
Label: 'nas'  uuid: e02b9bf4-3186-40c3-ab60-f9cd85ae7a97
    Total devices 3 FS bytes used 38.99TiB
    devid    1 size 10.91TiB used 5.76TiB path /dev/sdk
    devid    2 size 21.83TiB used 16.68TiB path /dev/sdl
    devid    3 size 21.83TiB used 16.68TiB path /dev/sdm

$ btrfs filesystem df /data/nas
Data, single: total=3D39.01TiB, used=3D38.94TiB
System, RAID1: total=3D8.00MiB, used=3D4.36MiB
Metadata, RAID1: total=3D54.00GiB, used=3D44.14GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

Mount options: /data/vm-ssd noatime,compress=3Dzstd:1,ssd,space_cache=3Dv2;
/data/nas noatime,compress=3Dzstd:10,space_cache=3Dv2,autodefrag.

dmesg shows no btrfs warnings or errors around the sends; send and
receive both exit 0.

Thanks,
Tristan

Am Mi., 21. Okt. 2026 um 13:12 Uhr schrieb Filipe Manana <fdmanana@kernel.o=
rg>:
>
> On Wed, Oct 21, 2026 at 11:42=E2=80=AFAM Tristan Elvers <tristanelvers@gm=
ail.com> wrote:
> >
> > Hi,
> >
> > First of all, I found this bug with the help of Claude. The problem
> > occurred in the production environment; we weren't specifically
> > looking for an issue.
> > Unfortunately, I don't know much about coding myself, so I can't
> > contribute much personally, on this matter, but I hope this issue
> > doesn't turn out to be a false alarm and that it can be resolved.
> > Please do not hesitate to contact me if you have any queries.
> >
> > Here is the Information I got from Claude:
> > An incremental "btrfs send -p" silently omits a hole when the tail of a
> > file extent item is punched away, the item is the last item of its leaf=
,
> > and the following leaf is unchanged between parent and send snapshot.
> > The receiver keeps the old data in the punched range, so the received
> > file differs from the source without any error. Full sends are correct.
> >
> > Seen on 7.2.9 and 7.2.11 (Fedora 7.2.11-200.fc44.x86_64), btrfs-progs
> > 7.1, no-holes enabled (mkfs default). A self-contained reproducer is
> > included below; on a fresh 2 GiB loop filesystem it gives:
> >
> >     leaf-last extents trimmed: 7
> >     7 of 7 trimmed extents differ on the receiver
> >     whole file: DIFFERS
> >
> > The result is the same with "btrfs send --proto 2", so this is not the
> > v1-only zero-writing behaviour discussed in btrfs-progs issue #1001
> > (fixed by "btrfs: send: use fallocate for hole punching with send
> > stream v2"): with v1 the stream contains no command for the punched
> > range (checked with receive --dump, see below), not even a write of
> > zeroes, and with v2 the receiver keeps the stale data just the same.
> > The hole seems to be missed before the stream format comes into play.
> >
> >
> > How it was found
> > ----------------
> >
> > A nightly backup sends read-only snapshots of a VM disk image (qcow2,
> > qemu with discard=3D'unmap') incrementally to a second btrfs filesystem
> > and compares checksums afterwards. After the guest ran fstrim, qemu
> > punched a hole at the end of an existing extent. From then on the
> > received copy differed: 8 MiB at offset 12463964160 were a hole in the
> > source snapshot but still contained the parent's data on the receiver.
> >
> > "btrfs send -p PARENT SNAP | btrfs receive --dump" contains no command
> > at all touching that range (79480 write and 311 clone commands in
> > total, none overlapping it).
> >
> > File extent items of that inode (dump-tree of the snapshot roots):
> >
> > parent snapshot:
> >   leaf 935723008 items 174 free space 2711 generation 41670 owner 257
> >     item 172 key (257 EXTENT_DATA 12454526976) itemoff 7114 itemsize 53
> >         generation 18 type 1 (regular)
> >         extent data disk byte 26447552512 nr 67174400
> >         extent data offset 73728 nr 5242880 ram 67174400
> >     item 173 key (257 EXTENT_DATA 12461342720) itemoff 7061 itemsize 53
> >         generation 18 type 1 (regular)
> >         extent data disk byte 26447552512 nr 67174400
> >         extent data offset 6889472 nr 11010048 ram 67174400
> >   leaf 350879744 items 208 free space 59 generation 41657 owner 257
> >     item 0 key (257 EXTENT_DATA 12473139200) itemoff 16230 itemsize 53
> >         generation 18 type 1 (regular)
> >         extent data disk byte 26447552512 nr 67174400
> >         extent data offset 18685952 nr 720896 ram 67174400
> >
> > send snapshot:
> >   leaf 126293196800 items 173 free space 2789 generation 49841 owner 25=
7
> >     item 171 key (257 EXTENT_DATA 12454526976) itemoff 7167 itemsize 53
> >         ...
> >     item 172 key (257 EXTENT_DATA 12461342720) itemoff 7114 itemsize 53
> >         generation 18 type 1 (regular)
> >         extent data disk byte 26447552512 nr 67174400
> >         extent data offset 6889472 nr 2621440 ram 67174400
> >   leaf 350879744 items 208 free space 59 generation 41657 owner 257
> >     (same leaf as in the parent)
>
> Thanks for the report, I'll send a fix for this soon and let you know.
>
> >
> > So the item at 12461342720 shrank from 11010048 to 2621440 bytes (same
> > disk extent, same offset); [12463964160, 12472352768) became a hole.
> > The item stays the last one of its leaf, and the next leaf (350879744)
> > is shared, so the tree comparison never reports the following extent
> > item.
> >
> >
> > What does not trigger it
> > ------------------------
> >
> > All of these were received correctly on the same kernels:
> >
> > - punching a hole in the middle of an extent
> > - FALLOC_FL_ZERO_RANGE (prealloc extent)
> > - trimming the tail of an extent followed by an existing hole, small fi=
le
> > - the same with 5000 extents, every extent trimmed (all leaves changed)
> > - trimming a tail, 2000 unchanged extents, then a changed extent later
> > - trimming the tail of an extent in the middle of a leaf
> >
> > In a variant that trimmed leaf-last extents of 14 consecutive leaves
> > (plus one mid-leaf extent each), exactly one was received wrong: the
> > one whose following leaf was the only unchanged one.
> >
> > My guess, without having read send.c closely: the hole behind a changed
> > extent item is only detected when the next extent item (or the end of
> > the inode) is processed; when the next item lives in a leaf that the
> > tree comparison skips as shared, nothing ever checks the range between
> > the shortened extent's new end and the next item.
> >
> >
> > Reproducer
> > ----------
> >
> > Needs root, python3, btrfs-progs. Creates a 2 GiB image in a temporary
> > directory (default /var/tmp), loop-mounts it, cleans up afterwards.
> >
> > #!/bin/bash
> > # Reproducer: incremental btrfs send omits a hole created by trimming t=
he tail
> > # of a file extent item that is the LAST item of its leaf, when the fol=
lowing
> > # leaf is unchanged (shared between parent and send snapshot).
> > # The receiver keeps the old data in that range.
> > #
> > # Runs on a fresh loop-mounted btrfs (default mkfs features, i.e. no-ho=
les).
> > # Usage: sudo ./btrfs-send-trimmed-extent-repro.sh [workdir]
> > set -euo pipefail
> > [[ $EUID -eq 0 ]] || { echo "run as root" >&2; exit 1; }
> > W=3D$(mktemp -d "${1:-/var/tmp}/send-repro.XXXXXX")
> > IMG=3D$W/fs.img MNT=3D$W/mnt PY=3D$W/helper.py
> > cleanup() { umount "$MNT" 2>/dev/null || true; [[ -n ${LOOP:-} ]] &&
> > losetup -d "$LOOP" 2>/dev/null || true; rm -rf "$W"; }
> > trap cleanup EXIT
> >
> > cat > "$PY" <<'PYEOF'
> > import ctypes, os, re, sys
> > K =3D 1024
> > STEP, DATA, CUT =3D 128 * K, 64 * K, 16 * K
> > cmd =3D sys.argv[1]
> > if cmd =3D=3D "create":                 # n extents of 64 KiB data, 64 =
KiB
> > hole after each
> >     fd =3D os.open(sys.argv[2], os.O_WRONLY | os.O_CREAT | os.O_TRUNC, =
0o644)
> >     for i in range(int(sys.argv[3])):
> >         os.pwrite(fd, os.urandom(DATA), i * STEP)
> >     os.fsync(fd); os.close(fd)
> > elif cmd =3D=3D "pick":                 # last EXTENT_DATA key of every
> > other leaf that has a successor leaf
> >     ino =3D int(sys.argv[2]); leaves, cur =3D [], None
> >     key =3D re.compile(r"^\titem \d+ key \((\d+) EXTENT_DATA (\d+)\)")
> >     for line in sys.stdin:
> >         if line.startswith("leaf ") and " items " in line:
> >             cur =3D []; leaves.append(cur); continue
> >         m =3D key.match(line)
> >         if m and cur is not None and int(m.group(1)) =3D=3D ino:
> >             cur.append(int(m.group(2)))
> >     leaves =3D [l for l in leaves if l]
> >     for i in range(0, len(leaves) - 1, 2):
> >         print(leaves[i][-1])
> > elif cmd =3D=3D "trim":                 # punch the last 16 KiB of the
> > extent at each offset
> >     libc =3D ctypes.CDLL(None, use_errno=3DTrue)
> >     libc.fallocate.argtypes =3D [ctypes.c_int, ctypes.c_int,
> > ctypes.c_longlong, ctypes.c_longlong]
> >     fd =3D os.open(sys.argv[2], os.O_RDWR)
> >     for off in map(int, sys.argv[3:]):
> >         if libc.fallocate(fd, 3, off + DATA - CUT, CUT):   # KEEP_SIZE
> > | PUNCH_HOLE
> >             raise OSError(ctypes.get_errno(), "fallocate")
> >     os.fsync(fd); os.close(fd)
> > elif cmd =3D=3D "compare":              # count trimmed extents whose 6=
4 KiB differ
> >     a, b =3D open(sys.argv[2], "rb"), open(sys.argv[3], "rb"); bad =3D =
0
> >     offs =3D list(map(int, sys.argv[4:]))
> >     for off in offs:
> >         a.seek(off); b.seek(off)
> >         bad +=3D a.read(DATA) !=3D b.read(DATA)
> >     print(f"{bad} of {len(offs)} trimmed extents differ on the receiver=
")
> > PYEOF
> >
> > truncate -s 2G "$IMG"
> > mkfs.btrfs -q "$IMG"
> > LOOP=3D$(losetup -f --show "$IMG")
> > mkdir "$MNT"; mount "$LOOP" "$MNT"
> > btrfs subvolume create "$MNT/src" >/dev/null
> > mkdir "$MNT/dst"
> >
> > python3 -I "$PY" create "$MNT/src/f" 3000
> > btrfs subvolume snapshot -r "$MNT/src" "$MNT/s1" >/dev/null
> > btrfs filesystem sync "$MNT"
> > ino=3D$(stat -c %i "$MNT/s1/f")
> > offs=3D$(btrfs inspect-internal dump-tree -t "$(btrfs inspect-internal
> > rootid "$MNT/s1")" "$LOOP" | python3 -I "$PY" pick "$ino")
> > echo "leaf-last extents trimmed: $(wc -w <<< "$offs")"
> > # shellcheck disable=3DSC2086
> > python3 -I "$PY" trim "$MNT/src/f" $offs
> > btrfs subvolume snapshot -r "$MNT/src" "$MNT/s2" >/dev/null
> >
> > btrfs send -q "$MNT/s1" | btrfs receive "$MNT/dst" >/dev/null 2>&1
> > btrfs send -q -p "$MNT/s1" "$MNT/s2" | btrfs receive "$MNT/dst" >/dev/n=
ull 2>&1
> > # shellcheck disable=3DSC2086
> > python3 -I "$PY" compare "$MNT/s2/f" "$MNT/dst/s2/f" $offs
> > cmp -s "$MNT/s2/f" "$MNT/dst/s2/f" && echo "whole file: identical" ||
> > echo "whole file: DIFFERS"
> > echo "kernel $(uname -r), $(btrfs --version)"
> >
> > Thanks,
> > Tristan
> >

Am Mi., 21. Okt. 2026 um 13:12 Uhr schrieb Filipe Manana <fdmanana@kernel.o=
rg>:
>
> On Wed, Oct 21, 2026 at 11:42=E2=80=AFAM Tristan Elvers <tristanelvers@gm=
ail.com> wrote:
> >
> > Hi,
> >
> > First of all, I found this bug with the help of Claude. The problem
> > occurred in the production environment; we weren't specifically
> > looking for an issue.
> > Unfortunately, I don't know much about coding myself, so I can't
> > contribute much personally, on this matter, but I hope this issue
> > doesn't turn out to be a false alarm and that it can be resolved.
> > Please do not hesitate to contact me if you have any queries.
> >
> > Here is the Information I got from Claude:
> > An incremental "btrfs send -p" silently omits a hole when the tail of a
> > file extent item is punched away, the item is the last item of its leaf=
,
> > and the following leaf is unchanged between parent and send snapshot.
> > The receiver keeps the old data in the punched range, so the received
> > file differs from the source without any error. Full sends are correct.
> >
> > Seen on 7.2.9 and 7.2.11 (Fedora 7.2.11-200.fc44.x86_64), btrfs-progs
> > 7.1, no-holes enabled (mkfs default). A self-contained reproducer is
> > included below; on a fresh 2 GiB loop filesystem it gives:
> >
> >     leaf-last extents trimmed: 7
> >     7 of 7 trimmed extents differ on the receiver
> >     whole file: DIFFERS
> >
> > The result is the same with "btrfs send --proto 2", so this is not the
> > v1-only zero-writing behaviour discussed in btrfs-progs issue #1001
> > (fixed by "btrfs: send: use fallocate for hole punching with send
> > stream v2"): with v1 the stream contains no command for the punched
> > range (checked with receive --dump, see below), not even a write of
> > zeroes, and with v2 the receiver keeps the stale data just the same.
> > The hole seems to be missed before the stream format comes into play.
> >
> >
> > How it was found
> > ----------------
> >
> > A nightly backup sends read-only snapshots of a VM disk image (qcow2,
> > qemu with discard=3D'unmap') incrementally to a second btrfs filesystem
> > and compares checksums afterwards. After the guest ran fstrim, qemu
> > punched a hole at the end of an existing extent. From then on the
> > received copy differed: 8 MiB at offset 12463964160 were a hole in the
> > source snapshot but still contained the parent's data on the receiver.
> >
> > "btrfs send -p PARENT SNAP | btrfs receive --dump" contains no command
> > at all touching that range (79480 write and 311 clone commands in
> > total, none overlapping it).
> >
> > File extent items of that inode (dump-tree of the snapshot roots):
> >
> > parent snapshot:
> >   leaf 935723008 items 174 free space 2711 generation 41670 owner 257
> >     item 172 key (257 EXTENT_DATA 12454526976) itemoff 7114 itemsize 53
> >         generation 18 type 1 (regular)
> >         extent data disk byte 26447552512 nr 67174400
> >         extent data offset 73728 nr 5242880 ram 67174400
> >     item 173 key (257 EXTENT_DATA 12461342720) itemoff 7061 itemsize 53
> >         generation 18 type 1 (regular)
> >         extent data disk byte 26447552512 nr 67174400
> >         extent data offset 6889472 nr 11010048 ram 67174400
> >   leaf 350879744 items 208 free space 59 generation 41657 owner 257
> >     item 0 key (257 EXTENT_DATA 12473139200) itemoff 16230 itemsize 53
> >         generation 18 type 1 (regular)
> >         extent data disk byte 26447552512 nr 67174400
> >         extent data offset 18685952 nr 720896 ram 67174400
> >
> > send snapshot:
> >   leaf 126293196800 items 173 free space 2789 generation 49841 owner 25=
7
> >     item 171 key (257 EXTENT_DATA 12454526976) itemoff 7167 itemsize 53
> >         ...
> >     item 172 key (257 EXTENT_DATA 12461342720) itemoff 7114 itemsize 53
> >         generation 18 type 1 (regular)
> >         extent data disk byte 26447552512 nr 67174400
> >         extent data offset 6889472 nr 2621440 ram 67174400
> >   leaf 350879744 items 208 free space 59 generation 41657 owner 257
> >     (same leaf as in the parent)
>
> Thanks for the report, I'll send a fix for this soon and let you know.
>
> >
> > So the item at 12461342720 shrank from 11010048 to 2621440 bytes (same
> > disk extent, same offset); [12463964160, 12472352768) became a hole.
> > The item stays the last one of its leaf, and the next leaf (350879744)
> > is shared, so the tree comparison never reports the following extent
> > item.
> >
> >
> > What does not trigger it
> > ------------------------
> >
> > All of these were received correctly on the same kernels:
> >
> > - punching a hole in the middle of an extent
> > - FALLOC_FL_ZERO_RANGE (prealloc extent)
> > - trimming the tail of an extent followed by an existing hole, small fi=
le
> > - the same with 5000 extents, every extent trimmed (all leaves changed)
> > - trimming a tail, 2000 unchanged extents, then a changed extent later
> > - trimming the tail of an extent in the middle of a leaf
> >
> > In a variant that trimmed leaf-last extents of 14 consecutive leaves
> > (plus one mid-leaf extent each), exactly one was received wrong: the
> > one whose following leaf was the only unchanged one.
> >
> > My guess, without having read send.c closely: the hole behind a changed
> > extent item is only detected when the next extent item (or the end of
> > the inode) is processed; when the next item lives in a leaf that the
> > tree comparison skips as shared, nothing ever checks the range between
> > the shortened extent's new end and the next item.
> >
> >
> > Reproducer
> > ----------
> >
> > Needs root, python3, btrfs-progs. Creates a 2 GiB image in a temporary
> > directory (default /var/tmp), loop-mounts it, cleans up afterwards.
> >
> > #!/bin/bash
> > # Reproducer: incremental btrfs send omits a hole created by trimming t=
he tail
> > # of a file extent item that is the LAST item of its leaf, when the fol=
lowing
> > # leaf is unchanged (shared between parent and send snapshot).
> > # The receiver keeps the old data in that range.
> > #
> > # Runs on a fresh loop-mounted btrfs (default mkfs features, i.e. no-ho=
les).
> > # Usage: sudo ./btrfs-send-trimmed-extent-repro.sh [workdir]
> > set -euo pipefail
> > [[ $EUID -eq 0 ]] || { echo "run as root" >&2; exit 1; }
> > W=3D$(mktemp -d "${1:-/var/tmp}/send-repro.XXXXXX")
> > IMG=3D$W/fs.img MNT=3D$W/mnt PY=3D$W/helper.py
> > cleanup() { umount "$MNT" 2>/dev/null || true; [[ -n ${LOOP:-} ]] &&
> > losetup -d "$LOOP" 2>/dev/null || true; rm -rf "$W"; }
> > trap cleanup EXIT
> >
> > cat > "$PY" <<'PYEOF'
> > import ctypes, os, re, sys
> > K =3D 1024
> > STEP, DATA, CUT =3D 128 * K, 64 * K, 16 * K
> > cmd =3D sys.argv[1]
> > if cmd =3D=3D "create":                 # n extents of 64 KiB data, 64 =
KiB
> > hole after each
> >     fd =3D os.open(sys.argv[2], os.O_WRONLY | os.O_CREAT | os.O_TRUNC, =
0o644)
> >     for i in range(int(sys.argv[3])):
> >         os.pwrite(fd, os.urandom(DATA), i * STEP)
> >     os.fsync(fd); os.close(fd)
> > elif cmd =3D=3D "pick":                 # last EXTENT_DATA key of every
> > other leaf that has a successor leaf
> >     ino =3D int(sys.argv[2]); leaves, cur =3D [], None
> >     key =3D re.compile(r"^\titem \d+ key \((\d+) EXTENT_DATA (\d+)\)")
> >     for line in sys.stdin:
> >         if line.startswith("leaf ") and " items " in line:
> >             cur =3D []; leaves.append(cur); continue
> >         m =3D key.match(line)
> >         if m and cur is not None and int(m.group(1)) =3D=3D ino:
> >             cur.append(int(m.group(2)))
> >     leaves =3D [l for l in leaves if l]
> >     for i in range(0, len(leaves) - 1, 2):
> >         print(leaves[i][-1])
> > elif cmd =3D=3D "trim":                 # punch the last 16 KiB of the
> > extent at each offset
> >     libc =3D ctypes.CDLL(None, use_errno=3DTrue)
> >     libc.fallocate.argtypes =3D [ctypes.c_int, ctypes.c_int,
> > ctypes.c_longlong, ctypes.c_longlong]
> >     fd =3D os.open(sys.argv[2], os.O_RDWR)
> >     for off in map(int, sys.argv[3:]):
> >         if libc.fallocate(fd, 3, off + DATA - CUT, CUT):   # KEEP_SIZE
> > | PUNCH_HOLE
> >             raise OSError(ctypes.get_errno(), "fallocate")
> >     os.fsync(fd); os.close(fd)
> > elif cmd =3D=3D "compare":              # count trimmed extents whose 6=
4 KiB differ
> >     a, b =3D open(sys.argv[2], "rb"), open(sys.argv[3], "rb"); bad =3D =
0
> >     offs =3D list(map(int, sys.argv[4:]))
> >     for off in offs:
> >         a.seek(off); b.seek(off)
> >         bad +=3D a.read(DATA) !=3D b.read(DATA)
> >     print(f"{bad} of {len(offs)} trimmed extents differ on the receiver=
")
> > PYEOF
> >
> > truncate -s 2G "$IMG"
> > mkfs.btrfs -q "$IMG"
> > LOOP=3D$(losetup -f --show "$IMG")
> > mkdir "$MNT"; mount "$LOOP" "$MNT"
> > btrfs subvolume create "$MNT/src" >/dev/null
> > mkdir "$MNT/dst"
> >
> > python3 -I "$PY" create "$MNT/src/f" 3000
> > btrfs subvolume snapshot -r "$MNT/src" "$MNT/s1" >/dev/null
> > btrfs filesystem sync "$MNT"
> > ino=3D$(stat -c %i "$MNT/s1/f")
> > offs=3D$(btrfs inspect-internal dump-tree -t "$(btrfs inspect-internal
> > rootid "$MNT/s1")" "$LOOP" | python3 -I "$PY" pick "$ino")
> > echo "leaf-last extents trimmed: $(wc -w <<< "$offs")"
> > # shellcheck disable=3DSC2086
> > python3 -I "$PY" trim "$MNT/src/f" $offs
> > btrfs subvolume snapshot -r "$MNT/src" "$MNT/s2" >/dev/null
> >
> > btrfs send -q "$MNT/s1" | btrfs receive "$MNT/dst" >/dev/null 2>&1
> > btrfs send -q -p "$MNT/s1" "$MNT/s2" | btrfs receive "$MNT/dst" >/dev/n=
ull 2>&1
> > # shellcheck disable=3DSC2086
> > python3 -I "$PY" compare "$MNT/s2/f" "$MNT/dst/s2/f" $offs
> > cmp -s "$MNT/s2/f" "$MNT/dst/s2/f" && echo "whole file: identical" ||
> > echo "whole file: DIFFERS"
> > echo "kernel $(uname -r), $(btrfs --version)"
> >
> > Thanks,
> > Tristan
> >
