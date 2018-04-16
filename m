Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:55437 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbeDPFHI (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 16 Apr 2018 01:07:08 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: Do super block verification before writing it to disk
Date: Mon, 16 Apr 2018 13:06:52 +0800
Message-Id: <20180416050652.2544-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are already 2 reports about strangely corrupted super blocks,
where csum type and incompat flags get some obvious garbage, but csum
still matches and all other vitals are correct.

This normally means some kernel memory corruption happens, although the
cause is unknown, at least detect it and prevent further corruption.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Fix false alerts by moving the check to write_dev_supers() as
  btrfs_check_super_valid() only handles the primary superblock.
---
 fs/btrfs/disk-io.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 23803102aa0d..69f49f4937ea 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -68,7 +68,8 @@
 static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info);
+static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
+				   struct btrfs_super_block *sb);
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_fs_info *fs_info);
@@ -2680,7 +2681,7 @@ int open_ctree(struct super_block *sb,
 
 	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
 
-	ret = btrfs_check_super_valid(fs_info);
+	ret = btrfs_check_super_valid(fs_info, fs_info->super_copy);
 	if (ret) {
 		btrfs_err(fs_info, "superblock contains fatal errors");
 		err = -EINVAL;
@@ -3310,6 +3311,26 @@ static int write_dev_supers(struct btrfs_device *device,
 
 		btrfs_set_super_bytenr(sb, bytenr);
 
+		/* check the validation of the primary sb before writing */
+		if (i == 0) {
+			ret = btrfs_check_super_valid(device->fs_info, sb);
+			if (ret) {
+				btrfs_err(device->fs_info,
+			"superblock corruption detected for device %llu",
+					  device->devid);
+				return -EUCLEAN;
+			}
+			/*
+			 * Unknown incompat flags can't be mounted, so newly
+			 * developed flags means corruption
+			 */
+			if (btrfs_super_incompat_flags(sb) &
+			    ~BTRFS_FEATURE_INCOMPAT_SUPP) {
+				btrfs_err(device->fs_info,
+					"fatal superblock corrupted detected");
+				return -EUCLEAN;
+			}
+		}
 		crc = ~(u32)0;
 		crc = btrfs_csum_data((const char *)sb + BTRFS_CSUM_SIZE, crc,
 				      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
@@ -3985,9 +4006,9 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid, int level,
 					      level, first_key);
 }
 
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
+static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
+				   struct btrfs_super_block *sb)
 {
-	struct btrfs_super_block *sb = fs_info->super_copy;
 	u64 nodesize = btrfs_super_nodesize(sb);
 	u64 sectorsize = btrfs_super_sectorsize(sb);
 	int ret = 0;
-- 
2.17.0

