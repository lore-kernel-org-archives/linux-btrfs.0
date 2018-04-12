Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:49133 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751841AbeDLBF7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 21:05:59 -0400
Subject: Re: [PATCH] btrfs-progs: tests: test mkfs.btrfs fails on small
 backing size thin provision device
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20180411070330.31196-1-suy.fnst@cn.fujitsu.com>
 <20180411154145.GF21272@twin.jikos.cz>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <65c76f20-29d9-03be-dae6-f669cf9cb492@cn.fujitsu.com>
Date: Thu, 12 Apr 2018 09:11:38 +0800
MIME-Version: 1.0
In-Reply-To: <20180411154145.GF21272@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/11/2018 11:41 PM, David Sterba wrote:
> On Wed, Apr 11, 2018 at 03:03:30PM +0800, Su Yue wrote:
>> This tests is most similar to xfstests generic/405.
>> It calls device mapper to create a thin provision device with small
>> backing size and big virtual size. mkfs.btrfs should fail on such
>> devices.
>>
>> This test should pass after commit e805b143a4fe
>> ("btrfs-progs: mkfs: return nozero value on thin provisioned device").
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> Thanks, test looks good overall, a few comments below.
> 
Thanks, V2 has been sent.

>> ---
>>   .../test.sh                                   | 93 +++++++++++++++++++
>>   1 file changed, 93 insertions(+)
>>   create mode 100755 tests/mkfs-tests/017-small-backing-size-thin-provision-device/test.sh
>>
>> diff --git a/tests/mkfs-tests/017-small-backing-size-thin-provision-device/test.sh b/tests/mkfs-tests/017-small-backing-size-thin-provision-device/test.sh
>> new file mode 100755
>> index 000000000000..f2e044da5d17
>> --- /dev/null
>> +++ b/tests/mkfs-tests/017-small-backing-size-thin-provision-device/test.sh
>> @@ -0,0 +1,93 @@
>> +#!/bin/bash
>> +# mkfs.btrfs must failed on a thin provision device with very small
>> +# backing size and big virtual size.
>> +
>> +source "$TEST_TOP/common"
>> +
>> +check_prereq mkfs.btrfs
>> +
>> +setup_root_helper
>> +prepare_test_dev
>> +
>> +# Backing data dev
>> +DMTHIN_DATA_NAME="thin-data"
> 
> Please add some prefix to avoid any collisions, eg.
> 'btrfs-progs-thin-data'. It's easier to spot in logs or device listings
> if eg. the test fails and the device needs to be removed manually.
> 
>> +DMTHIN_DATA_DEV="/dev/mapper/$DMTHIN_DATA_NAME"
>> +# Backing metadata dev
>> +DMTHIN_META_NAME="thin-meta"
>> +DMTHIN_META_DEV="/dev/mapper/$DMTHIN_META_NAME"
>> +# Backing pool dev (combination of above)
>> +DMTHIN_POOL_NAME="thin-pool"
>> +DMTHIN_POOL_DEV="/dev/mapper/$DMTHIN_POOL_NAME"
>> +# Thin volume
>> +DMTHIN_VOL_NAME="thin-vol"
>> +DMTHIN_VOL_DEV="/dev/mapper/$DMTHIN_VOL_NAME"
>> +
>> +dmthin_cleanup()
>> +{
>> +	# wait for device to be fully settled
>> +	run_check $SUDO_HELPER udevadm settle
>> +	run_check $SUDO_HELPER dmsetup remove $DMTHIN_VOL_NAME
>> +	run_check $SUDO_HELPER dmsetup remove $DMTHIN_POOL_NAME
>> +	run_check $SUDO_HELPER dmsetup remove $DMTHIN_META_NAME
>> +	run_check $SUDO_HELPER dmsetup remove $DMTHIN_DATA_NAME
> 
> Missing quotes around the DMTHIN_* variables.
> 
>> +}
>> +
>> +sector_size=512		  # in bytes
>> +data_dev_size=$((1 * 1024 * 1024 / $sector_size))   # 1M
>> +virtual_size=$((1 * 1024 * 1024 * 1024 * 1024 / $sector_size))  # 1T
>> +cluster_size=1024	  # 512k in sectors
>> +low_water=$((104857600 / $cluster_size/ $sector_size))  # 100M / $cluster_size, in sectors
>> +
>> +# Need to make linear metadata and data devs.  From kernel docs:
>> +# As a guide, we suggest you calculate the number of bytes to use in the
>> +# metadata device as 48 * $data_dev_size / $data_block_size but round it up
>> +# to 2MB (4096 sectors) if the answer is smaller.
>> +# So do that:
>> +meta_dev_size=$((48 * $data_dev_size / $cluster_size))
>> +if [ "$meta_dev_size" -lt "4096" ]; then
>> +        meta_dev_size=4096      # 2MB
>> +fi
>> +
>> +meta_dev_offset=0
>> +total_data_dev_size=$(($meta_dev_offset + $meta_dev_size + $data_dev_size))
>> +
>> +run_check truncate -s0 img
>> +chmod a+w img
>> +run_check truncate -s"$(($total_data_dev_size * $sector_size))" img
>> +
>> +dm_backing_dev=`run_check_stdout $SUDO_HELPER losetup --find --show img`
>> +
>> +# Metadata device
>> +DMTHIN_META_TABLE="0 $meta_dev_size linear $dm_backing_dev $meta_dev_offset"
>> +run_check $SUDO_HELPER dmsetup create $DMTHIN_META_NAME --table "$DMTHIN_META_TABLE"
>> +
>> +# Data device
>> +data_dev_offset=$((meta_dev_offset + $meta_dev_size))
>> +DMTHIN_DATA_TABLE="0 $data_dev_size linear $dm_backing_dev $data_dev_offset"
>> +run_check $SUDO_HELPER dmsetup create $DMTHIN_DATA_NAME --table "$DMTHIN_DATA_TABLE"
>> +
>> +# Zap the pool metadata dev
>> +run_check dd if=/dev/zero of=$DMTHIN_META_DEV bs=4096 count=1
>> +
>> +# Thin pool
>> +# "start length thin-pool metadata_dev data_dev data_block_size low_water_mark"
>> +DMTHIN_POOL_TABLE="0 $data_dev_size thin-pool $DMTHIN_META_DEV $DMTHIN_DATA_DEV $cluster_size $low_water"
>> +run_check $SUDO_HELPER dmsetup create $DMTHIN_POOL_NAME --table "$DMTHIN_POOL_TABLE"
>> +
>> +# Thin volume
>> +pool_id=$RANDOM
>> +run_check $SUDO_HELPER dmsetup message $DMTHIN_POOL_DEV 0 "create_thin $pool_id"
>> +
>> +# start length thin pool_dev dev_id [external_origin_dev]
>> +DMTHIN_VOL_TABLE="0 $virtual_size thin $DMTHIN_POOL_DEV $pool_id"
>> +run_check $SUDO_HELPER dmsetup create $DMTHIN_VOL_NAME --table "$DMTHIN_VOL_TABLE"
>> +
>> +# mkfs.btrfs should fail due to the small backing device
>> +run_mustfail "should fail for samll backing size thin provision device" \
>> +	     $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$@" "$DMTHIN_VOL_DEV"
> 
> What does $@ mean here? This would pass arguments from the script
> itself, but we don't pass any.
> 
>> +
>> +#cleanup
>> +dmthin_cleanup
>> +run_mayfail $SUDO_HELPER losetup -d $dm_backing_dev
>> +run_check truncate -s0 img
>> +rm img
> 
> 


