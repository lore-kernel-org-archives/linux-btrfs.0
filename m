Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD67FC04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7543220834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="TlTjMfLZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7543220834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbeLCPUx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:20:53 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38874 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLCPUx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:20:53 -0500
Received: by mail-yw1-f68.google.com with SMTP id i20so5522532ywc.5
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L6oGBPEzscGKsaf2nJZ8ggM/w/zhzdZHJKPMzya7Ipk=;
        b=TlTjMfLZw8sH+Fylsd552p2Ese7Dyro/fAOFGXXviGmeiDBlZByjZOrKkxfcqguu3L
         Pfv7LWcOuPpxfMZg/G4eOTIVD3RexVeCLwJibLWSs97YNmKpgHupfE5PIdGuUxzM/AJC
         sMbFWtCZOVWo+x+JQXSPGU7ZWghRqWrVOfhlZbe9Jw/JADrbKABhehd7QSCp7bFGjCcx
         T4okAyem19Y5DsBp3MPFXd9qPc1JOxRAjdPcf5pu2hn77/eRupjldFYHkvrOj8UuhyMu
         7Wc6oReyFk8z6TBnr6dV+qT2CDjh6HMKffkJSCzSF3zYi/lXEAII+M9NXTInI0YoQYvj
         oSWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L6oGBPEzscGKsaf2nJZ8ggM/w/zhzdZHJKPMzya7Ipk=;
        b=gSYpjXBdnc384ja/Sny7zNQznzmYvdC7kEk9voPbvFWaufax99u3Xxn7DGrpjKSSR8
         qeYvHuj/ZRg+PTcgBrgUM1sbFm1UNfHJ6odJXdRWFT3wSmNZLUspCtixUJGT4mVksvsI
         0+gomMJFgQB97WH4xieDtnhfT/7L6WApR9PxqeeSUBA2vLUODgEqd9Im5fTNUEtNicIq
         u77gQbAllLAqcW42gC0/oeMKlSzTBehcuK7DHQe2w33WZi+rqRkimY5SN8DYNaRy6bwZ
         eOWvUJQEcgKlW4PoYK3SzI1Qi6/RuP47/6WBCykAT/YNLj5hHAn8Xz5oPh5AMt5RpVfp
         3t2Q==
X-Gm-Message-State: AA+aEWZKOpgZtyZL4Zv8tTytw5JlpDZFSv9+BzRE2NkxF6cpV+hOWzTq
        EzHZ3BPQHPk6nawzzoDwkwZMItomRW4=
X-Google-Smtp-Source: AFSGD/V/S+FTeexZpFjMxSy3uMMGEQkrfJ5UiBcVIef1+SSoA+N1m4bOT6L7bOVjtFctZpeSZw9VEA==
X-Received: by 2002:a81:7c04:: with SMTP id x4mr7294527ywc.264.1543850450854;
        Mon, 03 Dec 2018 07:20:50 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id w2sm11780259ywl.10.2018.12.03.07.20.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:20:50 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 05/10] btrfs: introduce delayed_refs_rsv
Date:   Mon,  3 Dec 2018 10:20:33 -0500
Message-Id: <20181203152038.21388-6-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152038.21388-1-josef@toxicpanda.com>
References: <20181203152038.21388-1-josef@toxicpanda.com>
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
 fs/btrfs/ctree.h       |  14 +++-
 fs/btrfs/delayed-ref.c |  43 ++++++++--
 fs/btrfs/disk-io.c     |   4 +
 fs/btrfs/extent-tree.c | 212 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/transaction.c |  37 ++++++++-
 5 files changed, 284 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8b41ec42f405..52a87d446945 100644
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
 
@@ -2796,6 +2799,13 @@ int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
 void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
 			     struct btrfs_block_rsv *block_rsv,
 			     u64 num_bytes);
