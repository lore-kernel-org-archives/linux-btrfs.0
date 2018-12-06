Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01843C04EB9
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC8DA214DB
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:59:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC8DA214DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbeLFG7P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 01:59:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:59436 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728489AbeLFG7P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 01:59:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AD882AED3
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Dec 2018 06:59:12 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/8] btrfs: delayed-ref: Use btrfs_ref to refactor btrfs_add_delayed_tree_ref()
Date:   Thu,  6 Dec 2018 14:58:58 +0800
Message-Id: <20181206065903.11343-4-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181206065903.11343-1-wqu@suse.com>
References: <20181206065903.11343-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_add_delayed_tree_ref() has a longer and longer parameter list, and
some caller like btrfs_inc_extent_ref() are using @owner as level for
delayed tree ref.

Instead of making the parameter list longer and longer, use btrfs_ref to
refactor it, so each parameter assignment should be self-explaining
without dirty level/owner trick, and provides the basis for later refactor.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/delayed-ref.c | 24 ++++++++++++++-------
 fs/btrfs/delayed-ref.h |  4 +---
 fs/btrfs/extent-tree.c | 48 ++++++++++++++++++++++++------------------
 3 files changed, 44 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 11dd46be4017..c42b8ade7b07 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -710,9 +710,7 @@ static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
  * transaction commits.
  */
 int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
-			       u64 bytenr, u64 num_bytes, u64 parent,
-			       u64 ref_root,  int level, bool for_reloc,
-			       int action,
+			       struct btrfs_ref *generic_ref,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int *old_ref_mod, int *new_ref_mod)
 {
@@ -722,10 +720,17 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_qgroup_extent_record *record = NULL;
 	int qrecord_inserted;
-	bool is_system = (ref_root == BTRFS_CHUNK_TREE_OBJECTID);
+	bool is_system = (generic_ref->real_root == BTRFS_CHUNK_TREE_OBJECTID);
+	int action = generic_ref->action;
+	int level = generic_ref->tree_ref.level;
 	int ret;
+	u64 bytenr = generic_ref->bytenr;
+	u64 num_bytes = generic_ref->len;
+	u64 parent = generic_ref->parent;
 	u8 ref_type;
 
+	ASSERT(generic_ref && generic_ref->type == BTRFS_REF_METADATA &&
+		generic_ref->action);
 	BUG_ON(extent_op && extent_op->is_data);
 	ref = kmem_cache_alloc(btrfs_delayed_tree_ref_cachep, GFP_NOFS);
 	if (!ref)
@@ -738,7 +743,9 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	}
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
-	    is_fstree(ref_root) && !for_reloc) {
+	    is_fstree(generic_ref->real_root) &&
+	    is_fstree(generic_ref->tree_ref.root) &&
+	    !generic_ref->skip_qgroup) {
 		record = kzalloc(sizeof(*record), GFP_NOFS);
 		if (!record) {
 			kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
@@ -753,13 +760,14 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		ref_type = BTRFS_TREE_BLOCK_REF_KEY;
 
 	init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
-				ref_root, action, ref_type);
-	ref->root = ref_root;
+				generic_ref->tree_ref.root, action, ref_type);
+	ref->root = generic_ref->tree_ref.root;
 	ref->parent = parent;
 	ref->level = level;
 
 	init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
-			      ref_root, 0, action, false, is_system);
+			      generic_ref->tree_ref.root, 0, action, false,
+			      is_system);
 	head_ref->extent_op = extent_op;
 
 	delayed_refs = &trans->transaction->delayed_refs;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index e36d6b05d85e..dbe029c4e01b 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -333,9 +333,7 @@ static inline void btrfs_put_delayed_ref_head(struct btrfs_delayed_ref_head *hea
 }
 
 int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
-			       u64 bytenr, u64 num_bytes, u64 parent,
-			       u64 ref_root, int level, bool for_reloc,
-			       int action,
+			       struct btrfs_ref *generic_ref,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int *old_ref_mod, int *new_ref_mod);
 int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ea68d288d761..ecfa0234863b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2031,6 +2031,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 bool for_reloc)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_ref generic_ref = { 0 };
 	int old_ref_mod, new_ref_mod;
 	int ret;
 
@@ -2040,13 +2041,13 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	btrfs_ref_tree_mod(root, bytenr, num_bytes, parent, root_objectid,
 			   owner, offset, BTRFS_ADD_DELAYED_REF);
 
