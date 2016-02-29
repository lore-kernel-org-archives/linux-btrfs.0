Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30333 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753024AbcB2CEn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 21:04:43 -0500
Subject: Re: [PATCH v2 RESEND 2/5] fstests: btrfs: Add basic test for btrfs
 in-band de-duplication
To: Dave Chinner <david@fromorbit.com>
References: <1456301196-15874-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1456301196-15874-3-git-send-email-quwenruo@cn.fujitsu.com>
 <20160228222627.GA29057@dastard>
CC: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56D3A733.7010608@cn.fujitsu.com>
Date: Mon, 29 Feb 2016 10:04:35 +0800
MIME-Version: 1.0
In-Reply-To: <20160228222627.GA29057@dastard>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dave,

Thanks for the review.

All comment are correct and I'll update the patchset soon.

Only one small question below

Dave Chinner wrote on 2016/02/29 09:26 +1100:
...
>> +# File size is twice the maximum file extent of btrfs
>> +# So even fallbacked to non-dedup, it will have at least 2 extents
>> +file_size=$(( 256 * 1024 * 1024 ))
>
> Used for xfs_io, so "file_size=256m" is all that is needed here.

Super nice feature for support unit suffix, I checked man page of xfs_io 
but only value for extsize mentioned the support for such suffix.

I assume all offset/length/bsize/value support suffix, right?
Hope man page get updated.

Thanks,
Qu
>
>> +_scratch_mkfs "-O dedup" >> $seqres.full 2>&1
>> +_scratch_mount
>> +
>> +do_dedup_test()
>> +{
>> +	backend=$1
>> +	dedup_bs=$2
>> +
>> +	_run_btrfs_util_prog dedup enable -s $backend -b $dedup_bs $SCRATCH_MNT
>> +	$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $dedup_bs" \
>> +		$SCRATCH_MNT/initial_block | _filter_xfs_io
>> +
>> +	# sync to ensure dedup hash is added into dedup pool
>> +	sync
>
> xfs_io -fs  or xfs_io ... -c "fsync" ... ?
>
>> +	$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $file_size" \
>> +		$SCRATCH_MNT/real_file | _filter_xfs_io
>> +	# sync again to ensure data are all written to disk and
>> +	# we can get stable extent map
>> +	sync
>
> Again, why now just do a sync write or fsync from the xfs?
>
>> +
>> +	# Test if real_file is de-duplicated
>> +	nr_uniq_extents=$(_uniq_extent_count $SCRATCH_MNT/real_file)
>> +	nr_total_extents=$(_extent_count $SCRATCH_MNT/real_file)
>> +
>> +	echo "uniq/total: $nr_uniq_extents/$nr_total_extents" >> $seqres.full
>> +	# Allow a small amount of dedup miss, as commit interval or
>> +	# memory pressure may break a dedup_bs block and cause
>> +	# smalll extent which won't go through dedup routine
>> +	if [ $nr_uniq_extents -ge $(( $nr_total_extents * 5 / 100 )) ]; then
>> +		echo "Too high dedup failure rate"
>> +	fi
>
> _within_tolerance
>
>> +
>> +	# Also check the md5sum to ensure data is not corrupted
>> +	md5=$(_md5_checksum $SCRATCH_MNT/real_file)
>> +	if [ $md5 != $init_md5 ]; then
>> +		echo "File after in-band de-duplication is corrupted"
>> +	fi
>
> Nope. Just echo the md5sum to the golden output file.
>
>
>> +}
>> +
>> +# Create the initial file and calculate its checksum without dedup
>> +$XFS_IO_PROG -f -c "pwrite 0 $file_size" $SCRATCH_MNT/csum_file | \
>> +	_filter_xfs_io
>> +init_md5=$(_md5_checksum $SCRATCH_MNT/csum_file)
>> +echo "md5 of the initial file is $init_md5" >> $seqres.full
>
> Just echo the md5sum to the golden output file.
>
> Cheers,
>
> Dave.
>