+void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int nr);
+void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans);
+int btrfs_delayed_refs_rsv_refill(struct btrfs_fs_info *fs_info,
+				  enum btrfs_reserve_flush_enum flush);
+void btrfs_migrate_to_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
+				       struct btrfs_block_rsv *src,
+				       u64 num_bytes);
 int btrfs_inc_block_group_ro(struct btrfs_block_group_cache *cache);
 void btrfs_dec_block_group_ro(struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 48725fa757a3..a198ab91879c 100644
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
+		u64 csum_leaves =
+			btrfs_csum_bytes_to_leaves(fs_info,
+						   existing->num_bytes);
+
+		if (existing->total_ref_mod >= 0 && old_ref_mod < 0) {
 			delayed_refs->pending_csums -= existing->num_bytes;
-		if (existing->total_ref_mod < 0 && old_ref_mod >= 0)
+			btrfs_delayed_refs_rsv_release(fs_info, csum_leaves);
+		}
+		if (existing->total_ref_mod < 0 && old_ref_mod >= 0) {
 			delayed_refs->pending_csums += existing->num_bytes;
+			trans->delayed_ref_updates += csum_leaves;
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
@@ -793,6 +808,12 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
 	spin_unlock(&delayed_refs->lock);
 
+	/*
+	 * Need to update the delayed_refs_rsv with any changes we may have
+	 * made.
+	 */
+	btrfs_update_delayed_refs_rsv(trans);
+
 	trace_add_delayed_tree_ref(fs_info, &ref->node, ref,
 				   action == BTRFS_ADD_DELAYED_EXTENT ?
 				   BTRFS_ADD_DELAYED_REF : action);
@@ -874,6 +895,12 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
 	spin_unlock(&delayed_refs->lock);
 
+	/*
+	 * Need to update the delayed_refs_rsv with any changes we may have
+	 * made.
+	 */
+	btrfs_update_delayed_refs_rsv(trans);
+
 	trace_add_delayed_data_ref(trans->fs_info, &ref->node, ref,
 				   action == BTRFS_ADD_DELAYED_EXTENT ?
 				   BTRFS_ADD_DELAYED_REF : action);
@@ -910,6 +937,12 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 			     NULL, NULL, NULL);
 
 	spin_unlock(&delayed_refs->lock);
+
+	/*
+	 * Need to update the delayed_refs_rsv with any changes we may have
+	 * made.
+	 */
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
index 9f169f3c5fdb..aa0a638d0263 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2462,6 +2462,7 @@ static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_delayed_ref_root *delayed_refs =
 		&trans->transaction->delayed_refs;
+	int nr_items = 1;	/* Dropping this ref head update. */
 
 	if (head->total_ref_mod < 0) {
 		struct btrfs_space_info *space_info;
@@ -2479,16 +2480,24 @@ static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
 				   -head->num_bytes,
 				   BTRFS_TOTAL_BYTES_PINNED_BATCH);
 
+		/*
+		 * We had csum deletions accounted for in our delayed refs rsv,
+		 * we need to drop the csum leaves for this update from our
+		 * delayed_refs_rsv.
+		 */
 		if (head->is_data) {
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
@@ -3626,6 +3635,8 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 	 */
 	mutex_lock(&trans->transaction->cache_write_mutex);
 	while (!list_empty(&dirty)) {
+		bool drop_reserve = true;
+
 		cache = list_first_entry(&dirty,
 					 struct btrfs_block_group_cache,
 					 dirty_list);
@@ -3698,6 +3709,7 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 					list_add_tail(&cache->dirty_list,
 						      &cur_trans->dirty_bgs);
 					btrfs_get_block_group(cache);
+					drop_reserve = false;
 				}
 				spin_unlock(&cur_trans->dirty_bgs_lock);
 			} else if (ret) {
@@ -3708,6 +3720,8 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 		/* if its not on the io list, we need to put the block group */
 		if (should_put)
 			btrfs_put_block_group(cache);
+		if (drop_reserve)
+			btrfs_delayed_refs_rsv_release(fs_info, 1);
 
 		if (ret)
 			break;
@@ -3856,6 +3870,7 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 		/* if its not on the io list, we need to put the block group */
 		if (should_put)
 			btrfs_put_block_group(cache);
+		btrfs_delayed_refs_rsv_release(fs_info, 1);
 		spin_lock(&cur_trans->dirty_bgs_lock);
 	}
 	spin_unlock(&cur_trans->dirty_bgs_lock);
@@ -5389,6 +5404,91 @@ int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
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
+ * btrfs_delayed_refs_rsv_refill - refill based on our delayed refs usage.
+ * @fs_info - the fs_info for our fs.
+ * @flush - control how we can flush for this reservation.
+ *
+ * This will refill the delayed block_rsv up to 1 items size worth of space and
+ * will return -ENOSPC if we can't make the reservation.
+ */
+int btrfs_delayed_refs_rsv_refill(struct btrfs_fs_info *fs_info,
+				  enum btrfs_reserve_flush_enum flush)
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
@@ -5709,6 +5809,31 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
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
@@ -5723,7 +5848,6 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
 	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
 	u64 released = 0;
 	u64 qgroup_to_release = 0;
@@ -5733,8 +5857,8 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
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
@@ -5745,16 +5869,26 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
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
@@ -5819,9 +5953,10 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
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
@@ -5841,8 +5976,34 @@ static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
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
@@ -6135,6 +6296,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 	u64 old_val;
 	u64 byte_in_group;
 	int factor;
+	int ret = 0;
 
 	/* block accounting for super block */
 	spin_lock(&info->delalloc_root_lock);
@@ -6148,8 +6310,10 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 
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
@@ -6208,6 +6372,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			list_add_tail(&cache->dirty_list,
 				      &trans->transaction->dirty_bgs);
 			trans->transaction->num_dirty_bgs++;
+			trans->delayed_ref_updates++;
 			btrfs_get_block_group(cache);
 		}
 		spin_unlock(&trans->transaction->dirty_bgs_lock);
