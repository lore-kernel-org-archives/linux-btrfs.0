Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5274 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751435AbdCAE3K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 23:29:10 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 8481247D8B60
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:16 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 11/20] btrfs-progs: inode.c: alter btrfs_add_link
Date: Wed, 1 Mar 2017 11:13:54 +0800
Message-ID: <20170301031403.23902-12-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add an arg 'ignore_existed' to btrfs_add_link.
If ignore_existed=1, continue to add while relative dir index/item
or inode ref is already existed.

This patch is for further repair.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c   |  6 +++---
 convert/main.c |  2 +-
 ctree.h        |  2 +-
 inode.c        | 46 ++++++++++++++++++++++++++--------------------
 4 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 685f4f5d..bda0849b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2855,7 +2855,7 @@ static int reset_nlink(struct btrfs_trans_handle *trans,
 	list_for_each_entry(backref, &rec->backrefs, list) {
 		ret = btrfs_add_link(trans, root, rec->ino, backref->dir,
 				     backref->name, backref->namelen,
-				     backref->filetype, &backref->index, 1);
+				     backref->filetype, &backref->index, 1, 0);
 		if (ret < 0)
 			goto out;
 	}
@@ -2947,7 +2947,7 @@ static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
 			goto out;
 		}
 		ret = btrfs_add_link(trans, root, rec->ino, lost_found_ino,
-				     namebuf, namelen, type, NULL, 1);
+				     namebuf, namelen, type, NULL, 1, 0);
 		/*
 		 * Add ".INO" suffix several times to handle case where
 		 * "FILENAME.INO" is already taken by another file.
@@ -2966,7 +2966,7 @@ static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
 			namelen += count_digits(rec->ino) + 1;
 			ret = btrfs_add_link(trans, root, rec->ino,
 					     lost_found_ino, namebuf,
-					     namelen, type, NULL, 1);
+					     namelen, type, NULL, 1, 0);
 		}
 		if (ret < 0) {
 			fprintf(stderr,
diff --git a/convert/main.c b/convert/main.c
index 8d9f29fa..7607bec1 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -998,7 +998,7 @@ static int create_image(struct btrfs_root *root,
 	if (ret < 0)
 		goto out;
 	ret = btrfs_add_link(trans, root, ino, BTRFS_FIRST_FREE_OBJECTID, name,
-			     strlen(name), BTRFS_FT_REG_FILE, NULL, 1);
+			     strlen(name), BTRFS_FT_REG_FILE, NULL, 1, 0);
 	if (ret < 0)
 		goto out;
 
diff --git a/ctree.h b/ctree.h
index 0c34ae20..a28e36de 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2779,7 +2779,7 @@ int btrfs_change_inode_flags(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 ino, u64 flags);
 int btrfs_add_link(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   u64 ino, u64 parent_ino, char *name, int namelen,
-		   u8 type, u64 *index, int add_backref);
+		   u8 type, u64 *index, int add_backref, int ignore_existed);
 int btrfs_unlink(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		 u64 ino, u64 parent_ino, u64 index, const char *name,
 		 int namelen, int add_orphan);
diff --git a/inode.c b/inode.c
index 991b8ddb..62e8abec 100644
--- a/inode.c
+++ b/inode.c
@@ -161,7 +161,7 @@ out:
  */
 int btrfs_add_link(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   u64 ino, u64 parent_ino, char *name, int namelen,
-		   u8 type, u64 *index, int add_backref)
+		   u8 type, u64 *index, int add_backref, int ignore_existed)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -184,33 +184,38 @@ int btrfs_add_link(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	}
 
 	ret = check_dir_conflict(root, name, namelen, parent_ino, ret_index);
-	if (ret < 0)
+	if (ret < 0 && (!ignore_existed || ret != -EEXIST))
 		goto out;
 
 	/* Add inode ref */
 	if (add_backref) {
 		ret = btrfs_insert_inode_ref(trans, root, name, namelen,
 					     ino, parent_ino, ret_index);
-		if (ret < 0)
+		if (ret < 0 && (!ignore_existed || ret != -EEXIST))
 			goto out;
 
-		/* Update nlinks for the inode */
-		key.objectid = ino;
-		key.type = BTRFS_INODE_ITEM_KEY;
-		key.offset = 0;
-		ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
-		if (ret) {
-			if (ret > 0)
-				ret = -ENOENT;
-			goto out;
+		/* do not update nlinks if existed */
+		if (!ret) {
+			/* Update nlinks for the inode */
+			key.objectid = ino;
+			key.type = BTRFS_INODE_ITEM_KEY;
+			key.offset = 0;
+			ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
+			if (ret) {
+				if (ret > 0)
+					ret = -ENOENT;
+				goto out;
+			}
+			inode_item = btrfs_item_ptr(path->nodes[0],
+						    path->slots[0],
+						    struct btrfs_inode_item);
+			nlink = btrfs_inode_nlink(path->nodes[0], inode_item);
+			nlink++;
+			btrfs_set_inode_nlink(path->nodes[0], inode_item,
+					      nlink);
+			btrfs_mark_buffer_dirty(path->nodes[0]);
+			btrfs_release_path(path);
 		}
-		inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
-				    struct btrfs_inode_item);
-		nlink = btrfs_inode_nlink(path->nodes[0], inode_item);
-		nlink++;
-		btrfs_set_inode_nlink(path->nodes[0], inode_item, nlink);
-		btrfs_mark_buffer_dirty(path->nodes[0]);
-		btrfs_release_path(path);
 	}
 
 	/* Add dir_item and dir_index */
@@ -219,6 +224,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	key.offset = 0;
 	ret = btrfs_insert_dir_item(trans, root, name, namelen, parent_ino,
 				    &key, type, ret_index);
+
 	if (ret < 0)
 		goto out;
 
@@ -561,7 +567,7 @@ int btrfs_mkdir(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	if (ret)
 		goto out;
 	ret = btrfs_add_link(trans, root, ret_ino, parent_ino, name, namelen,
-			     BTRFS_FT_DIR, NULL, 1);
+			     BTRFS_FT_DIR, NULL, 1, 0);
 	if (ret)
 		goto out;
 out:
-- 
2.11.1



