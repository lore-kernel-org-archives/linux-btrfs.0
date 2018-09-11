Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:56920 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727998AbeILDIJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 23:08:09 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove unused code in __btrfs_unlink_inode
Date: Wed, 12 Sep 2018 06:06:25 +0800
Message-Id: <1536703587-94565-6-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It might get @leaf and @key in order to do some sanity checks on key's
fields, but since we don't check it any more, it's fine to remove the
code.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/inode.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d3febc3a6bc0..fd64d7ac76f9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3911,9 +3911,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_path *path;
 	int ret = 0;
-	struct extent_buffer *leaf;
 	struct btrfs_dir_item *di;
-	struct btrfs_key key;
 	u64 index;
 	u64 ino = btrfs_ino(inode);
 	u64 dir_ino = btrfs_ino(dir);
@@ -3935,8 +3933,6 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		ret = -ENOENT;
 		goto err;
 	}
-	leaf = path->nodes[0];
-	btrfs_dir_item_key_to_cpu(leaf, di, &key);
 	ret = btrfs_delete_one_dir_name(trans, root, path, di);
 	if (ret)
 		goto err;
-- 
1.8.3.1
