Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792678833;
	b=NRPLnlm8C0uUu3tJZGOODaJf4/Ohn7p4gzzrn5SqfxV8BU/GYzymJbGUescPHK37qgxy
	 LS2+3olcyrvfuERlxvOtucpvlSNggoyHmMJmPzev/K532YeNflYxO+PELlFB32dV07uWZ
	 NnwTUbRohfl0fYIcMx5yoTQoAA3vr39TQ1RtAkUlnxI2MIgS53Lj/+EPs+5MReUcLcb5/
	 ITQmWctjBeo4Cfm8gGfZOcvNg9QQfN7dEomiXiv8sdBfw1AoH0ZbiP4TdCSnlXti//goE
	 dYs8mGXnSuwBDx7LyueGgLUXMMtwM1DvT6ovLokfzsjXR/V7E5uVisDPuZ+VJyt+cYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792678833;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=TBmuD7g3EKGGtM+6rRq0jSjtoblez/HG0zDyPruzeM8=;
	b=AMxTUUaAc2epIwRLT5qR2fWNyRw6QSKQ1Y7tlSsQPNjZFjZ6w4iL+5BK5gtUBcSxj2e1
	 jPQBVZVN97NfSK1YkhGhziZD4EQC/bzWCHv4uHYN8hw7b+7/B+zLGI7rPNvJ4D1+1grQg
	 0kLiBsQOTxhHaND9YwwWo7sDwWNOdLyhqGeqGtpF+q94Oz86iLtIQSfFHWIl73ztVt44p
	 TSCBRHsDtmf7BLGZM0OMs2j6aesq5CUilDi3YVyO2jDJdVul0cY8UwATkh58R2Hyt45D/
	 VsASrAoRM/KrC/mpp1whm74GzBbaqvWwPrMvHkDvMxI8x1o/pByuLqq4bZxCm8CVvxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oP8CgG87;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71553606A31A
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 14:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oP8CgG87
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9EF1F000C2
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 14:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792678833;
	bh=TBmuD7g3EKGGtM+6rRq0jSjtoblez/HG0zDyPruzeM8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oP8CgG87eY3ltnpJxM16C9wyAFeQ6bRUqT6SE4tmyN3F0es3rlPlrOyZRuVwwYKAq
	 5rqjcFo89i4usI78OeX8Cj3aFZOSpAi73/5OwXAhlS+DgWdTPOy2aRMs0NL6CmU6eL
	 qC+fzRdqriw3U9PJAwySIiT5i3jojEHXfB3/rMfGlp/gKzcAWOm7Rqz5JeDHyKFV/x
	 4DsXs24gzMiIV2R5cyeWI0L/KdrffO8Ukz11otN5RyPG8WbI5OekM0qjX5kAHmTAL0
	 ZerAdkJnXUDP4megM+FH+8cstsSEdK9z2GWR+a8UnaecX+W/l+rQNRa3FxbNquqBcy
	 YHDZ9idLysiVw==
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-9908e3cd939so851698241.3
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 07:20:33 -0700 (PDT)
X-Gm-Message-State: AFq9FYLUYXfEBjFjgkDz4pfITQwCfEIKlNXAb5aUdbg1LaxFjmHr+SPw
	OCLG/HFprx1UjIeCT+ccVXxHGTSKDW4Tt5lRScLshUBuhDTAVucn9ibOn6TzFSWCgw0zzMxxWHQ
	veHdXtswGFcU26p8H+F80lOrwUWdMHeg=
X-Received: by 2002:a05:6102:a1c1:20b0:7cc:c104:6dc6 with SMTP id
 ada2fe7eead31-7ccc10478ddmr1621137.14.1792678832520; Thu, 22 Oct 2026
 07:20:32 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261022090754.2584747-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20261022090754.2584747-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 22 Oct 2026 15:19:55 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7a+JykbQKscuWvpsHyXYN8zLAjDbESFrbFDAEOf9RREw@mail.gmail.com>
