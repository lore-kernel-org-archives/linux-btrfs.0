Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9315C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 18:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DC64214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 18:59:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Ht8gN/OI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DC64214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731721AbeKVFe5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:34:57 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:44043 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731406AbeKVFe5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:34:57 -0500
Received: by mail-yb1-f194.google.com with SMTP id p144-v6so2618778yba.11
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 10:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=shKe9qJqA0pv+PsSObLy+PZvYLqvSUU8yQ6mMAHSxsY=;
        b=Ht8gN/OIyDVrC225N2PPu0jsOge837SMx96IS9HF+8igtp7IgHA/aM9y7bBAUUb4La
         rMn1b4yFXnG7Pq8WupaE6JFEQkG1FZm7SusjVBvzPRM5GRwfaaZ/evh1lW8l87Z/6gh5
         otyL49C8sQmN0wa7IYe/u26qyo/omcXRjotT+k35wtY87743uXPBiBkFR8LMhCJAr+Zd
         A2dQadymVqlugmch55COon0AOdnH2ZwH8/9CMwLnn9AkI7OIdjxrg2TafCACAcmd5gK4
         y+EqoFwng33bXzrBlgsYwqF6b6GhIZTAka4Kdw91jehUECnubXq/8YbFWjYf0OfOCfmr
         HfPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=shKe9qJqA0pv+PsSObLy+PZvYLqvSUU8yQ6mMAHSxsY=;
        b=q7x/uPbVAYjOk1LrmQtgpaukUBi7cNw3Ft8iPLeVFlCu2+damE1JLe1ynXeoVZHwmv
         q5w7R/3C5UrjqnzuQYkm+QNftUwowvcVHHXzfajne8Ik0mbH5l5okpi4YSz42s9ueEjg
         TaEx4/Q6m5nfHLq9i9FNIbzXaWCJZ8y/kbx4OBX8RxUo1OOD+XjxXSf1U5hNr7xzBE1+
         PDzXCwtXrdwh0I0vD9bfbvfJ7emsVkxOACyQZ7Hw+yz434174K0JJlahDFEkj6s9vOUK
         4pbPiyBK6Cb5XryHtziNkSQPRBVDE8m6KTHTcDT0h794yTRwWlNF/RjkDai48g/6+KM2
         A6Zw==
X-Gm-Message-State: AGRZ1gLTfkBu/83OJ7J2NySOKWGGzfY5sRtyYsxNK6lecglRmAEERvqM
        AD9d0oFd94cI+uk3UWHfHqwAW5BRRiM=
X-Google-Smtp-Source: AJdET5eUoquNNS+FS5YRiPjxKl+WEiInslQcijPl6ybT+wN2P/1Guifi62oJ7ZTowyPunnZXGWuZQQ==
X-Received: by 2002:a25:8041:: with SMTP id a1-v6mr7263509ybn.53.1542826764278;
        Wed, 21 Nov 2018 10:59:24 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id k185-v6sm10847797ywc.98.2018.11.21.10.59.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 10:59:23 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 5/6] btrfs: introduce delayed_refs_rsv
Date:   Wed, 21 Nov 2018 13:59:11 -0500
Message-Id: <20181121185912.24288-6-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121185912.24288-1-josef@toxicpanda.com>
References: <20181121185912.24288-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

Traditionally we've had voodoo in btrfs to account for the space that
delayed refs may take up by having a global_block_rsv.  This works most
of the time, except when it doesn't.  We've had issues reported and seen
in production where sometimes the global reserve is exhausted during
transaction commit before we can run all of our delayed refs, resulting
in an aborted transaction.  Because of this voodoo we have equally
dubious flushing semantics around throttling delayed refs which we often
get wrong.

So instead give them their own block_rsv.  This way we can always know
exactly how much outstanding space we need for delayed refs.  This
allows us to make sure we are constantly filling that reservation up
with space, and allows us to put more precise pressure on the enospc
system.  Instead of doing math to see if its a good time to throttle,
the normal enospc code will be invoked if we have a lot of delayed refs
pending, and they will be run via the normal flushing mechanism.

