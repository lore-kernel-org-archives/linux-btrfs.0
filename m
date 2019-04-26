Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FDCC43219
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 12:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DEC0206C1
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 12:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfDZMBt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 08:01:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:56992 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726012AbfDZMBt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 08:01:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 03576AF19
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2019 12:01:46 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Make the critical section of will_be_snapshotted and snapshot_force_cow smaller
Date:   Fri, 26 Apr 2019 20:01:40 +0800
Message-Id: <20190426120140.5956-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Btrfs uses btrfs_root::will_be_snapshotted and
btrfs_root::snapshot_force_cow to control data space reservation and
delalloc for NODATACOW/COW switch.

To be more specific:

                   /------------------------ inc(will_be_snapshotted)
                   |                     /-- inc(snapshot_force_cow)
-------------------|---------------------|---------------
reserve: NOCOW     | reserve: COW        | reserve: COW
delalloc: NOCOW    | delalloc: NOCOW     | delalloc: COW

They combined together ensure btrfs data NOCOW cooperate with
snapshot creation, and no data reservation underflow.
- No data written into shared extents
  This is ensured by snapshot_force_cow, as with it set, all
  NOCOW delalloc range will be forced back to COW.

- No data reserved space underflow
  This is ensured by will_be_snapshot and snapshot_force_cow sequence.

Normally, we use the following call sequence:
  atomic_inc(&root->will_be_snapshotted)
  smp_mb__after_atomic();
  wait_event(root->subv_writers->wait,
  	     percpu_counter_sum(&root->subv_writers->coutner) == 0;
  btrfs_start_delalloc_snapshot(root);
  atomic_inc(&root->snapshot_force_cow);

And such calls happens in create_snapshot().

However since commit 09e804d771f ("Btrfs: fix file corruption after
snapshotting due to mix of buffered/DIO writes"), we also call
btrfs_start_delalloc_snapstho() in btrfs_start_delalloc_flush().

This means we can make the critical section smaller, instead of doing
above call sequence in the ioctl context, we reuse the
btrfs_start_delalloc_snapshot() in btrfs_start_delalloc_flush() in the
transaction commit context.

So old call critical section will be changed from:

/-------- snapshot ioctl
|    /- inc will_be/force_cow and call start_delalloc_snapshot()
|    |     /- btrfs_start_transaction()
|    |     |                        /- btrfs_commit_transaction()
|    |     |                        |  /- dec will_be/force_cow
|----|/////|///////////////////////////|-----| <- ioctl return

To new one:

/-------- snapshot ioctl
|    /- inc will_be/force_cow and call start_delalloc_snapshot()
|    |     /- btrfs_start_transaction()
|    |     |                        /- btrfs_commit_transaction()
|    |     |                        |  /- dec will_be/force_cow
|----|-----|--|//////////////////|--|--|-----| <- ioctl return
              |                  |
              |                  \- create_pending_snapshot() return
              \- btrfs_start_delalloc_flush()

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ioctl.c       | 31 +-------------------------
 fs/btrfs/transaction.c | 50 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 44 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8c9a908d3acc..d41e8b6aa36f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -766,7 +766,6 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	struct btrfs_pending_snapshot *pending_snapshot;
 	struct btrfs_trans_handle *trans;
 	int ret;
-	bool snapshot_force_cow = false;
 
 	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		return -EINVAL;
@@ -789,29 +788,6 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 		goto free_pending;
 	}
 
-	/*
-	 * Force new buffered writes to reserve space even when NOCOW is
-	 * possible. This is to avoid later writeback (running dealloc) to
-	 * fallback to COW mode and unexpectedly fail with ENOSPC.
-	 */
-	atomic_inc(&root->will_be_snapshotted);
-	smp_mb__after_atomic();
-	/* wait for no snapshot writes */
-	wait_event(root->subv_writers->wait,
-		   percpu_counter_sum(&root->subv_writers->counter) == 0);
-
-	ret = btrfs_start_delalloc_snapshot(root);
-	if (ret)
-		goto dec_and_free;
-
-	/*
-	 * All previous writes have started writeback in NOCOW mode, so now
-	 * we force future writes to fallback to COW mode during snapshot
-	 * creation.
-	 */
-	atomic_inc(&root->snapshot_force_cow);
-	snapshot_force_cow = true;
-
 	btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
 
 	btrfs_init_block_rsv(&pending_snapshot->block_rsv,
@@ -828,7 +804,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 					&pending_snapshot->block_rsv, 8,
 					false);
 	if (ret)
-		goto dec_and_free;
+		goto free_pending;
 
 	pending_snapshot->dentry = dentry;
 	pending_snapshot->root = root;
@@ -875,11 +851,6 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	ret = 0;
 fail:
 	btrfs_subvolume_release_metadata(fs_info, &pending_snapshot->block_rsv);
-dec_and_free:
-	if (snapshot_force_cow)
-		atomic_dec(&root->snapshot_force_cow);
-	if (atomic_dec_and_test(&root->will_be_snapshotted))
-		wake_up_var(&root->will_be_snapshotted);
 free_pending:
 	kfree(pending_snapshot->root_item);
 	btrfs_free_path(pending_snapshot->path);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3f6811cdf803..67fb520fed9b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1605,6 +1605,9 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	}
 
 fail:
