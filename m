Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB9F5C7112C
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3FA7207DD
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3FA7207DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbeJWR5Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:57:16 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:5988 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728446AbeJWR5Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 13:57:16 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46602823"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 23 Oct 2018 17:34:36 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 7F3F54B710F1
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 17:34:36 +0800 (CST)
Received: from archlinux.g08.fujitsu.local (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Oct 2018 17:34:42 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 03/13] btrfs-progs: lowmem: fix false alert if extent item has been repaired
Date:   Tue, 23 Oct 2018 17:41:37 +0800
Message-ID: <20181023094147.7906-4-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: 7F3F54B710F1.AA621
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Previously, @err are assigned immediately after check but before
repair.
repair_extent_item()'s return value also confuses the caller. If
error has been repaired and returns 0, check_extent_item() will try
to continue check the nonexistent and cause flase alerts.

Here make repair_extent_item()'s return codes only represents status
of the extent item, error bits are passed by pointer.
Move the change of @err after repair.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 106 ++++++++++++++++++++++++++++----------------
 1 file changed, 68 insertions(+), 38 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 76e7be81ceb1..769b3141de8b 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -3788,35 +3788,35 @@ out:
 /*
  * Only delete backref if REFERENCER_MISSING now
  *
- * Returns <0   the extent was deleted
- * Returns >0   the backref was deleted but extent still exists, returned value
- *               means error after repair
+ * Returns <0   the whole extent item was deleted
+ * Returns >0   the backref was deleted but extent still exists, @err_ret
+ *		will be set to be error bits after repair.
  * Returns  0   nothing happened
  */
 static int repair_extent_item(struct btrfs_root *root, struct btrfs_path *path,
 		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
-		      u64 owner, u64 offset, int err)
+		      u64 owner, u64 offset, int *err_ret)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *extent_root = root->fs_info->extent_root;
 	struct btrfs_key old_key;
-	int freed = 0;
 	int ret;
+	int err = *err_ret;
 
 	btrfs_item_key_to_cpu(path->nodes[0], &old_key, path->slots[0]);
 
 	if ((err & (REFERENCER_MISSING | REFERENCER_MISMATCH)) == 0)
-		return err;
+		return 0;
 
 	ret = avoid_extents_overwrite(root->fs_info);
 	if (ret)
-		return err;
+		return 0;
 
 	trans = btrfs_start_transaction(extent_root, 1);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		error("fail to start transaction %s", strerror(-ret));
-		/* nothing happened */
+		err |= FATAL_ERROR;
 		ret = 0;
 		goto out;
 	}
@@ -3824,24 +3824,44 @@ static int repair_extent_item(struct btrfs_root *root, struct btrfs_path *path,
 	ret = btrfs_free_extent(trans, root->fs_info->fs_root, bytenr,
 			num_bytes, parent, root_objectid, owner, offset);
 	if (!ret) {
-		freed = 1;
-		err &= ~REFERENCER_MISSING;
+		err &= ~(REFERENCER_MISSING | REFERENCER_MISMATCH);
 		printf("Delete backref in extent [%llu %llu]\n",
 		       bytenr, num_bytes);
 	} else {
 		error("fail to delete backref in extent [%llu %llu]",
 		      bytenr, num_bytes);
+		if (ret < 0)
+			err |= FATAL_ERROR;
 	}
 	btrfs_commit_transaction(trans, extent_root);
 
-	/* btrfs_free_extent may delete the extent */
 	btrfs_release_path(path);
 	ret = btrfs_search_slot(NULL, root, &old_key, path, 0, 0);
-	if (ret)
+	if (ret > 0) {
+		/* odd, there must be one block group before at least*/
+		if (path->slots[0] == 0) {
+			ret = -EUCLEAN;
+			err |= FATAL_ERROR;
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
 		ret = -ENOENT;
-	else if (freed)
-		ret = err;
+		err = 0;
+	} else if (ret < 0) {
+		err |= FATAL_ERROR;
+	} else {
+		ret = 1;
+	}
 out:
+	*err_ret = err;
 	return ret;
 }
 
@@ -3858,7 +3878,6 @@ static int check_extent_item(struct btrfs_fs_info *fs_info,
 	struct btrfs_extent_inline_ref *iref;
 	struct btrfs_extent_data_ref *dref;
 	struct extent_buffer *eb = path->nodes[0];
-	unsigned long end;
 	unsigned long ptr;
 	int slot = path->slots[0];
 	int type;
@@ -3876,6 +3895,8 @@ static int check_extent_item(struct btrfs_fs_info *fs_info,
 	struct btrfs_key key;
 	int ret;
 	int err = 0;
+	int tmp_err;
+	u32 ptr_offset;
 
 	btrfs_item_key_to_cpu(eb, &key, slot);
 	if (key.type == BTRFS_EXTENT_ITEM_KEY) {
@@ -3921,21 +3942,22 @@ static int check_extent_item(struct btrfs_fs_info *fs_info,
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
@@ -3948,52 +3970,60 @@ next:
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
+	if (tmp_err && repair) {
 		ret = repair_extent_item(fs_info->extent_root, path,
 			 key.objectid, num_bytes, parent, root_objectid,
-			 owner, owner_offset, ret);
-		if (ret < 0)
+			 owner, owner_offset, &tmp_err);
+		err |= tmp_err;
+
+		if (tmp_err & FATAL_ERROR || ret < 0)
 			goto out;
-		if (ret) {
+		/*
+		 * the error has been repaired which means the extent item
+		 * is still existed with other backrefs, go to check next.
+		 */
+		if (ret > 0) {
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
2.19.1



