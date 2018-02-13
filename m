Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964950AbeBMOQy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 09:16:54 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BAB77ADAC
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 14:16:52 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: Refactor running of delayed inode items during transaction commit
Date: Tue, 13 Feb 2018 16:16:49 +0200
Message-Id: <1518531409-31625-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1518531409-31625-1-git-send-email-nborisov@suse.com>
References: <1518531409-31625-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently calls to btrfs_run_delayed_inode items have been scattered
around the transaction commit code with no real design argument when they 
should be execute.

We have one call, after transaction writers go to 0. Then we have the delayed
items running as part of creating a snapshot (once per pedning snapshot).
Finally, delayed items are run once more _after_ snapshots have been created.
All in all this amounts to 2 + N (N = number of snapshots slated for creation).
In reality we need to flush delayed items once before
create_pending_snapshots is called to ensure snapshosts are consistent with
inode data and once after snapshots are created so that newly introduced inode 
items during snapshot creation process are correctly persisted on disk. This 
patch brings the total executions of run_delayed_items to just 2. 

This survived multiple xfstest runs. 

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 02bc1e6212e6..b32d3136f36c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1524,18 +1524,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 
-	/*
-	 * pull in the delayed directory update
-	 * and the delayed inode item
-	 * otherwise we corrupt the FS during
-	 * snapshot
-	 */
-	ret = btrfs_run_delayed_items(trans);
-	if (ret) {	/* Transaction aborted */
-		btrfs_abort_transaction(trans, ret);
-		goto fail;
-	}
-
 	record_root_in_trans(trans, root, 0);
 	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
@@ -2069,10 +2057,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	wait_event(cur_trans->writer_wait,
 		   extwriter_counter_read(cur_trans) == 0);
 
-	/* some pending stuffs might be added after the previous flush. */
-	ret = btrfs_run_delayed_items(trans);
-	if (ret)
-		goto cleanup_transaction;
 
 	btrfs_wait_delalloc_flush(fs_info);
 
@@ -2095,6 +2079,16 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		ret = cur_trans->aborted;
 		goto scrub_continue;
 	}
+
+	/*
+	 * Run delayed items because we need them to be consistent on-disk
+	 * so that snapshots created in create_pending_snapshots don't corrupt
+	 * the filesystem. At this point we are the one doing transaction
+	 * commit and now one can come and introduce new delayed inode items
+	 */
+	ret = btrfs_run_delayed_items(trans);
+	if (ret)
+		goto scrub_continue;
 	/*
 	 * the reloc mutex makes sure that we stop
 	 * the balancing code from coming in and moving
@@ -2102,11 +2096,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 */
 	mutex_lock(&fs_info->reloc_mutex);
 
-	/*
-	 * We needn't worry about the delayed items because we will
-	 * deal with them in create_pending_snapshot(), which is the
-	 * core function of the snapshot creation.
-	 */
 	ret = create_pending_snapshots(trans);
 	if (ret) {
 		mutex_unlock(&fs_info->reloc_mutex);
-- 
2.7.4

