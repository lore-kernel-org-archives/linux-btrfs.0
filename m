Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:48654 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3FLUW3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Jun 2013 16:22:29 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 890C67C0434
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Jun 2013 14:22:29 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 7hbOislcemNX1ymC (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 12 Jun 2013 14:22:28 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: cleanup backref search commit root flag stuff
Date: Wed, 12 Jun 2013 16:22:26 -0400
Message-ID: <1371068546-30039-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looking into this backref problem I noticed we're using a macro to what turns
out to essentially be a NULL check to see if we need to search the commit root.
I'm killing this, let's just do what everybody else does and checks if trans ==
NULL.  I've also made it so we pass in the path to __resolve_indirect_refs which
will have the search_commit_root flag set properly already and that way we can
avoid allocating another path when we have a perfectly good one to use.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/backref.c |   41 ++++++++++++++++-------------------------
 fs/btrfs/backref.h |    2 --
 2 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 290e347..431ea92 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -255,13 +255,11 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
  * to a logical address
  */
 static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
-					int search_commit_root,
-					u64 time_seq,
-					struct __prelim_ref *ref,
-					struct ulist *parents,
-					const u64 *extent_item_pos)
+				  struct btrfs_path *path, u64 time_seq,
+				  struct __prelim_ref *ref,
+				  struct ulist *parents,
+				  const u64 *extent_item_pos)
 {
-	struct btrfs_path *path;
 	struct btrfs_root *root;
 	struct btrfs_key root_key;
 	struct extent_buffer *eb;
@@ -269,11 +267,6 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 	int root_level;
 	int level = ref->level;
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-	path->search_commit_root = !!search_commit_root;
-
 	root_key.objectid = ref->root_id;
 	root_key.type = BTRFS_ROOT_ITEM_KEY;
 	root_key.offset = (u64)-1;
@@ -314,7 +307,8 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 				time_seq, ref->wanted_disk_byte,
 				extent_item_pos);
 out:
-	btrfs_free_path(path);
+	path->lowest_level = 0;
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -322,7 +316,7 @@ out:
  * resolve all indirect backrefs from the list
  */
 static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
-				   int search_commit_root, u64 time_seq,
+				   struct btrfs_path *path, u64 time_seq,
 				   struct list_head *head,
 				   const u64 *extent_item_pos)
 {
@@ -349,9 +343,8 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 			continue;
 		if (ref->count == 0)
 			continue;
-		err = __resolve_indirect_ref(fs_info, search_commit_root,
-					     time_seq, ref, parents,
-					     extent_item_pos);
+		err = __resolve_indirect_ref(fs_info, path, time_seq, ref,
+					     parents, extent_item_pos);
 		if (err == -ENOMEM)
 			goto out;
 		if (err)
@@ -795,7 +788,6 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_head *head;
 	int info_level = 0;
 	int ret;
-	int search_commit_root = (trans == BTRFS_BACKREF_SEARCH_COMMIT_ROOT);
 	struct list_head prefs_delayed;
 	struct list_head prefs;
 	struct __prelim_ref *ref;
@@ -810,7 +802,8 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	path->search_commit_root = !!search_commit_root;
+	if (!trans)
+		path->search_commit_root = 1;
 
 	/*
 	 * grab both a lock on the path and a lock on the delayed ref head.
@@ -825,7 +818,7 @@ again:
 		goto out;
 	BUG_ON(ret == 0);
 
-	if (trans != BTRFS_BACKREF_SEARCH_COMMIT_ROOT) {
+	if (trans) {
 		/*
 		 * look if there are updates for this ref queued and lock the
 		 * head
@@ -890,8 +883,8 @@ again:
 
 	__merge_refs(&prefs, 1);
 
-	ret = __resolve_indirect_refs(fs_info, search_commit_root, time_seq,
-				      &prefs, extent_item_pos);
+	ret = __resolve_indirect_refs(fs_info, path, time_seq, &prefs,
+				      extent_item_pos);
 	if (ret)
 		goto out;
 
@@ -1459,7 +1452,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 				iterate_extent_inodes_t *iterate, void *ctx)
 {
 	int ret;
-	struct btrfs_trans_handle *trans;
+	struct btrfs_trans_handle *trans = NULL;
 	struct ulist *refs = NULL;
 	struct ulist *roots = NULL;
 	struct ulist_node *ref_node = NULL;
@@ -1471,9 +1464,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	pr_debug("resolving all inodes for extent %llu\n",
 			extent_item_objectid);
 
-	if (search_commit_root) {
-		trans = BTRFS_BACKREF_SEARCH_COMMIT_ROOT;
-	} else {
+	if (!search_commit_root) {
 		trans = btrfs_join_transaction(fs_info->extent_root);
 		if (IS_ERR(trans))
 			return PTR_ERR(trans);
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 0f446d7..8f2e767 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -23,8 +23,6 @@
 #include "ulist.h"
 #include "extent_io.h"
 
-#define BTRFS_BACKREF_SEARCH_COMMIT_ROOT ((struct btrfs_trans_handle *)0)
-
 struct inode_fs_paths {
 	struct btrfs_path		*btrfs_path;
 	struct btrfs_root		*fs_root;
-- 
1.7.7.6