For now the delayed_refs_rsv will hold the reservations for the delayed
refs, the block group updates, and deleting csums.  We could have a
separate rsv for the block group updates, but the csum deletion stuff is
still handled via the delayed_refs so that will stay there.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/ctree.h             |  26 ++--
 fs/btrfs/delayed-ref.c       |  28 ++++-
 fs/btrfs/disk-io.c           |   4 +
 fs/btrfs/extent-tree.c       | 279 +++++++++++++++++++++++++++++++++++--------
 fs/btrfs/inode.c             |   4 +-
 fs/btrfs/transaction.c       |  77 ++++++------
 include/trace/events/btrfs.h |   2 +
 7 files changed, 313 insertions(+), 107 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8b41ec42f405..0c6d589c8ce4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -448,8 +448,9 @@ struct btrfs_space_info {
 #define	BTRFS_BLOCK_RSV_TRANS		3
 #define	BTRFS_BLOCK_RSV_CHUNK		4
 #define	BTRFS_BLOCK_RSV_DELOPS		5
-#define	BTRFS_BLOCK_RSV_EMPTY		6
-#define	BTRFS_BLOCK_RSV_TEMP		7
+#define BTRFS_BLOCK_RSV_DELREFS		6
+#define	BTRFS_BLOCK_RSV_EMPTY		7
+#define	BTRFS_BLOCK_RSV_TEMP		8
 
 struct btrfs_block_rsv {
 	u64 size;
@@ -812,6 +813,8 @@ struct btrfs_fs_info {
 	struct btrfs_block_rsv chunk_block_rsv;
 	/* block reservation for delayed operations */
 	struct btrfs_block_rsv delayed_block_rsv;
+	/* block reservation for delayed refs */
+	struct btrfs_block_rsv delayed_refs_rsv;
 
 	struct btrfs_block_rsv empty_block_rsv;
 
@@ -2628,7 +2631,7 @@ static inline u64 btrfs_calc_trunc_metadata_size(struct btrfs_fs_info *fs_info,
 }
 
 int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans);
-int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans);
+bool btrfs_check_space_for_delayed_refs(struct btrfs_fs_info *fs_info);
 void btrfs_dec_block_group_reservations(struct btrfs_fs_info *fs_info,
 					 const u64 start);
 void btrfs_wait_block_group_reservations(struct btrfs_block_group_cache *bg);
@@ -2742,10 +2745,12 @@ enum btrfs_reserve_flush_enum {
 enum btrfs_flush_state {
 	FLUSH_DELAYED_ITEMS_NR	=	1,
 	FLUSH_DELAYED_ITEMS	=	2,
-	FLUSH_DELALLOC		=	3,
-	FLUSH_DELALLOC_WAIT	=	4,
-	ALLOC_CHUNK		=	5,
-	COMMIT_TRANS		=	6,
+	FLUSH_DELAYED_REFS_NR	=	3,
+	FLUSH_DELAYED_REFS	=	4,
+	FLUSH_DELALLOC		=	5,
+	FLUSH_DELALLOC_WAIT	=	6,
+	ALLOC_CHUNK		=	7,
+	COMMIT_TRANS		=	8,
 };
 
 int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes);
@@ -2796,6 +2801,13 @@ int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
 void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
 			     struct btrfs_block_rsv *block_rsv,
 			     u64 num_bytes);
+void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int nr);
+void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans);
+int btrfs_throttle_delayed_refs(struct btrfs_fs_info *fs_info,
+				enum btrfs_reserve_flush_enum flush);
+void btrfs_migrate_to_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
+				       struct btrfs_block_rsv *src,
+				       u64 num_bytes);
 int btrfs_inc_block_group_ro(struct btrfs_block_group_cache *cache);
 void btrfs_dec_block_group_ro(struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 48725fa757a3..96de92588f06 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -474,11 +474,14 @@ static int insert_delayed_ref(struct btrfs_trans_handle *trans,
  * existing and update must have the same bytenr
  */
 static noinline void
-update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
+update_existing_head_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_delayed_ref_head *existing,
 			 struct btrfs_delayed_ref_head *update,
 			 int *old_ref_mod_ret)
 {
+	struct btrfs_delayed_ref_root *delayed_refs =
+		&trans->transaction->delayed_refs;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int old_ref_mod;
 
 	BUG_ON(existing->is_data != update->is_data);
@@ -536,10 +539,18 @@ update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
 	 * versa we need to make sure to adjust pending_csums accordingly.
 	 */
 	if (existing->is_data) {
-		if (existing->total_ref_mod >= 0 && old_ref_mod < 0)
+		u64 csum_items =
+			btrfs_csum_bytes_to_leaves(fs_info,
+						   existing->num_bytes);
+
+		if (existing->total_ref_mod >= 0 && old_ref_mod < 0) {
 			delayed_refs->pending_csums -= existing->num_bytes;
-		if (existing->total_ref_mod < 0 && old_ref_mod >= 0)
+			btrfs_delayed_refs_rsv_release(fs_info, csum_items);
+		}
+		if (existing->total_ref_mod < 0 && old_ref_mod >= 0) {
 			delayed_refs->pending_csums += existing->num_bytes;
+			trans->delayed_ref_updates += csum_items;
+		}
 	}
 	spin_unlock(&existing->lock);
 }
@@ -645,7 +656,7 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 			&& head_ref->qgroup_reserved
 			&& existing->qgroup_ref_root
 			&& existing->qgroup_reserved);
