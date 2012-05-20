Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:33911 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab2ETQGh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:37 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 12/24] Btrfs: tree mod log sanity checks in join_transaction
Date: Sun, 20 May 2012 18:06:23 +0200
Message-Id: <93804b3b6dc9712542947e65e255d972edcc011c.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a fresh transaction begins, the tree mod log must be clean. Users of
the tree modification log must ensure they never span across transaction
boundaries.

We reset the sequence to 0 in this safe situation to make absolutely sure
overflow can't happen.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/transaction.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index eb2bd82..3f50cba 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -122,6 +122,15 @@ loop:
 	cur_trans->delayed_refs.flushing = 0;
 	cur_trans->delayed_refs.run_delayed_start = 0;
 	cur_trans->delayed_refs.seq = 1;
+
+	/*
+	 * although the tree mod log is per file system and not per transaction,
+	 * the log must never go across transaction boundaries.
+	 */
+	BUG_ON(!list_empty(&fs_info->tree_mod_seq_list));
+	BUG_ON(!RB_EMPTY_ROOT(&fs_info->tree_mod_log));
+	atomic_set(&fs_info->tree_mod_seq, 0);
+
 	init_waitqueue_head(&cur_trans->delayed_refs.seq_wait);
 	spin_lock_init(&cur_trans->commit_lock);
 	spin_lock_init(&cur_trans->delayed_refs.lock);
-- 
1.7.3.4

