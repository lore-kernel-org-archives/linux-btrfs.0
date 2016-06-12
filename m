Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbcFLFGT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 01:06:19 -0400
Date: Sun, 12 Jun 2016 13:06:16 +0800
From: Eryu Guan <eguan@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6] fstests: btrfs: test RAID1 device reappear and
 balanced
Message-ID: <20160612050616.GC5140@eguan.usersys.redhat.com>
References: <1463495530-425-1-git-send-email-anand.jain@oracle.com>
 <1463495530-425-5-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463495530-425-5-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 10:32:09PM +0800, Anand Jain wrote:
> The test does the following:
>   Initialize a RAID1 with some data
> 
>   Re-mount RAID1 degraded with _dev1_ and write up to
>   half of the FS capacity
>   Save md5sum checkpoint1
> 
>   Re-mount healthy RAID1
> 
>   Let balance re-silver.
>   Save md5sum checkpoint2
> 
>   Re-mount RAID1 degraded with _dev2_
>   Save md5sum checkpoint3
> 
>   Verify if all three md5sum match
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  tests/btrfs/121     | 163 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/121.out |   8 +++
>  tests/btrfs/group   |   1 +
>  3 files changed, 172 insertions(+)
>  create mode 100755 tests/btrfs/121
>  create mode 100644 tests/btrfs/121.out
> 
> diff --git a/tests/btrfs/121 b/tests/btrfs/121
> new file mode 100755
> index 000000000000..81b7deb047af
> --- /dev/null
> +++ b/tests/btrfs/121
> @@ -0,0 +1,163 @@
> +#! /bin/bash
> +# FS QA Test 121
> +#
> +# This test verify the RAID1 reconstruction on the reappeared
> +# device. By using the following steps:
> +# Initialize a RAID1 with some data
> +#
> +# Re-mount RAID1 degraded with dev2 missing and write up to
> +# half of the FS capacity.
> +# Save md5sum checkpoint1
> +#
> +# Re-mount healthy RAID1
> +#
> +# Let balance re-silver.
> +# Save md5sum checkpoint2
> +#
> +# Re-mount RAID1 degraded with dev1 missing
> +# Save md5sum checkpoint3
> +#
> +# Verify if all three checkpoints match
> +#
> +#---------------------------------------------------------------------
> +# Copyright (c) 2016 Oracle.  All Rights Reserved.
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
> +#---------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /

The "rm -f $tmp.*" is still needed even $tmp.* is not used in the test
itself, it's still possible to be used by some helper functions.

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
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch_nocheck
> +_require_scratch_dev_pool 2
> +
> +# the mounted test dir prevent btrfs unload, we need to unmount
> +_test_unmount
> +_require_btrfs_unloadable
> +
> +_scratch_dev_pool_get 2
> +
> +dev1=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
> +dev2=`echo $SCRATCH_DEV_POOL | awk '{print $2}'`
> +
> +dev1_sz=`blockdev --getsize64 $dev1`
> +dev2_sz=`blockdev --getsize64 $dev2`
> +# get min of both
> +max_fs_sz=`echo -e "$dev1_sz\n$dev2_sz" | sort | head -1`
> +max_fs_sz=$(( max_fs_sz/2 ))
> +if [ $max_fs_sz -gt 1000000 ]; then
> +	bs="1M"
> +	count=$(( max_fs_sz/1000000 ))
> +else
> +	max_fs_sz=$(( max_fs_sz*2 ))
> +	_notrun "Smallest dev size $max_fs_sz, Need at least 2M"
> +fi
> +
> +echo >> $seqres.full
> +echo "max_fs_sz=$max_fs_sz count=$count" >> $seqres.full
> +echo "-----Initialize -----" >> $seqres.full
> +_scratch_pool_mkfs "-mraid1 -draid1" >> $seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1
> +_run_btrfs_util_prog filesystem show
> +dd if=/dev/zero of="$SCRATCH_MNT"/tf1 bs=$bs count=1 \
> +					>>$seqres.full 2>&1
> +count=$(( count-- ))
> +echo "unmount" >> $seqres.full
> +echo "clean btrfs ko" >> $seqres.full
> +_scratch_unmount
> +_reload_btrfs_ko

A comment to explain the reason to reload btrfs.ko would be good.

> +
> +
> +echo >> $seqres.full
> +echo "-----Write degraded mount fill upto $max_fs_sz bytes-----" >> $seqres.full
> +echo
> +echo "Write data with degraded mount"
> +# Since we didn't run dev scan, btrfs kernel does not know
> +# about the dev2
> +# don't use _scratch_mount as we want to control
> +# the device used for mounting.
> +
> +_mount -o degraded $dev1 $SCRATCH_MNT >>$seqres.full 2>&1
> +_run_btrfs_util_prog filesystem show
> +dd if=/dev/zero of="$SCRATCH_MNT"/tf2 bs=$bs count=$count \
> +					>>$seqres.full 2>&1
> +checkpoint1=`md5sum $SCRATCH_MNT/tf2`
> +echo $checkpoint1 >> $seqres.full 2>&1
> +_scratch_unmount
> +echo "unmount" >> $seqres.full
> +
> +echo >> $seqres.full
> +echo "-----Mount normal-----" >> $seqres.full
> +echo
> +echo "Mount normal after balance"
> +_run_btrfs_util_prog device scan
> +_scratch_mount >> $seqres.full 2>&1
> +_run_btrfs_util_prog filesystem show
> +echo >> $seqres.full
> +_run_btrfs_util_prog balance start ${SCRATCH_MNT}
> +
> +checkpoint2=`md5sum $SCRATCH_MNT/tf2`
> +echo $checkpoint2 >> $seqres.full 2>&1
> +
> +echo >> $seqres.full
> +echo "-----Mount degraded but with other dev -----" >> $seqres.full
> +echo
> +echo "Mount degraded but with other dev"
> +_scratch_unmount
> +_reload_btrfs_ko
> +_mount -o degraded $dev2 $SCRATCH_MNT >>$seqres.full 2>&1
> +_run_btrfs_util_prog filesystem show
> +checkpoint3=`md5sum $SCRATCH_MNT/tf2`
> +echo $checkpoint3 >> $seqres.full 2>&1
> +
> +if [ "$checkpoint1" != "$checkpoint2" ]; then
> +	echo $checkpoint1
> +	echo $checkpoint2
> +	_fail "Inital sum does not match with after balance"
> +fi
> +
> +if [ "$checkpoint1" != "$checkpoint3" ]; then
> +	echo $checkpoint1
> +	echo $checkpoint3
> +	_fail "Inital sum does not match with data on dev2 written by balance"

Just "echo" error message, not _fail. _fail causes the test to exit,
leaves the following "_scratch_dev_pool_put; _test_mount" not run.

> +fi
> +
> +_scratch_dev_pool_put
> +_test_mount
> +
> +echo "Silence is golden"

There're outputs in golden image, then this line is not needed.

Thanks,
Eryu

> +status=0
> +exit
> diff --git a/tests/btrfs/121.out b/tests/btrfs/121.out
> new file mode 100644
> index 000000000000..0728787d17bc
> --- /dev/null
> +++ b/tests/btrfs/121.out
> @@ -0,0 +1,8 @@
> +QA output created by 121
> +
> +Write data with degraded mount
> +
> +Mount normal after balance
> +
> +Mount degraded but with other dev
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 90af8fc2d106..5c28a3ca0687 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -122,3 +122,4 @@
>  118 auto quick snapshot metadata
>  119 auto quick snapshot metadata qgroup
>  120 auto quick snapshot metadata
> +121 auto replace
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
