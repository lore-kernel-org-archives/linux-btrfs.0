Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932096AbdDDQfI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Apr 2017 12:35:08 -0400
MIME-Version: 1.0
In-Reply-To: <83c423c0-03d0-0b1c-4153-9e605149fb0b@cn.fujitsu.com>
References: <1487104553-13858-1-git-send-email-fdmanana@kernel.org> <83c423c0-03d0-0b1c-4153-9e605149fb0b@cn.fujitsu.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 4 Apr 2017 17:35:04 +0100
Message-ID: <CAL3q7H705Ethox3o6rZ45-4sYqGmyponnBtoDM5=afHbm+wZYg@mail.gmail.com>
Subject: Re: [PATCH] fstests: add test for btrfs send/receive with sparse files
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 21, 2017 at 6:50 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Hi Filipe,
>
> At 02/15/2017 04:35 AM, fdmanana@kernel.org wrote:
>>
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> Test that both a full and incremental btrfs send operation preserves file
>> holes.
>
>
> I found the test case fails with compress=lzo mount option.

I had seen it too but had no time so far to investigate it.

>
> In fact, it turns out to be 2 bugs:
>
> [Inline-then-regular layout]
> And further more, it seems that it can create inline-then-regular file
> extents layout with compress=lzo.

That's not good.

I'll take a look at it.

Thanks.

