Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35069 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762062AbdAEL2m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jan 2017 06:28:42 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <edb59fe19caeed584141d9616f428c10@synology.com>
References: <1483527210-2530-1-git-send-email-robbieko@synology.com>
 <1483527210-2530-5-git-send-email-robbieko@synology.com> <CAL3q7H6eNoP6v+T=AXwB+5V0z_GMaJq8BxU=PO6z0mhRNtyuBA@mail.gmail.com>
 <edb59fe19caeed584141d9616f428c10@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 5 Jan 2017 11:28:17 +0000
Message-ID: <CAL3q7H4+qHR-wQqDJ960sXNdTipoqxQX-0aEsmQSpS9oSo+Upw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] xfstests: btrfs/134: add test for incremental send
 which renames a directory already being deleted
To: robbieko <robbieko@synology.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 5, 2017 at 5:22 AM, robbieko <robbieko@synology.com> wrote:
> Filipe Manana 於 2017-01-04 21:07 寫到:
>
>> On Wed, Jan 4, 2017 at 10:53 AM, robbieko <robbieko@synology.com> wrote:
>>>
>>> From: Robbie Ko <robbieko@synology.com>
>>>
>>> Test that an incremental send operation dosen't work because
>>
>>
>> dosen't -> doesn't
>>
>>> it tries to rename a directory which is already deleted.
>>>
>>> This test exercises scenarios used to fail in btrfs and are fixed by
>>> the following patch for the linux kernel:
>>>
>>> "Btrfs: incremental send, add generation check for inode is waiting for
>>> move."
>>>
>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>>> ---
>>> V3: remove "run_" based helpers
>>> V2: improve the change log
>>>
>>>  tests/btrfs/134     | 124
>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  tests/btrfs/134.out |   9 ++++
>>>  tests/btrfs/group   |   1 +
>>>  3 files changed, 134 insertions(+)
>>>  create mode 100755 tests/btrfs/134
>>>  create mode 100644 tests/btrfs/134.out
>>>
>>> diff --git a/tests/btrfs/134 b/tests/btrfs/134
>>> new file mode 100755
>>> index 0000000..87c108e
>>> --- /dev/null
>>> +++ b/tests/btrfs/134
>>> @@ -0,0 +1,124 @@
>>> +#! /bin/bash
>>> +# FS QA Test No. btrfs/134
>>> +#
>>> +# Test that an incremental send operation dosen't work because
>>
>>
>> dosen't -> doesn't
>>
>>> +# it tries to rename a directory which is already deleted.
>>> +#
>>> +#-----------------------------------------------------------------------
>>> +# Copyright (C) 2016 Synology Inc. All Rights Reserved.
>>
>>
>> We're already in 2017 btw.
>>
>>> +# Author: Robbie Ko <robbieko@synology.com>
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
>>> +tmp=/tmp/$$
>>> +status=1       # failure is the default!
>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>> +
>>> +_cleanup()
>>> +{
>>> +       cd /
>>> +       rm -fr $send_files_dir
>>> +       rm -f $tmp.*
>>> +}
>>> +
>>> +# get standard environment, filters and checks
>>> +. ./common/rc
>>> +. ./common/filter
>>> +
>>> +# real QA test starts here
>>> +_supported_fs btrfs
>>> +_supported_os Linux
>>> +_require_test
>>> +_require_scratch
>>> +_require_fssum
>>> +
>>> +send_files_dir=$TEST_DIR/btrfs-test-$seq
>>> +
>>> +rm -f $seqres.full
>>> +rm -fr $send_files_dir
>>> +mkdir $send_files_dir
>>> +
>>> +_scratch_mkfs >>$seqres.full 2>&1
>>> +_scratch_mount
>>> +
>>> +mkdir $SCRATCH_MNT/d1
>>> +mkdir $SCRATCH_MNT/d4
>>> +mkdir $SCRATCH_MNT/d3
>>> +
>>> +# Filesystem looks like:
>>> +#
>>> +# .                                                             (ino
>>> 256)
>>> +# |--- d1                                                       (ino
>>> 257)
>>> +# |--- d4                                                       (ino
>>> 258)
>>> +# |--- d3                                                       (ino
>>> 259)
>>> +#
>>> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
>>> +    $SCRATCH_MNT/mysnap1 > /dev/null
>>> +
>>> +$BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f \
>>> +    $send_files_dir/1.snap 2>&1 1>/dev/null | _filter_scratch
>>> +
>>> +_scratch_unmount
>>> +_scratch_mkfs >>$seqres.full 2>&1
>>> +_scratch_mount
>>
>>
>> I don't understand this. Why do we need to recreate the filesystem?
>> Why don't we just create the first and second snapshots in the same
>> filesystems, just like all the other tests do.
>>
>> I would like to see comments explaining why that is needed and how/why
>> the incremental send used to fail (in a user understandable way, not
>> in a very technical way referring to pieces of code of btrfs), just
>> like most of the existing send/receive tests have.
>>
>> I haven't tried nor reviewed the btrfs patches, but I hope to do it this
>> week.
>>
>> thanks
>
>
> Does not require recreate the filesystem, it just a scenario,
> there are many ways to do the same thing,