X-Gm-Features: AclHuK_9gOKFZnUx9T6iTBhAfKxLJ4I7LOHhJKimlk-VkkUDVH468GR198_c314
Message-ID: <CAL3q7H7a+JykbQKscuWvpsHyXYN8zLAjDbESFrbFDAEOf9RREw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: test that fsynced data on a RAID stripe tree
 survives a power failure
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 22, 2026 at 10:15=E2=80=AFAM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> A data extent in a block-group that uses the RAID stripe tree has its log=
ical
> to physical mapping stored in that tree, which only becomes durable when =
the
> stripe tree is written out at transaction commit. The log tree cannot car=
ry
> that mapping, so an fsync served by the log logs a file-extent item whose
> logical range could not be resolved afterwards. Log replay restored the f=
ile
> with the correct size, but reading it failed with EIO.
>
> Extents reach the log both from log_one_extent() and from copy_items(), s=
o
> cover a fast fsync and a full fsync.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
> Changes to v2:
> - Also test full fsync
>
>
>  tests/btrfs/363     | 67 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/363.out | 15 ++++++++++
>  2 files changed, 82 insertions(+)
>  create mode 100755 tests/btrfs/363
>  create mode 100644 tests/btrfs/363.out
>
> diff --git a/tests/btrfs/363 b/tests/btrfs/363
> new file mode 100755
> index 00000000..834f2673
> --- /dev/null
> +++ b/tests/btrfs/363
> @@ -0,0 +1,67 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
> +#
> +# FS QA Test 363
> +#
> +# Test that data fsynced on a RAID stripe tree file system is still read=
able
> +# after a power failure, both for a fast fsync and for a full fsync.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick log volume raid-stripe-tree
> +
> +_fixed_by_kernel_commit XXXXXXXXXXXX \
> +       "btrfs: force a transaction commit when fsyncing stripe-tree exte=
nts"
> +
> +_cleanup()
> +{
> +       _cleanup_flakey
> +       rm -fr $tmp
> +}
> +
> +. ./common/filter
> +. ./common/dmflakey
> +
> +_require_btrfs_mkfs_feature "raid-stripe-tree"
> +_require_btrfs_fs_feature "raid_stripe_tree"
> +_require_scratch
> +_require_dm_target flakey
> +
> +# DUP keeps its mapping in the stripe tree, so a single device is enough=
 and
> +# dm-flakey can be layered on top of it.
> +_scratch_mkfs -d dup -m dup -O raid-stripe-tree >> $seqres.full 2>&1 || =
\
> +       _fail "mkfs failed"
> +
> +_init_flakey
> +_scratch_mount
> +
> +# The first fsync of an inode is always a full fsync. Do one here and th=
en
> +# commit the transaction, so that the second fsync of this file below is=
 a
> +# fast fsync.
> +$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 128K" -c fsync $SCRATCH_MNT/fast | =
\
> +       _filter_xfs_io
> +_scratch_sync
> +
> +# Fast fsync: only the extents changed since the last fsync are logged.
> +$XFS_IO_PROG -c "pwrite -S 0xbb 0 128K" -c fsync $SCRATCH_MNT/fast | \
> +       _filter_xfs_io
> +
> +# Full fsync: this is the first fsync of this inode, so all of its items=
 are
> +# logged.
> +$XFS_IO_PROG -f -c "pwrite -S 0xcc 0 128K" -c fsync $SCRATCH_MNT/full | =
\
> +       _filter_xfs_io
> +
> +# Simulate a power failure. The log is replayed on the next mount and bo=
th
> +# files must still have the data they were fsynced with.
> +_flakey_drop_and_remount
> +
> +echo "fast fsync:"
> +_hexdump $SCRATCH_MNT/fast
> +echo "full fsync:"
> +_hexdump $SCRATCH_MNT/full
> +
> +_scratch_unmount
> +
> +# success, all done
> +status=3D0
> +exit

I think you may be using an old fstests, because nowadays the template
created by the "./new" script does:

_exit 0

instead of

status=3D0
exit

Anyway:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> diff --git a/tests/btrfs/363.out b/tests/btrfs/363.out
> new file mode 100644
> index 00000000..fcf6e0a7
> --- /dev/null
> +++ b/tests/btrfs/363.out
> @@ -0,0 +1,15 @@
> +QA output created by 363
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +fast fsync:
> +000000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  >...............=
.<
> +*
> +020000
> +full fsync:
> +000000 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  >...............=
.<
> +*
> +020000
> --
> 2.56.0
>
>
