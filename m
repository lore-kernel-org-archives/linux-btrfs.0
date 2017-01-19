Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34428 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752378AbdASMSc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 07:18:32 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAL3q7H6qQZ+H8KU86x46Va8bmwhrMrWzH=8K7385BpuPLD5MFQ@mail.gmail.com>
References: <1483527210-2530-1-git-send-email-robbieko@synology.com>
 <1483527210-2530-3-git-send-email-robbieko@synology.com> <CAL3q7H7y2iLrUQVGBDBsNUqn0JRTqqUCrpL6m1yAvHyK1E7ZLg@mail.gmail.com>
 <ea8911b56cc08ecb821c4a6bb8e4646c@synology.com> <CAL3q7H6qQZ+H8KU86x46Va8bmwhrMrWzH=8K7385BpuPLD5MFQ@mail.gmail.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 19 Jan 2017 12:10:43 +0000
Message-ID: <CAL3q7H7HGkfcKtgwWvqA=MN7QnC0v27gE3gU63iGdbLTTvPvsw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] xfstests: btrfs/132: add test for invaild update
 time by an incremental send
To: robbieko <robbieko@synology.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 5, 2017 at 11:31 AM, Filipe Manana <fdmanana@gmail.com> wrote:
> On Thu, Jan 5, 2017 at 2:45 AM, robbieko <robbieko@synology.com> wrote:
>> Filipe Manana 於 2017-01-04 21:09 寫到:
>>
>>> On Wed, Jan 4, 2017 at 10:53 AM, robbieko <robbieko@synology.com> wrote:
>>>>
>>>> From: Robbie Ko <robbieko@synology.com>
>>>>
>>>> Test that an incremental send operation dosen't' work because
>>>> it tries to update the time to a deleted directory after it finishes
>>>> a move operation.
>>>>
>>>> The other one is that an operation is applied to a file using the old
>>>> name not the new name.
>>>>
>>>> This test exercises scenarios used to fail in btrfs and are fixed by
>>>> the following patches for the linux kernel:
>>>>
>>>> "Btrfs: incremental send, add generation check for the inode waiting for
>>>> rmdir operation."
>>>> "Btrfs: incremental send, add generation check in existence
>>>> demtermination for the parent directory"
>>>>
>>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>>>> ---
>>>> V3: remove "run_" based helpers
>>>> V2: improve the change log
>>>>
>>>>  tests/btrfs/132     | 123
>>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  tests/btrfs/132.out |   7 +++
>>>>  tests/btrfs/group   |   1 +
>>>>  3 files changed, 131 insertions(+)
>>>>  create mode 100755 tests/btrfs/132
>>>>  create mode 100644 tests/btrfs/132.out
>>>>
>>>> diff --git a/tests/btrfs/132 b/tests/btrfs/132
>>>> new file mode 100755
>>>> index 0000000..f1bb698
>>>> --- /dev/null
>>>> +++ b/tests/btrfs/132
>>>> @@ -0,0 +1,123 @@
>>>> +#! /bin/bash
>>>> +# FS QA Test No. btrfs/132
>>>> +#
>>>> +# Test that an incremental send operation dosen't' work because
>>>> +# it tries to update the time to a deleted directory after it finishes
>>>> +# a move operation.
>>>> +#
>>>> +# The other one is that an operation is applied to a file using the old
>>>> +# name not the new name.
>>>> +#
>>>> +#-----------------------------------------------------------------------
>>>> +# Copyright (C) 2016 Synology Inc. All Rights Reserved.
>>>> +# Author: Robbie Ko <robbieko@synology.com>
>>>> +#
>>>> +# This program is free software; you can redistribute it and/or
>>>> +# modify it under the terms of the GNU General Public License as
>>>> +# published by the Free Software Foundation.
>>>> +#
>>>> +# This program is distributed in the hope that it would be useful,
>>>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> +# GNU General Public License for more details.
>>>> +#
>>>> +# You should have received a copy of the GNU General Public License
>>>> +# along with this program; if not, write the Free Software Foundation,
>>>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>>>> +#-----------------------------------------------------------------------
>>>> +#
>>>> +
>>>> +seq=`basename $0`
>>>> +seqres=$RESULT_DIR/$seq
>>>> +echo "QA output created by $seq"
>>>> +
>>>> +tmp=/tmp/$$
>>>> +status=1       # failure is the default!
>>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>>> +
>>>> +_cleanup()
>>>> +{
>>>> +       cd /
>>>> +       rm -fr $send_files_dir
>>>> +       rm -f $tmp.*
>>>> +}
>>>> +
>>>> +# get standard environment, filters and checks
>>>> +. ./common/rc
>>>> +. ./common/filter
>>>> +
>>>> +# real QA test starts here
>>>> +_supported_fs btrfs
>>>> +_supported_os Linux
>>>> +_require_test
>>>> +_require_scratch
>>>> +_require_fssum
>>>> +
>>>> +send_files_dir=$TEST_DIR/btrfs-test-$seq
>>>> +
>>>> +rm -f $seqres.full
>>>> +rm -fr $send_files_dir
>>>> +mkdir $send_files_dir
>>>> +
>>>> +_scratch_mkfs >>$seqres.full 2>&1
>>>> +_scratch_mount
>>>> +
>>>> +mkdir $SCRATCH_MNT/dir257
>>>> +mkdir $SCRATCH_MNT/dir258
>>>> +mkdir $SCRATCH_MNT/dir259
>>>> +mv $SCRATCH_MNT/dir257 $SCRATCH_MNT/dir258/dir257
>>>> +
>>>> +# Filesystem looks like:
>>>> +#
>>>> +# .                                                             (ino
>>>> 256)
>>>> +# |--- dir258/                                                  (ino
>>>> 258)
>>>> +# |    |--- dir257/                                             (ino
>>>> 257)
>>>> +# |
>>>> +# |--- dir259/                                                  (ino
>>>> 259)
>>>> +#
>>>> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
>>>> +    $SCRATCH_MNT/mysnap1 > /dev/null
>>>> +
>>>> +mv $SCRATCH_MNT/dir258/dir257 $SCRATCH_MNT/dir257
>>>> +rmdir $SCRATCH_MNT/dir258
>>>> +rmdir $SCRATCH_MNT/dir259
>>>> +_scratch_unmount
>>>> +_scratch_mount
>>>
>>>
>>> Why do need to remount the fs? There's also a _scratch_remount function.
>>>
>>> Again, I would like to see comments in the test explaining why and
>>> how/why did the incremental send operation used to fail (like most of
>>> the existing send/receive tests have).
>>>
>>> thanks
>>
>>
>> Because we need to use the same inode 258 recreate, so need to delete the
>> old dir258 and dir259, then remount the fs, the next new file will be
>> generated
>> from inode 258.
>
> So you want to recreate the same inodes, with the same numbers but
> different generation values. You can get the same effect by using the
> mount option "-o inode_cache" (which is more obvious and doesn't rely
> on an implementation detail that is not guaranteed to exist forever).
> Again, as I said in my reply to some other test, this should be well
> explained as a comment in the test.

