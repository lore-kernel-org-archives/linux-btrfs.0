Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:11864 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbaGJVKa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 17:10:30 -0400
Date: Fri, 11 Jul 2014 07:10:27 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] xfstests/btrfs: add test for quota groups and drop
 snapshot
Message-ID: <20140710211027.GM4453@dastard>
References: <20140709224150.GA5484@wotan.suse.de>
 <20140710004330.GG4453@dastard>
 <20140710173614.GB5484@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140710173614.GB5484@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 10, 2014 at 10:36:14AM -0700, Mark Fasheh wrote:
> Hey Dave, thanks for the patch review! Pretty much all of what you wrote
> sounds good to me, there's just one or two items I wanted to clarify - those
> comments are inline. Thanks again,
> 
> On Thu, Jul 10, 2014 at 10:43:30AM +1000, Dave Chinner wrote:
> > On Wed, Jul 09, 2014 at 03:41:50PM -0700, Mark Fasheh wrote:
> > > +
> > > +# Enable qgroups now that we have our filesystem prepared. This
> > > +# will kick off a scan which we will have to wait for below.
> > > +$BTRFS_UTIL_PROG qu en $SCRATCH_MNT
> > > +sleep 30
> > 
> > That seems rather arbitrary. The sleeps you are adding add well over
> > a minute to the runtime, and a quota scan of a filesystem with 200
> > files should be almost instantenous.
> 
> Yeah I'll bring that back down to 5 seconds? It's 30 from my testing because
> I was being paranoid and neglected to update it for the rest of the world.

Be nice to have the btrfs command wait for it to complete. Not being
able to query the status of background work or wait for it is
somewhat user unfriendly. If you could poll, then a 1s sleep in a
poll loop would be fine. Short of that, then I guess sleep 5 is the
best we can do.

> 
> > > +_scratch_unmount
> > > +_scratch_mount
> > 
> > What is the purpose of this?
> 
> This is kind of 'maximum paranoia' again from my own test script. The idea
> was to make _absolutely_ certain that all metadata found it's way to disk
> and won't be optimized in layout any more. There's a decent chance it
> doesn't do anything but it doesn't seem a huge deal. I wasn't clear though -
> do you want it removed or can I comment it for clarity?

Comment. If someone reads the test in 2 years time they won't
have to ask "wtf?"...

> > > +# Ok, delete the snapshot we made previously. Since btrfs drop
> > > +# snapshot is a delayed action with no way to force it, we have to
> > > +# impose another sleep here.
> > > +$BTRFS_UTIL_PROG su de $SCRATCH_MNT/snap1
> > > +sleep 45
> > 
> > That's indicative of a bug, yes?
> 
> No, that's just how it happens. In fact, if you unmount while a snapshot is
> being dropped, progress of the drop will be recorded and it will be
> continued on next mount. However, since we *must* have the drop_snapshot
> complete for this test I have the large sleep. Unlike the previous sleep I
> don't think this can be reduced by much :(

Right, again the "can't wait or poll for status of background work"
issue comes up.  That's the bug in the UI I was refering to. I guess
that we'll just have to wait for a long time here. Pretty hacky,
though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
