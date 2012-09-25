Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:34728 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab2IYUEu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 16:04:50 -0400
Date: Tue, 25 Sep 2012 16:04:46 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Mark Fasheh <mfasheh@suse.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v4 0/4] btrfs: extended inode refs
Message-ID: <20120925200446.GD6596@shiny>
References: <1345494561-28758-1-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1345494561-28758-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 20, 2012 at 02:29:17PM -0600, Mark Fasheh wrote:
> 
> Testing wise, the basic namespace operations work well (link, unlink, etc).
> The rest has gotten less debugging (and I really don't have a great way of
> testing the code in tree-log.c) Attached to this e-mail are btrfs-progs
> patches which make testing of the changes possible.

Hi Mark,

I hit a few problems testing this, so I have the patch below that I plan
on folding into your commits (to keep bisect from crashing in tree log).

Just let me know if this is a problem, or if you see any bugs in there.
I'm still doing a last round of checks on it, but I wanted to send along
early for comments.

The biggest change in here is to always check the ref_objectid when
returning a backref.  Hash collisions mean we may return a ref for a
completely different parent id otherwise.  I think I caught all the
places missing that logic, but please double check me.

Other than that I went through and fixed up bugs in
tree-log.c.  __add_inode_ref had a bunch of cut and paste errors, and you
carefully preserved a huge use-after-free bug in the original
add_inode_ref.

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6f2e7e6..50dcd0f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3231,7 +3231,8 @@ btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
 			  u64 inode_objectid, u64 ref_objectid, int ins_len,
 			  int cow);
 
