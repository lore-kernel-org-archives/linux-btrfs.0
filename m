Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232E8C65BAF
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAF042084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:31:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAF042084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbeLLHb3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 02:31:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:39672 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726603AbeLLHb2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 02:31:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C4D7AADDD
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 07:31:25 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/8] btrfs: delayed-ref: Use btrfs_ref to refactor btrfs_add_delayed_tree_ref()
Date:   Wed, 12 Dec 2018 15:30:57 +0800
Message-Id: <20181212073102.7736-4-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181212073102.7736-1-wqu@suse.com>
References: <20181212073102.7736-1-wqu@suse.com>
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
 fs/btrfs/delayed-ref.c | 22 ++++++++++++++-------
 fs/btrfs/delayed-ref.h |  3 +--
 fs/btrfs/extent-tree.c | 44 +++++++++++++++++++++++++-----------------
 3 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 2fc7936a377f..d2d0aa5f5620 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -704,8 +704,7 @@ static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
  * transaction commits.
  */
 int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
-			       u64 bytenr, u64 num_bytes, u64 parent,
-			       u64 ref_root,  int level, int action,
+			       struct btrfs_ref *generic_ref,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int *old_ref_mod, int *new_ref_mod)
 {
@@ -714,10 +713,16 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_qgroup_extent_record *record = NULL;
-	bool is_system = (ref_root == BTRFS_CHUNK_TREE_OBJECTID);
+	bool is_system = (generic_ref->real_root == BTRFS_CHUNK_TREE_OBJECTID);
+	int action = generic_ref->action;
+	int level = generic_ref->tree_ref.level;
 	int ret;
+	u64 bytenr = generic_ref->bytenr;
+	u64 num_bytes = generic_ref->len;
+	u64 parent = generic_ref->parent;
 	u8 ref_type;
 
+	ASSERT(generic_ref->type == BTRFS_REF_METADATA && generic_ref->action);
 	BUG_ON(extent_op && extent_op->is_data);
 	ref = kmem_cache_alloc(btrfs_delayed_tree_ref_cachep, GFP_NOFS);
 	if (!ref)
@@ -730,7 +735,9 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	}
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
-	    is_fstree(ref_root)) {
+	    is_fstree(generic_ref->real_root) &&
+	    is_fstree(generic_ref->tree_ref.root) &&
+	    !generic_ref->skip_qgroup) {
 		record = kzalloc(sizeof(*record), GFP_NOFS);
 		if (!record) {
 			kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
@@ -745,13 +752,14 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
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
index 7f700e00c77a..b3b18463cc8f 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -340,8 +340,7 @@ static inline void btrfs_put_delayed_ref_head(struct btrfs_delayed_ref_head *hea
 }
 
 int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
-			       u64 bytenr, u64 num_bytes, u64 parent,
-			       u64 ref_root, int level, int action,
+			       struct btrfs_ref *generic_ref,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int *old_ref_mod, int *new_ref_mod);
 int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9fb922d2f8f6..e0ce14cd6d6e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2030,6 +2030,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 u64 root_objectid, u64 owner, u64 offset)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_ref generic_ref = { 0 };
 	int old_ref_mod, new_ref_mod;
 	int ret;
 
@@ -2039,12 +2040,13 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	btrfs_ref_tree_mod(root, bytenr, num_bytes, parent, root_objectid,
 			   owner, offset, BTRFS_ADD_DELAYED_REF);
 
+	btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_REF, bytenr,
+			       num_bytes, parent);
+	generic_ref.real_root = root->root_key.objectid;
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
-						 num_bytes, parent,
-						 root_objectid, (int)owner,
-						 BTRFS_ADD_DELAYED_REF, NULL,
-						 &old_ref_mod, &new_ref_mod);
+		btrfs_init_tree_ref(&generic_ref, (int)owner, root_objectid);
+		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref,
+				NULL, &old_ref_mod, &new_ref_mod);
 	} else {
 		ret = btrfs_add_delayed_data_ref(trans, bytenr,
 						 num_bytes, parent,
@@ -7008,9 +7010,15 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			   u64 parent, int last_ref)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_ref generic_ref = { 0 };
 	int pin = 1;
 	int ret;
 
+	btrfs_init_generic_ref(&generic_ref, BTRFS_DROP_DELAYED_REF,
+			       buf->start, buf->len, parent);
+	btrfs_init_tree_ref(&generic_ref, btrfs_header_level(buf),
+			    root->root_key.objectid);
+
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
 		int old_ref_mod, new_ref_mod;
 
@@ -7018,11 +7026,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 				   root->root_key.objectid,
 				   btrfs_header_level(buf), 0,
 				   BTRFS_DROP_DELAYED_REF);
-		ret = btrfs_add_delayed_tree_ref(trans, buf->start,
-						 buf->len, parent,
-						 root->root_key.objectid,
-						 btrfs_header_level(buf),
-						 BTRFS_DROP_DELAYED_REF, NULL,
+		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL,
 						 &old_ref_mod, &new_ref_mod);
 		BUG_ON(ret); /* -ENOMEM */
 		pin = old_ref_mod >= 0 && new_ref_mod < 0;
@@ -7075,6 +7079,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      u64 owner, u64 offset)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_ref generic_ref = { 0 };
 	int old_ref_mod, new_ref_mod;
 	int ret;
 
@@ -7086,6 +7091,9 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 				   root_objectid, owner, offset,
 				   BTRFS_DROP_DELAYED_REF);
 
+	btrfs_init_generic_ref(&generic_ref, BTRFS_DROP_DELAYED_REF, bytenr,
+			       num_bytes, parent);
+	generic_ref.real_root = root->root_key.objectid;
 	/*
 	 * tree log blocks never actually go into the extent allocation
 	 * tree, just update pinning info and exit early.
@@ -7097,10 +7105,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		old_ref_mod = new_ref_mod = 0;
 		ret = 0;
 	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
-						 num_bytes, parent,
-						 root_objectid, (int)owner,
-						 BTRFS_DROP_DELAYED_REF, NULL,
+		btrfs_init_tree_ref(&generic_ref, (int)owner, root_objectid);
+		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL,
 						 &old_ref_mod, &new_ref_mod);
 	} else {
 		ret = btrfs_add_delayed_data_ref(trans, bytenr,
@@ -8270,6 +8276,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 	struct btrfs_block_rsv *block_rsv;
 	struct extent_buffer *buf;
 	struct btrfs_delayed_extent_op *extent_op;
+	struct btrfs_ref generic_ref = { 0 };
 	u64 flags = 0;
 	int ret;
 	u32 blocksize = fs_info->nodesize;
@@ -8327,10 +8334,11 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		btrfs_ref_tree_mod(root, ins.objectid, ins.offset, parent,
 				   root_objectid, level, 0,
 				   BTRFS_ADD_DELAYED_EXTENT);
-		ret = btrfs_add_delayed_tree_ref(trans, ins.objectid,
-						 ins.offset, parent,
-						 root_objectid, level,
-						 BTRFS_ADD_DELAYED_EXTENT,
+		btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_EXTENT,
+				       ins.objectid, ins.offset, parent);
+		generic_ref.real_root = root->root_key.objectid;
+		btrfs_init_tree_ref(&generic_ref, level, root_objectid);
+		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref,
 						 extent_op, NULL, NULL);
 		if (ret)
 			goto out_free_delayed;
-- 
2.19.2

