Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31984 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431AbbIWCrM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 22:47:12 -0400
Date: Wed, 23 Sep 2015 12:47:08 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: add test for quota groups and drop
 snapshot
Message-ID: <20150923024708.GK3902@dastard>
References: <20150922221649.GB17854@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150922221649.GB17854@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 03:16:49PM -0700, Mark Fasheh wrote:
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	rm -fr $tmp
> +}

Missing a "cd /" (see the "new" template).

> +# Create an fs tree of a given height at a target location. This is
> +# done by agressively creating inline extents to expand the number of
> +# nodes required. We also add an traditional extent so that
> +# drop_snapshot is forced to walk at least one extent that is not
> +# stored in metadata.
> +#
> +# NOTE: The ability to vary tree height for this test is very useful
> +# for debugging problems with drop_snapshot(). As a result we retain
> +# that parameter even though the test below always does level 2 trees.
> +_explode_fs_tree () {
> +    local level=$1;
> +    local loc="$2";
> +    local bs=4095;
> +    local cnt=1;
> +    local n;

8 space tabs, please.

> +
> +    mkdir -p $loc
> +    for i in `seq -w 1 $n`;
> +    do

	for ... ; do

> +	dd status=none if=/dev/zero of=$loc/file$i bs=$bs count=$cnt

Please use xfs_io, not dd. It's also only ever writing a single
block of 4095 bytes, so you can drop the bs/cnt variables and just
use:

	$XFS_IO_PROG -f -c "pwrite 0 4095" $loc/file$i > /dev/null 2>&1

> +    done
> +
> +    bs=131072
> +    cnt=1
> +    dd status=none if=/dev/zero of=$loc/extentfile bs=$bs count=$cnt

Variables for a single use? :P

	$XFS_IO_PROG -f -c "pwrite 0 128k $loc/extentfile > /dev/null 2>&1

> +# Force the default leaf size as the calculations for making our btree
> +# heights are based on that.
> +run_check _scratch_mkfs "--nodesize 16384"

Please, no new users of run_check.

> +# Remount to clear cache, force everything to disk
> +_scratch_unmount
> +_scratch_mount

_scratch_remount

> +# Finally, delete snap1 to trigger btrfs_drop_snapshot(). This
> +# snapshot is most interesting to delete because it will cause some
> +# nodes to go exclusively owned for snap2, while some will stay shared
> +# with the default subvolume. That exercises a maximum of the drop
> +# snapshot/qgroup interactions.
> +#
> +# snap2s imlied ref from to the 128K extent in files/ can be lost by
> +# the root finding code in qgroup accounting due to snap1 no longer
> +# providing a path to it. This was fixed by the first two patches
> +# referenced above.
> +_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/snap1
> +
> +# There is no way from userspace to force btrfs_drop_snapshot to run
> +# at a given time (even via mount/unmount). We must wait for it to
> +# start and complete. This is the shortest time on my tests systems I
> +# have found which always allows drop_snapshot to run to completion.
> +sleep 45

Which means it will not be long enough for someone else. We've had
this discussion before - btrfs needs a way to query if a background
operation is in progress or not....

> +_scratch_unmount
> +
> +# generate a qgroup report and look for inconsistent groups
> +#  - don't use _run_btrfs_util_prog here as it captures the output and
> +#    we need to grep it.
> +$BTRFS_UTIL_PROG check --qgroup-report $SCRATCH_DEV 2>&1 | grep -E -q "Counts for qgroup.*are different"
> +if [ $? -ne 0 ]; then
> +    status=0
> +fi

Thereby demonstrating why run_check and functions that use it are
considered harmful.... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
