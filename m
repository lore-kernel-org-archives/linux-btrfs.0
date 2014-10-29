Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:49607 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756147AbaJ2IV6 (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Wed, 29 Oct 2014 04:21:58 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v3] Btrfs: fix snapshot inconsistency after a file write followed by truncate
Date: Wed, 29 Oct 2014 08:21:12 +0000
Message-Id: <1414570872-20666-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1413886363-12442-1-git-send-email-fdmanana@suse.com>
References: <1413886363-12442-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If right after starting the snapshot creation ioctl we perform a write against a
file followed by a truncate, with both operations increasing the file's size, we
can get a snapshot tree that reflects a state of the source subvolume's tree where
the file truncation happened but the write operation didn't. This leaves a gap
between 2 file extent items of the inode, which makes btrfs' fsck complain about it.

For example, if we perform the following file operations:

    $ mkfs.btrfs -f /dev/vdd
    $ mount /dev/vdd /mnt
    $ xfs_io -f \
          -c "pwrite -S 0xaa -b 32K 0 32K" \
          -c "fsync" \
          -c "pwrite -S 0xbb -b 32770 16K 32770" \
          -c "truncate 90123" \
          /mnt/foobar

and the snapshot creation ioctl was just called before the second write, we often
can get the following inode items in the snapshot's btree:

        item 120 key (257 INODE_ITEM 0) itemoff 7987 itemsize 160
                inode generation 146 transid 7 size 90123 block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0 flags 0x0
        item 121 key (257 INODE_REF 256) itemoff 7967 itemsize 20
                inode ref index 282 namelen 10 name: foobar
        item 122 key (257 EXTENT_DATA 0) itemoff 7914 itemsize 53
                extent data disk byte 1104855040 nr 32768
                extent data offset 0 nr 32768 ram 32768
                extent compression 0
        item 123 key (257 EXTENT_DATA 53248) itemoff 7861 itemsize 53
                extent data disk byte 0 nr 0
                extent data offset 0 nr 40960 ram 40960
                extent compression 0

There's a file range, corresponding to the interval [32K; ALIGN(16K + 32770, 4096)[
for which there's no file extent item covering it. This is because the file write
and file truncate operations happened both right after the snapshot creation ioctl
called btrfs_start_delalloc_inodes(), which means we didn't start and wait for the
ordered extent that matches the write and, in btrfs_setsize(), we were able to call
btrfs_cont_expand() before being able to commit the current transaction in the
snapshot creation ioctl. So this made it possibe to insert the hole file extent
item in the source subvolume (which represents the region added by the truncate)
right before the transaction commit from the snapshot creation ioctl.

Btrfs' fsck tool complains about such cases with a message like the following:

    "root 331 inode 257 errors 100, file extent discount"

>From a user perspective, the expectation when a snapshot is created while those
file operations are being performed is that the snapshot will have a file that
either:

1) is empty
2) only the first write was captured
3) only the 2 writes were captured
4) both writes and the truncation were captured

But never capture a state where only the first write and the truncation were
captured (since the second write was performed before the truncation).

A test case for xfstests follows.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Use different approach to solve the problem. Don't start and wait for all
    dellaloc to finish after every expanding truncate, instead add an additional
    flush at transaction commit time if we're doing a transaction commit that
    creates snapshots.

V3: Removed useless test condition in +wait_pending_snapshot_roots_delalloc().

 fs/btrfs/transaction.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 396ae8b..5e7f004 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1714,12 +1714,65 @@ static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
 		btrfs_wait_ordered_roots(fs_info, -1);
 }
 
+static int
+start_pending_snapshot_roots_delalloc(struct btrfs_trans_handle *trans,
+				      struct list_head *splice)
+{
+	struct btrfs_pending_snapshot *pending_snapshot;
+	int ret = 0;
+
+	if (btrfs_test_opt(trans->root, FLUSHONCOMMIT))
+		return 0;
+
+	spin_lock(&trans->root->fs_info->trans_lock);
+	list_splice_init(&trans->transaction->pending_snapshots, splice);
+	spin_unlock(&trans->root->fs_info->trans_lock);
+
+	/*
+	 * Start again delalloc for the roots our pending snapshots are made
+	 * from. We did it before starting/joining a transaction and we do it
+	 * here again because new inode operations might have happened since
+	 * then and we want to make sure the snapshot captures a fully
+	 * consistent state of the source root tree. For example, if after the
+	 * first delalloc flush a write is made against an inode followed by
+	 * an expanding truncate, we want to make sure the snapshot captured
+	 * both the write and the truncation, and not just the truncation.
+	 * Here we shouldn't have much delalloc work to do, as the bulk of it
+	 * was done before and outside the transaction.
+	 */
+	list_for_each_entry(pending_snapshot, splice, list) {
+		ret = btrfs_start_delalloc_inodes(pending_snapshot->root, 1);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static void
+wait_pending_snapshot_roots_delalloc(struct btrfs_trans_handle *trans,
+				     struct list_head *splice)
+{
+	struct btrfs_pending_snapshot *pending_snapshot;
+
+	if (list_empty(splice))
+		return;
+
+	list_for_each_entry(pending_snapshot, splice, list)
+		btrfs_wait_ordered_extents(pending_snapshot->root, -1);
+
+	spin_lock(&trans->root->fs_info->trans_lock);
+	list_splice_init(splice, &trans->transaction->pending_snapshots);
+	spin_unlock(&trans->root->fs_info->trans_lock);
+}
+
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_transaction *prev_trans = NULL;
 	struct btrfs_inode *btree_ino = BTRFS_I(root->fs_info->btree_inode);
+	LIST_HEAD(pending_snapshots);
 	int ret;
 
 	/* Stop the commit early if ->aborted is set */
@@ -1802,6 +1855,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto cleanup_transaction;
 
+	ret = start_pending_snapshot_roots_delalloc(trans, &pending_snapshots);
+	if (ret)
+		goto cleanup_transaction;
+
 	ret = btrfs_run_delayed_items(trans, root);
 	if (ret)
 		goto cleanup_transaction;
@@ -1816,6 +1873,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_wait_delalloc_flush(root->fs_info);
 
+	wait_pending_snapshot_roots_delalloc(trans, &pending_snapshots);
+
 	btrfs_scrub_pause(root);
 	/*
 	 * Ok now we need to make sure to block out any other joins while we
-- 
1.9.1

