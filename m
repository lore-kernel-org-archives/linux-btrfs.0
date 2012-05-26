Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:44233 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab2EZK7w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 06:59:52 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 15/15] Btrfs: tree mod log sanity checks in join_transaction
Date: Sat, 26 May 2012 12:59:49 +0200
Message-Id: <50fa8efa6226c2debd85da7982a7c32623e436fd.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
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