Nevermind. I have made the changes myself and sent a new version of
this test and the others, preserving your authorship.

In the future, please also take the care to update the change log to
mention the subject of the last versions of the kernel patches.
Right now these change logs refers to the subjects of older versions
of the kernel patches... Not really helpful.

thanks

>
> thanks
>
>>
>>
>> thanks
>>
>>>
>>>> +touch $SCRATCH_MNT/file258
>>>> +mkdir $SCRATCH_MNT/new_dir259
>>>> +mv $SCRATCH_MNT/dir257 $SCRATCH_MNT/new_dir259/dir257
>>>> +
>>>> +# Filesystem now looks like:
>>>> +#
>>>> +# .                                                             (ino
>>>> 256)
>>>> +# |--- file258                                                  (ino
>>>> 258)
>>>> +# |
>>>> +# |--- new_dir259/                                              (ino
>>>> 259)
>>>> +# |    |--- dir257/                                             (ino
>>>> 257)
>>>> +#
>>>> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
>>>> +    $SCRATCH_MNT/mysnap2 > /dev/null
>>>> +
>>>> +$FSSUM_PROG -A -f -w $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
>>>> +$FSSUM_PROG -A -f -w $send_files_dir/2.fssum \
>>>> +        -x $SCRATCH_MNT/mysnap2/mysnap1 $SCRATCH_MNT/mysnap2
>>>> +
>>>> +$BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f \
>>>> +    $send_files_dir/1.snap 2>&1 1>/dev/null | _filter_scratch
>>>> +$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
>>>> +       -f $send_files_dir/2.snap 2>&1 1>/dev/null | _filter_scratch
>>>> +
>>>> +# Now recreate the filesystem by receiving both send streams and verify
>>>> we get
>>>> +# the same content that the original filesystem had.
>>>> +_scratch_unmount
>>>> +_scratch_mkfs >>$seqres.full 2>&1
>>>> +_scratch_mount
>>>> +
>>>> +$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $send_files_dir/1.snap >
>>>> /dev/null
>>>> +$FSSUM_PROG -r $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
>>>> +$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $send_files_dir/2.snap >
>>>> /dev/null
>>>> +$FSSUM_PROG -r $send_files_dir/2.fssum $SCRATCH_MNT/mysnap2
>>>> +
>>>> +echo "Silence is golden"
>>>> +status=0
>>>> +exit
>>>> diff --git a/tests/btrfs/132.out b/tests/btrfs/132.out
>>>> new file mode 100644
>>>> index 0000000..ff21547
>>>> --- /dev/null
>>>> +++ b/tests/btrfs/132.out
>>>> @@ -0,0 +1,7 @@
>>>> +QA output created by 132
>>>> +At subvol SCRATCH_MNT/mysnap1
>>>> +At subvol SCRATCH_MNT/mysnap2
>>>> +At subvol mysnap1
>>>> +OK
>>>> +OK
>>>> +Silence is golden
>>>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>>>> index a7a070a..1b12382 100644
>>>> --- a/tests/btrfs/group
>>>> +++ b/tests/btrfs/group
>>>> @@ -134,3 +134,4 @@
>>>>  129 auto quick send
>>>>  130 auto clone send
>>>>  131 auto quick send
>>>> +132 auto quick send
>>>> --
>>>> 1.9.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "People will forget what you said,
>  people will forget what you did,
>  but people will never forget how you made them feel."



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
