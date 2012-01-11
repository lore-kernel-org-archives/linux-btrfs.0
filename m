From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 06/11] Btrfs: don't pass a trans handle unnecessarily in volumes.c
Date: Wed, 11 Jan 2012 13:53:35 +0800
Message-ID: <4F0D23DF.4000608@cn.fujitsu.com>
References: <4F0D236E.2010306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F0D236E.2010306@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Some functions never use the transaction handle passed to them.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/volumes.c     |   18 +++++++-----------
 fs/btrfs/volumes.h     |    3 +--
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8603ee4..5b53479 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7084,7 +7084,7 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 		 * space to fit our block group in.
 		 */
 		if (device->total_bytes > device->bytes_used + min_free) {
-			ret = find_free_dev_extent(NULL, device, min_free,
+			ret = find_free_dev_extent(device, min_free,
 						   &dev_offset, NULL);
 			if (!ret)
 				dev_nr++;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f4b839f..73f673c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -829,7 +829,6 @@ out:
 
 /*
  * find_free_dev_extent - find free space in the specified device
- * @trans:	transaction handler
  * @device:	the device which we search the free space in
  * @num_bytes:	the size of the free space that we need
  * @start:	store the start of the free space.
@@ -848,8 +847,7 @@ out:
  * But if we don't find suitable free space, it is used to store the size of
  * the max free space.
  */
-int find_free_dev_extent(struct btrfs_trans_handle *trans,
-			 struct btrfs_device *device, u64 num_bytes,
+int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *len)
 {
 	struct btrfs_key key;
@@ -893,7 +891,7 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
 	key.offset = search_start;
 	key.type = BTRFS_DEV_EXTENT_KEY;
 
-	ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
 	if (ret > 0) {
@@ -1469,8 +1467,7 @@ error_undo:
 /*
  * does all the dirty work required for changing file system's UUID.
  */
-static int btrfs_prepare_sprout(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root)
+static int btrfs_prepare_sprout(struct btrfs_root *root)
 {
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 	struct btrfs_fs_devices *old_devices;
@@ -1695,7 +1692,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 
 	if (seeding_dev) {
 		sb->s_flags &= ~MS_RDONLY;
-		ret = btrfs_prepare_sprout(trans, root);
+		ret = btrfs_prepare_sprout(root);
 		BUG_ON(ret);
 	}
 
@@ -2323,8 +2320,7 @@ done:
 	return ret;
 }
 
-static int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
+static int btrfs_add_system_chunk(struct btrfs_root *root,
 			   struct btrfs_key *key,
 			   struct btrfs_chunk *chunk, int item_size)
 {
@@ -2496,7 +2492,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		if (total_avail == 0)
 			continue;
 
-		ret = find_free_dev_extent(trans, device,
+		ret = find_free_dev_extent(device,
 					   max_stripe_size * dev_stripes,
 					   &dev_offset, &max_avail);
 		if (ret && ret != -ENOSPC)
@@ -2687,7 +2683,7 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
 	BUG_ON(ret);
 
 	if (map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
-		ret = btrfs_add_system_chunk(trans, chunk_root, &key, chunk,
+		ret = btrfs_add_system_chunk(chunk_root, &key, chunk,
 					     item_size);
 		BUG_ON(ret);
 	}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 78f2d4d..c1701ec 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -230,7 +230,6 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_balance(struct btrfs_root *dev_root);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
-int find_free_dev_extent(struct btrfs_trans_handle *trans,
-			 struct btrfs_device *device, u64 num_bytes,
+int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
 #endif
-- 
1.7.3.1
