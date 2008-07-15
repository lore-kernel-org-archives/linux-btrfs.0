From: "Yan Zheng" <yanzheng@21cn.com>
Subject: [PATCH] Fix .. lookup corner case
Date: Tue, 15 Jul 2008 21:56:09 +0800
Message-ID: <3d0408630807150656r122ac6acm7b0ab4f575efd53f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Inode ref item can be in the next leaf when we find "path->slots[0] ==
btrfs_header_nritems(...)".

Regards
YZ
---
diff -r 3f0eee804974 inode.c
--- a/inode.c	Thu Jun 26 10:34:20 2008 -0400
+++ b/inode.c	Tue Jul 15 21:38:01 2008 +0800
@@ -1312,22 +1312,19 @@ static int btrfs_inode_by_name(struct in
 	if (namelen == 2 && strcmp(name, "..") == 0) {
 		struct btrfs_key key;
 		struct extent_buffer *leaf;
-		u32 nritems;
 		int slot;

 		key.objectid = dir->i_ino;
 		btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
-		key.offset = 0;
+		key.offset = (u64)-1;
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		if (ret < 0 || path->slots[0] == 0)
+			goto out_err;
 		BUG_ON(ret == 0);
 		ret = 0;

 		leaf = path->nodes[0];
-		slot = path->slots[0];
-		nritems = btrfs_header_nritems(leaf);
-		if (slot >= nritems)
-			goto out_err;
-
+		slot = path->slots[0] - 1;
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.objectid != dir->i_ino ||
 		    key.type != BTRFS_INODE_REF_KEY) {
@@ -1536,16 +1533,15 @@ static int btrfs_readdir(struct file *fi
 	/* special case for .., just use the back ref */
 	if (filp->f_pos == 1) {
 		btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
-		key.offset = 0;
+		key.offset = (u64)-1;
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		if (ret < 0 || path->slots[0] == 0) {
+			btrfs_release_path(root, path);
+			goto read_dir_items;
+		}
 		BUG_ON(ret == 0);
 		leaf = path->nodes[0];
-		slot = path->slots[0];
-		nritems = btrfs_header_nritems(leaf);
-		if (slot >= nritems) {
-			btrfs_release_path(root, path);
-			goto read_dir_items;
-		}
+		slot = path->slots[0] - 1;
 		btrfs_item_key_to_cpu(leaf, &found_key, slot);
 		btrfs_release_path(root, path);
 		if (found_key.objectid != key.objectid ||
