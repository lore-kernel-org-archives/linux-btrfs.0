Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbbFRDk1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 23:40:27 -0400
Date: Thu, 18 Jun 2015 11:40:22 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: generic test for fsync after adding hard link
 to a file
Message-ID: <20150618034022.GV3672@dhcp-13-216.nay.redhat.com>
References: <1434541936-28353-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434541936-28353-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 12:52:16PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This test is motivated by an issue found in btrfs.
> 
> It tests that after syncing the filesystem, adding a hard link to a file,
> syncing the filesystem again, doing a write to the file that increases
> its size and then doing a fsync against that file, durably persists the
> data written to the file. That is, after log/journal replay, the data
> is available.
> 
> The btrfs issue is fixed by the commit titled:
> 
>   "Btrfs: fix fsync data loss after append write"
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Looks good to me. Tested on ext2/3/4 xfs and btrfs, btrfs fails the
test, and _notrun on ext2, as expected.

Reviewed-by: Eryu Guan <eguan@redhat.com>

> ---
>  tests/generic/090     | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/090.out |  17 ++++++++
>  tests/generic/group   |   1 +
>  3 files changed, 126 insertions(+)
>  create mode 100755 tests/generic/090
>  create mode 100644 tests/generic/090.out
> 
> diff --git a/tests/generic/090 b/tests/generic/090
> new file mode 100755
> index 0000000..a1f2b89
> --- /dev/null
> +++ b/tests/generic/090
> @@ -0,0 +1,108 @@
> +#! /bin/bash
> +# FS QA Test No. 090
> +#
> +# Test that after syncing the filesystem, adding a hard link to a file,
> +# syncing the filesystem again, doing a write to the file that increases
> +# its size and then doing a fsync against that file, durably persists the
> +# data written to the file. That is, after log/journal replay, the data
> +# is available.
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
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_need_to_be_root
> +_require_scratch
> +_require_dm_flakey
> +_require_metadata_journaling $SCRATCH_DEV
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_init_flakey
> +_mount_flakey
> +
> +# Create the test file with some initial data and then fsync it.
> +# The fsync here is only needed to trigger the issue in btrfs, as it causes the
> +# the flag BTRFS_INODE_NEEDS_FULL_SYNC to be removed from the btrfs inode.
> +$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 32k" \
> +		-c "fsync" \
> +		$SCRATCH_MNT/foo | _filter_xfs_io
> +sync
> +
> +# Add a hard link to our file.
> +# On btrfs this sets the flag BTRFS_INODE_COPY_EVERYTHING on the btrfs inode,
> +# which is a necessary condition to trigger the issue.
> +ln $SCRATCH_MNT/foo $SCRATCH_MNT/bar
> +
> +# Sync the filesystem to force a commit of the current btrfs transaction, this
> +# is a necessary condition to trigger the bug on btrfs.
> +sync
> +
> +# Now append more data to our file, increasing its size, and fsync the file.
> +# In btrfs because the inode flag BTRFS_INODE_COPY_EVERYTHING was set and the
> +# write path did not update the inode item in the btree nor the delayed inode
> +# item (in memory structure) in the current transaction (created by the fsync
> +# handler), the fsync did not record the inode's new i_size in the fsync
> +# log/journal. This made the data unavailable after the fsync log/journal is
> +# replayed.
> +$XFS_IO_PROG -c "pwrite -S 0xbb 32K 32K" \
> +		-c "fsync" \
> +		$SCRATCH_MNT/foo | _filter_xfs_io
> +
> +echo "File content after fsync and before crash:"
> +od -t x1 $SCRATCH_MNT/foo
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
> +status=0
> +exit
> diff --git a/tests/generic/090.out b/tests/generic/090.out
> new file mode 100644
> index 0000000..4a4423a
> --- /dev/null
> +++ b/tests/generic/090.out
> @@ -0,0 +1,17 @@
> +QA output created by 090
> +wrote 32768/32768 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 32768/32768 bytes at offset 32768
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +File content after fsync and before crash:
> +0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
> +*
> +0100000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
> +*
> +0200000
> +File content after crash and log replay:
> +0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
> +*
> +0100000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
> +*
> +0200000
> diff --git a/tests/generic/group b/tests/generic/group
> index 0c8964c..ae40fed 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -92,6 +92,7 @@
>  087 perms auto quick
>  088 perms auto quick
>  089 metadata auto
> +090 metadata auto quick
>  091 rw auto quick
>  092 auto quick prealloc
>  093 attr cap udf auto
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