+	btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_REF, bytenr,
+			       num_bytes, root->root_key.objectid, parent);
+	generic_ref.skip_qgroup = for_reloc;
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
-						 num_bytes, parent,
-						 root_objectid, (int)owner,
-						 for_reloc,
-						 BTRFS_ADD_DELAYED_REF, NULL,
-						 &old_ref_mod, &new_ref_mod);
+		btrfs_init_tree_ref(&generic_ref, (int)owner, root_objectid);
+		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref,
+				NULL, &old_ref_mod, &new_ref_mod);
 	} else {
 		ret = btrfs_add_delayed_data_ref(trans, root, bytenr,
 						 num_bytes, parent,
@@ -7013,9 +7014,16 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			   u64 parent, int last_ref)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_ref generic_ref = { 0 };
 	int pin = 1;
 	int ret;
 
+	btrfs_init_generic_ref(&generic_ref, BTRFS_DROP_DELAYED_REF,
+			       buf->start, buf->len, root->root_key.objectid,
+			       parent);
+	btrfs_init_tree_ref(&generic_ref, btrfs_header_level(buf),
+			    root->root_key.objectid);
+
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
 		int old_ref_mod, new_ref_mod;
 
@@ -7023,11 +7031,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 				   root->root_key.objectid,
 				   btrfs_header_level(buf), 0,
 				   BTRFS_DROP_DELAYED_REF);
-		ret = btrfs_add_delayed_tree_ref(trans, buf->start,
-						 buf->len, parent,
-						 root->root_key.objectid,
-						 btrfs_header_level(buf), false,
-						 BTRFS_DROP_DELAYED_REF, NULL,
+		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL,
 						 &old_ref_mod, &new_ref_mod);
 		BUG_ON(ret); /* -ENOMEM */
 		pin = old_ref_mod >= 0 && new_ref_mod < 0;
@@ -7080,6 +7084,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      u64 owner, u64 offset, bool for_reloc)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_ref generic_ref = { 0 };
 	int old_ref_mod, new_ref_mod;
 	int ret;
 
@@ -7091,6 +7096,9 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 				   root_objectid, owner, offset,
 				   BTRFS_DROP_DELAYED_REF);
 
+	btrfs_init_generic_ref(&generic_ref, BTRFS_DROP_DELAYED_REF, bytenr,
+			       num_bytes, root->root_key.objectid, parent);
+	generic_ref.skip_qgroup = for_reloc;
 	/*
 	 * tree log blocks never actually go into the extent allocation
 	 * tree, just update pinning info and exit early.
@@ -7102,11 +7110,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		old_ref_mod = new_ref_mod = 0;
 		ret = 0;
 	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
-						 num_bytes, parent,
-						 root_objectid, (int)owner,
-						 for_reloc,
-						 BTRFS_DROP_DELAYED_REF, NULL,
+		btrfs_init_tree_ref(&generic_ref, (int)owner, root_objectid);
+		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL,
 						 &old_ref_mod, &new_ref_mod);
 	} else {
 		ret = btrfs_add_delayed_data_ref(trans, root, bytenr,
@@ -8276,6 +8281,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 	struct btrfs_block_rsv *block_rsv;
 	struct extent_buffer *buf;
 	struct btrfs_delayed_extent_op *extent_op;
+	struct btrfs_ref generic_ref = { 0 };
 	u64 flags = 0;
 	int ret;
 	bool for_reloc = false;
@@ -8337,11 +8343,11 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		btrfs_ref_tree_mod(root, ins.objectid, ins.offset, parent,
 				   root_objectid, level, 0,
 				   BTRFS_ADD_DELAYED_EXTENT);
-		ret = btrfs_add_delayed_tree_ref(trans, ins.objectid,
-						 ins.offset, parent,
-						 root_objectid, level,
-						 for_reloc,
-						 BTRFS_ADD_DELAYED_EXTENT,
+		btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_EXTENT,
+				       ins.objectid, ins.offset,
+				       root->root_key.objectid, parent);
+		btrfs_init_tree_ref(&generic_ref, level, root_objectid);
+		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref,
 						 extent_op, NULL, NULL);
 		if (ret)
 			goto out_free_delayed;
-- 
2.19.2

