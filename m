Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6C9C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DE482086A
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:24:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DE482086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbeKNR0v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 12:26:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:45588 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727375AbeKNR0u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 12:26:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 00899ABEF
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 07:24:47 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: Move reserved data account from btrfs_delayed_ref_head to btrfs_qgroup_extent_record
Date:   Wed, 14 Nov 2018 15:24:44 +0800
Message-Id: <20181114072444.21813-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
Btrfs/139 will fail with a pretty high possibility if the testing
machine (VM) only has 2G ram.

Resulting the final write success while it should fail due to EDQUOT,
and the result fs will has quota exceeding the limit by 16K.

The simplified reproducer will be: (needs a 2G ram VM)

  mkfs.btrfs -f $dev
  mount $dev $mnt

  btrfs subv create $mnt/subv
  btrfs quota enable $mnt
  btrfs quota rescan -w $mnt
  btrfs qgroup limit -e 1G $mnt/subv

  for i in $(seq -w  1 8); do
  	xfs_io -f -c "pwrite 0 128M" $mnt/subv/file_$i > /dev/null
  	echo "file $i written" > /dev/kmsg
  done
  sync
  btrfs qgroup show -pcre --raw $mnt

The last pwrite will not trigger EDQUOT and final qgroup show will show
something like:

  qgroupid         rfer         excl     max_rfer     max_excl parent  child
  --------         ----         ----     --------     -------- ------  -----
  0/5             16384        16384         none         none ---     ---
  0/256      1073758208   1073758208         none   1073741824 ---     ---

And 1073758208 is larger than
  > 1073741824.

[CAUSE]
It's a bug in btrfs qgroup data reserved space management.

For quota limit, we must ensure that:
  reserved (data + metadata) + rfer/excl <= limit

Since rfer/excl is only updated at transaction commmit time, reserved
space needs to be taken special care.

One important part of reserved space is data, and for a new data extent
written to disk, we still need to take the reserved space until
rfer/excl numbers get update.

Originally when an ordered extent finishes, we migrate the reserved
qgroup data space from extent_io tree to delayed ref head of the data
extent, expecting delayed ref will only be cleaned up at commit
transaction time.

However for small RAM machine, due to memory pressure dirty pages can be
flushed back to disk without committing a transaction.

The  related events will be something like:

  BTRFS info (device dm-3): has skinny extents
  file 1 written
  btrfs_finish_ordered_io: ino=258 ordered offset=0 len=54947840
  btrfs_finish_ordered_io: ino=258 ordered offset=54947840 len=5636096
  btrfs_finish_ordered_io: ino=258 ordered offset=61153280 len=57344
  btrfs_finish_ordered_io: ino=258 ordered offset=61210624 len=8192
  btrfs_finish_ordered_io: ino=258 ordered offset=60583936 len=569344
  cleanup_ref_head: num_bytes=54947840
  cleanup_ref_head: num_bytes=5636096
  cleanup_ref_head: num_bytes=569344
  cleanup_ref_head: num_bytes=57344
  cleanup_ref_head: num_bytes=8192
  ^^^^^^^^^^^^^^^^ This will free qgroup data reserved space
  file 2 written
  ...
  file 8 written
  cleanup_ref_head: num_bytes=8192
  ...
  btrfs_commit_transaction  <<< the only transaction committed during
				the test

When file 2 is written, we have already freed 128M reserved qgroup data
space for ino 258. Thus later write won't trigger EDQUOT.

This allows us to write more data beyond qgroup limit.

In my 2G ram VM, it could reach about 1.2G before hitting EDQUOT.

[FIX]
By moving reserved qgroup data space from btrfs_delayed_ref_head to
btrfs_qgroup_extent_record, we can ensure that reserved qgroup data
space won't be freed half way before commit transaction, thus fix the
problem.

Fixes: f64d5ca86821 ("btrfs: delayed_ref: Add new function to record reserved space into delayed ref")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
I tried to create a dedicated test case for this, however drop_caches
interface would also trigger transaction commit, thus allowing bad kernel
to pass (as transaction commit updates qgroup numbers, killing the leakage).

