From: Chris Ball <cjb@laptop.org>
Subject: Update to Project_ideas wiki page
Date: Tue, 16 Nov 2010 22:19:45 -0500
Message-ID: <m3hbfg3acu.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Chris Mason has posted a bunch of interesting updates to the
Project_ideas wiki page.  If you're interested in working on any
of these, feel free to speak up and ask for more information if
you need it.  Here are the new sections, for the curious:

== Block group reclaim ==

The split between data and metadata block groups means that we
sometimes have mostly empty block groups dedicated to only data or
metadata.  As files are deleted, we should be able to reclaim these
and put the space back into the free space pool.

We also need rebalancing ioctls that focus only on specific raid
levels.

== RBtree lock contention ==

Btrfs uses a number of rbtrees to index in-memory data structures.
Some of these are dominated by reads, and the lock contention from
searching them is showing up in profiles.  We need to look into an RCU
and sequence counter combination to allow lockless reads.

== Forced readonly mounts on errors ==

The sources have a number of BUG() statements that could easily be
replaced with code to force the filesystem readonly.  This is the
first step in being more fault tolerant of disk corruptions.  The
first step is to add a framework for generating errors that should
result in filesystems going readonly, and the conversion from BUG()
to that framework can happen incrementally.

== Dedicated metadata drives ==

We're able to split data and metadata IO very easily.  Metadata tends
to be dominated by seeks and for many applications it makes sense to
put the metadata onto faster SSDs.

== Readonly snapshots ==

The Btrfs snapshots are read/write by default.  A small number of
checks would allow us to make readonly snapshots instead.

== Per file / directory controls for COW and compression ==

Data compression and data cow are controlled across the entire FS by
mount options right now.  ioctls are needed to set this on a per file
or per directory basis.  This has been proposed previously, but VFS
developers wanted us to use generic ioctls rather than btrfs-specific
ones.  Can we use some of the same ioctls that ext4 uses?  This task
is mostly organizational rather than technical.

== Chunk tree backups ==

The chunk tree is critical to mapping logical block numbers to
physical locations on the drive.  We need to make the mappings
discoverable via a block device scan so that we can recover from
corrupted chunk trees.

== Rsync integration ==

Now that we have code to efficiently find newly updated files, we need
to tie it into tools such as rsync and dirvish.  (For bonus points, we
can even tell rsync _which blocks_ inside a file have changed.  Would
need to work with the rsync developers on that one.)

== Atomic write API ==

The Btrfs implementation of data=ordered only updates metadata to
point to new data blocks when the data IO is finished.  This makes it
easy for us to implement atomic writes of an arbitrary size.  Some
hardware is coming out that can support this down in the block layer
as well.

== Backref walking utilities ==

Given a block number on a disk, the Btrfs metadata can find all the
files and directories that use or care about that block.  Some
utilities to walk these back refs and print the results would help
debug corruptions.

Given an inode, the Btrfs metadata can find all the directories that
point to the inode.  We should have utils to walk these back refs as
well.

== Scrubbing ==

We need a periodic daemon that can walk the filesystem and verify
the contents of all copies of all allocated blocks are correct.
This is mostly equivalent to "find | xargs cat >/dev/null", but
with the constraint that we don't want to thrash the page cache,
so direct I/O should be used instead.

If we find a bad copy during this process, and we're using RAID,
we should queue up an overwrite of the bad copy with a good one.
The overwrite can happen in-place.

== Drive swapping ==

Right now when we replace a drive, we do so with a full FS balance.
If we are inserting a new drive to remove an old one, we can do a
much less expensive operation where we just put valid copies of all
the blocks onto the new drive.

== IO error tracking ==

As we get bad csums or IO errors from drives, we should track the
failures and kick out the drive if it is clearly going bad.

== Random write performance ==

Random writes introduce small extents and fragmentation.  We need new
file layout code to improve this and defrag the files as they are
being changed.

== Free inode number cache ==

As the filesystem fills up, finding a free inode number will become
expensive.  This should be cached the same way we do free blocks.

== Snapshot aware defrag ==

As we defragment files, we break any sharing from other snapshots.
The balancing code will preserve the sharing, and defrag needs to grow
this as well.

== Btree lock contention ==

The btree locks, especially on the root block can be very hot.
We need to improve this, especially in read mostly workloads.

== Changing RAID levels ==

We need ioctls to change between different raid levels.  Some of these
are quite easy -- e.g. for RAID0 to RAID1, we just halve the available
bytes on the fs, then queue a rebalance.

== DISCARD utilities ==

For SSDs with discard support, we could use a scrubber that goes
through the fs and performs discard on anything that is unused.  You
could first use the balance operation to compact data to the front of
the drive, then discard the rest.

-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
