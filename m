Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4274333B6D9;
	Wed, 20 May 2026 06:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779258035; cv=none; b=XuszmOUar4CsK0hUb0G1zJ9QDFamra72ggahwEf2ADPCSC67EaUQeMe+jj2kfarUP3DiOyUcCAc42/NFwgw1dfGQL0MH/lrKTq260lDDVnNmwReeePV1NWn5KIK8ANG8J4KB1yaQSC/Kxf108Zxv2AC9dV4GjjN2y/t9HR62H5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779258035; c=relaxed/simple;
	bh=7LjUPrOO4x2lp1Qdo3SaZvjKImRG5nzvPVcQmZl28VU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RYpvsIQzu5HWf8UGQ5rz9odrMExcZ/tJSMWI7E641rbF3hvKO/Epz1Yxz27b2htfRKcbI+VlL0DxXUIVv87I2hi91Gr3jR+j3ZkZxGiSRdM+tCTsuWINZmZ+XG9MhVbU9OPOPdbTv37OvYQ8e4qLphjv16jtPxjq3tfC85R5yf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lLqerSYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lLqerSYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069C41F000E9;
	Wed, 20 May 2026 06:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258034;
	bh=fQdDhgd2PvySKItpknuRR1sYdZAI6Yp8CnDqIs7/jYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lLqerSYTUEozdioTTkgtXD4wR/A/rQy9fFUyhgUdxLaP3Cx3r/9XHT6R3nRkVVXQo
	 IDEFHBU6F+Gy3un+Rnx9bQ/9T2wuU8janBt8yC9iLgcOxxRhQPtukyXMo/kKl7K9mV
	 LM6faaXBCxOpyjlfstuPFyWDXpsBZ6NFh293iFfOuFnrqfnzmDz6fcjq2GlNBusqGj
	 b6AuFAKk/QXD6oxHHoTnkLzzUJLA00xiJY9oWMCl8T0YbjR0mrgZ2yLwaFFIpEXa55
	 GkgWXQQu1aPHZyp2Li04nhy9ZiKUvq84H4hiOJ0FT3CAShQHmOIis2vc6VffZ08IXR
	 dO19TBDsXYRPA==
Date: Wed, 20 May 2026 14:20:28 +0800
From: Zorro Lang <zlang@kernel.org>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] generic: add a test case for fallocate i_size extension
Message-ID: <ag1QPepVWjXIT-2X@zlang-mailbox>
Mail-Followup-To: fdmanana@kernel.org, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <a92aea73a82100f1dfde58e6f64191bed1d7f41d.1779210827.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a92aea73a82100f1dfde58e6f64191bed1d7f41d.1779210827.git.fdmanana@suse.com>

On Tue, May 19, 2026 at 06:14:10PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test an i_size expanding fallocate into a range beyond current i_size that
> already has a preallocated extent, with an unmount and mount after each
> fallocate to verify that no metadata (i_size) and extents were lost.
> 
> This used to fail on btrfs when not using the no-holes feature (which is
> a default since btrfs-progs 5.15) before this recent kernel fix:
> 
>   c562ba61fc5e ("btrfs: fix incorrect i_size after remount caused by KEEP_SIZE prealloc gap")
> 
> So in order to reproduce the failure when using an unpatched kernel and
> a btrfs-progs >= 5.15, one must run the test with:
> 
>   MKFS_OPTIONS="-O ^no-holes"
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---

Classic, Filipe! As standard as always. Even the tiny details like comments,
groups, _require_congruent_file_oplen and so on are perfect.

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/generic/795     | 52 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/795.out |  5 +++++
>  2 files changed, 57 insertions(+)
>  create mode 100755 tests/generic/795
>  create mode 100644 tests/generic/795.out
> 
> diff --git a/tests/generic/795 b/tests/generic/795
> new file mode 100755
> index 00000000..299c8134
> --- /dev/null
> +++ b/tests/generic/795
> @@ -0,0 +1,52 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 795
> +#
> +# Test an i_size expanding fallocate into a range beyond current i_size that
> +# already has a preallocated extent, with an unmount and mount after each
> +# fallocate to verify that no metadata (i_size) and extents were lost.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick prealloc fiemap
> +
> +. ./common/punch # for _filter_fiemap
> +
> +_require_scratch
> +_require_xfs_io_command "falloc" "-k"
> +_require_xfs_io_command "fiemap"
> +
> +_fixed_by_fs_commit btrfs c562ba61fc5e \
> +	"btrfs: fix incorrect i_size after remount caused by KEEP_SIZE prealloc gap"
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +# The fiemap results in the golden output requires file allocations to align to
> +# 1M boundaries.
> +_require_congruent_file_oplen $SCRATCH_MNT 1048576
> +
> +# Create our file with a size of 0 and a prealloc extent in the range [4M, 8M].
> +$XFS_IO_PROG -f -c "falloc -k 4M 4M" $SCRATCH_MNT/foo
> +
> +# Unmount and mount again to remove any in memory state of the inode. We will
> +# verify later that neither metadata nor extents were lost during unmount.
> +_scratch_cycle_mount
> +
> +# Do an i_size expanding fallocate that overlaps the previous prealloc range
> +# and extents past it. This increases the file size to 9M and allocates an
> +# extent in the range [8M, 9M].
> +$XFS_IO_PROG -c "falloc 7M 2M" $SCRATCH_MNT/foo
> +
> +# Unmount and mount again to remove any in memory state of the inode. We will
> +# verify later that neither metadata nor extents were lost during unmount.
> +_scratch_cycle_mount
> +
> +# File size should be 9M and we should have unwritten extents in range [4M, 9M].
> +echo "File size after cycle mounts: $(stat -c %s $SCRATCH_MNT/foo)"
> +echo "Fiemap output:"
> +$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foo | _filter_fiemap
> +
> +# Success, all done.
> +_exit 0
> diff --git a/tests/generic/795.out b/tests/generic/795.out
> new file mode 100644
> index 00000000..b2f78ac0
> --- /dev/null
> +++ b/tests/generic/795.out
> @@ -0,0 +1,5 @@
> +QA output created by 795
> +File size after cycle mounts: 9437184
> +Fiemap output:
> +0: [0..8191]: hole
> +1: [8192..18431]: unwritten
> -- 
> 2.47.2
> 
> 
