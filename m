Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33345 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758445AbcDAGfn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 02:35:43 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v10 14/21] btrfs: dedupe: add per-file online dedupe control
Date: Fri,  1 Apr 2016 14:35:05 +0800
Message-Id: <1459492512-31435-15-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce inode_need_dedupe() to implement per-file online dedupe control.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 96790d0..c80fd74 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -708,6 +708,18 @@ static void end_dedupe_extent(struct inode *inode, u64 start,
 	}
 }
 
+static inline int inode_need_dedupe(struct btrfs_fs_info *fs_info,
+				    struct inode *inode)
+{
+	if (!fs_info->dedupe_enabled)
+		return 0;
+
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODEDUPE)
+		return 0;
+
+	return 1;
+}
+
 /*
  * phase two of compressed writeback.  This is the ordered portion
  * of the code, which only gets called in the order the work was
@@ -1680,7 +1692,8 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode) && !fs_info->dedupe_enabled) {
+	} else if (!inode_need_compress(inode) &&
+		   !inode_need_dedupe(fs_info, inode)) {
 		ret = cow_file_range(inode, locked_page, start, end,
 				      page_started, nr_written, 1, NULL);
 	} else {
-- 
2.7.4



