Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DEBC65BAF
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B815F2084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:32:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B815F2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbeLLHcF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 02:32:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:39732 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbeLLHcF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 02:32:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 92111ADDD
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 07:32:02 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 8/8] btrfs: extent-tree: Use btrfs_ref to refactor btrfs_free_extent()
Date:   Wed, 12 Dec 2018 15:31:02 +0800
Message-Id: <20181212073102.7736-9-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181212073102.7736-1-wqu@suse.com>
References: <20181212073102.7736-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Similar to btrfs_inc_extent_ref(), just use btrfs_ref to replace the
long parameter list and the confusing @owner parameter.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h       |  5 +---
 fs/btrfs/extent-tree.c | 52 +++++++++++++++++++-----------------------
 fs/btrfs/file.c        | 22 ++++++++++--------
 fs/btrfs/inode.c       | 13 +++++++----
 fs/btrfs/relocation.c  | 25 ++++++++++++--------
 5 files changed, 61 insertions(+), 56 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6b31f8af9852..9ed55a29993d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2671,10 +2671,7 @@ int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info,
 				u64 bytenr, u64 num_bytes, u64 flags,
 				int level, int is_data);
-int btrfs_free_extent(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root,
-		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
-		      u64 owner, u64 offset);
+int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_ref *ref);
 
 int btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info,
 			       u64 start, u64 len, int delalloc);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7dbfa4159e2b..26afed91bfb2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3255,9 +3255,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			if (inc)
 				ret = btrfs_inc_extent_ref(trans, &generic_ref);
 			else
-				ret = btrfs_free_extent(trans, root, bytenr,
-						num_bytes, parent, ref_root,
-						key.objectid, key.offset);
+				ret = btrfs_free_extent(trans, &generic_ref);
 			if (ret)
 				goto fail;
 		} else {
@@ -3271,9 +3269,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			if (inc)
 				ret = btrfs_inc_extent_ref(trans, &generic_ref);
 			else
-				ret = btrfs_free_extent(trans, root, bytenr,
-						num_bytes, parent, ref_root,
-						level - 1, 0);
+				ret = btrfs_free_extent(trans, &generic_ref);
 			if (ret)
 				goto fail;
 		}
@@ -7071,47 +7067,43 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 }
 
 /* Can return -ENOMEM */
-int btrfs_free_extent(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root,
-		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
-		      u64 owner, u64 offset)
+int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_ref *ref)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_ref generic_ref = { 0 };
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int old_ref_mod, new_ref_mod;
 	int ret;
 
 	if (btrfs_is_testing(fs_info))
 		return 0;
 
-	btrfs_init_generic_ref(&generic_ref, BTRFS_DROP_DELAYED_REF, bytenr,
-			       num_bytes, parent);
-	generic_ref.real_root = root->root_key.objectid;
 	/*
 	 * tree log blocks never actually go into the extent allocation
 	 * tree, just update pinning info and exit early.
 	 */
-	if (root_objectid == BTRFS_TREE_LOG_OBJECTID) {
-		WARN_ON(owner >= BTRFS_FIRST_FREE_OBJECTID);
+	if ((ref->type == BTRFS_REF_METADATA &&
+	     ref->tree_ref.root == BTRFS_TREE_LOG_OBJECTID) ||
+	    (ref->type == BTRFS_REF_DATA &&
+	     ref->data_ref.ref_root == BTRFS_TREE_LOG_OBJECTID)) {
 		/* unlocks the pinned mutex */
-		btrfs_pin_extent(fs_info, bytenr, num_bytes, 1);
+		btrfs_pin_extent(fs_info, ref->bytenr, ref->len, 1);
 		old_ref_mod = new_ref_mod = 0;
 		ret = 0;
-	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		btrfs_init_tree_ref(&generic_ref, (int)owner, root_objectid);
-		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL,
+	} else if (ref->type == BTRFS_REF_METADATA) {
+		ret = btrfs_add_delayed_tree_ref(trans, ref, NULL,
 						 &old_ref_mod, &new_ref_mod);
 	} else {
-		btrfs_init_data_ref(&generic_ref, root_objectid, owner, offset);
-		ret = btrfs_add_delayed_data_ref(trans, &generic_ref, 0,
+		ret = btrfs_add_delayed_data_ref(trans, ref, 0,
 						 &old_ref_mod, &new_ref_mod);
 	}
 
-	if (root_objectid != BTRFS_TREE_LOG_OBJECTID)
-		btrfs_ref_tree_mod(fs_info, &generic_ref);
+	if (!((ref->type == BTRFS_REF_METADATA &&
+	       ref->tree_ref.root == BTRFS_TREE_LOG_OBJECTID) ||
+	      (ref->type == BTRFS_REF_DATA &&
+	       ref->data_ref.ref_root == BTRFS_TREE_LOG_OBJECTID)))
+		btrfs_ref_tree_mod(fs_info, ref);
 
 	if (ret == 0 && old_ref_mod >= 0 && new_ref_mod < 0)
-		add_pinned_bytes(fs_info, &generic_ref);
+		add_pinned_bytes(fs_info, ref);
 
 	return ret;
 }
@@ -8541,6 +8533,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	u32 blocksize;
 	struct btrfs_key key;
 	struct btrfs_key first_key;
+	struct btrfs_ref ref = { 0 };
 	struct extent_buffer *next;
 	int level = wc->level;
 	int reada = 0;
@@ -8687,9 +8680,10 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 					     ret);
 			}
 		}
