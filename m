From: Miao Xie <miaoxie1984@gmail.com>
Subject: [PATCH 2/4] Btrfs: fix deadlock on sb->s_umount when doing umount
Date: Thu, 26 Apr 2012 10:58:04 +0800
Message-ID: <4F98B9BC.7010905@gmail.com>
Reply-To: miaoxie1984@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, miaox@cn.fujitsu.com,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux FSDevel <linux-fsdevel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The reason the deadlock is that:
  Task					Btrfs-cleaner
  umount()
    down_write(&s->s_umount)
    sync_filesystem()
					do auto-defragment and produce
					lots of dirty pages
    close_ctree()
      wait for the end of
      btrfs-cleaner
					start_transaction
					  reserve space
					    shrink_delalloc()
					      writeback_inodes_sb_nr_if_idle()
						down_read(&sb->s_umount)
So, the deadlock has happened.

We fix it by using try_to_writeback_inodes_sb_nr(), this function will try to
get sb->s_umount, if fail, it won't do any writeback. At this time, In order to
get enough space to reserve successfully, we will use the sync function of
btrfs to sync all the delalloc file. This operation is safe, we needn't worry
about the case that the filesystem goes from r/w to r/o. because the filesystem
should guarantee all the dirty pages have been written into the disk after it
becomes readonly, so the sync operation will do nothing if the filesystem is
already readonly. Though it may waste lots of time, as a corner case, we
needn't care.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c     |    3 +++
 fs/btrfs/extent-tree.c |   25 +++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 20196f4..59b566d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3056,6 +3056,9 @@ int close_ctree(struct btrfs_root *root)
 	/* clear out the rbtree of defraggable inodes */
 	btrfs_run_defrag_inodes(fs_info);
 
+	/* sync all the dirty pages which are made by auto defrag */
+	sync_filesystem(fs_info->sb);
+
 	/*
 	 * Here come 2 situations when btrfs is broken to flip readonly:
 	 *
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2b35f8d..e533ab3 100644
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
-		writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages,
-						WB_REASON_FS_FREE_SPACE);
+		btrfs_writeback_inodes_sb_nr(root, nr_pages);
 
 		spin_lock(&space_info->lock);
 		if (reserved > space_info->bytes_may_use)
-- 
1.7.6.5
