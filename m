Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbeHSTdm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Aug 2018 15:33:42 -0400
MIME-Version: 1.0
In-Reply-To: <20180819161926.GH2791@desktop>
References: <20180817083924.16916-1-fdmanana@kernel.org> <20180819140759.GG2791@desktop>
 <CAL3q7H7igoFqM+5sKUCVia_TK4Q9nR+4Ys7WuZ3eW1OiYY5_gA@mail.gmail.com> <20180819161926.GH2791@desktop>
From: Filipe Manana <fdmanana@kernel.org>
Date: Sun, 19 Aug 2018 17:21:40 +0100
Message-ID: <CAL3q7H5ocNCPur6pE8uUXxkXzJBxbd=5-WUQ5OAvyacWd-4YBA@mail.gmail.com>
Subject: Re: [PATCH] generic: test for deduplication between different files
To: Eryu Guan <guaneryu@gmail.com>
Cc: fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 19, 2018 at 5:19 PM, Eryu Guan <guaneryu@gmail.com> wrote:
> On Sun, Aug 19, 2018 at 04:41:31PM +0100, Filipe Manana wrote:
>> On Sun, Aug 19, 2018 at 3:07 PM, Eryu Guan <guaneryu@gmail.com> wrote:
>> > On Fri, Aug 17, 2018 at 09:39:24AM +0100, fdmanana@kernel.org wrote:
>> >> From: Filipe Manana <fdmanana@suse.com>
>> >>
>> >> Test that deduplication of an entire file that has a size that is not
>> >> aligned to the filesystem's block size into a different file does not
>> >> corrupt the destination's file data.
>> >>
>> >> This test is motivated by a bug found in Btrfs which is fixed by the
>> >> following patch for the linux kernel:
>> >>
>> >>   "Btrfs: fix data corruption when deduplicating between different files"
>> >>
>> >> XFS also fails this test, at least as of linux kernel 4.18-rc7, exactly
>> >> with the same corruption as in Btrfs - some bytes of a block get replaced
>> >> with zeroes after the deduplication.
>> >>
>> >> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> >> ---
>> >>  tests/generic/505     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++
>> >>  tests/generic/505.out | 33 ++++++++++++++++++++
>> >>  tests/generic/group   |  1 +
>> >>  3 files changed, 118 insertions(+)
>> >>  create mode 100755 tests/generic/505
>> >>  create mode 100644 tests/generic/505.out
>> >>
>> >> diff --git a/tests/generic/505 b/tests/generic/505
>> >> new file mode 100755
>> >> index 00000000..5ee232a2
>> >> --- /dev/null
>> >> +++ b/tests/generic/505
>> >> @@ -0,0 +1,84 @@
>> >> +#! /bin/bash
>> >> +# SPDX-License-Identifier: GPL-2.0
>> >> +# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
>> >> +#
>> >> +# FS QA Test No. 505
>> >> +#
>> >> +# Test that deduplication of an entire file that has a size that is not aligned
>> >> +# to the filesystem's block size into a different file does not corrupt the
>> >> +# destination's file data.
>> >> +#
>> >> +seq=`basename $0`
>> >> +seqres=$RESULT_DIR/$seq
>> >> +echo "QA output created by $seq"
>> >> +tmp=/tmp/$$
>> >> +status=1     # failure is the default!
>> >> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> >> +
>> >> +_cleanup()
>> >> +{
>> >> +     cd /
>> >> +     rm -f $tmp.*
>> >> +}
>> >> +
>> >> +# get standard environment, filters and checks
>> >> +. ./common/rc
>> >> +. ./common/filter
>> >> +. ./common/reflink
>> >> +
>> >> +# real QA test starts here
>> >> +_supported_fs generic
>> >> +_supported_os Linux
>> >> +_require_scratch_dedupe
>> >> +
>> >> +rm -f $seqres.full
>> >> +
>> >> +_scratch_mkfs >>$seqres.full 2>&1
>> >> +_scratch_mount
>> >> +
>> >> +# The first byte with a value of 0xae starts at an offset (2518890) which is not
>> >> +# a multiple of the block size.
>> >> +$XFS_IO_PROG -f \
>> >> +     -c "pwrite -S 0x6b 0 2518890" \
>> >> +     -c "pwrite -S 0xae 2518890 102398" \
>> >> +     $SCRATCH_MNT/foo | _filter_xfs_io
>> >> +
>> >> +# Create a second file with a length not aligned to the block size, whose bytes
>> >> +# all have the value 0x6b, so that its extent(s) can be deduplicated with the
>> >> +# first file.
>> >> +$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 557771" $SCRATCH_MNT/bar | _filter_xfs_io
>> >> +
>> >> +# The file is filled with bytes having the value 0x6b from offset 0 to offset
>> >> +# 2518889 and with the value 0xae from offset 2518890 to offset 2621287.
>> >> +echo "File content before deduplication:"
>> >> +od -t x1 $SCRATCH_MNT/foo
>> >> +
>> >> +# Now deduplicate the entire second file into a range of the first file that
>> >> +# also has all bytes with the value 0x6b. The destination range's end offset
>> >> +# must not be aligned to the block size and must be less then the offset of
>> >> +# the first byte with the value 0xae (byte at offset 2518890).
>> >> +$XFS_IO_PROG -c "dedupe $SCRATCH_MNT/bar 0 1957888 557771" $SCRATCH_MNT/foo \
>> >> +     | _filter_xfs_io
>> >> +
>> >> +# The bytes in the range starting at offset 2515659 (end of the deduplication
>> >> +# range) and ending at offset 2519040 (start offset rounded up to the block
>> >> +# size) must all have the value 0xae (and not replaced with 0x00 values).
>> >
>> > This doesn't seem right to me, range [2515659, 2518890) should be 0x6b
>> > not 0xae, while range [2518890, 2519040) indeed should contain 0xae.
>>
>> Yes, indeed. My mistake (got it right in the comment before the first
>> call to "od").
>> Can you fix it up (if there's nothing else to fix), or do you need me
>> to send a new version?
>
> Sure, I can fix it on commit. But I've already pushed this week's update
> to upstream, so you won't see it until next week :)

No problem.
Thanks!

>
> Thanks,
> Eryu
