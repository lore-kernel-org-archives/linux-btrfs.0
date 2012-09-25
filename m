Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:58635 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab2IYQnk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 12:43:40 -0400
Date: Tue, 25 Sep 2012 18:43:36 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC design issues
Message-ID: <20120925164335.GZ14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120920190306.GG2272@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120920190306.GG2272@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 20, 2012 at 03:03:06PM -0400, Josef Bacik wrote:
> I'm going to look at fixing some of the performance issues that crop up because
> of our reservation system.  Before I go and do a whole lot of work I want some
> feedback.  I've done a brain dump here
> https://btrfs.wiki.kernel.org/index.php/ENOSPC

Thanks for writing it down, much appreciated.

My first and probably naive approach is described in the page, quoting
here:

 "Attempt to address how to flush less stated below. The
 over-reservation of a 4k block can go up to 96k as the worst case
 calculation (see above). This accounts for splitting the full tree path
 from 8th level root down to the leaf plus the node splits. My question:
 how often do we need to go up to the level N+1 from current level N?
 for levels 0 and 1 it may happen within one transaction, maybe not so
 often for level 2 and with exponentially decreasing frequency for the
 higher levels. Therefore, is it possible to check the tree level first
 and adapt the calculation according to that? Let's say we can reduce
 the 4k reservation size from 96k to 32k on average (for a many-gigabyte
 filesystem), thus increasing the space available for reservations by
 some factor. The expected gain is less pressure to the flusher because
 more reservations will succeed immediately.
 The idea behind is to make the initial reservation more accurate to
 current state than blindly overcommitting by some random factor (1/2).
 Another hint to the tree root level may be the usage of the root node:
 eg. if the root is less than half full, splitting will not happen
 unless there are K concurrent reservations running where K is
 proportional to overwriting the whole subtree (same exponential
 decrease with increasing level) and this will not be possible within
 one transaction or there will not be enough space to satisfy all
 reservations. (This attempts to fine-tune the currently hardcoded level
 8 up to the best value). The safe value for the level in the
 calculations would be like N+1, ie. as if all the possible splits
 happen with respect to current tree height."

implemented as follows on top of next/master, in short:
* disable overcommit completely
* do the optimistically best guess for the metadata and reserve only up
  to the current tree height

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2794,7 +2794,11 @@ static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
 static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
                                                 unsigned num_items)
 {
-       return (root->leafsize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
+       int level = btrfs_header_level(root->node);
+
+       level = min(level, BTRFS_MAX_LEVEL);
+
+       return (root->leafsize + root->nodesize * (level - 1)) *
                3 * num_items;
 }

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index efb044e..c9fa7ed 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3649,6 +3649,8 @@ static int can_overcommit(struct btrfs_root *root,
        u64 avail;
        u64 used;

+       return 0;
+
        used = space_info->bytes_used + space_info->bytes_reserved +
                space_info->bytes_pinned + space_info->bytes_readonly +
                space_info->bytes_may_use;
---

I must be doing something wrong, because I don't see any unexpected
ENOSPC while performing some tests on a 2G, 4G and 10G partitions with
following loads:

fs_mark -F -k -S 0 -D 20 -N 100
- dumb, no file contents

fs_mark -F -k -S 0 -D 20000 -N 400000 -s 2048 -t 8
- metadata intense, files and inline contents

fs_mark -F -k -S 0 -D 20 -N 100 -s 3900 -t 24
- ~dtto, lots writers

fs_mark -F -k -S 0 -D 20 -N 100 -s 8192 -t 24
- lots writers, no inlines

tar xf linux-3.2.tar.bz2	(1G in total)
- simple untar


The fs_mark loads do not do any kind of sync, as this should stress the
number of data in flight. After each load finishes with ENOSPC, the rest
of the filesystem is filled with a file full of zeros. Then 'fi df'
reports all the space is used, no unexpectedly large files can be found
(ie a few hundred KBs if it was data-intense, or using whole remaining
data space if it was meta-intense, eg. 8MB).

mkfs was default, so are the mount options, did not push it through
xfstests. but at least verified md5sums of the kernel tree.

Sample tree height for extent tree was 2 and 3 for fs tree, so I think
it exercised the case where the tree height increased during the load
(but maybe it was just lucky to get the +1 block from somewhere else,
dunno).

I'm running the tests on a 100G filesystem now.


david
