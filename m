Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:35045 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757051AbdAJSgK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 13:36:10 -0500
Received: by mail-wj0-f195.google.com with SMTP id ey1so9326061wjd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 10:36:10 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 12/12] btrfs: Make btrfs_inode_delayed_dir_index_count take btrfs_inode
Date: Tue, 10 Jan 2017 20:35:42 +0200
Message-Id: <1484073342-28854-13-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/delayed-inode.c | 6 +++---
 fs/btrfs/delayed-inode.h | 2 +-
 fs/btrfs/inode.c         | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 0afbea220fbb..00a3e62222d6 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1556,9 +1556,9 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_inode_delayed_dir_index_count(struct inode *inode)
+int btrfs_inode_delayed_dir_index_count(struct btrfs_inode *inode)
 {
-	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(BTRFS_I(inode));
+	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(inode);
 
 	if (!delayed_node)
 		return -ENOENT;
@@ -1573,7 +1573,7 @@ int btrfs_inode_delayed_dir_index_count(struct inode *inode)
 		return -EINVAL;
 	}
 
-	BTRFS_I(inode)->index_cnt = delayed_node->index_cnt;
+	inode->index_cnt = delayed_node->index_cnt;
 	btrfs_release_delayed_node(delayed_node);
 	return 0;
 }
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 40bf1a943146..40327cc3b99a 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -109,7 +109,7 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 				   struct btrfs_fs_info *fs_info,
 				   struct btrfs_inode *dir, u64 index);
 
-int btrfs_inode_delayed_dir_index_count(struct inode *inode);
+int btrfs_inode_delayed_dir_index_count(struct btrfs_inode *inode);
 
 int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 92051c441435..80060aa2eda2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6106,7 +6106,7 @@ int btrfs_set_inode_index(struct inode *dir, u64 *index)
 	int ret = 0;
 
 	if (BTRFS_I(dir)->index_cnt == (u64)-1) {
-		ret = btrfs_inode_delayed_dir_index_count(dir);
+		ret = btrfs_inode_delayed_dir_index_count(BTRFS_I(dir));
 		if (ret) {
 			ret = btrfs_set_inode_index_count(dir);
 			if (ret)
-- 
2.7.4

