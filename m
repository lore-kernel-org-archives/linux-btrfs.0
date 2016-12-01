Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57097 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750775AbcLAR2i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Dec 2016 12:28:38 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9338DAABE
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Dec 2016 17:28:36 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] btrfs-progs: find_free_dev_extent() closer to kernel code
Date: Thu,  1 Dec 2016 11:28:33 -0600
Message-Id: <20161201172833.1199-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This solves an ENOSPC issue with nearly full filesystems.

The only things missing from the function is contains_pending_extent()
which should not be required in this case.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 volumes.c | 191 +++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 119 insertions(+), 72 deletions(-)

diff --git a/volumes.c b/volumes.c
index 5d770e5..a0a85ed 100644
--- a/volumes.c
+++ b/volumes.c
@@ -276,53 +276,79 @@ int btrfs_scan_one_device(int fd, const char *path,
 }
 
 /*
+ * find_free_dev_extent_start - find free space in the specified device
+ * @device:	  the device which we search the free space in
+ * @num_bytes:	  the size of the free space that we need
+ * @search_start: the position from which to begin the search
+ * @start:	  store the start of the free space.
+ * @len:	  the size of the free space. that we find, or the size
+ *		  of the max free space if we don't find suitable free space
+ *
  * this uses a pretty simple search, the expectation is that it is
  * called very infrequently and that a given device has a small number
  * of extents
+ *
+ * @start is used to store the start of the free space if we find. But if we
+ * don't find suitable free space, it will be used to store the start position
+ * of the max free space.
+ *
+ * @len is used to store the size of the free space that we find.
+ * But if we don't find suitable free space, it is used to store the size of
+ * the max free space.
  */
