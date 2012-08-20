Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab2HTUfC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Aug 2012 16:35:02 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>, Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH v4 2/4] btrfs: improved readablity for add_inode_ref
Date: Mon, 20 Aug 2012 13:29:19 -0700
Message-Id: <1345494561-28758-3-git-send-email-mfasheh@suse.de>
In-Reply-To: <1345494561-28758-1-git-send-email-mfasheh@suse.de>
References: <1345494561-28758-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jan Schmidt <list.btrfs@jan-o-sch.net>

Moved part of the code into a sub function and replaced most of the gotos
by ifs, hoping that it will be easier to read now.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/tree-log.c |  178 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 97 insertions(+), 81 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 8abeae4..da265dd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -786,76 +786,18 @@ out:
 	return match;
 }
 
-
-/*
- * replay one inode back reference item found in the log tree.
- * eb, slot and key refer to the buffer and key found in the log tree.
- * root is the destination we are replaying into, and path is for temp
- * use by this function.  (it should be released on return).
- */
-static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
+static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
-				  struct btrfs_root *log,
 				  struct btrfs_path *path,
-				  struct extent_buffer *eb, int slot,
-				  struct btrfs_key *key)
+				  struct btrfs_root *log_root,
+				  struct inode *dir, struct inode *inode,
+				  struct btrfs_key *key,
+				  struct extent_buffer *eb,
+				  struct btrfs_inode_ref *ref,
+				  char *name, int namelen, int *search_done)
 {
-	struct btrfs_inode_ref *ref;
-	struct btrfs_dir_item *di;
-	struct inode *dir;
-	struct inode *inode;
-	unsigned long ref_ptr;
-	unsigned long ref_end;
-	char *name;
-	int namelen;
 	int ret;
-	int search_done = 0;
-
-	/*
-	 * it is possible that we didn't log all the parent directories
-	 * for a given inode.  If we don't find the dir, just don't
-	 * copy the back ref in.  The link count fixup code will take
-	 * care of the rest
-	 */
-	dir = read_one_inode(root, key->offset);
-	if (!dir)
-		return -ENOENT;
-
-	inode = read_one_inode(root, key->objectid);
-	if (!inode) {
-		iput(dir);
-		return -EIO;
-	}
-
-	ref_ptr = btrfs_item_ptr_offset(eb, slot);
-	ref_end = ref_ptr + btrfs_item_size_nr(eb, slot);
-
-again:
-	ref = (struct btrfs_inode_ref *)ref_ptr;
-
-	namelen = btrfs_inode_ref_name_len(eb, ref);
-	name = kmalloc(namelen, GFP_NOFS);
-	BUG_ON(!name);
-
-	read_extent_buffer(eb, name, (unsigned long)(ref + 1), namelen);
-
-	/* if we already have a perfect match, we're done */
-	if (inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
-			 btrfs_inode_ref_index(eb, ref),
-			 name, namelen)) {
-		goto out;
-	}
-
-	/*
-	 * look for a conflicting back reference in the metadata.
-	 * if we find one we have to unlink that name of the file
-	 * before we add our new link.  Later on, we overwrite any
-	 * existing back reference, and we don't want to create
-	 * dangling pointers in the directory.
-	 */
-
-	if (search_done)
-		goto insert;
+	struct btrfs_dir_item *di;
 
 	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
 	if (ret == 0) {
@@ -870,7 +812,7 @@ again:
 		 * if so, just jump out, we're done
 		 */
 		if (key->objectid == key->offset)
-			goto out_nowrite;
+			return 1;
 
 		/* check all the names in this back reference to see
 		 * if they are in the log.  if so, we allow them to stay
@@ -889,7 +831,7 @@ again:
 					   (unsigned long)(victim_ref + 1),
 					   victim_name_len);
 
-			if (!backref_in_log(log, key, victim_name,
+			if (!backref_in_log(log_root, key, victim_name,
 					    victim_name_len)) {
 				btrfs_inc_nlink(inode);
 				btrfs_release_path(path);
@@ -908,7 +850,7 @@ again:
 		 * NOTE: we have searched root tree and checked the
 		 * coresponding ref, it does not need to check again.
 		 */
-		search_done = 1;
+		*search_done = 1;
 	}
 	btrfs_release_path(path);
 
