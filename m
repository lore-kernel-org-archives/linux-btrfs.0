Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:33420 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728018AbeILDIL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 23:08:11 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: unify error handling of btrfs_lookup_dir_item
Date: Wed, 12 Sep 2018 06:06:26 +0800
Message-Id: <1536703587-94565-7-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unify the error handling part with IS_ERR_OR_NULL.

No functional changes.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/inode.c | 21 +++++----------------
 fs/btrfs/send.c  |  8 ++------
 2 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fd64d7ac76f9..99ab0203b701 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3925,12 +3925,8 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	path->leave_spinning = 1;
 	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
 				    name, name_len, -1);
-	if (IS_ERR(di)) {
-		ret = PTR_ERR(di);
-		goto err;
-	}
-	if (!di) {
-		ret = -ENOENT;
+	if (IS_ERR_OR_NULL(di)) {
+		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto err;
 	}
 	ret = btrfs_delete_one_dir_name(trans, root, path, di);
@@ -4088,10 +4084,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
 				   name, name_len, -1);
 	if (IS_ERR_OR_NULL(di)) {
-		if (!di)
-			ret = -ENOENT;
-		else
-			ret = PTR_ERR(di);
+		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto out;
 	}
 
@@ -5481,12 +5474,8 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 
 	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(BTRFS_I(dir)),
 			name, namelen, 0);
-	if (!di) {
-		ret = -ENOENT;
-		goto out;
-	}
-	if (IS_ERR(di)) {
-		ret = PTR_ERR(di);
+	if (IS_ERR_OR_NULL(di)) {
+		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto out;
 	}
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index ba8950bfd9c7..b8c83778f0f7 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1693,12 +1693,8 @@ static int lookup_dir_item_inode(struct btrfs_root *root,
 
 	di = btrfs_lookup_dir_item(NULL, root, path,
 			dir, name, name_len, 0);
-	if (!di) {
-		ret = -ENOENT;
-		goto out;
-	}
-	if (IS_ERR(di)) {
-		ret = PTR_ERR(di);
+	if (IS_ERR_OR_NULL(di)) {
+		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto out;
 	}
 	btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
-- 
1.8.3.1
