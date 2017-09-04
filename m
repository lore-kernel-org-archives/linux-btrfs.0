Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51860 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752064AbdIDGlW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 02:41:22 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/5] btrfs-progs: mkfs: Shrink the image for rootdir to minimal size
Date: Mon,  4 Sep 2017 15:41:08 +0900
Message-Id: <20170904064110.25951-4-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
References: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Follow the original rootdir behavior to shrink the device size to
minimal.

The shrink itself is very simple, since dev extent is allocated on
demand, we just need to shrink the device size to the device extent end
position.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 mkfs/main.c | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index bca836b5..c43ce18d 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -990,6 +990,107 @@ fail_no_dir:
 	goto out;
 }
 
+/*
+ * Shrink the image to its minimal size.
+ *
+ * The work is quite easy, as btrfs only allocates dev extent/chunk on demand.
+ * So we only need to do:
+ * 1) Determine the minimal image size
+ *    By checking the device extent end
+ * 2) Modify in-memory device size
+ * 3) Modify device item
+ * 4) Modify superblock
+ */
+static int shrink_image(struct btrfs_trans_handle *trans,
+			struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *dev_root = fs_info->dev_root;
+	struct btrfs_root *chunk_root = fs_info->chunk_root;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_dev_extent *de;
+	struct btrfs_dev_item *di;
+	struct btrfs_device *dev;
+	u64 min_size;
+	int ret = 0;
+
+	/*
+	 * New rootdir can support multi device easily, but since only one
+	 * device is supported, devid is fixed to 1.
+	 */
+	key.objectid = 1;
+	key.type = BTRFS_DEV_EXTENT_KEY;
+	key.offset = (u64)-1;
+	btrfs_init_path(&path);
+
+	/*
+	 * Determine minimal fs size by find the end position of last dev extent
+	 */
+	ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
+	if (ret == 0) {
+		WARN_ON(1);
+		ret = -EIO;
+		goto out_release;
+	}
+	if (ret < 0)
+		goto out_release;
+
+	ret = btrfs_previous_item(dev_root, &path, key.objectid,
+				  BTRFS_DEV_EXTENT_KEY);
+	if (ret < 0)
+		goto out_release;
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out_release;
+	}
+	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+	de = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_dev_extent);
+	min_size = key.offset + btrfs_dev_extent_length(path.nodes[0], de);
+	btrfs_release_path(&path);
+
+	/*
+	 * Modify btrfs_device size
+	 */
+	dev = list_entry(fs_info->fs_devices->devices.next,
+			 struct btrfs_device, dev_list);
+	if (!dev) {
+		WARN_ON(1);
+		ret = -ENOENT;
+		goto out;
+	}
+	dev->total_bytes = min_size;
+
+	/*
+	 * Modify dev item size
+	 */
+	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
+	key.type = BTRFS_DEV_ITEM_KEY;
+	key.offset = 1;
+
+	ret = btrfs_search_slot(trans, chunk_root, &key, &path, 0, 1);
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out_release;
+	}
+	if (ret < 0)
+		goto out_release;
+	di = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_dev_item);
+	btrfs_set_device_total_bytes(path.nodes[0], di, min_size);
+	btrfs_release_path(&path);
+
+	/*
+	 * Modify superblock size
+	 */
+	btrfs_set_super_total_bytes(fs_info->super_copy, min_size);
+
+out_release:
+	btrfs_release_path(&path);
+out:
+	return ret;
+}
+
 static int make_image(const char *source_dir, struct btrfs_root *root)
 {
 	int ret;
@@ -1013,6 +1114,12 @@ static int make_image(const char *source_dir, struct btrfs_root *root)
 		error("unable to traverse directory %s: %d", source_dir, ret);
 		goto fail;
 	}
+
+	ret = shrink_image(trans, root->fs_info);
+	if (ret < 0) {
+		error("failed to shrink image: %d", ret);
+		goto out;
+	}
 	ret = btrfs_commit_transaction(trans, root);
 	if (ret) {
 		error("transaction commit failed: %d", ret);
-- 
2.14.1

