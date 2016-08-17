Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbcHQIpl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Aug 2016 04:45:41 -0400
Date: Wed, 17 Aug 2016 16:45:39 +0800
From: Eryu Guan <eguan@redhat.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, fstests@vger.kernel.org,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] btrfs/131: test for umount of read-only fs when
 quota rescan is paused
Message-ID: <20160817084539.GS27776@eguan.usersys.redhat.com>
References: <2f102cc7-a6b2-e23d-9c56-de6c6bc5110d@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2f102cc7-a6b2-e23d-9c56-de6c6bc5110d@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 16, 2016 at 02:30:21PM -0400, Jeff Mahoney wrote:
> Ensure that we can unmount a read-only file system when quota rescan
> is paused from a previous read-write mount.
> 
> If the kernel has a separate bug where we are returning early while
> waiting for the rescan worker, we can use that to un-hang the test,
> and report both errors.
> 
> This issue is resolved by the following patch for the Linux kernel:
> "btrfs: properly track when rescan worker is running"
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  tests/btrfs/131     | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/131.out |   3 ++
>  tests/btrfs/group   |   1 +
>  3 files changed, 104 insertions(+)
>  create mode 100755 tests/btrfs/131
>  create mode 100644 tests/btrfs/131.out
> 
> diff --git a/tests/btrfs/131 b/tests/btrfs/131
> new file mode 100755
> index 0000000..56c38a2
> --- /dev/null
> +++ b/tests/btrfs/131
> @@ -0,0 +1,100 @@
> +#! /bin/bash
> +# FS QA Test 131
> +#
> +# Test for bug where read-only mounts will hang on umount when
> +# a qgroup rescan was paused.  This also tests whether that hung
> +# umount can be unhung by trying to make use of a separate bug that
> +# means we can interrupt the wait for the rescan worker.  If that
> +# happens, we report both errors.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 SUSE.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +_supported_os Linux
> +
> +# We'll exit with a quota rescan paused
> +_require_scratch_nocheck
> +
> +_require_btrfs
> +BTRFS_DEBUG_TREE_PROG="`set_prog_path btrfs-debug-tree`"
> +_require_command "$BTRFS_DEBUG_TREE_PROG" btrfs-debug-tree
> +TIMEOUT_PROG="`set_prog_path timeout`"
> +_require_command "$TIMEOUT_PROG" timeout

The "set_prog_path" calls belong to common/config, we only need
"_require_command" calls in test.

> +
> +rm -f $seqres.full
> +_scratch_mkfs >>$seqres.full 2>&1
> +
> +_scratch_mount
> +cp -aR /lib/modules/$(uname -r) $SCRATCH_MNT

Consider populating the filesystem using _populate_fs or fsstress?

> +
> +# A qgroup rescan on an empty or small file system completes nearly
> +# immediately.  We need to ensure that it runs long enough that it will
> +# be paused on umount.  Snapshots slow down the rescan so we should see
> +# the race without a lot of data.  This is an arbitrary number that
> +# works on a ramdisk so it should be sufficient for any storage.
> +for n in $(seq 1 100); do
> +  _run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/$n

Use tab for indention.

> +done
> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> +_scratch_unmount
> +
> +echo "read-write umount completed"
> +
> +# Confirm that the rescan is paused
> +if ! $BTRFS_DEBUG_TREE_PROG $SCRATCH_DEV | \
> +	egrep -q 'flags ON|SCANNING|INCONSISTENT scan'; then
> +	echo "qgroup rescan not paused."
> +fi
> +_scratch_mount -r
> +
> +# If the bug exists, this will hang.  If we can kill it, that's another bug.
> +$TIMEOUT_PROG 10 umount $SCRATCH_MNT
> +if test $? -eq 124 ; then
> +    echo "umount hung but was killed"

I see this log with 4.8-rc1 kernel, is that expected?

Thanks,
Eryu

> +fi
> +echo "read-only umount completed"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/131.out b/tests/btrfs/131.out
> new file mode 100644
> index 0000000..845a501
> --- /dev/null
> +++ b/tests/btrfs/131.out
> @@ -0,0 +1,3 @@
> +QA output created by 131
> +read-write umount completed
> +read-only umount completed
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 6b29c05..929fa21 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -133,3 +133,4 @@
>  128 auto quick send
>  129 auto quick send
>  130 auto clone send
> +131 auto quick qgroup
> -- 
> 1.8.5.6
> 
> 
> -- 
> Jeff Mahoney
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
