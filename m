Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50438 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754700AbdJJHv1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 03:51:27 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yoasif@gmail.com, rrauenza@gmail.com
Subject: [PATCH 1/4] btrfs-progs: Introduce functions to repair unaligned/mismatch device size
Date: Tue, 10 Oct 2017 07:51:10 +0000
Message-Id: <20171010075113.10718-2-quwenruo.btrfs@gmx.com>
In-Reply-To: <20171010075113.10718-1-quwenruo.btrfs@gmx.com>
References: <20171010075113.10718-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces functions to repair device size related problems,
including:
1) Unaligned total_bytes of dev_item
   v4.14-rc kernel introduced total_bytes alignment checker.
   However older kernel device add/shrink doesn't align these members.
   This will cause kernel warning every time dev_item get updated.

   Although it can be fixed by shrinking device on latest kernel or
   use manually aligned size on older kernel, a fallback method in
   btrfs-progs won't hurt.

2) Mismatch super->total_bytes
   There are some reports about unmountable fs, due to mismatched
   super->total_bytes.
   And normal kernel device shrink won't help since it only modify the
   total_bytes by the size changed, not re-calculating it.

   The root cause is still under investigation, but at least to fix it
   in btrfs-progs

Fix all of them by manually rounding down total_bytes of each device, and
recalculate super->total_bytes using all existing devices.

Reported-by: Asif Youssuff <yoasif@gmail.com>
Reported-by: Rich Rauenzahn <rrauenza@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 cmds-check.c | 191 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 191 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 0c08618ed701..007781fa5d1b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12885,6 +12885,197 @@ close_out:
 	return ret;
 }
 
