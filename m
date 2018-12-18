Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175A8C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 10:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9945217D8
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 10:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbeLRKrD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Dec 2018 05:47:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:38536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726364AbeLRKrD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Dec 2018 05:47:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4712BAD82;
        Tue, 18 Dec 2018 10:47:00 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 04/13] btrfs-progs: lowmem: fix false alert if extent item has been repaired
Date:   Tue, 18 Dec 2018 18:46:37 +0800
Message-Id: <20181218104646.29599-5-wqu@suse.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20181218104646.29599-1-wqu@suse.com>
References: <20181218104646.29599-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yue <suy.fnst@cn.fujitsu.com>

Previously, @err are assigned immediately after check but before
repair.
repair_extent_item()'s return value also confuses the caller. If
error has been repaired and returns 0, check_extent_item() will try
to continue check the nonexistent and cause flase alerts.

Here make repair_extent_item()'s return codes only represents status
of the extent item, error bits are handled in caller of the repair
function.
Change of @err after repair.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
[Solve conflicts with DIR_ITEM hash mismatch patchset]
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 118 +++++++++++++++++++++++++++-----------------
 1 file changed, 72 insertions(+), 46 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 3f3f90e124d8..b7690c6dc1f1 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -3849,62 +3849,70 @@ out:
 }
 
 /*
- * Only delete backref if REFERENCER_MISSING now
+ * Only delete backref if REFERENCER_MISSING or REFERENCER_MISMATCH.
  *
- * Returns <0   the extent was deleted
- * Returns >0   the backref was deleted but extent still exists, returned value
- *               means error after repair
- * Returns  0   nothing happened
+ * Returns <0   error
+ * Returns >0   the backref was deleted but extent still exists
+ * Returns =0   the whole extent item was deleted
  */
 static int repair_extent_item(struct btrfs_root *root, struct btrfs_path *path,
 		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
-		      u64 owner, u64 offset, int err)
+		      u64 owner, u64 offset)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *extent_root = root->fs_info->extent_root;
 	struct btrfs_key old_key;
-	int freed = 0;
 	int ret;
 
 	btrfs_item_key_to_cpu(path->nodes[0], &old_key, path->slots[0]);
 
-	if ((err & (REFERENCER_MISSING | REFERENCER_MISMATCH)) == 0)
-		return err;
-
 	ret = avoid_extents_overwrite(root->fs_info);
 	if (ret)
-		return err;
+		return ret;
 
 	trans = btrfs_start_transaction(extent_root, 1);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		errno = -ret;
 		error("fail to start transaction: %m");
-		/* nothing happened */
-		ret = 0;
 		goto out;
 	}
 	/* delete the backref */
 	ret = btrfs_free_extent(trans, root->fs_info->fs_root, bytenr,
 			num_bytes, parent, root_objectid, owner, offset);
-	if (!ret) {
-		freed = 1;
-		err &= ~REFERENCER_MISSING;
+	if (!ret)
 		printf("Delete backref in extent [%llu %llu]\n",
 		       bytenr, num_bytes);
-	} else {
+	else {
 		error("fail to delete backref in extent [%llu %llu]",
 		      bytenr, num_bytes);
+		btrfs_abort_transaction(trans, ret);
+		goto out;
 	}
 	btrfs_commit_transaction(trans, extent_root);
 
-	/* btrfs_free_extent may delete the extent */
 	btrfs_release_path(path);
 	ret = btrfs_search_slot(NULL, root, &old_key, path, 0, 0);
-	if (ret)
-		ret = -ENOENT;
-	else if (freed)
-		ret = err;
+	if (ret > 0) {
+		/* odd, there must be one block group before at least */
+		if (path->slots[0] == 0) {
+			ret = -EUCLEAN;
+			goto out;
+		}
+		/*
+		 * btrfs_free_extent() has deleted the extent item,
+		 * let path point to last checked item.
+		 */
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0]))
+			path->slots[0] = btrfs_header_nritems(path->nodes[0]) - 1;
+		else
+			path->slots[0]--;
+
+		ret = 0;
+	} else if (ret == 0) {
+		ret = 1;
+	}
+
 out:
 	return ret;
 }
