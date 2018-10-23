Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A66CC46475
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C2E20665
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6C2E20665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbeJWR5Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:57:24 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2023 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728020AbeJWR5W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 13:57:22 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46602839"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 23 Oct 2018 17:34:43 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 69AFD4B6EDB6
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 17:34:40 +0800 (CST)
Received: from archlinux.g08.fujitsu.local (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Oct 2018 17:34:46 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>, Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH 08/13] btrfs-progs: Revert "btrfs-progs: Add repair and report function for orphan file extent."
Date:   Tue, 23 Oct 2018 17:41:42 +0800
Message-ID: <20181023094147.7906-9-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: 69AFD4B6EDB6.AC3FC
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yanjun <suyj.fnst@cn.fujitsu.com>

The reason for revert is that according to the existing situation, the
probability of problem in the extent tree is higher than in the fs tree.
So this feature should be removed.

Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
---
 check/main.c | 103 +--------------------------------------------------
 1 file changed, 1 insertion(+), 102 deletions(-)

diff --git a/check/main.c b/check/main.c
index 9c0e75c19ebc..268de5dd5f26 100644
--- a/check/main.c
+++ b/check/main.c
@@ -460,8 +460,6 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 	struct inode_backref *backref;
 	struct inode_backref *orig;
 	struct inode_backref *tmp;
-	struct orphan_data_extent *src_orphan;
-	struct orphan_data_extent *dst_orphan;
 	struct rb_node *rb;
 	size_t size;
 	int ret;
@@ -472,7 +470,6 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 	memcpy(rec, orig_rec, sizeof(*rec));
 	rec->refs = 1;
 	INIT_LIST_HEAD(&rec->backrefs);
-	INIT_LIST_HEAD(&rec->orphan_extents);
 	rec->holes = RB_ROOT;
 
 	list_for_each_entry(orig, &orig_rec->backrefs, list) {
@@ -485,15 +482,7 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 		memcpy(backref, orig, size);
 		list_add_tail(&backref->list, &rec->backrefs);
 	}
-	list_for_each_entry(src_orphan, &orig_rec->orphan_extents, list) {
-		dst_orphan = malloc(sizeof(*dst_orphan));
-		if (!dst_orphan) {
-			ret = -ENOMEM;
-			goto cleanup;
-		}
-		memcpy(dst_orphan, src_orphan, sizeof(*src_orphan));
-		list_add_tail(&dst_orphan->list, &rec->orphan_extents);
-	}
+
 	ret = copy_file_extent_holes(&rec->holes, &orig_rec->holes);
 	if (ret < 0)
 		goto cleanup_rb;
@@ -517,12 +506,6 @@ cleanup:
 			free(orig);
 		}
 
-	if (!list_empty(&rec->orphan_extents))
-		list_for_each_entry_safe(orig, tmp, &rec->orphan_extents, list) {
-			list_del(&orig->list);
-			free(orig);
-		}
-
 	free(rec);
 
 	return ERR_PTR(ret);
@@ -590,8 +573,6 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
 		fprintf(stderr, ", some csum missing");
 	if (errors & I_ERR_LINK_COUNT_WRONG)
 		fprintf(stderr, ", link count wrong");
-	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
-		fprintf(stderr, ", orphan file extent");
 	if (errors & I_ERR_ODD_INODE_FLAGS)
 		fprintf(stderr, ", odd inode flags");
 	if (errors & I_ERR_INLINE_RAM_BYTES_WRONG)
@@ -681,7 +662,6 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 		rec->extent_start = (u64)-1;
 		rec->refs = 1;
 		INIT_LIST_HEAD(&rec->backrefs);
-		INIT_LIST_HEAD(&rec->orphan_extents);
 		rec->holes = RB_ROOT;
 
 		node = malloc(sizeof(*node));
@@ -2420,9 +2400,6 @@ static int repair_inode_no_item(struct btrfs_trans_handle *trans,
 		} else if (rec->found_dir_item) {
 			type_recovered = 1;
 			filetype = BTRFS_FT_DIR;
-		} else if (!list_empty(&rec->orphan_extents)) {
-			type_recovered = 1;
-			filetype = BTRFS_FT_REG_FILE;
 		} else{
 			printf("Can't determine the filetype for inode %llu, assume it is a normal file\n",
 			       rec->ino);
@@ -2453,67 +2430,6 @@ out:
 	return ret;
 }
 
