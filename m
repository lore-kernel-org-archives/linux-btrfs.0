Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5201AC04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 11:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB48F21019
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 11:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T5VlL0Ux"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB48F21019
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gelma.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbeK1WGk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 17:06:40 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:34304 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbeK1WGj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 17:06:39 -0500
Received: by mail-wr1-f51.google.com with SMTP id j2so25870686wrw.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 03:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KP+ydSKyLA0XLac4JjJYVXH9yQ7FWTpVus1h6yF1oQ0=;
        b=T5VlL0UxxD3aT3Pg2NxT5lY05GRz/5wkPfSpVMpfWpEFg8OxORRYndhu4Tv5L2vibJ
         Oob4iaXag7996NXNjf9AhC5WNsjPm24AY/r36ZqqpszRiSsSPowCC5dJ9KpYxr6otJuw
         pX6J1UOCtvpBQsHba3fN7AsYcfhC2vTPyDEfOJEBk6bLq/k2udr7Y6D6FdXKQdzjaUDt
         yPMzPkr7FomNljeTYI94gluf0eoJlV0hgQCq91mGy1WhmVU8Juh2/m37Qs7n8xT6CESG
         DmbbtmBO6QL8GKEhM4TDUllcJ2ioXbPOEvpC+VqrHn7t2YMUbgi7w0RUl9TihZbZfPWg
         QObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=KP+ydSKyLA0XLac4JjJYVXH9yQ7FWTpVus1h6yF1oQ0=;
        b=VWyFZlYDJLU6lSh212S4pjmAiE/yMeckGOaQmCd/Lqy2WoeJ097V8dki+GGccCE6DF
         ZBzSccZjcgsERBUivaMATJJHk78D7WL/fHXq7WCUsJ9hDq5G4FFe343R8dYAAD+EUyNs
         /eL0I4H4cTzl8PkSv3HbtPG1SR1TP4CsU6z84yHiYWhvYOD0HasS88+tC3Ouyf+RqjBa
         kBv/LidU27z2aQyTLHOZ6PutQW5KwRy0GT12FdQ6ci6HhqvQCztCLES8W1skrag1Bc3G
         /o6s+/IbstPjv/aehrzgH7mt6HcrncfqfRKG6SP8m1gVhIZ1qNPCwyhRiJuZMEhzPOf1
         0Osw==
X-Gm-Message-State: AA+aEWZ7gVJPxguCAII+TdOiO5fuJ+hNms5sFj/Gs2xgDgSXwHPpk058
        UiWmFxgiL4QdUNXL4dPNVcp2os4uwzo=
X-Google-Smtp-Source: AFSGD/XfFUTA/JSM31TFKI87P4KE6b0uTkIMsDCTlXIbZ6yO8sc4WhPLfSwPzOdsigwnn0PPjuArJg==
X-Received: by 2002:adf:d089:: with SMTP id y9mr3299882wrh.22.1543403118718;
        Wed, 28 Nov 2018 03:05:18 -0800 (PST)
Received: from localhost.localdomain (anon-42-175.vpn.ipredator.se. [46.246.42.175])
        by smtp.gmail.com with ESMTPSA id k19sm6927792wre.5.2018.11.28.03.05.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Nov 2018 03:05:17 -0800 (PST)
From:   Andrea Gelmini <andrea.gelmini@gelma.net>
To:     linux-btrfs@vger.kernel.org
Cc:     Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH] Fix typos
Date:   Wed, 28 Nov 2018 12:05:13 +0100
Message-Id: <20181128110513.6079-1-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 2.20.0.rc1.28.g8a4ee09a8a
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---

