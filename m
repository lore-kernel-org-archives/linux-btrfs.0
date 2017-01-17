Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33752 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdAQWiK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:38:10 -0500
Received: by mail-wm0-f66.google.com with SMTP id r144so41958302wme.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:38:10 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 03/24] btrfs: Make btrfs_record_snapshot_destroy take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:29 +0200
Message-Id: <1484692310-3987-4-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/ioctl.c    | 2 +-
 fs/btrfs/tree-log.c | 8 ++++----
 fs/btrfs/tree-log.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e8e1f5f5f93a..7d1b5378de49 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2497,7 +2497,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	trans->block_rsv = &block_rsv;
 	trans->bytes_reserved = block_rsv.size;
 
-	btrfs_record_snapshot_destroy(trans, dir);
+	btrfs_record_snapshot_destroy(trans, BTRFS_I(dir));
 
 	ret = btrfs_unlink_subvol(trans, root, dir,
 				dest->root_key.objectid,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6f9a3beb7050..581d31171683 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5794,11 +5794,11 @@ void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
  * parent root and tree of tree roots trees, etc) are done.
  */
 void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
-				   struct inode *dir)
+				   struct btrfs_inode *dir)
 {
-	mutex_lock(&BTRFS_I(dir)->log_mutex);
-	BTRFS_I(dir)->last_unlink_trans = trans->transid;
-	mutex_unlock(&BTRFS_I(dir)->log_mutex);
+	mutex_lock(&dir->log_mutex);
+	dir->last_unlink_trans = trans->transid;
+	mutex_unlock(&dir->log_mutex);
 }
 
 /*
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 69702eef9603..e08ce78b2ad4 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -83,7 +83,7 @@ void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
 			     struct btrfs_inode *dir, struct btrfs_inode *inode,
 			     int for_rename);
 void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
-				   struct inode *dir);
+				   struct btrfs_inode *dir);
 int btrfs_log_new_name(struct btrfs_trans_handle *trans,
 			struct inode *inode, struct inode *old_dir,
 			struct dentry *parent);
-- 
2.7.4

