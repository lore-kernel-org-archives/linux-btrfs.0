Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:40740 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934673AbdJQJNf (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 17 Oct 2017 05:13:35 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: [PATCH v2 4/6] btrfs-progs: check: Also check and repair unalignment/mismatch device and super size
Date: Tue, 17 Oct 2017 17:13:10 +0800
Message-Id: <20171017091312.31045-5-wqu@suse.com>
In-Reply-To: <20171017091312.31045-1-wqu@suse.com>
References: <20171017091312.31045-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Along with the rescue introduced, also introduce check and repair for them.

Unlike normal check functions, some of the check is optional, and even if
the image failed to pass optional check, kernel can still run fine.
(But may cause noisy kernel warning)

So some check, mainly for alignment, will not cause btrfs check to fail,
but only to output warning and how to fix it.

For repair, it just calls the same repair in rescue, and is included in
'btrfs check --repair'.
But 'btrfs rescue' is still the preferred method, since it can bypass
all the possible dangerous repair.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 cmds-check.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 5c822b848608..52250b4d2420 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9879,6 +9879,67 @@ static int check_device_used(struct device_record *dev_rec,
 	}
 }
 
+/*
+ * Extra (optional) check for dev_item size
+ *
+ * To avoid possible kernel warning for newer kernel.
+ * It's not a deadly problem, just to info newer kernel user.
+ * So it won't return any value, just info user directly.
+ */
+static void check_dev_size_alignment(u64 devid, u64 total_bytes,
+				     u32 sectorsize)
+{
+	if (!IS_ALIGNED(total_bytes, sectorsize)) {
+		warning("unaligned total_bytes detected for devid %llu, have %llu should be aligned to %u",
+			devid, total_bytes, sectorsize);
+		warning("this is OK for older kernel, but may cause kernel warning for newer kernel");
+		warning("this can be fixed by 'btrfs rescue fix-device-size'");
+	}
+}
+
+/*
+ * Unlike device size alignment check above, some super total_bytes check
+ * failure can lead to mount failure for newer kernel.
+ *
+ * So this function will return the error for fatal super total_bytes problem.
+ */
+static bool is_super_size_valid(struct btrfs_fs_info *fs_info)
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
+		error("super total bytes %llu smaller than real device(s) size %llu",
+			super_bytes, total_bytes);
+		error("mounting this fs may fail for newer kernels");
+		error("this can be fixed by 'btrfs rescue fix-device-size'");
+		return false;
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
+		return true;
+	if (!IS_ALIGNED(super_bytes, fs_info->sectorsize) ||
+	    !IS_ALIGNED(total_bytes, fs_info->sectorsize) ||
+	    super_bytes != total_bytes) {
+		warning("minor unaligned/mismatch device size detected");
+		warning("recommended to use 'btrfs rescue fix-device-size' to fix it");
+	}
+	return true;
+}
+
 /* check btrfs_dev_item -> btrfs_dev_extent */
 static int check_devices(struct rb_root *dev_cache,
 			 struct device_extent_tree *dev_extent_cache)
@@ -9896,6 +9957,8 @@ static int check_devices(struct rb_root *dev_cache,
 		if (err)
 			ret = err;
 
+		check_dev_size_alignment(dev_rec->devid, dev_rec->total_byte,
+					 global_info->sectorsize);
 		dev_node = rb_next(dev_node);
 	}
 	list_for_each_entry(dext_rec, &dev_extent_cache->no_device_orphans,
@@ -11141,6 +11204,7 @@ static int check_dev_item(struct btrfs_fs_info *fs_info,
 	struct btrfs_path path;
 	struct btrfs_key key;
 	struct btrfs_dev_extent *ptr;
+	u64 total_bytes;
 	u64 dev_id;
 	u64 used;
 	u64 total = 0;
@@ -11149,6 +11213,7 @@ static int check_dev_item(struct btrfs_fs_info *fs_info,
 	dev_item = btrfs_item_ptr(eb, slot, struct btrfs_dev_item);
 	dev_id = btrfs_device_id(eb, dev_item);
 	used = btrfs_device_bytes_used(eb, dev_item);
+	total_bytes = btrfs_device_total_bytes(eb, dev_item);
 
 	key.objectid = dev_id;
 	key.type = BTRFS_DEV_EXTENT_KEY;
@@ -11193,6 +11258,8 @@ next:
 			BTRFS_DEV_EXTENT_KEY, dev_id);
 		return ACCOUNTING_MISMATCH;
 	}
+	check_dev_size_alignment(dev_id, total_bytes, fs_info->sectorsize);
+
 	return 0;
 }
 
@@ -11757,6 +11824,12 @@ static int do_check_chunks_and_extents(struct btrfs_fs_info *fs_info)
 	else
 		ret = check_chunks_and_extents(fs_info);
 
+	/* Also repair device size related problems */
+	if (repair && !ret) {
+		ret = btrfs_fix_device_and_super_size(fs_info);
+		if (ret > 0)
+			ret = 0;
+	}
 	return ret;
 }
 
@@ -13256,6 +13329,9 @@ int cmd_check(int argc, char **argv)
 		error(
 		"errors found in extent allocation tree or chunk allocation");
 
+	/* Only re-check super size after we checked and repaired the fs */
+	err |= !is_super_size_valid(info);
+
 	ret = repair_root_items(info);
 	err |= !!ret;
 	if (ret < 0) {
-- 
2.14.2

