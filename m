Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32604 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752188AbaGQDti (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 23:49:38 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6H3nIJ8031814
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 11:49:18 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/6] Btrfs: fix wrong skipping compression for an inode
Date: Thu, 17 Jul 2014 11:44:09 +0800
Message-ID: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a file's compression ratios is bad, we will set NOCOMPRESS
flag for it, and it will skip compression for that inode next time.

However, if we remount fs to COMPRESS_FORCE, it still should try
if we could compress pages for that inode, this patch fix wrong
check for this problem.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a58f31c..20798f8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -348,6 +348,23 @@ static noinline int add_async_extent(struct async_cow *cow,
 	return 0;
 }
 
+static inline int inode_need_compress(struct inode *inode)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
+	/* force compress */
+	if (btrfs_test_opt(root, FORCE_COMPRESS))
+		return 1;
+	/* bad compression ratios */
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
+		return 0;
+	if (btrfs_test_opt(root, COMPRESS) ||
+	    BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS ||
+	    BTRFS_I(inode)->force_compress)
+		return 1;
+	return 0;
+}
+
 /*
  * we create compressed extents in two phases.  The first
  * phase compresses a range of pages that have already been
@@ -444,10 +461,7 @@ again:
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS) &&
-	    (btrfs_test_opt(root, COMPRESS) ||
-	     (BTRFS_I(inode)->force_compress) ||
-	     (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS))) {
+	if (inode_need_compress(inode)) {
 		WARN_ON(pages);
 		pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
 		if (!pages) {
@@ -1076,7 +1090,8 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
 
-		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
+		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
+		    !btrfs_test_opt(root, FORCE_COMPRESS))
 			cur_end = end;
 		else
 			cur_end = min(end, start + 512 * 1024 - 1);
-- 
1.8.2.1