Stupid fixes. Made on 4.20-rc4, and ported on linux-next (next-20181128).


 fs/btrfs/backref.c         |  4 ++--
 fs/btrfs/check-integrity.c |  2 +-
 fs/btrfs/compression.c     |  4 ++--
 fs/btrfs/ctree.c           |  4 ++--
 fs/btrfs/dev-replace.c     |  2 +-
 fs/btrfs/disk-io.c         |  4 ++--
 fs/btrfs/extent-tree.c     | 28 ++++++++++++++--------------
 fs/btrfs/extent_io.c       |  4 ++--
 fs/btrfs/extent_io.h       |  2 +-
 fs/btrfs/extent_map.c      |  2 +-
 fs/btrfs/file.c            |  6 +++---
 fs/btrfs/free-space-tree.c |  2 +-
 fs/btrfs/inode.c           | 10 +++++-----
 fs/btrfs/ioctl.c           |  4 ++--
 fs/btrfs/lzo.c             |  2 +-
 fs/btrfs/qgroup.c          | 14 +++++++-------
 fs/btrfs/qgroup.h          |  4 ++--
 fs/btrfs/raid56.c          |  2 +-
 fs/btrfs/ref-verify.c      |  6 +++---
 fs/btrfs/relocation.c      |  2 +-
 fs/btrfs/scrub.c           |  2 +-
 fs/btrfs/send.c            |  4 ++--
 fs/btrfs/super.c           |  8 ++++----
 fs/btrfs/transaction.c     |  4 ++--
 fs/btrfs/tree-checker.c    |  6 +++---
 fs/btrfs/tree-log.c        |  4 ++--
 fs/btrfs/volumes.c         |  8 ++++----
 27 files changed, 72 insertions(+), 72 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 4a15f87dbbb4..78556447e1d5 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -591,7 +591,7 @@ unode_aux_to_inode_list(struct ulist_node *node)
 }
 
 /*
- * We maintain three seperate rbtrees: one for direct refs, one for
+ * We maintain three separate rbtrees: one for direct refs, one for
  * indirect refs which have a key, and one for indirect refs which do not
  * have a key. Each tree does merge on insertion.
  *
@@ -695,7 +695,7 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		}
 
 		/*
-		 * Now it's a direct ref, put it in the the direct tree. We must
+		 * Now it's a direct ref, put it in the direct tree. We must
 		 * do this last because the ref could be merged/freed here.
 		 */
 		prelim_ref_insert(fs_info, &preftrees->direct, ref, NULL);
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 781cae168d2a..42b2c5e159f1 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2327,7 +2327,7 @@ static int btrfsic_check_all_ref_blocks(struct btrfsic_state *state,
 		 * write operations. Therefore it keeps the linkage
 		 * information for a block until a block is
 		 * rewritten. This can temporarily cause incorrect
-		 * and even circular linkage informations. This
+		 * and even circular linkage information. This
 		 * causes no harm unless such blocks are referenced
 		 * by the most recent super block.
 		 */
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 34d50bc5c10d..d8ce66f3e943 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1202,7 +1202,7 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
 /*
  * Shannon Entropy calculation
  *
- * Pure byte distribution analysis fails to determine compressiability of data.
+ * Pure byte distribution analysis fails to determine compressibility of data.
  * Try calculating entropy to estimate the average minimum number of bits
  * needed to encode the sampled data.
  *
@@ -1266,7 +1266,7 @@ static u8 get4bits(u64 num, int shift) {
 
 /*
  * Use 4 bits as radix base
- * Use 16 u32 counters for calculating new possition in buf array
+ * Use 16 u32 counters for calculating new position in buf array
  *
  * @array     - array that will be sorted
  * @array_buf - buffer array to store sorting results
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 1ec08efba814..25a58486bf89 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1414,7 +1414,7 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
 	 *
 	 * What is forced COW:
 	 *    when we create snapshot during committing the transaction,
-	 *    after we've finished coping src root, we must COW the shared
+	 *    after we've finished copying src root, we must COW the shared
 	 *    block to ensure the metadata consistency.
 	 */
 	if (btrfs_header_generation(buf) == trans->transid &&
@@ -3746,7 +3746,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 		/* Key greater than all keys in the leaf, right neighbor has
 		 * enough room for it and we're not emptying our leaf to delete
 		 * it, therefore use right neighbor to insert the new item and
-		 * no need to touch/dirty our left leaft. */
+		 * no need to touch/dirty our left leaf. */
 		btrfs_tree_unlock(left);
 		free_extent_buffer(left);
 		path->nodes[0] = right;
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 6f7e890bf480..8750c835f535 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -991,7 +991,7 @@ int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace)
 		 * something that can happen if the dev_replace
 		 * procedure is suspended by an umount and then
 		 * the tgtdev is missing (or "btrfs dev scan") was
-		 * not called and the the filesystem is remounted
+		 * not called and the filesystem is remounted
 		 * in degraded state. This does not stop the
 		 * dev_replace procedure. It needs to be canceled
 		 * manually if the cancellation is wanted.
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5d0ee65664b8..8651ae73eecd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3106,7 +3106,7 @@ int open_ctree(struct super_block *sb,
 
 	if (!sb_rdonly(sb) && !btrfs_check_rw_degradable(fs_info, NULL)) {
 		btrfs_warn(fs_info,
-		"writeable mount is not allowed due to too many missing devices");
+		"writable mount is not allowed due to too many missing devices");
 		goto fail_sysfs;
 	}
 
@@ -4083,7 +4083,7 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	/*
 	 * This is a fast path so only do this check if we have sanity tests
-	 * enabled.  Normal people shouldn't be using umapped buffers as dirty
+	 * enabled.  Normal people shouldn't be using unmapped buffers as dirty
 	 * outside of the sanity tests.
 	 */
 	if (unlikely(test_bit(EXTENT_BUFFER_UNMAPPED, &buf->bflags)))
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 581c2a0b2945..393189652967 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1010,14 +1010,14 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
  *
  * - multiple snapshots, subvolumes, or different generations in one subvol
  * - different files inside a single subvolume
- * - different offsets inside a file (bookend extents in file.c)
+ * - different offsets inside a file (booked extents in file.c)
  *
  * The extent ref structure for the implicit back refs has fields for:
  *
  * - Objectid of the subvolume root
  * - objectid of the file holding the reference
  * - original offset in the file
- * - how many bookend extents
+ * - how many booked extents
  *
  * The key offset for the implicit back refs is hash of the first
  * three fields.
@@ -1055,7 +1055,7 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 
 /*
  * is_data == BTRFS_REF_TYPE_BLOCK, tree block type is required,
- * is_data == BTRFS_REF_TYPE_DATA, data type is requried,
+ * is_data == BTRFS_REF_TYPE_DATA, data type is requiried,
  * is_data == BTRFS_REF_TYPE_ANY, either type is OK.
  */
 int btrfs_get_extent_inline_ref_type(const struct extent_buffer *eb,
@@ -3693,7 +3693,7 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 			}
 		}
 
