Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42929 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752503AbdDFAeB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Apr 2017 20:34:01 -0400
Subject: Re: [PATCH] fstests: btrfs: Check if btrfs will create
 inline-then-regular file extents
To: <fdmanana@gmail.com>
References: <20170405021428.14742-1-quwenruo@cn.fujitsu.com>
 <CAL3q7H4Qh1bU5pyOQgzmi5D2NcawW3e9333w5qHv49ugzPn-eA@mail.gmail.com>
 <CAL3q7H4n4ORQ4Jxgkzr7d0ZD911vN-kyvFJKzPY5KH3oUj3uew@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <4e8af31f-27f3-2c37-a798-2c7a503da71a@cn.fujitsu.com>
Date: Thu, 6 Apr 2017 08:33:54 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4n4ORQ4Jxgkzr7d0ZD911vN-kyvFJKzPY5KH3oUj3uew@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 04/06/2017 12:25 AM, Filipe Manana wrote:
> On Wed, Apr 5, 2017 at 5:00 PM, Filipe Manana <fdmanana@gmail.com> wrote:
>> On Wed, Apr 5, 2017 at 3:14 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>> Btrfs allows inline file extent if and only if
>>> 1) It's at offset 0
>>> 2) It's smaller than min(max_inline, page_size)
>>>    Although we don't specify if the size is before compression or after
>>>    compression.
>>>    At least according to current behavior, we are only limiting the size
>>>    after compression.
>>> 3) It's the only file extent
>>>    So that if we append existing inline extent, it should be converted
>>>    to regular file extents.
>>>
>>> However several users in btrfs mail list have reported invalid inline
>>> file extent, which only meets the first two condition, but with regular
>>> file extents follows.
>>
>> follows -> following
>>
>>>
>>> The bug is here for a long long time, so long that we have modified
>>> kernel and btrfs-progs to accept such case, but it's still not designed
>>> behavior, and must be detected and fixed.
>>>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>>  tests/btrfs/140     | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  tests/btrfs/140.out |   2 +
>>>  tests/btrfs/group   |   1 +
>>>  3 files changed, 123 insertions(+)
>>>  create mode 100755 tests/btrfs/140
>>>  create mode 100644 tests/btrfs/140.out
>>>
>>> diff --git a/tests/btrfs/140 b/tests/btrfs/140
>>> new file mode 100755
>>> index 0000000..55f81f2
>>> --- /dev/null
>>> +++ b/tests/btrfs/140
>>> @@ -0,0 +1,120 @@
>>> +#! /bin/bash
>>> +# FS QA Test 140
>>> +#
>>> +# Check if btrfs will create inline-then-regular file layout.
>>> +#
>>> +# Btrfs only allows inline file extent if file is small enough, and any
>>> +# incoming write enlarges the file beyong max_inline should replace inline
>>
>> beyong -> beyond
>>
>>> +# extents with regular extents.
>>> +# This is a long standing bug, so fsck won't detect it and kernel will allow
>>> +# normal read on it, but should be avoided.
>>> +#
>>> +#-----------------------------------------------------------------------
>>> +# Copyright (c) 2017 Fujitsu.  All Rights Reserved.
>>> +#
>>> +# This program is free software; you can redistribute it and/or
>>> +# modify it under the terms of the GNU General Public License as
>>> +# published by the Free Software Foundation.
>>> +#
>>> +# This program is distributed in the hope that it would be useful,
>>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> +# GNU General Public License for more details.
>>> +#
>>> +# You should have received a copy of the GNU General Public License
>>> +# along with this program; if not, write the Free Software Foundation,
>>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>>> +#-----------------------------------------------------------------------
>>> +#
>>> +
>>> +seq=`basename $0`
>>> +seqres=$RESULT_DIR/$seq
>>> +echo "QA output created by $seq"
>>> +
>>> +here=`pwd`
>>> +tmp=/tmp/$$
>>> +status=1       # failure is the default!
>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>> +
>>> +_cleanup()
>>> +{
>>> +       cd /
>>> +       rm -f $tmp.*
>>> +}
>>> +
>>> +# get standard environment, filters and checks
>>> +. ./common/rc
>>> +. ./common/filter
>>> +
>>> +# remove previous $seqres.full before test
>>> +rm -f $seqres.full
>>> +
>>> +# real QA test starts here
>>> +
>>> +# Modify as appropriate.
>>> +_supported_fs btrfs
>>> +_supported_os Linux
>>> +_require_scratch
>>> +_require_btrfs_command inspect-internal dump-tree
>>> +
>>> +inline_size=2048
>>> +page_size=$(get_page_size)
>>> +src_subv="$SCRATCH_MNT/src"
>>> +dst_subv="$SCRATCH_MNT/dst"
>>> +loop_counts=$(($LOAD_FACTOR * 4)) #The possibility is over 80%, just in case
>>> +
>>> +do_test()
>>> +{
>>> +       local ret
>>
>> unused variable
>>
>>> +       _scratch_mkfs > /dev/null 2>&1
>>> +
>>> +       # specify max_inline and compress explicitly to create
>>> +       # inlined compressed extent
>>> +       _scratch_mount "-o max_inline=$inline_size,compress"
>>> +
>>> +       # Subvolume id=257
>>> +       _run_btrfs_util_prog subvolume create $src_subv
>>> +
>>> +       # Page sized data will be compressed to quite small size,
>>> +       # which is about 50 bytes for 4K, 100 bytes for 64K,
>>> +       # far smaller than $inline_size, causing a inlined compressed
>>> +       # file extent
>>> +       $XFS_IO_PROG -f -c "pwrite 0 $page_size" -c "fsync" $src_subv/file \
>>> +               > /dev/null
>>> +
>>> +       # Subvolume id=258
>>> +       _run_btrfs_util_prog subvolume snapshot $src_subv $dst_subv
>>> +
>>> +       # Append another page to file in snapshot, since its offset is not
>>> +       # 0, it will cause regular extent, and should convert inline extent
>>> +       # to regular too.
>>> +       $XFS_IO_PROG -c "pwrite $page_size $page_size" $dst_subv/file > /dev/null
>>> +       _scratch_unmount
>>> +
>>> +       # Fsck won't report inline-then-regular as error, as it's so long
>>> +       # standing that we have no choice but to accept.
>>> +       # So here we use dump-tree to catch inline extent of $dst_subv, and
>>> +       # we need piping stdout, call btrfs-progs directly
>>
>> I don't understand the last sentence of the comment. Need piping
>> stdout? What pipe, to where? And call btrfs-progs directly where, what
>> does it mean?
>>
>>> +       $BTRFS_UTIL_PROG inspect-internal dump-tree -t 258 $SCRATCH_DEV \
>>> +               > $tmp.dump_tree
>>> +       if grep -q inline $tmp.dump_tree; then
>>> +               cat $tmp.dump_tree >> $seqres.full
>>> +               echo "Invalid inline file extent detected"
>>> +               return 1
>>> +       fi
>>> +       return 0
>>> +}
>>
>> This is unnecessarily complex to reproduce the issue.
>> It is enough to:
>>
>> 1) Create a file with an inline extent in the default subvolume (5)
>> 2) Create a snapshot of the default subvolume (can be readonly)
>> 3) Do the second write against the file in the default subvolume
>>
>> I.e., no need to create a second subvolume/snapshot. The file in the
>> default subvolume will have the issue.
>
> Even simpler:
>
> 1) Create the file with the data that results in the inline extent
> 2) fsync the file or call sync
> 3) Do the second write to the file
> 4) fsync the file, call sync or unmount the fs
>
> No need for creation of any snapshot/subvolume.
> Basically what you had here is a shorter version of btrfs/137 forced
> with mount option -o compress.

