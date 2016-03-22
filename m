Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758084AbcCVBik (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:38:40 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v8 23/27] btrfs: dedupe: Avoid submit IO for hash hit extent
Date: Tue, 22 Mar 2016 09:35:48 +0800
Message-Id: <1458610552-9845-24-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Before this patch, even for duplicated extent, it will still go through
page write, meaning we didn't skip IO for them.

Although such write will be skipped by block level, as block level will
only select the last submitted write request to the same bytenr.

This patch will manually skip such IO to reduce dedupe overhead.
After this patch, dedupe all miss performance is higher than low
compress ratio performance.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 81b19193..b22663c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -688,6 +688,38 @@ static inline int inode_need_dedupe(struct btrfs_fs_info *fs_info,
 	return 1;
 }
 
+static void end_dedupe_extent(struct inode *inode, u64 start,
+			      u32 len, unsigned long page_ops)
+{
+	int i;
+	unsigned nr_pages = len / PAGE_CACHE_SIZE;
+	struct page *page;
+
+	for (i = 0; i < nr_pages; i++) {
+		page = find_get_page(inode->i_mapping,
+				     start >> PAGE_CACHE_SHIFT);
+		/* page should be already locked by caller */
+		if (WARN_ON(!page))
+			continue;
+
+		/* We need to do this by ourselves as we skipped IO */
+		if (page_ops & PAGE_CLEAR_DIRTY)
+			clear_page_dirty_for_io(page);
+		if (page_ops & PAGE_SET_WRITEBACK)
+			set_page_writeback(page);
+
+		end_extent_writepage(page, 0, start,
+				     start + PAGE_CACHE_SIZE - 1);
+		if (page_ops & PAGE_END_WRITEBACK)
+			end_page_writeback(page);
+		if (page_ops & PAGE_UNLOCK)
+			unlock_page(page);
+
+		start += PAGE_CACHE_SIZE;
+		page_cache_release(page);
+	}
+}
+
 /*
  * phase two of compressed writeback.  This is the ordered portion
  * of the code, which only gets called in the order the work was
@@ -742,14 +774,24 @@ retry:
 			 * and IO for us.  Otherwise, we need to submit
 			 * all those pages down to the drive.
 			 */
-			if (!page_started && !ret)
-				extent_write_locked_range(io_tree,
-						  inode, async_extent->start,
-						  async_extent->start +
-						  async_extent->ram_size - 1,
-						  btrfs_get_extent,
-						  WB_SYNC_ALL);
-			else if (ret)
+			if (!page_started && !ret) {
+				/* Skip IO for dedup async_extent */
+				if (btrfs_dedupe_hash_hit(hash))
+					end_dedupe_extent(inode,
+						async_extent->start,
+						async_extent->ram_size,
+						PAGE_CLEAR_DIRTY |
+						PAGE_SET_WRITEBACK |
+						PAGE_END_WRITEBACK |
+						PAGE_UNLOCK);
+				else
+					extent_write_locked_range(io_tree,
+						inode, async_extent->start,
+						async_extent->start +
+						async_extent->ram_size - 1,
+						btrfs_get_extent,
+						WB_SYNC_ALL);
+			} else if (ret)
 				unlock_page(async_cow->locked_page);
 			kfree(hash);
 			kfree(async_extent);
-- 
2.7.3



