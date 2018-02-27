Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39519 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753133AbeB0PhX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 10:37:23 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1AB6BAEB8
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 15:37:22 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/3] btrfs: Remove root argument from btrfs_log_dentry_safe
Date: Tue, 27 Feb 2018 17:37:18 +0200
Message-Id: <1519745838-25584-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1519745838-25584-1-git-send-email-nborisov@suse.com>
References: <1519745838-25584-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that nothing uses the root arg of btrfs_log_dentry_safe it can be
safely removed. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/file.c     | 2 +-
 fs/btrfs/tree-log.c | 2 +-
 fs/btrfs/tree-log.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 41ab9073d1d4..f048879c222f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2214,7 +2214,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 	trans->sync = true;
 
-	ret = btrfs_log_dentry_safe(trans, root, dentry, start, end, &ctx);
+	ret = btrfs_log_dentry_safe(trans, dentry, start, end, &ctx);
 	if (ret < 0) {
 		/* Fallthrough and commit/free transaction. */
 		ret = 1;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f6b1795c44ee..f83048023666 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5572,7 +5572,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
  * data on disk.
  */
 int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct dentry *dentry,
+			  struct dentry *dentry,
 			  const loff_t start,
 			  const loff_t end,
 			  struct btrfs_log_ctx *ctx)
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 483027f9a7f4..88abc43312a1 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -65,7 +65,7 @@ int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info);
 int btrfs_recover_log_trees(struct btrfs_root *tree_root);
 int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct dentry *dentry,
+			  struct dentry *dentry,
 			  const loff_t start,
 			  const loff_t end,
 			  struct btrfs_log_ctx *ctx);
-- 
2.7.4

