From: Miao Xie <miaoxie1984@gmail.com>
Subject: [PATCH 2/2] Btrfs: flush all the dirty pages if try_to_writeback_inodes_sb_nr()
 fails
Date: Sun, 29 Apr 2012 23:25:19 +0800
Message-ID: <4F9D5D5F.5070503@gmail.com>
Reply-To: miaoxie1984@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: miaox@cn.fujitsu.com, Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We may try to flush some dirty pages when there is no enough space to reserve.
But it is possible that this operation fails, in order to get enough space to
reserve successfully, we will sync all the delalloc file. This operation is
safe, we needn't worry about the case that the filesystem goes from r/w to r/o.
because the filesystem should guarantee all the dirty pages have been written
into the disk after it becomes readonly, so the sync operation will do nothing
if the filesystem is already readonly. Though it may waste lots of time,
as a corner case, we needn't care.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index deb2577..e533ab3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3580,6 +3580,28 @@ out:
 	return ret;
 }
 
+void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
+				  unsigned long nr_pages)
+{
+	struct super_block *sb = root->fs_info->sb;
+	int started;
+
+	/* If we can not start writeback, just sync all the delalloc file. */
+	started = try_to_writeback_inodes_sb_nr(sb, nr_pages,
+						WB_REASON_FS_FREE_SPACE);
+	if (!started) {
+		/*
+		 * We needn't worry the filesystem going from r/w to r/o though
+		 * we don't acquire ->s_umount mutex, because the filesystem
+		 * should guarantee the delalloc inodes list be empty after
+		 * the filesystem is readonly(all dirty pages are written to
+		 * the disk).
+		 */
+		btrfs_start_delalloc_inodes(root, 0);
+		btrfs_wait_ordered_extents(root, 0, 0);
+	}
+}
+
 /*
  * shrink metadata reservation for delalloc
  */
@@ -3624,8 +3646,7 @@ static int shrink_delalloc(struct btrfs_root *root, u64 to_reclaim,
 		smp_mb();
 		nr_pages = min_t(unsigned long, nr_pages,
 		       root->fs_info->delalloc_bytes >> PAGE_CACHE_SHIFT);
-		try_to_writeback_inodes_sb_nr(root->fs_info->sb, nr_pages,
-					      WB_REASON_FS_FREE_SPACE);
+		btrfs_writeback_inodes_sb_nr(root, nr_pages);
 
 		spin_lock(&space_info->lock);
 		if (reserved > space_info->bytes_may_use)
-- 
1.7.6.5
