From: Josef Bacik <josef@redhat.com>
Subject: [RFC] new free space caching stuff
Date: Thu, 21 May 2009 14:43:52 -0400
Message-ID: <20090521184351.GC11101@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Okay I'm looking at redoing all of this stuff again, and I'd like to make this
the last time, so I'm going to outline what we currently have, what the problems
are with it, and what I want to do.  I would appreciate any/all input so I can
try and get this right the first time.

So first off, what we currently do

1) We have btrfs_space_info, this keeps a list of all of the block groups with
the same allocation bits.  Whenever we allocate free space, we ask what area
we're going to allocate from, and then loop through this list of block groups
looking for free space in each block group.

2) We have btrfs_block_group_cache, which represents chunks of space for a
particular allocation group.  Usually around 1 gig a peice.  Per block group we
maintain an RB tree of free space extents indexed by a) bytes and b) offset, so
we can quickly find the best possible allocation based on our size and our
offset hint.

3) We have btrfs_free_cluster, which helps cluster allocations together.  For
metadata we want to try and pack everything together as much as possible, so we
come in and look for a big chunk of space, and pull it out of the free space
cache and put it in these clusters, and then once we have this cluster we try
and allocate from it, and then refill it when we need to.  This is per fs_info
(mounted fs).

So thats all well and good and has worked fine for us for the most part, except

1) Its kind of complicated.  This is alot of work to go through just to keep
track of free space, and it gets confusing quick and is very fragile.

2) It is a memory hog.  sizeof(struct btrfs_free_space) is something like 56
bytes, which worst case scenario ends up being about 7 megabytes total RAM used
for free space cache per 1 gigabyte of space, so worse case scenario we're
talking 7 gigabytes of ram to keep track of free space for 1terabyte of disk
space, which is unacceptable.

Which leads me to the goals of redoing this stuff

1) Make it less complicated.  I would like to have less moving parts involved
with the allocation stuff so we don't have the situation where only one of us at
any given time really understands how it all works.

2) Don't use as much memory.  Messing around with the numbers I came up with 32k
of RAM should be the maximum amount of memory used to track 1 gigabyte of free
space, in the worst case scenario, which makes 3.125 gigs worth of ram to track
100T of disk space.

3) Not really a goal, but we can't take a performance regression in redoing all
of this stuff.

Ok so, whats the plan?  Well here's what I have in mind

1) Switch all per-blockgroup free space accounting to bitmaps.  No more RB tree
at all for tracking free space at the block group level.  This has the benefit
that we easily stay in our 32k of ram per block group requirement, and it lets
us in the future simply write the free space bitmaps to disk, so we can flush
out our free space cache under memory pressure, and we can even read it back
during mount and be alot faster with establishing our free space cache.

2) Use the cluster space stuff like we currently do.  This will need some
retooling since we need to be able to allocate new bitmaps under a lock, so I
will likely have a spin lock for the simple allocation case, and then a mutex to
refill the cluster.

I think this is all I have.  Please if you have a better idea I am all ears, but
this is the best I can come up with at the moment.  Thanks,

Josef
