Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34925 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932445AbdDGJa3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 05:30:29 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <cb1aed11-abd7-967f-9633-517034341016@cn.fujitsu.com>
References: <20170406012853.31414-1-quwenruo@cn.fujitsu.com>
 <CAL3q7H6dUOL-WhsFBvgDSRgg3DwKnUP2f0Z11DK+ab+3ZKBOHg@mail.gmail.com> <cb1aed11-abd7-967f-9633-517034341016@cn.fujitsu.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 7 Apr 2017 10:30:27 +0100
Message-ID: <CAL3q7H5u2etYCQnweOdwVQnOxwdYuv=SDQ2hQCRFE=83zVOTiQ@mail.gmail.com>
Subject: Re: [PATCH v3] fstests: btrfs: Check if btrfs will create
 inline-then-regular file extents
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        fstests@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 7, 2017 at 1:28 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 04/07/2017 12:02 AM, Filipe Manana wrote:
>>
>> On Thu, Apr 6, 2017 at 2:28 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>
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
>>> file extents following.
>>>
>>> The bug is here for a long long time, so long that we have modified
>>> kernel and btrfs-progs to accept such case, but it's still not designed
>>> behavior, and must be detected and fixed.
>>
>>
>> So after looking at this better, I'm not convinced it's a problem.
>> Other than making btrfs/137 fail when compression is enabled, what
>> problems have you observed?
>
>
> Inline-then-regular file extent layout itself is a problem.

It is when the inline extent represents less than 4096 bytes of data.
I've fixed such problems in the past with the clone ioctl at least.

>
> Just check the behavior of plain btrfs.
>
> Inline extent must be the *only* extent, hole/regular/prealloc extent
> shouldn't co-exist with inline extent.

Yes, if the inline extent represents less than 4096 bytes of data,
which isn't the case this test is exercising.

>
> Such append should convert the inline extent to regular.
>
> Furthermore, this behavior also exposes the confusion of max_inline.
> If we are limiting inline extent size by its compressed size other than
> plain size, then we're hiding a new limit, page size.

You haven't answered my question. So let me state it again.

Did you find any problem with this scenario, where an inline extent
represents 4096 bytes of data?

To me it seems that you didn't either understood nor did any research
to see if this causes a problem neither to understand the steps that
lead to this scenario:

1) You found btrfs/137 failing because of this, then you just copy
pasted it into a new test case and removed the use of send/receive.
You didn't investigate what leads exactly to the potential problem and
you claimed it was probabilistic when it's really fully deterministic
and there's no need to involve snapshots;

2) You claimed there's a problem but you haven't yet said what is the
problem. Does this scenario causes any kernel crash? Does it result in
some sort of corruption? Does it prevent any file operation from
succeeding? So far it doesn't seem it causes any problem from a user's
perspective.

Unless there's evidence this particular case (inline extent containing
4096 bytes of data) causes at least one problem, I don't agree with
inclusion of this test.

thanks




