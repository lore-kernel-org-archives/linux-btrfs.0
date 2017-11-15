Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25536 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754291AbdKODEA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 22:04:00 -0500
Subject: Re: [PATCH] btrfs/154: test for device dynamic rescan
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20171113022541.7413-1-anand.jain@oracle.com>
 <20171114121215.GJ17339@eguan.usersys.redhat.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <45339f53-0073-c7ef-b0c9-8302af89e5e2@oracle.com>
Date: Wed, 15 Nov 2017 11:04:13 +0800
MIME-Version: 1.0
In-Reply-To: <20171114121215.GJ17339@eguan.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/14/2017 08:12 PM, Eryu Guan wrote:
> On Mon, Nov 13, 2017 at 10:25:41AM +0800, Anand Jain wrote:
>> Make sure missing device is included in the alloc list when it is
>> scanned on a mounted FS.
>>
>> This test case needs btrfs kernel patch which is in the ML
>>    [PATCH] btrfs: handle dynamically reappearing missing device
>> Without the kernel patch, the test will run, but reports as
>> failed, as the device scanned won't appear in the alloc_list.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Tested without the fix and test failed as expected, test passed after
> applying the fix.


> Some minor nits below.
> 
>> ---
>>   tests/btrfs/154     | 188 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/btrfs/154.out |  10 +++
>>   tests/btrfs/group   |   1 +
>>   3 files changed, 199 insertions(+)
>>   create mode 100755 tests/btrfs/154
>>   create mode 100644 tests/btrfs/154.out
>>
>> diff --git a/tests/btrfs/154 b/tests/btrfs/154
>> new file mode 100755
>> index 000000000000..8b06fc4d9347
>> --- /dev/null
>> +++ b/tests/btrfs/154
>> @@ -0,0 +1,188 @@
>> +#! /bin/bash
>> +# FS QA Test 154
>> +#
>> +# Test for reappearing missing device functionality.
>> +#   This test will fail without the btrfs kernel patch
>> +#   [PATCH] btrfs: handle dynamically reappearing missing device
>> +#
>> +#---------------------------------------------------------------------
>> +# Copyright (c) 2017 Oracle.  All Rights Reserved.
>> +# Author: Anand Jain <anand.jain@oracle.com>
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#---------------------------------------------------------------------
>> +#
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1	# failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/module
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_scratch_dev_pool 2
>> +_test_unmount
> 
> This is not needed now, _require_loadable_fs_module will umount & mount
> test dev as necessary.

  Right will fix it.

>> +_require_loadable_fs_module "btrfs"
>> +
>> +_scratch_dev_pool_get 2
>> +
>> +DEV1=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
>> +DEV2=`echo $SCRATCH_DEV_POOL | awk '{print $2}'`
>> +
>> +echo DEV1=$DEV1 >> $seqres.full
>> +echo DEV2=$DEV2 >> $seqres.full
>> +
>> +# Balance won't be successful if filled too much
>> +DEV1_SZ=`blockdev --getsize64 $DEV1`
>> +DEV2_SZ=`blockdev --getsize64 $DEV2`
>> +
>> +# get min
>> +MAX_FS_SZ=`echo -e "$DEV1_SZ\n$DEV2_SZ" | sort | head -1`
>> +# Need disks with more than 2G
>> +if [ $MAX_FS_SZ -lt 2000000000 ]; then
>> +	_scratch_dev_pool_put
>> +	_test_mount
> 
> Then no need to _test_mount.

  Fixed this in v2.

