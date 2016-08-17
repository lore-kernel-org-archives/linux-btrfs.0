Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbcHQIzC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Aug 2016 04:55:02 -0400
Date: Wed, 17 Aug 2016 16:54:59 +0800
From: Eryu Guan <eguan@redhat.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, fstests@vger.kernel.org,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] btrfs/132: test for crash if btrfs quota disable is
 killed while waiting on rescan
Message-ID: <20160817085459.GT27776@eguan.usersys.redhat.com>
References: <86c01c58-09df-178b-10de-dc4fc822bb55@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <86c01c58-09df-178b-10de-dc4fc822bb55@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 16, 2016 at 02:30:22PM -0400, Jeff Mahoney wrote:
> There was a bug in btrfs where the wait for completion of the qgroup
> rescan worker could be interrupted, resulting in a crash in the rescan
> worker when the quota root goes away.
> 
> It is possible to interrupt the wait during file system umount as well,
> but effectively impossible to test.  The umount generally succeeds safely
> anyway due to other synchronization points.
> 
> This issue is resolved by the following patch for the Linux kernel:
> "btrfs: waiting on qgroup rescan should not always be interruptible"
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  tests/btrfs/132     | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/132.out |   1 +
>  tests/btrfs/group   |   1 +
>  3 files changed, 103 insertions(+)
>  create mode 100755 tests/btrfs/132
>  create mode 100644 tests/btrfs/132.out
> 
> diff --git a/tests/btrfs/132 b/tests/btrfs/132
> new file mode 100755
> index 0000000..3929afa
> --- /dev/null
> +++ b/tests/btrfs/132
> @@ -0,0 +1,101 @@
> +#! /bin/bash
> +# FS QA Test 132
> +#
> +# Test for race with signal being received in btrfs_qgroup_disable and
> +# the qgroup rescan worker.  The failure case is a crash due to the quota
> +# root being released prematurely.
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

This belongs to common/config

> +_require_command "$BTRFS_DEBUG_TREE_PROG" btrfs-debug-tree
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +cp -aR /lib/modules/$(uname -r) $SCRATCH_MNT

_populate_fs or fsstress to populate the filesystem?

> +
> +# A qgroup rescan on an empty or small file system completes nearly
> +# immediately.  We need to ensure that it runs long enough that it will
> +# be running when the disable ioctl executes.  Snapshots slow down the
> +# rescan so we should see the race without a lot of data.  This is an
> +# arbitrary number that works on a ramdisk so it should be sufficient
> +# for any storage.
> +for n in $(seq 1 100); do
> +    _run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/$n

Use tab for indention.

> +done
> +
> +sync
> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> +
> +# _run_btrfs_util_prog runs the command in a subshell
> +# so jobs -p and $! don't work

Can you run "$BTRFS_UTIL_PROG quota enable $SCRATCH_MNT" directly
without _run_btrfs_util_prog? This helper is not recommended, I think
it's only useful when the output of btrfs command is changing over time,
which makes it harder to filter out a stable output as golden image. But
I notice that "btrfs quota enable /mnt" doesn't print any message on
success.

> +$BTRFS_UTIL_PROG quota disable $SCRATCH_MNT &
> +
> +# This is arbitrary as well but worked for me.  The goal is to let the
> +# command get into the umount syscall before calling kill but not so far
> +# into it that we've already waited for the rescan worker to complete.
> +usleep 10000
> +jobs=$(jobs -p)
> +if kill -0 $jobs 2> /dev/null; then
> +	kill -KILL $jobs
> +else
> +	echo "quota disable command exited too quickly"
> +fi
> +
> +# wait will output the Killed message, so silence that
> +wait 2> /dev/null
> +_scratch_unmount
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/132.out b/tests/btrfs/132.out
> new file mode 100644
> index 0000000..06c1d19
> --- /dev/null
> +++ b/tests/btrfs/132.out
> @@ -0,0 +1 @@
> +QA output created by 132

Need a line like "Silence is golden" to indicate we expect nothing
from the test.

Thanks,
Eryu

> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 929fa21..c4e880a 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -134,3 +134,4 @@
>  129 auto quick send
>  130 auto clone send
>  131 auto quick qgroup
> +132 auto quick qgroup
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
