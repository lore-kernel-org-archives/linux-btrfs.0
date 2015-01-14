Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56535 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752469AbbANIVV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 03:21:21 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0E8KhNm025582
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Jan 2015 16:20:43 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: cleanup a straight free-after-malloc branch for free-space-cache
Date: Wed, 14 Jan 2015 16:18:54 +0800
Message-ID: <1421223534-11799-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move the branch that is unrelated to the result of io_ctl_init() before
the function call, so we can save a kmalloc() & kfree() pair in that
branch.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d6c03f7..88f6122 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1132,10 +1132,6 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	if (!i_size_read(inode))
 		return -1;
 
-	ret = io_ctl_init(&io_ctl, inode, root, 1);
-	if (ret)
-		return -1;
-
 	if (block_group && (block_group->flags & BTRFS_BLOCK_GROUP_DATA)) {
 		down_write(&block_group->data_rwsem);
 		spin_lock(&block_group->lock);
@@ -1145,11 +1141,15 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 			up_write(&block_group->data_rwsem);
 			BTRFS_I(inode)->generation = 0;
 			ret = 0;
-			goto out;
+			goto out_skip;
 		}
 		spin_unlock(&block_group->lock);
 	}
 
+	ret = io_ctl_init(&io_ctl, inode, root, 1);
+	if (ret)
+		return -1;
+
 	/* Lock all pages first so we can lock the extent safely. */
 	io_ctl_prepare_pages(&io_ctl, inode, 0);
 
@@ -1212,13 +1212,14 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	/* Flush the dirty pages in the cache file. */
 	ret = flush_dirty_cache(inode);
 	if (ret)
-		goto out;
+		goto out_free;
 
 	/* Update the cache item to tell everyone this cache file is valid. */
 	ret = update_cache_item(trans, root, inode, path, offset,
 				entries, bitmaps);
-out:
+out_free:
 	io_ctl_free(&io_ctl);
+out_skip:
 	if (ret) {
 		invalidate_inode_pages2(inode->i_mapping);
 		BTRFS_I(inode)->generation = 0;
@@ -1232,7 +1233,7 @@ out_nospc:
 	if (block_group && (block_group->flags & BTRFS_BLOCK_GROUP_DATA))
 		up_write(&block_group->data_rwsem);
 
-	goto out;
+	goto out_free;
 }
 
 int btrfs_write_out_cache(struct btrfs_root *root,
-- 
1.8.1.4

