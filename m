Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:53412 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbcB1W0c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 17:26:32 -0500
Date: Mon, 29 Feb 2016 09:26:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 2/5] fstests: btrfs: Add basic test for btrfs
 in-band de-duplication
Message-ID: <20160228222627.GA29057@dastard>
References: <1456301196-15874-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1456301196-15874-3-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456301196-15874-3-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2016 at 04:06:33PM +0800, Qu Wenruo wrote:
> Add basic test for btrfs in-band de-duplication, including:
> 1) Enable
> 2) Re-enable
> 3) On disk extents are refering to same bytenr
> 4) Disable
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  common/defrag       |   8 ++++
>  tests/btrfs/200     | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/200.out |  19 ++++++++
>  tests/btrfs/group   |   1 +
>  4 files changed, 153 insertions(+)
>  create mode 100755 tests/btrfs/200
>  create mode 100644 tests/btrfs/200.out
> 
> diff --git a/common/defrag b/common/defrag
> index 942593e..34cc822 100644
> --- a/common/defrag
> +++ b/common/defrag
> @@ -47,6 +47,14 @@ _extent_count()
>  	$XFS_IO_PROG -c "fiemap" $1 | tail -n +2 | grep -v hole | wc -l| $AWK_PROG '{print $1}'
>  }
>  
> +_uniq_extent_count()
> +{
> +	file=$1
> +	$XFS_IO_PROG -c "fiemap" $file >> $seqres.full 2>&1
> +	$XFS_IO_PROG -c "fiemap" $file | tail -n +2 | grep -v hole |\
> +		$AWK_PROG '{print $3}' | sort | uniq | wc -l
> +}

This needs comments ot explain how it is different to _extent_count.
Also should probably be named _extent_count_unique()

> +
>  	min=$1
> diff --git a/tests/btrfs/200 b/tests/btrfs/200
> new file mode 100755
> index 0000000..f2ff542
> --- /dev/null
> +++ b/tests/btrfs/200
> @@ -0,0 +1,125 @@
> +#! /bin/bash
> +# FS QA Test 200
> +#
> +# Basic btrfs inband dedup test, including:
> +# 1) Enable
> +# 2) Uniq file extent number
        Unique.

> +# 3) Re-enable
> +# 4) Disable

I don't understand what 2-4 are describing. As a test summary,
"Basic btrfs inband dedup test" is sufficient.

> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_btrfs_subcommand dedup
> +_require_btrfs_fs_feature dedup
> +_require_btrfs_mkfs_feature dedup

> +
> +# File size is twice the maximum file extent of btrfs
> +# So even fallbacked to non-dedup, it will have at least 2 extents
> +file_size=$(( 256 * 1024 * 1024 ))

Used for xfs_io, so "file_size=256m" is all that is needed here.

> +_scratch_mkfs "-O dedup" >> $seqres.full 2>&1
> +_scratch_mount
> +
> +do_dedup_test()
> +{
> +	backend=$1
> +	dedup_bs=$2
> +
> +	_run_btrfs_util_prog dedup enable -s $backend -b $dedup_bs $SCRATCH_MNT
> +	$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $dedup_bs" \
> +		$SCRATCH_MNT/initial_block | _filter_xfs_io
> +
> +	# sync to ensure dedup hash is added into dedup pool
> +	sync

xfs_io -fs  or xfs_io ... -c "fsync" ... ?

> +	$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $file_size" \
> +		$SCRATCH_MNT/real_file | _filter_xfs_io
> +	# sync again to ensure data are all written to disk and
> +	# we can get stable extent map
> +	sync

Again, why now just do a sync write or fsync from the xfs?

> +
> +	# Test if real_file is de-duplicated
> +	nr_uniq_extents=$(_uniq_extent_count $SCRATCH_MNT/real_file)
> +	nr_total_extents=$(_extent_count $SCRATCH_MNT/real_file)
> +
> +	echo "uniq/total: $nr_uniq_extents/$nr_total_extents" >> $seqres.full
> +	# Allow a small amount of dedup miss, as commit interval or
> +	# memory pressure may break a dedup_bs block and cause
> +	# smalll extent which won't go through dedup routine
> +	if [ $nr_uniq_extents -ge $(( $nr_total_extents * 5 / 100 )) ]; then
> +		echo "Too high dedup failure rate"
> +	fi

_within_tolerance

> +
> +	# Also check the md5sum to ensure data is not corrupted
> +	md5=$(_md5_checksum $SCRATCH_MNT/real_file)
> +	if [ $md5 != $init_md5 ]; then
> +		echo "File after in-band de-duplication is corrupted"
> +	fi

Nope. Just echo the md5sum to the golden output file.


> +}
> +
> +# Create the initial file and calculate its checksum without dedup
> +$XFS_IO_PROG -f -c "pwrite 0 $file_size" $SCRATCH_MNT/csum_file | \
> +	_filter_xfs_io
> +init_md5=$(_md5_checksum $SCRATCH_MNT/csum_file)
> +echo "md5 of the initial file is $init_md5" >> $seqres.full

Just echo the md5sum to the golden output file.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
