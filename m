Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E798C46475
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E0EE20665
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E0EE20665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbeJWR5V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:57:21 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2023 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728020AbeJWR5U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 13:57:20 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46602836"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 23 Oct 2018 17:34:43 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 81AA74B6EDBB
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 17:34:41 +0800 (CST)
Received: from archlinux.g08.fujitsu.local (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Oct 2018 17:34:47 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>, Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH 09/13] btrfs-progs: Revert "btrfs-progs: Record orphan data extent ref to corresponding root."
Date:   Tue, 23 Oct 2018 17:41:43 +0800
Message-ID: <20181023094147.7906-10-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: 81AA74B6EDBB.AD28C
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yanjun <suyj.fnst@cn.fujitsu.com>

The reason for revert is that according to the existing situation, the
probability of problem in the extent tree is higher than in the fs Tree.
So this feature should be removed.

Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
---
 check/main.c          | 120 +-----------------------------------------
 check/mode-original.h |  17 ------
 ctree.h               |  10 ----
 disk-io.c             |   1 -
 4 files changed, 1 insertion(+), 147 deletions(-)

diff --git a/check/main.c b/check/main.c
index 268de5dd5f26..bd1f322e0f12 100644
--- a/check/main.c
+++ b/check/main.c
@@ -511,22 +511,6 @@ cleanup:
 	return ERR_PTR(ret);
 }
 
-static void print_orphan_data_extents(struct list_head *orphan_extents,
-				      u64 objectid)
-{
-	struct orphan_data_extent *orphan;
-
-	if (list_empty(orphan_extents))
-		return;
-	printf("The following data extent is lost in tree %llu:\n",
-	       objectid);
-	list_for_each_entry(orphan, orphan_extents, list) {
-		printf("\tinode: %llu, offset:%llu, disk_bytenr: %llu, disk_len: %llu\n",
-		       orphan->objectid, orphan->offset, orphan->disk_bytenr,
-		       orphan->disk_len);
-	}
-}
-
 static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
 {
 	u64 root_objectid = root->root_key.objectid;
@@ -578,9 +562,6 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
 	if (errors & I_ERR_INLINE_RAM_BYTES_WRONG)
 		fprintf(stderr, ", invalid inline ram bytes");
 	fprintf(stderr, "\n");
-	/* Print the orphan extents if needed */
-	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
-		print_orphan_data_extents(&rec->orphan_extents, root->objectid);
 
 	/* Print the holes if needed */
 	if (errors & I_ERR_FILE_EXTENT_DISCOUNT) {
@@ -683,18 +664,6 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 	return rec;
 }
 
-static void free_orphan_data_extents(struct list_head *orphan_extents)
-{
-	struct orphan_data_extent *orphan;
-
-	while (!list_empty(orphan_extents)) {
-		orphan = list_entry(orphan_extents->next,
-				    struct orphan_data_extent, list);
-		list_del(&orphan->list);
-		free(orphan);
-	}
-}
-
 static void free_inode_rec(struct inode_record *rec)
 {
 	struct inode_backref *backref;
@@ -707,7 +676,6 @@ static void free_inode_rec(struct inode_record *rec)
 		list_del(&backref->list);
 		free(backref);
 	}
-	free_orphan_data_extents(&rec->orphan_extents);
 	free_file_extent_holes(&rec->holes);
 	free(rec);
 }
@@ -3286,7 +3254,6 @@ skip_walking:
 
 	free_corrupt_blocks_tree(&corrupt_blocks);
 	root->fs_info->corrupt_blocks = NULL;
-	free_orphan_data_extents(&root->orphan_data_extents);
 	return ret;
 }
 
@@ -7137,88 +7104,6 @@ static int find_possible_backrefs(struct btrfs_fs_info *info,
 	return 0;
 }
 
