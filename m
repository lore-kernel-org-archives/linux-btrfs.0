Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794668736;
	b=Cc3Lcsg+ZATbO/RmptNKuW1u0M7/mp+HbUu8u4Uha/0qad/zilw7P8+Yjjy7PfEG3cEA
	 L+j1n9ahOpzj1LRWDSQcqsR/thmBBxE9nYfJVAzpGhEUgiaiw8oLg7RkX2OdSq/Fjo8N+
	 x67Drqx9C7zTqxiyCT/Iq9O5PHBizRJ/Po4/bxaFqxjgBKo+tJmjtKZ5n+xGLQ7pFsc/w
	 f3Cq4FDp2XcOQwAmKdK66oXGgN/7LLxclcQZKMrd5Utdv4dywjgx/vFgNxwblJYgFON2Z
	 vaPn44Jj4jAQNKrnMu/HswKxIxRIuT3zokXEwk7xaGsAA6zibO5V6Nq1rm/PjIcB1GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794668736;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=GyeTWfkZrMQUnHO467sddftYprVJmoiVwBI8RKGHnRg=;
	b=fddDpZ7nT5I15lRu4FgyhqSnD7tsRIRpSVSEenaIjdWkLSN9bSyS8twz/RGYhekX88PU
	 2LcztrYDQTMWAeE32N+xEOa2kA7enV56jhZPugxEhOIxr7q1wND4PvZGMb1dTsXlJwe9s
	 k/qmpRZ+tUJ2C4Lpmx3c+8UpOZvQYgJ9h9faeSTdvxRBS869F71DoSfV9rwJayMOYYC8U
	 ZCtDaZ4MHIRD8jNB2nZruoRyWUwIOir7JKZqnSpRXhBUZ7HV0Vmz9CmVjyCJKscZMyYET
	 XmD2pxFyH2q+PQKvxQdzq+KR1uSOqcQcA3n869jdWlnXlaU8ffFOR5XkxvX8zRyxvtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lbNy832f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AA1606A329;
	Sat, 14 Nov 2026 15:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lbNy832f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F90D1F000C4;
	Sat, 14 Nov 2026 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794668736;
	bh=GyeTWfkZrMQUnHO467sddftYprVJmoiVwBI8RKGHnRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lbNy832fX03/me3XRMYXQ2cxGbGkbC4kqhIsQ37rQkpHXlLvskrAKUtCxfRjs04iJ
	 JsRIqtcvePPmN3xai+6eeOVsu5q47Cv6UNw0e3dtGFno+EezQETBajXwPGUUyDxbn8
	 cDnhintfnLhmdkIxcC4uV4IARsemsXE5e3/dF2n4smvOsRf9aMZQSCAEB294c+/jnF
	 0h2EGSFKRtgs3K9lzaX+g1DxNWbOvqdwYPVL0gVZHJtfgv2B3ORyg81EemlHC0E1j/
	 Ijd3SEEjXrm7cTK0TvvF+XG7DuEx+lRlyK9vTjJEDXOvU1Mh9kbVuZEJoDk6xfRq6Q
	 cHZEzwNSSYRXw==
Date: Sat, 14 Nov 2026 23:05:25 +0800
From: Zorro Lang <zlang@kernel.org>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: test an incremental send scenario with hole
 punching
Message-ID: <avh4IU-M5jYkc1uE@zlang-mailbox>
Mail-Followup-To: fdmanana@kernel.org, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <233845be4bd0fd12b4c62b5ca5243ec1ef4d44f8.1792613768.git.fdmanana@suse.com>
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
In-Reply-To: <233845be4bd0fd12b4c62b5ca5243ec1ef4d44f8.1792613768.git.fdmanana@suse.com>