-		update_existing_head_ref(delayed_refs, existing, head_ref,
+		update_existing_head_ref(trans, existing, head_ref,
 					 old_ref_mod);
 		/*
 		 * we've updated the existing ref, free the newly
@@ -656,8 +667,12 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 	} else {
 		if (old_ref_mod)
 			*old_ref_mod = 0;
-		if (head_ref->is_data && head_ref->ref_mod < 0)
+		if (head_ref->is_data && head_ref->ref_mod < 0) {
 			delayed_refs->pending_csums += head_ref->num_bytes;
+			trans->delayed_ref_updates +=
+				btrfs_csum_bytes_to_leaves(trans->fs_info,
+							   head_ref->num_bytes);
+		}
 		delayed_refs->num_heads++;
 		delayed_refs->num_heads_ready++;
 		atomic_inc(&delayed_refs->num_entries);
@@ -792,6 +807,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 
 	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
 	spin_unlock(&delayed_refs->lock);
+	btrfs_update_delayed_refs_rsv(trans);
 
 	trace_add_delayed_tree_ref(fs_info, &ref->node, ref,
 				   action == BTRFS_ADD_DELAYED_EXTENT ?
@@ -873,6 +889,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 
 	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
 	spin_unlock(&delayed_refs->lock);
+	btrfs_update_delayed_refs_rsv(trans);
 
 	trace_add_delayed_data_ref(trans->fs_info, &ref->node, ref,
 				   action == BTRFS_ADD_DELAYED_EXTENT ?
@@ -910,6 +927,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 			     NULL, NULL, NULL);
 
 	spin_unlock(&delayed_refs->lock);
+	btrfs_update_delayed_refs_rsv(trans);
 	return 0;
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 55e8ca782b98..beaa58e742b5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2666,6 +2666,9 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_block_rsv(&fs_info->empty_block_rsv, BTRFS_BLOCK_RSV_EMPTY);
 	btrfs_init_block_rsv(&fs_info->delayed_block_rsv,
 			     BTRFS_BLOCK_RSV_DELOPS);
+	btrfs_init_block_rsv(&fs_info->delayed_refs_rsv,
+			     BTRFS_BLOCK_RSV_DELREFS);
+
 	atomic_set(&fs_info->async_delalloc_pages, 0);
 	atomic_set(&fs_info->defrag_running, 0);
 	atomic_set(&fs_info->qgroup_op_seq, 0);
@@ -4413,6 +4416,7 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
 
 		spin_unlock(&cur_trans->dirty_bgs_lock);
 		btrfs_put_block_group(cache);
+		btrfs_delayed_refs_rsv_release(fs_info, 1);
 		spin_lock(&cur_trans->dirty_bgs_lock);
 	}
 	spin_unlock(&cur_trans->dirty_bgs_lock);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8a776dc9cb38..8af68b13fa27 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2463,6 +2463,7 @@ static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_delayed_ref_root *delayed_refs =
 		&trans->transaction->delayed_refs;
+	int nr_items = 1;
 
 	if (head->total_ref_mod < 0) {
 		struct btrfs_space_info *space_info;
@@ -2484,12 +2485,15 @@ static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
 			spin_lock(&delayed_refs->lock);
 			delayed_refs->pending_csums -= head->num_bytes;
 			spin_unlock(&delayed_refs->lock);
+			nr_items += btrfs_csum_bytes_to_leaves(fs_info,
+				head->num_bytes);
 		}
 	}
 
 	/* Also free its reserved qgroup space */
 	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
 				      head->qgroup_reserved);
+	btrfs_delayed_refs_rsv_release(fs_info, nr_items);
 }
 
 static int cleanup_ref_head(struct btrfs_trans_handle *trans,
@@ -2831,40 +2835,22 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csum_bytes)
 	return num_csums;
 }
 
