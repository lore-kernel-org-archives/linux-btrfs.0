Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64777 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755157AbdJJHv2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 03:51:28 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yoasif@gmail.com, rrauenza@gmail.com
Subject: [PATCH 3/4] btrfs-progs: check: Also check unalignment/mismatch device and super size
Date: Tue, 10 Oct 2017 07:51:12 +0000
Message-Id: <20171010075113.10718-4-quwenruo.btrfs@gmx.com>
In-Reply-To: <20171010075113.10718-1-quwenruo.btrfs@gmx.com>
References: <20171010075113.10718-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Along with the fix introduced, also introduce check for them.
Unlike normal check funtions, some of the check is optional, and even if
the image failed to pass optional check, kernel can still run fine.
(But may cause noisy kernel warning)

So some check, mainly for alignment, will not cause btrfs check to fail,
but only to output warning and how to fix it.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 cmds-check.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index fdb6d832eee1..23dd3b51102b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9879,6 +9879,67 @@ static int check_device_used(struct device_record *dev_rec,
 	}
 }
 
+/*
+ * Extra (optional) check for dev_item size
+ *
+ * To avoid possible kernel warning for v4.14 kernel.
+ * It's not a deadly problem, just to info v4.14 kernel user.
+ * So it won't change the return value.
+ */
+static void check_dev_size_alignment(u64 devid, u64 total_bytes,
+				     u32 sectorsize)
+{
+	if (!IS_ALIGNED(total_bytes, sectorsize)) {
+		warning("unaligned total_bytes detected for devid %llu, have %llu should be aligned to %u",
+			devid, total_bytes, sectorsize);
+		warning("this is OK for older kernel (<4.14), but may cause kernel warning for newer kernel (>=4.14)");
+		warning("this can be fixed by 'btrfs check --fix-dev-size'");
+	}
+}
+
+/*
+ * Unlike device size alignment check above, some super total_bytes check
+ * failure can lead to unmountable fs for kernel >=v4.6.
+ *
+ * So this function will return the error for fatal super total_bytes problem.
+ */
+static int check_super_size(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_device *dev;
+	struct list_head *dev_list = &fs_info->fs_devices->devices;
+	u64 total_bytes = 0;
+	u64 super_bytes = btrfs_super_total_bytes(fs_info->super_copy);
+
+	list_for_each_entry(dev, dev_list, dev_list)
+		total_bytes += dev->total_bytes;
+
+	/* Important check, which can cause unmountable fs */
+	if (super_bytes < total_bytes) {
+		error("super total bytes %llu smaller than real devices size %llu",
+			super_bytes, total_bytes);
+		error("this fs will not be mountable for newer kernels (>=v4.6)");
+		error("this can be fixed by 'btrfs check --fix-dev-size'");
+		return 1;
+	}
+
+	/*
+	 * Optional check, just to make everything aligned and match with
+	 * each other.
+	 *
+	 * For btrfs-image restored fs, we don't need to check it anyway.
+	 */
+	if (btrfs_super_flags(fs_info->super_copy) &
+	    (BTRFS_SUPER_FLAG_METADUMP | BTRFS_SUPER_FLAG_METADUMP_V2))
+		return 0;
+	if (!IS_ALIGNED(super_bytes, fs_info->sectorsize) ||
+	    !IS_ALIGNED(total_bytes, fs_info->sectorsize) ||
+	    super_bytes != total_bytes) {
+		warning("minor unaligned/mismatch device size detected");
+		warning("recommended to use 'btrfs check --fix-dev-size' to fix it");
+	}
+	return 0;
+}
+
 /* check btrfs_dev_item -> btrfs_dev_extent */
 static int check_devices(struct rb_root *dev_cache,
 			 struct device_extent_tree *dev_extent_cache)
@@ -9896,6 +9957,11 @@ static int check_devices(struct rb_root *dev_cache,
 		if (err)
 			ret = err;
 
+		if (!IS_ALIGNED(dev_rec->total_byte, global_info->sectorsize)) {
+		}
+
+		check_dev_size_alignment(dev_rec->devid, dev_rec->total_byte,
+					 global_info->sectorsize);
 		dev_node = rb_next(dev_node);
 	}
 	list_for_each_entry(dext_rec, &dev_extent_cache->no_device_orphans,
@@ -11141,6 +11207,7 @@ static int check_dev_item(struct btrfs_fs_info *fs_info,
 	struct btrfs_path path;
 	struct btrfs_key key;
 	struct btrfs_dev_extent *ptr;
+	u64 total_bytes;
 	u64 dev_id;
 	u64 used;
 	u64 total = 0;
@@ -11149,6 +11216,7 @@ static int check_dev_item(struct btrfs_fs_info *fs_info,
 	dev_item = btrfs_item_ptr(eb, slot, struct btrfs_dev_item);
 	dev_id = btrfs_device_id(eb, dev_item);
 	used = btrfs_device_bytes_used(eb, dev_item);
+	total_bytes = btrfs_device_total_bytes(eb, dev_item);
 
 	key.objectid = dev_id;
 	key.type = BTRFS_DEV_EXTENT_KEY;
@@ -11193,6 +11261,8 @@ next:
 			BTRFS_DEV_EXTENT_KEY, dev_id);
 		return ACCOUNTING_MISMATCH;
 	}
+	check_dev_size_alignment(dev_id, total_bytes, fs_info->sectorsize);
+
 	return 0;
 }
 
@@ -13471,6 +13541,9 @@ int cmd_check(int argc, char **argv)
 		error(
 		"errors found in extent allocation tree or chunk allocation");
 
+	/* Only re-check super size after we checked and repaired the fs */
+	err |= check_super_size(info);
+
 	ret = repair_root_items(info);
 	err |= !!ret;
 	if (ret < 0) {
-- 
2.14.2

