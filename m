Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90ED1C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 06:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A5A12081C
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 06:41:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A5A12081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbeK1Rlr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 12:41:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:56066 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727082AbeK1Rlr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 12:41:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 824F7AC8B
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 06:41:11 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: Introduce more accurate early reloc tree detection
Date:   Wed, 28 Nov 2018 14:41:06 +0800
Message-Id: <20181128064106.11231-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The biggest challenge for qgroup to skip reloc tree extents is to detect
correct owner of reloc tree blocks owner.

Unlike most data operations, the root of tree reloc tree can't be
easily detected.

For example, for relocation we call btrfs_copy_root to init reloc tree:

btrfs_copy_root(root=257, new_root_objectid=RELOC)
|- btrfs_inc_ref(trans, root=257, cow, 1)
   | << From this point, we won't know this eb will be used for reloc >>
   |- __btrfs_mod_ref(root=257)
      |- btrfS_inc_extent_ref()

In above case, at the timing of calling btrfs_inc_ref(), all later
function will not be aware of the fact that the extent buffer is used
for reloc tree.

This makes it extremely hard for qgroup code to detect tree block
allocated for reloc tree.

The good news is, at btrfs_copy_root() if we found @new_root_objectid ==
RELOC, we set BTRFS_HEADER_FLAG_RELOC for that extent buffer.

We could use that flag to detect reloc tree blocks, then we needs to
modify the following function for an extra parameter:
- btrfs_inc_extent_ref
- btrfs_free_extent
- add_delayed_tree_ref

This parameter change affects a lot of callers, but is needed for qgroup
to reduce balance overhead.

For benchmark, still the same memory backed VM, 4G subvolume 16
snaphots:
                     | v4.20-rc1 + delayed* | w/ patch       | diff
-----------------------------------------------------------------------
relocated extents    | 22703                | 22610          | -0.0%
qgroup dirty extents | 74938                | 69292          | -7.5%
time (real)          | 24.567s              | 23.546         | -4.1%

*: With delayed subtree scan and "btrfs: qgroup: Skip delayed data ref
for reloc trees"

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
For the delayed ref API paramaters mess, it need an interface refactor
to make things tidy.
In fact from current interface, we don't even have a method to know the
real owner of a delayed ref.
It will definitely cause problem for later qgroup + balance
optimization.
---
 fs/btrfs/ctree.h       |  5 +++--
 fs/btrfs/delayed-ref.c |  5 +++--
 fs/btrfs/delayed-ref.h |  3 ++-
 fs/btrfs/extent-tree.c | 24 +++++++++++++++++-------
 fs/btrfs/file.c        | 10 +++++-----
 fs/btrfs/inode.c       |  4 ++--
 fs/btrfs/ioctl.c       |  3 ++-
 fs/btrfs/relocation.c  | 16 +++++++++-------
 fs/btrfs/tree-log.c    |  2 +-
 9 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e32fcf211c8a..6f4b1e605736 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2673,7 +2673,7 @@ int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
-		      u64 owner, u64 offset);
+		      u64 owner, u64 offset, bool for_reloc);
 
 int btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info,
 			       u64 start, u64 len, int delalloc);
@@ -2684,7 +2684,8 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 root_objectid, u64 owner, u64 offset);
+			 u64 root_objectid, u64 owner, u64 offset,
+			 bool for_reloc);
 
 int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 269bd6ecb8f3..685b21b2dc24 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -718,7 +718,8 @@ static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
  */
 int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes, u64 parent,
-			       u64 ref_root,  int level, int action,
+			       u64 ref_root,  int level, bool for_reloc,
+			       int action,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int *old_ref_mod, int *new_ref_mod)
 {
@@ -744,7 +745,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	}
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
-	    is_fstree(ref_root)) {
+	    is_fstree(ref_root) && !for_reloc) {
 		record = kmalloc(sizeof(*record), GFP_NOFS);
 		if (!record) {
 			kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 6c60737e55d6..35b38410e6bf 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -236,7 +236,8 @@ static inline void btrfs_put_delayed_ref_head(struct btrfs_delayed_ref_head *hea
 
 int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes, u64 parent,
-			       u64 ref_root, int level, int action,
+			       u64 ref_root, int level, bool for_reloc,
+			       int action,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int *old_ref_mod, int *new_ref_mod);
 int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0554d2cc2ea1..b48e1858cf8b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2027,7 +2027,8 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
-			 u64 root_objectid, u64 owner, u64 offset)
+			 u64 root_objectid, u64 owner, u64 offset,
+			 bool for_reloc)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int old_ref_mod, new_ref_mod;
@@ -2043,6 +2044,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
 						 num_bytes, parent,
 						 root_objectid, (int)owner,
