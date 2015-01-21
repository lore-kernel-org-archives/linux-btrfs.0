Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50064 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbbAUE0m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 23:26:42 -0500
Date: Wed, 21 Jan 2015 15:26:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, fdmanana@gmail.com
Subject: Re: [PATCH v2] xfstests: btrfs: fix up 001.out
Message-ID: <20150121042627.GF16510@dastard>
References: <1420055304-4633-1-git-send-email-anand.jain@oracle.com>
 <1420203869-26085-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1420203869-26085-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 02, 2015 at 09:04:29PM +0800, Anand Jain wrote:
> The subvol delete output has changed with btrfs-progs
>     -Delete subvolume 'SCRATCH_MNT/snap'
>     +Delete subvolume (no-commit): 'SCRATCH_MNT/snap'
> 
> so fix 001 failing.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> v2: Thanks Filipe for mentioning now we have _run_btrfs_util_prog. and
>     commit update
> ---
>  tests/btrfs/001     | 2 +-
>  tests/btrfs/001.out | 1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tests/btrfs/001 b/tests/btrfs/001
> index 8258d06..a7747c8 100755
> --- a/tests/btrfs/001
> +++ b/tests/btrfs/001
> @@ -99,7 +99,7 @@ echo "Listing subvolumes"
>  $BTRFS_UTIL_PROG subvolume list $SCRATCH_MNT | awk '{ print $NF }'
>  
>  # Delete the snapshot
> -$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/snap | _filter_btrfs_subvol_delete
> +_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/snap

This is also the wrong way to fix the problem.

We have output filters for a reason, people:

_filter_btrfs_subvol_delete()
{
	_filter_scratch | _filter_transcation_commit_default
}

Simply becomes:

_filter_btrfs_subvol_delete()
{
	_filter_scratch | _filter_transcation_commit_default | \
		sed -e 's/^Delete subvolume.*:/Delete subvolume/'
}

The golden output does not change - the filter simply removes the
part of the message that changed between versions.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