-int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans)
+bool btrfs_check_space_for_delayed_refs(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_block_rsv *global_rsv;
-	u64 num_heads = trans->transaction->delayed_refs.num_heads_ready;
-	u64 csum_bytes = trans->transaction->delayed_refs.pending_csums;
-	unsigned int num_dirty_bgs = trans->transaction->num_dirty_bgs;
-	u64 num_bytes, num_dirty_bgs_bytes;
-	int ret = 0;
-
-	num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
-	num_heads = heads_to_leaves(fs_info, num_heads);
-	if (num_heads > 1)
-		num_bytes += (num_heads - 1) * fs_info->nodesize;
-	num_bytes <<= 1;
-	num_bytes += btrfs_csum_bytes_to_leaves(fs_info, csum_bytes) *
-							fs_info->nodesize;
-	num_dirty_bgs_bytes = btrfs_calc_trans_metadata_size(fs_info,
-							     num_dirty_bgs);
-	global_rsv = &fs_info->global_block_rsv;
-
-	/*
-	 * If we can't allocate any more chunks lets make sure we have _lots_ of
-	 * wiggle room since running delayed refs can create more delayed refs.
-	 */
-	if (global_rsv->space_info->full) {
-		num_dirty_bgs_bytes <<= 1;
-		num_bytes <<= 1;
-	}
+	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
+	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
+	u64 reserved;
+	bool ret = false;
 
 	spin_lock(&global_rsv->lock);
-	if (global_rsv->reserved <= num_bytes + num_dirty_bgs_bytes)
-		ret = 1;
+	reserved = global_rsv->reserved;
 	spin_unlock(&global_rsv->lock);
+
+	spin_lock(&delayed_refs_rsv->lock);
+	reserved += delayed_refs_rsv->reserved;
+	if (delayed_refs_rsv->size >= reserved)
+		ret = true;
+	spin_unlock(&delayed_refs_rsv->lock);
 	return ret;
 }
 
@@ -2883,7 +2869,7 @@ int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans)
 	if (val >= NSEC_PER_SEC / 2)
 		return 2;
 
-	return btrfs_check_space_for_delayed_refs(trans);
+	return btrfs_check_space_for_delayed_refs(trans->fs_info);
 }
 
 struct async_delayed_refs {
@@ -3627,6 +3613,8 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 	 */
 	mutex_lock(&trans->transaction->cache_write_mutex);
 	while (!list_empty(&dirty)) {
+		bool drop_reserve = true;
+
 		cache = list_first_entry(&dirty,
 					 struct btrfs_block_group_cache,
 					 dirty_list);
@@ -3699,6 +3687,7 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 					list_add_tail(&cache->dirty_list,
 						      &cur_trans->dirty_bgs);
 					btrfs_get_block_group(cache);
+					drop_reserve = false;
 				}
 				spin_unlock(&cur_trans->dirty_bgs_lock);
 			} else if (ret) {
@@ -3709,6 +3698,8 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 		/* if its not on the io list, we need to put the block group */
 		if (should_put)
 			btrfs_put_block_group(cache);
+		if (drop_reserve)
+			btrfs_delayed_refs_rsv_release(fs_info, 1);
 
 		if (ret)
 			break;
@@ -3857,6 +3848,7 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 		/* if its not on the io list, we need to put the block group */
 		if (should_put)
 			btrfs_put_block_group(cache);
+		btrfs_delayed_refs_rsv_release(fs_info, 1);
 		spin_lock(&cur_trans->dirty_bgs_lock);
 	}
 	spin_unlock(&cur_trans->dirty_bgs_lock);
