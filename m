From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 02/10][RESEND] Btrfs: fix deadlock during allocating chunks
Date: Tue, 27 Mar 2012 14:44:30 +0800
Message-ID: <1332830678-3992-3-git-send-email-liubo2009@cn.fujitsu.com>
References: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

This deadlock comes from xfstests 251.

We'll hold the chunk_mutex throughout the whole of a chunk allocation.
But if we find that we've used up system chunk space, we need to allocate a
new system chunk, but this will lead to a recursion of chunk allocation and end
up with a deadlock on chunk_mutex.
So instead we need to allocate the system chunk first if we find we're in ENOSPC.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f3d367a..fe5bbc7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3394,6 +3394,50 @@ static int should_alloc_chunk(struct btrfs_root *root,
 	return 1;
 }
 
+static u64 get_system_chunk_thresh(struct btrfs_root *root, u64 type)
+{
+	u64 num_dev;
+
+	if (type & BTRFS_BLOCK_GROUP_RAID10 ||
+	    type & BTRFS_BLOCK_GROUP_RAID0)
+		num_dev = root->fs_info->fs_devices->rw_devices;
+	else if (type & BTRFS_BLOCK_GROUP_RAID1)
+		num_dev = 2;
+	else
+		num_dev = 1;	/* DUP or single */
+
+	/* metadata for updaing devices and chunk tree */
+	return btrfs_calc_trans_metadata_size(root, num_dev + 1);
+}
+
+static void check_system_chunk(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root, u64 type)
+{
+	struct btrfs_space_info *info;
+	u64 left;
+	u64 thresh;
+
+	info = __find_space_info(root->fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
+	spin_lock(&info->lock);
+	left = info->total_bytes - info->bytes_used - info->bytes_pinned -
+		info->bytes_reserved - info->bytes_readonly;
+	spin_unlock(&info->lock);
+
+	thresh = get_system_chunk_thresh(root, type);
+	if (left < thresh && btrfs_test_opt(root, ENOSPC_DEBUG)) {
+		printk(KERN_INFO "left=%llu, need=%llu, flags=%llu\n",
+		       left, thresh, type);
+		dump_space_info(info, 0, 0);
+	}
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
@@ -3466,6 +3510,12 @@ again:
 			force_metadata_allocation(fs_info);
 	}
 
+	/*
+	 * Check if we have enough space in SYSTEM chunk because we may need
+	 * to update devices.
+	 */
+	check_system_chunk(trans, extent_root, flags);
+
 	ret = btrfs_alloc_chunk(trans, extent_root, flags);
 	if (ret < 0 && ret != -ENOSPC)
 		goto out;
-- 
1.6.5.2

