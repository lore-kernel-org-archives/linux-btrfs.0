Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F2A37DAAA;
	Thu,  8 Oct 2026 14:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791469383; cv=none; b=f4+xoJe4B6Z87tB4QiOlYsjHfXp/zYPdAm0QVJoZsenwgapaMW4tLkBPsK/A51Fy9cSH9XkgM2f9g3Cchn/Ne7oTwrXdy0HyJop27szsQTCB8YX+Af+2jv36CjnzuGH1ChckWv5QrOPcN0Fr2Ty8PpbHhu5cW5arU3CrWfp34Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791469383; c=relaxed/simple;
	bh=QlDTtVGkxkOHwoQSpmT1n/39Zjt9nhqIV38hM+vXpGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sL6MNUt3lppT0d6Aw/VPfUZTsuV1wcTGkI9pDG7ROfHXk/bVMNfyktAt0i6BXW4cgx7MjCbcHjU2TD4cN9dUBc/vUHdr/D/+mZqRXPGq8yGWcyPzFdGoU03eyE+lCTujRg8oiyVNehPe+bEEZ0cyiroWqBIHME9gai/o373ukOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvQ5hp0T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvQ5hp0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382951F000FF;
	Thu,  8 Oct 2026 14:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791469379;
	bh=v2fEigo5J0h1flVl0mtadJngQ3ZdGH2v9hWbqhaMhUE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hvQ5hp0TTB2e7MiHHgQ2E3kTQZJ4sk/eWNSLgIFTnizusEpg02cw8mlJEyXjRrMcK
	 rG0UAEWIFS7bEsCeWqwOhB90VyvzCDn4MyC8/ElNdaCGDJyx4h38Mn2klmt6le4LiU
	 BPWlKmUtxwHBaF5LpCtg1afyJAk8CzRRfP8yAlPLIYqXunEP86ooxCCTHqnL+QMjX4
	 A8U3wTp+k3H8Qtq3lGWmu6/0dN+IQMQMJtpcWaPBPbnLjUjv/8UzlG1D4Sumiqga0J
	 bi/yuEud06okcJeMhYBHF7ReBHbqlneIoM8+OvcqfP0BkFIoeI100fTraWRRIh8qYS
	 Cw/gwF6ZK7/9g==
Date: Thu, 8 Oct 2026 22:22:54 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: add a new test case to verify degraded
 RMW writes
Message-ID: <asem9MOVUpDOBMB2@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
	fstests@vger.kernel.org
References: <20261001041008.39697-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001041008.39697-1-wqu@suse.com>

On Thu, Oct 01, 2026 at 01:40:08PM +0930, Qu Wenruo wrote:
> This is a regression test for a recent reported bug.
> 
> The test workload is pretty straightforward:
> 
> - Create a 4 disks RAID5 or RAID6 btrfs
> 
> - Destroy one disk and mount the btrfs degraded
> 
> - Use fio to do a workload meeting all the following conditions
>   * Triggering a RMW write
>     This is done by using buffered write with 8 4K writes.
>     The total write will not fulfill a full stripe, thus it will
>     always go through RMW.
> 
>   * Some blocks of the full stripe have csum and some do not
>     This is done by pre-allocating the target file before testing, so
>     every full stripe does not have any csum by default.
> 
>     Then after some writes, there will be checksum for those new writes,
>     resulting blocks with mixed data checksum.
> 
>   * Detect RMW failure
>     This is done through fdatasync.
> 
> For unpatched kernels, the fio will always fail pretty early, meanwhile
> patched kernels can finish the full 15 seconds runs on both RAID5 and
> RAID6 profiles.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---

A standard and clear test case. Acked.

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/btrfs/357     | 65 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/357.out |  2 ++
>  2 files changed, 67 insertions(+)
>  create mode 100755 tests/btrfs/357
>  create mode 100644 tests/btrfs/357.out
> 
> diff --git a/tests/btrfs/357 b/tests/btrfs/357
> new file mode 100755
> index 00000000..f2c04285
> --- /dev/null
> +++ b/tests/btrfs/357
> @@ -0,0 +1,65 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 357
> +#
> +# Make sure on degraded RAID5/6, RMW writes won't return false errors
> +# when some blocks do not have checksums.
> +#
> +. ./common/preamble
> +
> +_begin_fstest auto raid volume
> +
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: raid56: do not verify the content if there is no data checksum"
> +
> +_require_command "$WIPEFS_PROG" wipefs
> +_require_scratch_dev_pool 4
> +_scratch_dev_pool_get 4
> +
> +fio_job_file=$tmp.fio
> +cat > $fio_job_file << EOF
> +[sync_randwrite]
> +directory=$SCRATCH_MNT
> +rw=randwrite
> +filesize=512M
> +bs=4K
> +fdatasync=8
> +time_based
> +fallocate=posix
> +runtime=15
> +EOF
> +
> +_require_fio "$fio_job_file"
> +
> +# The target to remove for degraded mount.
> +dev2="${SCRATCH_DEV_NAME[1]}"
> +
> +workload()
> +{
> +	local profile=$1
> +	_scratch_pool_mkfs "-m raid1 -d $profile" >> $seqres.full 2>&1
> +	$WIPEFS_PROG -fa "$dev2" >> $seqres.full 2>&1
> +	_scratch_mount -o degraded
> +
> +	# The fio job will do fsync after 8 4K writes, which is not enough to
> +	# fill a full stripe and always trigger RMW.
> +	# And the target file is preallocated, after some writes a full stripe
> +	# can have blocks with csum and some blocks without csum.
> +	#
> +	# Unpatched kernels will try to verify the checksum even if there is no
> +	# csum and fail the RMW, causing fio to fail.
> +	$FIO_PROG $fio_job_file >> $seqres.full 2>&1
> +	if [ $? -ne 0 ]; then
> +		echo "fio failed on degraded $profile"
> +	fi
> +	_scratch_unmount
> +}
> +
> +workload raid5
> +workload raid6
> +
> +_scratch_dev_pool_put
> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/btrfs/357.out b/tests/btrfs/357.out
> new file mode 100644
> index 00000000..25875c6d
> --- /dev/null
> +++ b/tests/btrfs/357.out
> @@ -0,0 +1,2 @@
> +QA output created by 357
> +Silence is golden
> -- 
> 2.51.2
> 
> 
