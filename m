Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:46991 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2FKIKS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jun 2012 04:10:18 -0400
Message-ID: <4FD5A657.5060504@huawei.com>
Date: Mon, 11 Jun 2012 16:03:35 +0800
From: Li Zefan <lizefan@huawei.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Btrfs: fix defrag regression
Content-Type: text/plain; charset="GB2312"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a file has 3 small extents:

| ext1 | ext2 | ext3 |

Running "btrfs fi defrag" will only defrag the last two extents, if those
extent mappings hasn't been read into memory from disk.

This bug was introduced by commit 17ce6ef8d731af5edac8c39e806db4c7e1f6956f
("Btrfs: add a check to decide if we should defrag the range")

The cause is, that commit looked into previous and next extents using
lookup_extent_mapping() only.

While at it, remove the code that checks the previous extent, since
it's sufficient to check the next extent.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/btrfs/ioctl.c |   97 +++++++++++++++++++++++++++---------------------------
 1 file changed, 49 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 24b776c..ac910f2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -785,39 +785,57 @@ none:
 	return -ENOENT;
 }
 
-/*
- * Validaty check of prev em and next em:
- * 1) no prev/next em
- * 2) prev/next em is an hole/inline extent
- */
-static int check_adjacent_extents(struct inode *inode, struct extent_map *em)
+static struct extent_map *defrag_lookup_extent(struct inode *inode, u64 start)
 {
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
-	struct extent_map *prev = NULL, *next = NULL;
-	int ret = 0;
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	struct extent_map *em;
+	u64 len = PAGE_CACHE_SIZE;
 
+	/*
+	 * hopefully we have this extent in the tree already, try without
+	 * the full extent lock
+	 */
 	read_lock(&em_tree->lock);
-	prev = lookup_extent_mapping(em_tree, em->start - 1, (u64)-1);
-	next = lookup_extent_mapping(em_tree, em->start + em->len, (u64)-1);
+	em = lookup_extent_mapping(em_tree, start, len);
 	read_unlock(&em_tree->lock);
 
-	if ((!prev || prev->block_start >= EXTENT_MAP_LAST_BYTE) &&
-	    (!next || next->block_start >= EXTENT_MAP_LAST_BYTE))
-		ret = 1;
-	free_extent_map(prev);
-	free_extent_map(next);
+	if (!em) {
+		/* get the big lock and read metadata off disk */
+		lock_extent(io_tree, start, start + len - 1);
+		em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
+		unlock_extent(io_tree, start, start + len - 1);
 
+		if (IS_ERR(em))
+			return NULL;
+	}
+
+	return em;
+}
+
+static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em)
+{
+	struct extent_map *next;
+	bool ret = true;
+
+	/* this is the last extent */
+	if (em->start + em->len >= i_size_read(inode))
+		return false;
+
+	next = defrag_lookup_extent(inode, em->start + em->len);
+	if (!next || next->block_start >= EXTENT_MAP_LAST_BYTE)
+		ret = false;
+
+	free_extent_map(next);
 	return ret;
 }
 
-static int should_defrag_range(struct inode *inode, u64 start, u64 len,
-			       int thresh, u64 *last_len, u64 *skip,
-			       u64 *defrag_end)
+static int should_defrag_range(struct inode *inode, u64 start, int thresh,
+			       u64 *last_len, u64 *skip, u64 *defrag_end)
 {
-	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
-	struct extent_map *em = NULL;
-	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct extent_map *em;
 	int ret = 1;
+	bool next_mergeable = true;
 
 	/*
 	 * make sure that once we start defragging an extent, we keep on
@@ -828,23 +846,9 @@ static int should_defrag_range(struct inode *inode, u64 start, u64 len,
 
 	*skip = 0;
 
-	/*
-	 * hopefully we have this extent in the tree already, try without
-	 * the full extent lock
-	 */
-	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, start, len);
-	read_unlock(&em_tree->lock);
-
-	if (!em) {
-		/* get the big lock and read metadata off disk */
-		lock_extent(io_tree, start, start + len - 1);
-		em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
-		unlock_extent(io_tree, start, start + len - 1);
-
-		if (IS_ERR(em))
-			return 0;
-	}
+	em = defrag_lookup_extent(inode, start);
+	if (!em)
+		return 0;
 
 	/* this will cover holes, and inline extents */
 	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
@@ -852,18 +856,15 @@ static int should_defrag_range(struct inode *inode, u64 start, u64 len,
 		goto out;
 	}
 
-	/* If we have nothing to merge with us, just skip. */
-	if (check_adjacent_extents(inode, em)) {
-		ret = 0;
-		goto out;
-	}
+	next_mergeable = defrag_check_next_extent(inode, em);
 
 	/*
-	 * we hit a real extent, if it is big don't bother defragging it again
+	 * we hit a real extent, if it is big or the next extent is not a
+	 * real extent, don't bother defragging it
 	 */
-	if ((*last_len == 0 || *last_len >= thresh) && em->len >= thresh)
+	if ((*last_len == 0 || *last_len >= thresh) &&
+	    (em->len >= thresh || !next_mergeable))
 		ret = 0;
-
 out:
 	/*
 	 * last_len ends up being a counter of how many bytes we've defragged.
@@ -1142,8 +1143,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			break;
 
 		if (!should_defrag_range(inode, (u64)i << PAGE_CACHE_SHIFT,
-					 PAGE_CACHE_SIZE, extent_thresh,
-					 &last_len, &skip, &defrag_end)) {
+					 extent_thresh, &last_len, &skip,
+					 &defrag_end)) {
 			unsigned long next;
 			/*
 			 * the should_defrag function tells us how much to skip
-- 
1.7.9.7