>> +	_notrun "Smallest dev size $MAX_FS_SZ, Need at least 2G"
>> +fi
>> +
>> +MAX_FS_SZ=100000000
>> +bs="1M"
>> +COUNT=$(($MAX_FS_SZ / 1000000))
>> +CHECKPOINT1=0
>> +CHECKPOINT2=0
>> +
>> +setup()
>> +{
>> +	echo >> $seqres.full
>> +	echo "MAX_FS_SZ=$MAX_FS_SZ COUNT=$COUNT" >> $seqres.full
>> +	echo "setup"
>> +	echo "-----setup-----" >> $seqres.full
>> +	_scratch_pool_mkfs "-mraid1 -draid1" >> $seqres.full 2>&1
>> +	_scratch_mount >> $seqres.full 2>&1
>> +	dd if=/dev/urandom of="$SCRATCH_MNT"/tf bs=$bs count=1 \
>> +					>>$seqres.full 2>&1
>> +	_run_btrfs_util_prog filesystem show -m ${SCRATCH_MNT}
>> +	_run_btrfs_util_prog filesystem df $SCRATCH_MNT
>> +	COUNT=$(( $COUNT - 1 ))
>> +	echo "unmount" >> $seqres.full
>> +	_scratch_unmount
>> +}
>> +
>> +degrade_mount_write()
>> +{
>> +	echo >> $seqres.full
>> +	echo "--degraded mount: max_fs_sz $max_fs_sz bytes--" >> $seqres.full
>> +	echo
>> +	echo "degraded mount"
>> +
>> +	echo "clean btrfs ko" >> $seqres.full
>> +	# un-scan the btrfs devices
>> +	_reload_fs_module "btrfs"
>> +	_mount -o degraded $DEV1 $SCRATCH_MNT >>$seqres.full 2>&1
>> +	cnt=$(( $COUNT/10 ))
>> +	dd if=/dev/urandom of="$SCRATCH_MNT"/tf1 bs=$bs count=$cnt \
>> +					>>$seqres.full 2>&1
>> +	COUNT=$(( $COUNT - $cnt ))
>> +	_run_btrfs_util_prog filesystem show -m $SCRATCH_MNT
>> +	_run_btrfs_util_prog filesystem df $SCRATCH_MNT
>> +	CHECKPOINT1=`md5sum $SCRATCH_MNT/tf1`
>> +	echo $SCRATCH_MNT/tf1:$CHECKPOINT1 >> $seqres.full 2>&1
> 
> "2>&1" not needed.

  Fixed in v2.

>> +}
>> +
>> +scan_missing_dev_and_write()
>> +{
>> +	echo >> $seqres.full
>> +	echo "--scan missing $DEV2--" >> $seqres.full
>> +	echo
>> +	echo "scan missing dev and write"
>> +
>> +	_run_btrfs_util_prog device scan $DEV2
>> +
>> +	echo >> $seqres.full
>> +
>> +	_run_btrfs_util_prog filesystem show -m ${SCRATCH_MNT}
>> +	_run_btrfs_util_prog filesystem df ${SCRATCH_MNT}
>> +
>> +	dd if=/dev/urandom of="$SCRATCH_MNT"/tf2 bs=$bs count=$COUNT \
>> +						>>$seqres.full 2>&1
>> +	CHECKPOINT2=`md5sum $SCRATCH_MNT/tf2`
>> +	echo $SCRATCH_MNT/tf2:$CHECKPOINT2 >> $seqres.full 2>&1
> 
> Same here.

  Fixed in v2.

>> +}
>> +
>> +balance_convert()
>> +{
>> +	echo >> $seqres.full
>> +	echo "----- run balance -----" >> $seqres.full
>> +	echo
>> +	echo "run balance"
>> +
>> +	_run_btrfs_util_prog bal start --full-balance -dconvert=raid1 \
> 
> All btrfs tests use full btrfs sub-command now, use "balance" too?

  Will replace with balance sub-command in v2.

>> +				-mconvert=raid1 ${SCRATCH_MNT}
>> +}
>> +
>> +verify()
>> +{
>> +	echo >> $seqres.full
>> +	echo "--mount reconstructed dev only and check md5sum--" >> $seqres.full
>> +	echo
>> +	echo "mount reconstructed dev only and check md5sum"
>> +	echo "unmount" >> $seqres.full
>> +
>> +	_scratch_unmount
>> +	_reload_fs_module "btrfs"
>> +	_mount -o degraded $DEV2 $SCRATCH_MNT >>$seqres.full 2>&1
>> +	verify_checkpoint1=`md5sum $SCRATCH_MNT/tf1`
>> +	verify_checkpoint2=`md5sum $SCRATCH_MNT/tf2`
>> +
>> +	if [ "$verify_checkpoint1" != "$CHECKPOINT1" ]; then
>> +		echo "checkpoint1 does not match with after scrub"
> 
> I don't see scrub involved, you meant "scan"?

  Right. I have updated this as well.

  Sent out V2 with these fixes.

Thanks, Anand


> Thanks,
> Eryu
> 
>> +	fi
>> +
>> +	if [ "$verify_checkpoint2" != "$CHECKPOINT2" ]; then
>> +		echo "checkpoint2 does not match with after scrub"
>> +	fi
>> +}
>> +
>> +setup
>> +degrade_mount_write
>> +scan_missing_dev_and_write
>> +balance_convert
>> +verify
>> +
>> +$UMOUNT_PROG $DEV2
>> +_scratch_dev_pool_put
>> +_test_mount
>> +
>> +status=0
>> +exit
>> diff --git a/tests/btrfs/154.out b/tests/btrfs/154.out
>> new file mode 100644
>> index 000000000000..4a4939d448aa
>> --- /dev/null
>> +++ b/tests/btrfs/154.out
>> @@ -0,0 +1,10 @@
>> +QA output created by 154
>> +setup
>> +
>> +degraded mount
>> +
>> +scan missing dev and write
>> +
>> +run balance
>> +
>> +mount reconstructed dev only and check md5sum
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index 15c2ecbf553c..c98cf823224e 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -156,3 +156,4 @@
>>   151 auto quick
>>   152 auto quick metadata qgroup send
>>   153 auto quick qgroup
>> +154 auto quick
>> -- 
>> 2.13.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