-int btrfs_find_name_in_ext_backref(struct btrfs_path *path, const char *name,
+int btrfs_find_name_in_ext_backref(struct btrfs_path *path,
+				   u64 ref_objectid, const char *name,
 				   int name_len,
 				   struct btrfs_inode_extref **extref_ret);
 
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index ad11b30..48b8fda 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -51,8 +51,8 @@ static int find_name_in_backref(struct btrfs_path *path, const char *name,
 	return 0;
 }
 
-int btrfs_find_name_in_ext_backref(struct btrfs_path *path, const char *name,
-				   int name_len,
+int btrfs_find_name_in_ext_backref(struct btrfs_path *path, u64 ref_objectid,
+				   const char *name, int name_len,
 				   struct btrfs_inode_extref **extref_ret)
 {
 	struct extent_buffer *leaf;
@@ -78,8 +78,9 @@ int btrfs_find_name_in_ext_backref(struct btrfs_path *path, const char *name,
 		name_ptr = (unsigned long)(&extref->name);
 		ref_name_len = btrfs_inode_extref_name_len(leaf, extref);
 
-		if (ref_name_len == name_len
-		    && (memcmp_extent_buffer(leaf, name, name_ptr, name_len) == 0)) {
+		if (ref_name_len == name_len &&
+		    btrfs_inode_extref_parent(leaf, extref) == ref_objectid &&
+		    (memcmp_extent_buffer(leaf, name, name_ptr, name_len) == 0)) {
 			if (extref_ret)
 				*extref_ret = extref;
 			return 1;
@@ -138,7 +139,7 @@ btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
 		return ERR_PTR(ret);
 	if (ret > 0)
 		return NULL;
-	if (!btrfs_find_name_in_ext_backref(path, name, name_len, &extref))
+	if (!btrfs_find_name_in_ext_backref(path, ref_objectid, name, name_len, &extref))
 		return NULL;
 	return extref;
 }
@@ -218,7 +219,8 @@ int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
 	 * This should always succeed so error here will make the FS
 	 * readonly.
 	 */
-	if (!btrfs_find_name_in_ext_backref(path, name, name_len, &extref)) {
+	if (!btrfs_find_name_in_ext_backref(path, ref_objectid,
+					    name, name_len, &extref)) {
 		btrfs_std_error(root->fs_info, -ENOENT);
 		ret = -EROFS;
 		goto out;
@@ -355,7 +357,8 @@ static int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      ins_len);
 	if (ret == -EEXIST) {
-		if (btrfs_find_name_in_ext_backref(path, name, name_len, NULL))
+		if (btrfs_find_name_in_ext_backref(path, ref_objectid,
+						   name, name_len, NULL))
 			goto out;
 
 		btrfs_extend_item(trans, root, path, ins_len);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index baf8be2..1d7b348 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -745,6 +745,7 @@ out:
  */
 static noinline int backref_in_log(struct btrfs_root *log,
 				   struct btrfs_key *key,
+				   u64 ref_objectid,
 				   char *name, int namelen)
 {
 	struct btrfs_path *path;
@@ -768,7 +769,8 @@ static noinline int backref_in_log(struct btrfs_root *log,
 	ptr = btrfs_item_ptr_offset(path->nodes[0], path->slots[0]);
 
 	if (key->type == BTRFS_INODE_EXTREF_KEY) {
-		if (btrfs_find_name_in_ext_backref(path, name, namelen, NULL))
+		if (btrfs_find_name_in_ext_backref(path, ref_objectid,
+						   name, namelen, NULL))
 			match = 1;
 
 		goto out;
@@ -813,6 +815,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_key search_key;
 	struct btrfs_inode_extref *extref;
 
+again:
 	/* Search old style refs */
 	search_key.objectid = inode_objectid;
 	search_key.type = BTRFS_INODE_REF_KEY;
@@ -848,7 +851,9 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 					   (unsigned long)(victim_ref + 1),
 					   victim_name_len);
 
-			if (!backref_in_log(log_root, &search_key, victim_name,
+			if (!backref_in_log(log_root, &search_key,
+					    parent_objectid,
+					    victim_name,
 					    victim_name_len)) {
 				btrfs_inc_nlink(inode);
 				btrfs_release_path(path);
@@ -856,9 +861,14 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 				ret = btrfs_unlink_inode(trans, root, dir,
 							 inode, victim_name,
 							 victim_name_len);
+				BUG_ON(ret);
 				btrfs_run_delayed_items(trans, root);
+				kfree(victim_name);
+				*search_done = 1;
+				goto again;
 			}
 			kfree(victim_name);
+
 			ptr = (unsigned long)(victim_ref + 1) + victim_name_len;
 		}
 		BUG_ON(ret);
@@ -889,16 +899,23 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 		while (cur_offset < item_size) {
 			extref = (struct btrfs_inode_extref *)base + cur_offset;
 
-			victim_name_len = btrfs_inode_extref_name_len(eb, extref);
-			victim_name = kmalloc(namelen, GFP_NOFS);
-			leaf = path->nodes[0];
-			read_extent_buffer(eb, name, (unsigned long)&extref->name, namelen);
+			victim_name_len = btrfs_inode_extref_name_len(leaf, extref);
+
+			if (btrfs_inode_extref_parent(leaf, extref) != parent_objectid)
+				goto next;
+
+			victim_name = kmalloc(victim_name_len, GFP_NOFS);
+			read_extent_buffer(leaf, victim_name, (unsigned long)&extref->name,
+					   victim_name_len);
 
 			search_key.objectid = inode_objectid;
 			search_key.type = BTRFS_INODE_EXTREF_KEY;
 			search_key.offset = btrfs_extref_hash(parent_objectid,
-							      name, namelen);
-			if (!backref_in_log(log_root, &search_key, victim_name,
+							      victim_name,
+							      victim_name_len);
+			ret = 0;
+			if (!backref_in_log(log_root, &search_key,
+					    parent_objectid, victim_name,
 					    victim_name_len)) {
 				ret = -ENOENT;
 				victim_parent = read_one_inode(root,
@@ -912,16 +929,22 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 								 inode,
 								 victim_name,
 								 victim_name_len);
+					btrfs_run_delayed_items(trans, root);
 				}
+				BUG_ON(ret);
 				iput(victim_parent);
+				kfree(victim_name);
+				*search_done = 1;
+				goto again;
 			}
 			kfree(victim_name);
 			BUG_ON(ret);
-
+next:
 			cur_offset += victim_name_len + sizeof(*extref);
 		}
 		*search_done = 1;
 	}
+	btrfs_release_path(path);
 
 	/* look for a conflicting sequence number */
 	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(dir),
@@ -1158,6 +1181,7 @@ static int count_inode_extrefs(struct btrfs_root *root,
 		}
 
 		offset++;
+		btrfs_release_path(path);
 	}
 	btrfs_release_path(path);
 
@@ -1248,11 +1272,16 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 	nlink = ret;
 
 	ret = count_inode_extrefs(root, inode, path);
+	if (ret == -ENOENT)
+		ret = 0;
+
 	if (ret < 0)
 		goto out;
 
 	nlink += ret;
 
+	ret = 0;
+
 	if (nlink != inode->i_nlink) {
 		set_nlink(inode, nlink);
 		btrfs_update_inode(trans, root, inode);
