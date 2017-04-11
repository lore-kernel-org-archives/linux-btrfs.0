Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38576 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdDKI53 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 04:57:29 -0400
Date: Tue, 11 Apr 2017 11:57:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] Btrfs: remove some dead code
Message-ID: <20170411085715.GA24157@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_get_extent() never returns NULL pointers, so this code introduces
a static checker warning.

The btrfs_get_extent() is a bit complex, but trust me that it doesn't
return NULLs and also if it did we would trigger the BUG_ON(!em) before
the last return statement.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 315fbbf84fa2..1519d29dec01 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2397,13 +2397,8 @@ static int find_first_non_hole(struct inode *inode, u64 *start, u64 *len)
 	int ret = 0;
 
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, *start, *len, 0);
-	if (IS_ERR_OR_NULL(em)) {
-		if (!em)
-			ret = -ENOMEM;
-		else
-			ret = PTR_ERR(em);
-		return ret;
-	}
+	if (IS_ERR(em))
+		return PTR_ERR(em);
 
 	/* Hole or vacuum extent(only exists in no-hole mode) */
 	if (em->block_start == EXTENT_MAP_HOLE) {
@@ -2893,11 +2888,8 @@ static long btrfs_fallocate(struct file *file, int mode,
 	while (1) {
 		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, cur_offset,
 				      alloc_end - cur_offset, 0);
-		if (IS_ERR_OR_NULL(em)) {
-			if (!em)
-				ret = -ENOMEM;
-			else
-				ret = PTR_ERR(em);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
 			break;
 		}
 		last_byte = min(extent_map_end(em), alloc_end);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index df937f8c71df..dc5f9002593d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6866,7 +6866,6 @@ static noinline int uncompress_inline(struct btrfs_path *path,
  *
  * This also copies inline extents directly into the page.
  */
-
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		struct page *page,
 	    size_t pg_offset, u64 start, u64 len,
@@ -7175,19 +7174,17 @@ struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
 	em = btrfs_get_extent(inode, page, pg_offset, start, len, create);
 	if (IS_ERR(em))
 		return em;
-	if (em) {
-		/*
-		 * if our em maps to
-		 * -  a hole or
-		 * -  a pre-alloc extent,
-		 * there might actually be delalloc bytes behind it.
-		 */
-		if (em->block_start != EXTENT_MAP_HOLE &&
-		    !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
-			return em;
-		else
-			hole_em = em;
-	}
+	/*
+	 * if our em maps to
+	 * -  a hole or
+	 * -  a pre-alloc extent,
+	 * there might actually be delalloc bytes behind it.
+	 */
+	if (em->block_start != EXTENT_MAP_HOLE &&
+	    !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
+		return em;
+	else
+		hole_em = em;
 
 	/* check to see if we've wrapped (len == -1 or similar) */
 	end = start + len;