-		ret = btrfs_free_extent(trans, root, bytenr, blocksize,
-					parent, root->root_key.objectid,
-					level - 1, 0);
+		btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, bytenr,
+				       blocksize, parent);
+		btrfs_init_tree_ref(&ref, level - 1, root->root_key.objectid);
+		ret = btrfs_free_extent(trans, &ref);
 		if (ret)
 			goto out_unlock;
 	}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index bacd6a9005f8..53b66f4ca833 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -997,11 +997,14 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 				extent_end = ALIGN(extent_end,
 						   fs_info->sectorsize);
 			} else if (update_refs && disk_bytenr > 0) {
-				ret = btrfs_free_extent(trans, root,
-						disk_bytenr, num_bytes, 0,
+				btrfs_init_generic_ref(&ref,
+						BTRFS_DROP_DELAYED_REF,
+						disk_bytenr, num_bytes, 0);
+				btrfs_init_data_ref(&ref,
 						root->root_key.objectid,
-						key.objectid, key.offset -
-						extent_offset);
+						key.objectid,
+						key.offset - extent_offset);
+				ret = btrfs_free_extent(trans, &ref);
 				BUG_ON(ret); /* -ENOMEM */
 				inode_sub_bytes(inode,
 						extent_end - key.offset);
@@ -1318,6 +1321,9 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 
 	other_start = end;
 	other_end = 0;
+	btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, bytenr,
+			       num_bytes, 0);
+	btrfs_init_data_ref(&ref, root->root_key.objectid, ino, orig_offset);
 	if (extent_mergeable(leaf, path->slots[0] + 1,
 			     ino, bytenr, orig_offset,
 			     &other_start, &other_end)) {
@@ -1328,9 +1334,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		extent_end = other_end;
 		del_slot = path->slots[0] + 1;
 		del_nr++;
-		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
-					0, root->root_key.objectid,
-					ino, orig_offset);
+		ret = btrfs_free_extent(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
@@ -1348,9 +1352,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		key.offset = other_start;
 		del_slot = path->slots[0];
 		del_nr++;
-		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
-					0, root->root_key.objectid,
-					ino, orig_offset);
+		ret = btrfs_free_extent(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 31ff1f8854c5..3607eabe7316 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4714,12 +4714,17 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 		if (found_extent &&
 		    (test_bit(BTRFS_ROOT_REF_COWS, &root->state) ||
 		     root == fs_info->tree_root)) {
+			struct btrfs_ref ref = { 0 };
+
 			btrfs_set_path_blocking(path);
 			bytes_deleted += extent_num_bytes;
-			ret = btrfs_free_extent(trans, root, extent_start,
-						extent_num_bytes, 0,
-						btrfs_header_owner(leaf),
-						ino, extent_offset);
+
+			btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF,
+					extent_start, extent_num_bytes, 0);
+			ref.real_root = root->root_key.objectid;
+			btrfs_init_data_ref(&ref, btrfs_header_owner(leaf),
+					ino, extent_offset);
+			ret = btrfs_free_extent(trans, &ref);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
 				break;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8499d9added3..1836d003b188 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1731,9 +1731,12 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 			break;
 		}
 
-		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
-					parent, btrfs_header_owner(leaf),
-					key.objectid, key.offset);
+		btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, bytenr,
+				       num_bytes, parent);
+		ref.real_root = root->root_key.objectid;
+		btrfs_init_data_ref(&ref, btrfs_header_owner(leaf),
+				    key.objectid, key.offset);
+		ret = btrfs_free_extent(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			break;
@@ -1947,14 +1950,18 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 		ret = btrfs_inc_extent_ref(trans, &ref);
 		BUG_ON(ret);
 
-		ret = btrfs_free_extent(trans, src, new_bytenr, blocksize,
-					path->nodes[level]->start,
-					src->root_key.objectid, level - 1, 0);
+		btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, new_bytenr,
+				       blocksize, path->nodes[level]->start);
+		btrfs_init_tree_ref(&ref, level - 1, src->root_key.objectid);
+		ref.skip_qgroup = true;
+		ret = btrfs_free_extent(trans, &ref);
 		BUG_ON(ret);
 
-		ret = btrfs_free_extent(trans, dest, old_bytenr, blocksize,
-					0, dest->root_key.objectid, level - 1,
-					0);
+		btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, old_bytenr,
+				       blocksize, 0);
+		btrfs_init_tree_ref(&ref, level - 1, dest->root_key.objectid);
+		ref.skip_qgroup = true;
+		ret = btrfs_free_extent(trans, &ref);
 		BUG_ON(ret);
 
 		btrfs_unlock_up_safe(path, 0);
-- 
2.19.2