On Wed, Oct 21, 2026 at 09:17:25PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test an incremental send scenario where we punched a hole into a tail
> section of a file extent item that is the last item in a leaf and the
> next leaf in the subvolume tree was not changed (remains shared between
> the parent and send snapshots).
> 
> This currently fails and is fixed by the following kernel patch:
> 
>   btrfs: send: fix missing hole punching during incremental send
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  tests/btrfs/362     | 84 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/362.out |  7 ++++
>  2 files changed, 91 insertions(+)
>  create mode 100755 tests/btrfs/362
>  create mode 100644 tests/btrfs/362.out
> 
> diff --git a/tests/btrfs/362 b/tests/btrfs/362
> new file mode 100755
> index 00000000..aca56540
> --- /dev/null
> +++ b/tests/btrfs/362
> @@ -0,0 +1,84 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 362
> +#
> +# Test an incremental send scenario where we punched a hole into a tail section
> +# of a file extent item that is the last item in a leaf and the next leaf in the
> +# subvolume tree was not changed (remains shared between the parent and send
> +# snapshots).
> +#
> +. ./common/preamble
> +_begin_fstest auto quick send
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -fr $tmp.*
> +	rm -fr $send_files_dir
> +}
> +
> +. ./common/filter
> +
> +_require_test
> +_require_scratch
> +_require_btrfs_support_sectorsize 4096
> +_require_xfs_io_command "fpunch"
> +
> +_fixed_by_kernel_commit xxxxxxxxxx \
> +	"btrfs: send: fix missing hole punching during incremental send"
> +
> +send_files_dir=$TEST_DIR/btrfs-test-$seq
> +
> +rm -fr $send_files_dir
> +mkdir $send_files_dir
> +
> +first_stream="$send_files_dir/1.send"
> +second_stream="$send_files_dir/2.send"
> +
> +# We need a very specific leaf layout where we punch a hole in the last file
> +# extent item of a leaf and the next leaf was not modified in the send snapshot,
> +# so we set a fixed size of 16K.
> +_scratch_mkfs -n 16K >> $seqres.full 2>&1 || _fail "first mkfs failed"
> +_scratch_mount
> +
> +touch $SCRATCH_MNT/foo
> +# 205 extents of 64K each with a 64K hole between them.
> +for ((i = 0; i < 410; i += 2)); do
> +	offset=$((i * 64 * 1024))
> +	$XFS_IO_PROG -c "pwrite -b 64K -S 0xab $offset 64K" \
> +		$SCRATCH_MNT/foo > /dev/null
> +done
> +
> +_btrfs subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap1
> +
> +# Punch a hole in the last 16K of the last file extent item of the first leaf,
> +# which starts at file offset 12845056, so 12845056 + 64K - 16K = 12894208.
> +# This does not cause any change in the second leaf of the fs tree, so it will
> +# be shared between the snapshots.
> +$XFS_IO_PROG -c "fpunch 12894208 16K" $SCRATCH_MNT/foo
> +
> +_btrfs subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap2
> +
> +echo "File digest in the original fs: $(_md5_checksum $SCRATCH_MNT/snap2/foo)"
> +
> +_btrfs send -f $first_stream $SCRATCH_MNT/snap1
> +_btrfs send -f $second_stream -p $SCRATCH_MNT/snap1 $SCRATCH_MNT/snap2
> +
> +# Create a new fs and apply both send streams.
> +_scratch_unmount
> +_scratch_mkfs >> $seqres.full 2>&1 || _fail "second mkfs failed"
> +_scratch_mount
> +
> +_btrfs receive -f $first_stream $SCRATCH_MNT
> +_btrfs receive -f $second_stream $SCRATCH_MNT
> +
> +echo "File digest in the new fs:      $(_md5_checksum $SCRATCH_MNT/snap2/foo)"
> +
> +# Check the region we punched a hole is full of zeroes.
> +echo "Hole data:"
> +od -A d -t x1 -j 12894208 -N $((16 * 1024)) $SCRATCH_MNT/snap2/foo


Can this be replaced with common helper: _hexdump ?

Thanks,
Zorro

> +
> +# success, all done
> +_exit 0
> diff --git a/tests/btrfs/362.out b/tests/btrfs/362.out
> new file mode 100644
> index 00000000..789abb53
> --- /dev/null
> +++ b/tests/btrfs/362.out
> @@ -0,0 +1,7 @@
> +QA output created by 362
> +File digest in the original fs: a5a06694d9f7fc3245afb2f391636e44
> +File digest in the new fs:      a5a06694d9f7fc3245afb2f391636e44
> +Hole data:
> +12894208 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> +*
> +12910592
> -- 
> 2.53.0
> 
> 
