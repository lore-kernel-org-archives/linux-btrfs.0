Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23014 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbcBEBZA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 20:25:00 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v6 18/19] btrfs: dedup: add per-file online dedup control
Date: Fri,  5 Feb 2016 09:22:38 +0800
Message-Id: <1454635359-10013-19-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
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
index 759b03d..25af469 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -676,6 +676,18 @@ static void free_async_extent_pages(struct async_extent *async_extent)
 	async_extent->pages = NULL;
 }
 
+static inline int inode_need_dedup(struct btrfs_fs_info *fs_info,
+				   struct inode *inode)
+{
+	if (!fs_info->dedup_enabled)
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
@@ -1637,7 +1649,8 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode) && !fs_info->dedup_enabled) {
+	} else if (!inode_need_compress(inode) &&
+		   !inode_need_dedup(fs_info, inode)) {
 		ret = cow_file_range(inode, locked_page, start, end,
 				      page_started, nr_written, 1, NULL);
 	} else {
-- 
2.7.0



