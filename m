Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82935C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 10:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F7E5217D8
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 10:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbeLRKrP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Dec 2018 05:47:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:38632 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726450AbeLRKrP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Dec 2018 05:47:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 31D33AE72;
        Tue, 18 Dec 2018 10:47:10 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH 08/13] btrfs-progs: Revert "btrfs-progs: Add repair and report function for orphan file extent."
Date:   Tue, 18 Dec 2018 18:46:41 +0800
Message-Id: <20181218104646.29599-9-wqu@suse.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20181218104646.29599-1-wqu@suse.com>
References: <20181218104646.29599-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yanjun <suyj.fnst@cn.fujitsu.com>

Commit ad03f840f0d2 ("btrfs-progs: Add repair and report function for
orphan file extent.") will record and try to repair orphan file extents
by:
- Removing the orphan file extent item if no extent backref can be found
Or
- Re-insert a file extent using data backref

Especially the later case is far from ideal, as normally extent tree is
more fragile and corruption prone.
Use any data from extent tree to try to repair could easily lead to
further corruption.

So here we revert commit ad03f840f0d2 ("btrfs-progs: Add repair and report
function for orphan file extent.") to cleanup the space for later proper
repair in original mode.

Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
[Update commit message, solve conflicts with DIR_ITEM hash mismatch patchset]
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 101 ---------------------------------------------------
 1 file changed, 101 deletions(-)

diff --git a/check/main.c b/check/main.c
index eb6a4a50db98..dd475ac87d93 100644
--- a/check/main.c
+++ b/check/main.c
@@ -460,8 +460,6 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 	struct inode_backref *backref;
 	struct inode_backref *orig;
 	struct inode_backref *tmp;
-	struct orphan_data_extent *src_orphan;
-	struct orphan_data_extent *dst_orphan;
 	struct mismatch_dir_hash_record *hash_record;
 	struct mismatch_dir_hash_record *new_record;
 	struct rb_node *rb;
@@ -474,7 +472,6 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 	memcpy(rec, orig_rec, sizeof(*rec));
 	rec->refs = 1;
 	INIT_LIST_HEAD(&rec->backrefs);
-	INIT_LIST_HEAD(&rec->orphan_extents);
 	INIT_LIST_HEAD(&rec->mismatch_dir_hash);
 	rec->holes = RB_ROOT;
 
@@ -488,15 +485,6 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
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
 	list_for_each_entry(hash_record, &orig_rec->mismatch_dir_hash, list) {
 		size = sizeof(*hash_record) + hash_record->namelen;
 		new_record = malloc(size);
@@ -530,11 +518,6 @@ cleanup:
 			free(orig);
 		}
 
-	if (!list_empty(&rec->orphan_extents))
-		list_for_each_entry_safe(orig, tmp, &rec->orphan_extents, list) {
-			list_del(&orig->list);
-			free(orig);
-		}
 	if (!list_empty(&rec->mismatch_dir_hash)) {
 		list_for_each_entry_safe(hash_record, new_record,
 				&rec->mismatch_dir_hash, list) {
@@ -610,8 +593,6 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
 		fprintf(stderr, ", some csum missing");
 	if (errors & I_ERR_LINK_COUNT_WRONG)
 		fprintf(stderr, ", link count wrong");
-	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
-		fprintf(stderr, ", orphan file extent");
 	if (errors & I_ERR_ODD_INODE_FLAGS)
 		fprintf(stderr, ", odd inode flags");
 	if (errors & I_ERR_INLINE_RAM_BYTES_WRONG)
@@ -720,7 +701,6 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 		rec->extent_start = (u64)-1;
 		rec->refs = 1;
 		INIT_LIST_HEAD(&rec->backrefs);
-		INIT_LIST_HEAD(&rec->orphan_extents);
 		INIT_LIST_HEAD(&rec->mismatch_dir_hash);
 		rec->holes = RB_ROOT;
 
@@ -2488,9 +2468,6 @@ static int repair_inode_no_item(struct btrfs_trans_handle *trans,
 		} else if (rec->found_dir_item) {
 			type_recovered = 1;
 			filetype = BTRFS_FT_DIR;
-		} else if (!list_empty(&rec->orphan_extents)) {
-			type_recovered = 1;
-			filetype = BTRFS_FT_REG_FILE;
 		} else{
 			printf("Can't determine the filetype for inode %llu, assume it is a normal file\n",
 			       rec->ino);
@@ -2521,67 +2498,6 @@ out:
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
@@ -2703,7 +2619,6 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 			     I_ERR_NO_ORPHAN_ITEM |
 			     I_ERR_LINK_COUNT_WRONG |
 			     I_ERR_NO_INODE_ITEM |
-			     I_ERR_FILE_EXTENT_ORPHAN |
 			     I_ERR_FILE_EXTENT_DISCOUNT |
 			     I_ERR_FILE_NBYTES_WRONG |
 			     I_ERR_INLINE_RAM_BYTES_WRONG |
@@ -2726,8 +2641,6 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 		ret = repair_mismatch_dir_hash(trans, root, rec);
 	if (rec->errors & I_ERR_NO_INODE_ITEM)
 		ret = repair_inode_no_item(trans, root, &path, rec);
-	if (!ret && rec->errors & I_ERR_FILE_EXTENT_ORPHAN)
-		ret = repair_inode_orphan_extent(trans, root, &path, rec);
 	if (!ret && rec->errors & I_ERR_FILE_EXTENT_DISCOUNT)
 		ret = repair_inode_discount_extent(trans, root, &path, rec);
 	if (!ret && rec->errors & I_ERR_DIR_ISIZE_WRONG)
@@ -3356,8 +3269,6 @@ static int check_fs_root(struct btrfs_root *root,
 	struct root_record *rec;
 	struct btrfs_root_item *root_item = &root->root_item;
 	struct cache_tree corrupt_blocks;
-	struct orphan_data_extent *orphan;
-	struct orphan_data_extent *tmp;
 	enum btrfs_tree_block_status status;
 	struct node_refs nrefs;
 
@@ -3383,18 +3294,6 @@ static int check_fs_root(struct btrfs_root *root,
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
2.20.0

