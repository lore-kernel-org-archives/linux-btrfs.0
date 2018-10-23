Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94ECEC7112C
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6406620665
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6406620665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbeJWR5X (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:57:23 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:4300 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728607AbeJWR5X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 13:57:23 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46602835"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 23 Oct 2018 17:34:43 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 9D9D14B710E7
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 17:34:42 +0800 (CST)
Received: from archlinux.g08.fujitsu.local (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Oct 2018 17:34:48 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>, Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH 11/13] btrfs-progs: check: Delete file extent item with unaligned extent backref
Date:   Tue, 23 Oct 2018 17:41:45 +0800
Message-ID: <20181023094147.7906-12-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: 9D9D14B710E7.AB71C
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yanjun <suyj.fnst@cn.fujitsu.com>

In original mode, if some file extent item has unaligned extent backref,
fixup_extent_refs can't repair it. This patch will check extent alignment
then delete file extent with unaligned extent backref.

Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
---
 check/main.c          | 278 +++++++++++++++++++++++++++++++++++++++++-
 check/mode-original.h |  13 ++
 ctree.h               |   2 +
 disk-io.c             |   1 +
 4 files changed, 293 insertions(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index 90d9fd570287..b5e68b3241e5 100644
--- a/check/main.c
+++ b/check/main.c
@@ -460,6 +460,8 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 	struct inode_backref *backref;
 	struct inode_backref *orig;
 	struct inode_backref *tmp;
+	struct unaligned_extent_rec_t *src;
+	struct unaligned_extent_rec_t *dst;
 	struct rb_node *rb;
 	size_t size;
 	int ret;
@@ -470,6 +472,7 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 	memcpy(rec, orig_rec, sizeof(*rec));
 	rec->refs = 1;
 	INIT_LIST_HEAD(&rec->backrefs);
+	INIT_LIST_HEAD(&rec->unaligned_extent_recs);
 	rec->holes = RB_ROOT;
 
 	list_for_each_entry(orig, &orig_rec->backrefs, list) {
@@ -483,6 +486,17 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 		list_add_tail(&backref->list, &rec->backrefs);
 	}
 
+	list_for_each_entry(src, &orig_rec->unaligned_extent_recs, list) {
+		size = sizeof(*src);
+		dst = malloc(size);
+		if (!dst) {
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+		memcpy(dst, src, size);
+		list_add_tail(&dst->list, &rec->unaligned_extent_recs);
+	}
+
 	ret = copy_file_extent_holes(&rec->holes, &orig_rec->holes);
 	if (ret < 0)
 		goto cleanup_rb;
@@ -506,6 +520,13 @@ cleanup:
 			free(orig);
 		}
 
+	if (!list_empty(&rec->unaligned_extent_recs))
+		list_for_each_entry_safe(src, dst, &rec->unaligned_extent_recs,
+				list) {
+			list_del(&src->list);
+			free(src);
+		}
+
 	free(rec);
 
 	return ERR_PTR(ret);
@@ -643,6 +664,7 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 		rec->extent_start = (u64)-1;
 		rec->refs = 1;
 		INIT_LIST_HEAD(&rec->backrefs);
+		INIT_LIST_HEAD(&rec->unaligned_extent_recs);
 		rec->holes = RB_ROOT;
 
 		node = malloc(sizeof(*node));
@@ -664,6 +686,18 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 	return rec;
 }
 
+static void free_unaligned_extent_recs(struct list_head *unaligned_extent_recs)
+{
+	struct unaligned_extent_rec_t *urec;
+
+	while (!list_empty(unaligned_extent_recs)) {
+		urec = list_entry(unaligned_extent_recs->next,
+				struct unaligned_extent_rec_t, list);
+		list_del(&urec->list);
+		free(urec);
+	}
+}
+
 static void free_inode_rec(struct inode_record *rec)
 {
 	struct inode_backref *backref;
@@ -676,6 +710,7 @@ static void free_inode_rec(struct inode_record *rec)
 		list_del(&backref->list);
 		free(backref);
 	}
+	free_unaligned_extent_recs(&rec->unaligned_extent_recs);
 	free_file_extent_holes(&rec->holes);
 	free(rec);
 }
