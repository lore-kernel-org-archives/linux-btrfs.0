Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:20047 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933579Ab2GLJnt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 05:43:49 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: [PATCH v1 05/15] Btrfs: check the root passed to btrfs_end_transaction
Date: Thu, 12 Jul 2012 11:43:37 +0200
Message-Id: <d13603ef6e14a12cd65a6975e8117c0fea7c7ddf.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

This patch only add a consistancy check to validate that the
same root is passed to start_transaction and end_transaction.
Subvolume quota depends on this.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/transaction.c |    6 ++++++
 fs/btrfs/transaction.h |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 621c8dc..23cbda0 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -345,6 +345,7 @@ again:
 	h->transaction = cur_trans;
 	h->blocks_used = 0;
 	h->bytes_reserved = 0;
+	h->root = root;
 	h->delayed_ref_updates = 0;
 	h->use_count = 1;
 	h->block_rsv = NULL;
@@ -511,6 +512,11 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
+	/*
+	 * the same root has to be passed to start_transaction and
+	 * end_transaction. Subvolume quota depends on this.
+	 */
+	WARN_ON(trans->root != root);
 	while (count < 2) {
 		unsigned long cur = trans->delayed_ref_updates;
 		trans->delayed_ref_updates = 0;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index fe27379..0107294 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -57,6 +57,12 @@ struct btrfs_trans_handle {
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_block_rsv *orig_rsv;
 	int aborted;
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

