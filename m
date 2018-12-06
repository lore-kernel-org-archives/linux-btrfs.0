Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D556DC65BB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9732E214DB
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:59:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9732E214DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbeLFG7Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 01:59:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:59460 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728294AbeLFG7X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 01:59:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7343EAE98
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Dec 2018 06:59:20 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 7/8] btrfs: extent-tree: Use btrfs_ref to refactor btrfs_inc_extent_ref()
Date:   Thu,  6 Dec 2018 14:59:02 +0800
Message-Id: <20181206065903.11343-8-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181206065903.11343-1-wqu@suse.com>
References: <20181206065903.11343-1-wqu@suse.com>
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
 fs/btrfs/ctree.h       |  6 ++---
 fs/btrfs/extent-tree.c | 58 ++++++++++++++++++++++--------------------
 fs/btrfs/file.c        | 20 ++++++++++-----
 fs/btrfs/inode.c       | 10 +++++---
 fs/btrfs/ioctl.c       | 17 ++++++++-----
 fs/btrfs/relocation.c  | 44 ++++++++++++++++++++------------
 fs/btrfs/tree-log.c    | 12 ++++++---
 7 files changed, 100 insertions(+), 67 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6f4b1e605736..db3df5ce6087 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -40,6 +40,7 @@ extern struct kmem_cache *btrfs_bit_radix_cachep;
 extern struct kmem_cache *btrfs_path_cachep;
 extern struct kmem_cache *btrfs_free_space_cachep;
 struct btrfs_ordered_sum;
+struct btrfs_ref;
 
 #define BTRFS_MAGIC 0x4D5F53665248425FULL /* ascii _BHRfS_M, no null */
 
@@ -2682,10 +2683,7 @@ int btrfs_free_and_pin_reserved_extent(struct btrfs_fs_info *fs_info,
 void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
-			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 root_objectid, u64 owner, u64 offset,
-			 bool for_reloc);
+			 struct btrfs_ref *generic_ref);
 
 int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 70c05ca30d9a..ff60091aef6b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2026,36 +2026,28 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 
 /* Can return -ENOMEM */
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
-			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 root_objectid, u64 owner, u64 offset,
-			 bool for_reloc)
+			 struct btrfs_ref *generic_ref)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_ref generic_ref = { 0 };
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int old_ref_mod, new_ref_mod;
 	int ret;
 
-	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
-	       root_objectid == BTRFS_TREE_LOG_OBJECTID);
+	BUG_ON(generic_ref->type == BTRFS_REF_NOT_SET ||
+	       !generic_ref->action);
+	BUG_ON(generic_ref->type == BTRFS_REF_METADATA &&
+	       generic_ref->tree_ref.root == BTRFS_TREE_LOG_OBJECTID);
 
-	btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_REF, bytenr,
-			       num_bytes, root->root_key.objectid, parent);
-	generic_ref.skip_qgroup = for_reloc;
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
@@ -3212,8 +3204,10 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	u32 nritems;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item *fi;
+	struct btrfs_ref generic_ref = { 0 };
 	bool for_reloc = btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC);
 	int i;
+	int action;
 	int level;
 	int ret = 0;
 
@@ -3231,6 +3225,10 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 		parent = buf->start;
 	else
 		parent = 0;
