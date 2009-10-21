From: Josef Bacik <josef@redhat.com>
Subject: Allocator changes
Date: Wed, 21 Oct 2009 17:41:36 -0400
Message-ID: <20091021214135.GA5935@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've been thinking recently about how to fix the caching stuff so it isn't so
damned slow and had started to work on writing out the free space cache into
bitmaps for every dirty bitmap, but then Eric Sandeen pointed out that xfs just
has a couple of btree's to track free space, so I started thinking about doing
it that way, since we do have this nice btree code laying about.

There are a couple of problems with adding another free space root however:

1) Backwards compatibility.  This would be yet another format change that would
be rolling and users would not be able to go back on.  The problem here is that
both the userspace and kernel sides would have to be changed, so if old
userspace tools made changes to a new fs there would be no way of signalling
that we need to make sure we rebuild the free space tree, so it would have to be
an incompatible change.  I'm less worried about this, but it is an issue to
consider.

2) COW.  This part really sucks, we get into the same sort of recursiveness that
we had with the extent tree, only worse because in order to COW a block in the
free space tree during allocation we'd have to come back into the allocator.
The way I'm thinking about fixing this is doing something like
path->recursive_locking = 1.  This way when we do a tree_lock, if we are already
locked then we just set a flag on the eb->flags to say we recursively locked it,
and then when we walk back unlocking stuff we check that flag and clear it if
its set, otherwise we unlock the eb->lock spinlock.

This lets us get rid of all of the free space cache code and simply use the free
space btree for keeping track of our free space.  This would do well for keeping
our memory footprint down.  We can still keep the block group stuff and
find_free_extent mostly in place, that way we can still mark block groups as
read-only and be sure we don't end up allocating any of the area within that
byte range.

Once all that is in place, we can do a per_cpu cluster/pool where we add big
extents that we read out of the btree and then we can keep down the number of
times we hit the btree.  Then we just flush the percpu extents back to the btree
everytime we commit the transaction and we're good to go.

This keeps us from having to do the caching kthread at all and I think will
greatly help our bootup times.  What do you think?  Thanks,

Josef
