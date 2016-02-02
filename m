Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7891 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbcBBDH5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 22:07:57 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v5 18/19] btrfs: dedup: add per-file online dedup control
Date: Tue,  2 Feb 2016 11:05:50 +0800
Message-Id: <1454382351-31775-19-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454382351-31775-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454382351-31775-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce inode_need_dedup() to implement per-file online dedup control.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1e27a71..1973f86 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -676,6 +676,18 @@ static void free_async_extent_pages(struct async_extent *async_extent)
 	async_extent->pages = NULL;
 }
 
+static inline int inode_need_dedup(struct btrfs_dedup_info *dedup_info,
+				   struct inode *inode)
+{
+	if (!dedup_info)
+		return 0;
+
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODEDUP)
+		return 0;
+
+	return 1;
+}
+
 /*
  * phase two of compressed writeback.  This is the ordered portion
  * of the code, which only gets called in the order the work was
@@ -1634,7 +1646,8 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode) && !dedup_info) {
+	} else if (!inode_need_compress(inode) &&
+		   !inode_need_dedup(dedup_info, inode)) {
 		ret = cow_file_range(inode, locked_page, start, end,
 				      page_started, nr_written, 1, NULL);
 	} else {
-- 
2.7.0



