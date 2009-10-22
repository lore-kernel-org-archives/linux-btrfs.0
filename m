From: Josef Bacik <josef@redhat.com>
Subject: Re: Allocator changes
Date: Thu, 22 Oct 2009 13:37:21 -0400
Message-ID: <20091022173721.GB1382@dhcp231-156.rdu.redhat.com>
References: <20091021214135.GA5935@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091021214135.GA5935@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 21, 2009 at 05:41:36PM -0400, Josef Bacik wrote:
> Hello,
> 
> I've been thinking recently about how to fix the caching stuff so it isn't so
> damned slow and had started to work on writing out the free space cache into
> bitmaps for every dirty bitmap, but then Eric Sandeen pointed out that xfs just
> has a couple of btree's to track free space, so I started thinking about doing
> it that way, since we do have this nice btree code laying about.
> 
> There are a couple of problems with adding another free space root however:
> 
> 1) Backwards compatibility.  This would be yet another format change that would
> be rolling and users would not be able to go back on.  The problem here is that
> both the userspace and kernel sides would have to be changed, so if old
> userspace tools made changes to a new fs there would be no way of signalling
> that we need to make sure we rebuild the free space tree, so it would have to be
> an incompatible change.  I'm less worried about this, but it is an issue to
> consider.
> 
> 2) COW.  This part really sucks, we get into the same sort of recursiveness that
> we had with the extent tree, only worse because in order to COW a block in the
> free space tree during allocation we'd have to come back into the allocator.
> The way I'm thinking about fixing this is doing something like
> path->recursive_locking = 1.  This way when we do a tree_lock, if we are already
> locked then we just set a flag on the eb->flags to say we recursively locked it,
> and then when we walk back unlocking stuff we check that flag and clear it if
> its set, otherwise we unlock the eb->lock spinlock.
> 

Actually doing this doesn't actually work, since theres no way to keep track of
who is recursively locking without saving the pid or some such other garbage.
So what I'm going to do is have a patch->delay_cow.  Everytime we do a search in
the free space tree we'll set delay_cow, and mark the nodes in the path that we
need to cow with what the operation we need to do (cow, split, new root etc),
and then once we find the leaf with the free space we just look for enough space
to allocate enough blocks for our operations and then do the cow operations
then.  We also keep the nodes that we want to cow as blocked so we keep other
people from walking down that path until after we've run the delayed cow
operations.  Thanks,

Josef