@@ -6225,7 +6390,10 @@ static int update_block_group(struct btrfs_trans_handle *trans,
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
@@ -8368,7 +8536,12 @@ use_block_rsv(struct btrfs_trans_handle *trans,
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
@@ -10301,6 +10474,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 		add_block_group_free_space(trans, block_group);
 		/* already aborted the transaction if it failed. */
 next:
+		btrfs_delayed_refs_rsv_release(fs_info, 1);
 		list_del_init(&block_group->bg_list);
 	}
 	btrfs_trans_release_chunk_metadata(trans);
@@ -10378,6 +10552,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans, u64 bytes_used,
 	link_block_group(cache);
 
 	list_add_tail(&cache->bg_list, &trans->new_bgs);
+	trans->delayed_ref_updates++;
+	btrfs_update_delayed_refs_rsv(trans);
 
 	set_avail_alloc_bits(fs_info, type);
 	return 0;
@@ -10415,6 +10591,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	int factor;
 	struct btrfs_caching_control *caching_ctl = NULL;
 	bool remove_em;
+	bool remove_rsv = false;
 
 	block_group = btrfs_lookup_block_group(fs_info, group_start);
 	BUG_ON(!block_group);
@@ -10479,6 +10656,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	if (!list_empty(&block_group->dirty_list)) {
 		list_del_init(&block_group->dirty_list);
+		remove_rsv = true;
 		btrfs_put_block_group(block_group);
 	}
 	spin_unlock(&trans->transaction->dirty_bgs_lock);
@@ -10688,6 +10866,8 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_del_item(trans, root, path);
 out:
+	if (remove_rsv)
+		btrfs_delayed_refs_rsv_release(fs_info, 1);
 	btrfs_free_path(path);
 	return ret;
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f92c0a88c4ad..a21c4defad92 100644
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
+		ret = btrfs_delayed_refs_rsv_refill(fs_info, flush);
 		if (ret)
 			goto reserve_fail;
 	}
-- 
2.14.3