@@ -2474,18 +2509,154 @@ out:
 	return ret;
 }
 
+static int btrfs_delete_item(struct btrfs_trans_handle *trans,
+		struct btrfs_root *root, struct btrfs_key *key)
+{
+	struct btrfs_path path;
+	int ret = 0;
+
+	btrfs_init_path(&path);
+
+	ret = btrfs_search_slot(trans, root, key, &path, -1, 1);
+	if (ret) {
+		if (ret > 0)
+			ret = -ENOENT;
+
+		btrfs_release_path(&path);
+		return ret;
+	}
+
+	ret = btrfs_del_item(trans, root, &path);
+
+	btrfs_release_path(&path);
+	return ret;
+}
+
+static int find_file_extent_offset_by_bytenr(struct btrfs_root *root,
+		u64 owner, u64 bytenr, u64 *offset_ret)
+{
+	int ret = 0;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_file_extent_item *fi;
+	struct extent_buffer *leaf;
+	u64 disk_bytenr;
+	int slot;
+
+	btrfs_init_path(&path);
+
+	key.objectid = owner;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret) {
+		if (ret > 0)
+			ret = -ENOENT;
+		btrfs_release_path(&path);
+		return ret;
+	}
+
+	btrfs_release_path(&path);
+
+	key.objectid = owner;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret < 0) {
+		btrfs_release_path(&path);
+		return ret;
+	}
+
+	while (1) {
+		leaf = path.nodes[0];
+		slot = path.slots[0];
+
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, &path);
+			if (ret) {
+				if (ret > 0)
+					ret = 0;
+				break;
+			}
+
+			leaf = path.nodes[0];
+			slot = path.slots[0];
+		}
+
+		btrfs_item_key_to_cpu(leaf, &found_key, slot);
+		if ((found_key.objectid != owner) ||
+			(found_key.type != BTRFS_EXTENT_DATA_KEY))
+			break;
+
+		fi = btrfs_item_ptr(leaf, slot,
+				struct btrfs_file_extent_item);
+
+		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+		if (disk_bytenr == bytenr) {
+			*offset_ret = found_key.offset;
+			ret = 0;
+			break;
+		}
+		path.slots[0]++;
+	}
+
+	btrfs_release_path(&path);
+	return ret;
+}
+
+static int repair_unaligned_extent_recs(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_path *path,
+				struct inode_record *rec)
+{
+	int ret = 0;
+	struct btrfs_key key;
+	struct unaligned_extent_rec_t *urec;
+	struct unaligned_extent_rec_t *tmp;
+
+	list_for_each_entry_safe(urec, tmp, &rec->unaligned_extent_recs, list) {
+
+		key.objectid = urec->owner;
+		key.type = BTRFS_EXTENT_DATA_KEY;
+		key.offset = urec->offset;
+		fprintf(stderr, "delete file extent item [%llu,%llu]\n",
+					urec->owner, urec->offset);
+		ret = btrfs_delete_item(trans, root, &key);
+		if (ret)
+			return ret;
+
+		list_del(&urec->list);
+		free(urec);
+	}
+	rec->errors &= ~I_ERR_UNALIGNED_EXTENT_REC;
+
+	return ret;
+}
+
 static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_path path;
 	int ret = 0;
 
+	/*
+	 * unaligned extent recs always lead to csum missing error, clean it
+	 */
+	if ((rec->errors & I_ERR_SOME_CSUM_MISSING) &&
+			(rec->errors & I_ERR_UNALIGNED_EXTENT_REC))
+		rec->errors &= ~I_ERR_SOME_CSUM_MISSING;
+
+
 	if (!(rec->errors & (I_ERR_DIR_ISIZE_WRONG |
 			     I_ERR_NO_ORPHAN_ITEM |
 			     I_ERR_LINK_COUNT_WRONG |
 			     I_ERR_NO_INODE_ITEM |
 			     I_ERR_FILE_EXTENT_DISCOUNT |
 			     I_ERR_FILE_NBYTES_WRONG |
+			     I_ERR_UNALIGNED_EXTENT_REC |
 			     I_ERR_INLINE_RAM_BYTES_WRONG)))
 		return rec->errors;
 
