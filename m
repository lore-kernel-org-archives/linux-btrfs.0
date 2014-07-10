Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:39684 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaGJSca (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 14:32:30 -0400
Date: Thu, 10 Jul 2014 11:32:28 -0700
From: Zach Brown <zab@zabbo.net>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] xfstests/btrfs: add test for quota groups and drop
 snapshot
Message-ID: <20140710183228.GD17201@lenny.home.zabbo.net>
References: <20140709224150.GA5484@wotan.suse.de>
 <20140710004330.GG4453@dastard>
 <20140710173614.GB5484@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140710173614.GB5484@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 10, 2014 at 10:36:14AM -0700, Mark Fasheh wrote:
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
> Yeah I'll bring that back down to 5 seconds?

How long does it usually take?

What interfaces would be needed for this to work precisely so we don't
have to play this game ever again?

- z
