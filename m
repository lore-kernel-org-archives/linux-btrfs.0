Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6406DC282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 14:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 363E22083B
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 14:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549290496;
	bh=AOQ8/gc7tASL8rPosrb6r0XqUzvUTatskHZ1PimALa4=;
	h=From:To:Subject:Date:List-ID:From;
	b=2DQGrtQLlNERdJosD9RGRDoC8fFgxkY4hVYRhopLmacEG7q80OGW1WRgMXVxfOHjq
	 MIxiO5pJKdSdf5CoZ6vmymXfN7JkQjIJ8AkrPvCf3kwcq0wOhtJxEGSV/9FCGX2wIu
	 YrcNKBdnNXHiJ0eQdChfz5LmX+xeHbkJkIoRsdfQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbfBDO2O (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 09:28:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbfBDO2O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Feb 2019 09:28:14 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67A2C2083B
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Feb 2019 14:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549290493;
        bh=AOQ8/gc7tASL8rPosrb6r0XqUzvUTatskHZ1PimALa4=;
        h=From:To:Subject:Date:From;
        b=SC/CbnvLU8JGQP/7rPabwu458t6eJLTIWgvjM4FplwY0aVzvuw7508Rh2XSb45dNk
         yq2gcndkUinuarrXN6NZJb3MCJFUo+2V/6ngobvZiuFTQbD2ncqw7HmCq/zzbbvrzX
         MqULEn9mS1Sx+52BauCm2PoJQv4ic/mI1nhAKkjE=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix file corruption after snapshotting
Date:   Mon,  4 Feb 2019 14:28:10 +0000
Message-Id: <20190204142810.1800-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When we are mixing buffered writes with direct IO writes against the same
file and snapshotting is happening concurrently, we can end up with a
corrupt file content in the snapshot. Example:

1) Inode/file is empty.

2) Snapshotting starts.

2) Buffered write at offset 0 length 256Kb. This updates the i_size of the
   inode to 256Kb, disk_i_size remains zero. This happens after the task
   doing the snapshot flushes all existing delalloc.

3) DIO write at offset 256Kb length 768Kb. Once the ordered extent
   completes it sets the inode's disk_i_size to 1Mb (256Kb + 768Kb) and
   updates the inode item in the fs tree with a size of 1Mb (which is
   the value of disk_i_size).

4) The dealloc for the range [0, 256Kb[ did not start yet.

5) The transaction used in the DIO ordered extent completion, which updated
   the inode item, is committed by the snapshotting task.

6) Snapshot creation completes.

7) Dealloc for the range [0, 256Kb[ is flushed.

After that when reading the file from the snapshot we always get zeroes for
the range [0, 256Kb[, the file has a size of 1Mb and the data written by
the direct IO write is found. From an application's point of view this is
a corruption, since in the source subvolume it could never read a version
of the file that included the data from the direct IO write without the
data from the buffered write included as well. In the snapshot's tree,
file extent items are missing for the range [0, 256Kb[.

The issue, obviously, does not happen when using the -o flushoncommit
mount option.

Fix this by flushing delalloc for all the roots that are about to be
snapshotted when committing a transaction. This guarantees total ordering
when updating the disk_i_size of an inode since the flush for dealloc is
done when a transaction is in the TRANS_STATE_COMMIT_START state and wait
is done once no more external writers exist. This is similar to what we
do when using the flushoncommit mount option, but we do it only if the
transaction has snapshots to create and only for the roots of the
subvolumes to be snapshotted. The bulk of the dealloc is flushed in the
snapshot creation ioctl, so the flush work we do inside the transaction
is minimized.

This issue, involving buffered and direct IO writes with snapshotting, is
often triggered by fstest btrfs/078, and got reported by fsck when not
using the NO_HOLES features, for example:

  $ cat results/btrfs/078.full
  (...)
  _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent
  *** fsck.btrfs output ***
  [1/7] checking root items
  [2/7] checking extents
  [3/7] checking free space cache
  [4/7] checking fs roots
  root 258 inode 264 errors 100, file extent discount
  Found file extent holes:
        start: 524288, len: 65536
  ERROR: errors found in fs roots

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4ec2b660d014..2e8f15eee2e8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1886,8 +1886,10 @@ static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
        }
 }
 
-static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
+static inline int btrfs_start_delalloc_flush(struct btrfs_trans_handle *trans)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+
 	/*
 	 * We use writeback_inodes_sb here because if we used
 	 * btrfs_start_delalloc_roots we would deadlock with fs freeze.
@@ -1897,15 +1899,37 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
 	 * from already being in a transaction and our join_transaction doesn't
 	 * have to re-take the fs freeze lock.
 	 */
-	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
+	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT)) {
 		writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
+	} else {
+		struct btrfs_pending_snapshot *pending;
+		struct list_head *head = &trans->transaction->pending_snapshots;
+
+		list_for_each_entry(pending, head, list) {
+			int ret;
+
+			ret = btrfs_start_delalloc_snapshot(pending->root);
+			if (ret)
+				return ret;
+		}
+	}
 	return 0;
 }
 
-static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
+static inline void btrfs_wait_delalloc_flush(struct btrfs_trans_handle *trans)
 {
-	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+
+	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT)) {
 		btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
+	} else {
+		struct btrfs_pending_snapshot *pending;
+		struct list_head *head = &trans->transaction->pending_snapshots;
+
+		list_for_each_entry(pending, head, list)
+			btrfs_wait_ordered_extents(pending->root,
+						   U64_MAX, 0, U64_MAX);
+	}
 }
 
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
@@ -2024,7 +2048,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	extwriter_counter_dec(cur_trans, trans->type);
 
-	ret = btrfs_start_delalloc_flush(fs_info);
+	ret = btrfs_start_delalloc_flush(trans);
 	if (ret)
 		goto cleanup_transaction;
 
@@ -2040,7 +2064,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	if (ret)
 		goto cleanup_transaction;
 
-	btrfs_wait_delalloc_flush(fs_info);
+	btrfs_wait_delalloc_flush(trans);
 
 	btrfs_scrub_pause(fs_info);
 	/*
-- 
2.11.0

