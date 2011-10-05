From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/8] btrfs: fix misleading variable name for flags
Date: Wed,  5 Oct 2011 12:21:45 +0200
Message-ID: <0d362fe51435bbf697600c2d9851add375f7dcfd.1317746377.git.dsterba@suse.cz>
References: <cover.1317746377.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1317746377.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/extent-tree.c |   14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e7276f6..8d8983a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2190,7 +2190,7 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 				  u64 num_bytes, u64 min_alloc_size,
 				  u64 empty_size, u64 hint_byte,
 				  u64 search_end, struct btrfs_key *ins,
-				  u64 data);
+				  u64 flags);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		  struct extent_buffer *buf, int full_backref);
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8732585..a626c14 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5404,12 +5404,12 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 			 u64 num_bytes, u64 min_alloc_size,
 			 u64 empty_size, u64 hint_byte,
 			 u64 search_end, struct btrfs_key *ins,
-			 u64 data)
+			 u64 flags)
 {
 	int ret;
 	u64 search_start = 0;
 
-	data = btrfs_get_alloc_profile(root, data);
+	flags = btrfs_get_alloc_profile(root, flags);
 again:
 	/*
 	 * the only place that sets empty_size is btrfs_realloc_node, which
@@ -5417,28 +5417,28 @@ again:
 	 */
 	if (empty_size || root->ref_cows)
 		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-				     num_bytes + 2 * 1024 * 1024, data,
+				     num_bytes + 2 * 1024 * 1024, flags,
 				     CHUNK_ALLOC_NO_FORCE);
 
 	WARN_ON(num_bytes < root->sectorsize);
 	ret = find_free_extent(trans, root, num_bytes, empty_size,
 			       search_start, search_end, hint_byte,
-			       ins, data);
+			       ins, flags);
 
 	if (ret == -ENOSPC && num_bytes > min_alloc_size) {
 		num_bytes = num_bytes >> 1;
 		num_bytes = num_bytes & ~(root->sectorsize - 1);
 		num_bytes = max(num_bytes, min_alloc_size);
 		do_chunk_alloc(trans, root->fs_info->extent_root,
-			       num_bytes, data, CHUNK_ALLOC_FORCE);
+			       num_bytes, flags, CHUNK_ALLOC_FORCE);
 		goto again;
 	}
 	if (ret == -ENOSPC && btrfs_test_opt(root, ENOSPC_DEBUG)) {
 		struct btrfs_space_info *sinfo;
 
-		sinfo = __find_space_info(root->fs_info, data);
+		sinfo = __find_space_info(root->fs_info, flags);
 		printk(KERN_ERR "btrfs allocation failed flags %llu, "
-		       "wanted %llu\n", (unsigned long long)data,
+		       "wanted %llu\n", (unsigned long long)flags,
 		       (unsigned long long)num_bytes);
 		dump_space_info(sinfo, num_bytes, 1);
 	}
-- 
1.7.6

