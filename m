Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18708 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754305AbcHSVyE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 17:54:04 -0400
Date: Fri, 19 Aug 2016 14:53:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 13/17] xfs: test swapext with reflink
Message-ID: <20160819215354.GA15174@birch.djwong.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
 <146914485888.11762.1688573359701830686.stgit@birch.djwong.org>
 <20160808081359.GB27776@eguan.usersys.redhat.com>
 <20160808174132.GC11291@birch.djwong.org>
 <20160809062943.GF19025@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160809062943.GF19025@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 09, 2016 at 04:29:43PM +1000, Dave Chinner wrote:
> On Mon, Aug 08, 2016 at 10:41:32AM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 08, 2016 at 04:13:59PM +0800, Eryu Guan wrote:
> > > On Thu, Jul 21, 2016 at 04:47:38PM -0700, Darrick J. Wong wrote:
> > > > Add a few tests to stress the new swapext code for reflink and rmap.
> > > > +_reflink_range "$testdir/file1" 0 "$testdir/file2" 0 $bytes >> "$seqres.full"
> > > > +
> > > > +echo "Defrag the big file"
> > > > +old_nextents=$(xfs_io -c 'stat -v' $testdir/file1 | grep 'nextents' | cut -d ' ' -f 3)
> > > 
> > > There's a "_count_extents" helper, does that work for this case?
> > 
> > It can, though stat -v reports GETFSXATTR results, which should be faster than
> > _count_extents because the latter FIEMAPs the entire file and counts lines.
> > Seeing as XFS records the extent count in the inode, we might as well use it.
> 
> perhaps put a special xfs case in _count_extents() that does this
> rather than FIEMAP?

Ok.  Seems simple enough to do.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