@@ -4829,8 +4821,10 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 {
 	struct reserve_ticket *ticket = NULL;
 	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_block_rsv;
+	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
 	struct btrfs_trans_handle *trans;
 	u64 bytes;
+	u64 reclaim_bytes = 0;
 
 	trans = (struct btrfs_trans_handle *)current->journal_info;
 	if (trans)
@@ -4863,12 +4857,16 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 		return -ENOSPC;
 
 	spin_lock(&delayed_rsv->lock);
-	if (delayed_rsv->size > bytes)
-		bytes = 0;
-	else
-		bytes -= delayed_rsv->size;
+	reclaim_bytes += delayed_rsv->reserved;
 	spin_unlock(&delayed_rsv->lock);
 
+	spin_lock(&delayed_refs_rsv->lock);
+	reclaim_bytes += delayed_refs_rsv->reserved;
+	spin_unlock(&delayed_refs_rsv->lock);
+	if (reclaim_bytes >= bytes)
+		goto commit;
+	bytes -= reclaim_bytes;
+
 	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
 				   bytes,
 				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0) {
@@ -4918,6 +4916,20 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 		shrink_delalloc(fs_info, num_bytes * 2, num_bytes,
 				state == FLUSH_DELALLOC_WAIT);
 		break;
+	case FLUSH_DELAYED_REFS_NR:
+	case FLUSH_DELAYED_REFS:
+		trans = btrfs_join_transaction(root);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			break;
+		}
+		if (state == FLUSH_DELAYED_REFS_NR)
+			nr = calc_reclaim_items_nr(fs_info, num_bytes);
+		else
+			nr = 0;
+		btrfs_run_delayed_refs(trans, nr);
+		btrfs_end_transaction(trans);
+		break;
 	case ALLOC_CHUNK:
 		trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans)) {
@@ -5390,6 +5402,91 @@ int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+/**
+ * btrfs_migrate_to_delayed_refs_rsv - transfer bytes to our delayed refs rsv.
+ * @fs_info - the fs info for our fs.
+ * @src - the source block rsv to transfer from.
+ * @num_bytes - the number of bytes to transfer.
+ *
+ * This transfers up to the num_bytes amount from the src rsv to the
+ * delayed_refs_rsv.  Any extra bytes are returned to the space info.
+ */
+void btrfs_migrate_to_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
+				       struct btrfs_block_rsv *src,
+				       u64 num_bytes)
+{
+	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
+	u64 to_free = 0;
+
+	spin_lock(&src->lock);
+	src->reserved -= num_bytes;
+	src->size -= num_bytes;
+	spin_unlock(&src->lock);
+
+	spin_lock(&delayed_refs_rsv->lock);
+	if (delayed_refs_rsv->size > delayed_refs_rsv->reserved) {
+		u64 delta = delayed_refs_rsv->size -
+			delayed_refs_rsv->reserved;
+		if (num_bytes > delta) {
+			to_free = num_bytes - delta;
+			num_bytes = delta;
+		}
+	} else {
+		to_free = num_bytes;
+		num_bytes = 0;
+	}
+
+	if (num_bytes)
+		delayed_refs_rsv->reserved += num_bytes;
+	if (delayed_refs_rsv->reserved >= delayed_refs_rsv->size)
+		delayed_refs_rsv->full = 1;
+	spin_unlock(&delayed_refs_rsv->lock);
+
+	if (num_bytes)
+		trace_btrfs_space_reservation(fs_info, "delayed_refs_rsv",
+					      0, num_bytes, 1);
+	if (to_free)
+		space_info_add_old_bytes(fs_info, delayed_refs_rsv->space_info,
+					 to_free);
+}
+
+/**
+ * btrfs_throttle_delayed_refs - throttle based on our delayed refs usage.
+ * @fs_info - the fs_info for our fs.
+ * @flush - control how we can flush for this reservation.
+ *
+ * This will refill the delayed block_rsv up to 1 items size worth of space and
+ * will return -ENOSPC if we can't make the reservation.
+ */
+int btrfs_throttle_delayed_refs(struct btrfs_fs_info *fs_info,
+				enum btrfs_reserve_flush_enum flush)
+{
+	struct btrfs_block_rsv *block_rsv = &fs_info->delayed_refs_rsv;
+	u64 limit = btrfs_calc_trans_metadata_size(fs_info, 1);
+	u64 num_bytes = 0;
+	int ret = -ENOSPC;
+
+	spin_lock(&block_rsv->lock);
+	if (block_rsv->reserved < block_rsv->size) {
+		num_bytes = block_rsv->size - block_rsv->reserved;
+		num_bytes = min(num_bytes, limit);
+	}
+	spin_unlock(&block_rsv->lock);
+
+	if (!num_bytes)
+		return 0;
+
+	ret = reserve_metadata_bytes(fs_info->extent_root, block_rsv,
+				     num_bytes, flush);
+	if (ret)
+		return ret;
+	block_rsv_add_bytes(block_rsv, num_bytes, 0);
+	trace_btrfs_space_reservation(fs_info, "delayed_refs_rsv",
+				      0, num_bytes, 1);
+	return 0;
+}
+
+
 /*
  * This is for space we already have accounted in space_info->bytes_may_use, so
  * basically when we're returning space from block_rsv's.
@@ -5710,6 +5807,31 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 	return ret;
 }
 
+static u64 __btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
+				     struct btrfs_block_rsv *block_rsv,
+				     u64 num_bytes, u64 *qgroup_to_release)
+{
+	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
+	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_refs_rsv;
+	struct btrfs_block_rsv *target = delayed_rsv;
+
+	if (target->full || target == block_rsv)
+		target = global_rsv;
+
+	if (block_rsv->space_info != target->space_info)
+		target = NULL;
+
+	return block_rsv_release_bytes(fs_info, block_rsv, target, num_bytes,
+				       qgroup_to_release);
+}
+
+void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
+			     struct btrfs_block_rsv *block_rsv,
+			     u64 num_bytes)
+{
+	__btrfs_block_rsv_release(fs_info, block_rsv, num_bytes, NULL);
+}
+
 /**
  * btrfs_inode_rsv_release - release any excessive reservation.
  * @inode - the inode we need to release from.
@@ -5724,7 +5846,6 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
 	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
 	u64 released = 0;
 	u64 qgroup_to_release = 0;
@@ -5734,8 +5855,8 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
 	 * are releasing 0 bytes, and then we'll just get the reservation over
 	 * the size free'd.
 	 */
