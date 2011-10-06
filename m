From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v0 06/18] btrfs: check the root passed to btrfs_end_transaction
Date: Thu,  6 Oct 2011 17:54:16 +0200
Message-ID: <117b50417e344cb59abdd69977f56a7427e2dd51.1317915010.git.sensille@gmx.net>
References: <cover.1317915010.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

This patch only add a consistancy check to validate that the
same root is passed to start_transaction and end_transaction.
Subvolume quota depends on this.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/transaction.c |    6 ++++++
 fs/btrfs/transaction.h |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b5ee16b..d7f32da 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -306,6 +306,7 @@ again:
 	h->transaction = cur_trans;
 	h->blocks_used = 0;
 	h->bytes_reserved = 0;
+	h->root = root;
 	h->delayed_ref_updates = 0;
 	h->use_count = 1;
 	h->block_rsv = NULL;
@@ -453,6 +454,11 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
+	/*
+	 * the same root has to be passed to start_transaction and
+	 * end_transaction. Subvolume quota depends on this.
+	 */
+	WARN_ON(trans->root != root);
 	while (count < 4) {
 		unsigned long cur = trans->delayed_ref_updates;
 		trans->delayed_ref_updates = 0;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 02564e6..b120126 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -55,6 +55,12 @@ struct btrfs_trans_handle {
 	struct btrfs_transaction *transaction;
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_block_rsv *orig_rsv;
+	/*
+	 * this root is only needed to validate that the root passed to
+	 * start_transaction is the same as the one passed to end_transaction.
+	 * Subvolume quota depends on this
+	 */
+	struct btrfs_root *root;
 };
 
 struct btrfs_pending_snapshot {
-- 
1.7.3.4

