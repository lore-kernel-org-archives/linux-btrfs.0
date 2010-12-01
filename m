From: Josef Bacik <josef@redhat.com>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 12:38:30 -0500
Message-ID: <20101201173830.GA7021@localhost.localdomain>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <20101201163800.GA4087@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de,
	ssorce@redhat.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101201163800.GA4087@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 01, 2010 at 04:38:00PM +0000, Hugo Mills wrote:
> On Wed, Dec 01, 2010 at 09:21:36AM -0500, Josef Bacik wrote:
> > === Quotas ===
> > 
> > This is a huge topic in and of itself, but Christoph mentioned wanting to have
> > an idea of what we wanted to do with it, so I'm putting it here.  There are
> > really 2 things here
> > 
> > 1) Limiting the size of subvolumes.  This is really easy for us, just create a
> > subvolume and at creation time set a maximum size it can grow to and not let it
> > go farther than that.  Nice, simple and straightforward.
> > 
> > 2) Normal quotas, via the quota tools.  This just comes down to how do we want
> > to charge users, do we want to do it per subvolume, or per filesystem.  My vote
> > is per filesystem.  Obviously this will make it tricky with snapshots, but I
> > think if we're just charging the diff's between the original volume and the
> > snapshot to the user then that will be the easiest for people to understand,
> > rather than making a snapshot all of a sudden count the users currently used
> > quota * 2.
> 
>    This is going to be tricky to get the semantics right, I suspect.
> 
>    Say you've created a subvolume, A, containing 10G of Useful Stuff
> (say, a base image for VMs). This counts 10G against your quota. Now,
> I come along and snapshot that subvolume (as a writable subvolume) --
> call it B. This is essentially free for me, because I've got a COW
> copy of your subvolume (and the original counts against your quota).
> 
>    If I now modify a file in subvolume B, the full modified section
> goes onto my quota. This is all well and good. But what happens if you
> delete your subvolume, A? Suddenly, I get lumbered with 10G of extra
> files.  Worse, what happens if someone else had made a snapshot of A,
> too? Who gets the 10G added to their quota, me or them? What if I'd
> filled up my quota? Would that stop you from deleting your copy,
> because my copy can't be charged against my quota? Would I just end up
> unexpectedly 10G over quota?
> 

If you delete your subvolume A, like use the btrfs tool to delete it, you will
only be stuck with what you changed in snapshot B.  So if you only changed 5gig
worth of information, and you deleted the original subvolume, you would have
5gig charged to your quota.  The idea is you are only charged for what blocks
you have on the disk.  Thanks,

Josef
