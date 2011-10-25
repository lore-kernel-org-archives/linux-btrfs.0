From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 08/66] btrfs: convert_extent_bit error push-up
Date: Mon, 24 Oct 2011 21:02:44 -0400
Message-ID: <20111025010851.484227255@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 convert_extent_bit can fail with -ENOMEM but nothing actually catches the
 errors.

 This patch catches the error with BUG_ON in the caller.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.h   |    2 +-
 fs/btrfs/transaction.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -220,7 +220,7 @@ int set_extent_dirty(struct extent_io_tr
 int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		       gfp_t mask) __must_check;
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		       int bits, int clear_bits, gfp_t mask);
+		       int bits, int clear_bits, gfp_t mask) __must_check;
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -580,8 +580,9 @@ int btrfs_write_marked_extents(struct bt
 
 	while (!find_first_extent_bit(dirty_pages, start, &start, &end,
 				      mark)) {
-		convert_extent_bit(dirty_pages, start, end, EXTENT_NEED_WAIT, mark,
-				   GFP_NOFS);
+		err = convert_extent_bit(dirty_pages, start, end,
+					 EXTENT_NEED_WAIT, mark, GFP_NOFS);
+		BUG_ON(err < 0);
 		err = filemap_fdatawrite_range(mapping, start, end);
 		if (err)
 			werr = err;


