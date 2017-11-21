Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:45859 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdKUHVv (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 21 Nov 2017 02:21:51 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, lists@colorremedies.com
Subject: [PATCH v2 1/2] btrfs: Enhance btrfs_trim_fs function to handle error better
Date: Tue, 21 Nov 2017 15:21:44 +0800
Message-Id: <20171121072145.24413-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Function btrfs_trim_fs() doesn't handle errors in a consistent way, if
error happens when trimming existing block groups, it will skip the
remaining blocks and continue to trim unallocated space for each device.

And the return value will only reflect the final error from device
trimming.

This patch will fix such behavior by:

1) Recording first error from block group or device trimming
   So return value will also reflect any error found when trimming.
   Make developer more aware of the problem.

2) Outputting debug message for total trimming failure
   Since trimming failure for device and block group is not fatal, put
   the message level to debug and only output the total failure number
   along with the info for first block group/device.

3) Continuing trimming if we can
   If we failed to trim one block group or device, we could still try
   next block group or device.

Such behavior can avoid confusion for case like failure to trim the
first block group and then only unallocated space is trimmed.

Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Only report total number of errors and first errno to make it less
  noisy.
  Change message level from warning to debug
---
 fs/btrfs/extent-tree.c | 75 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 58 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2d7e86b51d1..3a252d7af158 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10995,6 +10995,16 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 	return ret;
 }
 
+/*
+ * Trim the whole fs, by:
+ * 1) Trimming free space in each block group
+ * 2) Trimming unallocated space in each device
+ *
+ * Will try to continue trimming even if we failed to trim one block group or
+ * device.
+ * The return value will be the error return value of the first error.
+ * Or 0 if nothing wrong happened.
+ */
 int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 {
 	struct btrfs_block_group_cache *cache = NULL;
@@ -11005,6 +11015,12 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	u64 end;
 	u64 trimmed = 0;
 	u64 total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
+	u64 first_bg_failed = 0;
+	u64 first_dev_failed = 0;
+	int bg_failed = 0;
+	int dev_failed = 0;
+	int bg_ret = 0;
+	int dev_ret = 0;
 	int ret = 0;
 
 	/*
@@ -11015,7 +11031,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	else
 		cache = btrfs_lookup_block_group(fs_info, range->start);
 
-	while (cache) {
+	for (; cache; cache = next_block_group(fs_info, cache)) {
 		if (cache->key.objectid >= (range->start + range->len)) {
 			btrfs_put_block_group(cache);
 			break;
@@ -11029,45 +11045,70 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 			if (!block_group_cache_done(cache)) {
 				ret = cache_block_group(cache, 0);
 				if (ret) {
-					btrfs_put_block_group(cache);
-					break;
+					if (!bg_ret) {
+						bg_ret = ret;
+						first_bg_failed =
+							cache->key.objectid;
+					}
+					bg_failed++;
+					continue;
 				}
 				ret = wait_block_group_cache_done(cache);
 				if (ret) {
-					btrfs_put_block_group(cache);
-					break;
+					if (!bg_ret) {
+						bg_ret = ret;
+						first_bg_failed =
+							cache->key.objectid;
+					}
+					bg_failed++;
+					continue;
 				}
 			}
-			ret = btrfs_trim_block_group(cache,
-						     &group_trimmed,
-						     start,
-						     end,
-						     range->minlen);
+			ret = btrfs_trim_block_group(cache, &group_trimmed,
+						start, end, range->minlen);
 
 			trimmed += group_trimmed;
 			if (ret) {
-				btrfs_put_block_group(cache);
-				break;
+				if (!bg_ret) {
+					bg_ret = ret;
+					first_bg_failed = cache->key.objectid;
+				}
+				bg_failed++;
+				continue;
 			}
 		}
-
-		cache = next_block_group(fs_info, cache);
 	}
 
+	if (bg_ret)
+		btrfs_debug(fs_info,
+	"failed to trim %d block groups, first error occurs for block group %llu ret %d",
+			    bg_failed, first_bg_failed, bg_ret);
+
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	devices = &fs_info->fs_devices->alloc_list;
 	list_for_each_entry(device, devices, dev_alloc_list) {
 		ret = btrfs_trim_free_extents(device, range->minlen,
 					      &group_trimmed);
-		if (ret)
-			break;
+		if (ret) {
+			if (!dev_ret) {
+				dev_ret = ret;
+				first_dev_failed = device->devid;
+			}
+			dev_failed++;
+		}
 
 		trimmed += group_trimmed;
 	}
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
+	if (dev_ret)
+		btrfs_debug(fs_info,
+	"failed to trim %d devices, first error occurs for devid %llu ret %d",
+			    dev_failed, first_dev_failed, dev_ret);
 	range->len = trimmed;
-	return ret;
+	if (bg_ret)
+		return bg_ret;
+	return dev_ret;
 }
 
 /*
-- 
2.15.0

