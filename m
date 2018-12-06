Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F528C04EBF
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 350DB214DB
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:59:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 350DB214DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbeLFG7T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 01:59:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:59448 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728489AbeLFG7T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 01:59:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 64BA5AED3
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Dec 2018 06:59:16 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 5/8] btrfs: ref-verify: Use btrfs_ref to refactor btrfs_ref_tree_mod()
Date:   Thu,  6 Dec 2018 14:59:00 +0800
Message-Id: <20181206065903.11343-6-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181206065903.11343-1-wqu@suse.com>
References: <20181206065903.11343-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It's a perfect match for btrfs_ref_tree_mod() to use btrfs_ref, as
btrfs_ref describes a metadata/data reference update comprehensively.

Now we have one less function use confusing owner/level trick.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 27 +++++++--------------
 fs/btrfs/ref-verify.c  | 53 ++++++++++++++++++++++++------------------
 fs/btrfs/ref-verify.h  | 10 ++++----
 3 files changed, 42 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fa5dd3dfe2e7..1d812bc2c7fc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2038,9 +2038,6 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
 	       root_objectid == BTRFS_TREE_LOG_OBJECTID);
 
-	btrfs_ref_tree_mod(root, bytenr, num_bytes, parent, root_objectid,
-			   owner, offset, BTRFS_ADD_DELAYED_REF);
-
 	btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_REF, bytenr,
 			       num_bytes, root->root_key.objectid, parent);
 	generic_ref.skip_qgroup = for_reloc;
@@ -2054,6 +2051,8 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 						 &old_ref_mod, &new_ref_mod);
 	}
 
+	btrfs_ref_tree_mod(fs_info, &generic_ref);
+
 	if (ret == 0 && old_ref_mod < 0 && new_ref_mod >= 0) {
 		bool metadata = owner < BTRFS_FIRST_FREE_OBJECTID;
 
@@ -7025,10 +7024,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
 		int old_ref_mod, new_ref_mod;
 
-		btrfs_ref_tree_mod(root, buf->start, buf->len, parent,
-				   root->root_key.objectid,
-				   btrfs_header_level(buf), 0,
-				   BTRFS_DROP_DELAYED_REF);
+		btrfs_ref_tree_mod(fs_info, &generic_ref);
 		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL,
 						 &old_ref_mod, &new_ref_mod);
 		BUG_ON(ret); /* -ENOMEM */
@@ -7089,11 +7085,6 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 	if (btrfs_is_testing(fs_info))
 		return 0;
 
-	if (root_objectid != BTRFS_TREE_LOG_OBJECTID)
-		btrfs_ref_tree_mod(root, bytenr, num_bytes, parent,
-				   root_objectid, owner, offset,
-				   BTRFS_DROP_DELAYED_REF);
-
 	btrfs_init_generic_ref(&generic_ref, BTRFS_DROP_DELAYED_REF, bytenr,
 			       num_bytes, root->root_key.objectid, parent);
 	generic_ref.skip_qgroup = for_reloc;
@@ -7117,6 +7108,9 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 						 &old_ref_mod, &new_ref_mod);
 	}
 
+	if (root_objectid != BTRFS_TREE_LOG_OBJECTID)
+		btrfs_ref_tree_mod(fs_info, &generic_ref);
+
 	if (ret == 0 && old_ref_mod >= 0 && new_ref_mod < 0) {
 		bool metadata = owner < BTRFS_FIRST_FREE_OBJECTID;
 
@@ -8083,14 +8077,11 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 
 	BUG_ON(root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID);
 
-	btrfs_ref_tree_mod(root, ins->objectid, ins->offset, 0,
-			   root->root_key.objectid, owner, offset,
-			   BTRFS_ADD_DELAYED_EXTENT);
-
 	btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_EXTENT,
 			       ins->objectid, ins->offset,
 			       root->root_key.objectid, 0);
 	btrfs_init_data_ref(&generic_ref, root->root_key.objectid, owner, offset);
+	btrfs_ref_tree_mod(root->fs_info, &generic_ref);
 	ret = btrfs_add_delayed_data_ref(trans, &generic_ref,
 					 ram_bytes, NULL, NULL);
 	return ret;
@@ -8338,13 +8329,11 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		extent_op->is_data = false;
 		extent_op->level = level;
 
-		btrfs_ref_tree_mod(root, ins.objectid, ins.offset, parent,
-				   root_objectid, level, 0,
-				   BTRFS_ADD_DELAYED_EXTENT);
 		btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_EXTENT,
 				       ins.objectid, ins.offset,
 				       root->root_key.objectid, parent);
 		btrfs_init_tree_ref(&generic_ref, level, root_objectid);
+		btrfs_ref_tree_mod(fs_info, &generic_ref);
 		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref,
 						 extent_op, NULL, NULL);
 		if (ret)
diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
index d69fbfb30aa9..f6c15b612570 100644
--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -670,36 +670,43 @@ static void dump_block_entry(struct btrfs_fs_info *fs_info,
 
 /*
  * btrfs_ref_tree_mod: called when we modify a ref for a bytenr
- * @root: the root we are making this modification from.
- * @bytenr: the bytenr we are modifying.
- * @num_bytes: number of bytes.
- * @parent: the parent bytenr.
- * @ref_root: the original root owner of the bytenr.
- * @owner: level in the case of metadata, inode in the case of data.
- * @offset: 0 for metadata, file offset for data.
- * @action: the action that we are doing, this is the same as the delayed ref
- *	action.
  *
  * This will add an action item to the given bytenr and do sanity checks to make
  * sure we haven't messed something up.  If we are making a new allocation and
  * this block entry has history we will delete all previous actions as long as
  * our sanity checks pass as they are no longer needed.
  */
-int btrfs_ref_tree_mod(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
-		       u64 parent, u64 ref_root, u64 owner, u64 offset,
-		       int action)
+int btrfs_ref_tree_mod(struct btrfs_fs_info *fs_info,
+		       struct btrfs_ref *generic_ref)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct ref_entry *ref = NULL, *exist;
 	struct ref_action *ra = NULL;
 	struct block_entry *be = NULL;
 	struct root_entry *re = NULL;
+	int action = generic_ref->action;
 	int ret = 0;
-	bool metadata = owner < BTRFS_FIRST_FREE_OBJECTID;
+	bool metadata;
+	u64 bytenr = generic_ref->bytenr;
+	u64 num_bytes = generic_ref->len;
+	u64 parent = generic_ref->parent;
+	u64 ref_root;
+	u64 owner;
+	u64 offset;
 
-	if (!btrfs_test_opt(root->fs_info, REF_VERIFY))
+	if (!btrfs_test_opt(fs_info, REF_VERIFY))
 		return 0;
 
+	if (generic_ref->type == BTRFS_REF_METADATA) {
+		ref_root = generic_ref->tree_ref.root;
+		owner = generic_ref->tree_ref.level;
+		offset = 0;
+	} else {
+		ref_root = generic_ref->data_ref.ref_root;
+		owner = generic_ref->data_ref.ino;
+		offset = generic_ref->data_ref.offset;
+	}
+	metadata = owner < BTRFS_FIRST_FREE_OBJECTID;
+
 	ref = kzalloc(sizeof(struct ref_entry), GFP_NOFS);
 	ra = kmalloc(sizeof(struct ref_action), GFP_NOFS);
 	if (!ra || !ref) {
@@ -732,7 +739,7 @@ int btrfs_ref_tree_mod(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
 
 	INIT_LIST_HEAD(&ra->list);
 	ra->action = action;
-	ra->root = root->root_key.objectid;
+	ra->root = generic_ref->real_root;
 
 	/*
 	 * This is an allocation, preallocate the block_entry in case we haven't
@@ -745,7 +752,7 @@ int btrfs_ref_tree_mod(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
 		 * is and the new root objectid, so let's not treat the passed
 		 * in root as if it really has a ref for this bytenr.
 		 */
-		be = add_block_entry(root->fs_info, bytenr, num_bytes, ref_root);
+		be = add_block_entry(fs_info, bytenr, num_bytes, ref_root);
 		if (IS_ERR(be)) {
 			kfree(ra);
 			ret = PTR_ERR(be);
@@ -787,13 +794,13 @@ int btrfs_ref_tree_mod(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
 			 * one we want to lookup below when we modify the
 			 * re->num_refs.
 			 */
-			ref_root = root->root_key.objectid;
-			re->root_objectid = root->root_key.objectid;
+			ref_root = generic_ref->real_root;
+			re->root_objectid = generic_ref->real_root;
 			re->num_refs = 0;
 		}
 
-		spin_lock(&root->fs_info->ref_verify_lock);
-		be = lookup_block_entry(&root->fs_info->block_tree, bytenr);
+		spin_lock(&fs_info->ref_verify_lock);
+		be = lookup_block_entry(&fs_info->block_tree, bytenr);
 		if (!be) {
 			btrfs_err(fs_info,
 "trying to do action %d to bytenr %llu num_bytes %llu but there is no existing entry!",
@@ -862,7 +869,7 @@ int btrfs_ref_tree_mod(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
 			 * didn't thik of some other corner case.
 			 */
 			btrfs_err(fs_info, "failed to find root %llu for %llu",
-				  root->root_key.objectid, be->bytenr);
+				  generic_ref->real_root, be->bytenr);
 			dump_block_entry(fs_info, be);
 			dump_ref_action(fs_info, ra);
 			kfree(ra);
@@ -881,7 +888,7 @@ int btrfs_ref_tree_mod(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
 	list_add_tail(&ra->list, &be->actions);
 	ret = 0;
 out_unlock:
-	spin_unlock(&root->fs_info->ref_verify_lock);
+	spin_unlock(&fs_info->ref_verify_lock);
 out:
 	if (ret)
 		btrfs_clear_opt(fs_info->mount_opt, REF_VERIFY);
diff --git a/fs/btrfs/ref-verify.h b/fs/btrfs/ref-verify.h
index b7d2a4edfdb7..855de37719b5 100644
--- a/fs/btrfs/ref-verify.h
+++ b/fs/btrfs/ref-verify.h
@@ -9,9 +9,8 @@
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 int btrfs_build_ref_tree(struct btrfs_fs_info *fs_info);
 void btrfs_free_ref_cache(struct btrfs_fs_info *fs_info);
-int btrfs_ref_tree_mod(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
-		       u64 parent, u64 ref_root, u64 owner, u64 offset,
-		       int action);
+int btrfs_ref_tree_mod(struct btrfs_fs_info *fs_info,
+		       struct btrfs_ref *generic_ref);
 void btrfs_free_ref_tree_range(struct btrfs_fs_info *fs_info, u64 start,
 			       u64 len);
 
@@ -30,9 +29,8 @@ static inline void btrfs_free_ref_cache(struct btrfs_fs_info *fs_info)
 {
 }
 
-static inline int btrfs_ref_tree_mod(struct btrfs_root *root, u64 bytenr,
-				     u64 num_bytes, u64 parent, u64 ref_root,
-				     u64 owner, u64 offset, int action)
+static inline int btrfs_ref_tree_mod(struct btrfs_fs_info *fs_info,
+		       struct btrfs_ref *generic_ref)
 {
 	return 0;
 }
-- 
2.19.2

