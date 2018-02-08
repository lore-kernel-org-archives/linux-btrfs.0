Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750929AbeBHQZY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Feb 2018 11:25:24 -0500
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: Document consistency of transaction->io_bgs list
Date: Thu,  8 Feb 2018 18:25:18 +0200
Message-Id: <1518107118-15137-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1518107118-15137-1-git-send-email-nborisov@suse.com>
References: <1518107118-15137-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The reason why io_bgs can be modified without holding any lock is
non-obvious. Document it and reference that documentation from the
respective call sites

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c     |  4 ++++
 fs/btrfs/extent-tree.c |  7 ++++++-
 fs/btrfs/transaction.h | 15 +++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1b3989c54d7c..b6fc734b0f5c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4342,6 +4342,10 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
 	}
 	spin_unlock(&cur_trans->dirty_bgs_lock);
 
+
+	/* Refer to the definition of io_bgs member for details why it's safe
+	 * to use it without any locking
+	 */
 	while (!list_empty(&cur_trans->io_bgs)) {
 		cache = list_first_entry(&cur_trans->io_bgs,
 					 struct btrfs_block_group_cache,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index cc08e6af3542..c4a3dfac224a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3742,7 +3742,8 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans,
 
 				/*
 				 * the cache_write_mutex is protecting
-				 * the io_list
+				 * the io_list, also refer to the definition of
+				 * btrfs_transaction::io_bfs for more details
 				 */
 				list_add_tail(&cache->io_list, io);
 			} else {
@@ -3934,6 +3935,10 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 	}
 	spin_unlock(&cur_trans->dirty_bgs_lock);
 
+
+	/* Refer to the definition of io_bgs member for details why it's safe
+	 * to use it without any locking
+	 */
 	while (!list_empty(io)) {
 		cache = list_first_entry(io, struct btrfs_block_group_cache,
 					 io_list);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 817fd7c9836b..90b80a6bea66 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -69,6 +69,21 @@ struct btrfs_transaction {
 	struct list_head pending_chunks;
 	struct list_head switch_commits;
 	struct list_head dirty_bgs;
+
+	/* There is no explicit lock which protects io_bgs, rather its
+	 * consistency is implied by the fact that all the sites which modify
+	 * it do so under some form of transaction critical section, namely:
+	 *
+	 * * btrfs_start_dirty_block_groups - This function can only ever be
+	 * run by one of the transaction committers. Refer to
+	 * BTRFS_TRANS_DIRTY_BG_RUN usage in btrfs_commit_transaction
+	 *
+	 * * btrfs_write_dirty_blockgroups - this is called by
+	 * commit_cowonly_roots from transaction critical section
+	 * (TRANS_STATE_COMMIT_DOING)
+	 *
+	 * * btrfs_cleanup_dirty_bgs - called on transaction abort
+	 */
 	struct list_head io_bgs;
 	struct list_head dropped_roots;
 
-- 
2.7.4

