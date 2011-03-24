From: Li Dongyang <lidongyang@novell.com>
Subject: [PATCH V4 1/4] Btrfs: make update_reserved_bytes() public
Date: Thu, 24 Mar 2011 18:24:25 +0800
Message-ID: <1300962268-12774-2-git-send-email-lidongyang@novell.com>
References: <1300962268-12774-1-git-send-email-lidongyang@novell.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300962268-12774-1-git-send-email-lidongyang@novell.com>
List-ID: <linux-btrfs.vger.kernel.org>

Make the function public as we should update the reserved extents calculations
after taking out an extent for trimming.

Signed-off-by: Li Dongyang <lidongyang@novell.com>
---
 fs/btrfs/ctree.h        |    2 ++
 fs/btrfs/extent-tree.c  |   16 +++++++---------
 2 files changed, 9 insertions(+), 9 deletions(-)
 create mode 100644 fs/btrfs/Module.symvers

diff --git a/fs/btrfs/Module.symvers b/fs/btrfs/Module.symvers
new file mode 100644
index 0000000..e69de29
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7f78cc7..2c84551 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2157,6 +2157,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      u64 root_objectid, u64 owner, u64 offset);
 
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
+int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
+				u64 num_bytes, int reserve, int sinfo);
 int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7b3089b..caa4254 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -36,8 +36,6 @@
 static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc);
-static int update_reserved_bytes(struct btrfs_block_group_cache *cache,
-				 u64 num_bytes, int reserve, int sinfo);
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 parent,
@@ -4223,8 +4221,8 @@ int btrfs_pin_extent(struct btrfs_root *root,
  * update size of reserved extents. this function may return -EAGAIN
  * if 'reserve' is true or 'sinfo' is false.
  */
-static int update_reserved_bytes(struct btrfs_block_group_cache *cache,
-				 u64 num_bytes, int reserve, int sinfo)
+int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
+				u64 num_bytes, int reserve, int sinfo)
 {
 	int ret = 0;
 	if (sinfo) {
@@ -4704,10 +4702,10 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->bflags));
 
 		btrfs_add_free_space(cache, buf->start, buf->len);
-		ret = update_reserved_bytes(cache, buf->len, 0, 0);
+		ret = btrfs_update_reserved_bytes(cache, buf->len, 0, 0);
 		if (ret == -EAGAIN) {
 			/* block group became read-only */
-			update_reserved_bytes(cache, buf->len, 0, 1);
+			btrfs_update_reserved_bytes(cache, buf->len, 0, 1);
 			goto out;
 		}
 
@@ -5191,7 +5189,7 @@ checks:
 					     search_start - offset);
 		BUG_ON(offset > search_start);
 
-		ret = update_reserved_bytes(block_group, num_bytes, 1,
+		ret = btrfs_update_reserved_bytes(block_group, num_bytes, 1,
 					    (data & BTRFS_BLOCK_GROUP_DATA));
 		if (ret == -EAGAIN) {
 			btrfs_add_free_space(block_group, offset, num_bytes);
@@ -5415,7 +5413,7 @@ int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
 	ret = btrfs_discard_extent(root, start, len);
 
 	btrfs_add_free_space(cache, start, len);
-	update_reserved_bytes(cache, len, 0, 1);
+	btrfs_update_reserved_bytes(cache, len, 0, 1);
 	btrfs_put_block_group(cache);
 
 	return ret;
@@ -5614,7 +5612,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 		put_caching_control(caching_ctl);
 	}
 
-	ret = update_reserved_bytes(block_group, ins->offset, 1, 1);
+	ret = btrfs_update_reserved_bytes(block_group, ins->offset, 1, 1);
 	BUG_ON(ret);
 	btrfs_put_block_group(block_group);
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
-- 
1.7.4.1

