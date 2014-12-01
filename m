Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:19693 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbaLAFZW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 00:25:22 -0500
Date: Mon, 1 Dec 2014 16:25:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Filipe Manana <fdmanana@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: add btrfs test to stress chunk
 allocation/removal and fstrim
Message-ID: <20141201052507.GK16151@dastard>
References: <1417015839-26985-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417015839-26985-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 26, 2014 at 03:30:39PM +0000, Filipe Manana wrote:
> Stress btrfs' block group allocation and deallocation while running
> fstrim in parallel. Part of the goal is also to get data block groups
> deallocated so that new metadata block groups, using the same physical
> device space ranges, get allocated while fstrim is running. This caused
> several issues ranging from invalid memory accesses, kernel crashes,
> metadata or data corruption, free space cache inconsistencies and free
> space leaks.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

There's nothing btrfs specific about this test. Pleas emake it
generic.

....

> +
> +# real QA test starts here
> +_need_to_be_root
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch_nocheck
> +_require_fstrim
> +
> +rm -f $seqres.full

# needs 40GB of space in the filesystem
_scratch_mkfs
_require_fs_space $SCRATCH_MNT $((40 * 1024 * 1024))	

However, does it really need 40GB? It needs 2GB for the large alloc,
and then 400,000 * 4k is only 1.6GB. So This would fit in a 10GB
filesystem without a problem, right? And if it's a generic test,
keeping it under 10GB would mean it runs on the majority of
filesystem developers test VMs, small or large....


> +# Create a bunch of small files that get their single extent inlined in the
> +# btree, so that we consume a lot of metadata space and get a chance of a
> +# data block group getting deleted and reused for metadata later. Sometimes
> +# the creation of all these files succeeds other times we get ENOSPC failures
> +# at some point - this depends on how fast the btrfs' cleaner kthread is
> +# notified about empty block groups, how fast it deletes them and how fast
> +# the fallocate calls happen. So we don't really care if they all succeed or
> +# not, the goal is just to keep metadata space usage growing while data block
> +# groups are deleted.
> +create_files()
> +{
> +	local prefix=$1
> +
> +	for ((i = 1; i <= 400000; i++)); do
> +		echo "Creating file ${prefix}_$i" >>$seqres.full 2>&1
> +		$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 3900" \
> +			$SCRATCH_MNT/"${prefix}_$i" >>$seqres.full 2>&1

You don't need to echo 400,000 file creates to $seqres.full.

This is one of those times that directing output to /dev/null makes
sense, especially as:

> +		ret=$?
> +		if [ $ret -ne 0 ]; then
> +			break
> +		fi

you can do this:

		if [ $? -ne 0 ]; then
			echo "failed creating file $prefix.$i" >> $seqres.full
			break
		fi

> +	done
> +
> +}
> +
> +fsz=`expr 40 \* 1024 \* 1024 \* 1024`
> +_scratch_mkfs_sized $fsz >>$seqres.full 2>&1 || \
> +	_fail "size=$fsz mkfs failed"
> +_scratch_mount
> +
> +for ((i = 0; i < 4; i++)); do
> +	trim_loop &
> +	trim_pids[$i]=$!
> +done
> +
> +fallocate_loop "falloc_file" &
> +fallocate_pid=$!
> +
> +create_files "foobar"
> +
> +kill $fallocate_pid
> +kill ${trim_pids[@]}
> +wait
> +
> +# Sleep a bit, otherwise umount fails often with EBUSY (TODO: investigate why).
> +sleep 3
> +
> +# Check for fs consistency. The trimming was racy and caused some btree nodes
> +# to get full of zeroes on disk, which obviously caused fs metadata corruption.
> +# The race often lead to missing free space entries in a block group's free
> +# space cache too.
> +_check_scratch_fs

Ummm, if you just use _require_scratch, you don't need to do this.
The test harness will check it for you.

> index e79b848..6608005 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -84,3 +84,4 @@
>  079 auto
>  080 auto
>  081 auto quick
> +082 auto

I'd suggest that for a generic test we'd want to add the stress
group to this, and allow the test to be scaled in terms of
filesystem size and the number of concurrent trim and fallocate
loops by $LOAD_FACTOR....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
