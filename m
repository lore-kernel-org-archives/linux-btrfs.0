Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbaGVSLA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 14:11:00 -0400
Date: Tue, 22 Jul 2014 20:10:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Zach Brown <zab@zabbo.net>, Dave Chinner <david@fromorbit.com>,
        fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] xfstests/btrfs: add test for quota groups and drop
 snapshot
Message-ID: <20140722181057.GH1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140709224150.GA5484@wotan.suse.de>
 <20140710004330.GG4453@dastard>
 <20140710173614.GB5484@wotan.suse.de>
 <20140710183228.GD17201@lenny.home.zabbo.net>
 <20140710190055.GC5484@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140710190055.GC5484@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 10, 2014 at 12:00:55PM -0700, Mark Fasheh wrote:
> On Thu, Jul 10, 2014 at 11:32:28AM -0700, Zach Brown wrote:
> > On Thu, Jul 10, 2014 at 10:36:14AM -0700, Mark Fasheh wrote:
> > > On Thu, Jul 10, 2014 at 10:43:30AM +1000, Dave Chinner wrote:
> > > > On Wed, Jul 09, 2014 at 03:41:50PM -0700, Mark Fasheh wrote:
> > > > > +
> > > > > +# Enable qgroups now that we have our filesystem prepared. This
> > > > > +# will kick off a scan which we will have to wait for below.
> > > > > +$BTRFS_UTIL_PROG qu en $SCRATCH_MNT
> > > > > +sleep 30
> > > > 
> > > > That seems rather arbitrary. The sleeps you are adding add well over
> > > > a minute to the runtime, and a quota scan of a filesystem with 200
> > > > files should be almost instantenous.
> > > 
> > > Yeah I'll bring that back down to 5 seconds?
> > 
> > How long does it usually take?
> > 
> > What interfaces would be needed for this to work precisely so we don't
> > have to play this game ever again?
> 
> Well there's also the 'sleep 45' below because we need to be certain that
> btrfs_drop_snapshot gets run. This was all a bit of a pain during debugging
> to be honest.

If you need to wait just for the quota scan, then use
'btrfs quota rescan -w' that will wait until the rescan finishes.
