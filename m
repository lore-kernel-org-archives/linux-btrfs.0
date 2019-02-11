Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF03FC282D7
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 05:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6F7820855
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 05:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfBKFRI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 00:17:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:49548 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726045AbfBKFRH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 00:17:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E0C15AD9D
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 05:17:05 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 4/9] btrfs: delayed-ref: Use btrfs_ref to refactor btrfs_add_delayed_data_ref()
Date:   Mon, 11 Feb 2019 13:16:48 +0800
Message-Id: <20190211051653.3167-5-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190211051653.3167-1-wqu@suse.com>
References: <20190211051653.3167-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just like btrfs_add_delayed_tree_ref(), use btrfs_ref to refactor
btrfs_add_delayed_data_ref().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/delayed-ref.c | 20 ++++++++++++++------
 fs/btrfs/delayed-ref.h |  7 +++----
 fs/btrfs/extent-tree.c | 23 ++++++++++-------------
 3 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 5c864ce2f959..d4245ccd1afb 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -837,10 +837,9 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
  * add a delayed data ref. it's similar to btrfs_add_delayed_tree_ref.
  */
 int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
-			       u64 bytenr, u64 num_bytes,
-			       u64 parent, u64 ref_root,
-			       u64 owner, u64 offset, u64 reserved, int action,
-			       int *old_ref_mod, int *new_ref_mod)
+			       struct btrfs_ref *generic_ref,
+			       u64 reserved, int *old_ref_mod,
+			       int *new_ref_mod)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_delayed_data_ref *ref;
@@ -848,9 +847,17 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_qgroup_extent_record *record = NULL;
 	int qrecord_inserted;
+	int action = generic_ref->action;
 	int ret;
+	u64 bytenr = generic_ref->bytenr;
+	u64 num_bytes = generic_ref->len;
+	u64 parent = generic_ref->parent;
+	u64 ref_root = generic_ref->data_ref.ref_root;
+	u64 owner = generic_ref->data_ref.ino;
+	u64 offset = generic_ref->data_ref.offset;
 	u8 ref_type;
 
+	ASSERT(generic_ref->type == BTRFS_REF_DATA && action);
 	ref = kmem_cache_alloc(btrfs_delayed_data_ref_cachep, GFP_NOFS);
 	if (!ref)
 		return -ENOMEM;
@@ -874,8 +881,9 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	}
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
-	    is_fstree(ref_root)) {
-		record = kmalloc(sizeof(*record), GFP_NOFS);
+	    is_fstree(ref_root) && is_fstree(generic_ref->real_root) &&
+	    !generic_ref->skip_qgroup) {
+		record = kzalloc(sizeof(*record), GFP_NOFS);
 		if (!record) {
 			kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
 			kmem_cache_free(btrfs_delayed_ref_head_cachep,
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 70bb080bf3ef..9037a7de18b7 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -355,10 +355,9 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int *old_ref_mod, int *new_ref_mod);
 int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
-			       u64 bytenr, u64 num_bytes,
-			       u64 parent, u64 ref_root,
-			       u64 owner, u64 offset, u64 reserved, int action,
-			       int *old_ref_mod, int *new_ref_mod);
+			       struct btrfs_ref *generic_ref,
+			       u64 reserved, int *old_ref_mod,
+			       int *new_ref_mod);
 int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				struct btrfs_trans_handle *trans,
 				u64 bytenr, u64 num_bytes,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b01fad9a56ff..36516b33d07f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2066,10 +2066,8 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref,
 				NULL, &old_ref_mod, &new_ref_mod);
 	} else {
-		ret = btrfs_add_delayed_data_ref(trans, bytenr,
-						 num_bytes, parent,
-						 root_objectid, owner, offset,
-						 0, BTRFS_ADD_DELAYED_REF,
+		btrfs_init_data_ref(&generic_ref, root_objectid, owner, offset);
+		ret = btrfs_add_delayed_data_ref(trans, &generic_ref, 0,
 						 &old_ref_mod, &new_ref_mod);
 	}
 
@@ -7378,10 +7376,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL,
 						 &old_ref_mod, &new_ref_mod);
 	} else {
-		ret = btrfs_add_delayed_data_ref(trans, bytenr,
-						 num_bytes, parent,
-						 root_objectid, owner, offset,
-						 0, BTRFS_DROP_DELAYED_REF,
+		btrfs_init_data_ref(&generic_ref, root_objectid, owner, offset);
+		ret = btrfs_add_delayed_data_ref(trans, &generic_ref, 0,
 						 &old_ref_mod, &new_ref_mod);
 	}
 
@@ -8489,6 +8485,7 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				     u64 offset, u64 ram_bytes,
 				     struct btrfs_key *ins)
 {
+	struct btrfs_ref generic_ref = { 0 };
 	int ret;
 
 	BUG_ON(root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID);
@@ -8497,11 +8494,11 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 			   root->root_key.objectid, owner, offset,
 			   BTRFS_ADD_DELAYED_EXTENT);
 
-	ret = btrfs_add_delayed_data_ref(trans, ins->objectid,
-					 ins->offset, 0,
-					 root->root_key.objectid, owner,
-					 offset, ram_bytes,
-					 BTRFS_ADD_DELAYED_EXTENT, NULL, NULL);
+	btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_EXTENT,
+			       ins->objectid, ins->offset, 0);
+	btrfs_init_data_ref(&generic_ref, root->root_key.objectid, owner, offset);
+	ret = btrfs_add_delayed_data_ref(trans, &generic_ref,
+					 ram_bytes, NULL, NULL);
 	return ret;
 }
 
-- 
2.20.1

