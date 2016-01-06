Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41917 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbcAFW7G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jan 2016 17:59:06 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix regression that makes fitrim ioctl discard a device's MBR
Date: Wed,  6 Jan 2016 22:57:11 +0000
Message-Id: <1452121064-15594-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

As of the 4.3 kernel release, the fitrim ioctl can now discard any region
of a disk that is not part of a chunk/block group, including the MBR
(master boot record).
Fix this by not allowing to trim/discard any region in the device starting
with an offset not greater than min(alloc_start_mount_option, 1Mb), just
as we did for space allocated to chunks/block groups.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=109341
Fixes: 499f377f49f0 (btrfs: iterate over unused chunk space in FITRIM)
Cc: stable@vger.kernel.org # 4.3+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c |  7 +++----
 fs/btrfs/volumes.c     | 38 ++++++++++++++------------------------
 fs/btrfs/volumes.h     |  5 +----
 3 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index cf8983e..7af2f03 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9482,8 +9482,8 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 		 */
 		if (device->total_bytes > device->bytes_used + min_free &&
 		    !device->is_tgtdev_for_dev_replace) {
-			ret = find_free_dev_extent(trans, device, min_free,
-						   &dev_offset, NULL);
+			ret = find_free_dev_extent(trans->transaction, device,
+						   min_free, &dev_offset, NULL);
 			if (!ret)
 				dev_nr++;
 
@@ -10677,8 +10677,7 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 			atomic_inc(&trans->use_count);
 		spin_unlock(&fs_info->trans_lock);
 
-		ret = find_free_dev_extent_start(trans, device, minlen, start,
-						 &start, &len);
+		ret = find_free_dev_extent(trans, device, minlen, &start, &len);
 		if (trans)
 			btrfs_put_transaction(trans);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a114b7b..207f077 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1222,10 +1222,9 @@ again:
 
 
 /*
- * find_free_dev_extent_start - find free space in the specified device
+ * find_free_dev_extent - find free space in the specified device
  * @device:	  the device which we search the free space in
  * @num_bytes:	  the size of the free space that we need
- * @search_start: the position from which to begin the search
  * @start:	  store the start of the free space.
  * @len:	  the size of the free space. that we find, or the size
  *		  of the max free space if we don't find suitable free space
@@ -1242,9 +1241,9 @@ again:
  * But if we don't find suitable free space, it is used to store the size of
  * the max free space.
  */
-int find_free_dev_extent_start(struct btrfs_transaction *transaction,
-			       struct btrfs_device *device, u64 num_bytes,
-			       u64 search_start, u64 *start, u64 *len)
+int find_free_dev_extent(struct btrfs_transaction *transaction,
+			 struct btrfs_device *device, u64 num_bytes,
+			 u64 *start, u64 *len)
 {
 	struct btrfs_key key;
 	struct btrfs_root *root = device->dev_root;
@@ -1258,6 +1257,15 @@ int find_free_dev_extent_start(struct btrfs_transaction *transaction,
 	int ret;
 	int slot;
 	struct extent_buffer *l;
+	u64 search_start;
+
+	/* FIXME use last free of some kind */
+
+	/*
+	 * we don't want to overwrite the superblock on the drive (nor the MBR
+	 * sector), so we make sure to start at an offset of at least 1MB
+	 */
+	search_start = max(root->fs_info->alloc_start, 1024ull * 1024);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -1394,24 +1402,6 @@ out:
 	return ret;
 }
 
-int find_free_dev_extent(struct btrfs_trans_handle *trans,
-			 struct btrfs_device *device, u64 num_bytes,
-			 u64 *start, u64 *len)
-{
-	struct btrfs_root *root = device->dev_root;
-	u64 search_start;
-
-	/* FIXME use last free of some kind */
-
-	/*
-	 * we don't want to overwrite the superblock on the drive,
-	 * so we make sure to start at an offset of at least 1MB
-	 */
-	search_start = max(root->fs_info->alloc_start, 1024ull * 1024);
-	return find_free_dev_extent_start(trans->transaction, device,
-					  num_bytes, search_start, start, len);
-}
-
 static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
 			  struct btrfs_device *device,
 			  u64 start, u64 *dev_extent_len)
@@ -4597,7 +4587,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		if (total_avail == 0)
 			continue;
 
-		ret = find_free_dev_extent(trans, device,
+		ret = find_free_dev_extent(trans->transaction, device,
 					   max_stripe_size * dev_stripes,
 					   &dev_offset, &max_avail);
 		if (ret && ret != -ENOSPC)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6a4375a..9db9261 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -472,10 +472,7 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
 int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info);
 int btrfs_check_uuid_tree(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
-int find_free_dev_extent_start(struct btrfs_transaction *transaction,
-			 struct btrfs_device *device, u64 num_bytes,
-			 u64 search_start, u64 *start, u64 *max_avail);
-int find_free_dev_extent(struct btrfs_trans_handle *trans,
+int find_free_dev_extent(struct btrfs_transaction *transaction,
 			 struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
 void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index);
-- 
2.1.3