-		/* if its not on the io list, we need to put the block group */
+		/* if it's not on the io list, we need to put the block group */
 		if (should_put)
 			btrfs_put_block_group(cache);
 		if (drop_reserve)
@@ -4655,7 +4655,7 @@ static int can_overcommit(struct btrfs_fs_info *fs_info,
 
 	/*
 	 * If we have dup, raid1 or raid10 then only half of the free
-	 * space is actually useable.  For raid56, the space info used
+	 * space is actually usable.  For raid56, the space info used
 	 * doesn't include the parity drive, so we don't have to
 	 * change the math
 	 */
@@ -5316,7 +5316,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
  * @orig_bytes - the number of bytes we want
  * @flush - whether or not we can flush to make our reservation
  *
- * This will reserve orgi_bytes number of bytes from the space info associated
+ * This will reserve orig_bytes number of bytes from the space info associated
  * with the block_rsv.  If there is not enough space it will make an attempt to
  * flush out space to make room.  It will do this by flushing delalloc if
  * possible or committing the transaction.  If flush is 0 then no attempts to
@@ -5801,11 +5801,11 @@ static inline void __get_refill_bytes(struct btrfs_block_rsv *block_rsv,
 /**
  * btrfs_inode_rsv_refill - refill the inode block rsv.
  * @inode - the inode we are refilling.
- * @flush - the flusing restriction.
+ * @flush - the flushing restriction.
  *
  * Essentially the same as btrfs_block_rsv_refill, except it uses the
  * block_rsv->size as the minimum size.  We'll either refill the missing amount
- * or return if we already have enough space.  This will also handle the resreve
+ * or return if we already have enough space.  This will also handle the reserve
  * tracepoint for the reserved amount.
  */
 static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
@@ -8556,7 +8556,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		buf->log_index = root->log_transid % 2;
 		/*
 		 * we allow two log transactions at a time, use different
-		 * EXENT bit to differentiate dirty pages.
+		 * EXTENT bit to differentiate dirty pages.
 		 */
 		if (buf->log_index == 0)
 			set_extent_dirty(&root->dirty_log_pages, buf->start,
@@ -9807,7 +9807,7 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group_cache *cache)
 }
 
 /*
- * checks to see if its even possible to relocate this block group.
+ * checks to see if it's even possible to relocate this block group.
  *
  * @return - false if not enough space can be found for relocation, true
  * otherwise
@@ -9872,7 +9872,7 @@ bool btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 	 * ok we don't have enough space, but maybe we have free space on our
 	 * devices to allocate new chunks for relocation, so loop through our
 	 * alloc devices and guess if we have enough space.  if this block
-	 * group is going to be restriped, run checks against the target
+	 * group is going to be restripped, run checks against the target
 	 * profile instead of the current one.
 	 */
 	can_reloc = false;
@@ -10424,7 +10424,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 		 * check for two cases, either we are full, and therefore
 		 * don't need to bother with the caching work since we won't
 		 * find any space, or we are empty, and we can just add all
-		 * the space in and be done with it.  This saves us _alot_ of
+		 * the space in and be done with it.  This saves us _a_lot_ of
 		 * time, particularly in the full case.
 		 */
 		if (found_key.offset == btrfs_block_group_used(&cache->item)) {
@@ -10700,7 +10700,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	mutex_lock(&trans->transaction->cache_write_mutex);
 	/*
-	 * make sure our free spache cache IO is done before remove the
+	 * make sure our free space cache IO is done before remove the
 	 * free space inode
 	 */
 	spin_lock(&trans->transaction->dirty_bgs_lock);
@@ -11217,7 +11217,7 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 	if (!blk_queue_discard(bdev_get_queue(device->bdev)))
 		return 0;
 
-	/* Not writeable = nothing to do. */
+	/* Not writable = nothing to do. */
 	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
 		return 0;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index aef3c9866ff0..1493f0c102ec 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -492,7 +492,7 @@ static struct extent_state *next_state(struct extent_state *state)
 
 /*
  * utility function to clear some bits in an extent state struct.
- * it will optionally wake up any one waiting on this state (wake == 1).
+ * it will optionally wake up anyone waiting on this state (wake == 1).
  *
  * If no bits are set on the state struct after clearing things, the
  * struct is freed and removed from the tree
@@ -4319,7 +4319,7 @@ static int emit_fiemap_extent(struct fiemap_extent_info *fieinfo,
 
 	/*
 	 * Sanity check, extent_fiemap() should have ensured that new
-	 * fiemap extent won't overlap with cahced one.
+	 * fiemap extent won't overlap with cached one.
 	 * Not recoverable.
 	 *
 	 * NOTE: Physical address can overlap, due to compression
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 17878eef9bcc..0064504aa9a6 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -94,7 +94,7 @@ typedef blk_status_t (extent_submit_bio_start_t)(void *private_data,
 
 struct extent_io_ops {
 	/*
-	 * The following callbacks must be allways defined, the function
+	 * The following callbacks must be always defined, the function
 	 * pointer will be called unconditionally.
 	 */
 	extent_submit_bio_hook_t *submit_bio_hook;
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 7eea8b6e2cd3..bdb26e0e209b 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -475,7 +475,7 @@ static struct extent_map *prev_extent_map(struct extent_map *em)
 	return container_of(prev, struct extent_map, rb_node);
 }
 
-/* helper for btfs_get_extent.  Given an existing extent in the tree,
+/* helper for btrfs_get_extent.  Given an existing extent in the tree,
  * the existing extent is the nearest extent to map_start,
  * and an extent that you want to insert, deal with overlap and insert
  * the best fitted new extent into the tree.
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 6d64d16c77e6..e8247c7e4508 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2005,7 +2005,7 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
 	filp->private_data = NULL;
 
 	/*
-	 * ordered_data_close is set by settattr when we are about to truncate
+	 * ordered_data_close is set by setattr when we are about to truncate
 	 * a file from a non-zero size to a zero size.  This tries to
 	 * flush down new bytes that may have been written if the
 	 * application were using truncate to replace a file in place.
@@ -2114,7 +2114,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	/*
 	 * We have to do this here to avoid the priority inversion of waiting on
-	 * IO of a lower priority task while holding a transaciton open.
+	 * IO of a lower priority task while holding a transaction open.
 	 */
 	ret = btrfs_wait_ordered_range(inode, start, len);
 	if (ret) {
@@ -2154,7 +2154,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * here we could get into a situation where we're waiting on IO to
 	 * happen that is blocked on a transaction trying to commit.  With start
 	 * we inc the extwriter counter, so we wait for all extwriters to exit
-	 * before we start blocking join'ers.  This comment is to keep somebody
+	 * before we start blocking joiners.  This comment is to keep somebody
 	 * from thinking they are super smart and changing this to
 	 * btrfs_join_transaction *cough*Josef*cough*.
 	 */
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index e5089087eaa6..13e71efcfe21 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -550,7 +550,7 @@ static void free_space_set_bits(struct btrfs_block_group_cache *block_group,
 
 /*
  * We can't use btrfs_next_item() in modify_free_space_bitmap() because
- * btrfs_next_leaf() doesn't get the path for writing. We can forgo the fancy
+ * btrfs_next_leaf() doesn't get the path for writing. We can forgot the fancy
  * tree walking in btrfs_next_leaf() anyways because we know exactly what we're
  * looking for.
  */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bab2f1983c07..babbd75d91d2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -104,7 +104,7 @@ static void __endio_write_update_ordered(struct inode *inode,
 
 /*
  * Cleanup all submitted ordered extents in specified range to handle errors
- * from the fill_dellaloc() callback.
+ * from the fill_delalloc() callback.
  *
  * NOTE: caller must ensure that when an error happens, it can not call
  * extent_clear_unlock_delalloc() to clear both the bits EXTENT_DO_ACCOUNTING
@@ -1831,7 +1831,7 @@ void btrfs_clear_delalloc_extent(struct inode *vfs_inode,
 
 		/*
 		 * We don't reserve metadata space for space cache inodes so we
-		 * don't need to call dellalloc_release_metadata if there is an
+		 * don't need to call delalloc_release_metadata if there is an
 		 * error.
 		 */
 		if (*bits & EXTENT_CLEAR_META_RESV &&
@@ -4538,7 +4538,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	/*
 	 * This function is also used to drop the items in the log tree before
 	 * we relog the inode, so if root != BTRFS_I(inode)->root, it means
-	 * it is used to drop the loged items. So we shouldn't kill the delayed
+	 * it is used to drop the logged items. So we shouldn't kill the delayed
 	 * items.
 	 */
 	if (min_type == 0 && root == BTRFS_I(inode)->root)
@@ -5130,7 +5130,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 
 		truncate_setsize(inode, newsize);
 
-		/* Disable nonlocked read DIO to avoid the end less truncate */
+		/* Disable nonlocked read DIO to avoid the endless truncate */
 		btrfs_inode_block_unlocked_dio(BTRFS_I(inode));
 		inode_dio_wait(inode);
 		btrfs_inode_resume_unlocked_dio(BTRFS_I(inode));
@@ -8089,7 +8089,7 @@ static void __endio_write_update_ordered(struct inode *inode,
 			return;
 		/*
 		 * Our bio might span multiple ordered extents. In this case
-		 * we keep goin until we have accounted the whole dio.
+		 * we keep going until we have accounted the whole dio.
 		 */
 		if (ordered_offset < offset + bytes) {
 			ordered_bytes = offset + bytes - ordered_offset;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 410c7e007ba8..d7b6c2b09a0c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -892,7 +892,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
  *  7. If we were asked to remove a directory and victim isn't one - ENOTDIR.
  *  8. If we were asked to remove a non-directory and victim isn't one - EISDIR.
  *  9. We can't remove a root or mountpoint.
- * 10. We don't allow removal of NFS sillyrenamed files; it's handled by
+ * 10. We don't allow removal of NFS silly renamed files; it's handled by
  *     nfs_async_unlink().
  */
 
@@ -3522,7 +3522,7 @@ static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 olen,
 					       false);
 	/*
 	 * If one of the inodes has dirty pages in the respective range or
-	 * ordered extents, we need to flush dellaloc and wait for all ordered
+	 * ordered extents, we need to flush delalloc and wait for all ordered
 	 * extents in the range. We must unlock the pages and the ranges in the
 	 * io trees to avoid deadlocks when flushing delalloc (requires locking
 	 * pages) and when waiting for ordered extents to complete (they require
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index b6a4cc178bee..90639140439f 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -27,7 +27,7 @@
  *     Records the total size (including the header) of compressed data.
  *
  * 2.  Segment(s)
- *     Variable size. Each segment includes one segment header, followd by data
+ *     Variable size. Each segment includes one segment header, followed by data
  *     payload.
  *     One regular LZO compressed extent can have one or more segments.
  *     For inlined LZO compressed extent, only one segment is allowed.
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 2272419ade7e..a7b10ea02d2a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -30,7 +30,7 @@
  *  - sync
  *  - copy also limits on subvol creation
  *  - limit
- *  - caches fuer ulists
+ *  - caches for ulists
  *  - performance benchmarks
  *  - check all ioctl parameters
  */
@@ -522,7 +522,7 @@ void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info)
 		__del_qgroup_rb(qgroup);
 	}
 	/*
-	 * we call btrfs_free_qgroup_config() when umounting
+	 * we call btrfs_free_qgroup_config() when unmounting
 	 * filesystem and disabling quota, so we set qgroup_ulist
 	 * to be null here to avoid double free.
 	 */
@@ -1128,7 +1128,7 @@ static void qgroup_dirty(struct btrfs_fs_info *fs_info,
  * The easy accounting, we're updating qgroup relationship whose child qgroup
  * only has exclusive extents.
  *
- * In this case, all exclsuive extents will also be exlusive for parent, so
+ * In this case, all exclusive extents will also be exclusive for parent, so
  * excl/rfer just get added/removed.
  *
  * So is qgroup reservation space, which should also be added/removed to
@@ -1755,14 +1755,14 @@ static int adjust_slots_upwards(struct btrfs_path *path, int root_level)
  *
  * 2) Mark the final tree blocks in @src_path and @dst_path qgroup dirty
  *    NOTE: In above case, OO(a) and NN(a) won't be marked qgroup dirty.
- *    They should be marked during preivous (@dst_level = 1) iteration.
+ *    They should be marked during previous (@dst_level = 1) iteration.
  *
  * 3) Mark file extents in leaves dirty
  *    We don't have good way to pick out new file extents only.
  *    So we still follow the old method by scanning all file extents in
  *    the leave.
  *
- * This function can free us from keeping two pathes, thus later we only need
+ * This function can free us from keeping two paths, thus later we only need
  * to care about how to iterate all new tree blocks in reloc tree.
  */
 static int qgroup_trace_extent_swap(struct btrfs_trans_handle* trans,
@@ -1901,7 +1901,7 @@ static int qgroup_trace_extent_swap(struct btrfs_trans_handle* trans,
  *
  * We will iterate through tree blocks NN(b), NN(d) and info qgroup to trace
  * above tree blocks along with their counter parts in file tree.
- * While during search, old tree blocsk OO(c) will be skiped as tree block swap
+ * While during search, old tree blocks OO(c) will be skipped as tree block swap
  * won't affect OO(c).
  */
 static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
@@ -2026,7 +2026,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
  * Will go down the tree block pointed by @dst_eb (pointed by @dst_parent and
  * @dst_slot), and find any tree blocks whose generation is at @last_snapshot,
  * and then go down @src_eb (pointed by @src_parent and @src_slot) to find
- * the conterpart of the tree block, then mark both tree blocks as qgroup dirty,
+ * the counterpart of the tree block, then mark both tree blocks as qgroup dirty,
  * and skip all tree blocks whose generation is smaller than last_snapshot.
  *
  * This would skip tons of tree blocks of original btrfs_qgroup_trace_subtree(),
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index d8f78f5ab854..01aea4510c77 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -81,10 +81,10 @@ enum btrfs_qgroup_rsv_type {
  *
  * Each type should have different reservation behavior.
  * E.g, data follows its io_tree flag modification, while
- * *currently* meta is just reserve-and-clear during transcation.
+ * *currently* meta is just reserve-and-clear during transaction.
  *
  * TODO: Add new type for reservation which can survive transaction commit.
- * Currect metadata reservation behavior is not suitable for such case.
+ * Current metadata reservation behavior is not suitable for such case.
  */
 struct btrfs_qgroup_rsv {
 	u64 values[BTRFS_QGROUP_RSV_LAST];
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index df41d7049936..e74455eb42f9 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1980,7 +1980,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 		 * - In case of single failure, where rbio->failb == -1:
 		 *
 		 *   Cache this rbio iff the above read reconstruction is
-		 *   excuted without problems.
+		 *   executed without problems.
 		 */
 		if (err == BLK_STS_OK && rbio->failb < 0)
 			cache_rbio_pages(rbio);
diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
index d69fbfb30aa9..c3557c12656b 100644
--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -43,7 +43,7 @@ struct ref_entry {
  * back to the delayed ref action.  We hold the ref we are changing in the
  * action so we can account for the history properly, and we record the root we
  * were called with since it could be different from ref_root.  We also store
- * stack traces because thats how I roll.
+ * stack traces because that's how I roll.
  */
 struct ref_action {
 	int action;
@@ -56,7 +56,7 @@ struct ref_action {
 
 /*
  * One of these for every block we reference, it holds the roots and references
- * to it as well as all of the ref actions that have occured to it.  We never
+ * to it as well as all of the ref actions that have occurred to it.  We never
  * free it until we unmount the file system in order to make sure re-allocations
  * are happening properly.
  */
@@ -859,7 +859,7 @@ int btrfs_ref_tree_mod(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
 			 * This shouldn't happen because we will add our re
 			 * above when we lookup the be with !parent, but just in
 			 * case catch this case so we don't panic because I
-			 * didn't thik of some other corner case.
+			 * didn't think of some other corner case.
 			 */
 			btrfs_err(fs_info, "failed to find root %llu for %llu",
 				  root->root_key.objectid, be->bytenr);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index e881fbe12367..bd16dddb0272 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2631,7 +2631,7 @@ static int reserve_metadata_space(struct btrfs_trans_handle *trans,
 		 * only one thread can access block_rsv at this point,
 		 * so we don't need hold lock to protect block_rsv.
 		 * we expand more reservation size here to allow enough
-		 * space for relocation and we will return eailer in
+		 * space for relocation and we will return earlier in
 		 * enospc case.
 		 */
 		rc->block_rsv->size = tmp + fs_info->nodesize *
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4936cc65dca0..5d3942ea6219 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3540,7 +3540,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		if (!ret && sctx->is_dev_replace) {
 			/*
 			 * If we are doing a device replace wait for any tasks
-			 * that started dellaloc right before we set the block
+			 * that started delalloc right before we set the block
 			 * group to RO mode, as they might have just allocated
 			 * an extent from it or decided they could do a nocow
 			 * write. And if any such tasks did that, wait for their
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 5be83b5a1b43..b32bb369115f 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2238,7 +2238,7 @@ static int __get_cur_name_and_parent(struct send_ctx *sctx,
  * inodes "orphan" name instead of the real name and stop. Same with new inodes
  * that were not created yet and overwritten inodes/refs.
  *
- * When do we have have orphan inodes:
+ * When do we have orphan inodes:
  * 1. When an inode is freshly created and thus no valid refs are available yet
  * 2. When a directory lost all it's refs (deleted) but still has dir items
  *    inside which were not processed yet (pending for move/delete). If anyone
@@ -3854,7 +3854,7 @@ static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
 		/*
 		 * We may have refs where the parent directory does not exist
 		 * yet. This happens if the parent directories inum is higher
-		 * the the current inum. To handle this case, we create the
+		 * than the current inum. To handle this case, we create the
 		 * parent directory out of order. But we need to check if this
 		 * did already happen before due to other refs in the same dir.
 		 */
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f517e1351b7b..b71ec3df82d2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -94,7 +94,7 @@ const char *btrfs_decode_error(int errno)
 
 /*
  * __btrfs_handle_fs_error decodes expected errors from the caller and
- * invokes the approciate error response.
+ * invokes the appropriate error response.
  */
 __cold
 void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function,
@@ -152,7 +152,7 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
 	 * although there is no way to update the progress. It would add the
 	 * risk of a deadlock, therefore the canceling is omitted. The only
 	 * penalty is that some I/O remains active until the procedure
-	 * completes. The next time when the filesystem is mounted writeable
+	 * completes. The next time when the filesystem is mounted writable
 	 * again, the device replace operation continues.
 	 */
 }
@@ -1854,7 +1854,7 @@ static int btrfs_remount(struct super_block *sb, int *flags,
 
 		if (!btrfs_check_rw_degradable(fs_info, NULL)) {
 			btrfs_warn(fs_info,
-				"too many missing devices, writeable remount is not allowed");
+				"too many missing devices, writable remount is not allowed");
 			ret = -EACCES;
 			goto restore;
 		}
@@ -2318,7 +2318,7 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 	 * device_list_mutex here as we only read the device data and the list
 	 * is protected by RCU.  Even if a device is deleted during the list
 	 * traversals, we'll get valid data, the freeing callback will wait at
-	 * least until until the rcu_read_unlock.
+	 * least until the rcu_read_unlock.
 	 */
 	rcu_read_lock();
 	cur_devices = fs_info->fs_devices;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3c1be9db897c..19e49ecd91c5 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -699,7 +699,7 @@ struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root)
 /*
  * btrfs_attach_transaction_barrier() - catch the running transaction
  *
- * It is similar to the above function, the differentia is this one
+ * It is similar to the above function, the difference is this one
  * will wait for all the inactive transactions until they fully
  * complete.
  */
@@ -1328,7 +1328,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 		return 0;
 
 	/*
-	 * Ensure dirty @src will be commited.  Or, after comming
+	 * Ensure dirty @src will be committed.  Or, after coming
 	 * commit_fs_roots() and switch_commit_roots(), any dirty but not
 	 * recorded root will never be updated again, causing an outdated root
 	 * item.
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index efcf89a8ba44..c3e8c58efe8d 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -27,10 +27,10 @@
  *
  * @type:	leaf or node
  * @identifier:	the necessary info to locate the leaf/node.
- * 		It's recommened to decode key.objecitd/offset if it's
+ * 		It's recommended to decode key.objecitd/offset if it's
  * 		meaningful.
  * @reason:	describe the error
- * @bad_value:	optional, it's recommened to output bad value and its
+ * @bad_value:	optional, it's recommended to output bad value and its
  *		expected value (range).
  *
  * Since comma is used to separate the components, only space is allowed
@@ -130,7 +130,7 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
 	}
 
 	/*
-	 * Support for new compression/encrption must introduce incompat flag,
+	 * Support for new compression/encryption must introduce incompat flag,
 	 * and must be caught in open_ctree().
 	 */
 	if (btrfs_file_extent_compression(leaf, fi) > BTRFS_COMPRESS_TYPES) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 013d0abcd46b..e3f4efe4d661 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1144,7 +1144,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 
-	/* look for a conflicing name */
+	/* look for a conflicting name */
 	di = btrfs_lookup_dir_item(trans, root, path, btrfs_ino(dir),
 				   name, namelen, 0);
 	if (di && !IS_ERR(di)) {
@@ -3149,7 +3149,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	mutex_unlock(&log_root_tree->log_mutex);
 
 	/*
-	 * nobody else is going to jump in and write the the ctree
+	 * nobody else is going to jump in and write the ctree
 	 * super here because the log_commit atomic below is protecting
 	 * us.  We must be called with a transaction handle pinning
 	 * the running transaction open, so a full commit can't hop
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 55cce9b1a55d..6287d11bd6d8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -212,7 +212,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
  * the mutex can be very coarse and can cover long-running operations
  *
  * protects: updates to fs_devices counters like missing devices, rw devices,
- * seeding, structure cloning, openning/closing devices at mount/umount time
+ * seeding, structure cloning, opening/closing devices at mount/umount time
  *
  * global::fs_devs - add, remove, updates to the global list
  *
@@ -5099,7 +5099,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		BUG_ON(1);
 	}
 
-	/* we don't want a chunk larger than 10% of writeable space */
+	/* we don't want a chunk larger than 10% of writable space */
 	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
 			     max_chunk_size);
 
@@ -5408,7 +5408,7 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 
 /*
  * Chunk allocation falls into two parts. The first part does works
- * that make the new allocated chunk useable, but not do any operation
+ * that make the new allocated chunk usable, but not do any operation
  * that modifies the chunk tree. The second part does the works that
  * require modifying the chunk tree. This division is important for the
  * bootstrap process of adding storage to a seed btrfs.
@@ -7306,7 +7306,7 @@ bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
 		if (missing > max_tolerated) {
 			if (!failing_dev)
 				btrfs_warn(fs_info,
-	"chunk %llu missing %d devices, max tolerance is %d for writeable mount",
+	"chunk %llu missing %d devices, max tolerance is %d for writable mount",
 				   em->start, missing, max_tolerated);
 			free_extent_map(em);
 			ret = false;
-- 
2.20.0.rc1.28.g8a4ee09a8a

