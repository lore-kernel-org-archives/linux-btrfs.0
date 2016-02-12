Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:21652 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbcBLWtg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 17:49:36 -0500
Date: Sat, 13 Feb 2016 09:49:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 12/32] dio: unwritten conversion bug tests
Message-ID: <20160212224932.GZ14668@dastard>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
 <20160211234037.2202.93885.stgit@birch.djwong.org>
 <20160212035253.GX14668@dastard>
 <20160212152231.GA7928@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160212152231.GA7928@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 12, 2016 at 10:22:31AM -0500, Theodore Ts'o wrote:
> On Fri, Feb 12, 2016 at 02:52:53PM +1100, Dave Chinner wrote:
> > On Thu, Feb 11, 2016 at 03:40:37PM -0800, Darrick J. Wong wrote:
> > > Check that we don't expose old disk contents when a directio write to
> > > an unwritten extent fails due to IO errors.  This primarily affects
> > > XFS and ext4.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > aiocp.c: In function 'main':
> > aiocp.c:407:1: warning: format '%d' expects argument of type 'int', but argument 3 has type 'off_t' [-Wformat=]
> >  printf("tocopy=%d len=%d blk=%d\n", tocopy, length, aio_blksize);
> >  ^
> > 
> > Followup patch is fine, I'll commit as is.
> 
> Dave, given that Darrick's patches is going to cause more
> _scratch_mount occurences, how quickly do you plan to commit his
> patchset?  Should I wait until he makes his change before I do the
> s/_scratch_mount/_scratch_cycle_mount/ change?  Should I make that
> change, and let you fix it up the commit?

I had to head out suddenly yestrday afternoon, just after I sent
above email. Only just got back in front of the computer, so I'll be
pushing it out once the new pull has run through a sanity check.

If you can respin the patch once I've done that, it would be greatly
appreciated.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