+						 for_reloc,
 						 BTRFS_ADD_DELAYED_REF, NULL,
 						 &old_ref_mod, &new_ref_mod);
 	} else {
@@ -3217,12 +3219,13 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	u32 nritems;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item *fi;
+	bool for_reloc = btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC);
 	int i;
 	int level;
 	int ret = 0;
 	int (*process_func)(struct btrfs_trans_handle *,
 			    struct btrfs_root *,
-			    u64, u64, u64, u64, u64, u64);
+			    u64, u64, u64, u64, u64, u64, bool);
 
 
 	if (btrfs_is_testing(fs_info))
@@ -3263,14 +3266,15 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			key.offset -= btrfs_file_extent_offset(buf, fi);
 			ret = process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, key.objectid,
-					   key.offset);
+					   key.offset, for_reloc);
 			if (ret)
 				goto fail;
 		} else {
 			bytenr = btrfs_node_blockptr(buf, i);
 			num_bytes = fs_info->nodesize;
 			ret = process_func(trans, root, bytenr, num_bytes,
-					   parent, ref_root, level - 1, 0);
+					   parent, ref_root, level - 1, 0,
+					   for_reloc);
 			if (ret)
 				goto fail;
 		}
@@ -7022,7 +7026,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 		ret = btrfs_add_delayed_tree_ref(trans, buf->start,
 						 buf->len, parent,
 						 root->root_key.objectid,
-						 btrfs_header_level(buf),
+						 btrfs_header_level(buf), false,
 						 BTRFS_DROP_DELAYED_REF, NULL,
 						 &old_ref_mod, &new_ref_mod);
 		BUG_ON(ret); /* -ENOMEM */
@@ -7073,7 +7077,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
-		      u64 owner, u64 offset)
+		      u64 owner, u64 offset, bool for_reloc)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int old_ref_mod, new_ref_mod;
@@ -7101,6 +7105,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
 						 num_bytes, parent,
 						 root_objectid, (int)owner,
+						 for_reloc,
 						 BTRFS_DROP_DELAYED_REF, NULL,
 						 &old_ref_mod, &new_ref_mod);
 	} else {
@@ -8273,6 +8278,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_extent_op *extent_op;
 	u64 flags = 0;
 	int ret;
+	bool for_reloc = false;
 	u32 blocksize = fs_info->nodesize;
 	bool skinny_metadata = btrfs_fs_incompat(fs_info, SKINNY_METADATA);
 
@@ -8309,6 +8315,9 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 	} else
 		BUG_ON(parent > 0);
 
+	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID ||
+	    root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+		for_reloc = true;
 	if (root_objectid != BTRFS_TREE_LOG_OBJECTID) {
 		extent_op = btrfs_alloc_delayed_extent_op();
 		if (!extent_op) {
@@ -8331,6 +8340,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		ret = btrfs_add_delayed_tree_ref(trans, ins.objectid,
 						 ins.offset, parent,
 						 root_objectid, level,
+						 for_reloc,
 						 BTRFS_ADD_DELAYED_EXTENT,
 						 extent_op, NULL, NULL);
 		if (ret)
@@ -8695,7 +8705,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 		}
 		ret = btrfs_free_extent(trans, root, bytenr, blocksize,
 					parent, root->root_key.objectid,
-					level - 1, 0);
+					level - 1, 0, false);
 		if (ret)
 			goto out_unlock;
 	}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a3c22e16509b..56414c2ebf1d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -913,7 +913,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 						disk_bytenr, num_bytes, 0,
 						root->root_key.objectid,
 						new_key.objectid,
