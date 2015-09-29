Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33935 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934223AbbI2KYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 06:24:06 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <560A6451.6050808@gmx.com>
References: <1443519264-19184-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20150929100013.GD25907@carfax.org.uk>
	<560A6451.6050808@gmx.com>
Date: Tue, 29 Sep 2015 11:24:05 +0100
Message-ID: <CAL3q7H4+xS7OOJd-Ny0zzA0a4JVrNHbhzCKStKcTReqriYyKrw@mail.gmail.com>
Subject: Re: [PATCH v2] fstests: generic: Check if a bull fallocate will
 change extent number
From: Filipe Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        fstests@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 29, 2015 at 11:13 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> 在 2015年09月29日 18:00, Hugo Mills 写道:
>>
>> On Tue, Sep 29, 2015 at 05:34:24PM +0800, Qu Wenruo wrote:
>>>
>>> Normally, a bull fallocate call on a fully written and synced file
>>> should not add an extent.
>>
>>
>>     What's a "bull" fallocate call? Is it a typo, or simply something
>> I'm not familiar with?
>>
>>     Hugo.
>
>
> Oh, it should be null.
> But null still seems not appropriate here.
>
> I mean a fallocate call which doesn't really allocate any space...
>
> Any good ideas?

"Test if fallocate will create uneeded extra tailing extent"

change it to:

"Test that calling fallocate against a range which is already
allocated does not create new file extents".

No need to categorize such case for fallocate imho (but I'm not a
native English speaker either).

>
> Thanks,
> Qu
>
>>
>>> But not all filesystem follows the correct behavior.
>>>
>>> Btrfs has a bug to always truncate the last page if the fallocate start
>>> offset is smaller than inode size.
>>>
>>> So add this test case to detect such malfunction.
>>>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>> v2:
>>>    Add author info...
>>>    Fix some comment typo
>>> ---
>>>   tests/generic/110     | 78
>>> +++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   tests/generic/110.out |  3 ++
>>>   tests/generic/group   |  1 +
>>>   3 files changed, 82 insertions(+)
>>>   create mode 100755 tests/generic/110
>>>   create mode 100644 tests/generic/110.out
>>>
>>> diff --git a/tests/generic/110 b/tests/generic/110
>>> new file mode 100755
>>> index 0000000..b2b140c
>>> --- /dev/null
>>> +++ b/tests/generic/110
>>> @@ -0,0 +1,78 @@
>>> +#! /bin/bash
>>> +# FS QA Test 110
>>> +#
>>> +# Test if fallocate will create uneeded extra tailing extent
>>> +#
>>> +#-----------------------------------------------------------------------
>>> +# Copyright (c) 2015 Fujitsu.  All Rights Reserved.
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
>>> +. ./common/defrag
>>> +
>>> +# remove previous $seqres.full before test
>>> +rm -f $seqres.full
>>> +
>>> +# real QA test starts here
>>> +
>>> +_supported_fs generic
>>> +_supported_os IRIX Linux
>>> +_require_scratch
>>> +_need_to_be_root
>>> +
>>> +# Use 64K file size to match any sectorsize
>>> +# And with a unaligned tailing range to ensure it will be at least 2
>>> pages
>>> +filesize=$(( 64 * 1024 + 1024 ))
>>> +
>>> +_scratch_mkfs > /dev/null 2>&1
>>> +_scratch_mount
>>> +$XFS_IO_PROG -f -c "pwrite 0 $filesize" $SCRATCH_MNT/foo |
>>> _filter_xfs_io
>>> +sync
>>> +orig_extent_nr=`_extent_count $SCRATCH_MNT/foo`
>>> +
>>> +# As all space are allocated and even written to disk, this falloc
>>> +# should do nothing with extent modification.
>>> +$XFS_IO_PROG -f -c "falloc 0 $filesize" $SCRATCH_MNT/foo
>>> +sync
>>> +new_extent_nr=`_extent_count $SCRATCH_MNT/foo`
>>> +
>>> +echo "orig: $orig_extent_nr, new: $new_extent_nr" >> $seqres.full
>>> +
>>> +if [ "x$orig_extent_nr" != "x$new_extent_nr" ]; then
>>> +       echo "number of extents mis-match after bull fallocate"
>>> +fi
>>> +
>>> +# success, all done
>>> +status=0
>>> +exit
>>> diff --git a/tests/generic/110.out b/tests/generic/110.out
>>> new file mode 100644
>>> index 0000000..64049da
>>> --- /dev/null
>>> +++ b/tests/generic/110.out
>>> @@ -0,0 +1,3 @@
>>> +QA output created by 110
>>> +wrote 66560/66560 bytes at offset 0
>>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>>> diff --git a/tests/generic/group b/tests/generic/group
>>> index 4ae256f..428f3e3 100644
>>> --- a/tests/generic/group
>>> +++ b/tests/generic/group
>>> @@ -112,6 +112,7 @@
>>>   107 auto quick metadata
>>>   108 auto quick rw
>>>   109 auto metadata dir
>>> +110 auto quick prealloc
>>>   112 rw aio auto quick
>>>   113 rw aio auto quick
>>>   117 attr auto quick
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
