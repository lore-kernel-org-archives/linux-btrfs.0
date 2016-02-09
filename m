Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42134 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbcBIIIO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 03:08:14 -0500
Date: Tue, 9 Feb 2016 00:08:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 06/23] dio unwritten conversion bug tests
Message-ID: <20160209080809.GA6350@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
 <20160209011223.23099.3987.stgit@birch.djwong.org>
 <20160209073732.GJ19486@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160209073732.GJ19486@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 09, 2016 at 06:37:32PM +1100, Dave Chinner wrote:
> On Mon, Feb 08, 2016 at 05:12:23PM -0800, Darrick J. Wong wrote:
> > Check that we don't expose old disk contents when a directio write to
> > an unwritten extent fails due to IO errors.  This primarily affects
> > XFS and ext4.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> .....
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -252,7 +252,9 @@
> >  247 auto quick rw
> >  248 auto quick rw
> >  249 auto quick rw
> > +250 auto quick
> >  251 ioctl trim
> > +252 auto quick
> 
> Also should be in the prealloc group if we are testing unwritten
> extent behaviour and the rw group because it's testing IO.

Done.

Should the CoW tests be in 'rw' too?  They're testing IO, but otoh they
(most probably) require shared blocks to have much of a point.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
