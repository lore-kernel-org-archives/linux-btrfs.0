Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63763 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab2H2GRu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Aug 2012 02:17:50 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q7T6HnFW006694
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2012 14:17:49 +0800
Message-ID: <503DB3F7.3010000@cn.fujitsu.com>
Date: Wed, 29 Aug 2012 14:17:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2 RESEND] Btrfs: flush all the dirty pages if try_to_writeback_inodes_sb_nr()
 fails
Content-Type: text/plain; charset=UTF-8
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
 fs/btrfs/extent-tree.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 175d802..2fe4d8c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3675,6 +3675,28 @@ out:
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
@@ -3706,8 +3728,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 	while (delalloc_bytes && loops < 3) {
 		max_reclaim = min(delalloc_bytes, to_reclaim);
 		nr_pages = max_reclaim >> PAGE_CACHE_SHIFT;
-		try_to_writeback_inodes_sb_nr(root->fs_info->sb, nr_pages,
-					      WB_REASON_FS_FREE_SPACE);
+		btrfs_writeback_inodes_sb_nr(root, nr_pages);
 
 		spin_lock(&space_info->lock);
 		if (space_info->bytes_used + space_info->bytes_reserved +
-- 
1.6.5.2
