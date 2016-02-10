Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18844 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbcBJBGl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 20:06:41 -0500
Date: Tue, 9 Feb 2016 17:06:31 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 18/23] xfs: test the automatic cowextsize extent garbage
 collector
Message-ID: <20160210010631.GG6350@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
 <20160209011342.23099.23019.stgit@birch.djwong.org>
 <20160209081547.GN19486@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160209081547.GN19486@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 09, 2016 at 07:15:47PM +1100, Dave Chinner wrote:
> On Mon, Feb 08, 2016 at 05:13:42PM -0800, Darrick J. Wong wrote:
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > +
> > +_cleanup()
> > +{
> > +    cd /
> > +    echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
> > +    #rm -rf "$tmp".* "$testdir"
> 
> uncomment.
> 
> > +echo "CoW and leave leftovers"
> > +echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
> > +seq 2 2 $((nr - 1)) | while read f; do
> > +	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * f)) 1" "$testdir/file2" >> "$seqres.full"
> > +	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * f)) 1" "$testdir/file2.chk" >> "$seqres.full"
> > +done
> 
> Ok, I just realised what was bugging me about these loops: "f" is
> not a typical loop iterator for a count. Normally we'd use "i" for
> these....
> 
> > +echo "old extents: $old_extents" >> "$seqres.full"
> > +echo "new extents: $new_extents" >> "$seqres.full"
> > +echo "maximum extents: $internal_blks" >> "$seqres.full"
> > +test $new_extents -lt $((internal_blks / 7)) || _fail "file2 badly fragmented"
> 
> I wouldn't use _fail like this, echo is sufficient to cause the test
> to fail.

Ok, fixed.

--D

> > +echo "Check for damage"
> > +umount "$SCRATCH_MNT"
> > +
> > +# success, all done
> > +status=0
> > +exit
> 
> As would getting rid of the unmount and just setting status
> appropriately...
> 
> /repeat
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
