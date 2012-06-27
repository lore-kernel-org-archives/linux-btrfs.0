Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:12974 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757759Ab2F0RZB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 13:25:01 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/7] Btrfs: avoid waiting for delayed refs when we must not
Date: Wed, 27 Jun 2012 19:24:53 +0200
Message-Id: <1340817899-16343-2-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We track two conditions to decide if we should sleep while waiting for more
delayed refs, the number of delayed refs (num_refs) and the first entry in
the list of blockers (first_seq).

When we suspect staleness, we save num_refs and do one more cycle. If
nothing changes, we then save first_seq for later comparison and do
wait_event. We ought to save first_seq the very same moment we're saving
num_refs. Otherwise we cannot be sure that nothing has changed and we might
start waiting when we shouldn't, which could lead to starvation.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/extent-tree.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4b5a1e1..6e1d367 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2347,12 +2347,10 @@ next:
 	return count;
 }
 
-
 static void wait_for_more_refs(struct btrfs_delayed_ref_root *delayed_refs,
-			unsigned long num_refs)
+			       unsigned long num_refs,
+			       struct list_head *first_seq)
 {
-	struct list_head *first_seq = delayed_refs->seq_head.next;
-
 	spin_unlock(&delayed_refs->lock);
 	pr_debug("waiting for more refs (num %ld, first %p)\n",
 		 num_refs, first_seq);
@@ -2381,6 +2379,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_delayed_ref_node *ref;
 	struct list_head cluster;
+	struct list_head *first_seq = NULL;
 	int ret;
 	u64 delayed_start;
 	int run_all = count == (unsigned long)-1;
@@ -2436,8 +2435,10 @@ again:
 				 */
 				consider_waiting = 1;
 				num_refs = delayed_refs->num_entries;
+				first_seq = root->fs_info->tree_mod_seq_list.next;
 			} else {
-				wait_for_more_refs(delayed_refs, num_refs);
+				wait_for_more_refs(delayed_refs,
+						   num_refs, first_seq);
 				/*
 				 * after waiting, things have changed. we
 				 * dropped the lock and someone else might have
-- 
1.7.3.4

