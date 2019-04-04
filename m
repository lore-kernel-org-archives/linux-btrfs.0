Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94ABC4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 06:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B040206DF
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 06:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfDDGqe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:46:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:36506 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbfDDGqe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Apr 2019 02:46:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3BED9AE7D
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2019 06:46:32 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3.1 7/9] btrfs: extent-tree: Use btrfs_ref to refactor btrfs_inc_extent_ref()
Date:   Thu,  4 Apr 2019 14:45:35 +0800
Message-Id: <20190404064537.4031-8-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190404064537.4031-1-wqu@suse.com>
References: <20190404064537.4031-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now we don't need to play the dirty game of reusing @owner for tree block
level.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h       |  5 ++--
 fs/btrfs/extent-tree.c | 57 ++++++++++++++++++++++++------------------
 fs/btrfs/file.c        | 17 +++++++++----
 fs/btrfs/inode.c       | 10 +++++---
 fs/btrfs/ioctl.c       | 15 ++++++-----
 fs/btrfs/relocation.c  | 42 ++++++++++++++++++++-----------
 fs/btrfs/tree-log.c    | 11 +++++---
 7 files changed, 96 insertions(+), 61 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1a6c5ce0cdac..19dae09bbe22 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -41,6 +41,7 @@ extern struct kmem_cache *btrfs_bit_radix_cachep;
 extern struct kmem_cache *btrfs_path_cachep;
 extern struct kmem_cache *btrfs_free_space_cachep;
 struct btrfs_ordered_sum;
+struct btrfs_ref;
 
 #define BTRFS_MAGIC 0x4D5F53665248425FULL /* ascii _BHRfS_M, no null */
 
@@ -2762,9 +2763,7 @@ int btrfs_free_and_pin_reserved_extent(struct btrfs_fs_info *fs_info,
 void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
-			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 root_objectid, u64 owner, u64 offset);
+			 struct btrfs_ref *generic_ref);
 
 int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6f82dcf1528e..1f4cb91d5c14 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2043,35 +2043,28 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 
 /* Can return -ENOMEM */
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
-			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 root_objectid, u64 owner, u64 offset)
+			 struct btrfs_ref *generic_ref)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_ref generic_ref = { 0 };
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int old_ref_mod, new_ref_mod;
 	int ret;
 
-	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
-	       root_objectid == BTRFS_TREE_LOG_OBJECTID);
+	ASSERT(generic_ref->type != BTRFS_REF_NOT_SET &&
+	       generic_ref->action);
+	BUG_ON(generic_ref->type == BTRFS_REF_METADATA &&
+	       generic_ref->tree_ref.root == BTRFS_TREE_LOG_OBJECTID);
 
-	btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_REF, bytenr,
-			       num_bytes, parent);
-	generic_ref.real_root = root->root_key.objectid;
-	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		btrfs_init_tree_ref(&generic_ref, (int)owner, root_objectid);
-		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref,
+	if (generic_ref->type == BTRFS_REF_METADATA)
+		ret = btrfs_add_delayed_tree_ref(trans, generic_ref,
 				NULL, &old_ref_mod, &new_ref_mod);
-	} else {
-		btrfs_init_data_ref(&generic_ref, root_objectid, owner, offset);
-		ret = btrfs_add_delayed_data_ref(trans, &generic_ref, 0,
+	else
+		ret = btrfs_add_delayed_data_ref(trans, generic_ref, 0,
 						 &old_ref_mod, &new_ref_mod);
-	}
 
-	btrfs_ref_tree_mod(fs_info, &generic_ref);
+	btrfs_ref_tree_mod(fs_info, generic_ref);
 
 	if (ret == 0 && old_ref_mod < 0 && new_ref_mod >= 0)
-		add_pinned_bytes(fs_info, &generic_ref);
+		add_pinned_bytes(fs_info, generic_ref);
 
 	return ret;
 }
@@ -3236,7 +3229,10 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	u32 nritems;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item *fi;
+	struct btrfs_ref generic_ref = { 0 };
+	bool for_reloc = btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC);
 	int i;
+	int action;
 	int level;
 	int ret = 0;
 
@@ -3254,6 +3250,10 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 		parent = buf->start;
 	else
 		parent = 0;
