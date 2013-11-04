Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61609 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab3KDPMp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 10:12:45 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA4FCUOQ031733
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2013 23:12:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/7] Btrfs: don't wait for all the async delalloc when shrinking delalloc
Date: Mon, 4 Nov 2013 23:13:24 +0800
Message-Id: <1383578006-22691-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
References: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It was very likely that there were lots of async delalloc pages in the
filesystem, if we waited until all the pages were flushed, we would be
blocked for a long time, and the performance would also drop down.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c48fde1..d691e15 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4061,9 +4061,19 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 		 * We need to wait for the async pages to actually start before
 		 * we do anything.
 		 */
-		wait_event(root->fs_info->async_submit_wait,
-			   !atomic_read(&root->fs_info->async_delalloc_pages));
+		max_reclaim = atomic_read(&root->fs_info->async_delalloc_pages);
+		if (!max_reclaim)
+			goto skip_async;
+
+		if (max_reclaim <= nr_pages)
+			max_reclaim = 0;
+		else
+			max_reclaim -= nr_pages;
 
+		wait_event(root->fs_info->async_submit_wait,
+			   atomic_read(&root->fs_info->async_delalloc_pages) <=
+			   (int)max_reclaim);
+skip_async:
 		if (!trans)
 			flush = BTRFS_RESERVE_FLUSH_ALL;
 		else
-- 
1.8.1.4

