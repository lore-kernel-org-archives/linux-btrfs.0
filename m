Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E42C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 06:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCFD4206DF
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 06:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbfDDGqI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:46:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:36436 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbfDDGqI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Apr 2019 02:46:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D1F7AAE7D
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2019 06:46:06 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3.1 4/9] btrfs: delayed-ref: Use btrfs_ref to refactor btrfs_add_delayed_data_ref()
Date:   Thu,  4 Apr 2019 14:45:32 +0800
Message-Id: <20190404064537.4031-5-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190404064537.4031-1-wqu@suse.com>
References: <20190404064537.4031-1-wqu@suse.com>
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
 fs/btrfs/delayed-ref.c | 18 +++++++++++++-----
 fs/btrfs/delayed-ref.h |  7 +++----
 fs/btrfs/extent-tree.c | 23 ++++++++++-------------
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index e0802d59a1ca..a315387b8f1c 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -830,10 +830,9 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
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
@@ -841,9 +840,17 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
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
@@ -867,7 +874,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	}
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
-	    is_fstree(ref_root)) {
+	    is_fstree(ref_root) && is_fstree(generic_ref->real_root) &&
+	    !generic_ref->skip_qgroup) {
 		record = kzalloc(sizeof(*record), GFP_NOFS);
 		if (!record) {
 			kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index ad7eaa8993e4..393251e5121d 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -344,10 +344,9 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
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
index 4d499d1b1cc8..973093bdf307 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2065,10 +2065,8 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
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
 
@@ -7368,10 +7366,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
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
 
@@ -8479,6 +8475,7 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				     u64 offset, u64 ram_bytes,
 				     struct btrfs_key *ins)
 {
+	struct btrfs_ref generic_ref = { 0 };
 	int ret;
 
 	BUG_ON(root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID);
@@ -8487,11 +8484,11 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
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
2.21.0

