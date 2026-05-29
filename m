Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE1D3B3BE9;
	Fri, 29 May 2026 08:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780041863; cv=none; b=ckyDQIKt7t9jv5HxpaLbwo0JwT/ASGQbCd6JwWEpjRoxLsf2QySX3APMSgw6l5ajcI1vomcICkxwEE+Bo15W1NXIeaqID0PqyOXBQi5rbMdk5/UNWuFTnG29i22ONquX4St89hehcB9n7u8yWIQwzPVdZDEv7xd7PB94tCpgB2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780041863; c=relaxed/simple;
	bh=R9cklFJYtB1FibLakqag4lyWcWAxRMWiS6noL4bbADg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3RemWET7CJ+qWl97SXzXwj2NAJAWFxj5mWxUUiKP8uW+ptiaMuheGdLIcCTmEoCdCBBtstz9hAUKQ/tNCOjH/aXuIPXxlYdi3iSjETM487bS8gqIdGNw1uLECMEfv1ul9qUNC1VhQLoZzrnbyEAHa/fF3eom6Y4nyZPA+n2AHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BAgOBOim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BAgOBOim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD43F1F00893;
	Fri, 29 May 2026 08:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780041862;
	bh=S1LAc+tOiG5+avfY8MoOI0Ns+kmhToOfwbXRe5wuLt0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BAgOBOim4VbFON+PL8JUFsv4+EjfhDlJBCwg2JjCekLm85Bsmhf3NuMMLVbC2cj0z
	 QCeYnNEwpUnd3LfKMMFWJg1mbos471KPAr3cEtD/fRfq+vc82G5zgnJ0zGc3bB3sVz
	 fXNuPx2Yjvmj6aY93CB6jWRL7PdWoTv8hKtHjOyRQP2JNl+Ii0WY43d13331xNl4sT
	 RBVxcXl9zTEwyZllUxLikOpa2SwkxXKANt4hBzBeD46UG5Z2XpnH6z03+iDFqk4quQ
	 Fk2Dt8qJnsTqucHX5Ju1sgQfs15nBThoejZfPrFEgpdWOw89Re6otPdVFQhWqRm0SS
	 p4tqyr7zo8H1g==
Date: Fri, 29 May 2026 16:04:17 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: add a new test case for single data
 RAID56
Message-ID: <ahlHVCZDpwvrhowj@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org
References: <20260524050848.57740-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260524050848.57740-1-wqu@suse.com>

On Sun, May 24, 2026 at 02:38:48PM +0930, Qu Wenruo wrote:
> Although single-data-RAID56, aka 2 disks raid5 or 3 disks raid6, is
> not recommended for btrfs, btrfs still supports it as there are cases
> like degraded writes can still lead to such cases.
> 
> But we do not have any proper tests for such corner cases.
> 
> Furthermore, RAID56 lib is going to drop the support of
> single-data-RAID56, and btrfs will have its own handling of such cases,
> thus coverage on single-data-RAID56 is required.
> 
> This new test case will have the following workload to verify the
> behavior:
> 
> - Create a fs with single-data-RAID56
> 
> - Populate the fs with fsx and fsstress
>   Fsx and fsstress will utilize read and write paths of RAID56.
> 
> - Mount each device in degraded mode and run read-only scrub on them
>   Such scrub will utilize the following path of RAID56:
>   * Regular data read
>   * Reconstruction read
>   * P/Q stripe scrub
> 
> - Re-scan all devices and add a new disk to the array
> - Balance all data and scrub again
>   This should utilized non-single-data-RAID56 handling.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---

This test case is highly standardized and complete! Thanks

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/btrfs/348     | 68 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/348.out |  2 ++
>  2 files changed, 70 insertions(+)
>  create mode 100755 tests/btrfs/348
>  create mode 100644 tests/btrfs/348.out
> 
> diff --git a/tests/btrfs/348 b/tests/btrfs/348
> new file mode 100755
> index 00000000..748e5a86
> --- /dev/null
> +++ b/tests/btrfs/348
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 348
> +#
> +# Basic function test for single-data-RAID56.
> +#
> +. ./common/preamble
> +_begin_fstest auto raid
> +
> +# 3 disks for single-data-raid6, but one extra to make sure btrfs can still properly
> +# convert to regular 4 disks raid6.
> +_require_scratch_dev_pool 4
> +_require_btrfs_raid_type raid5
> +_require_btrfs_raid_type raid6
> +_require_btrfs_forget_or_module_loadable
> +
> +# Make sure we have support RAID1C34 first
> +if [ ! -f "/sys/fs/btrfs/features/raid1c34" ]; then
> +	_notrun "no RAID1C34 support"
> +fi
> +
> +common_workload()
> +{
> +	_scratch_mount
> +	_run_fsx_on_file $FSX_AVOID "$SCRATCH_MNT/foobar" -q -N 10000 >> $seqres.full
> +	_run_fsstress -w -n 10000 -d "$SCRATCH_MNT"
> +	_scratch_unmount
> +
> +	# Mount each device degraded and run a scrub to exercise:
> +	# - Regular data read
> +	# - Data reconstruction read
> +	# - P/Q scrub
> +	for dev in $SCRATCH_DEV_POOL; do
> +		_btrfs_forget_or_module_reload
> +
> +		_mount -o ro,degraded "$dev" "$SCRATCH_MNT"
> +		_btrfs scrub start -Br "$SCRATCH_MNT"
> +		_scratch_unmount
> +	done
> +
> +	# Add a new device, balance all data, and re-scrub to make sure
> +	# regular RAID56 is still working.
> +	_btrfs_rescan_devices
> +	_spare_dev_get
> +	_scratch_mount
> +	_btrfs device add -f "$SPARE_DEV" "$SCRATCH_MNT"
> +	_btrfs balance start -d "$SCRATCH_MNT"
> +	_btrfs scrub start -B "$SCRATCH_MNT"
> +	_scratch_unmount
> +	_spare_dev_put
> +}
> +
> +_scratch_dev_pool_get 2
> +# There will be a warning about single-data-RAID56, thus need
> +# to redirect stderr
> +_scratch_pool_mkfs -m raid1 -d raid5 >> $seqres.full 2>&1
> +common_workload
> +_scratch_dev_pool_put
> +
> +_scratch_dev_pool_get 3
> +_scratch_pool_mkfs -m raid1c3 -d raid6 >> $seqres.full 2>&1
> +common_workload
> +_scratch_dev_pool_put
> +
> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/btrfs/348.out b/tests/btrfs/348.out
> new file mode 100644
> index 00000000..ec5e4701
> --- /dev/null
> +++ b/tests/btrfs/348.out
> @@ -0,0 +1,2 @@
> +QA output created by 348
> +Silence is golden
> -- 
> 2.51.2
> 
> 
