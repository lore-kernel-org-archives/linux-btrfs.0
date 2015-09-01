Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36667 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbbIATB5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 15:01:57 -0400
Received: by pacwi10 with SMTP id wi10so4509492pac.3
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2015 12:01:57 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@fb.com>
Subject: [PATCH 0/6] free space B-tree
Date: Tue,  1 Sep 2015 12:01:35 -0700
Message-Id: <cover.1441131625.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi,

At Facebook, we are still running into the issue of long commit stalls
on large filesystems (say, 10s of TBs). 1bbc621ef284 ("Btrfs: allow
block group cache writeout outside critical section in commit") was a
stopgap, but it wasn't enough, as it's still possible for a very busy
filesystem to have a lot of block groups dirtied between the time we do
the initial free space cache writeout and redo it in the critical
section. Like Chris mentioned at LPC, I've been working on another
solution to put these issues behind us.

The solution we came up with is to track free space in a separate B-tree
and update it in tandem with the extent tree. Using a B-tree rather than
another ad-hoc mechanism has the advantage of being well-understood and
giving us the proper metadata allocation profile by default, even if it
could be slightly less efficient than something else purpose-built.

In any case, the scalability win is clear. All of the tests below were
run on a Fusion-io card. My stress testing workload, fallocating 50 TB
worth of space on a 100 TB sparse filesystem image and then freeing it
all, could cause stalls in the critical section for tens of seconds
writing out the free space cache. Using no free space cache or the free
space tree, commits spend only about a tenth of a second in the critical
section.

The time to load the free space tree is still reasonable as well. To
test this, I created extremely fragmented block groups and then ran a
workload that dirtied every inode in the filesystem, measuring how long
we spent loading free space. The free space cache comes out on top,
costing only ~30 ms. Using no cache is much worse, costing about 3-5
seconds. The free space tree is in between, taking 100-500 ms total
(keep in mind that this is for the whole test lasting several minutes,
not just for one block group). A lot of this overhead is actually
manipulating the in-memory free space structures, so there's room for
improvement in the future.

Finally, we keep the disk usage under control by switching to a bitmap
format when it becomes more efficient than using extents. Using 256 byte
bitmaps and 4096 blocks, a 1 GB block groups in the worst case requires
1 GB / (256 * 8 * 4096 B) = 128 bitmaps, at 256 + sizeof(btrfs_item) =
256 + 25 = 281 bytes per bitmap for a grand total of ~35 KB of overhead
per block group, comparable to the free space cache. This incurs the
cost of converting between the two formats while running delayed refs,
but I found that this takes <5 ms on my device.

There are a couple of things that I wouldn't mind some comments on.
Firstly, when doing the conversion between the extent and bitmap
formats, we vmalloc a chunk of memory to buffer the free space in. For a
1 GB block group, this is 32 KB of memory. This happens during a
transaction commit, so I'm worried about whether this will cause
problems in low-memory situations. I chose to do this instead of
handling the extent or bitmap items one by one because this is the
simplest way to guarantee that the free space tree does not become
larger at any point during the conversion (for example, imagine that our
metadata space is almost full and we try to process a bitmap that
becomes several extents). I'm wondering if anyone has any better ideas
about how to handle this. Secondly, I *think* that using the commit root
in load_free_space_tree() like is done in caching_thread() is correct,
but I'm not 100% sure.

This series is on top of v4.2. I've run it through xfstests and some
manual stress tests as well. I'm sending it from my personal email
address because soon I'll be back to finish up school, but I'll still be
looking at any comments that anyone might have.

Thanks!

Omar Sandoval (6):
  Btrfs: add extent buffer bitmap operations
  Btrfs: add helpers for read-only compat bits
  Btrfs: introduce the free space B-tree on-disk format
  Btrfs: implement the free space B-tree
  Btrfs: wire up the free space tree to the extent tree
  Btrfs: add free space tree mount option

 fs/btrfs/Makefile            |    2 +-
 fs/btrfs/ctree.h             |  104 ++-
 fs/btrfs/disk-io.c           |   26 +
 fs/btrfs/extent-tree.c       |   88 ++-
 fs/btrfs/extent_io.c         |  101 +++
 fs/btrfs/extent_io.h         |    6 +
 fs/btrfs/free-space-tree.c   | 1468 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/free-space-tree.h   |   39 ++
 fs/btrfs/super.c             |   21 +-
 include/trace/events/btrfs.h |    3 +-
 10 files changed, 1843 insertions(+), 15 deletions(-)
 create mode 100644 fs/btrfs/free-space-tree.c
 create mode 100644 fs/btrfs/free-space-tree.h

-- 
2.5.1

