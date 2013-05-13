Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:54943 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab3EMNxi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 09:53:38 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.27 OK)
	with ESMTP id X02f08p4D7BpT1 for <linux-btrfs@vger.kernel.org>;
	Mon, 13 May 2013 15:53:35 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btrfs: cleanup: don't check the same thing twice
Date: Mon, 13 May 2013 15:53:35 +0200
Message-Id: <3d9ca988fc244d8ce11302cdfb3a55ff085524f8.1368450252.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368450252.git.sbehrens@giantdisaster.de>
References: <cover.1368450252.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368450252.git.sbehrens@giantdisaster.de>
References: <cover.1368450252.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_read_fs_root_no_name() already checks if btrfs_root_refs()
is zero and returns ENOENT in this case. There is no need to do
it again in six places.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/export.c |  5 -----
 fs/btrfs/file.c   |  4 ----
 fs/btrfs/inode.c  | 10 ----------
 fs/btrfs/ioctl.c  |  5 -----
 fs/btrfs/super.c  |  3 ---
 5 files changed, 27 deletions(-)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 81ee29e..4b86916 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -82,11 +82,6 @@ static struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
 		goto fail;
 	}
 
-	if (btrfs_root_refs(&root->root_item) == 0) {
-		err = -ENOENT;
-		goto fail;
-	}
-
 	key.objectid = objectid;
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 	key.offset = 0;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b3e359b..185af15 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -308,10 +308,6 @@ static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 		ret = PTR_ERR(inode_root);
 		goto cleanup;
 	}
-	if (btrfs_root_refs(&inode_root->root_item) == 0) {
-		ret = -ENOENT;
-		goto cleanup;
-	}
 
 	key.objectid = defrag->ino;
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1669c3b..0457347 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2258,11 +2258,6 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 			return 0;
 		return PTR_ERR(root);
 	}
-	if (btrfs_root_refs(&root->root_item) == 0) {
-		srcu_read_unlock(&fs_info->subvol_srcu, index);
-		/* parse ENOENT to 0 */
-		return 0;
-	}
 
 	/* step 2: get inode */
 	key.objectid = backref->inum;
@@ -4816,11 +4811,6 @@ static int fixup_tree_root_location(struct btrfs_root *root,
 		goto out;
 	}
 
-	if (btrfs_root_refs(&new_root->root_item) == 0) {
-		err = -ENOENT;
-		goto out;
-	}
-
 	*sub_root = new_root;
 	location->objectid = btrfs_root_dirid(&new_root->root_item);
 	location->type = BTRFS_INODE_ITEM_KEY;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1e0dda1..b2537c7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2951,11 +2951,6 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 		goto out;
 	}
 
-	if (btrfs_root_refs(&new_root->root_item) == 0) {
-		ret = -ENOENT;
-		goto out;
-	}
-
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c02c59a..b6af7d3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -775,9 +775,6 @@ find_root:
 	if (IS_ERR(new_root))
 		return ERR_CAST(new_root);
 
-	if (btrfs_root_refs(&new_root->root_item) == 0)
-		return ERR_PTR(-ENOENT);
-
 	dir_id = btrfs_root_dirid(&new_root->root_item);
 setup_root:
 	location.objectid = dir_id;
-- 
1.8.2.2

