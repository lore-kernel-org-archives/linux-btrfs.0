Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CE2285CB3;
	Mon, 11 May 2026 15:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778512868; cv=none; b=PAxTpTrIdsUgbFb9E4nqNlKwYk40iaCiLIrBZ6jYCSFZqUZ4g3PQzyQEUaqXM+1J9p2WP1i68kqdpm4vP/UCT+bf/rcdVL+Xmawo31E819SEpGYpOSi+swH87Gc2KyXgJpCUXJc89+R5wJAQWw6HBSgWMkY3455+9W+R4rgE6oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778512868; c=relaxed/simple;
	bh=eqi5imCbejju5DCLSZj6Z+bxoaMuWn6CMFQWrWBH6+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lVb29gdUmAEymFr+X6mqaw9IOKMDKdNRq/u59F03BJDa88pEVhs6qjgsZnuBxaXADDfF4j5x3SQoyh6ZOWT6NbxU3g7nXkIHa5aVvDFntIuCGCPgZVyKHreE87EPucSocdu+2FD4tEBxLsl4kg/6VpAcoob1AYD1TxzCdqh8JJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ap4FI0Db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ap4FI0Db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD6FC2BCB0;
	Mon, 11 May 2026 15:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778512867;
	bh=eqi5imCbejju5DCLSZj6Z+bxoaMuWn6CMFQWrWBH6+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ap4FI0Dbg2QO5GVnBdFbkLgtCFp8WIi6H8O1+FpuVZY/LnmYYTBfwWFYSzhSmu3Ir
	 BHk/ZAQaEWoBKtTIZIuMZpLgWM2VoNyd8EfFvv1zT36HHh3RVuQMfjcilG7oMAQ5Dr
	 VQEiILcYo16AG6Wk1+1HH6Sa3PgJd168rpiRuKa91n+Hs+kh4llh3y/earTQe5iUMb
	 3RJrkgHy7fs8UI96wL3Z6nfYmZoCth7VkOc32RyyQ9Tz/188pBCwNyTCybu9pjrkWK
	 xOobNBiGlIx8CZl1v4cUZWhAn9T8LYfMwCUd5NQx7WN/amf53USqHMwdlf1amUcaVJ
	 euu2v2Bd9qQvg==
Date: Mon, 11 May 2026 23:20:57 +0800
From: Zorro Lang <zlang@kernel.org>
To: Disha Goel <disgoel@linux.ibm.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org, fdmanana@kernel.org, 
	quwenruo.btrfs@gmx.com, anajain.sg@gmail.com
Subject: Re: [PATCH v3 2/2] btrfs/291: fix state transition logic and add
 size requirement
Message-ID: <agHogPMQGKqAHkIT@zlang-mailbox>
Mail-Followup-To: Disha Goel <disgoel@linux.ibm.com>, 
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, ritesh.list@gmail.com, 
	ojaswin@linux.ibm.com, djwong@kernel.org, fdmanana@kernel.org, quwenruo.btrfs@gmx.com, 
	anajain.sg@gmail.com
References: <20260508144701.68561-1-disgoel@linux.ibm.com>
 <20260508144701.68561-2-disgoel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508144701.68561-2-disgoel@linux.ibm.com>

