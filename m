Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab3LMKIb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 05:08:31 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBDA8SPq008940
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 18:08:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] Btrfs: cleanup code of btrfs_balance_delayed_items()
Date: Fri, 13 Dec 2013 18:09:38 +0800
Message-Id: <1386929381-3483-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1386929381-3483-1-git-send-email-miaox@cn.fujitsu.com>
References: <1386929381-3483-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- move the condition check for wait into a function
- use wait_event_interruptible instead of prepare-schedule-finish process

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/delayed-inode.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index bb101b0..5229106 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1349,52 +1349,40 @@ void btrfs_assert_delayed_root_empty(struct btrfs_root *root)
 	WARN_ON(btrfs_first_delayed_node(delayed_root));
 }
 
-static int refs_newer(struct btrfs_delayed_root *delayed_root,
-		      int seq, int count)
+static int could_end_wait(struct btrfs_delayed_root *delayed_root, int seq)
 {
 	int val = atomic_read(&delayed_root->items_seq);
 
-	if (val < seq || val >= seq + count)
+	if (val < seq || val >= seq + BTRFS_DELAYED_BATCH)
 		return 1;
+
+	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND)
+		return 1;
+
 	return 0;
 }
 
 void btrfs_balance_delayed_items(struct btrfs_root *root)
 {
 	struct btrfs_delayed_root *delayed_root;
-	int seq;
 
 	delayed_root = btrfs_get_delayed_root(root);
 
 	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND)
 		return;
 
-	seq = atomic_read(&delayed_root->items_seq);
-
 	if (atomic_read(&delayed_root->items) >= BTRFS_DELAYED_WRITEBACK) {
+		int seq;
 		int ret;
-		DEFINE_WAIT(__wait);
+
+		seq = atomic_read(&delayed_root->items_seq);
 
 		ret = btrfs_wq_run_delayed_node(delayed_root, root, 0);
 		if (ret)
 			return;
 
-		while (1) {
-			prepare_to_wait(&delayed_root->wait, &__wait,
-					TASK_INTERRUPTIBLE);
-
-			if (refs_newer(delayed_root, seq,
-				       BTRFS_DELAYED_BATCH) ||
-			    atomic_read(&delayed_root->items) <
-			    BTRFS_DELAYED_BACKGROUND) {
-				break;
-			}
-			if (!signal_pending(current))
-				schedule();
-			else
-				break;
-		}
-		finish_wait(&delayed_root->wait, &__wait);
+		wait_event_interruptible(delayed_root->wait,
+					 could_end_wait(delayed_root, seq));
 		return;
 	}
 
-- 
1.8.3.1

