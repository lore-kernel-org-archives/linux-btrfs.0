Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932297AbdDEJqC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Apr 2017 05:46:02 -0400
Date: Wed, 5 Apr 2017 17:46:00 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>, hch@lst.de
Subject: Re: [PATCH] generic: test for number of bytes used by files after
 buffered writes
Message-ID: <20170405094600.GW22845@eguan.usersys.redhat.com>
References: <1491272615-3795-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1491272615-3795-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 04, 2017 at 03:23:35AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that a filesystem's implementation of the stat(2) system call
> reports correct values for the number of blocks allocated for a file
> when there are delayed allocations.
> 
> This test is motivated by a bug in btrfs which is fixed by the following
> path for the linux kernel:
> 
>  "Btrfs: fix reported number of inode blocks"
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Overall this looks good to me, test fails with btrfs and passes with
other filesystems (tested xfs, extN). Some comments below.

> ---
>  tests/generic/422     | 126 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/422.out |  41 ++++++++++++++++
>  tests/generic/group   |   1 +
>  3 files changed, 168 insertions(+)
>  create mode 100755 tests/generic/422
>  create mode 100644 tests/generic/422.out
> 
> diff --git a/tests/generic/422 b/tests/generic/422
> new file mode 100755
> index 0000000..20cd54a
> --- /dev/null
> +++ b/tests/generic/422
> @@ -0,0 +1,126 @@
> +#! /bin/bash
> +# FS QA Test No. generic/422
> +#
> +# Test that a filesystem's implementation of the stat(2) system call reports
> +# correct values for the number of blocks allocated for a file when there are
> +# delayed allocations.
> +#
> +#-----------------------------------------------------------------------
> +#
> +# Copyright (C) 2017 SUSE Linux Products GmbH. All Rights Reserved.
> +# Author: Filipe Manana <fdmanana@suse.com>
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_test
> +_require_scratch

Need "_require_odirect" too, it does direct I/O.

> +_require_xfs_io_command "falloc"

This has some problems with the "-k" flag. NFSv4.2 supports fallocate(2)
but not KEEP_SIZE flag, so test fails with NFSv4.2 mount.

     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    +fallocate: Operation not supported
     wrote 65536/65536 bytes at offset 0

We met the same issue before with generic/071.
http://www.spinics.net/lists/fstests/msg03527.html

So I have two options now, one is the method proposed by Eric in above
thread, run falloc command with $param.

common/rc::_require_xfs_io_command
-               testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
+               testio=`$XFS_IO_PROG -F -f -c "falloc $param 0 1m" $testfile 2>&1`

tests/generic/422:
-_require_xfs_io_command "falloc"
+_require_xfs_io_command "falloc" "-k"


The other is requiring "falloc -k" in the test:

common/rc::_require_xfs_io_command
-       "falloc" )
-               testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
+       falloc* )
+               testio=`$XFS_IO_PROG -F -f -c "$command 0 1m" $testfile 2>&1`

tests/generic/422:
-_require_xfs_io_command "falloc"
+_require_xfs_io_command "falloc -k"

I slightly prefer the second way, as it doesn't change the default
behavior and makes falloc a special-case.
(_require_xfs_io_command "<cmd>" "<param>" behaves the same as other
commands).

Thanks,
Eryu

> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 64K" $SCRATCH_MNT/foo1 | _filter_xfs_io
> +$XFS_IO_PROG -f \
> +     -c "pwrite -S 0xaa 0 64K" \
> +     -c "truncate 128K" \
> +     $SCRATCH_MNT/foo2 | _filter_xfs_io
> +$XFS_IO_PROG -f \
> +     -c "falloc -k 0 128K" \
> +     -c "pwrite -S 0xaa 0 64K" \
> +     $SCRATCH_MNT/foo3 | _filter_xfs_io
> +touch $SCRATCH_MNT/foo4
> +
> +# Make sure everything done so far is durably persisted.
> +sync
> +
> +# Now overwrite the extent of the first file.
> +$XFS_IO_PROG -c "pwrite -S 0xff 0 64K" $SCRATCH_MNT/foo1 | _filter_xfs_io
> +
> +# Write to a hole of the second file.
> +$XFS_IO_PROG -c "pwrite -S 0xff 64K 64K" $SCRATCH_MNT/foo2 | _filter_xfs_io
> +# Write again to the same location, just to test that the fs will not account
> +# the same write twice.
> +$XFS_IO_PROG -c "pwrite -S 0x20 64K 64K" $SCRATCH_MNT/foo2 | _filter_xfs_io
> +
> +# Write beyond eof of the third file into the pre-allocated extent.
> +$XFS_IO_PROG -c "pwrite -S 0xff 64K 64K" $SCRATCH_MNT/foo3 | _filter_xfs_io
> +
> +# Do a buffered write immediately followed by a direct IO write, without a
> +# fsync in between, just to test that page invalidation does not lead to an
> +# incorrect number of file blocks reported.
> +$XFS_IO_PROG -c "pwrite -S 0xab 0 64K" $SCRATCH_MNT/foo4 | _filter_xfs_io
> +$XFS_IO_PROG -d -c "pwrite -S 0xef 0 64K" $SCRATCH_MNT/foo4 | _filter_xfs_io
> +
> +echo
> +echo "Before writeback"
> +echo
> +
> +echo "Space used by file foo1:"
> +du -h $SCRATCH_MNT/foo1 | _filter_scratch
> +
> +echo "Space used by file foo2:"
> +du -h $SCRATCH_MNT/foo2 | _filter_scratch
> +
> +echo "Space used by file foo3:"
> +du -h $SCRATCH_MNT/foo3 | _filter_scratch
> +
> +echo "Space used by file foo4:"
> +du -h $SCRATCH_MNT/foo4 | _filter_scratch
> +
> +sync
> +
> +# We expect the same file sizes reported by 'du' after writeback finishes.
> +echo
> +echo "After writeback"
> +echo
> +
> +echo "Space used by file foo1:"
> +du -h $SCRATCH_MNT/foo1 | _filter_scratch
> +
> +echo "Space used by file foo2:"
> +du -h $SCRATCH_MNT/foo2 | _filter_scratch
> +
> +echo "Space used by file foo3:"
> +du -h $SCRATCH_MNT/foo3 | _filter_scratch
> +
> +echo "Space used by file foo4:"
> +du -h $SCRATCH_MNT/foo4 | _filter_scratch
> +
> +status=0
> +exit
> diff --git a/tests/generic/422.out b/tests/generic/422.out
> new file mode 100644
> index 0000000..3696088
> --- /dev/null
> +++ b/tests/generic/422.out
> @@ -0,0 +1,41 @@
> +QA output created by 422
> +wrote 65536/65536 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 65536/65536 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 65536/65536 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 65536/65536 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 65536/65536 bytes at offset 65536
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 65536/65536 bytes at offset 65536
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 65536/65536 bytes at offset 65536
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 65536/65536 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 65536/65536 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +
> +Before writeback
> +
> +Space used by file foo1:
> +64K	SCRATCH_MNT/foo1
> +Space used by file foo2:
> +128K	SCRATCH_MNT/foo2
> +Space used by file foo3:
> +128K	SCRATCH_MNT/foo3
> +Space used by file foo4:
> +64K	SCRATCH_MNT/foo4
> +
> +After writeback
> +
> +Space used by file foo1:
> +64K	SCRATCH_MNT/foo1
> +Space used by file foo2:
> +128K	SCRATCH_MNT/foo2
> +Space used by file foo3:
> +128K	SCRATCH_MNT/foo3
> +Space used by file foo4:
> +64K	SCRATCH_MNT/foo4
> diff --git a/tests/generic/group b/tests/generic/group
> index 3c7c5e4..d747385 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -424,3 +424,4 @@
>  419 auto quick encrypt
>  420 auto quick punch
>  421 auto quick encrypt dangerous
> +422 auto quick
> -- 
> 2.7.0.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
