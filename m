Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:35031 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939115AbdAJSgD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 13:36:03 -0500
Received: by mail-wj0-f195.google.com with SMTP id ey1so9325973wjd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 10:36:03 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 10/12] btrfs: Make btrfs_commit_inode_delayed_inode take btrfs_inode
Date: Tue, 10 Jan 2017 20:35:40 +0200
Message-Id: <1484073342-28854-11-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/delayed-inode.c | 6 +++---
 fs/btrfs/delayed-inode.h | 2 +-
 fs/btrfs/inode.c         | 2 +-
 fs/btrfs/tree-log.c      | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 5d4dd3e18af3..17af7b186916 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1231,11 +1231,11 @@ int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_commit_inode_delayed_inode(struct inode *inode)
+int btrfs_commit_inode_delayed_inode(struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	struct btrfs_trans_handle *trans;
-	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(BTRFS_I(inode));
+	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(inode);
 	struct btrfs_path *path;
 	struct btrfs_block_rsv *block_rsv;
 	int ret;
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 81572693d0e0..cd80fe8f150f 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -123,7 +123,7 @@ int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 /* Used for evicting the inode. */
 void btrfs_remove_delayed_node(struct btrfs_inode *inode);
 void btrfs_kill_delayed_inode_items(struct btrfs_inode *inode);
-int btrfs_commit_inode_delayed_inode(struct inode *inode);
+int btrfs_commit_inode_delayed_inode(struct btrfs_inode *inode);
 
 
 int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 874a8689938f..92051c441435 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5274,7 +5274,7 @@ void btrfs_evict_inode(struct inode *inode)
 		goto no_delete;
 	}
 
-	ret = btrfs_commit_inode_delayed_inode(inode);
+	ret = btrfs_commit_inode_delayed_inode(BTRFS_I(inode));
 	if (ret) {
 		btrfs_orphan_del(NULL, inode);
 		goto no_delete;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 0ad6da8b194b..69ab3d19ea1e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4657,7 +4657,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	    BTRFS_I(inode)->generation > fs_info->last_trans_committed)
 		ret = btrfs_commit_inode_delayed_items(trans, inode);
 	else
-		ret = btrfs_commit_inode_delayed_inode(inode);
+		ret = btrfs_commit_inode_delayed_inode(BTRFS_I(inode));
 
 	if (ret) {
 		btrfs_free_path(path);
-- 
2.7.4

