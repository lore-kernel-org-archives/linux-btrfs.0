Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793029659;
	b=MGPdbTleF/AZh+cCia2+SxHlgpg4R33TJZqDTnjv6Wxwrxm3L4YIPGRWwyZgRmvKvPSn
	 GQ8oX2kElZphnYhCvox+EndRUkuoyKeqX/dPniZZvvwiiE5EnLDt/TfkYBPG16jQqDsTL
	 7H+gTt8iGRrzdRx+u69YBrSo6hZYVnaHoVHGO9xeqAp77fzuWdrNYGN0BKsGLwfPdJchA
	 YzRubW+DrG3rWnFPSQYijJvr6RVvUn1GOFVaxs7l7ujXIlr7wPc7JRYJkL42a11uqsPOh
	 97Ku3N2LQTBVrg1h0mMlTUF3PU/svrAarGKU4BVe3b80ltqClYs+OoiwEQZ0hTWy2wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793029659;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=4bHsgxkd71yp0PyHCQx8V+wNDlg3bK6SdmD3N4zjE+Y=;
	b=kOr8mSu1MWp9fYpHr93Bhr/+Fy4iLqlMHsXIN/NUi0qMTFNhXvvKPBq4onqanuV099tR
	 m/GxeHi5x+csxyjRzWjRZHrmimuQ9VFPHRiI9X56HAAZZnOVSO5XCPF7/b2fVgB3RyjZc
	 0y1kHdpUeL2OsvHuDdXonAdyKz2n5sCjCWK59m2OdI6otVPSIvUmOwPJHUwiDg35djDcx
	 NyM5Y1kPMYV/hlmV5IIbRZHFB50F/Ymk0kReFGWHw74n7flh+CTHJ1eECTpQb32t+xviG
	 G/sQVdi0i4XiyE2S5UdvNjdfhI1//GiiK4LypBcrgq7fK11YXN4fTPZV3j5FNIXffNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e9MT3Q9d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B38606A31A;
	Mon, 26 Oct 2026 15:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e9MT3Q9d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3121F01825;
	Mon, 26 Oct 2026 15:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793029658;
	bh=4bHsgxkd71yp0PyHCQx8V+wNDlg3bK6SdmD3N4zjE+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e9MT3Q9dNOnd4/4jQtaYx6MDPElbph8E8e8bDp5d45U3S/mSIC3dc2U/E8bZtWxtS
	 98ZgoNKtdajAsgkYvnBqNYIM5xS0jmG8ZW1dDpgise2qbYRTRduEW0jZwwJsju+U1i
	 mcxv9Sn4OzQmU4rSQQZp4GntWRUY6rf0fDkzt/QaNI/WcnnCl7f0ryOKubu5DSmL6j
	 YkK2xu7CXwY6u9rFw6I7LDcvkcFcml07Vxs91gXvBh8tmS2ur3U4CpHhfDbVW7u9l6
	 qAIryVh7eYNq1N0e0aMrWe95Nqk76WZ+qUx26oJM3ZzMXDxjJ5tAImaDWFvEkJQdT3
	 ERkRCZktx0x0w==
Date: Mon, 26 Oct 2026 23:47:29 +0800
From: Zorro Lang <zlang@kernel.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH v3] btrfs: test that fsynced data on a RAID stripe tree
 survives a power failure
Message-ID: <at9zEEwdEjoJW2bP@zlang-mailbox>
Mail-Followup-To: Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
	Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, 
	linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
References: <20261023123451.90365-1-johannes.thumshirn@wdc.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023123451.90365-1-johannes.thumshirn@wdc.com>

On Fri, Oct 23, 2026 at 02:34:51PM +0200, Johannes Thumshirn wrote:
> A data extent in a block-group that uses the RAID stripe tree has its logical
> to physical mapping stored in that tree, which only becomes durable when the
> stripe tree is written out at transaction commit. The log tree cannot carry
> that mapping, so an fsync served by the log logs a file-extent item whose
> logical range could not be resolved afterwards. Log replay restored the file
> with the correct size, but reading it failed with EIO.
> 
> Extents reach the log both from log_one_extent() and from copy_items(), so
> cover a fast fsync and a full fsync. Each one is followed by its own power
> failure, so a transaction commit triggered by one cannot hide a bug in the
> other.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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
> +# Test that data fsynced on a RAID stripe tree file system is still readable
> +# after a power failure, both for a fast fsync and for a full fsync.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick log volume raid-stripe-tree
> +
> +_fixed_by_kernel_commit XXXXXXXXXXXX \
> +	"btrfs: force a transaction commit when fsyncing stripe-tree extents"
> +
> +_cleanup()
> +{

  cd /

> +	_cleanup_flakey
> +	rm -fr $tmp

It should be "$tmp.*", not "$tmp" .

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
> +# DUP keeps its mapping in the stripe tree, so a single device is enough and
> +# dm-flakey can be layered on top of it.
> +_scratch_mkfs -d dup -m dup -O raid-stripe-tree >> $seqres.full 2>&1 || \
> +	_fail "mkfs failed"
> +
> +_init_flakey
> +_scratch_mount
> +
> +# The first fsync of an inode is always a full fsync. Do one here and then
> +# commit the transaction, so that the second fsync of this file below is a
> +# fast fsync.
> +$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 128K" -c fsync $SCRATCH_MNT/fast | \
> +	_filter_xfs_io
> +_scratch_sync
> +
> +# Fast fsync: only the extents changed since the last fsync are logged.
> +$XFS_IO_PROG -c "pwrite -S 0xbb 0 128K" -c fsync $SCRATCH_MNT/fast | \
> +	_filter_xfs_io
> +
> +_flakey_drop_and_remount
> +
> +echo "fast fsync:"
> +_hexdump $SCRATCH_MNT/fast
> +
> +# Full fsync: this is the first fsync of this inode, so all of its items are
> +# logged.
> +$XFS_IO_PROG -f -c "pwrite -S 0xcc 0 128K" -c fsync $SCRATCH_MNT/full | \
> +	_filter_xfs_io
> +
> +_flakey_drop_and_remount
> +
> +echo "full fsync:"
> +_hexdump $SCRATCH_MNT/full
> +
> +_scratch_unmount

Is this necessary to reproduce the bug? If not, we can remove this line.

> +
> +# success, all done
> +status=0
> +exit

_exit 0

These are all minor review points. If there are no other comments, I can
do these changes when merging.

Thanks,
Zorro

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
> +000000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  >................<
> +*
> +020000
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +full fsync:
> +000000 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  >................<
> +*
> +020000
> -- 
> 2.56.0
> 
> 