@@ -2515,6 +2686,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 		ret = repair_inode_nbytes(trans, root, &path, rec);
 	if (!ret && rec->errors & I_ERR_INLINE_RAM_BYTES_WRONG)
 		ret = repair_inline_ram_bytes(trans, root, &path, rec);
+	if (!ret && rec->errors & I_ERR_UNALIGNED_EXTENT_REC)
+		ret = repair_unaligned_extent_recs(trans, root, &path, rec);
 	btrfs_commit_transaction(trans, root);
 	btrfs_release_path(&path);
 	return ret;
@@ -3128,6 +3301,8 @@ static int check_fs_root(struct btrfs_root *root,
 	struct cache_tree corrupt_blocks;
 	enum btrfs_tree_block_status status;
 	struct node_refs nrefs;
+	struct unaligned_extent_rec_t *urec;
+	struct unaligned_extent_rec_t *tmp;
 
 	/*
 	 * Reuse the corrupt_block cache tree to record corrupted tree block
@@ -3151,6 +3326,30 @@ static int check_fs_root(struct btrfs_root *root,
 	cache_tree_init(&root_node.inode_cache);
 	memset(&nrefs, 0, sizeof(nrefs));
 
+	/*
+	 * Mode unaligned extent recs to corresponding inode record
+	 */
+	list_for_each_entry_safe(urec, tmp,
+			&root->unaligned_extent_recs, list) {
+		struct inode_record *inode;
+
+		inode = get_inode_rec(&root_node.inode_cache, urec->owner, 1);
+
+		if (IS_ERR_OR_NULL(inode)) {
+			fprintf(stderr,
+				"fail to get inode rec on [%llu,%llu]\n",
+				urec->objectid, urec->owner);
+
+			list_del(&urec->list);
+			free(urec);
+
+			continue;
+		}
+
+		inode->errors |= I_ERR_UNALIGNED_EXTENT_REC;
+		list_move(&urec->list, &inode->unaligned_extent_recs);
+	}
+
 	level = btrfs_header_level(root->node);
 	memset(wc->nodes, 0, sizeof(wc->nodes));
 	wc->nodes[level] = &root_node;
@@ -7425,6 +7624,68 @@ static int prune_corrupt_blocks(struct btrfs_fs_info *info)
 	return 0;
 }
 
