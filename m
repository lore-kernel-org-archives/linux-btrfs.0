From: Chris Mason <chris.mason@oracle.com>
Subject: Re: snapshot creation
Date: Wed, 13 Jan 2010 09:44:02 -0500
Message-ID: <20100113144402.GN14979@think>
References: <Pine.LNX.4.64.1001121116250.2394@cobra.newdream.net>
 <20100112202550.GF14979@think>
 <Pine.LNX.4.64.1001121241050.2394@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1001121241050.2394@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 12, 2010 at 12:47:22PM -0800, Sage Weil wrote:
> On Tue, 12 Jan 2010, Chris Mason wrote:
> 
> > On Tue, Jan 12, 2010 at 11:24:39AM -0800, Sage Weil wrote:
> > > Hi Chris,
> > > 
> > > What is the motivation behind the two phases of snapshot creation 
> > > (create_pending_snapshot, finish_pending_snapshot)?  Is it just to avoid 
> > > putting a reference to the snap subvol inside the snapped version of the 
> > > subvol (forming a loop)?
> > > 
> > > If that's the case, I think the problem can be solved in other ways (by 
> > > not following the subvol link if it loops to self, or by also delaying the 
> > > root creation to avoid leaking an unreferenced root).  And the rest of the 
> > > time (when the link is outside the linked-to subvol) committing the root 
> > > and it's reference in one commit.
> > > 
> > > Unless I'm missing something else?
> > 
> > Part of the problem is that we want to make sure we have a consistent
> > view of a given root.  So if we tell snapshot abc to point to a specific
> > root block, the reference that gets taken and all the cow rules get
> > complex in a hurry.
> > 
> > I'm guessing that you want to do snapshot creation without forcing a
> > commit?
> 
> Actually I just want the snapshot AND the reference to it to commit at 
> once.  (Currently, you create a snap, a commit happens, and then you still 
> need to sync one more time or it can get orphaned.)  I posted a patch a 
> few weeks back that did that, but it wasn't clear to me why the snapshot 
> link was delayed in the first place.  If it's loop avoidance, maybe we can 
> at least avoid that in the case where the reference isn't in the same root 
> it refers to...

Ok, it's not loop avoidance, its just keeping the whole tree consistent.
I'll pick up the patch from you.

-chris

