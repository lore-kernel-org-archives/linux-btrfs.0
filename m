Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:26556 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755162AbcB1WjV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 17:39:21 -0500
Date: Mon, 29 Feb 2016 09:39:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 4/5] fstests: btrfs: Add per inode dedup flag
 test
Message-ID: <20160228223917.GC29057@dastard>
References: <1456301196-15874-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1456301196-15874-5-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456301196-15874-5-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2016 at 04:06:35PM +0800, Qu Wenruo wrote:
> +# File size is twice the maximum file extent of btrfs
> +# So even fallbacked to non-dedup, it will have at least 2 extents
> +file_size=$(( 256 * 1024 * 1024 ))
> +dedup_bs=$(( 64 * 1024 ))

256m, 64k.

> +_scratch_mkfs "-O dedup" >> $seqres.full 2>&1
> +_scratch_mount
> +
> +# Return 0 for not deduped at all , return 1 for part or full deduped
> +test_file_deduped () {
> +	file=$1
> +

echo -n "$file: "

> +	nr_uniq_extents=$(_uniq_extent_count $file)
> +	nr_total_extents=$(_extent_count $file)
> +
> +	if [ $nr_uniq_extents -eq $nr_total_extents ]; then
> +		echo "not de-duplicated"
> +	else
> +		echo "de-duplicated"
> +	fi

> +}
> +
> +dedup_write_file () {
> +	file=$1
> +	size=$2
> +
> +	$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $size" $file | _filter_xfs_io
> +}
> +
> +print_result () {
> +	file=$1
> +
> +	echo "$(basename $file): $(test_file_deduped $file)"
> +}
> +_run_btrfs_util_prog dedup enable -b $dedup_bs $SCRATCH_MNT
> +touch $SCRATCH_MNT/dedup_file
> +touch $SCRATCH_MNT/no_dedup_file
> +mkdir $SCRATCH_MNT/dedup_dir
> +mkdir $SCRATCH_MNT/no_dedup_dir
> +
> +_run_btrfs_util_prog property set $SCRATCH_MNT/no_dedup_file dedup disable
> +_run_btrfs_util_prog property set $SCRATCH_MNT/no_dedup_dir dedup disable
> +
> +dedup_write_file $SCRATCH_MNT/tmp $dedup_bs

Just call xfs_io directly - wrapper is not necessary for a single
line command.

> +# sync to ensure hash is added to dedup tree
> +sync
> +
> +dedup_write_file $SCRATCH_MNT/dedup_file $file_size
> +dedup_write_file $SCRATCH_MNT/no_dedup_file $file_size
> +dedup_write_file $SCRATCH_MNT/dedup_dir/dedup_dir_default_file $file_size
> +dedup_write_file $SCRATCH_MNT/no_dedup_dir/no_dedup_dir_default_file $file_size
> +
> +print_result $SCRATCH_MNT/dedup_file

test_file_deduped $SCRATCH_MNT/dedup_file | _filter_scratch

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
