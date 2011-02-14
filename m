From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: check return value of alloc_extent_map()
Date: Mon, 14 Feb 2011 09:45:29 +0900
Message-ID: <201102140045.AA00008@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I add the check on the return value of alloc_extent_map() to several places.
In addition, alloc_extent_map() returns only the address or NULL.
Therefore, check by IS_ERR() is unnecessary. So, I remove IS_ERR() checking.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/extent_map.c  |    4 ++--
 fs/btrfs/file.c        |    1 +
 fs/btrfs/inode.c       |    3 +++
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 565e22d..a7aaa10 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6584,7 +6584,7 @@ static noinline int relocate_data_extent(struct inode *reloc_inode,
 	u64 end = start + extent_key->offset - 1;
 
 	em = alloc_extent_map(GFP_NOFS);
-	BUG_ON(!em || IS_ERR(em));
+	BUG_ON(!em);
 
 	em->start = start;
 	em->len = extent_key->offset;
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index b0e1fce..2b6c12e 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -51,8 +51,8 @@ struct extent_map *alloc_extent_map(gfp_t mask)
 {
 	struct extent_map *em;
 	em = kmem_cache_alloc(extent_map_cache, mask);
-	if (!em || IS_ERR(em))
-		return em;
+	if (!em)
+		return NULL;
 	em->in_tree = 0;
 	em->flags = 0;
 	em->compress_type = BTRFS_COMPRESS_NONE;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b0ff34b..65338a1 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -185,6 +185,7 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			split = alloc_extent_map(GFP_NOFS);
 		if (!split2)
 			split2 = alloc_extent_map(GFP_NOFS);
+		BUG_ON(!split || !split2);
 
 		write_lock(&em_tree->lock);
 		em = lookup_extent_mapping(em_tree, start, len);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c9bc0af..8d392ed 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -644,6 +644,7 @@ retry:
 					async_extent->ram_size - 1, 0);
 
 		em = alloc_extent_map(GFP_NOFS);
+		BUG_ON(!em);
 		em->start = async_extent->start;
 		em->len = async_extent->ram_size;
 		em->orig_start = em->start;
@@ -820,6 +821,7 @@ static noinline int cow_file_range(struct inode *inode,
 		BUG_ON(ret);
 
 		em = alloc_extent_map(GFP_NOFS);
+		BUG_ON(!em);
 		em->start = start;
 		em->orig_start = em->start;
 		ram_size = ins.offset;
@@ -1169,6 +1171,7 @@ out_check:
 			struct extent_map_tree *em_tree;
 			em_tree = &BTRFS_I(inode)->extent_tree;
 			em = alloc_extent_map(GFP_NOFS);
+			BUG_ON(!em);
 			em->start = cur_offset;
 			em->orig_start = em->start;
 			em->len = num_bytes;


