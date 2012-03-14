From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH v2] Btrfs: fix deadlock during allocating chunks
Date: Wed, 14 Mar 2012 19:17:09 +0800
Message-ID: <1331723829-25226-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This deadlock comes from xfstests 251.

We'll hold the chunk_mutex throughout the whole of a chunk allocation.
But if we find that we've used up system chunk space, we need to allocate a
new system chunk, but this will lead to a recursion of chunk allocation and end
up with a deadlock on chunk_mutex.
So instead we need to allocate the system chunk first if we find we're in ENOSPC.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 37e0a80..0793ddc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3396,6 +3396,39 @@ static int should_alloc_chunk(struct btrfs_root *root,
 	return 1;
 }
 
+static void check_system_chunk(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root, int check)
+{
+	struct btrfs_space_info *info;
+	u64 left;
+	u64 thresh;
+	u64 num_dev = 0;
+
+	info = __find_space_info(root->fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
+	spin_lock(&info->lock);
+	left = info->total_bytes - info->bytes_used - info->bytes_pinned -
+		info->bytes_reserved - info->bytes_readonly;
+	spin_unlock(&info->lock);
+
+	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+	num_dev = root->fs_info->fs_devices->rw_devices;
+	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+
+	thresh = btrfs_calc_trans_metadata_size(root, num_dev + 1);
+	if (left < thresh && btrfs_test_opt(root, ENOSPC_DEBUG))
+		dump_space_info(info, 0, 0);
+
+	if (check)
+		return;
+
+	if (left < thresh) {
+		u64 flags;
+
+		flags = btrfs_get_alloc_profile(root->fs_info->chunk_root, 0);
+		btrfs_alloc_chunk(trans, root, flags);
+	}
+}
+
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
 			  u64 flags, int force)
@@ -3468,6 +3501,12 @@ again:
 			force_metadata_allocation(fs_info);
 	}
 
+	/*
+	 * Check if we have enough space in SYSTEM chunk because we may need
+	 * to update devices.
+	 */
+	check_system_chunk(trans, extent_root, 0);
+
 	ret = btrfs_alloc_chunk(trans, extent_root, flags);
 	if (ret < 0 && ret != -ENOSPC)
 		goto out;
-- 
1.6.5.2

