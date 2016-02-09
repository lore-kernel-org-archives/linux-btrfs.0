Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:38475 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbcBIIx7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 03:53:59 -0500
Date: Tue, 9 Feb 2016 19:53:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 12/23] xfs/122: support refcount/rmap data structures
Message-ID: <20160209085328.GQ19486@dastard>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
 <20160209011303.23099.40721.stgit@birch.djwong.org>
 <20160209074330.GK19486@dastard>
 <20160209075506.GB6346@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160209075506.GB6346@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 08, 2016 at 11:55:06PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 09, 2016 at 06:43:30PM +1100, Dave Chinner wrote:
> > On Mon, Feb 08, 2016 at 05:13:03PM -0800, Darrick J. Wong wrote:
> > > Include the refcount and rmap structures in the golden output.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  tests/xfs/122     |    3 +++
> > >  tests/xfs/122.out |    4 ++++
> > >  tests/xfs/group   |    2 +-
> > >  3 files changed, 8 insertions(+), 1 deletion(-)
> > > 
> > > 
> > > diff --git a/tests/xfs/122 b/tests/xfs/122
> > > index e6697a2..758cb50 100755
> > > --- a/tests/xfs/122
> > > +++ b/tests/xfs/122
> > > @@ -90,6 +90,9 @@ xfs_da3_icnode_hdr
> > >  xfs_dir3_icfree_hdr
> > >  xfs_dir3_icleaf_hdr
> > >  xfs_name
> > > +xfs_owner_info
> > > +xfs_refcount_irec
> > > +xfs_rmap_irec
> > >  xfs_alloctype_t
> > >  xfs_buf_cancel_t
> > >  xfs_bmbt_rec_32_t
> > 
> > So this is going to cause failures on any userspace that doesn't
> > know about these new types, right?
> > 
> > Should these be conditional in some way?
> 
> I wasn't sure how to handle this -- I could just keep the patch at the head of
> my stack (unreleased) until xfsprogs pulls in the appropriate libxfs pieces?
> So long as we're not dead certain of the final format of the rmapbt and
> refcountbt, there's probably not a lot of value in putting this in (yet).

Well, I'm more concerned about running on older/current distros that
don't have support for them in userspace. My brain is mush right
now, so I don't have any brilliant ideas (hence the question, rather
than also presenting a posible solution). I'll have a think; maybe
we can make use of the configurable .out file code we have now?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
