Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:6365 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab2LTL65 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Dec 2012 06:58:57 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qBKBJhvh016350
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Dec 2012 19:19:44 +0800
Message-ID: <50D2F42D.7070600@cn.fujitsu.com>
Date: Thu, 20 Dec 2012 19:19:09 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND 1/3] Btrfs: flush all dirty inodes if writeback can
 not start
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

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
 fs/btrfs/extent-tree.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d133edf..44a0b58 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3689,12 +3689,15 @@ static int can_overcommit(struct btrfs_root *root,
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
@@ -3703,6 +3706,28 @@ static int writeback_inodes_sb_nr_if_idle_safe(struct super_block *sb,
 	return 0;
 }
 
+void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
+				  unsigned long nr_pages)
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
+		btrfs_wait_ordered_extents(root, 0);
+	}
+}
+
 /*
  * shrink metadata reservation for delalloc
  */
@@ -3735,10 +3760,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
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
-- 
1.7.11.7