-static int find_free_dev_extent(struct btrfs_trans_handle *trans,
-				struct btrfs_device *device,
-				struct btrfs_path *path,
-				u64 num_bytes, u64 *start)
+static int find_free_dev_extent_start(struct btrfs_trans_handle *trans,
+			       struct btrfs_device *device, u64 num_bytes,
+			       u64 search_start, u64 *start, u64 *len)
 {
 	struct btrfs_key key;
 	struct btrfs_root *root = device->dev_root;
-	struct btrfs_dev_extent *dev_extent = NULL;
-	u64 hole_size = 0;
-	u64 last_byte = 0;
-	u64 search_start = root->fs_info->alloc_start;
+	struct btrfs_dev_extent *dev_extent;
+	struct btrfs_path *path;
+	u64 hole_size;
+	u64 max_hole_start;
+	u64 max_hole_size;
+	u64 extent_end;
 	u64 search_end = device->total_bytes;
 	int ret;
-	int slot = 0;
-	int start_found;
+	int slot;
 	struct extent_buffer *l;
+	u64 min_search_start;
 
-	start_found = 0;
-	path->reada = 2;
+	/*
+	 * We don't want to overwrite the superblock on the drive nor any area
+	 * used by the boot loader (grub for example), so we make sure to start
+	 * at an offset of at least 1MB.
+	 */
+	min_search_start = max(root->fs_info->alloc_start, 1024ull * 1024);
+	search_start = max(search_start, min_search_start);
 
-	/* FIXME use last free of some kind */
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
-	/* we don't want to overwrite the superblock on the drive,
-	 * so we make sure to start at an offset of at least 1MB
-	 */
-	search_start = max(BTRFS_BLOCK_RESERVED_1M_FOR_SUPER, search_start);
+	max_hole_start = search_start;
+	max_hole_size = 0;
 
 	if (search_start >= search_end) {
 		ret = -ENOSPC;
-		goto error;
+		goto out;
 	}
 
+	path->reada = 2;
+
 	key.objectid = device->devid;
 	key.offset = search_start;
 	key.type = BTRFS_DEV_EXTENT_KEY;
-	ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
-	if (ret < 0)
-		goto error;
-	ret = btrfs_previous_item(root, path, 0, key.type);
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
-		goto error;
-	l = path->nodes[0];
-	btrfs_item_key_to_cpu(l, &key, path->slots[0]);
+		goto out;
+	if (ret > 0) {
+		ret = btrfs_previous_item(root, path, key.objectid, key.type);
+		if (ret < 0)
+			goto out;
+	}
+
 	while (1) {
 		l = path->nodes[0];
 		slot = path->slots[0];
@@ -331,24 +357,9 @@ static int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			if (ret == 0)
 				continue;
 			if (ret < 0)
-				goto error;
-no_more_items:
-			if (!start_found) {
-				if (search_start >= search_end) {
-					ret = -ENOSPC;
-					goto error;
-				}
-				*start = search_start;
-				start_found = 1;
-				goto check_pending;
-			}
-			*start = last_byte > search_start ?
-				last_byte : search_start;
-			if (search_end <= *start) {
-				ret = -ENOSPC;
-				goto error;
-			}
-			goto check_pending;
+				goto out;
+
+			break;
 		}
 		btrfs_item_key_to_cpu(l, &key, slot);
 
@@ -356,49 +367,85 @@ no_more_items:
 			goto next;
 
 		if (key.objectid > device->devid)
-			goto no_more_items;
-
-		if (key.offset >= search_start && key.offset > last_byte &&
-		    start_found) {
-			if (last_byte < search_start)
-				last_byte = search_start;
-			hole_size = key.offset - last_byte;
-			if (key.offset > last_byte &&
-			    hole_size >= num_bytes) {
-				*start = last_byte;
-				goto check_pending;
-			}
-		}
-		if (key.type != BTRFS_DEV_EXTENT_KEY) {
+			break;
+
+		if (key.type != BTRFS_DEV_EXTENT_KEY)
 			goto next;
+
+		if (key.offset > search_start) {
+			hole_size = key.offset - search_start;
+
+			/*
+			 * Have to check before we set max_hole_start, otherwise
+			 * we could end up sending back this offset anyway.
+			 */
+			if (hole_size > max_hole_size) {
+				max_hole_start = search_start;
+				max_hole_size = hole_size;
+			}
+
+			/*
+			 * If this free space is greater than which we need,
+			 * it must be the max free space that we have found
+			 * until now, so max_hole_start must point to the start
+			 * of this free space and the length of this free space
+			 * is stored in max_hole_size. Thus, we return
+			 * max_hole_start and max_hole_size and go back to the
+			 * caller.
+			 */
+			if (hole_size >= num_bytes) {
+				ret = 0;
+				goto out;
+			}
 		}
 
-		start_found = 1;
 		dev_extent = btrfs_item_ptr(l, slot, struct btrfs_dev_extent);
-		last_byte = key.offset + btrfs_dev_extent_length(l, dev_extent);
+		extent_end = key.offset + btrfs_dev_extent_length(l,
+								  dev_extent);
+		if (extent_end > search_start)
+			search_start = extent_end;
 next:
 		path->slots[0]++;
 		cond_resched();
 	}
-check_pending:
-	/* we have to make sure we didn't find an extent that has already
-	 * been allocated by the map tree or the original allocation
+
+	/*
+	 * At this point, search_start should be the end of
+	 * allocated dev extents, and when shrinking the device,
+	 * search_end may be smaller than search_start.
 	 */
-	btrfs_release_path(path);
-	BUG_ON(*start < search_start);
+	if (search_end > search_start) {
+		hole_size = search_end - search_start;
 
-	if (*start + num_bytes > search_end) {
-		ret = -ENOSPC;
-		goto error;
+		if (hole_size > max_hole_size) {
+			max_hole_start = search_start;
+			max_hole_size = hole_size;
+		}
 	}
-	/* check for pending inserts here */
-	return 0;
 
-error:
-	btrfs_release_path(path);
+	/* See above. */
+	if (max_hole_size < num_bytes)
+		ret = -ENOSPC;
+	else
+		ret = 0;
+
+out:
+	btrfs_free_path(path);
+	*start = max_hole_start;
+	if (len)
+		*len = max_hole_size;
 	return ret;
 }
 
+int find_free_dev_extent(struct btrfs_trans_handle *trans,
+			 struct btrfs_device *device, u64 num_bytes,
+			 u64 *start)
+{
+	/* FIXME use last free of some kind */
+	return find_free_dev_extent_start(trans, device,
+					  num_bytes, 0, start, NULL);
+}
+
 static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 				  struct btrfs_device *device,
 				  u64 chunk_tree, u64 chunk_objectid,
@@ -421,7 +468,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	 * is responsible to make sure it's free.
 	 */
 	if (!convert) {
-		ret = find_free_dev_extent(trans, device, path, num_bytes,
+		ret = find_free_dev_extent(trans, device, num_bytes,
 					   start);
 		if (ret)
 			goto err;
-- 
2.10.2

