Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9429 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752482AbdDEAv0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Apr 2017 20:51:26 -0400
Subject: Re: [PATCH] fstests: generic: Check if cycle mount and sleep can
 affect fiemap result
To: "Darrick J. Wong" <darrick.wong@oracle.com>
References: <20170403070923.18518-1-quwenruo@cn.fujitsu.com>
 <20170403163147.GC10881@birch.djwong.org>
CC: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <6e39e9ab-d071-c5f9-b3de-7d042116bc86@cn.fujitsu.com>
Date: Wed, 5 Apr 2017 08:51:19 +0800
MIME-Version: 1.0
In-Reply-To: <20170403163147.GC10881@birch.djwong.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 04/04/2017 12:31 AM, Darrick J. Wong wrote:
> On Mon, Apr 03, 2017 at 03:09:23PM +0800, Qu Wenruo wrote:
>> As long as we don't modify the on-disk data, fiemap result should always
>> be constant.
>>
>> Operation like cycle mount and sleep should not affect fiemap result.
>> While unfortunately, btrfs doesn't follow that behavior.
>>
>> Btrfs fiemap sometimes return merged result, while after cycle mount, it
>> returns split result. Furthermore after a snap, btrfs returns merged
>> result again.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  tests/generic/422     | 127 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/generic/422.out |   2 +
>>  tests/generic/group   |   1 +
>>  3 files changed, 130 insertions(+)
>>  create mode 100755 tests/generic/422
>>  create mode 100644 tests/generic/422.out
>>
>> diff --git a/tests/generic/422 b/tests/generic/422
>> new file mode 100755
>> index 0000000..4ca4476
>> --- /dev/null
>> +++ b/tests/generic/422
>> @@ -0,0 +1,127 @@
>> +#! /bin/bash
>> +# FS QA Test 422
>> +#
>> +# Test if a file system returns constant fiemap result after remount and
>> +# fiemap.
>> +# Unfortunately, btrfs doesn't follow this behavior.
>
> Is this test a goalpost for btrfs bugfixes you're going to post?

Yes.

>
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2017 Fujitsu.  All Rights Reserved.
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
>> +#-----------------------------------------------------------------------
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
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs generic
>> +_supported_os IRIX Linux
>
> I don't think we need to support IRIX...

Could we just remove IRIX from the template?

Thanks,
Qu

>
> --D
>
>> +_require_scratch
>> +
>> +block_size=$((64 * 1024))
>> +block_count=32
>> +dst=$SCRATCH_MNT/file
>> +sleeptime=3
>> +
>> +# It's almost 100% for btrfs to trigger inconstant fiemap result
>> +# just in case
>> +runtime=$((2 * $LOAD_FACTOR))
>> +
>> +# record fiemap as checkpoint, and output the hash of fiemap result
>> +# to stdout
>> +fiemap_checkpoint()
>> +{
>> +	local number=$1
>> +	local message=$2
>> +
>> +	echo "=== $message ===" >> $seqres.full
>> +	$XFS_IO_PROG -c "fiemap -v" $dst > ${tmp}.cp$number
>> +	cat ${tmp}.cp${number} >> $seqres.full
>> +
>> +	md5sum ${tmp}.cp${number} | cut -d ' ' -f 1
>> +}
>> +
>> +do_test()
>> +{
>> +	local number=$1
>> +
>> +	# Use 16 times of file size to ensure we have enough space
>> +	_scratch_mkfs_sized $((16 * $block_size * $block_count)) \
>> +		> /dev/null 2>&1
>> +	_scratch_mount
>> +
>> +	echo "====== Loop $number ======" >> $seqres.full
>> +	touch $dst
>> +	# Xfsprogs 4.9.0 still has a bug that xfs_io "open" with O_SYNC command
>> +	# doesn't work well with "pwrite", although it gets fixed in v4.10.0,
>> +	# use dd here to avoid it won't hurt for non-xfs developers
>> +	dd if=/dev/zero of=$dst bs=$block_size count=$block_count oflag=dsync \
>> +		status=none 2>&1
>> +
>> +	hash1=$(fiemap_checkpoint 1 "Fiemap just after dsync write")
>> +
>> +	# Sleep should not modify fiemap result
>> +	sleep $sleeptime
>> +
>> +	hash2=$(fiemap_checkpoint 2 "Fiemap after dsync write and sleep")
>> +
>> +	# cycle mount should not modify fiemap result
>> +	_scratch_cycle_mount
>> +
>> +	hash3=$(fiemap_checkpoint 3 "Fiemap after cycle mount")
>> +
>> +	# Sleep should not modify fiemap result
>> +	sleep $sleeptime
>> +
>> +	hash4=$(fiemap_checkpoint 4 "Fiemap after cycle mount and sleep")
>> +
>> +	_scratch_unmount
>> +
>> +	if [ $hash1 != $hash2 -o $hash2 != $hash3 -o $hash3 != $hash4 ]; then
>> +		echo "Inconstant fiemap result detected"
>> +	fi
>> +	echo >> $seqres.full
>> +}
>> +
>> +for i in $(seq 1 $runtime); do
>> +	do_test $i
>> +done
>> +
>> +echo "Silence is golden"
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/generic/422.out b/tests/generic/422.out
>> new file mode 100644
>> index 0000000..f70693f
>> --- /dev/null
>> +++ b/tests/generic/422.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 422
>> +Silence is golden
>> diff --git a/tests/generic/group b/tests/generic/group
>> index 3c7c5e4..86d2325 100644
>> --- a/tests/generic/group
>> +++ b/tests/generic/group
>> @@ -424,3 +424,4 @@
>>  419 auto quick encrypt
>>  420 auto quick punch
>>  421 auto quick encrypt dangerous
>> +422 auto
>> --
>> 2.9.3
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