-static int repair_inode_orphan_extent(struct btrfs_trans_handle *trans,
-				      struct btrfs_root *root,
-				      struct btrfs_path *path,
-				      struct inode_record *rec)
-{
-	struct orphan_data_extent *orphan;
-	struct orphan_data_extent *tmp;
-	int ret = 0;
-
-	list_for_each_entry_safe(orphan, tmp, &rec->orphan_extents, list) {
-		/*
-		 * Check for conflicting file extents
-		 *
-		 * Here we don't know whether the extents is compressed or not,
-		 * so we can only assume it not compressed nor data offset,
-		 * and use its disk_len as extent length.
-		 */
-		ret = btrfs_get_extent(NULL, root, path, orphan->objectid,
-				       orphan->offset, orphan->disk_len, 0);
-		btrfs_release_path(path);
-		if (ret < 0)
-			goto out;
-		if (!ret) {
-			fprintf(stderr,
-				"orphan extent (%llu, %llu) conflicts, delete the orphan\n",
-				orphan->disk_bytenr, orphan->disk_len);
-			ret = btrfs_free_extent(trans,
-					root->fs_info->extent_root,
-					orphan->disk_bytenr, orphan->disk_len,
-					0, root->objectid, orphan->objectid,
-					orphan->offset);
-			if (ret < 0)
-				goto out;
-		}
-		ret = btrfs_insert_file_extent(trans, root, orphan->objectid,
-				orphan->offset, orphan->disk_bytenr,
-				orphan->disk_len, orphan->disk_len);
-		if (ret < 0)
-			goto out;
-
-		/* Update file size info */
-		rec->found_size += orphan->disk_len;
-		if (rec->found_size == rec->nbytes)
-			rec->errors &= ~I_ERR_FILE_NBYTES_WRONG;
-
-		/* Update the file extent hole info too */
-		ret = del_file_extent_hole(&rec->holes, orphan->offset,
-					   orphan->disk_len);
-		if (ret < 0)
-			goto out;
-		if (RB_EMPTY_ROOT(&rec->holes))
-			rec->errors &= ~I_ERR_FILE_EXTENT_DISCOUNT;
-
-		list_del(&orphan->list);
-		free(orphan);
-	}
-	rec->errors &= ~I_ERR_FILE_EXTENT_ORPHAN;
-out:
-	return ret;
-}
-
 static int repair_inode_discount_extent(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root,
 					struct btrfs_path *path,
@@ -2600,7 +2516,6 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 			     I_ERR_NO_ORPHAN_ITEM |
 			     I_ERR_LINK_COUNT_WRONG |
 			     I_ERR_NO_INODE_ITEM |
-			     I_ERR_FILE_EXTENT_ORPHAN |
 			     I_ERR_FILE_EXTENT_DISCOUNT |
 			     I_ERR_FILE_NBYTES_WRONG |
 			     I_ERR_INLINE_RAM_BYTES_WRONG)))
@@ -2620,8 +2535,6 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 	btrfs_init_path(&path);
 	if (rec->errors & I_ERR_NO_INODE_ITEM)
 		ret = repair_inode_no_item(trans, root, &path, rec);
-	if (!ret && rec->errors & I_ERR_FILE_EXTENT_ORPHAN)
-		ret = repair_inode_orphan_extent(trans, root, &path, rec);
 	if (!ret && rec->errors & I_ERR_FILE_EXTENT_DISCOUNT)
 		ret = repair_inode_discount_extent(trans, root, &path, rec);
 	if (!ret && rec->errors & I_ERR_DIR_ISIZE_WRONG)
@@ -3245,8 +3158,6 @@ static int check_fs_root(struct btrfs_root *root,
 	struct root_record *rec;
 	struct btrfs_root_item *root_item = &root->root_item;
 	struct cache_tree corrupt_blocks;
-	struct orphan_data_extent *orphan;
-	struct orphan_data_extent *tmp;
 	enum btrfs_tree_block_status status;
 	struct node_refs nrefs;
 
@@ -3272,18 +3183,6 @@ static int check_fs_root(struct btrfs_root *root,
 	cache_tree_init(&root_node.inode_cache);
 	memset(&nrefs, 0, sizeof(nrefs));
 
-	/* Move the orphan extent record to corresponding inode_record */
-	list_for_each_entry_safe(orphan, tmp,
-				 &root->orphan_data_extents, list) {
-		struct inode_record *inode;
-
-		inode = get_inode_rec(&root_node.inode_cache, orphan->objectid,
-				      1);
-		BUG_ON(IS_ERR(inode));
-		inode->errors |= I_ERR_FILE_EXTENT_ORPHAN;
-		list_move(&orphan->list, &inode->orphan_extents);
-	}
-
 	level = btrfs_header_level(root->node);
 	memset(wc->nodes, 0, sizeof(wc->nodes));
 	wc->nodes[level] = &root_node;
-- 
2.19.1



