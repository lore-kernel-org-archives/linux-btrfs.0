From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: check if there is enough space for balancing smarter
Date: Wed, 3 Aug 2011 18:15:25 +0800
Message-ID: <1312366525-19677-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <josef@redhat.com>, <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When checking if there is enough space for balancing a block group,
since we do not take raid types into consideration, we do not account
corrent amounts of space that we needed.  This makes us do some extra
work before we get ENOSPC.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   41 +++++++++++++++++++++++++++++++++++------
 1 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3213c39..02216cc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6682,6 +6682,10 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	struct btrfs_space_info *space_info;
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 	struct btrfs_device *device;
+	u64 min_free;
+	int index;
+	int dev_nr = 0;
+	int dev_min = 1;
 	int full = 0;
 	int ret = 0;
 
@@ -6691,8 +6695,10 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	if (!block_group)
 		return -1;
 
+	min_free = btrfs_block_group_used(&block_group->item);
+
 	/* no bytes used, we're good */
-	if (!btrfs_block_group_used(&block_group->item))
+	if (!min_free)
 		goto out;
 
 	space_info = block_group->space_info;
@@ -6708,10 +6714,9 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	 * all of the extents from this block group.  If we can, we're good
 	 */
 	if ((space_info->total_bytes != block_group->key.offset) &&
-	   (space_info->bytes_used + space_info->bytes_reserved +
-	    space_info->bytes_pinned + space_info->bytes_readonly +
-	    btrfs_block_group_used(&block_group->item) <
-	    space_info->total_bytes)) {
+	    (space_info->bytes_used + space_info->bytes_reserved +
+	     space_info->bytes_pinned + space_info->bytes_readonly +
+	     min_free < space_info->total_bytes)) {
 		spin_unlock(&space_info->lock);
 		goto out;
 	}
@@ -6728,9 +6733,29 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	if (full)
 		goto out;
 
+	/*
+	 * index:
+	 *      0: raid10
+	 *      1: raid1
+	 *      2: dup
+	 *      3: raid0
+	 *      4: single
+	 */
+	index = get_block_group_index(block_group);
+	if (index == 0) {
+		dev_min = 4;
+		min_free /= 2;
+	} else if (index == 1) {
+		dev_min = 2;
+	} else if (index == 2) {
+		min_free *= 2;
+	} else if (index == 3) {
+		dev_min = fs_devices->rw_devices;
+		min_free /= dev_min;
+	}
+
 	mutex_lock(&root->fs_info->chunk_mutex);
 	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
-		u64 min_free = btrfs_block_group_used(&block_group->item);
 		u64 dev_offset;
 
 		/*
@@ -6741,7 +6766,11 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 			ret = find_free_dev_extent(NULL, device, min_free,
 						   &dev_offset, NULL);
 			if (!ret)
+				dev_nr++;
+
+			if (dev_nr >= dev_min)
 				break;
+
 			ret = -1;
 		}
 	}
-- 
1.6.5.2

