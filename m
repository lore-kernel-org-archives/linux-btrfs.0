Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41800 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751374AbaLaBxr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 20:53:47 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBV1rFrS027888
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Dec 2014 09:53:15 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: cleanup init for list in free-space-cache
Date: Wed, 31 Dec 2014 09:51:35 +0800
Message-ID: <1419990695-2062-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

o removed an unecessary INIT_LIST_HEAD after LIST_HEAD

o merge a declare & INIT_LIST_HEAD pair into one LIST_HEAD

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d6c03f7..8d346d3 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -651,15 +651,13 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	struct io_ctl io_ctl;
 	struct btrfs_key key;
 	struct btrfs_free_space *e, *n;
-	struct list_head bitmaps;
+	LIST_HEAD(bitmaps);
 	u64 num_entries;
 	u64 num_bitmaps;
 	u64 generation;
 	u8 type;
 	int ret = 0;
 
-	INIT_LIST_HEAD(&bitmaps);
-
 	/* Nothing in the space cache, goodbye */
 	if (!i_size_read(inode))
 		return 0;
@@ -2903,7 +2901,6 @@ int btrfs_find_space_cluster(struct btrfs_root *root,
 	trace_btrfs_find_cluster(block_group, offset, bytes, empty_size,
 				 min_bytes);
 
-	INIT_LIST_HEAD(&bitmaps);
 	ret = setup_cluster_no_bitmap(block_group, cluster, &bitmaps, offset,
 				      bytes + empty_size,
 				      cont1_bytes, min_bytes);
-- 
1.8.1.4

