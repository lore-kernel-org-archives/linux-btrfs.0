Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:45639 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab2K3Dkx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Nov 2012 22:40:53 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so2145fae.1
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 19:40:51 -0800 (PST)
From: Filipe Brandenburger <filbranden@google.com>
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 2/2] Btrfs: refactor error handling to drop inode in btrfs_create()
Date: Thu, 29 Nov 2012 19:40:09 -0800
Message-Id: <1354246809-32339-3-git-send-email-filbranden@google.com>
In-Reply-To: <1354246809-32339-2-git-send-email-filbranden@google.com>
References: <1354246809-32339-1-git-send-email-filbranden@google.com>
 <1354246809-32339-2-git-send-email-filbranden@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Refactor it by checking whether the inode has been created and needs to be
dropped (drop_inode_on_err) and also if the err variable is set. That way the
variable doesn't need to be set on each and every error handling block.

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
 fs/btrfs/inode.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index caf9d76..1d66c9e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4963,7 +4963,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct inode *inode = NULL;
-	int drop_inode = 0;
+	int drop_inode_on_err = 0;
 	int err;
 	unsigned long nr = 0;
 	u64 objectid;
@@ -4989,18 +4989,15 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 		err = PTR_ERR(inode);
 		goto out_unlock;
 	}
+	drop_inode_on_err = 1;
 
 	err = btrfs_init_inode_security(trans, inode, dir, &dentry->d_name);
-	if (err) {
-		drop_inode = 1;
+	if (err)
 		goto out_unlock;
-	}
 
 	err = btrfs_update_inode(trans, root, inode);
-	if (err) {
-		drop_inode = 1;
+	if (err)
 		goto out_unlock;
-	}
 
 	/*
 	* If the active LSM wants to access the inode during
@@ -5013,17 +5010,17 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 
 	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
 	if (err)
-		drop_inode = 1;
-	else {
-		inode->i_mapping->a_ops = &btrfs_aops;
-		inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
-		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
-		d_instantiate(dentry, inode);
-	}
+		goto out_unlock;
+
+	inode->i_mapping->a_ops = &btrfs_aops;
+	inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
+	BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
+	d_instantiate(dentry, inode);
+
 out_unlock:
 	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
-	if (drop_inode) {
+	if (err && drop_inode_on_err) {
 		inode_dec_link_count(inode);
 		iput(inode);
 	}
-- 
1.7.11.7

