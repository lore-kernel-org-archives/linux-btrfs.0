Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:20620 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932872AbeCEJIg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Mar 2018 04:08:36 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 7B3B048AE761
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Mar 2018 17:08:30 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: adjust return values of btrfs_inode_by_name
Date: Mon, 5 Mar 2018 17:13:37 +0800
Message-ID: <20180305091337.22854-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously, btrfs_inode_by_name() returns 0 which leaves caller to
check objectid of location even location type is invalid.

Let btrfs_inode_by_name() returns -EUCLEAN if found corrupted
location of a dir entry.
Removal of label out_err also simplifies the function.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 53ca025655fc..c7155f9d7c6f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5448,7 +5448,8 @@ void btrfs_evict_inode(struct inode *inode)
 
 /*
  * this returns the key found in the dir entry in the location pointer.
- * If no dir entries were found, location->objectid is 0.
+ * If no dir entries were found, returns -ENOENT.
+ * If found a corrupted location in dir entry, returns -EUCLEAN.
  */
 static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 			       struct btrfs_key *location)
@@ -5466,27 +5467,27 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 
 	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(BTRFS_I(dir)),
 			name, namelen, 0);
-	if (IS_ERR(di))
+	if (unlikely(!di)) {
+		ret = -ENOENT;
+		goto out;
+	}
+	if (IS_ERR(di)) {
 		ret = PTR_ERR(di);
-
-	if (IS_ERR_OR_NULL(di))
-		goto out_err;
+		goto out;
+	}
 
 	btrfs_dir_item_key_to_cpu(path->nodes[0], di, location);
 	if (location->type != BTRFS_INODE_ITEM_KEY &&
 	    location->type != BTRFS_ROOT_ITEM_KEY) {
+		ret = -EUCLEAN;
 		btrfs_warn(root->fs_info,
 "%s gets something invalid in DIR_ITEM (name %s, directory ino %llu, location(%llu %u %llu))",
 			   __func__, name, btrfs_ino(BTRFS_I(dir)),
 			   location->objectid, location->type, location->offset);
-		goto out_err;
 	}
 out:
 	btrfs_free_path(path);
 	return ret;
-out_err:
-	location->objectid = 0;
-	goto out;
 }
 
 /*
@@ -5789,9 +5790,6 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	if (location.objectid == 0)
-		return ERR_PTR(-ENOENT);
-
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, &location, root, NULL);
 		return inode;
-- 
2.16.1



