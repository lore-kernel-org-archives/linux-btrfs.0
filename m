Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792759446;
	b=1T0NWFYPvUkEU1/cM6pP0DyfXkcMkB1JTe0D9oFXvEnrmFG0qYDT82DLPJiHwN7OIYuW
	 5n5iLfXzUVaRWVCJ2QbLKAqo7z96q4cB4AmUQZKyLISwsp5Sdd1fJYKHTg6pRJvgB0WwE
	 LD+Nj5oLjO1yAH47eo5fiOpSmhfRuqKxq3U2550uwmDYE4FuS1onrQ+vCRnO+ik2H2/5H
	 z8KGp7FVkgmqPHfFZAviMtJiVsZpuBAi2RNO3aN9ixstcXG/Egh5hkpj6lT+OP/KwPdng
	 o8Zb9fYzUCjdRv/41zZyrLCv9pNS0lHd0cs1IZBD6qamMZOQdE9HqOmXwemHG1HGHpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792759446;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=WrAOETMjhx30eB6jE0xbEdxRMf8h1XOmVFU+VKLsWZE=;
	b=dLiAxTc2kCiyqYrQ0uQF5fDy+53kSilguQ55nIR9nlz7Av8Z9Yr9zvAJUXHR3w9hvARH
	 jP5NxrrX+3r+Jy2J+ixwEcqzZn/9HJxlImwPDq0oVx37kiuX/7w4lxQW3X3s3vCcCFmBr
	 8hW/VVn8Php+9cVNHijENSJib3CNeBMhZU77K77iQyhhRvlGKhGAFtwmQhHrdoXIj1QjX
	 44xBm6iBkj2eBOuwX66HX0XnYV4J4MC5AmvVsH9M2G7Zby2vgSjbLtAwd0jHI/AYm8Pui
	 7z3Po1CargEsOXMbCmPikMS/eqtqyz1+xR+3CBK9vklLpKAqWl2LFlHEOe0kj24CeyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NULtYsdP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7F7606A31A
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 12:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NULtYsdP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C3F1F031E3
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 12:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792759445;
	bh=WrAOETMjhx30eB6jE0xbEdxRMf8h1XOmVFU+VKLsWZE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NULtYsdPF1edw3UNYT+odSQ8geDxGn5bxz0u41apezFLFP717nIXlh9XXawXf13u0
	 TwaKdDgDcWz7O/gpPL3gDwmuvtFNJwJsE3MnSO9e0x03Bvu9Pq2Fi1T/FflybzaS5K
	 UJOydemQB8QA4jymr4wuX3XDHltF2eNFfJdJw/+FJXtS6YLX6EXM5bgZRif57jlxec
	 jsblXti08yTKJ7Fg58K8Vr6919/QNtm/QL0mtPEnI/9qyllYZBAbnx83YTLWeIuFiG
	 c6uYnA1ZpeWLZ/t+f3GGdW3r4kImeXQO+VmyI/k7ar8WI/jGluzEOgv+drXKF29916
	 UL7BBHBTbNsdQ==
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5eae12762c9so390983e0c.1
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 05:44:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzXbUwfl5tXMaN7QRp/hVYvVJSo4NRtEfdF7r9Pd9BwwTUyrqof/d5Gb1IYOPn4afHAxYCohydZbbq7UQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJEQ6ezyJ2tzp6Q1SO4NqUtDP7dUlJW2R8rOcESWTnLVLhUmJAM
	HHXEgbpLE5piCeNDsyxhr4If/3/FmmInOGIpdViBZaQtz/uzGFvW1p+2AEQaJnUN5C/gUF1v0o3
	tV8GfPcEebTc+HsJ1Ad8lWWI15P7E0Hg=
X-Received: by 2002:a05:6102:644a:b0:7c3:91f5:26f1 with SMTP id
 ada2fe7eead31-7ccc32f27c8mr724688137.6.1792759444731; Fri, 23 Oct 2026
 05:44:04 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023123451.90365-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20261023123451.90365-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 23 Oct 2026 13:43:28 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7MRrhjgiedcvPobNP-irH+uh4E6M=gGrC4FKu9jYDFrA@mail.gmail.com>
X-Gm-Features: AclHuK-Pl-myzBT37YJ-M5biT0BKzWTW4VqF8fZeCFxGwRjmosQLcfWStKjX6tk
Message-ID: <CAL3q7H7MRrhjgiedcvPobNP-irH+uh4E6M=gGrC4FKu9jYDFrA@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: test that fsynced data on a RAID stripe tree
 survives a power failure
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 1:41=E2=80=AFPM Johannes Thumshirn
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
> cover a fast fsync and a full fsync. Each one is followed by its own powe=
r
> failure, so a transaction commit triggered by one cannot hide a bug in th=
e
> other.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>


> ---
> Changes to v2:
> - Add a _flakey_drop_and_remount between the fast and full fsync
>
>  tests/btrfs/363     | 68 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/363.out | 15 ++++++++++
>  2 files changed, 83 insertions(+)
>  create mode 100755 tests/btrfs/363
>  create mode 100644 tests/btrfs/363.out
>
> diff --git a/tests/btrfs/363 b/tests/btrfs/363
> new file mode 100755
> index 00000000..b71dff0f
> --- /dev/null
> +++ b/tests/btrfs/363
> @@ -0,0 +1,68 @@
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
> +_flakey_drop_and_remount
> +
> +echo "fast fsync:"
> +_hexdump $SCRATCH_MNT/fast
> +
> +# Full fsync: this is the first fsync of this inode, so all of its items=
 are
> +# logged.
> +$XFS_IO_PROG -f -c "pwrite -S 0xcc 0 128K" -c fsync $SCRATCH_MNT/full | =
\
> +       _filter_xfs_io
> +
> +_flakey_drop_and_remount
> +
> +echo "full fsync:"
> +_hexdump $SCRATCH_MNT/full
> +
> +_scratch_unmount
> +
> +# success, all done
> +status=3D0
> +exit
> diff --git a/tests/btrfs/363.out b/tests/btrfs/363.out
> new file mode 100644
> index 00000000..9e5f1fa2
> --- /dev/null
> +++ b/tests/btrfs/363.out
> @@ -0,0 +1,15 @@
> +QA output created by 363
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +fast fsync:
> +000000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  >...............=
.<
> +*
> +020000
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +full fsync:
> +000000 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  >...............=
.<
> +*
> +020000
> --
> 2.56.0
>
>
