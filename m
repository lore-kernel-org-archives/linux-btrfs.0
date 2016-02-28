Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:58693 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755162AbcB1Wmn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 17:42:43 -0500
Date: Mon, 29 Feb 2016 09:42:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 5/5] fstests: btrfs: Test inband dedup with
 balance.
Message-ID: <20160228224228.GD29057@dastard>
References: <1456301196-15874-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1456301196-15874-6-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456301196-15874-6-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2016 at 04:06:36PM +0800, Qu Wenruo wrote:
> Btrfs balance will reloate date extent, but its hash is removed too late
> at run_delayed_ref() time, which will cause extent ref increased
> increased during balance, cause either find_data_references() gives
> WARN_ON() or even run_delayed_refs() fails and cause transaction abort.
> 
> Add such concurrency test for inband dedup and balance.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
...
> +for n in $(seq 1 $nr); do
> +	$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $dedup_bs" \
> +		${file}_${n} > /dev/null 2>&1
> +done

_populate_fs(), please.

> +
> +kill $balance_pid &> /dev/null
> +wait
> +
> +# Sometimes even we killed $balance_pid and wait returned,
> +# balance may still be running, use balance cancel to wait it.
> +_run_btrfs_util_prog balance cancel $SCRATCH_MNT &> /dev/null

This needs to be in the cleanup function.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
