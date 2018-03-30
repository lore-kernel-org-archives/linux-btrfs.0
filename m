Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:47824 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752346AbeC3WMM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 18:12:12 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not abort transaction when failing to insert hole extent
Date: Sat, 31 Mar 2018 06:11:55 +0800
Message-Id: <1522447918-19147-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is running in a typical write path, not inside a critical path
where we have to abort the running transaction, so it's OK to return
errors to callers and eventually to userspace.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/inode.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c7b75dd..b9310f8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4939,16 +4939,13 @@ static int maybe_insert_hole(struct btrfs_root *root, struct inode *inode,
 
 	ret = btrfs_drop_extents(trans, root, inode, offset, offset + len, 1);
 	if (ret) {
-		btrfs_abort_transaction(trans, ret);
 		btrfs_end_transaction(trans);
 		return ret;
 	}
 
 	ret = btrfs_insert_file_extent(trans, root, btrfs_ino(BTRFS_I(inode)),
 			offset, 0, 0, len, 0, len, 0, 0, 0);
-	if (ret)
-		btrfs_abort_transaction(trans, ret);
-	else
+	if (!ret)
 		btrfs_update_inode(trans, root, inode);
 	btrfs_end_transaction(trans);
 	return ret;
-- 
1.8.3.1