+	if (inc)
+		action = BTRFS_ADD_DELAYED_REF;
+	else
+		action = BTRFS_DROP_DELAYED_REF;
 
 	for (i = 0; i < nritems; i++) {
 		if (level == 0) {
@@ -3271,10 +3271,14 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 
 			num_bytes = btrfs_file_extent_disk_num_bytes(buf, fi);
 			key.offset -= btrfs_file_extent_offset(buf, fi);
+			btrfs_init_generic_ref(&generic_ref, action, bytenr,
+					       num_bytes, parent);
+			generic_ref.real_root = root->root_key.objectid;
+			btrfs_init_data_ref(&generic_ref, ref_root, key.objectid,
+					    key.offset);
+			generic_ref.skip_qgroup = for_reloc;
 			if (inc)
-				ret = btrfs_inc_extent_ref(trans, root, bytenr,
-						num_bytes, parent, ref_root,
-						key.objectid, key.offset);
+				ret = btrfs_inc_extent_ref(trans, &generic_ref);
 			else
 				ret = btrfs_free_extent(trans, root, bytenr,
 						num_bytes, parent, ref_root,
@@ -3284,10 +3288,13 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 		} else {
 			bytenr = btrfs_node_blockptr(buf, i);
 			num_bytes = fs_info->nodesize;
+			btrfs_init_generic_ref(&generic_ref, action, bytenr,
+					       num_bytes, parent);
+			generic_ref.real_root = root->root_key.objectid;
+			btrfs_init_tree_ref(&generic_ref, level - 1, ref_root);
+			generic_ref.skip_qgroup = for_reloc;
 			if (inc)
-				ret = btrfs_inc_extent_ref(trans, root, bytenr,
-						num_bytes, parent, ref_root,
-						level - 1, 0);
+				ret = btrfs_inc_extent_ref(trans, &generic_ref);
 			else
 				ret = btrfs_free_extent(trans, root, bytenr,
 						num_bytes, parent, ref_root,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 15cc3b861346..0b6c59bd4e7d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -754,6 +754,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *leaf;
 	struct btrfs_file_extent_item *fi;
+	struct btrfs_ref ref = { 0 };
 	struct btrfs_key key;
 	struct btrfs_key new_key;
 	u64 ino = btrfs_ino(BTRFS_I(inode));
@@ -909,11 +910,14 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 			btrfs_mark_buffer_dirty(leaf);
 
 			if (update_refs && disk_bytenr > 0) {
-				ret = btrfs_inc_extent_ref(trans, root,
-						disk_bytenr, num_bytes, 0,
+				btrfs_init_generic_ref(&ref,
+						BTRFS_ADD_DELAYED_REF,
+						disk_bytenr, num_bytes, 0);
+				btrfs_init_data_ref(&ref,
 						root->root_key.objectid,
 						new_key.objectid,
 						start - extent_offset);
+				ret = btrfs_inc_extent_ref(trans, &ref);
 				BUG_ON(ret); /* -ENOMEM */
 			}
 			key.offset = start;
@@ -1142,6 +1146,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_path *path;
 	struct btrfs_file_extent_item *fi;
+	struct btrfs_ref ref = { 0 };
 	struct btrfs_key key;
 	struct btrfs_key new_key;
 	u64 bytenr;
@@ -1287,9 +1292,11 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 						extent_end - split);
 		btrfs_mark_buffer_dirty(leaf);
 
-		ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes,
-					   0, root->root_key.objectid,
-					   ino, orig_offset);
+		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, bytenr,
+				       num_bytes, 0);
+		btrfs_init_data_ref(&ref, root->root_key.objectid, ino,
+				    orig_offset);
+		ret = btrfs_inc_extent_ref(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index baa80d808806..cecd2e58e0d5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2520,6 +2520,7 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 	struct btrfs_file_extent_item *item;
 	struct btrfs_ordered_extent *ordered;
 	struct btrfs_trans_handle *trans;
+	struct btrfs_ref ref = { 0 };
 	struct btrfs_root *root;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
@@ -2690,10 +2691,11 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 	inode_add_bytes(inode, len);
 	btrfs_release_path(path);
 
-	ret = btrfs_inc_extent_ref(trans, root, new->bytenr,
-			new->disk_len, 0,
-			backref->root_id, backref->inum,
-			new->file_pos);	/* start - extent_offset */
+	btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, new->bytenr,
+			       new->disk_len, 0);
+	btrfs_init_data_ref(&ref, backref->root_id, backref->inum,
+			    new->file_pos);  /* start - extent_offset */
+	ret = btrfs_inc_extent_ref(trans, &ref);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_free_path;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8c9a908d3acc..19b0ee4e2c70 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3737,13 +3737,16 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 								datal);
 
 				if (disko) {
+					struct btrfs_ref ref = { 0 };
 					inode_add_bytes(inode, datal);
-					ret = btrfs_inc_extent_ref(trans,
-							root,
-							disko, diskl, 0,
-							root->root_key.objectid,
-							btrfs_ino(BTRFS_I(inode)),
-							new_key.offset - datao);
+					btrfs_init_generic_ref(&ref,
+						BTRFS_ADD_DELAYED_REF, disko,
+						diskl, 0);
+					btrfs_init_data_ref(&ref,
+						root->root_key.objectid,
+						btrfs_ino(BTRFS_I(inode)),
+						new_key.offset - datao);
+					ret = btrfs_inc_extent_ref(trans, &ref);
 					if (ret) {
 						btrfs_abort_transaction(trans,
 									ret);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 25fc6a4f3ecf..d283a70eed06 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1643,6 +1643,8 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 
 	nritems = btrfs_header_nritems(leaf);
 	for (i = 0; i < nritems; i++) {
+		struct btrfs_ref ref = { 0 };
+
 		cond_resched();
 		btrfs_item_key_to_cpu(leaf, &key, i);
 		if (key.type != BTRFS_EXTENT_DATA_KEY)
@@ -1703,10 +1705,12 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 		dirty = 1;
 
 		key.offset -= btrfs_file_extent_offset(leaf, fi);
-		ret = btrfs_inc_extent_ref(trans, root, new_bytenr,
-					   num_bytes, parent,
-					   btrfs_header_owner(leaf),
-					   key.objectid, key.offset);
+		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, new_bytenr,
+				       num_bytes, parent);
+		ref.real_root = root->root_key.objectid;
+		btrfs_init_data_ref(&ref, btrfs_header_owner(leaf),
+				    key.objectid, key.offset);
+		ret = btrfs_inc_extent_ref(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			break;
@@ -1756,6 +1760,7 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 	struct btrfs_fs_info *fs_info = dest->fs_info;
 	struct extent_buffer *eb;
 	struct extent_buffer *parent;
+	struct btrfs_ref ref = { 0 };
 	struct btrfs_key key;
 	u64 old_bytenr;
 	u64 new_bytenr;
@@ -1916,13 +1921,17 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 					      path->slots[level], old_ptr_gen);
 		btrfs_mark_buffer_dirty(path->nodes[level]);
 
-		ret = btrfs_inc_extent_ref(trans, src, old_bytenr,
-					blocksize, path->nodes[level]->start,
-					src->root_key.objectid, level - 1, 0);
+		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, old_bytenr,
+				       blocksize, path->nodes[level]->start);
+		ref.skip_qgroup = true;
+		btrfs_init_tree_ref(&ref, level - 1, src->root_key.objectid);
+		ret = btrfs_inc_extent_ref(trans, &ref);
 		BUG_ON(ret);
-		ret = btrfs_inc_extent_ref(trans, dest, new_bytenr,
-					blocksize, 0, dest->root_key.objectid,
-					level - 1, 0);
+		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, new_bytenr,
+				       blocksize, 0);
+		ref.skip_qgroup = true;
+		btrfs_init_tree_ref(&ref, level - 1, dest->root_key.objectid);
+		ret = btrfs_inc_extent_ref(trans, &ref);
 		BUG_ON(ret);
 
 		ret = btrfs_free_extent(trans, src, new_bytenr, blocksize,
@@ -2721,6 +2730,7 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 	rc->backref_cache.path[node->level] = node;
 	list_for_each_entry(edge, &node->upper, list[LOWER]) {
 		struct btrfs_key first_key;
+		struct btrfs_ref ref = { 0 };
 
 		cond_resched();
 
@@ -2826,11 +2836,13 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 						      trans->transid);
 			btrfs_mark_buffer_dirty(upper->eb);
 
-			ret = btrfs_inc_extent_ref(trans, root,
-						node->eb->start, blocksize,
-						upper->eb->start,
-						btrfs_header_owner(upper->eb),
-						node->level, 0);
+			btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF,
+					       node->eb->start, blocksize,
+					       upper->eb->start);
+			ref.real_root = root->root_key.objectid;
+			btrfs_init_tree_ref(&ref, node->level,
+					    btrfs_header_owner(upper->eb));
+			ret = btrfs_inc_extent_ref(trans, &ref);
 			BUG_ON(ret);
 
 			ret = btrfs_drop_subtree(trans, root, eb, upper->eb);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 79f75bec9f40..cef983d95113 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -705,9 +705,11 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 			goto out;
 
 		if (ins.objectid > 0) {
+			struct btrfs_ref ref = { 0 };
 			u64 csum_start;
 			u64 csum_end;
 			LIST_HEAD(ordered_sums);
+
 			/*
 			 * is this extent already allocated in the extent
 			 * allocation tree?  If so, just add a reference
@@ -715,10 +717,13 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 			ret = btrfs_lookup_data_extent(fs_info, ins.objectid,
 						ins.offset);
 			if (ret == 0) {
-				ret = btrfs_inc_extent_ref(trans, root,
-						ins.objectid, ins.offset,
-						0, root->root_key.objectid,
+				btrfs_init_generic_ref(&ref,
+						BTRFS_ADD_DELAYED_REF,
+						ins.objectid, ins.offset, 0);
+				btrfs_init_data_ref(&ref,
+						root->root_key.objectid,
 						key->objectid, offset);
+				ret = btrfs_inc_extent_ref(trans, &ref);
 				if (ret)
 					goto out;
 			} else {
-- 
2.21.0

