Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:6349 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647AbaKJBrh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Nov 2014 20:47:37 -0500
Date: Mon, 10 Nov 2014 12:47:33 +1100
From: Dave Chinner <david@fromorbit.com>
To: Filipe Manana <fdmanana@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs, add regression test for clone ioctl
Message-ID: <20141110014733.GO28565@dastard>
References: <1413924191-30467-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413924191-30467-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs folks, review please...

.....

On Tue, Oct 21, 2014 at 09:43:11PM +0100, Filipe Manana wrote:
> Regression test for a btrfs clone ioctl issue where races between
> a clone operation and concurrent target file reads would result in
> leaving stale data in the page cache. After the clone operation
> finished, reading from the clone target file would return the old
> and no longer valid data. This affected only buffered reads (i.e.
> didn't affect direct IO reads).
> 
> This issue was fixed by the following linux kernel patch:
> 
>     Btrfs: ensure readers see new data after a clone operation
>     (commit c125b8bff1d9f6c8c91ce4eb8bd5616058c7d510)
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  tests/btrfs/081     | 131 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/081.out |   4 ++
>  tests/btrfs/group   |   1 +
>  3 files changed, 136 insertions(+)
>  create mode 100755 tests/btrfs/081
>  create mode 100644 tests/btrfs/081.out
> 
> diff --git a/tests/btrfs/081 b/tests/btrfs/081
> new file mode 100755
> index 0000000..d2e3767
> --- /dev/null
> +++ b/tests/btrfs/081
> @@ -0,0 +1,131 @@
> +#! /bin/bash
> +# FSQA Test No. 081
> +#
> +# Regression test for a btrfs clone ioctl issue where races between
> +# a clone operation and concurrent target file reads would result in
> +# leaving stale data in the page cache. After the clone operation
> +# finished, reading from the clone target file would return the old
> +# and no longer valid data. This affected only buffered reads (i.e.
> +# didn't affect direct IO reads).
> +#
> +# This issue was fixed by the following linux kernel patch:
> +#
> +#     Btrfs: ensure readers see new data after a clone operation
> +#     (commit c125b8bff1d9f6c8c91ce4eb8bd5616058c7d510)
> +#
> +#-----------------------------------------------------------------------
> +#
> +# Copyright (C) 2014 SUSE Linux Products GmbH. All Rights Reserved.
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
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_need_to_be_root
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_btrfs_cloner
> +
> +rm -f $seqres.full
> +
> +num_extents=100
> +extent_size=8192
> +
> +create_source_file()
> +{
> +	name=$1
> +
> +	# Create a file with $num_extents extents, each with a size of
> +	# $extent_size bytes.
> +	touch $SCRATCH_MNT/$name
> +	for ((i = 0; i < $num_extents; i++)); do
> +		off=$((i * $extent_size))
> +		run_check $XFS_IO_PROG \
> +			-c "pwrite -S $i -b $extent_size $off $extent_size" \
> +			-c "fsync" $SCRATCH_MNT/$name

xfs_io dumps errors into the output file and that causes failures.
there is no need to use run_check here.

-Dave.
> +	done
> +}
> +
> +create_target_file()
> +{
> +	name=$1
> +	file_size=$(($num_extents * $extent_size))
> +
> +	run_check $XFS_IO_PROG -f -c "pwrite -S 0xff 0 $file_size" \
> +		-c "fsync" $SCRATCH_MNT/$name
> +}
> +
> +reader_loop()
> +{
> +	name=$1
> +
> +	while true; do
> +		cat $SCRATCH_MNT/$name > /dev/null
> +	done
> +}
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +create_source_file "foo"
> +create_target_file "bar"
> +
> +reader_loop "bar" &
> +reader_pid=$!
> +
> +$CLONER_PROG -s 0 -d 0 -l $(($num_extents * $extent_size)) \
> +	$SCRATCH_MNT/foo $SCRATCH_MNT/bar
> +
> +kill $reader_pid > /dev/null 2>&1
> +
> +# Now both foo and bar should have exactly the same content.
> +# This didn't use to be the case before the btrfs kernel fix mentioned
> +# above. The clone ioctl was racy, as it removed bar's pages from the
> +# page cache and only after it would update bar's metadata to point to
> +# the same extents that foo's metadata points to - and this was done in
> +# an unprotected way, so that a file read request done right after the
> +# clone ioctl removed the pages from the page cache and before it updated
> +# bar's metadata, would result in populating the page cache with stale
> +# data. Therefore a file read after the clone operation finished would
> +# not get the cloned data but it would get instead the old and no longer
> +# valid data.
> +md5sum $SCRATCH_MNT/foo | _filter_scratch
> +md5sum $SCRATCH_MNT/bar | _filter_scratch
> +
> +# Validate the content of bar still matches foo's content even after
> +# clearing all of bar's data from the page cache.
> +_scratch_remount
> +md5sum $SCRATCH_MNT/bar | _filter_scratch
> +
> +status=0
> +exit
> diff --git a/tests/btrfs/081.out b/tests/btrfs/081.out
> new file mode 100644
> index 0000000..3c7c3d2
> --- /dev/null
> +++ b/tests/btrfs/081.out
> @@ -0,0 +1,4 @@
> +QA output created by 081
> +14968c092c68e32fa35e776392d14523  SCRATCH_MNT/foo
> +14968c092c68e32fa35e776392d14523  SCRATCH_MNT/bar
> +14968c092c68e32fa35e776392d14523  SCRATCH_MNT/bar
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 801fc73..fc60c63 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -82,3 +82,4 @@
>  077 auto quick
>  078 auto
>  080 auto
> +081 auto quick
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Dave Chinner
david@fromorbit.com
