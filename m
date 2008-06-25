From: Chris Mason <chris.mason@oracle.com>
Subject: New tree concurrency code pushed to btrfs-unstable
Date: Wed, 25 Jun 2008 16:54:22 -0400
Message-ID: <1214427262.10187.722.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've finally pushed out the bulk of my work to increase concurrency in
btree operations.  It is a large change, and some parts of the FS are
not yet updated.  In particular, you'll get an oops, corruption or other
problems if you:

* Add/remove devices online (create a multi-device FS at mkfs time works
fine)

* Defrag the FS

* Run btrfs-vol -b

I'll clean these up tomorrow.  In general, the code is fairly stable,
but I expect to be tracking strange oopsen and other corruptions for a
while.

In order to get this stabilized and out the door more quickly, I put a
single mutex around the extent allocation operations.  Since this is a
COW FS, the extent allocation tree performance factors in heavily to all
operations, but I still get a big benefit from the current code.

Locking is done in a top down fashion, and most of the heavy lifting is
done inside btrfs_search_slot.  The basic algorithm is to:

take a lock on a block at a specific level of the btree
    search for a key
    balance as required for insertion or deletion
    unlock any blocks at levels higher up in the tree
    if leaf: return
    if node: read lower level

The end result is that searching through the btree usually only has two
blocks locked at a time, (one parent node and one child) and extra steps
are taken to drop locks before doing IO (except when balancing).  By the
time that btrfs_search_slot returns, the only lock held is usually on
the leaf corresponding to the search key.

The locks are freed when a path is released (via btrfs_release_path or
btrfs_free_path).

This means a few rules of the FS have changed.

1) It is no longer valid to hold two paths on the same tree root at the
same time.  Searching for the second path will probably deadlock against
the first.

2) The only components of the path that can be trusted are those that
are locked.  struct btrfs_path has a locks array that indicates which
levels of the path are locked.  In some cases such as changing the first
or last key in a block, the code needs to maintain locks on higher
levels of the tree after btrfs_search_slot returns so that higher nodes
can be modified to reflect changes.

All of this is a modified form of Ohad Rodeh's locking ideas that he
presented along with reference counted snapshot design a few years ago.
I'm just using the page lock right now, which is quick and easy to code
but will need to be replaced with a different locking structure later
on.

I'll spend the rest of the week writing up some locking docs and
finishing off the bits that are still broken before wandering off on
vacation next week.  Happy testing ;)

-chris


