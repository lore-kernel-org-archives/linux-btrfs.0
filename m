Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6061 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752477AbaGQDtf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 23:49:35 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6H3nJVf031819
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 11:49:19 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/6] Btrfs: fall into nocompression codes quickly if possible
Date: Thu, 17 Jul 2014 11:44:10 +0800
Message-ID: <1405568654-22120-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If flag NOCOMPRESS is set which means bad compression ratio,
we could avoid call cow_file_range_async() for this case earlier.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 20798f8..e678391 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1468,7 +1468,6 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 			      unsigned long *nr_written)
 {
 	int ret;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int force_cow = need_force_cow(inode, start, end);
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
@@ -1477,9 +1476,7 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!btrfs_test_opt(root, COMPRESS) &&
-		   !(BTRFS_I(inode)->force_compress) &&
-		   !(BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS)) {
+	} else if (!inode_need_compress(inode)) {
 		ret = cow_file_range(inode, locked_page, start, end,
 				      page_started, nr_written, 1);
 	} else {
-- 
1.8.2.1