On Fri, May 08, 2026 at 08:17:01PM +0530, Disha Goel wrote:
> This patch fixes two issues in btrfs/291:
> 
> 1. Add dynamic LOGWRITES_DEV size requirement based on SCRATCH_DEV
>    The test creates LVM snapshots at each FUA point during replay,
>    requiring significant space. Calculate the required size as 120%
>    of SCRATCH_DEV size (adding 20% overhead for LVM snapshots and
>    metadata) to ensure the test works regardless of SCRATCH_DEV size.
> 
> 2. Fix state transition logic for verity enablement
>    The original test assumed orphan items would always be created
>    during verity enablement (state 0->1 transition). However, in
>    some cases verity completes without creating orphan items,
>    causing the test to fail with "expected to reach verity done state".
> 
>    Fix by transitioning to state 1 when either orphan items exist
>    OR merkle items appear, handling both verity enablement paths.
>    Also improve state 1 validation to only check for cleared merkle
>    items when measurement actually fails.
> 
> The test now correctly handles verity enablement with or without
> orphan items while maintaining crash consistency validation, and
> works with any SCRATCH_DEV size.
> 
> Suggested-by: Anand Jain <anajain.sg@gmail.com>
> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
> ---
> v2 -> v3:
> - Calculate LOGWRITES_DEV size requirement dynamically based on SCRATCH_DEV
>   size (120% of SCRATCH_DEV) instead of fixed 9GB
> - This fixes test failures when SCRATCH_DEV > 9GB, as reported by Anand
> 
>  tests/btrfs/291 | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/tests/btrfs/291 b/tests/btrfs/291
> index 122aeaa5..e5ea4b50 100755
> --- a/tests/btrfs/291
> +++ b/tests/btrfs/291
> @@ -36,7 +36,9 @@ _cleanup()
>  _require_scratch
>  _require_test
>  _require_loop
> -_require_log_writes
> +scratch_size=$(_get_device_size $SCRATCH_DEV)
> +required_log_size=$((scratch_size * 120 / 100))
> +_require_log_writes_sized $required_log_size

OK, more 20% space makes sense.

>  _require_dm_target snapshot
>  _require_command $LVM_PROG lvm
>  _require_scratch_verity
> @@ -129,9 +131,14 @@ do
>  	_udev_wait /dev/mapper/$vgname-$snapname
>  
>  	orphan=$(count_item $snap_dev ORPHAN)
> -	[ $state -eq 0 ] && [ $orphan -gt 0 ] && state=1
> -
>  	pre_mount=$(count_merkle_items $snap_dev)
> +
> +	if [ $state -eq 0 ]; then
> +		if [ $orphan -gt 0 ] || [ $pre_mount -gt 0 ]; then

Hm, this's this exception you metioned in commit log, so if we find
merkle items, no matter where's it from, we need to deal with them
later, so set state to 1.

> +			state=1
> +		fi
> +	fi
> +
>  	_mount $snap_dev $SCRATCH_MNT || _fail "mount failed at entry $cur"
>  	fsverity measure $SCRATCH_MNT/fsv >>$seqres.full 2>&1
>  	measured=$?
> @@ -143,8 +150,10 @@ do
>  	echo "entry: $cur, state: $state, orphan: $orphan, pre_mount: $pre_mount, post_mount: $post_mount" >> $seqres.full
>  
>  	if [ $state -eq 1 ]; then
> -		[ $post_mount -eq 0 ] || \
> -			_fail "mount failed to clear under-construction merkle items pre: $pre_mount, post: $post_mount at entry $cur";
> +		if [ $measured -ne 0 ]; then
> +			[ $post_mount -eq 0 ] || \

OK, fix same situation you metioned.

From the code logic, this change is good to me.

Reviewed-by: Zorro Lang <zlang@kernel.org>

I just have one more question, this case is written in 2021, now it's 2026. It
still fails on latest test with kernel 7.1.0-0.rc2 and btrfs-progs-6.19.1-1.fc45,
no matter with or without this patch.

Is that expected by btrfs? Is there a known kernel commit uncovered by this case?

Thanks,
Zorro

# ./check btrfs/291
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 localhost 7.1.0-0.rc2.260505ga293ec25d59dd.17.fc45.x86_64 #1 SMP PREEMPT_DYNAMIC Tue May  5 17:39:29 UTC 2026
MKFS_OPTIONS  -- /dev/vdd
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/vdd /mnt/scratch

btrfs/291          _check_btrfs_filesystem: filesystem on /dev/vdd is inconsistent
(see /root/xfstests/results//btrfs/291.full for details)

Ran: btrfs/291
Failures: btrfs/291
Failed 1 of 1 tests

Thanks,
Zorro

> +				_fail "mount failed to clear under-construction merkle items pre: $pre_mount, post: $post_mount at entry $cur";
> +		fi
>  	fi
>  	if [ $state -eq 2 ]; then
>  		[ $pre_mount -gt 0 ] || \
> -- 
> 2.45.1
> 
