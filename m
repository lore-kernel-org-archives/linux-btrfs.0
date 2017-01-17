Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33576 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751342AbdAQWjg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:39:36 -0500
Received: by mail-wm0-f65.google.com with SMTP id r144so41964805wme.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:39:36 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 19/24] btrfs: Make drop_one_dir_item take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:45 +0200
Message-Id: <1484692310-3987-20-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index b2c0a30811f6..35434d686653 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -843,7 +843,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 				      struct btrfs_root *root,
 				      struct btrfs_path *path,
-				      struct inode *dir,
+				      struct btrfs_inode *dir,
 				      struct btrfs_dir_item *di)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -875,7 +875,7 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir), BTRFS_I(inode), name, name_len);
+	ret = btrfs_unlink_inode(trans, root, dir, BTRFS_I(inode), name, name_len);
 	if (ret)
 		goto out;
 	else
@@ -1151,7 +1151,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(BTRFS_I(dir)),
 					 ref_index, name, namelen, 0);
 	if (di && !IS_ERR(di)) {
-		ret = drop_one_dir_item(trans, root, path, dir, di);
+		ret = drop_one_dir_item(trans, root, path, BTRFS_I(dir), di);
 		if (ret)
 			return ret;
 	}
@@ -1161,7 +1161,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	di = btrfs_lookup_dir_item(trans, root, path, btrfs_ino(BTRFS_I(dir)),
 				   name, namelen, 0);
 	if (di && !IS_ERR(di)) {
-		ret = drop_one_dir_item(trans, root, path, dir, di);
+		ret = drop_one_dir_item(trans, root, path, BTRFS_I(dir), di);
 		if (ret)
 			return ret;
 	}
@@ -1769,7 +1769,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	if (!exists)
 		goto out;
 
-	ret = drop_one_dir_item(trans, root, path, dir, dst_di);
+	ret = drop_one_dir_item(trans, root, path, BTRFS_I(dir), dst_di);
 	if (ret)
 		goto out;
 
-- 
2.7.4