+	if (atomic_dec_and_test(&root->will_be_snapshotted))
+		wake_up_var(&root->will_be_snapshotted);
+	atomic_dec(&root->snapshot_force_cow);
 	pending->error = ret;
 dir_item_existed:
 	trans->block_rsv = rsv;
@@ -1852,6 +1855,10 @@ static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
 static inline int btrfs_start_delalloc_flush(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_pending_snapshot *last_fail;
+	struct btrfs_pending_snapshot *pending;
+	struct list_head *head = &trans->transaction->pending_snapshots;
+	int ret = 0;
 
 	/*
 	 * We use writeback_inodes_sb here because if we used
@@ -1865,8 +1872,6 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_trans_handle *trans)
 	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT)) {
 		writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
 	} else {
-		struct btrfs_pending_snapshot *pending;
-		struct list_head *head = &trans->transaction->pending_snapshots;
 
 		/*
 		 * Flush dellaloc for any root that is going to be snapshotted.
@@ -1876,14 +1881,45 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_trans_handle *trans)
 		 * the inode's size on disk.
 		 */
 		list_for_each_entry(pending, head, list) {
-			int ret;
-
-			ret = btrfs_start_delalloc_snapshot(pending->root);
-			if (ret)
-				return ret;
+			struct btrfs_root *root = pending->root;
+
+			/*
+			 * Force new buffered writes to reserve space even
+			 * when NOCOW is possible. This is to avoid later
+			 * writeback (running dealloc) to fallback to COW mode
+			 * and unexpectedly fail with ENOSPC.
+			 */
+			atomic_inc(&root->will_be_snapshotted);
+			smp_mb__after_atomic();
+			/* wait for no snapshot writes */
+			wait_event(root->subv_writers->wait,
+				   percpu_counter_sum(&root->subv_writers->counter) == 0);
+			ret = btrfs_start_delalloc_snapshot(root);
+			if (ret) {
+				atomic_dec(&root->will_be_snapshotted);
+				last_fail = pending;
+				goto cleanup;
+			}
+			/*
+			 * All previous writes have started writeback in NOCOW
+			 * mode, so now we force future writes to fallback
+			 * to COW mode during snapshot creation.
+			 */
+			atomic_inc(&root->snapshot_force_cow);
 		}
 	}
 	return 0;
+cleanup:
+	list_for_each_entry(pending, head, list) {
+		struct btrfs_root *root = pending->root;
+
+		if (pending == last_fail)
+			break;
+		if (atomic_dec_and_test(&root->will_be_snapshotted))
+			wake_up_var(&root->will_be_snapshotted);
+		atomic_dec(&root->snapshot_force_cow);
+	}
+	return ret;
 }
 
 static inline void btrfs_wait_delalloc_flush(struct btrfs_trans_handle *trans)
-- 
2.21.0

