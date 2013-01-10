Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38697 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932724Ab3AJD30 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Jan 2013 22:29:26 -0500
Message-ID: <50EE35BA.8030108@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 11:30:02 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V3] Btrfs: flush all dirty inodes if writeback can not start
References: <50D2F42D.7070600@cn.fujitsu.com> <50D826FF.8040202@cn.fujitsu.com> <20130108130241.GD2389@localhost.localdomain>
In-Reply-To: <20130108130241.GD2389@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
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
Changelog v2 -> v3:
- remove unnecessary btrfs_wait_ordered_extents()

Changelog v1 -> v2:
- make the function static
---
 fs/btrfs/extent-tree.c | 45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b6ed965..93a2bfc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3695,12 +3695,15 @@ static int can_overcommit(struct btrfs_root *root,
 	return 0;
 }
 
-static int writeback_inodes_sb_nr_if_idle_safe(struct super_block *sb,
-					       unsigned long nr_pages,
-					       enum wb_reason reason)
+static inline int writeback_inodes_sb_nr_if_idle_safe(struct super_block *sb,
+						      unsigned long nr_pages,
+						      enum wb_reason reason)
 {
-	if (!writeback_in_progress(sb->s_bdi) &&
-	    down_read_trylock(&sb->s_umount)) {
+	/* the flusher is dealing with the dirty inodes now. */
+	if (writeback_in_progress(sb->s_bdi))
+		return 1;
+
+	if (down_read_trylock(&sb->s_umount)) {
 		writeback_inodes_sb_nr(sb, nr_pages, reason);
 		up_read(&sb->s_umount);
 		return 1;
@@ -3709,6 +3712,27 @@ static int writeback_inodes_sb_nr_if_idle_safe(struct super_block *sb,
 	return 0;
 }
 
+static void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
+					 unsigned long nr_pages)
+{
+	struct super_block *sb = root->fs_info->sb;
+	int started;
+
+	/* If we can not start writeback, just sync all the delalloc file. */
+	started = writeback_inodes_sb_nr_if_idle_safe(sb, nr_pages,
+						      WB_REASON_FS_FREE_SPACE);
+	if (!started) {
+		/*
+		 * We needn't worry the filesystem going from r/w to r/o though
+		 * we don't acquire ->s_umount mutex, because the filesystem
+		 * should guarantee the delalloc inodes list be empty after
+		 * the filesystem is readonly(all dirty pages are written to
+		 * the disk).
+		 */
+		btrfs_start_delalloc_inodes(root, 0);
+	}
+}
+
 /*
  * shrink metadata reservation for delalloc
  */
@@ -3738,13 +3762,12 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 		return;
 	}
 
+	flush = trans ? BTRFS_RESERVE_NO_FLUSH : BTRFS_RESERVE_FLUSH_ALL;
+
 	while (delalloc_bytes && loops < 3) {
 		max_reclaim = min(delalloc_bytes, to_reclaim);
 		nr_pages = max_reclaim >> PAGE_CACHE_SHIFT;
-		writeback_inodes_sb_nr_if_idle_safe(root->fs_info->sb,
-						    nr_pages,
-						    WB_REASON_FS_FREE_SPACE);
-
+		btrfs_writeback_inodes_sb_nr(root, nr_pages);
 		/*
 		 * We need to wait for the async pages to actually start before
 		 * we do anything.
@@ -3752,10 +3775,6 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 		wait_event(root->fs_info->async_submit_wait,
 			   !atomic_read(&root->fs_info->async_delalloc_pages));
 
-		if (!trans)
-			flush = BTRFS_RESERVE_FLUSH_ALL;
-		else
-			flush = BTRFS_RESERVE_NO_FLUSH;
 		spin_lock(&space_info->lock);
 		if (can_overcommit(root, space_info, orig, flush)) {
 			spin_unlock(&space_info->lock);
-- 
1.7.11.7

