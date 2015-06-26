Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbbFZGtj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jun 2015 02:49:39 -0400
Date: Fri, 26 Jun 2015 14:49:36 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: generic test for fsync after file truncations
Message-ID: <20150626064936.GH1210@dhcp-13-216.nay.redhat.com>
References: <1435202295-23619-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435202295-23619-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 25, 2015 at 04:18:15AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that if we truncate a file to a smaller size, then truncate it to
> its original size or a larger size, then fsyncing it and a power failure
> happens, the file will have the range [first_truncate_size, last_size[
> with all bytes having a value of 0x00 if we read it the next time the
> filesystem is mounted.
> 
> This test is motivated by a bug found in btrfs, which is fixed by a patch
> titled: "Btrfs: fix fsync after truncate when no_holes feature is enabled"
> 
> Tested against ext3/4, xfs, btrfs (with and without the fix, and with the
> no_holes feature disabled), f2fs, reiserfs and nilfs2.
> 
> All filesystems pass the test except for unpatched btrfs with the
> no_holes feature enabled (as expected) and f2fs. Both produce the
> following file contents that differ from the golden output:
> 
>   File foo content after log replay:
>   0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
>   *
>   0200000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
>   *
>   0372000
>   File bar content after log replay:
>   0000000 ee ee ee ee ee ee ee ee ee ee ee ee ee ee ee ee
>   *
>   0200000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>   *
>   0372000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   *
>   0772000
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  tests/generic/095     | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/095.out |  19 +++++++++
>  tests/generic/group   |   1 +
>  3 files changed, 136 insertions(+)
>  create mode 100755 tests/generic/095
>  create mode 100644 tests/generic/095.out
> 
> diff --git a/tests/generic/095 b/tests/generic/095
> new file mode 100755
> index 0000000..bfd4112
> --- /dev/null
> +++ b/tests/generic/095
> @@ -0,0 +1,116 @@
> +#! /bin/bash
> +# FSQA Test No. 095
> +#
> +# Test that if we truncate a file to a smaller size, then truncate it to its
> +# original size or a larger size, then fsyncing it and a power failure happens,
> +# the file will have the range [first_truncate_size, last_size[ with all bytes
> +# having a value of 0x00 if we read it the next time the filesystem is mounted.
> +#
> +# This test is motivated by a bug found in btrfs.
> +#
> +#-----------------------------------------------------------------------
> +#
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
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	_cleanup_flakey
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmflakey
> +
> +# real QA test starts here
> +_need_to_be_root
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_require_dm_flakey

Need _require_metadata_journaling here.

Otherwise looks good to me. Adding _require_metadata_journaling then

Reviewed-by: Eryu Guan <eguan@redhat.com>

> +
> +# This test was motivated by an issue found in btrfs when the btrfs no-holes
> +# feature is enabled (introduced in kernel 3.14). So enable the feature if the
> +# fs being tested is btrfs.
> +if [ $FSTYP == "btrfs" ]; then
> +	_require_btrfs_fs_feature "no_holes"
> +	_require_btrfs_mkfs_feature "no-holes"
> +	MKFS_OPTIONS="$MKFS_OPTIONS -O no-holes"
> +fi
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_init_flakey
> +_mount_flakey
> +
> +# Create our test files and make sure everything is durably persisted.
> +$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 64K"         \
> +		-c "pwrite -S 0xbb 64K 61K"       \
> +		$SCRATCH_MNT/foo | _filter_xfs_io
> +$XFS_IO_PROG -f -c "pwrite -S 0xee 0 64K"         \
> +		-c "pwrite -S 0xff 64K 61K"       \
> +		$SCRATCH_MNT/bar | _filter_xfs_io
> +sync
> +
> +# Now truncate our file foo to a smaller size (64Kb) and then truncate it to the
> +# size it had before the shrinking truncate (125Kb). Then fsync our file. If a
> +# power failure happens after the fsync, we expect our file to have a size of
> +# 125Kb, with the first 64Kb of data having the value 0xaa and the second 61Kb
> +# of data having the value 0x00.
> +$XFS_IO_PROG -c "truncate 64K" \
> +		-c "truncate 125K" \
> +		-c "fsync" \
> +		$SCRATCH_MNT/foo
> +
> +# Do something similar to our file bar, but the first truncation sets the file
> +# size to 0 and the second truncation expands the size to the double of what it
> +# was initially.
> +$XFS_IO_PROG -c "truncate 0" \
> +		-c "truncate 253K" \
> +		-c "fsync" \
> +		$SCRATCH_MNT/bar
> +
> +_load_flakey_table $FLAKEY_DROP_WRITES
> +_unmount_flakey
> +
> +# Allow writes again, mount to trigger log replay and validate file contents.
> +_load_flakey_table $FLAKEY_ALLOW_WRITES
> +_mount_flakey
> +
> +# We expect foo to have a size of 125Kb, the first 64Kb of data all having the
> +# value 0xaa and the remaining 61Kb to be a hole (all bytes with value 0x00).
> +echo "File foo content after log replay:"
> +od -t x1 $SCRATCH_MNT/foo
> +
> +# We expect bar to have a size of 253Kb and no extents (any byte read from bar
> +# has the value 0x00).
> +echo "File bar content after log replay:"
> +od -t x1 $SCRATCH_MNT/bar
> +
> +status=0
> +exit
> diff --git a/tests/generic/095.out b/tests/generic/095.out
> new file mode 100644
> index 0000000..89586fe
> --- /dev/null
> +++ b/tests/generic/095.out
> @@ -0,0 +1,19 @@
> +QA output created by 095
> +wrote 65536/65536 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 62464/62464 bytes at offset 65536
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 65536/65536 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 62464/62464 bytes at offset 65536
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +File foo content after log replay:
> +0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
> +*
> +0200000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> +*
> +0372000
> +File bar content after log replay:
> +0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> +*
> +0772000
> diff --git a/tests/generic/group b/tests/generic/group
> index c14ddb9..1f1a0b0 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -97,6 +97,7 @@
>  092 auto quick prealloc
>  093 attr cap udf auto
>  094 auto quick metadata
> +095 auto quick metadata
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
