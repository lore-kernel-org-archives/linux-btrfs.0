Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:6576 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932423AbcGFXNx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jul 2016 19:13:53 -0400
Date: Thu, 7 Jul 2016 09:13:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 19/20] xfs: run xfs_repair at the end of each test
Message-ID: <20160706231340.GJ27480@dastard>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
 <146612808160.25024.5986137574652014794.stgit@birch.djwong.org>
 <20160705035617.GD23649@eguan.usersys.redhat.com>
 <20160705041134.GB18951@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160705041134.GB18951@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 04, 2016 at 09:11:34PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 05, 2016 at 11:56:17AM +0800, Eryu Guan wrote:
> > On Thu, Jun 16, 2016 at 06:48:01PM -0700, Darrick J. Wong wrote:
> > > Run xfs_repair twice at the end of each test -- once to rebuild
> > > the btree indices, and again with -n to check the rebuild work.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  common/rc |    3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > 
> > > diff --git a/common/rc b/common/rc
> > > index 1225047..847191e 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -2225,6 +2225,9 @@ _check_xfs_filesystem()
> > >          ok=0
> > >      fi
> > >  
> > > +    $XFS_REPAIR_PROG $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
> > > +    cat $tmp.repair | _fix_malloc		>>$seqres.full
> > > +
> > 
> > Won't this hide fs corruptions? Did I miss anything?
> 
> I could've sworn it did:
> 
> xfs_repair -n
> (complain if corrupt)
> 
> xfs_repair
> 
> xfs_repair -n
> (complain if still corrupt)
> 
> But that first xfs_repair -n hunk disappeared. :(
> 
> Ok, will fix and resend.

Not sure this is the best idea - when repair on an aged test device
takes 10s, this means the test harness overhead increases by a
factor of 3. i.e. test takes 1s to run, checking the filesystem
between tests now takes 30s. i.e. this will badly blow out the run
time of the test suite on aged test devices....

What does this overhead actually gain us that we couldn't encode
explicitly into a single test or two? e.g the test itself runs
repair on the aged test device....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