Any idea to trigger dirty data pages writeback while without triggering
a transaction is welcomed.
---
 fs/btrfs/delayed-ref.c       | 15 ++++-----------
 fs/btrfs/delayed-ref.h       | 11 -----------
 fs/btrfs/extent-tree.c       |  3 ---
 fs/btrfs/qgroup.c            | 19 +++++++++++++++----
 fs/btrfs/qgroup.h            | 20 +++++++++++---------
 include/trace/events/btrfs.h | 29 -----------------------------
 6 files changed, 30 insertions(+), 67 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 9301b3ad9217..7e74bf42f2db 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -581,17 +581,14 @@ static void init_delayed_ref_head(struct btrfs_delayed_ref_head *head_ref,
 	RB_CLEAR_NODE(&head_ref->href_node);
 	head_ref->processing = 0;
 	head_ref->total_ref_mod = count_mod;
-	head_ref->qgroup_reserved = 0;
-	head_ref->qgroup_ref_root = 0;
 	spin_lock_init(&head_ref->lock);
 	mutex_init(&head_ref->mutex);
 
 	if (qrecord) {
 		if (ref_root && reserved) {
-			head_ref->qgroup_ref_root = ref_root;
-			head_ref->qgroup_reserved = reserved;
+			qrecord->data_rsv = reserved;
+			qrecord->data_rsv_refroot = ref_root;
 		}
-
 		qrecord->bytenr = bytenr;
 		qrecord->num_bytes = num_bytes;
 		qrecord->old_roots = NULL;
@@ -630,10 +627,6 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 	existing = htree_insert(&delayed_refs->href_root,
 				&head_ref->href_node);
 	if (existing) {
-		WARN_ON(qrecord && head_ref->qgroup_ref_root
-			&& head_ref->qgroup_reserved
-			&& existing->qgroup_ref_root
-			&& existing->qgroup_reserved);
 		update_existing_head_ref(delayed_refs, existing, head_ref,
 					 old_ref_mod);
 		/*
@@ -745,7 +738,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
 	    is_fstree(ref_root)) {
-		record = kmalloc(sizeof(*record), GFP_NOFS);
+		record = kzalloc(sizeof(*record), GFP_NOFS);
 		if (!record) {
 			kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
 			kmem_cache_free(btrfs_delayed_ref_head_cachep, head_ref);
@@ -836,7 +829,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
 	    is_fstree(ref_root)) {
-		record = kmalloc(sizeof(*record), GFP_NOFS);
+		record = kzalloc(sizeof(*record), GFP_NOFS);
 		if (!record) {
 			kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
 			kmem_cache_free(btrfs_delayed_ref_head_cachep,
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 8e20c5cb5404..09e242159acf 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -102,17 +102,6 @@ struct btrfs_delayed_ref_head {
 	 */
 	int ref_mod;
 
-	/*
-	 * For qgroup reserved space freeing.
-	 *
-	 * ref_root and reserved will be recorded after
-	 * BTRFS_ADD_DELAYED_EXTENT is called.
-	 * And will be used to free reserved qgroup space at
-	 * run_delayed_refs() time.
-	 */
-	u64 qgroup_ref_root;
-	u64 qgroup_reserved;
-
 	/*
 	 * when a new extent is allocated, it is just reserved in memory
 	 * The actual extent isn't inserted into the extent allocation tree
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a1febf155747..6cf4070fd45f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2497,9 +2497,6 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	/* Also free its reserved qgroup space */
-	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
-				      head->qgroup_reserved);
 	btrfs_delayed_ref_unlock(head);
 	btrfs_put_delayed_ref_head(head);
 	return 0;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c1fbd8a30fc4..f8e68b37916c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1540,12 +1540,18 @@ int btrfs_qgroup_trace_extent_nolock(struct btrfs_fs_info *fs_info,
 		parent_node = *p;
 		entry = rb_entry(parent_node, struct btrfs_qgroup_extent_record,
 				 node);
-		if (bytenr < entry->bytenr)
+		if (bytenr < entry->bytenr) {
 			p = &(*p)->rb_left;
-		else if (bytenr > entry->bytenr)
+		} else if (bytenr > entry->bytenr) {
 			p = &(*p)->rb_right;
-		else
+		} else {
+			if (record->data_rsv && !entry->data_rsv) {
+				entry->data_rsv = record->data_rsv;
+				entry->data_rsv_refroot =
+					record->data_rsv_refroot;
+			}
 			return 1;
+		}
 	}
 
 	rb_link_node(&record->node, parent_node, p);
@@ -1591,7 +1597,7 @@ int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)
 	    || bytenr == 0 || num_bytes == 0)
 		return 0;