If there are many ways, then use the simpler one which doesn't raise
any questions and anyone can understand it.
If a non-obvious scenario is needed then just add a comment explaining why.

> we just need to use the same inode number, but different from the old one.

What you want to say is creating the same inode (same number) but with
a different generation, is that it?

And I would like to see this explanations as comments in the code.
Whenever in the future someone reads the test, he/she is unlikely to
go search the mailing list thread for explanations.

> Let btrfs send need to recreate dir.
>
> The primary mistake is "ERROR: rename d1 -> o257-44-0 failed: No such file
> or directory"
> But in fact the old d1 has been deleted.

Again, explain it in the test as a comment that send used to issue a
rename operation with a no longer valid source name (and why that
happened).
Look at the existing send/receive tests that have explanations of the
problems they test, for example:
https://git.kernel.org/cgit/fs/xfs/xfstests-dev.git/tree/tests/btrfs/129#n81

thanks


>
> thanks.
>
>
>>> +mkdir $SCRATCH_MNT/d1
>>> +mkdir $SCRATCH_MNT/d2
>>> +mkdir $SCRATCH_MNT/d3
>>> +mkdir $SCRATCH_MNT/d4
>>> +mv $SCRATCH_MNT/d1 $SCRATCH_MNT/d3/d1
>>> +mv $SCRATCH_MNT/d3 $SCRATCH_MNT/d4/d3
>>> +mv $SCRATCH_MNT/d2 $SCRATCH_MNT/d1
>>> +
>>> +# Filesystem now looks like:
>>> +#
>>> +# .                                                             (ino
>>> 256)
>>> +# |--- d1                                                       (ino
>>> 258)
>>> +# |--- d4                                                       (ino
>>> 260)
>>> +# |    |--- d3/                                                 (ino
>>> 259)
>>> +# |    |    |--- d1/                                            (ino
>>> 257)
>>> +#
>>> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
>>> +    $SCRATCH_MNT/mysnap2 > /dev/null
>>> +
>>> +$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $send_files_dir/1.snap >
>>> /dev/null
>>> +rm $send_files_dir/1.snap
>>> +
>>> +$FSSUM_PROG -A -f -w $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
>>> +$FSSUM_PROG -A -f -w $send_files_dir/2.fssum $SCRATCH_MNT/mysnap2
>>> +
>>> +$BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f \
>>> +    $send_files_dir/1.snap 2>&1 1>/dev/null | _filter_scratch
>>> +$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
>>> +       -f $send_files_dir/2.snap 2>&1 1>/dev/null | _filter_scratch
>>> +
>>> +# Now recreate the filesystem by receiving both send streams and verify
>>> we get
>>> +# the same content that the original filesystem had.
>>> +_scratch_unmount
>>> +_scratch_mkfs >>$seqres.full 2>&1
>>> +_scratch_mount
>>> +
>>> +$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $send_files_dir/1.snap >
>>> /dev/null
>>> +$FSSUM_PROG -r $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
>>> +$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $send_files_dir/2.snap >
>>> /dev/null
>>> +$FSSUM_PROG -r $send_files_dir/2.fssum $SCRATCH_MNT/mysnap2
>>> +
>>> +echo "Silence is golden"
>>> +status=0
>>> +exit
>>> diff --git a/tests/btrfs/134.out b/tests/btrfs/134.out
>>> new file mode 100644
>>> index 0000000..700a78f
>>> --- /dev/null
>>> +++ b/tests/btrfs/134.out
>>> @@ -0,0 +1,9 @@
>>> +QA output created by 134
>>> +At subvol SCRATCH_MNT/mysnap1
>>> +At subvol mysnap1
>>> +At subvol SCRATCH_MNT/mysnap1
>>> +At subvol SCRATCH_MNT/mysnap2
>>> +At subvol mysnap1
>>> +OK
>>> +OK
>>> +Silence is golden
>>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>>> index 779caec..831283e 100644
>>> --- a/tests/btrfs/group
>>> +++ b/tests/btrfs/group
>>> @@ -136,3 +136,4 @@
>>>  131 auto quick send
>>>  132 auto quick send
>>>  133 auto quick send
>>> +134 auto quick send
>>> --
>>> 1.9.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
