Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbbFRDsW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 23:48:22 -0400
Date: Thu, 18 Jun 2015 11:48:18 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: generic test for fsync after adding xattr to a
 file
Message-ID: <20150618034818.GW3672@dhcp-13-216.nay.redhat.com>
References: <1434541967-28402-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434541967-28402-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 12:52:47PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This test is motivated by an issue found in btrfs.
> 
> It tests that after syncing the filesystem, adding a xattr to a file,
> syncing the filesystem again, writing to the file and then doing a fsync
> against that file, the xattr still exists after a power failure. That is,
> after the fsync log/journal is replayed, the xattr still exists and with
> the correct value.
> 
> The btrfs issue is fixed by the patch titled:
> 
>   "Btrfs: fix fsync xattr loss in the fast fsync path"

If I read the above patch correctly, the issue to be tested here was
introduced by commit 4f764e515361 ("Btrfs: remove deleted xattrs on
fsync log replay"), which is in mainline kernel since v4.1-rc1, so the
test should fail on my v4.1-rc5 kernel, but I didn't see it fail.

Is it reproducible everytime? Or did I miss something?

> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  tests/generic/094     | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/094.out |  29 +++++++++++++
>  tests/generic/group   |   1 +
>  3 files changed, 142 insertions(+)
>  create mode 100755 tests/generic/094
>  create mode 100644 tests/generic/094.out
> 
> diff --git a/tests/generic/094 b/tests/generic/094
> new file mode 100755
> index 0000000..1c6d113
> --- /dev/null
> +++ b/tests/generic/094
> @@ -0,0 +1,112 @@
> +#! /bin/bash
> +# FS QA Test No. 094
> +#
> +# Test that after syncing the filesystem, adding a xattr to a file, syncing
> +# the filesystem again, writing to the file and then doing a fsync against that
> +# file, the xattr still exists after a power failure. That is, after the fsync
> +# log/journal is replayed, the xattr still exists and with the correct value.
> +#
> +# This test is motivated by a bug found in btrfs.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2015 SUSE Linux Products GmbH. All Rights Reserved.
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
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +	_cleanup_flakey
> +	rm -f $tmp.*
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmflakey
> +. ./common/attr
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_need_to_be_root
> +_require_scratch
> +_require_dm_flakey
> +_require_attrs
> +_require_metadata_journaling $SCRATCH_DEV
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_init_flakey
> +_mount_flakey
> +
> +# Create the test file with some initial data and make sure everything is
> +# durably persisted. We do fsync before calling sync to make sure that if the
> +# filesystem is btrfs, we get the flag BTRFS_INODE_NEEDS_FULL_SYNC cleared
> +# from the btrfs inode - a condition necessary to trigger the issue in btrfs.
> +$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 32k" \
> +		-c "fsync" \
> +		$SCRATCH_MNT/foo | _filter_xfs_io
> +sync
> +
> +# Add a xattr to our file.
> +$SETFATTR_PROG -n user.attr -v somevalue $SCRATCH_MNT/foo
> +
> +# Sync the filesystem to force a commit of the current btrfs transaction, this
> +# is a necessary condition to trigger the bug on btrfs.
> +sync
> +
> +# Now update our file's data and fsync the file.
> +# After a successful fsync, if the fsync log/journal is replayed we expect to
> +# see the xattr named "user.attr" with a value of "somevalue" (and the updated
> +# file data of course). Btrfs used to remove the xattr when it replayed the
> +# fsync log/journal.
> +$XFS_IO_PROG -c "pwrite -S 0xbb 8K 16K" \
> +		-c "fsync" \
> +		$SCRATCH_MNT/foo | _filter_xfs_io
> +
> +echo "File content after fsync and before crash:"
> +od -t x1 $SCRATCH_MNT/foo
> +
> +echo "File xattrs after fsync and before crash:"
> +$GETFATTR_PROG --absolute-names --dump $SCRATCH_MNT/foo | _filter_scratch
> +
> +# Simulate a crash/power loss.
> +_load_flakey_table $FLAKEY_DROP_WRITES
> +_unmount_flakey
> +
> +# Allow writes again and mount. This makes the fs replay its fsync log.
> +_load_flakey_table $FLAKEY_ALLOW_WRITES
> +_mount_flakey
> +
> +echo "File content after crash and log replay:"
> +od -t x1 $SCRATCH_MNT/foo
> +
> +echo "File xattrs after crash and log replay:"
> +$GETFATTR_PROG --absolute-names --dump $SCRATCH_MNT/foo | _filter_scratch
> +
> +status=0
> +exit
> diff --git a/tests/generic/094.out b/tests/generic/094.out
> new file mode 100644
> index 0000000..2e5e0fa
> --- /dev/null
> +++ b/tests/generic/094.out
> @@ -0,0 +1,29 @@
> +QA output created by 094
> +wrote 32768/32768 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 16384/16384 bytes at offset 8192
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +File content after fsync and before crash:
> +0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
> +*
> +0020000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
> +*
> +0060000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
> +*
> +0100000
> +File xattrs after fsync and before crash:
> +# file: SCRATCH_MNT/foo
> +user.attr="somevalue"
> +
> +File content after crash and log replay:
> +0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
> +*
> +0020000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
> +*
> +0060000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
> +*
> +0100000
> +File xattrs after crash and log replay:
> +# file: SCRATCH_MNT/foo
> +user.attr="somevalue"
> +

git am complains about the new line at EOF, but I think it's fine here,
it's generated by getfattr output and needed to match the output.

Thanks,
Eryu

> diff --git a/tests/generic/group b/tests/generic/group
> index ae40fed..18f31a7 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -96,6 +96,7 @@
>  091 rw auto quick
>  092 auto quick prealloc
>  093 attr cap udf auto
> +094 metadata auto quick
>  097 udf auto
>  099 udf auto
>  100 udf auto
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