-	record = kmalloc(sizeof(*record), gfp_flag);
+	record = kzalloc(sizeof(*record), gfp_flag);
 	if (!record)
 		return -ENOMEM;
 
@@ -2570,6 +2576,11 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 					goto cleanup;
 			}
 
+			/* Free the reserved data space */
+			btrfs_qgroup_free_refroot(fs_info,
+					record->data_rsv_refroot,
+					record->data_rsv,
+					BTRFS_QGROUP_RSV_DATA);
 			/*
 			 * Use SEQ_LAST as time_seq to do special search, which
 			 * doesn't lock tree or delayed_refs and search current
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index d8f78f5ab854..fd26fddacd90 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -45,6 +45,17 @@ struct btrfs_qgroup_extent_record {
 	struct rb_node node;
 	u64 bytenr;
 	u64 num_bytes;
+
+	/*
+	 * For qgroup reserved data space freeing.
+	 *
+	 * @data_rsv_refroot and @data_rsv will be recorded after
+	 * BTRFS_ADD_DELAYED_EXTENT is called.
+	 * And will be used to free reserved qgroup space at
+	 * transaction commit time.
+	 */
+	u32 data_rsv;		/* reserved data space needs to be freed */
+	u64 data_rsv_refroot;	/* which root the reserved data belongs to */
 	struct ulist *old_roots;
 };
 
@@ -252,15 +263,6 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 			       u64 ref_root, u64 num_bytes,
 			       enum btrfs_qgroup_rsv_type type);
-static inline void btrfs_qgroup_free_delayed_ref(struct btrfs_fs_info *fs_info,
-						 u64 ref_root, u64 num_bytes)
-{
-	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
-		return;
-	trace_btrfs_qgroup_free_delayed_ref(fs_info, ref_root, num_bytes);
-	btrfs_qgroup_free_refroot(fs_info, ref_root, num_bytes,
-				  BTRFS_QGROUP_RSV_DATA);
-}
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 8568946f491d..3a5d2581bffd 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1510,35 +1510,6 @@ DEFINE_EVENT(btrfs__qgroup_rsv_data, btrfs_qgroup_release_data,
 	TP_ARGS(inode, start, len, reserved, op)
 );
 
-DECLARE_EVENT_CLASS(btrfs__qgroup_delayed_ref,
-
-	TP_PROTO(const struct btrfs_fs_info *fs_info,
-		 u64 ref_root, u64 reserved),
-
-	TP_ARGS(fs_info, ref_root, reserved),
-
-	TP_STRUCT__entry_btrfs(
-		__field(	u64,		ref_root	)
-		__field(	u64,		reserved	)
-	),
-
-	TP_fast_assign_btrfs(fs_info,
-		__entry->ref_root	= ref_root;
-		__entry->reserved	= reserved;
-	),
-
-	TP_printk_btrfs("root=%llu reserved=%llu op=free",
-		  __entry->ref_root, __entry->reserved)
-);
-
-DEFINE_EVENT(btrfs__qgroup_delayed_ref, btrfs_qgroup_free_delayed_ref,
-
-	TP_PROTO(const struct btrfs_fs_info *fs_info,
-		 u64 ref_root, u64 reserved),
-
-	TP_ARGS(fs_info, ref_root, reserved)
-);
-
 DECLARE_EVENT_CLASS(btrfs_qgroup_extent,
 	TP_PROTO(const struct btrfs_fs_info *fs_info,
 		 const struct btrfs_qgroup_extent_record *rec),
-- 
2.19.1