-	released = block_rsv_release_bytes(fs_info, block_rsv, global_rsv, 0,
-					   &qgroup_to_release);
+	released = __btrfs_block_rsv_release(fs_info, block_rsv, 0,
+					     &qgroup_to_release);
 	if (released > 0)
 		trace_btrfs_space_reservation(fs_info, "delalloc",
 					      btrfs_ino(inode), released, 0);
@@ -5746,16 +5867,26 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
 						   qgroup_to_release);
 }
 
-void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
-			     struct btrfs_block_rsv *block_rsv,
-			     u64 num_bytes)
+/**
+ * btrfs_delayed_refs_rsv_release - release a ref head's reservation.
+ * @fs_info - the fs_info for our fs.
+ * @nr - the number of items to drop.
+ *
+ * This drops the delayed ref head's count from the delayed refs rsv and free's
+ * any excess reservation we had.
+ */
+void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int nr)
 {
+	struct btrfs_block_rsv *block_rsv = &fs_info->delayed_refs_rsv;
 	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
+	u64 num_bytes = btrfs_calc_trans_metadata_size(fs_info, nr);
+	u64 released = 0;
 
-	if (global_rsv == block_rsv ||
-	    block_rsv->space_info != global_rsv->space_info)
-		global_rsv = NULL;
-	block_rsv_release_bytes(fs_info, block_rsv, global_rsv, num_bytes, NULL);
+	released = block_rsv_release_bytes(fs_info, block_rsv, global_rsv,
+					   num_bytes, NULL);
+	if (released)
+		trace_btrfs_space_reservation(fs_info, "delayed_refs_rsv",
+					      0, released, 0);
 }
 
 static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
@@ -5820,9 +5951,10 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
 	fs_info->trans_block_rsv.space_info = space_info;
 	fs_info->empty_block_rsv.space_info = space_info;
 	fs_info->delayed_block_rsv.space_info = space_info;
+	fs_info->delayed_refs_rsv.space_info = space_info;
 
-	fs_info->extent_root->block_rsv = &fs_info->global_block_rsv;
-	fs_info->csum_root->block_rsv = &fs_info->global_block_rsv;
+	fs_info->extent_root->block_rsv = &fs_info->delayed_refs_rsv;
+	fs_info->csum_root->block_rsv = &fs_info->delayed_refs_rsv;
 	fs_info->dev_root->block_rsv = &fs_info->global_block_rsv;
 	fs_info->tree_root->block_rsv = &fs_info->global_block_rsv;
 	if (fs_info->quota_root)
@@ -5842,8 +5974,34 @@ static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
 	WARN_ON(fs_info->chunk_block_rsv.reserved > 0);
 	WARN_ON(fs_info->delayed_block_rsv.size > 0);
 	WARN_ON(fs_info->delayed_block_rsv.reserved > 0);
+	WARN_ON(fs_info->delayed_refs_rsv.reserved > 0);
+	WARN_ON(fs_info->delayed_refs_rsv.size > 0);
 }
 
+/*
+ * btrfs_update_delayed_refs_rsv - adjust the size of the delayed refs rsv
+ * @trans - the trans that may have generated delayed refs
+ *
+ * This is to be called anytime we may have adjusted trans->delayed_ref_updates,
+ * it'll calculate the additional size and add it to the delayed_refs_rsv.
+ */
+void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_refs_rsv;
+	u64 num_bytes;
+
+	if (!trans->delayed_ref_updates)
+		return;
+
+	num_bytes = btrfs_calc_trans_metadata_size(fs_info,
+						   trans->delayed_ref_updates);
+	spin_lock(&delayed_rsv->lock);
+	delayed_rsv->size += num_bytes;
+	delayed_rsv->full = 0;
+	spin_unlock(&delayed_rsv->lock);
+	trans->delayed_ref_updates = 0;
+}
 
 /*
  * To be called after all the new block groups attached to the transaction
@@ -6136,6 +6294,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 	u64 old_val;
 	u64 byte_in_group;
 	int factor;
+	int ret = 0;
 
 	/* block accounting for super block */
 	spin_lock(&info->delalloc_root_lock);
@@ -6149,8 +6308,10 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 
 	while (total) {
 		cache = btrfs_lookup_block_group(info, bytenr);
-		if (!cache)
-			return -ENOENT;
+		if (!cache) {
+			ret = -ENOENT;
+			break;
+		}
 		factor = btrfs_bg_type_to_factor(cache->flags);
 
 		/*
@@ -6209,6 +6370,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			list_add_tail(&cache->dirty_list,
 				      &trans->transaction->dirty_bgs);
 			trans->transaction->num_dirty_bgs++;
+			trans->delayed_ref_updates++;
 			btrfs_get_block_group(cache);
 		}
 		spin_unlock(&trans->transaction->dirty_bgs_lock);
@@ -6226,7 +6388,10 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		total -= num_bytes;
 		bytenr += num_bytes;
 	}
-	return 0;
+
+	/* Modified block groups are accounted for in the delayed_refs_rsv. */
+	btrfs_update_delayed_refs_rsv(trans);
+	return ret;
 }
 
 static u64 first_logical_byte(struct btrfs_fs_info *fs_info, u64 search_start)