+	if (inc)
+		action = BTRFS_ADD_DELAYED_REF;
+	else
+		action = BTRFS_DROP_DELAYED_REF;
 
 	for (i = 0; i < nritems; i++) {
 		if (level == 0) {
@@ -3248,11 +3246,14 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 
 			num_bytes = btrfs_file_extent_disk_num_bytes(buf, fi);
 			key.offset -= btrfs_file_extent_offset(buf, fi);
+			btrfs_init_generic_ref(&generic_ref, action, bytenr,
+					num_bytes, root->root_key.objectid,
+					parent);
+			btrfs_init_data_ref(&generic_ref, ref_root, key.objectid,
+					    key.offset);
+			generic_ref.skip_qgroup = for_reloc;
 			if (inc)
-				ret = btrfs_inc_extent_ref(trans, root, bytenr,
-						num_bytes, parent, ref_root,
-						key.objectid, key.offset,
-						for_reloc);
+				ret = btrfs_inc_extent_ref(trans, &generic_ref);
 			else
 				ret = btrfs_free_extent(trans, root, bytenr,
 						num_bytes, parent, ref_root,
@@ -3263,10 +3264,13 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 		} else {
 			bytenr = btrfs_node_blockptr(buf, i);
 			num_bytes = fs_info->nodesize;
+			btrfs_init_generic_ref(&generic_ref, action, bytenr,
+					num_bytes, root->root_key.objectid,
+					parent);
+			btrfs_init_tree_ref(&generic_ref, level - 1, ref_root);
+			generic_ref.skip_qgroup = for_reloc;
 			if (inc)
-				ret = btrfs_inc_extent_ref(trans, root, bytenr,
-						num_bytes, parent, ref_root,
-						level - 1, 0, for_reloc);
+				ret = btrfs_inc_extent_ref(trans, &generic_ref);
 			else
 				ret = btrfs_free_extent(trans, root, bytenr,
 						num_bytes, parent, ref_root,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 56414c2ebf1d..35c786334972 100644
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
@@ -909,11 +910,15 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 			btrfs_mark_buffer_dirty(leaf);
 
 			if (update_refs && disk_bytenr > 0) {
-				ret = btrfs_inc_extent_ref(trans, root,
-						disk_bytenr, num_bytes, 0,
+				btrfs_init_generic_ref(&ref,
+						BTRFS_ADD_DELAYED_REF,
+						disk_bytenr, num_bytes,
+						root->root_key.objectid, 0);
+				btrfs_init_data_ref(&ref,
 						root->root_key.objectid,
 						new_key.objectid,
-						start - extent_offset, false);
+						start - extent_offset);
+				ret = btrfs_inc_extent_ref(trans, &ref);
 				BUG_ON(ret); /* -ENOMEM */
 			}
 			key.offset = start;
@@ -1142,6 +1147,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_path *path;
 	struct btrfs_file_extent_item *fi;
+	struct btrfs_ref ref = { 0 };
 	struct btrfs_key key;
 	struct btrfs_key new_key;
 	u64 bytenr;
@@ -1287,9 +1293,11 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 						extent_end - split);
 		btrfs_mark_buffer_dirty(leaf);
 
-		ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes,
-					   0, root->root_key.objectid,
-					   ino, orig_offset, false);
+		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, bytenr,
+				       num_bytes, root->root_key.objectid, 0);
+		btrfs_init_data_ref(&ref, root->root_key.objectid, ino,
+				    orig_offset);
+		ret = btrfs_inc_extent_ref(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 539dd3f7f1bd..aa83f68e22ee 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2540,6 +2540,7 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 	struct btrfs_file_extent_item *item;
 	struct btrfs_ordered_extent *ordered;
 	struct btrfs_trans_handle *trans;
+	struct btrfs_ref ref = { 0 };
 	struct btrfs_root *root;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
@@ -2710,10 +2711,11 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 	inode_add_bytes(inode, len);
 	btrfs_release_path(path);
 
-	ret = btrfs_inc_extent_ref(trans, root, new->bytenr,
-			new->disk_len, 0,
-			backref->root_id, backref->inum,
-			new->file_pos, false);	/* start - extent_offset */
+	btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, new->bytenr,
+			       new->disk_len, backref->root_id, 0);
+	btrfs_init_data_ref(&ref, backref->root_id, backref->inum,
+			    new->file_pos);  /* start - extent_offset */
+	ret = btrfs_inc_extent_ref(trans, &ref);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_free_path;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ab9e87eb9a4e..d6115b04134f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4083,14 +4083,17 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 								datal);
 
 				if (disko) {
+					struct btrfs_ref ref = { 0 };
 					inode_add_bytes(inode, datal);
-					ret = btrfs_inc_extent_ref(trans,
-							root,
-							disko, diskl, 0,
-							root->root_key.objectid,
-							btrfs_ino(BTRFS_I(inode)),
-							new_key.offset - datao,
-							false);
+					btrfs_init_generic_ref(&ref,
+						BTRFS_ADD_DELAYED_REF, disko,
+						diskl, root->root_key.objectid,
+						0);
+					btrfs_init_data_ref(&ref,
+						root->root_key.objectid,
+						btrfs_ino(BTRFS_I(inode)),
+						new_key.offset - datao);
+					ret = btrfs_inc_extent_ref(trans, &ref);
 					if (ret) {
 						btrfs_abort_transaction(trans,
 									ret);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 80550c4464f3..7aa240d1f361 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1658,6 +1658,8 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 
 	nritems = btrfs_header_nritems(leaf);
 	for (i = 0; i < nritems; i++) {
+		struct btrfs_ref ref = { 0 };
+
 		cond_resched();
 		btrfs_item_key_to_cpu(leaf, &key, i);
 		if (key.type != BTRFS_EXTENT_DATA_KEY)
@@ -1718,10 +1720,12 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 		dirty = 1;
 
 		key.offset -= btrfs_file_extent_offset(leaf, fi);
-		ret = btrfs_inc_extent_ref(trans, root, new_bytenr,
-					   num_bytes, parent,
-					   btrfs_header_owner(leaf),
-					   key.objectid, key.offset, false);
+
+		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, new_bytenr,
+				num_bytes, root->root_key.objectid, parent);
+		btrfs_init_data_ref(&ref, btrfs_header_owner(leaf),
+				    key.objectid, key.offset);
+		ret = btrfs_inc_extent_ref(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			break;
@@ -1771,6 +1775,7 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 	struct btrfs_fs_info *fs_info = dest->fs_info;
 	struct extent_buffer *eb;
 	struct extent_buffer *parent;
+	struct btrfs_ref ref = { 0 };
 	struct btrfs_key key;
 	u64 old_bytenr;
 	u64 new_bytenr;
@@ -1929,14 +1934,18 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 					      path->slots[level], old_ptr_gen);
 		btrfs_mark_buffer_dirty(path->nodes[level]);
 
-		ret = btrfs_inc_extent_ref(trans, src, old_bytenr,
-					blocksize, path->nodes[level]->start,
-					src->root_key.objectid, level - 1, 0,
-					true);
+		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, old_bytenr,
+				       blocksize, src->root_key.objectid,
+				       path->nodes[level]->start);
+		btrfs_init_tree_ref(&ref, level - 1, src->root_key.objectid);
+		ref.skip_qgroup = true;
+		ret = btrfs_inc_extent_ref(trans, &ref);
 		BUG_ON(ret);
-		ret = btrfs_inc_extent_ref(trans, dest, new_bytenr,
-					blocksize, 0, dest->root_key.objectid,
-					level - 1, 0, true);
+		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, new_bytenr,
+				       blocksize, dest->root_key.objectid, 0);
+		btrfs_init_tree_ref(&ref, level - 1, dest->root_key.objectid);
+		ref.skip_qgroup = true;
+		ret = btrfs_inc_extent_ref(trans, &ref);
 		BUG_ON(ret);
 
 		ret = btrfs_free_extent(trans, src, new_bytenr, blocksize,
@@ -2763,6 +2772,7 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 	rc->backref_cache.path[node->level] = node;
 	list_for_each_entry(edge, &node->upper, list[LOWER]) {
 		struct btrfs_key first_key;
+		struct btrfs_ref ref = { 0 };
 
 		cond_resched();
 
@@ -2860,11 +2870,13 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 						      trans->transid);
 			btrfs_mark_buffer_dirty(upper->eb);
 
-			ret = btrfs_inc_extent_ref(trans, root,
-						node->eb->start, blocksize,
-						upper->eb->start,
-						btrfs_header_owner(upper->eb),
-						node->level, 0, false);
+			btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF,
+					       node->eb->start, blocksize,
+					       root->root_key.objectid,
+					       upper->eb->start);
+			btrfs_init_tree_ref(&ref, node->level,
+					    btrfs_header_owner(upper->eb));
+			ret = btrfs_inc_extent_ref(trans, &ref);
 			BUG_ON(ret);
 
 			ret = btrfs_drop_subtree(trans, root, eb, upper->eb);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9e4d274902b8..e4da64088679 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -693,9 +693,11 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
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
@@ -703,10 +705,14 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 			ret = btrfs_lookup_data_extent(fs_info, ins.objectid,
 						ins.offset);
 			if (ret == 0) {
-				ret = btrfs_inc_extent_ref(trans, root,
+				btrfs_init_generic_ref(&ref,
+						BTRFS_ADD_DELAYED_REF,
 						ins.objectid, ins.offset,
-						0, root->root_key.objectid,
-						key->objectid, offset, false);
+						root->root_key.objectid, 0);
+				btrfs_init_data_ref(&ref,
+						root->root_key.objectid,
+						key->objectid, offset);
+				ret = btrfs_inc_extent_ref(trans, &ref);
 				if (ret)
 					goto out;
 			} else {
-- 
2.19.2

