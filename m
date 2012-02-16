From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: check return value of lookup_extent_mapping() correctly
Date: Thu, 16 Feb 2012 16:23:58 +0900
Message-ID: <201202160723.AA00044@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch corrects error checking of lookup_extent_mapping().

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/compression.c |    2 ++
 fs/btrfs/extent_io.c   |    2 +-
 fs/btrfs/volumes.c     |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 14f1c5a..d02c27c 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -588,6 +588,8 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 				   page_offset(bio->bi_io_vec->bv_page),
 				   PAGE_CACHE_SIZE);
 	read_unlock(&em_tree->lock);
+	if (!em)
+		return -EIO;
 
 	compressed_len = em->block_len;
 	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a84621f..7411b9c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3293,7 +3293,7 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 			len = end - start + 1;
 			write_lock(&map->lock);
 			em = lookup_extent_mapping(map, start, len);
-			if (IS_ERR_OR_NULL(em)) {
+			if (!em) {
 				write_unlock(&map->lock);
 				break;
 			}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7ffdb15..7bc68a2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1954,7 +1954,7 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 	em = lookup_extent_mapping(em_tree, chunk_offset, 1);
 	read_unlock(&em_tree->lock);
 
-	BUG_ON(em->start > chunk_offset ||
+	BUG_ON(!em || em->start > chunk_offset ||
 	       em->start + em->len < chunk_offset);
 	map = (struct map_lookup *)em->bdev;
 