@@ -931,25 +873,99 @@ again:
 	}
 	btrfs_release_path(path);
 
-insert:
-	/* insert our name */
-	ret = btrfs_add_link(trans, dir, inode, name, namelen, 0,
-			     btrfs_inode_ref_index(eb, ref));
-	BUG_ON(ret);
+	return 0;
+}
 
-	btrfs_update_inode(trans, root, inode);
+/*
+ * replay one inode back reference item found in the log tree.
+ * eb, slot and key refer to the buffer and key found in the log tree.
+ * root is the destination we are replaying into, and path is for temp
+ * use by this function.  (it should be released on return).
+ */
+static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root,
+				  struct btrfs_root *log,
+				  struct btrfs_path *path,
+				  struct extent_buffer *eb, int slot,
+				  struct btrfs_key *key)
+{
+	struct btrfs_inode_ref *ref;
+	struct inode *dir;
+	struct inode *inode;
+	unsigned long ref_ptr;
+	unsigned long ref_end;
+	char *name;
+	int namelen;
+	int ret;
+	int search_done = 0;
 
-out:
-	ref_ptr = (unsigned long)(ref + 1) + namelen;
-	kfree(name);
-	if (ref_ptr < ref_end)
-		goto again;
+	/*
+	 * it is possible that we didn't log all the parent directories
+	 * for a given inode.  If we don't find the dir, just don't
+	 * copy the back ref in.  The link count fixup code will take
+	 * care of the rest
+	 */
+	dir = read_one_inode(root, key->offset);
+	if (!dir)
+		return -ENOENT;
+
+	inode = read_one_inode(root, key->objectid);
+	if (!inode) {
+		iput(dir);
+		return -EIO;
+	}
+
+	ref_ptr = btrfs_item_ptr_offset(eb, slot);
+	ref_end = ref_ptr + btrfs_item_size_nr(eb, slot);
+
+	while (ref_ptr < ref_end) {
+		ref = (struct btrfs_inode_ref *)ref_ptr;
+
+		namelen = btrfs_inode_ref_name_len(eb, ref);
+		name = kmalloc(namelen, GFP_NOFS);
+		BUG_ON(!name);
+
+		read_extent_buffer(eb, name, (unsigned long)(ref + 1), namelen);
+
+		/* if we already have a perfect match, we're done */
+		if (!inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
+				  btrfs_inode_ref_index(eb, ref),
+				  name, namelen)) {
+			/*
+			 * look for a conflicting back reference in the
+			 * metadata. if we find one we have to unlink that name
+			 * of the file before we add our new link.  Later on, we
+			 * overwrite any existing back reference, and we don't
+			 * want to create dangling pointers in the directory.
+			 */
+
+			if (!search_done) {
+				ret = __add_inode_ref(trans, root, path, log,
+						      dir, inode, key, eb, ref,
+						      name, namelen,
+						      &search_done);
+				if (ret == 1)
+					goto out;
+				BUG_ON(ret);
+			}
+
+			/* insert our name */
+			ret = btrfs_add_link(trans, dir, inode, name, namelen,
+					     0, btrfs_inode_ref_index(eb, ref));
+			BUG_ON(ret);
+
+			btrfs_update_inode(trans, root, inode);
+		}
+
+		ref_ptr = (unsigned long)(ref + 1) + namelen;
+		kfree(name);
+	}
 
 	/* finally write the back reference in the inode */
 	ret = overwrite_item(trans, root, path, eb, slot, key);
 	BUG_ON(ret);
 
-out_nowrite:
+out:
 	btrfs_release_path(path);
 	iput(dir);
 	iput(inode);
-- 
1.7.7

