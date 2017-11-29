Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:55493 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753778AbdK2JQT (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 29 Nov 2017 04:16:19 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 4/9] btrfs-progs: mkfs/rootdir: Shrink fs for rootdir option
Date: Wed, 29 Nov 2017 17:15:59 +0800
Message-Id: <20171129091604.2194-5-wqu@suse.com>
In-Reply-To: <20171129091604.2194-1-wqu@suse.com>
References: <20171129091604.2194-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the new dev extent based shrink method for rootdir option.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c    |   5 +++
 mkfs/rootdir.c | 111 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/rootdir.h |   1 +
 3 files changed, 117 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index eb49182ebe81..eb3e5bb1f92e 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1256,6 +1256,11 @@ raid_groups:
 				goto out;
 			}
 		}
+		ret = btrfs_mkfs_shrink_fs(fs_info, NULL);
+		if (ret < 0) {
+			error("error while shrinking filesystem: %d", ret);
+			goto out;
+		}
 	}
 
 	if (verbose) {
diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index f8cff44d06eb..271167fe0c02 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -822,3 +822,114 @@ out:
 
 	return ret;
 }
+
+/*
+ * Set device size to @new_size.
+ *
+ * Only used for --rootdir option.
+ * We will need to reset the following values:
+ * 1) dev item in chunk tree
+ * 2) super->dev_item
+ * 3) super->total_bytes
+ */
+static int set_device_size(struct btrfs_fs_info *fs_info,
+			   struct btrfs_device *device, u64 new_size)
+{
+	struct btrfs_root *chunk_root = fs_info->chunk_root;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_dev_item *di;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	int ret;
+
+	/*
+	 * Update in-meory device->total_bytes, so that at trans commit time,
+	 * it super->dev_item will also get updated
+	 */
+	device->total_bytes = new_size;
+	btrfs_init_path(&path);
+
+	/* Update device item in chunk tree */
+	trans = btrfs_start_transaction(chunk_root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("failed to start transaction: %d (%s)", ret,
+			strerror(-ret));
+		return ret;
+	}
+	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
+	key.type = BTRFS_DEV_ITEM_KEY;
+	key.offset = device->devid;
+
+	ret = btrfs_search_slot(trans, chunk_root, &key, &path, 0, 1);
+	if (ret < 0)
+		goto err;
+	if (ret > 0)
+		ret = -ENOENT;
+	di = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_dev_item);
+	btrfs_set_device_total_bytes(path.nodes[0], di, new_size);
+	btrfs_mark_buffer_dirty(path.nodes[0]);
+
+	/*
+	 * Update super->total_bytes, since it's only used for --rootdir,
+	 * there is only one device, just use the @new_size.
+	 */
+	btrfs_set_super_total_bytes(fs_info->super_copy, new_size);
+
+	/*
+	 * Commit transaction to reflect the updated super->total_bytes and
+	 * super->dev_item
+	 */
+	ret = btrfs_commit_transaction(trans, chunk_root);
+	if (ret < 0)
+		error("failed to commit current transaction: %d (%s)",
+			ret, strerror(-ret));
+	btrfs_release_path(&path);
+	return ret;
+
+err:
+	btrfs_release_path(&path);
+	/*
+	 * Commit trans here won't cause problem since the fs still has
+	 * bad magic, and something wrong already happened, we don't
+	 * care the return value anyway.
+	 */
+	btrfs_commit_transaction(trans, chunk_root);
+	return ret;
+}
+
+int btrfs_mkfs_shrink_fs(struct btrfs_fs_info *fs_info, u64 *new_size_ret)
+{
+	u64 new_size;
+	struct btrfs_device *device;
+	struct list_head *cur;
+	int nr_devs = 0;
+	int ret;
+
+	list_for_each(cur, &fs_info->fs_devices->devices)
+		nr_devs++;
+
+	if (nr_devs > 1) {
+		error("cannot shrink fs with more than 1 device");
+		return -ENOTTY;
+	}
+
+	ret = get_device_extent_end(fs_info, 1, &new_size);
+	if (ret < 0) {
+		error("failed to get minimal device size: %d (%s)",
+			ret, strerror(-ret));
+		return ret;
+	}
+
+	BUG_ON(!IS_ALIGNED(new_size, fs_info->sectorsize));
+
+	device = list_entry(fs_info->fs_devices->devices.next,
+			   struct btrfs_device, dev_list);
+	ret = set_device_size(fs_info, device, new_size);
+	if (ret < 0)
+		return ret;
+	if (new_size_ret)
+		*new_size_ret = new_size;
+	return ret;
+}
diff --git a/mkfs/rootdir.h b/mkfs/rootdir.h
index ada50ccb6ac4..91bebc507f02 100644
--- a/mkfs/rootdir.h
+++ b/mkfs/rootdir.h
@@ -32,4 +32,5 @@ int btrfs_mkfs_fill_dir(const char *source_dir, struct btrfs_root *root,
 			bool verbose);
 u64 btrfs_mkfs_size_dir(const char *dir_name, u32 sectorsize, u64 min_dev_size,
 			u64 meta_profile, u64 data_profile);
+int btrfs_mkfs_shrink_fs(struct btrfs_fs_info *fs_info, u64 *new_size_ret);
 #endif
-- 
2.15.0

