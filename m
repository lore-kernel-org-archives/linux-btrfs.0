Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:3240 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932162AbcCODj4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 23:39:56 -0400
Date: Tue, 15 Mar 2016 14:39:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] fstest: btrfs: test single 4k extent after
 subpagesize buffered writes
Message-ID: <20160315033941.GE30721@dastard>
References: <1457394467-1245-1-git-send-email-bo.li.liu@oracle.com>
 <1457396879-30572-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457396879-30572-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 07, 2016 at 04:27:59PM -0800, Liu Bo wrote:
> This is to test if COW enabled btrfs can end up with single 4k extents
> when doing subpagesize buffered writes.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
....
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +
> +default_expire=`cat /proc/sys/vm/dirty_expire_centisecs`
> +echo 50 > /proc/sys/vm/dirty_expire_centisecs

why?

> +tfile=$SCRATCH_MNT/testfile
> +
> +PAGE_SIZE=$(get_page_size)
> +SUBLEN=$((RANDOM % PAGE_SIZE))

local variables are lower case.

> +$XFS_IO_PROG -f -c "pwrite 0 $PAGE_SIZE" $tfile > /dev/null 2>&1
> +$XFS_IO_PROG -c "pwrite $PAGE_SIZE $SUBLEN" $tfile > /dev/null 2>&1
> +
> +toff=$((PAGE_SIZE + SUBLEN))
> +for ((i=0; i<10000; i++))
> +do

# Add comment on what the loop is trying to do to the layout of the
# file being written.
for ((i = 0; i < 10000; i++)); do

> +	tlen=$PAGE_SIZE
> +	if [ $((i % 2)) = 0 ]; then
> +		tlen=$((PAGE_SIZE * 3))
> +	fi
> +	if [ $((i % 1000)) = 0 ]; then
> +		tlen=$((RANDOM % PAGE_SIZE))
> +	fi
> +
> +	$XFS_IO_PROG -c "pwrite $toff $tlen" $tfile > /dev/null 2>&1
> +	toff=$((toff + tlen))
> +done
> +
> +sync
> +
> +# check for single PAGESIZE extent
> +$XFS_IO_PROG -c "fiemap -v" $tfile >> $seqres.full 2>&1
> +$XFS_IO_PROG -c "fiemap -v" $tfile | awk '{if ($4 == 8) print $4}'

Assumes page size is 4k. Also assumes that no individual extent in
the file is 4k. Likely broken.

> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/027.out b/tests/btrfs/027.out
> new file mode 100644
> index 0000000..e8291ab
> --- /dev/null
> +++ b/tests/btrfs/027.out
> @@ -0,0 +1 @@
> +QA output created by 027

So are we expecting no output or not?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
