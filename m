Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7490 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750811AbbHEA6l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Aug 2015 20:58:41 -0400
Subject: Re: [PATCH] fstests: btrfs: Add regression test for reserved space
 leak.
To: <fdmanana@gmail.com>
References: <1438669637-3666-1-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H4Df3ciei+i9Ao8bj487cDg2okSL6HW6+zpKJ-P+k4Xtw@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <fstests@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55C15F94.3070600@cn.fujitsu.com>
Date: Wed, 5 Aug 2015 08:57:56 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4Df3ciei+i9Ao8bj487cDg2okSL6HW6+zpKJ-P+k4Xtw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Filipe David Manana wrote on 2015/08/04 14:16 +0100:
> On Tue, Aug 4, 2015 at 7:27 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> The regression is introduced in v4.2-rc1, with the big btrfs qgroup
>> change.
>> The problem is, qgroup reserved space is never freed, causing even we
>> increase the limit, we can still hit the EDQUOT much faster than it
>> should.
>>
>> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> Thanks for doing this Qu.
> The test fails without the btrfs fix and passes with it, as expected.
> However, one question below:
Thanks for the review, Filipe.

I'll explain it inline below.
>
>> ---
>>   tests/btrfs/089     | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/btrfs/089.out |  5 ++++
>>   tests/btrfs/group   |  1 +
>>   3 files changed, 89 insertions(+)
>>   create mode 100755 tests/btrfs/089
>>   create mode 100644 tests/btrfs/089.out
>>
>> diff --git a/tests/btrfs/089 b/tests/btrfs/089
>> new file mode 100755
>> index 0000000..0c018f2
>> --- /dev/null
>> +++ b/tests/btrfs/089
>> @@ -0,0 +1,83 @@
>> +#! /bin/bash
>> +# FS QA Test 089
>> +#
>> +# Regression test for btrfs qgroup reserved space leak.
>> +#
>> +# Due to qgroup reserved space leak, EDQUOT can be trigged even it's not
>> +# over limit after previous write.
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2015 Fujitsu. All Rights Reserved.
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
>> +status=1       # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +       cd /
>> +       rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_scratch
>> +_need_to_be_root
>> +
>> +# Use big blocksize to ensure there is still enough space left
>> +# for metadata reserve after hitting EDQUOT
>> +BLOCKSIZE=$(( 2 * 1024 * 1024 ))
>> +FILESIZE=$(( 128 * 1024 * 1024 )) # 128Mbytes
>> +
>> +# The last block won't be able to finish write, as metadata takes
>> +# $NODESIZE space, causing the last block triggering EDQUOT
>> +LENGTH=$(( $FILESIZE - $BLOCKSIZE ))
>> +
>> +_scratch_mkfs >>$seqres.full 2>&1
>> +_scratch_mount
>> +_require_fs_space $SCRATCH_MNT $(($FILESIZE * 2 / 1024))
>> +
>> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
>> +_run_btrfs_util_prog qgroup limit $FILESIZE 5 $SCRATCH_MNT
>> +
>> +$XFS_IO_PROG -f -c "pwrite -b $BLOCKSIZE 0 $LENGTH" \
>> +       $SCRATCH_MNT/foo | _filter_xfs_io
>> +sync
>
> Why is the sync needed here? Can you add a comment explaining why? It
> isn't trivial/obvious (for me at least), specially because without the
> call to "sync" the test passes without the btrfs fix.
>
> thanks
No problem, I'll send a v2 patch with explain about the sync.

The reason is, without the sync, it's highly possible the data is not 
flush into disk. So the reserved space is correct until data is written.

For current write flow with sync, without the fix patch:
1) Want to write first 126M
    Reserve 126M space

    Qgroup 5: reserved = 126M, rfer = 0(*), rfer_max = 128M
*: Just ignore metadata, as blocksize 2M is much larger than nodesize(16K)

2) Sync
    Data writeback and metadata change
     |- Run delayed refs
        |- Qgroup accouting
    Qgroup 5: reserved = 126M, rfer = 126M, rfer_max = 128M
              ^^ Should be 0, as reserved data is written into disk.

3) Increase limit to 256M
    Qgroup 5: reserved = 126M, rfer = 126M, rfer_max = 256M

4) Want to write the next 126M
    Reserve 126M space.

    But qgroup 5 only has less than 4M available space.
    rfer_max - (reserved + rfer) = 4M

    So reserve fails with EDQUOT.

On the other hand, if there is no sync:
1) Want to write first 126M
    Reserve 126M space

    Qgroup 5: reserved = 126M, rfer = 0(*), rfer_max = 128M
    *: Ignore metadata again.
    Also we assume your memory is large enough to keep that amount of
    dirty pages without trigger page flush.

3) Increase limit to 256M
    Qgroup 5: reserved = 126M, rfer = 0, rfer_max = 256M

    Rfer will only be increase at commit_transaction() time.
    So it will stay 0 until manually sync or dirty page number triggers a
    flush.

4) Want to write the next 126M
    Reserve 126M space.

    Now qgroup 5 has 256 - 126 = 130M available space.
    The reserve will succeed without problem.
    So that's the reason why it pass the test without sync and the fix
    patch.

Thanks,
Qu
>
>> +
>> +# Double the limit to allow further write
>> +_run_btrfs_util_prog qgroup limit $(($FILESIZE * 2)) 5 $SCRATCH_MNT
>> +
>> +# Test whether further write can succeed
>> +$XFS_IO_PROG -f -c "pwrite -b $BLOCKSIZE $LENGTH $LENGTH" \
>> +       $SCRATCH_MNT/foo | _filter_xfs_io
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/btrfs/089.out b/tests/btrfs/089.out
>> new file mode 100644
>> index 0000000..396888f
>> --- /dev/null
>> +++ b/tests/btrfs/089.out
>> @@ -0,0 +1,5 @@
>> +QA output created by 089
>> +wrote 132120576/132120576 bytes at offset 0
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +wrote 132120576/132120576 bytes at offset 132120576
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index ffe18bf..225b532 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -91,6 +91,7 @@
>>   086 auto quick clone
>>   087 auto quick send
>>   088 auto quick metadata
>> +089 auto quick qgroup
>>   090 auto quick metadata
>>   091 auto quick qgroup
>>   092 auto quick send
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
