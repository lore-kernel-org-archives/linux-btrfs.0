Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC7AC43610
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 08:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 099C52075B
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 08:46:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 099C52075B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbeKTTOb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 14:14:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:56158 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbeKTTOb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 14:14:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2CCB4AE56
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 08:46:31 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: Skip delayed data ref for reloc trees
Date:   Tue, 20 Nov 2018 16:46:27 +0800
Message-Id: <20181120084627.31299-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently we only check @ref_root in btrfs_add_delayed_data_ref() to
determine whether a data delayed ref is for reloc tree.

Such check is insufficient as for relocation we could pass @ref_root
as the source file tree, causing qgroup to trace unchanged data extents
even we're only relocating metadata chunks.

We could insert qgroup extent record for the following call trace even
we're only relocating metadata block group:

do_relocation()
|- btrfs_cow_block(root=reloc_root)
   |- update_ref_for_cow(root=reloc_root)
      |- __btrfs_mod_ref(root=reloc_root)
         |- ref_root = btrfs_header_owner()
         |- btrfs_add_delayed_data_ref(ref_root=source_root)

And another case when dropping reloc tree:

clean_dirty_root()
|- btrfs_drop_snapshot(root=relocc_root)
   |- walk_up_tree(root=reloc_root)
      |- walk_up_proc(root=reloc_root)
         |- btrfs_dec_ref(root=reloc_root)
            |- __btrfs_mod_ref(root=reloc_root)
               |- ref_root = btrfs_header_owner()
               |- btrfs_add_delayed_data_ref(ref_root=source_root)

This patch will introduce @root parameter for
btrfs_add_delayed_data_ref(), so that we could determine if this data
extent belongs to reloc tree or not.

This could skip data extents which aren't really modified during
relocation.

For the same real world 4G data 16 snapshots 4K nodesize metadata
balance test:
                     | v4.20-rc1 + delaye*  | w/ patch       | diff
-----------------------------------------------------------------------
relocated extents    | 22773                | 22656          | -0.1%
qgroup dirty extents | 122879               | 74316          | -39.5%
time (real)          | 23.073s              | 14.971         | -35.1%

*: v4.20-rc1 + delayed subtree scan patchset

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/delayed-ref.c | 3 ++-
 fs/btrfs/delayed-ref.h | 1 +
 fs/btrfs/extent-tree.c | 6 +++---
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 9301b3ad9217..269bd6ecb8f3 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -798,6 +798,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
  * add a delayed data ref. it's similar to btrfs_add_delayed_tree_ref.
  */
 int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
 			       u64 owner, u64 offset, u64 reserved, int action,
@@ -835,7 +836,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	}
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
-	    is_fstree(ref_root)) {
+	    is_fstree(ref_root) && is_fstree(root->root_key.objectid)) {
 		record = kmalloc(sizeof(*record), GFP_NOFS);
 		if (!record) {
 			kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 8e20c5cb5404..6c60737e55d6 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -240,6 +240,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int *old_ref_mod, int *new_ref_mod);
 int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
 			       u64 owner, u64 offset, u64 reserved, int action,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a1febf155747..0554d2cc2ea1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2046,7 +2046,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 						 BTRFS_ADD_DELAYED_REF, NULL,
 						 &old_ref_mod, &new_ref_mod);
 	} else {
-		ret = btrfs_add_delayed_data_ref(trans, bytenr,
+		ret = btrfs_add_delayed_data_ref(trans, root, bytenr,
 						 num_bytes, parent,
 						 root_objectid, owner, offset,
 						 0, BTRFS_ADD_DELAYED_REF,
@@ -7104,7 +7104,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 						 BTRFS_DROP_DELAYED_REF, NULL,
 						 &old_ref_mod, &new_ref_mod);
 	} else {
-		ret = btrfs_add_delayed_data_ref(trans, bytenr,
+		ret = btrfs_add_delayed_data_ref(trans, root, bytenr,
 						 num_bytes, parent,
 						 root_objectid, owner, offset,
 						 0, BTRFS_DROP_DELAYED_REF,
@@ -8080,7 +8080,7 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 			   root->root_key.objectid, owner, offset,
 			   BTRFS_ADD_DELAYED_EXTENT);
 
-	ret = btrfs_add_delayed_data_ref(trans, ins->objectid,
+	ret = btrfs_add_delayed_data_ref(trans, root, ins->objectid,
 					 ins->offset, 0,
 					 root->root_key.objectid, owner,
 					 offset, ram_bytes,
-- 
2.19.1

