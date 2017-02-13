Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17518 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751310AbdBMXgK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 18:36:10 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: specify a new ordered extent type for create_io_em
Date: Mon, 13 Feb 2017 15:35:09 -0800
Message-Id: <1487028909-8694-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As 0 refers to an existing type BTRFS_ORDERED_IO_DONE, this specifies a
new type 'REGULAR' for regular IO.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
This fixes the problem in the patch
"[PATCH] Btrfs: create a helper to create em for IO".

 fs/btrfs/inode.c        | 8 ++++----
 fs/btrfs/ordered-data.h | 2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5e28355..f75c914 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -986,7 +986,7 @@ static noinline int cow_file_range(struct inode *inode,
 				  ins.offset, /* orig_block_len */
 				  ram_size, /* ram_bytes */
 				  BTRFS_COMPRESS_NONE, /* compress_type */
-				  0 /* type */);
+				  BTRFS_ORDERED_REGULAR /* type */);
 		if (IS_ERR(em))
 			goto out_reserve;
 		free_extent_map(em);
@@ -7490,7 +7490,7 @@ static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
 	ASSERT(type == BTRFS_ORDERED_PREALLOC ||
 	       type == BTRFS_ORDERED_COMPRESSED ||
 	       type == BTRFS_ORDERED_NOCOW ||
-	       type == 0);
+	       type == BTRFS_ORDERED_REGULAR);
 
 	em_tree = &BTRFS_I(inode)->extent_tree;
 	em = alloc_extent_map();
@@ -7507,9 +7507,9 @@ static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
 	em->ram_bytes = ram_bytes;
 	em->generation = -1;
 	set_bit(EXTENT_FLAG_PINNED, &em->flags);
-	if (type == BTRFS_ORDERED_PREALLOC)
+	if (type == BTRFS_ORDERED_PREALLOC) {
 		set_bit(EXTENT_FLAG_FILLING, &em->flags);
-	else if (type == BTRFS_ORDERED_COMPRESSED) {
+	} else if (type == BTRFS_ORDERED_COMPRESSED) {
 		set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 		em->compress_type = compress_type;
 	}
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 5f2b0ca..db003761 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -75,6 +75,8 @@ struct btrfs_ordered_sum {
 				 * in the logging code. */
 #define BTRFS_ORDERED_PENDING 11 /* We are waiting for this ordered extent to
 				  * complete in the current transaction. */
+#define BTRFS_ORDERED_REGULAR 12 /* Regular IO for COW */
+
 struct btrfs_ordered_extent {
 	/* logical offset in the file */
 	u64 file_offset;
-- 
2.5.5