-/*
- * Record orphan data ref into corresponding root.
- *
- * Return 0 if the extent item contains data ref and recorded.
- * Return 1 if the extent item contains no useful data ref
- *   On that case, it may contains only shared_dataref or metadata backref
- *   or the file extent exists(this should be handled by the extent bytenr
- *   recovery routine)
- * Return <0 if something goes wrong.
- */
-static int record_orphan_data_extents(struct btrfs_fs_info *fs_info,
-				      struct extent_record *rec)
-{
-	struct btrfs_key key;
-	struct btrfs_root *dest_root;
-	struct extent_backref *back, *tmp;
-	struct data_backref *dback;
-	struct orphan_data_extent *orphan;
-	struct btrfs_path path;
-	int recorded_data_ref = 0;
-	int ret = 0;
-
-	if (rec->metadata)
-		return 1;
-	btrfs_init_path(&path);
-	rbtree_postorder_for_each_entry_safe(back, tmp,
-					     &rec->backref_tree, node) {
-		if (back->full_backref || !back->is_data ||
-		    !back->found_extent_tree)
-			continue;
-		dback = to_data_backref(back);
-		if (dback->found_ref)
-			continue;
-		key.objectid = dback->root;
-		key.type = BTRFS_ROOT_ITEM_KEY;
-		key.offset = (u64)-1;
-
-		dest_root = btrfs_read_fs_root(fs_info, &key);
-
-		/* For non-exist root we just skip it */
-		if (IS_ERR(dest_root) || !dest_root)
-			continue;
-
-		key.objectid = dback->owner;
-		key.type = BTRFS_EXTENT_DATA_KEY;
-		key.offset = dback->offset;
-
-		ret = btrfs_search_slot(NULL, dest_root, &key, &path, 0, 0);
-		btrfs_release_path(&path);
-		/*
-		 * For ret < 0, it's OK since the fs-tree may be corrupted,
-		 * we need to record it for inode/file extent rebuild.
-		 * For ret > 0, we record it only for file extent rebuild.
-		 * For ret == 0, the file extent exists but only bytenr
-		 * mismatch, let the original bytenr fix routine to handle,
-		 * don't record it.
-		 */
-		if (ret == 0)
-			continue;
-		ret = 0;
-		orphan = malloc(sizeof(*orphan));
-		if (!orphan) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		INIT_LIST_HEAD(&orphan->list);
-		orphan->root = dback->root;
-		orphan->objectid = dback->owner;
-		orphan->offset = dback->offset;
-		orphan->disk_bytenr = rec->cache.start;
-		orphan->disk_len = rec->cache.size;
-		list_add(&dest_root->orphan_data_extents, &orphan->list);
-		recorded_data_ref = 1;
-	}
-out:
-	btrfs_release_path(&path);
-	if (!ret)
-		return !recorded_data_ref;
-	else
-		return ret;
-}
-
 /*
  * when an incorrect extent item is found, this will delete
  * all of the existing entries for it and recreate them
@@ -7560,10 +7445,7 @@ static int check_extent_refs(struct btrfs_root *root,
 			fprintf(stderr, "extent item %llu, found %llu\n",
 				(unsigned long long)rec->extent_item_refs,
 				(unsigned long long)rec->refs);
-			ret = record_orphan_data_extents(root->fs_info, rec);
-			if (ret < 0)
-				goto repair_abort;
-			fix = ret;
+			fix = 1;
 			cur_err = 1;
 		}
 		if (all_backpointers_checked(rec, 1)) {
diff --git a/check/mode-original.h b/check/mode-original.h
index ec2842e0b3be..ed995931fcd5 100644
--- a/check/mode-original.h
+++ b/check/mode-original.h
@@ -57,21 +57,6 @@ static inline struct data_backref* to_data_backref(struct extent_backref *back)
 	return container_of(back, struct data_backref, node);
 }
 
-/*
- * Much like data_backref, just removed the undetermined members
- * and change it to use list_head.
- * During extent scan, it is stored in root->orphan_data_extent.
- * During fs tree scan, it is then moved to inode_rec->orphan_data_extents.
- */
-struct orphan_data_extent {
-	struct list_head list;
-	u64 root;
-	u64 objectid;
-	u64 offset;
-	u64 disk_bytenr;
-	u64 disk_len;
-};
-
 struct tree_backref {
 	struct extent_backref node;
 	union {
@@ -184,7 +169,6 @@ struct file_extent_hole {
 #define I_ERR_ODD_CSUM_ITEM		(1 << 11)
 #define I_ERR_SOME_CSUM_MISSING		(1 << 12)
 #define I_ERR_LINK_COUNT_WRONG		(1 << 13)
-#define I_ERR_FILE_EXTENT_ORPHAN	(1 << 14)
 #define I_ERR_FILE_EXTENT_TOO_LARGE	(1 << 15)
 #define I_ERR_ODD_INODE_FLAGS		(1 << 16)
 #define I_ERR_INLINE_RAM_BYTES_WRONG	(1 << 17)
@@ -212,7 +196,6 @@ struct inode_record {
 	u64 extent_start;
 	u64 extent_end;
 	struct rb_root holes;
-	struct list_head orphan_extents;
 
 	u32 refs;
 };
diff --git a/ctree.h b/ctree.h
index 2a2437070ef9..2e0896390434 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1177,16 +1177,6 @@ struct btrfs_root {
 	u32 type;
 	u64 last_inode_alloc;
 
-	/*
-	 * Record orphan data extent ref
-	 *
-	 * TODO: Don't restore things in btrfs_root.
-	 * Directly record it into inode_record, which needs a lot of
-	 * infrastructure change to allow cooperation between extent
-	 * and fs tree scan.
-	 */
-	struct list_head orphan_data_extents;
-
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;
 	struct rb_node rb_node;
diff --git a/disk-io.c b/disk-io.c
index 4bc2e77d438a..992f4b870e9f 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -480,7 +480,6 @@ void btrfs_setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	root->last_inode_alloc = 0;
 
 	INIT_LIST_HEAD(&root->dirty_list);
-	INIT_LIST_HEAD(&root->orphan_data_extents);
 	memset(&root->root_key, 0, sizeof(root->root_key));
 	memset(&root->root_item, 0, sizeof(root->root_item));
 	root->root_key.objectid = objectid;
-- 
2.19.1