-						start - extent_offset);
+						start - extent_offset, false);
 				BUG_ON(ret); /* -ENOMEM */
 			}
 			key.offset = start;
@@ -997,7 +997,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 						disk_bytenr, num_bytes, 0,
 						root->root_key.objectid,
 						key.objectid, key.offset -
-						extent_offset);
+						extent_offset, false);
 				BUG_ON(ret); /* -ENOMEM */
 				inode_sub_bytes(inode,
 						extent_end - key.offset);
@@ -1289,7 +1289,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 
 		ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes,
 					   0, root->root_key.objectid,
-					   ino, orig_offset);
+					   ino, orig_offset, false);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
@@ -1323,7 +1323,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		del_nr++;
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					0, root->root_key.objectid,
-					ino, orig_offset);
+					ino, orig_offset, false);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
@@ -1343,7 +1343,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		del_nr++;
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					0, root->root_key.objectid,
-					ino, orig_offset);
+					ino, orig_offset, false);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d3df5b52278c..539dd3f7f1bd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2713,7 +2713,7 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 	ret = btrfs_inc_extent_ref(trans, root, new->bytenr,
 			new->disk_len, 0,
 			backref->root_id, backref->inum,
-			new->file_pos);	/* start - extent_offset */
+			new->file_pos, false);	/* start - extent_offset */
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_free_path;
@@ -4717,7 +4717,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			ret = btrfs_free_extent(trans, root, extent_start,
 						extent_num_bytes, 0,
 						btrfs_header_owner(leaf),
-						ino, extent_offset);
+						ino, extent_offset, false);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
 				break;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3ca6943827ef..ab9e87eb9a4e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4089,7 +4089,8 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 							disko, diskl, 0,
 							root->root_key.objectid,
 							btrfs_ino(BTRFS_I(inode)),
-							new_key.offset - datao);
+							new_key.offset - datao,
+							false);
 					if (ret) {
 						btrfs_abort_transaction(trans,
 									ret);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a5e9754243f4..80550c4464f3 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1721,7 +1721,7 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 		ret = btrfs_inc_extent_ref(trans, root, new_bytenr,
 					   num_bytes, parent,
 					   btrfs_header_owner(leaf),
-					   key.objectid, key.offset);
+					   key.objectid, key.offset, false);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			break;
@@ -1729,7 +1729,7 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					parent, btrfs_header_owner(leaf),
-					key.objectid, key.offset);
+					key.objectid, key.offset, false);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			break;
@@ -1931,21 +1931,23 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 
 		ret = btrfs_inc_extent_ref(trans, src, old_bytenr,
 					blocksize, path->nodes[level]->start,
-					src->root_key.objectid, level - 1, 0);
+					src->root_key.objectid, level - 1, 0,
+					true);
 		BUG_ON(ret);
 		ret = btrfs_inc_extent_ref(trans, dest, new_bytenr,
 					blocksize, 0, dest->root_key.objectid,
-					level - 1, 0);
+					level - 1, 0, true);
 		BUG_ON(ret);
 
 		ret = btrfs_free_extent(trans, src, new_bytenr, blocksize,
 					path->nodes[level]->start,
-					src->root_key.objectid, level - 1, 0);
+					src->root_key.objectid, level - 1, 0,
+					true);
 		BUG_ON(ret);
 
 		ret = btrfs_free_extent(trans, dest, old_bytenr, blocksize,
 					0, dest->root_key.objectid, level - 1,
-					0);
+					0, true);
 		BUG_ON(ret);
 
 		btrfs_unlock_up_safe(path, 0);
@@ -2862,7 +2864,7 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 						node->eb->start, blocksize,
 						upper->eb->start,
 						btrfs_header_owner(upper->eb),
-						node->level, 0);
+						node->level, 0, false);
 			BUG_ON(ret);
 
 			ret = btrfs_drop_subtree(trans, root, eb, upper->eb);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e07f3376b7df..9e4d274902b8 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -706,7 +706,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 				ret = btrfs_inc_extent_ref(trans, root,
 						ins.objectid, ins.offset,
 						0, root->root_key.objectid,
-						key->objectid, offset);
+						key->objectid, offset, false);
 				if (ret)
 					goto out;
 			} else {
-- 
2.19.2

