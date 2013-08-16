Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:51132 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3HQAb7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 20:31:59 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9548D7C064D
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 15:02:10 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id ZrAnU4i2u8yaPe8p (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 15:02:09 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix send issues related to inode number reuse
Date: Fri, 16 Aug 2013 17:02:07 -0400
Message-ID: <1376686927-28383-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you are sending a snapshot and specifying a parent snapshot we will walk the
trees and figure out where they differ and send the differences only.  The way
we check for differences are if the leaves aren't the same and if the keys are
not the same within the leaves.  So if neither leaf is the same (ie the leaf has
been cow'ed from the parent snapshot) we walk each item in the send root and
check it against the parent root.  If the items match exactly then we don't do
anything.  This doesn't quite work for inode refs, since they will just have the
name and the parent objectid.  If you move the file from a directory and then
remove that directory and re-create a directory with the same inode number as
the old directory and then move that file back into that directory we will
assume that nothing changed and you will get errors when you try to receive.

In order to fix this we need to do extra checking to see if the inode ref really
is the same or not.  So do this by passing down BTRFS_COMPARE_TREE_SAME if the
items match.  Then if the key type is an inode ref we can do some extra
checking, otherwise we just keep processing.  The extra checking is to look up
the generation of the directory in the parent volume and compare it to the
generation of the send volume.  If they match then they are the same directory
and we are good to go.  If they don't we have to add them to the changed refs
list.

This means we have to track the generation of the ref we're trying to lookup
when we iterate all the refs for a particular inode.  So in the case of looking
for new refs we have to get the generation from the parent volume, and in the
case of looking for deleted refs we have to get the generation from the send
volume to compare with.

There was also the issue of using a ulist to keep track of the directories we
needed to check.  Because we can get a deleted ref and a new ref for the same
inode number the ulist won't work since it indexes based on the value.  So
instead just dup any directory ref we find and add it to a local list, and then
process that list as normal and do away with using a ulist for this altogether.

Before we would fail all of the tests in the far-progs that related to moving
directories (test group 32).  With this patch we now pass these tests, and all
of the tests in the far-progs send testing suite.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.c |   21 ++++---
 fs/btrfs/ctree.h |    1 +
 fs/btrfs/send.c  |  162 ++++++++++++++++++++++++++++++++++++++++++++----------
 3 files changed, 144 insertions(+), 40 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 414a2d7..479c83d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5296,19 +5296,20 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 					goto out;
 				advance_right = ADVANCE;
 			} else {
+				enum btrfs_compare_tree_result cmp;
+
 				WARN_ON(!extent_buffer_uptodate(left_path->nodes[0]));
 				ret = tree_compare_item(left_root, left_path,
 						right_path, tmp_buf);
-				if (ret) {
-					WARN_ON(!extent_buffer_uptodate(left_path->nodes[0]));
-					ret = changed_cb(left_root, right_root,
-						left_path, right_path,
-						&left_key,
-						BTRFS_COMPARE_TREE_CHANGED,
-						ctx);
-					if (ret < 0)
-						goto out;
-				}
+				if (ret)
+					cmp = BTRFS_COMPARE_TREE_CHANGED;
+				else
+					cmp = BTRFS_COMPARE_TREE_SAME;
+				ret = changed_cb(left_root, right_root,
+						 left_path, right_path,
+						 &left_key, cmp, ctx);
+				if (ret < 0)
+					goto out;
 				advance_left = ADVANCE;
 				advance_right = ADVANCE;
 			}
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7c93d9f..9766e9f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3301,6 +3301,7 @@ enum btrfs_compare_tree_result {
 	BTRFS_COMPARE_TREE_NEW,
 	BTRFS_COMPARE_TREE_DELETED,
 	BTRFS_COMPARE_TREE_CHANGED,
+	BTRFS_COMPARE_TREE_SAME,
 };
 typedef int (*btrfs_changed_cb_t)(struct btrfs_root *left_root,
 				  struct btrfs_root *right_root,
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index f8f8b1f..fc03a57 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2630,6 +2630,22 @@ static int record_ref(struct list_head *head, u64 dir,
 	return 0;
 }
 
+static int dup_ref(struct recorded_ref *ref, struct list_head *list)
+{
+	struct recorded_ref *new;
+
+	new = kmalloc(sizeof(*ref), GFP_NOFS);
+	if (!new)
+		return -ENOMEM;
+
+	new->dir = ref->dir;
+	new->dir_gen = ref->dir_gen;
+	new->full_path = NULL;
+	INIT_LIST_HEAD(&new->list);
+	list_add_tail(&new->list, list);
+	return 0;
+}
+
 static void __free_recorded_refs(struct list_head *head)
 {
 	struct recorded_ref *cur;
@@ -2744,9 +2760,7 @@ static int process_recorded_refs(struct send_ctx *sctx)
 	int ret = 0;
 	struct recorded_ref *cur;
 	struct recorded_ref *cur2;
-	struct ulist *check_dirs = NULL;
-	struct ulist_iterator uit;
-	struct ulist_node *un;
+	struct list_head check_dirs;
 	struct fs_path *valid_path = NULL;
 	u64 ow_inode = 0;
 	u64 ow_gen;
@@ -2760,6 +2774,7 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 	 * which is always '..'
 	 */
 	BUG_ON(sctx->cur_ino <= BTRFS_FIRST_FREE_OBJECTID);
+	INIT_LIST_HEAD(&check_dirs);
 
 	valid_path = fs_path_alloc();
 	if (!valid_path) {
@@ -2767,12 +2782,6 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 		goto out;
 	}
 
-	check_dirs = ulist_alloc(GFP_NOFS);
-	if (!check_dirs) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	/*
 	 * First, check if the first ref of the current inode was overwritten
 	 * before. If yes, we know that the current inode was already orphanized
@@ -2909,8 +2918,7 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 					goto out;
 			}
 		}
-		ret = ulist_add(check_dirs, cur->dir, cur->dir_gen,
-				GFP_NOFS);
+		ret = dup_ref(cur, &check_dirs);
 		if (ret < 0)
 			goto out;
 	}
@@ -2938,8 +2946,7 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 		}
 
 		list_for_each_entry(cur, &sctx->deleted_refs, list) {
-			ret = ulist_add(check_dirs, cur->dir, cur->dir_gen,
-					GFP_NOFS);
+			ret = dup_ref(cur, &check_dirs);
 			if (ret < 0)
 				goto out;
 		}
@@ -2950,8 +2957,7 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 		 */
 		cur = list_entry(sctx->deleted_refs.next, struct recorded_ref,
 				list);
-		ret = ulist_add(check_dirs, cur->dir, cur->dir_gen,
-				GFP_NOFS);
+		ret = dup_ref(cur, &check_dirs);
 		if (ret < 0)
 			goto out;
 	} else if (!S_ISDIR(sctx->cur_inode_mode)) {
@@ -2971,12 +2977,10 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 				if (ret < 0)
 					goto out;
 			}
-			ret = ulist_add(check_dirs, cur->dir, cur->dir_gen,
-					GFP_NOFS);
+			ret = dup_ref(cur, &check_dirs);
 			if (ret < 0)
 				goto out;
 		}
-
 		/*
 		 * If the inode is still orphan, unlink the orphan. This may
 		 * happen when a previous inode did overwrite the first ref
@@ -2998,33 +3002,32 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 	 * deletion and if it's finally possible to perform the rmdir now.
 	 * We also update the inode stats of the parent dirs here.
 	 */
-	ULIST_ITER_INIT(&uit);
-	while ((un = ulist_next(check_dirs, &uit))) {
+	list_for_each_entry(cur, &check_dirs, list) {
 		/*
 		 * In case we had refs into dirs that were not processed yet,
 		 * we don't need to do the utime and rmdir logic for these dirs.
 		 * The dir will be processed later.
 		 */
-		if (un->val > sctx->cur_ino)
+		if (cur->dir > sctx->cur_ino)
 			continue;
 
-		ret = get_cur_inode_state(sctx, un->val, un->aux);
+		ret = get_cur_inode_state(sctx, cur->dir, cur->dir_gen);
 		if (ret < 0)
 			goto out;
 
 		if (ret == inode_state_did_create ||
 		    ret == inode_state_no_change) {
 			/* TODO delayed utimes */
-			ret = send_utimes(sctx, un->val, un->aux);
+			ret = send_utimes(sctx, cur->dir, cur->dir_gen);
 			if (ret < 0)
 				goto out;
 		} else if (ret == inode_state_did_delete) {
-			ret = can_rmdir(sctx, un->val, sctx->cur_ino);
+			ret = can_rmdir(sctx, cur->dir, sctx->cur_ino);
 			if (ret < 0)
 				goto out;
 			if (ret) {
-				ret = get_cur_path(sctx, un->val, un->aux,
-						valid_path);
+				ret = get_cur_path(sctx, cur->dir,
+						   cur->dir_gen, valid_path);
 				if (ret < 0)
 					goto out;
 				ret = send_rmdir(sctx, valid_path);
@@ -3037,8 +3040,8 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 	ret = 0;
 
 out:
+	__free_recorded_refs(&check_dirs);
 	free_recorded_refs(sctx);
-	ulist_free(check_dirs);
 	fs_path_free(valid_path);
 	return ret;
 }
@@ -3139,6 +3142,8 @@ out:
 
 struct find_ref_ctx {
 	u64 dir;
+	u64 dir_gen;
+	struct btrfs_root *root;
 	struct fs_path *name;
 	int found_idx;
 };
@@ -3148,9 +3153,21 @@ static int __find_iref(int num, u64 dir, int index,
 		       void *ctx_)
 {
 	struct find_ref_ctx *ctx = ctx_;
+	u64 dir_gen;
+	int ret;
 
 	if (dir == ctx->dir && fs_path_len(name) == fs_path_len(ctx->name) &&
 	    strncmp(name->start, ctx->name->start, fs_path_len(name)) == 0) {
+		/*
+		 * To avoid doing extra lookups we'll only do this if everything
+		 * else matches.
+		 */
+		ret = get_inode_info(ctx->root, dir, NULL, &dir_gen, NULL,
+				     NULL, NULL, NULL);
+		if (ret)
+			return ret;
+		if (dir_gen != ctx->dir_gen)
+			return 0;
 		ctx->found_idx = num;
 		return 1;
 	}
@@ -3160,14 +3177,16 @@ static int __find_iref(int num, u64 dir, int index,
 static int find_iref(struct btrfs_root *root,
 		     struct btrfs_path *path,
 		     struct btrfs_key *key,
-		     u64 dir, struct fs_path *name)
+		     u64 dir, u64 dir_gen, struct fs_path *name)
 {
 	int ret;
 	struct find_ref_ctx ctx;
 
 	ctx.dir = dir;
 	ctx.name = name;
+	ctx.dir_gen = dir_gen;
 	ctx.found_idx = -1;
+	ctx.root = root;
 
 	ret = iterate_inode_ref(root, path, key, 0, __find_iref, &ctx);
 	if (ret < 0)
@@ -3183,11 +3202,17 @@ static int __record_changed_new_ref(int num, u64 dir, int index,
 				    struct fs_path *name,
 				    void *ctx)
 {
+	u64 dir_gen;
 	int ret;
 	struct send_ctx *sctx = ctx;
 
+	ret = get_inode_info(sctx->send_root, dir, NULL, &dir_gen, NULL,
+			     NULL, NULL, NULL);
+	if (ret)
+		return ret;
+
 	ret = find_iref(sctx->parent_root, sctx->right_path,
-			sctx->cmp_key, dir, name);
+			sctx->cmp_key, dir, dir_gen, name);
 	if (ret == -ENOENT)
 		ret = __record_new_ref(num, dir, index, name, sctx);
 	else if (ret > 0)
@@ -3200,11 +3225,17 @@ static int __record_changed_deleted_ref(int num, u64 dir, int index,
 					struct fs_path *name,
 					void *ctx)
 {
+	u64 dir_gen;
 	int ret;
 	struct send_ctx *sctx = ctx;
 
+	ret = get_inode_info(sctx->parent_root, dir, NULL, &dir_gen, NULL,
+			     NULL, NULL, NULL);
+	if (ret)
+		return ret;
+
 	ret = find_iref(sctx->send_root, sctx->left_path, sctx->cmp_key,
-			dir, name);
+			dir, dir_gen, name);
 	if (ret == -ENOENT)
 		ret = __record_deleted_ref(num, dir, index, name, sctx);
 	else if (ret > 0)
@@ -4381,6 +4412,64 @@ static int changed_extent(struct send_ctx *sctx,
 	return ret;
 }
 
+static int dir_changed(struct send_ctx *sctx, u64 dir)
+{
+	u64 orig_gen, new_gen;
+	int ret;
+
+	ret = get_inode_info(sctx->send_root, dir, NULL, &new_gen, NULL, NULL,
+			     NULL, NULL);
+	if (ret)
+		return ret;
+
+	ret = get_inode_info(sctx->parent_root, dir, NULL, &orig_gen, NULL,
+			     NULL, NULL, NULL);
+	if (ret)
+		return ret;
+
+	return (orig_gen != new_gen) ? 1 : 0;
+}
+
+static int compare_refs(struct send_ctx *sctx, struct btrfs_path *path,
+			struct btrfs_key *key)
+{
+	struct btrfs_inode_extref *extref;
+	struct extent_buffer *leaf;
+	u64 dirid = 0, last_dirid = 0;
+	unsigned long ptr;
+	u32 item_size;
+	u32 cur_offset = 0;
+	int ref_name_len;
+	int ret = 0;
+
+	/* Easy case, just check this one dirid */
+	if (key->type == BTRFS_INODE_REF_KEY) {
+		dirid = key->offset;
+
+		ret = dir_changed(sctx, dirid);
+		goto out;
+	}
+
+	leaf = path->nodes[0];
+	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
+	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
+	while (cur_offset < item_size) {
+		extref = (struct btrfs_inode_extref *)(ptr +
+						       cur_offset);
+		dirid = btrfs_inode_extref_parent(leaf, extref);
+		ref_name_len = btrfs_inode_extref_name_len(leaf, extref);
+		cur_offset += ref_name_len + sizeof(*extref);
+		if (dirid == last_dirid)
+			continue;
+		ret = dir_changed(sctx, dirid);
+		if (ret)
+			break;
+		last_dirid = dirid;
+	}
+out:
+	return ret;
+}
+
 /*
  * Updates compare related fields in sctx and simply forwards to the actual
  * changed_xxx functions.
@@ -4396,6 +4485,19 @@ static int changed_cb(struct btrfs_root *left_root,
 	int ret = 0;
 	struct send_ctx *sctx = ctx;
 
+	if (result == BTRFS_COMPARE_TREE_SAME) {
+		if (key->type != BTRFS_INODE_REF_KEY &&
+		    key->type != BTRFS_INODE_EXTREF_KEY)
+			return 0;
+		ret = compare_refs(sctx, left_path, key);
+		if (!ret)
+			return 0;
+		if (ret < 0)
+			return ret;
+		result = BTRFS_COMPARE_TREE_CHANGED;
+		ret = 0;
+	}
+
 	sctx->left_path = left_path;
 	sctx->right_path = right_path;
 	sctx->cmp_key = key;
-- 
1.7.7.6