If it can be simpler that's better.

Thanks,
Qu
>
> thanks
>
>>
>>> +
>>> +for i in $(seq 1 $loop_counts); do
>>> +       do_test
>>> +       if [ $? -ne 0 ]; then
>>> +               corrupted=$(($corrupted + 1))
>>> +       fi
>>> +done
>>> +
>>> +echo "Corruption possibility: $corrupted/$loop_counts" >> $seqres.full
>>> +echo "Silence is golden"
>>> +
>>> +# success, all done
>>> +status=0
>>> +exit
>>> diff --git a/tests/btrfs/140.out b/tests/btrfs/140.out
>>> new file mode 100644
>>> index 0000000..24e90bc
>>> --- /dev/null
>>> +++ b/tests/btrfs/140.out
>>> @@ -0,0 +1,2 @@
>>> +QA output created by 140
>>> +Silence is golden
>>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>>> index 641d826..e4c76e3 100644
>>> --- a/tests/btrfs/group
>>> +++ b/tests/btrfs/group
>>> @@ -142,3 +142,4 @@
>>>  137 auto quick send
>>>  138 auto compress
>>>  139 auto qgroup
>>> +140 auto
>>
>> Add the compress group.
>>
>> thanks
>>
>>> --
>>> 2.9.3
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Filipe David Manana,
>>
>> “Whether you think you can, or you think you can't — you're right.”
>
>
>


