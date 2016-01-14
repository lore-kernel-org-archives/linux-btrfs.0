Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18653 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751962AbcANGAK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 01:00:10 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id A7A9D41896DF
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 13:59:48 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v4 18/18] btrfs: dedup: add per-file online dedup control
Date: Thu, 14 Jan 2016 13:57:34 +0800
Message-ID: <1452751054-2365-19-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce inode_need_dedup() to implement per-file online dedup control.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5a49afa..6d2f068 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -672,6 +672,21 @@ static void free_async_extent_pages(struct async_extent *async_extent)
 	async_extent->pages = NULL;
 }
 
+static inline int inode_need_dedup(struct inode *inode)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_dedup_info *dedup_info = root->fs_info->dedup_info;
+
+	if (!dedup_info)
+		return 0;
+
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODEDUP)
+		return 0;
+
+	return 1;
+}
+
+
 static int submit_dedup_extent(struct inode *inode, u64 start,
 			       unsigned long len, u64 disk_start, int dedup)
 {
@@ -1794,8 +1809,6 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 {
 	int ret;
 	int force_cow = need_force_cow(inode, start, end);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_dedup_info *dedup_info = root->fs_info->dedup_info;
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
@@ -1803,7 +1816,7 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode) && !dedup_info) {
+	} else if (!inode_need_compress(inode) && !inode_need_dedup(inode)) {
 		ret = cow_file_range(inode, locked_page, start, end,
 				      page_started, nr_written, 1);
 	} else {
-- 
2.7.0