@@ -8369,7 +8534,12 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 		goto again;
 	}
 
-	if (btrfs_test_opt(fs_info, ENOSPC_DEBUG)) {
+	/*
+	 * The global reserve still exists to save us from ourselves, so don't
+	 * warn_on if we are short on our delayed refs reserve.
+	 */
+	if (block_rsv->type != BTRFS_BLOCK_RSV_DELREFS &&
+	    btrfs_test_opt(fs_info, ENOSPC_DEBUG)) {
 		static DEFINE_RATELIMIT_STATE(_rs,
 				DEFAULT_RATELIMIT_INTERVAL * 10,
 				/*DEFAULT_RATELIMIT_BURST*/ 1);
@@ -10302,6 +10472,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 		add_block_group_free_space(trans, block_group);
 		/* already aborted the transaction if it failed. */
 next:
+		btrfs_delayed_refs_rsv_release(fs_info, 1);
 		list_del_init(&block_group->bg_list);
 	}
 	btrfs_trans_release_chunk_metadata(trans);
@@ -10379,6 +10550,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans, u64 bytes_used,
 	link_block_group(cache);
 
 	list_add_tail(&cache->bg_list, &trans->new_bgs);
+	trans->delayed_ref_updates++;
+	btrfs_update_delayed_refs_rsv(trans);
 
 	set_avail_alloc_bits(fs_info, type);
 	return 0;
@@ -10416,6 +10589,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	int factor;
 	struct btrfs_caching_control *caching_ctl = NULL;
 	bool remove_em;
+	bool remove_rsv = false;
 
 	block_group = btrfs_lookup_block_group(fs_info, group_start);
 	BUG_ON(!block_group);
@@ -10480,6 +10654,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	if (!list_empty(&block_group->dirty_list)) {
 		list_del_init(&block_group->dirty_list);
+		remove_rsv = true;
 		btrfs_put_block_group(block_group);
 	}
 	spin_unlock(&trans->transaction->dirty_bgs_lock);
@@ -10689,6 +10864,8 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_del_item(trans, root, path);
 out:
+	if (remove_rsv)
+		btrfs_delayed_refs_rsv_release(fs_info, 1);
 	btrfs_free_path(path);
 	return ret;
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a097f5fde31d..8532a2eb56d1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5326,8 +5326,8 @@ static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
 		 * Try to steal from the global reserve if there is space for
 		 * it.
 		 */
-		if (!btrfs_check_space_for_delayed_refs(trans) &&
-		    !btrfs_block_rsv_migrate(global_rsv, rsv, rsv->size, false))
+		if (!btrfs_check_space_for_delayed_refs(fs_info) &&
+		    !btrfs_block_rsv_migrate(global_rsv, rsv, rsv->size, 0))
 			return trans;
 
 		/* If not, commit and try again. */
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f92c0a88c4ad..a4682a696fb6 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -454,7 +454,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 		  bool enforce_qgroups)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-
+	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
 	struct btrfs_trans_handle *h;
 	struct btrfs_transaction *cur_trans;
 	u64 num_bytes = 0;
@@ -483,13 +483,28 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	 * the appropriate flushing if need be.
 	 */
 	if (num_items && root != fs_info->chunk_root) {
+		struct btrfs_block_rsv *rsv = &fs_info->trans_block_rsv;
+		u64 delayed_refs_bytes = 0;
+
 		qgroup_reserved = num_items * fs_info->nodesize;
 		ret = btrfs_qgroup_reserve_meta_pertrans(root, qgroup_reserved,
 				enforce_qgroups);
 		if (ret)
 			return ERR_PTR(ret);
 
+		/*
+		 * We want to reserve all the bytes we may need all at once, so
+		 * we only do 1 enospc flushing cycle per transaction start.  We
+		 * accomplish this by simply assuming we'll do 2 x num_items
+		 * worth of delayed refs updates in this trans handle, and
+		 * refill that amount for whatever is missing in the reserve.
+		 */
 		num_bytes = btrfs_calc_trans_metadata_size(fs_info, num_items);
+		if (delayed_refs_rsv->full == 0) {
+			delayed_refs_bytes = num_bytes;
+			num_bytes <<= 1;
+		}
+
 		/*
 		 * Do the reservation for the relocation root creation
 		 */
@@ -498,8 +513,24 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 			reloc_reserved = true;
 		}
 
