Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51292 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751076AbcEKCOv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 22:14:51 -0400
Subject: Re: [PATCH] fstests: btrfs: Test fiemap ioctl on completely deduped
 file
To: <fdmanana@gmail.com>
References: <1462869581-19227-1-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H5Mn2561cxK49vis3+XW1eTzx_j9h-iQpUJQ6qEGMczvQ@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <fstests@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55ce1c42-fda3-520f-ebb1-11048df8799f@cn.fujitsu.com>
Date: Wed, 11 May 2016 10:14:42 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5Mn2561cxK49vis3+XW1eTzx_j9h-iQpUJQ6qEGMczvQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Filipe Manana wrote on 2016/05/10 11:01 +0100:
> On Tue, May 10, 2016 at 9:39 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> For a completely deduped file, which means all its file extent are
>> pointing to one bytenr, if calling fiemap on it, btrfs will cause soft
>> hang up or just takes years long.
>>
>> This bug can be reproduced even without any in-band or out-of-band
>> dedupe, normal clone_file_range() call can create such situation.
>>
>> This test case will detect it.
>
> Why isn't this a generic test?
> There's nothing btrfs specific anymore...
>
> Thanks.

I'm OK to move it to generic, just as original planned.

BTW, does other fs support reflink file range?
I found a lot xfs test cases using reflink, but I still can't reflink a 
file range inside the same inode
---
$ xfs_io -c "reflink test.file 0 128k 128k" test.file
XFS_IOC_CLONE_RANGE: Operation not supported
---

>
>>
>> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  tests/btrfs/028     | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/028.out |  3 +++
>>  tests/btrfs/group   |  1 +
>>  3 files changed, 82 insertions(+)
>>  create mode 100755 tests/btrfs/028
>>  create mode 100644 tests/btrfs/028.out
>>
>> diff --git a/tests/btrfs/028 b/tests/btrfs/028
>> new file mode 100755
>> index 0000000..62bcc9d
>> --- /dev/null
>> +++ b/tests/btrfs/028
>> @@ -0,0 +1,78 @@
>> +#! /bin/bash
>> +# FS QA Test 028
>> +#
>> +# Test fiemap ioctl on heavily deduped file.
>> +#
>> +# This test will cause btrfs to soft hang up or takes years long to finish
>
> Haven't tried it, but I doubt it will take years...
> Are you sure that the soft lookup, which is what makes the test fail
> due to the dmesg warning, is triggered on very fast machines as well?
> I.e. this may not be reliable on better hardware.

On a fast test server too, using the same test case, but your concern is 
valid.

The reporter initially triggered the bug on a even faster server with 
similar file layout with 100% possibility, but with nr set to 8192.

I reduced the nr from 8192 (which is always reproducible) to 4096 to 
save some time creating file, but considering the scale of loops, 
considering the loop scale (at least n^3), the halved nr seems to hugely 
reduce the time.

The know loop scale is n^3 ~ n^4:
1. Loop all file extents (* 4096)
2. Loop all backrefs of one extent (* 4096)
3. Loop each backref in __merge_refs(list_for_each_entry_safe_continue) 
(* 4096)
4. Loop to the list end in "while(eie & eie->next) {eie=eie->next}" (*4096)

What about change nr to (8192 * $LOAD_FACTOR)?

Thanks,
Qu


Thanks,
Qu

>
>
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2016 Fujitsu. All Rights Reserved.
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
>> +. ./common/reflink
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_scratch_reflink
>> +
>> +blocksize=$(( 128 * 1024 ))
>> +nr=4096
>> +file="$SCRATCH_MNT/tmp"
>> +
>> +_scratch_mkfs
>> +_scratch_mount
>> +
>> +# write the initial block for later reflink
>> +$XFS_IO_PROG -f -c "pwrite 0 $blocksize" -c "fsync" $file | _filter_xfs_io
>> +
>> +# use reflink to create the rest of the file, whose all extents are all
>> +# pointing to the first extent
>> +for i in $(seq 1 $nr); do
>> +       $XFS_IO_PROG -c "reflink $file 0 $(( $i * $blocksize )) $blocksize" \
>> +               $SCRATCH_MNT/tmp > /dev/null || _fail "reflink failed"
>> +done
>> +
>> +# then call fiemap on that file, which shouldn't hang the fs by all means
>> +$XFS_IO_PROG -c "fiemap" $file >> $seqres.full
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/btrfs/028.out b/tests/btrfs/028.out
>> new file mode 100644
>> index 0000000..2b5a9a5
>> --- /dev/null
>> +++ b/tests/btrfs/028.out
>> @@ -0,0 +1,3 @@
>> +QA output created by 028
>> +wrote 131072/131072 bytes at offset 0
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index da0e27f..8f6f877 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -30,6 +30,7 @@
>>  025 auto quick send clone
>>  026 auto quick compress prealloc
>>  027 auto replace
>> +028 auto clone
>>  029 auto quick clone
>>  030 auto quick send
>>  031 auto quick subvol clone
>> --
>> 2.5.5
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>