+/*
+ * Return 0 if DEV_ITEM for @device is good
+ * Return >0 if DEV_ITEM for @device has unaligned value and fixed
+ * Return <0 if we failed to fix the unaligned value
+ */
+static int reset_one_dev_size(struct btrfs_fs_info *fs_info,
+			       struct btrfs_device *device)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct btrfs_root *chunk_root = fs_info->chunk_root;
+	struct btrfs_dev_item *di;
+	u64 old_bytes = device->total_bytes;
+	int ret;
+
+	if (IS_ALIGNED(device->total_bytes, fs_info->sectorsize))
+		return 0;
+
+	/* Align the in-memory total_bytes first, and use it later */
+	device->total_bytes = round_down(device->total_bytes,
+					 fs_info->sectorsize);
+
+	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
+	key.type = BTRFS_DEV_ITEM_KEY;
+	key.offset = device->devid;
+
+	trans = btrfs_start_transaction(chunk_root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("error starting transaction:  %d (%s)",
+		      ret, strerror(-ret));
+		return ret;
+	}
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(trans, chunk_root, &key, &path, 0, 1);
+	if (ret > 0) {
+		error("failed to find DEV_ITEM for devid %llu",
+			device->devid);
+		ret = -ENOENT;
+		goto err;
+	}
+	if (ret < 0) {
+		error("failed to search chunk root: %d (%s)",
+			ret, strerror(-ret));
+		goto err;
+	}
+	di = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_dev_item);
+	btrfs_set_device_total_bytes(path.nodes[0], di, device->total_bytes);
+	btrfs_mark_buffer_dirty(path.nodes[0]);
+	ret = btrfs_commit_transaction(trans, chunk_root);
+	if (ret < 0) {
+		error("failed to commit current transaction: %d (%s)",
+			ret, strerror(-ret));
+		btrfs_release_path(&path);
+		return ret;
+	}
+	btrfs_release_path(&path);
+	printf("Fixed device size for devid %llu, old size: %llu new size: %llu\n",
+		device->devid, old_bytes, device->total_bytes);
+	return 1;
+
+err:
+	/* We haven't modified anything, it's OK to commit current trans */
+	btrfs_commit_transaction(trans, chunk_root);
+	btrfs_release_path(&path);
+	return ret;
+}
+
+/*
+ * Return 0 if super block total bytes matches with device total_bytes
+ * Return >0 if super block has mismatch total_bytes and fixed
+ * Return <0 if we failed to fix the mismatch total_bytes
+ */
+static int reset_super_total_bytes(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_device *device;
+	struct list_head *dev_list = &fs_info->fs_devices->devices;
+	u64 total_bytes = 0;
+	u64 old_bytes = btrfs_super_total_bytes(fs_info->super_copy);
+	int ret;
+
+	list_for_each_entry(device, dev_list, dev_list)
+		total_bytes += device->total_bytes;
+
+	if (total_bytes == old_bytes)
+		return 0;
+
+	/* Just in case */
+	if (!IS_ALIGNED(total_bytes, fs_info->sectorsize)) {
+		error("final total_bytes still not aligned to %u, please report a bug to btrfs mail list",
+			fs_info->sectorsize);
+		return -EUCLEAN;
+	}
+
+	btrfs_set_super_total_bytes(fs_info->super_copy, total_bytes);
+
+	/* Commit transaction to update all super blocks */
+	trans = btrfs_start_transaction(fs_info->tree_root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("error starting transaction:  %d (%s)",
+		      ret, strerror(-ret));
+		return ret;
+	}
+	ret = btrfs_commit_transaction(trans, fs_info->tree_root);
+	if (ret < 0) {
+		error("failed to commit current transaction: %d (%s)",
+			ret, strerror(-ret));
+		return ret;
+	}
+	printf("Fixed super total bytes, old size: %llu new size: %llu\n",
+		old_bytes, total_bytes);
+	return 1;
+}
+
+/*
+ * Repair device size related problems, including:
+ * 1) Unaligned total_bytes of dev_item
+ *    v4.14-rc kernel introduced total_bytes alignment checker.
+ *    However older kernel device add/shrink doesn't restrictly align
+ *    these members.
+ *    This will cause kernel warning everytime dev_item get updated.
+ *
+ *    Although it can be fixed by shrinking device on latest kernel or
+ *    use manually aligned size on older kernel, a fallback method in
+ *    btrfs-progs won't hurt.
+ *
+ * 2) Mismatch super->total_bytes
+ *    Due to similar situation, super->total_bytes can be mismatch with
+ *    total size of all devices.
+ *    This will cause the filesystem unable to be mounted with v4.14-rc kernel.
+ *
+ *    Add such fixer in btrfs-progs as a fallback method.
+ *
+ * Fix all of them by manually rounding down total_bytes of each device, and
+ * recalculate super->total_bytes using all existing devices.
+ */
+static int reset_devs_size(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_device *device;
+	struct list_head *dev_list = &fs_info->fs_devices->devices;
+	bool have_bad_value = false;
+	int ret;
+
+	/* Seed device is not support yet */
+	if (fs_info->fs_devices->seed) {
+		error("resetting device size with seed device is not supported yet");
+		return -ENOTTY;
+	}
+
+	/* All devices must be on-line before reparing */
+	if (list_empty(dev_list)) {
+		error("no device found");
+		return -ENODEV;
+	}
+	list_for_each_entry(device, dev_list, dev_list) {
+		if (device->fd == -1 || !device->writeable) {
+			error("device with devid %llu is missing or not writeable",
+			      device->devid);
+			error("resetting device size needs all device(s) present and writeable");
+			return -ENODEV;
+		}
+	}
+
+	/* Repair total_bytes of each device */
+	list_for_each_entry(device, dev_list, dev_list) {
+		ret = reset_one_dev_size(fs_info, device);
+		if (ret < 0)
+			return ret;
+		if (ret > 0)
+			have_bad_value = true;
+	}
+
+	/* Repair super total_byte */
+	ret = reset_super_total_bytes(fs_info);
+	if (ret > 0)
+		have_bad_value = true;
+	if (have_bad_value) {
+		printf("Fixed unaligned/mismatch total_bytes for superblock and device item\n");
+		ret = 1;
+	} else {
+		printf("No device size related problem found\n");
+		ret = 0;
+	}
+	return ret;
+}
+
 const char * const cmd_check_usage[] = {
 	"btrfs check [options] <device>",
 	"Check structural integrity of a filesystem (unmounted).",
-- 
2.14.2