-		ret = btrfs_block_rsv_add(root, &fs_info->trans_block_rsv,
-					  num_bytes, flush);
+		ret = btrfs_block_rsv_add(root, rsv, num_bytes, flush);
+		if (ret)
+			goto reserve_fail;
+		if (delayed_refs_bytes) {
+			btrfs_migrate_to_delayed_refs_rsv(fs_info, rsv,
+							  delayed_refs_bytes);
+			num_bytes -= delayed_refs_bytes;
+		}
+	} else if (num_items == 0 && flush == BTRFS_RESERVE_FLUSH_ALL &&
+		   !delayed_refs_rsv->full) {
+		/*
+		 * Some people call with btrfs_start_transaction(root, 0)
+		 * because they can be throttled, but have some other mechanism
+		 * for reserving space.  We still want these guys to refill the
+		 * delayed block_rsv so just add 1 items worth of reservation
+		 * here.
+		 */
+		ret = btrfs_throttle_delayed_refs(fs_info, flush);
 		if (ret)
 			goto reserve_fail;
 	}
@@ -758,7 +789,7 @@ static int should_end_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 
-	if (btrfs_check_space_for_delayed_refs(trans))
+	if (btrfs_check_space_for_delayed_refs(fs_info))
 		return 1;
 
 	return !!btrfs_block_rsv_check(&fs_info->global_block_rsv, 5);
@@ -767,22 +798,12 @@ static int should_end_transaction(struct btrfs_trans_handle *trans)
 int btrfs_should_end_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
-	int updates;
-	int err;
 
 	smp_mb();
 	if (cur_trans->state >= TRANS_STATE_BLOCKED ||
 	    cur_trans->delayed_refs.flushing)
 		return 1;
 
-	updates = trans->delayed_ref_updates;
-	trans->delayed_ref_updates = 0;
-	if (updates) {
-		err = btrfs_run_delayed_refs(trans, updates * 2);
-		if (err) /* Error code will also eval true */
-			return err;
-	}
-
 	return should_end_transaction(trans);
 }
 
@@ -812,11 +833,8 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *info = trans->fs_info;
 	struct btrfs_transaction *cur_trans = trans->transaction;
-	u64 transid = trans->transid;
-	unsigned long cur = trans->delayed_ref_updates;
 	int lock = (trans->type != TRANS_JOIN_NOLOCK);
 	int err = 0;
-	int must_run_delayed_refs = 0;
 
 	if (refcount_read(&trans->use_count) > 1) {
 		refcount_dec(&trans->use_count);
@@ -827,27 +845,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
-	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans);
-
-	trans->delayed_ref_updates = 0;
-	if (!trans->sync) {
-		must_run_delayed_refs =
-			btrfs_should_throttle_delayed_refs(trans);
-		cur = max_t(unsigned long, cur, 32);
-
-		/*
-		 * don't make the caller wait if they are from a NOLOCK
-		 * or ATTACH transaction, it will deadlock with commit
-		 */
-		if (must_run_delayed_refs == 1 &&
-		    (trans->type & (__TRANS_JOIN_NOLOCK | __TRANS_ATTACH)))
-			must_run_delayed_refs = 2;
-	}
-
-	btrfs_trans_release_metadata(trans);
-	trans->block_rsv = NULL;
-
 	if (!list_empty(&trans->new_bgs))
 		btrfs_create_pending_block_groups(trans);
 
@@ -892,10 +889,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	}
 
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
-	if (must_run_delayed_refs) {
-		btrfs_async_run_delayed_refs(info, cur, transid,
-					     must_run_delayed_refs == 1);
-	}
 	return err;
 }
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 8568946f491d..63d1f9d8b8c7 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1048,6 +1048,8 @@ TRACE_EVENT(btrfs_trigger_flush,
 		{ FLUSH_DELAYED_ITEMS,		"FLUSH_DELAYED_ITEMS"},		\
 		{ FLUSH_DELALLOC,		"FLUSH_DELALLOC"},		\
 		{ FLUSH_DELALLOC_WAIT,		"FLUSH_DELALLOC_WAIT"},		\
+		{ FLUSH_DELAYED_REFS_NR,	"FLUSH_DELAYED_REFS_NR"},	\
+		{ FLUSH_DELAYED_REFS,		"FLUSH_ELAYED_REFS"},		\
 		{ ALLOC_CHUNK,			"ALLOC_CHUNK"},			\
 		{ COMMIT_TRANS,			"COMMIT_TRANS"})
 
-- 
2.14.3

