Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33285 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdAQWmS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:42:18 -0500
Received: by mail-wm0-f65.google.com with SMTP id r144so41979119wme.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:42:18 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 06/24] btrfs: Make btrfs_del_dir_entries_in_log take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:32 +0200
Message-Id: <1484692310-3987-7-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/inode.c    |  2 +-
 fs/btrfs/tree-log.c | 10 +++++-----
 fs/btrfs/tree-log.h |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 41b1e2ed63b4..ebfeabafe1b1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4075,7 +4075,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	}
 
 	ret = btrfs_del_dir_entries_in_log(trans, root, name, name_len,
-					   dir, index);
+					   BTRFS_I(dir), index);
 	if (ret == -ENOENT)
 		ret = 0;
 	else if (ret)
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index df822908f2be..caa8d886b4ae 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3084,7 +3084,7 @@ int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
 int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 const char *name, int name_len,
-				 struct inode *dir, u64 index)
+				 struct btrfs_inode *dir, u64 index)
 {
 	struct btrfs_root *log;
 	struct btrfs_dir_item *di;
@@ -3092,16 +3092,16 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	int ret;
 	int err = 0;
 	int bytes_del = 0;
-	u64 dir_ino = btrfs_ino(BTRFS_I(dir));
+	u64 dir_ino = btrfs_ino(dir);
 
-	if (BTRFS_I(dir)->logged_trans < trans->transid)
+	if (dir->logged_trans < trans->transid)
 		return 0;
 
 	ret = join_running_log_trans(root);
 	if (ret)
 		return 0;
 
-	mutex_lock(&BTRFS_I(dir)->log_mutex);
+	mutex_lock(&dir->log_mutex);
 
 	log = root->log_root;
 	path = btrfs_alloc_path();
@@ -3176,7 +3176,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 fail:
 	btrfs_free_path(path);
 out_unlock:
-	mutex_unlock(&BTRFS_I(dir)->log_mutex);
+	mutex_unlock(&dir->log_mutex);
 	if (ret == -ENOSPC) {
 		btrfs_set_log_full_commit(root->fs_info, trans);
 		ret = 0;
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 2bcbac7efa9c..6c2b316b28e0 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -72,7 +72,7 @@ int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
 int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 const char *name, int name_len,
-				 struct inode *dir, u64 index);
+				 struct btrfs_inode *dir, u64 index);
 int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       const char *name, int name_len,
-- 
2.7.4