>
> Thanks,
> Qu
>
>
>>
>> btrfs/137 fails due to the incremental send code not being prepared
>> for this case, which does not seem harmful to me because the inline
>> extent represents 4096 bytes of uncompressed data. It would be a
>> problem only if the uncompressed data was less than 4096 bytes.
>>
>> So unless there's evidence that this particular case causes problems
>> somewhere, I don't think it's useful to have this test.
>>
>> As for btrfs/137, I'm sending a fix for the incremental send code.
>>
>> More comments below anyway.
>>
>>>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>> v2:
>>>   All suggested by Eryu Guan
>>>   Use loop_counts instead of runtime to avoid naming confusion.
>>>   Fix whitespace issues
>>>   Use fsync instead of sync
>>>   Use $XFS_IO_PROG instead of calling xfs_io directly
>>>   Always output corruption possibility into seqres.full
>>>
>>> v3:
>>>   All suggested by Filipe Manana
>>>   Fix gramma errors
>>>   Use simpler reproducer
>>>   Add test case to compress group
>>> ---
>>>  tests/btrfs/140     | 111
>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  tests/btrfs/140.out |   2 +
>>>  tests/btrfs/group   |   1 +
>>>  3 files changed, 114 insertions(+)
>>>  create mode 100755 tests/btrfs/140
>>>  create mode 100644 tests/btrfs/140.out
>>>
>>> diff --git a/tests/btrfs/140 b/tests/btrfs/140
>>> new file mode 100755
>>> index 0000000..183d9cd
>>> --- /dev/null
>>> +++ b/tests/btrfs/140
>>> @@ -0,0 +1,111 @@
>>> +#! /bin/bash
>>> +# FS QA Test 140
>>> +#
>>> +# Check if btrfs will create inline-then-regular file layout.
>>> +#
>>> +# Btrfs only allows inline file extent if file is small enough, and any
>>> +# incoming write enlarges the file beyond max_inline should replace
>>> inline
>>> +# extents with regular extents.
>>> +# This is a long standing bug, so fsck won't detect it and kernel will
>>> allow
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
>>> +loop_counts=$(($LOAD_FACTOR * 4)) #The possibility is over 80%, just in
>>> case
>>
>>
>> Sorry I forgot about this before.
>> But why is the possibility not 100%? The code that skips the inline
>> extent expansion/conversion is 100% deterministic
>> (btrfs_file_write_iter() -> btrfs_cont_expand() ->
>> btrfs_truncate_block()) since the first extent always has a size of
>> 4096 bytes.
>>
>> So even if we end up having this test for some reason, there's no need
>> to have loops and the test could be added to the quick group.
>>
>>> +
>>> +do_test()
>>> +{
>>> +       _scratch_mkfs > /dev/null 2>&1
>>> +
>>> +       # specify max_inline and compress explicitly to create
>>> +       # inlined compressed extent
>>> +       _scratch_mount "-o max_inline=$inline_size,compress"
>>> +
>>> +       # Page sized data will be compressed to quite small size,
>>> +       # which is about 50 bytes for 4K, 100 bytes for 64K,
>>> +       # far smaller than $inline_size, causing a inlined compressed
>>> +       # file extent
>>> +       $XFS_IO_PROG -f -c "pwrite 0 $page_size" -c "fsync"
>>> $SCRATCH_MNT/file \
>>> +               > /dev/null 2>&1
>>> +
>>> +       # Append another page to file in snapshot, since its offset is
>>> not
>>
>>
>> There are no more snapshots, the comment is outdated.
>>
>> Thanks.
>>
>>> +       # 0, it will cause regular extent, and should convert inline
>>> extent
>>> +       # to regular too.
>>> +       $XFS_IO_PROG -c "pwrite $page_size $page_size" $SCRATCH_MNT/file
>>> \
>>> +               > /dev/null 2>&1
>>> +       _scratch_unmount
>>> +
>>> +       # Fsck won't report inline-then-regular as error, as it's so long
>>> +       # standing that we have no choice but to accept.
>>> +       # So here we use dump-tree to catch inline extent.
>>> +       $BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV \
>>> +               > $tmp.dump_tree 2>&1
>>> +       if grep -q inline $tmp.dump_tree; then
>>> +               cat $tmp.dump_tree >> $seqres.full
>>> +               echo "Invalid inline file extent detected"
>>> +               return 1
>>> +       fi
>>> +       return 0
>>> +}
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
>>> index 641d826..2c38fdd 100644
>>> --- a/tests/btrfs/group
>>> +++ b/tests/btrfs/group
>>> @@ -142,3 +142,4 @@
>>>  137 auto quick send
>>>  138 auto compress
>>>  139 auto qgroup
>>> +140 auto compress
>>> --
>>> 2.9.3
>>>
>>>
>>>
>>
>>
>>
>
>



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