>
> It does not always create such inline-then-regular, but the possibility
> seems quite high in my test box, near 80%.
>
> Btrfs dump tree for snap2 (258):
>         item 9 key (257 INODE_REF 256) itemoff 15736 itemsize 13
>                 inode ref index 2 namelen 3 name: foo
>         item 10 key (257 EXTENT_DATA 0) itemoff 15663 itemsize 73
>                 generation 7 type 0 (inline)
>                 inline extent data size 52 ram_bytes 4096 compression 2
> (lzo)
>         item 11 key (257 EXTENT_DATA 4096) itemoff 15610 itemsize 53
>                 generation 8 type 1 (regular)
>                 extent data disk byte 0 nr 0
>                 extent data offset 0 nr 1048576 ram 1052672
>                 extent compression 0 (none)
>         item 12 key (257 EXTENT_DATA 1052672) itemoff 15557 itemsize 53
>                 generation 8 type 1 (regular)
>                 extent data disk byte 12582912 nr 4096
>                 extent data offset 0 nr 4096 ram 4096
>                 extent compression 0 (none)
>
> [Send-stream without hole]
> This bug is 100% reproducible, the send stream of snap2 contains no hole,
> just the full file contents.
>
> Thanks,
> Qu
>
>
>>
>> This used to fail when the filesystem had the NO_HOLES feature enabled,
>> that is, when the test is run with MKFS_OPTIONS="-O no-holes".
>>
>> This is fixed by the following patch for the linux kernel:
>>
>>   "Btrfs: incremental send, fix unnecessary hole writes for sparse files"
>>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>  tests/btrfs/137     | 141
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/137.out |  63 +++++++++++++++++++++++
>>  tests/btrfs/group   |   1 +
>>  3 files changed, 205 insertions(+)
>>  create mode 100755 tests/btrfs/137
>>  create mode 100644 tests/btrfs/137.out
>>
>> diff --git a/tests/btrfs/137 b/tests/btrfs/137
>> new file mode 100755
>> index 0000000..3ff2c6b
>> --- /dev/null
>> +++ b/tests/btrfs/137
>> @@ -0,0 +1,141 @@
>> +#! /bin/bash
>> +# FS QA Test No. btrfs/137
>> +#
>> +# Test that both incremental and full send operations preserve file
>> holes.
>> +#
>> +#-----------------------------------------------------------------------
>> +#
>> +# Copyright (C) 2017 SUSE Linux Products GmbH. All Rights Reserved.
>> +# Author: Filipe Manana <fdmanana@suse.com>
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
>> +tmp=/tmp/$$
>> +status=1       # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +       cd /
>> +       rm -fr $send_files_dir
>> +       rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/punch
>> +
>> +# real QA test starts here
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_test
>> +_require_scratch
>> +_require_xfs_io_command "fiemap"
>> +
>> +send_files_dir=$TEST_DIR/btrfs-test-$seq
>> +
>> +rm -f $seqres.full
>> +rm -fr $send_files_dir
>> +mkdir $send_files_dir
>> +
>> +_scratch_mkfs >>$seqres.full 2>&1
>> +_scratch_mount
>> +
>> +# Create the first test file.
>> +$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 4K" $SCRATCH_MNT/foo |
>> _filter_xfs_io
>> +
>> +# Create a second test file with a 1Mb hole.
>> +$XFS_IO_PROG -f \
>> +     -c "pwrite -S 0xaa 0 4K" \
>> +     -c "pwrite -S 0xbb 1028K 4K" \
>> +     $SCRATCH_MNT/bar | _filter_xfs_io
>> +
>> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
>> +       $SCRATCH_MNT/snap1 >/dev/null
>> +
>> +# Now add one new extent to our first test file, increasing its size and
>> leaving
>> +# a 1Mb hole between the first extent and this new extent.
>> +$XFS_IO_PROG -c "pwrite -S 0xbb 1028K 4K" $SCRATCH_MNT/foo |
>> _filter_xfs_io
>> +
>> +# Now overwrite the last extent of our second test file.
>> +$XFS_IO_PROG -c "pwrite -S 0xcc 1028K 4K" $SCRATCH_MNT/bar |
>> _filter_xfs_io
>> +
>> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
>> +                $SCRATCH_MNT/snap2 >/dev/null
>> +
>> +echo
>> +echo "File digests in the original filesystem:"
>> +md5sum $SCRATCH_MNT/snap1/foo | _filter_scratch
>> +md5sum $SCRATCH_MNT/snap1/bar | _filter_scratch
>> +md5sum $SCRATCH_MNT/snap2/foo | _filter_scratch
>> +md5sum $SCRATCH_MNT/snap2/bar | _filter_scratch
>> +
>> +echo
>> +echo "File snap1/foo fiemap results in the original filesystem:"
>> +$XFS_IO_PROG -r -c "fiemap -v" $SCRATCH_MNT/snap1/foo | _filter_fiemap
>> +echo
>> +echo "File snap1/bar fiemap results in the original filesystem:"
>> +$XFS_IO_PROG -r -c "fiemap -v" $SCRATCH_MNT/snap1/bar | _filter_fiemap
>> +echo
>> +echo "File snap2/foo fiemap results in the original filesystem:"
>> +$XFS_IO_PROG -r -c "fiemap -v" $SCRATCH_MNT/snap2/foo | _filter_fiemap
>> +echo
>> +echo "File snap2/bar fiemap results in the original filesystem:"
>> +$XFS_IO_PROG -r -c "fiemap -v" $SCRATCH_MNT/snap2/bar | _filter_fiemap
>> +echo
>> +
>> +# Create the send streams to apply later on a new filesystem.
>> +$BTRFS_UTIL_PROG send $SCRATCH_MNT/snap1 -f $send_files_dir/1.snap 2>&1 \
>> +       | _filter_scratch
>> +$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/snap1 $SCRATCH_MNT/snap2 \
>> +       -f $send_files_dir/2.snap 2>&1 | _filter_scratch
>> +
>> +# Create a new filesystem, receive the send streams and verify that the
>> file
>> +# contents are the same as in the original filesystem and that the file
>> holes
>> +# exists in both snapshots.
>> +_scratch_unmount
>> +_scratch_mkfs >>$seqres.full 2>&1
>> +_scratch_mount
>> +$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $send_files_dir/1.snap
>> >/dev/null
>> +$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $send_files_dir/2.snap
>> >/dev/null
>> +
>> +echo
>> +echo "File digests in the new filesystem:"
>> +md5sum $SCRATCH_MNT/snap1/foo | _filter_scratch
>> +md5sum $SCRATCH_MNT/snap1/bar | _filter_scratch
>> +md5sum $SCRATCH_MNT/snap2/foo | _filter_scratch
>> +md5sum $SCRATCH_MNT/snap2/bar | _filter_scratch
>> +
>> +echo
>> +echo "File snap1/foo fiemap results in the new filesystem:"
>> +$XFS_IO_PROG -r -c "fiemap -v" $SCRATCH_MNT/snap1/foo | _filter_fiemap
>> +echo
>> +echo "File snap1/bar fiemap results in the new filesystem:"
>> +$XFS_IO_PROG -r -c "fiemap -v" $SCRATCH_MNT/snap1/bar | _filter_fiemap
>> +echo
>> +echo "File snap2/foo fiemap results in the new filesystem:"
>> +$XFS_IO_PROG -r -c "fiemap -v" $SCRATCH_MNT/snap2/foo | _filter_fiemap
>> +echo
>> +echo "File snap2/bar fiemap results in the new filesystem:"
>> +$XFS_IO_PROG -r -c "fiemap -v" $SCRATCH_MNT/snap2/bar | _filter_fiemap
>> +
>> +status=0
>> +exit
>> diff --git a/tests/btrfs/137.out b/tests/btrfs/137.out
>> new file mode 100644
>> index 0000000..8554399
>> --- /dev/null
>> +++ b/tests/btrfs/137.out
>> @@ -0,0 +1,63 @@
>> +QA output created by 137
>> +wrote 4096/4096 bytes at offset 0
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +wrote 4096/4096 bytes at offset 0
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +wrote 4096/4096 bytes at offset 1052672
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +wrote 4096/4096 bytes at offset 1052672
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +wrote 4096/4096 bytes at offset 1052672
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +
>> +File digests in the original filesystem:
>> +3e4309c7cc81f23d45e260a8f13ca860  SCRATCH_MNT/snap1/foo
>> +f3934f0cf164e2efa1bab71f2f164990  SCRATCH_MNT/snap1/bar
>> +f3934f0cf164e2efa1bab71f2f164990  SCRATCH_MNT/snap2/foo
>> +d3dc847171f9081bd75d7a2d3b53d322  SCRATCH_MNT/snap2/bar
>> +
>> +File snap1/foo fiemap results in the original filesystem:
>> +0: [0..7]: data
>> +
>> +File snap1/bar fiemap results in the original filesystem:
>> +0: [0..7]: data
>> +1: [8..2055]: hole
>> +2: [2056..2063]: data
>> +
>> +File snap2/foo fiemap results in the original filesystem:
>> +0: [0..7]: data
>> +1: [8..2055]: hole
>> +2: [2056..2063]: data
>> +
>> +File snap2/bar fiemap results in the original filesystem:
>> +0: [0..7]: data
>> +1: [8..2055]: hole
>> +2: [2056..2063]: data
>> +
>> +At subvol SCRATCH_MNT/snap1
>> +At subvol SCRATCH_MNT/snap2
>> +At subvol snap1
>> +
>> +File digests in the new filesystem:
>> +3e4309c7cc81f23d45e260a8f13ca860  SCRATCH_MNT/snap1/foo
>> +f3934f0cf164e2efa1bab71f2f164990  SCRATCH_MNT/snap1/bar
>> +f3934f0cf164e2efa1bab71f2f164990  SCRATCH_MNT/snap2/foo
>> +d3dc847171f9081bd75d7a2d3b53d322  SCRATCH_MNT/snap2/bar
>> +
>> +File snap1/foo fiemap results in the new filesystem:
>> +0: [0..7]: data
>> +
>> +File snap1/bar fiemap results in the new filesystem:
>> +0: [0..7]: data
>> +1: [8..2055]: hole
>> +2: [2056..2063]: data
>> +
>> +File snap2/foo fiemap results in the new filesystem:
>> +0: [0..7]: data
>> +1: [8..2055]: hole
>> +2: [2056..2063]: data
>> +
>> +File snap2/bar fiemap results in the new filesystem:
>> +0: [0..7]: data
>> +1: [8..2055]: hole
>> +2: [2056..2063]: data
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index ea88ba4..009dea1 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -139,3 +139,4 @@
>>  134 auto quick send
>>  135 auto quick send
>>  136 auto convert
>> +137 auto quick send
>>
>
>