@@ -3922,7 +3930,6 @@ static int check_extent_item(struct btrfs_fs_info *fs_info,
 	struct btrfs_extent_inline_ref *iref;
 	struct btrfs_extent_data_ref *dref;
 	struct extent_buffer *eb = path->nodes[0];
-	unsigned long end;
 	unsigned long ptr;
 	int slot = path->slots[0];
 	int type;
@@ -3940,6 +3947,8 @@ static int check_extent_item(struct btrfs_fs_info *fs_info,
 	struct btrfs_key key;
 	int ret;
 	int err = 0;
+	int tmp_err;
+	u32 ptr_offset;
 
 	btrfs_item_key_to_cpu(eb, &key, slot);
 	if (key.type == BTRFS_EXTENT_ITEM_KEY) {
@@ -3985,21 +3994,22 @@ static int check_extent_item(struct btrfs_fs_info *fs_info,
 		/* New METADATA_ITEM */
 		level = key.offset;
 	}
-	end = (unsigned long)ei + item_size;
+	ptr_offset = ptr - (unsigned long)ei;
 
 next:
 	/* Reached extent item end normally */
-	if (ptr == end)
+	if (ptr_offset == item_size)
 		goto out;
 
 	/* Beyond extent item end, wrong item size */
-	if (ptr > end) {
+	if (ptr_offset > item_size) {
 		err |= ITEM_SIZE_MISMATCH;
 		error("extent item at bytenr %llu slot %d has wrong size",
 			eb->start, slot);
 		goto out;
 	}
 
+	ptr = (unsigned long)ei + ptr_offset;
 	parent = 0;
 	root_objectid = 0;
 	owner = 0;
@@ -4012,52 +4022,68 @@ next:
 	case BTRFS_TREE_BLOCK_REF_KEY:
 		root_objectid = offset;
 		owner = level;
-		ret = check_tree_block_backref(fs_info, offset, key.objectid,
-					       level);
-		err |= ret;
+		tmp_err = check_tree_block_backref(fs_info, offset,
+						   key.objectid, level);
 		break;
 	case BTRFS_SHARED_BLOCK_REF_KEY:
 		parent = offset;
-		ret = check_shared_block_backref(fs_info, offset, key.objectid,
-						 level);
-		err |= ret;
+		tmp_err = check_shared_block_backref(fs_info, offset,
+						     key.objectid, level);
 		break;
 	case BTRFS_EXTENT_DATA_REF_KEY:
 		dref = (struct btrfs_extent_data_ref *)(&iref->offset);
 		root_objectid = btrfs_extent_data_ref_root(eb, dref);
 		owner = btrfs_extent_data_ref_objectid(eb, dref);
 		owner_offset = btrfs_extent_data_ref_offset(eb, dref);
-		ret = check_extent_data_backref(fs_info, root_objectid, owner,
-					owner_offset, key.objectid, key.offset,
-					btrfs_extent_data_ref_count(eb, dref));
-		err |= ret;
+		tmp_err = check_extent_data_backref(fs_info, root_objectid,
+			    owner, owner_offset, key.objectid, key.offset,
+			    btrfs_extent_data_ref_count(eb, dref));
 		break;
 	case BTRFS_SHARED_DATA_REF_KEY:
 		parent = offset;
-		ret = check_shared_data_backref(fs_info, offset, key.objectid);
-		err |= ret;
+		tmp_err = check_shared_data_backref(fs_info, offset,
+						    key.objectid);
 		break;
 	default:
 		error("extent[%llu %d %llu] has unknown ref type: %d",
 			key.objectid, key.type, key.offset, type);
-		ret = UNKNOWN_TYPE;
-		err |= ret;
+		err |= UNKNOWN_TYPE;
+
 		goto out;
 	}
 
-	if (err && repair) {
+	if ((tmp_err & (REFERENCER_MISSING | REFERENCER_MISMATCH))
+	    && repair) {
 		ret = repair_extent_item(fs_info->extent_root, path,
 			 key.objectid, num_bytes, parent, root_objectid,
-			 owner, owner_offset, ret);
-		if (ret < 0)
+			 owner, owner_offset);
+		if (ret < 0) {
+			err |= tmp_err;
+			err |= FATAL_ERROR;
 			goto out;
-		if (ret) {
+		} else if (ret == 0) {
+			err = 0;
+			goto out;
+		} else if (ret > 0) {
+			/*
+			 * The error has been repaired which means the
+			 * extent item is still existed with other backrefs,
+			 * go to check next.
+			 */
+			tmp_err &= ~REFERENCER_MISSING;
+			tmp_err &= ~REFERENCER_MISMATCH;
+			err |= tmp_err;
+			eb = path->nodes[0];
+			slot = path->slots[0];
+			ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
+			item_size = btrfs_item_size_nr(eb, slot);
 			goto next;
-			err = ret;
 		}
+	} else {
+		err |= tmp_err;
 	}
 
-	ptr += btrfs_extent_inline_ref_size(type);
+	ptr_offset += btrfs_extent_inline_ref_size(type);
 	goto next;
 
 out:
-- 
2.20.0

