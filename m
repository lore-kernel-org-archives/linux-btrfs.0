Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:54684 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175AbcBIIPu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 03:15:50 -0500
Date: Tue, 9 Feb 2016 19:15:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 18/23] xfs: test the automatic cowextsize extent garbage
 collector
Message-ID: <20160209081547.GN19486@dastard>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
 <20160209011342.23099.23019.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160209011342.23099.23019.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 08, 2016 at 05:13:42PM -0800, Darrick J. Wong wrote:
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> +
> +_cleanup()
> +{
> +    cd /
> +    echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
> +    #rm -rf "$tmp".* "$testdir"

uncomment.

> +echo "CoW and leave leftovers"
> +echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
> +seq 2 2 $((nr - 1)) | while read f; do
> +	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * f)) 1" "$testdir/file2" >> "$seqres.full"
> +	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * f)) 1" "$testdir/file2.chk" >> "$seqres.full"
> +done

Ok, I just realised what was bugging me about these loops: "f" is
not a typical loop iterator for a count. Normally we'd use "i" for
these....

> +echo "old extents: $old_extents" >> "$seqres.full"
> +echo "new extents: $new_extents" >> "$seqres.full"
> +echo "maximum extents: $internal_blks" >> "$seqres.full"
> +test $new_extents -lt $((internal_blks / 7)) || _fail "file2 badly fragmented"

I wouldn't use _fail like this, echo is sufficient to cause the test
to fail.

> +echo "Check for damage"
> +umount "$SCRATCH_MNT"
> +
> +# success, all done
> +status=0
> +exit

As would getting rid of the unmount and just setting status
appropriately...

/repeat

-Dave.
-- 
Dave Chinner
david@fromorbit.com
