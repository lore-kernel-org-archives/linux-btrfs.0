From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] another reader/writer lock for btrfs metadata
Date: Tue, 26 Jul 2011 18:00:21 -0400
Message-ID: <1311717520-sup-188@shiny>
References: <1311618006-sup-1777@shiny> <1311643645-sup-5605@shiny>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1311643645-sup-5605@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Chris Mason's message of 2011-07-25 21:28:30 -0400:
> Excerpts from Chris Mason's message of 2011-07-25 14:34:49 -0400:
> > Hi everyone,
> > 
> > I've updated the integration-test branch to use this code instead.  It
> > is a shiny new reader/writer lock built around rw spinlocks.  I've
> > removed all the adaptive spinning and started trusting the hints btrfs
> > already has about when blocks should block or spin.
> 
> I tested with lockdep and looks like I've got a bug in btrfs_next_leaf's
> lockdep handling.  So, please don't run this code with
> CONFIG_DEBUG_LOCK_ALLOC turned on.  The bug is only in lockdep mode, so
> we're fine with it off.
> 
> I'll fix it up in the morning.

Ok, I've rebased the btrfs integration-test branch to include fixes for
the lockdep problems.  I've also adapted Tejun's lockdep class patch to
the new code.  With this setup I'm not getting lockdep warnings, but I'm
always looking for more bug reports.

-chris
