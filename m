Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16509 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753433AbcESJpL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 05:45:11 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 128A8489F960
	for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 17:44:57 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: remove unnecessary btrfs_delalloc_release_metadata() call
Date: Thu, 19 May 2016 17:44:10 +0800
Message-ID: <1463651050-6922-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In __btrfs_write_out_cache(), we don't call btrfs_delalloc_reserve_metadata()
or btrfs_delalloc_reserve_space() to reserve metadata space, so we also should
not call btrfs_delalloc_release_metadata(), in which BTRFS_I(inode)->outstanding_extents
will be decreased, then WARN_ON(BTRFS_I(inode)->outstanding_extents) in
btrfs_destroy_inode() will be triggered.

To be honest, I do not see this WARNING in real, but I think we should fix it.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 8f835bf..ababf56 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3512,7 +3512,6 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
 	int ret;
 	struct btrfs_io_ctl io_ctl;
-	bool release_metadata = true;
 
 	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
 		return 0;
@@ -3520,26 +3519,16 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 	memset(&io_ctl, 0, sizeof(io_ctl));
 	ret = __btrfs_write_out_cache(root, inode, ctl, NULL, &io_ctl,
 				      trans, path, 0);
-	if (!ret) {
-		/*
-		 * At this point writepages() didn't error out, so our metadata
-		 * reservation is released when the writeback finishes, at
-		 * inode.c:btrfs_finish_ordered_io(), regardless of it finishing
-		 * with or without an error.
-		 */
-		release_metadata = false;
+	if (!ret)
 		ret = btrfs_wait_cache_io(root, trans, NULL, &io_ctl, path, 0);
-	}
 
-	if (ret) {
-		if (release_metadata)
-			btrfs_delalloc_release_metadata(inode, inode->i_size);
 #ifdef DEBUG
+	if (ret) {
 		btrfs_err(root->fs_info,
 			"failed to write free ino cache for root %llu",
 			root->root_key.objectid);
-#endif
 	}
+#endif
 
 	return ret;
 }
-- 
1.8.3.1



