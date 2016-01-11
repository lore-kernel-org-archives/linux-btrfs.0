Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34522 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757173AbcAKDl0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jan 2016 22:41:26 -0500
Date: Mon, 11 Jan 2016 14:41:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 1/4 v2] fstests: fix btrfs test failures after commit
 27d077ec0bda
Message-ID: <20160111034119.GG10456@dastard>
References: <1450845795-18729-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450845795-18729-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 23, 2015 at 04:43:12AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Commit 27d077ec0bda (common: use mount/umount helpers everywhere) made
> a few btrfs test fail for 2 different reasons:
> 
> 1) Some tests (btrfs/029 and btrfs/031) use $SCRATCH_MNT as a mount
>    point for some subvolume created in $TEST_DEV, therefore calling
>    _scratch_unmount does not work as it passes $SCRATCH_DEV as the
>    argument to the umount program. This is intentional to test reflinks
>    accross different mountpoints of the same filesystem but for different
>    subvolumes;
> 
> 2) For multiple devices filesystems (btrfs/003 and btrfs/011) that test
>    the device replace feature, we need to unmount using the mount path
>    ($SCRATCH_MNT) because unmounting using one of the devices as an
>    argument ($SCRATCH_DEV) does not always work - after replace operations
>    we get in /proc/mounts a device other than $SCRATCH_DEV associated
>    with the mount point $SCRATCH_MNT (this is mentioned in a comment at
>    btrfs/011 for example), so we need to pass that other device to the
>    umount program or pass it the mount point.
> 
> Using $SCRATCH_MNT as a mountpoint for a device other than $SCRATCH_DEV is
> misleading, but that's a different problem that existed long before and
> this change attempts only to fix the regression from 27d077ec0bda, leaving
> such cleanups to later.
> Fix this by making _sctatch_unmmount() pass $SCRATCH_MNT to umount instead
> of $SCRATCH_DEV.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Change _sctatch_unmount() to pass $SCRATCH_MNT as the argument to the
>     umount program instead of $SCRATCH_DEV. This makes the btrfs tests
>     pass again.
> 
>  common/rc | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index d33e3fb..16a47fe 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -319,7 +319,7 @@ _scratch_unmount()
>  	if [ "$FSTYP" == "overlay" ]; then
>  		_overlay_scratch_unmount
>  	else
> -		$UMOUNT_PROG $SCRATCH_DEV
> +		$UMOUNT_PROG $SCRATCH_MNT
>  	fi

This causes generic/050 to fail (and there's probably others, too):

@@ -15,7 +15,7 @@
     mount: SCRATCH_DEV is write-protected, mounting read-only
     mount: cannot mount SCRATCH_DEV read-only
     unmounting read-only filesystem
    -umount: SCRATCH_DEV: not mounted
    +umount: SCRATCH_MNT: not mounted
     mounting filesystem with -o norecovery on a read-only device:
     mount: SCRATCH_DEV is write-protected, mounting read-only
    ...

And, looking at the change for a second or two, the above code is
obviously wrong. Have a look at _overlay_scratch_unmount() and have
a think about what we normally do when multiple fileystem types need
a non-standard behaviour for a generic operation?

Hint: it starts with 'case "$FSTYP" in'....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