+static int record_unaligned_extent_rec(struct btrfs_fs_info *fs_info,
+					struct extent_record *rec)
+{
+
+	struct extent_backref *back, *tmp;
+	struct data_backref *dback;
+	struct btrfs_root *dest_root;
+	struct btrfs_key key;
+	struct unaligned_extent_rec_t *urec;
+	LIST_HEAD(entries);
+	int ret = 0;
+
+	fprintf(stderr, "record unaligned extent record on %llu %llu\n",
+			rec->start, rec->nr);
+
+	/*
+	 * Metadata is easy and the backrefs should always agree on bytenr and
+	 * size, if not we've got bigger issues.
+	 */
+	if (rec->metadata)
+		return 0;
+
+	rbtree_postorder_for_each_entry_safe(back, tmp,
+					     &rec->backref_tree, node) {
+		if (back->full_backref || !back->is_data)
+			continue;
+
+		dback = to_data_backref(back);
+
+		key.objectid = dback->root;
+		key.type = BTRFS_ROOT_ITEM_KEY;
+		key.offset = (u64)-1;
+
+		dest_root = btrfs_read_fs_root(fs_info, &key);
+
+		/*
+		 * For non-exist root we just skip it
+		 */
+		if (IS_ERR_OR_NULL(dest_root))
+			continue;
+
+		urec = malloc(sizeof(struct unaligned_extent_rec_t));
+		if (!urec)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(&urec->list);
+		urec->objectid = dest_root->objectid;
+		urec->owner = dback->owner;
+		urec->offset = 0;
+		urec->bytenr = rec->start;
+		ret = find_file_extent_offset_by_bytenr(dest_root,
+				dback->owner, rec->start, &urec->offset);
+		if (ret) {
+			free(urec);
+			return ret;
+		}
+		list_add(&urec->list, &dest_root->unaligned_extent_recs);
+	}
+
+	return ret;
+}
+
 static int check_extent_refs(struct btrfs_root *root,
 			     struct cache_tree *extent_cache)
 {
@@ -7522,6 +7783,21 @@ static int check_extent_refs(struct btrfs_root *root,
 			fix = 1;
 			cur_err = 1;
 		}
+
+		if (!IS_ALIGNED(rec->start, root->fs_info->sectorsize)) {
+			fprintf(stderr, "unaligned extent rec on [%llu %llu]\n",
+				(unsigned long long)rec->start,
+				(unsigned long long)rec->nr);
+			ret = record_unaligned_extent_rec(root->fs_info, rec);
+			if (ret)
+				goto repair_abort;
+
+			/*
+			 * free extent record
+			 */
+			goto next;
+		}
+
 		if (all_backpointers_checked(rec, 1)) {
 			fprintf(stderr, "backpointer mismatch on [%llu %llu]\n",
 				(unsigned long long)rec->start,
@@ -7574,7 +7850,7 @@ static int check_extent_refs(struct btrfs_root *root,
 				rec->start, rec->start + rec->max_size);
 			cur_err = 1;
 		}
-
+next:
 		err = cur_err;
 		remove_cache_extent(extent_cache, cache);
 		free_all_extent_backrefs(rec);
diff --git a/check/mode-original.h b/check/mode-original.h
index ed995931fcd5..b23594863199 100644
--- a/check/mode-original.h
+++ b/check/mode-original.h
@@ -155,6 +155,16 @@ struct file_extent_hole {
 	u64 len;
 };
 
+struct unaligned_extent_rec_t {
+	struct list_head list;
+
+	u64 objectid;
+	u64 owner;
+	u64 offset;
+
+	u64 bytenr;
+};
+
 #define I_ERR_NO_INODE_ITEM		(1 << 0)
 #define I_ERR_NO_ORPHAN_ITEM		(1 << 1)
 #define I_ERR_DUP_INODE_ITEM		(1 << 2)
@@ -169,6 +179,7 @@ struct file_extent_hole {
 #define I_ERR_ODD_CSUM_ITEM		(1 << 11)
 #define I_ERR_SOME_CSUM_MISSING		(1 << 12)
 #define I_ERR_LINK_COUNT_WRONG		(1 << 13)
+#define I_ERR_UNALIGNED_EXTENT_REC	(1 << 14)
 #define I_ERR_FILE_EXTENT_TOO_LARGE	(1 << 15)
 #define I_ERR_ODD_INODE_FLAGS		(1 << 16)
 #define I_ERR_INLINE_RAM_BYTES_WRONG	(1 << 17)
@@ -185,6 +196,8 @@ struct inode_record {
 	unsigned int nodatasum:1;
 	int errors;
 
+	struct list_head unaligned_extent_recs;
+
 	u64 ino;
 	u32 nlink;
 	u32 imode;
diff --git a/ctree.h b/ctree.h
index 2e0896390434..d0f441587f9f 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1177,6 +1177,8 @@ struct btrfs_root {
 	u32 type;
 	u64 last_inode_alloc;
 
+	struct list_head unaligned_extent_recs;
+
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;
 	struct rb_node rb_node;
diff --git a/disk-io.c b/disk-io.c
index 992f4b870e9f..0dfd51ed87bf 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -480,6 +480,7 @@ void btrfs_setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	root->last_inode_alloc = 0;
 
 	INIT_LIST_HEAD(&root->dirty_list);
+	INIT_LIST_HEAD(&root->unaligned_extent_recs);
 	memset(&root->root_key, 0, sizeof(root->root_key));
 	memset(&root->root_item, 0, sizeof(root->root_item));
 	root->root_key.objectid = objectid;
-- 
2.19.1



