Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:42994 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759Ab2GDDZw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jul 2012 23:25:52 -0400
Date: Wed, 4 Jul 2012 13:25:47 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zach Brown <zab@zabbo.net>, Hugo Mills <hugo@carfax.org.uk>,
        =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS fsck apparent errors
Message-ID: <20120704032547.GE19223@dastard>
References: <4FF30B55.6060205@petaramesh.org>
 <20120703152208.GA28701@carfax.org.uk>
 <20120703155212.GG5326@twin.jikos.cz>
 <4FF31D41.8070907@zabbo.net>
 <20120703173742.GH5326@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120703173742.GH5326@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2012 at 07:37:42PM +0200, David Sterba wrote:
> On Tue, Jul 03, 2012 at 09:26:41AM -0700, Zach Brown wrote:
> > On 07/03/2012 08:52 AM, David Sterba wrote:
> > >--- a/btrfsck.c
> > >+++ b/btrfsck.c
> > >@@ -3474,6 +3474,7 @@ static struct option long_options[] = {
> > >         { "repair", 0, NULL, 0 },
> > >         { "init-csum-tree", 0, NULL, 0 },
> > >         { "init-extent-tree", 0, NULL, 0 },
> > >+       { "force", 0, NULL, 0 },
> > 
> > If we were to run with this, I think it should be called something other
> > than force.  fsck.ext* has trained people to think that 'forcing' a fsck
> > means doing a full repair pass even if the fs thinks that it was shut
> > down cleanly.
> 
> Agreed, it's not a good name and was rather a quick aid to myself, I
> didn't put much thinking into the user interface as I usually do :)

xfs_repair uses:

       -d     Repair  dangerously.  Allow  xfs_repair  to  repair an
	      XFS filesystem mounted read only. This is typically
	      done on a root fileystem from single user mode,
	      immediately followed by a reboot.

> > --read-only would be good if fsck was taught to not even try to write in
> > this mode.
> 
> read-only mode is default and (hopefully) does no writes to the device,
> this would require the --repair option so what you propose is sort of a
> sanity check, right?

If you run fsck/reapir on a mounted filesystem, and it changes the
block device (i.e. fixes something) the mounted filesystem does not
know about it and so may use stale metadata and bad things will
happen. That's why it's called "dangerous". ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
