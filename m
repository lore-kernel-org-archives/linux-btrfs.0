Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35925 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdAQWlS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:41:18 -0500
Received: by mail-wm0-f65.google.com with SMTP id r126so42001204wmr.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:41:18 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 07/24] btrfs: Make btrfs_del_inode_ref take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:33 +0200
Message-Id: <1484692310-3987-8-git-send-email-n.borisov.lkml@gmail.com>
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
index ebfeabafe1b1..e86b08eabb82 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4068,7 +4068,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	}
 
 	ret = btrfs_del_inode_ref_in_log(trans, root, name, name_len,
-					 inode, dir_ino);
+					 BTRFS_I(inode), dir_ino);
 	if (ret != 0 && ret != -ENOENT) {
 		btrfs_abort_transaction(trans, ret);
 		goto err;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index caa8d886b4ae..a7705173150e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3192,25 +3192,25 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       const char *name, int name_len,
-			       struct inode *inode, u64 dirid)
+			       struct btrfs_inode *inode, u64 dirid)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_root *log;
 	u64 index;
 	int ret;
 
-	if (BTRFS_I(inode)->logged_trans < trans->transid)
+	if (inode->logged_trans < trans->transid)
 		return 0;
 
 	ret = join_running_log_trans(root);
 	if (ret)
 		return 0;
 	log = root->log_root;
-	mutex_lock(&BTRFS_I(inode)->log_mutex);
+	mutex_lock(&inode->log_mutex);
 
-	ret = btrfs_del_inode_ref(trans, log, name, name_len, btrfs_ino(BTRFS_I(inode)),
+	ret = btrfs_del_inode_ref(trans, log, name, name_len, btrfs_ino(inode),
 				  dirid, &index);
-	mutex_unlock(&BTRFS_I(inode)->log_mutex);
+	mutex_unlock(&inode->log_mutex);
 	if (ret == -ENOSPC) {
 		btrfs_set_log_full_commit(fs_info, trans);
 		ret = 0;
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 6c2b316b28e0..bc50f128c6be 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -76,7 +76,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       const char *name, int name_len,
-			       struct inode *inode, u64 dirid);
+			       struct btrfs_inode *inode, u64 dirid);
 void btrfs_end_log_trans(struct btrfs_root *root);
 int btrfs_pin_log_trans(struct btrfs_root *root);
 void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
-- 
2.7.4

