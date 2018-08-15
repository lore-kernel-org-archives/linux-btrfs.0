Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56234 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728670AbeHOKbE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 06:31:04 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 40EDEAED4
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 07:40:00 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/3] btrfs: Factor out ref head locking code in __btrfs_run_delayed_refs
Date: Wed, 15 Aug 2018 10:39:54 +0300
Message-Id: <1534318796-23111-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1534318796-23111-1-git-send-email-nborisov@suse.com>
References: <1534318796-23111-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is in preparation to refactor the giant loop in
__btrfs_run_delayed_refs. As a first step define a new function
which implements acquiring a reference to a btrfs_delayed_refs_head and
use it. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 54 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index de6f75f5547b..6a2c86c8a756 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2502,6 +2502,40 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+STATIC
+struct btrfs_delayed_ref_head *btrfs_obtain_ref_head(
+					struct btrfs_trans_handle *trans)
+{
+	struct btrfs_delayed_ref_root *delayed_refs =
+		&trans->transaction->delayed_refs;
+	struct btrfs_delayed_ref_head *head = NULL;
+	int ret;
+
+	spin_lock(&delayed_refs->lock);
+	head = btrfs_select_ref_head(trans);
+	if (!head) {
+		spin_unlock(&delayed_refs->lock);
+		return head;
+	}
+
+	/*
+	 * grab the lock that says we are going to process  all the refs for
+	 * this head
+	 */
+	ret = btrfs_delayed_ref_lock(trans, head);
+	spin_unlock(&delayed_refs->lock);
+	/*
+	 * we may have dropped the spin lock to get the head
+	 * mutex lock, and that might have given someone else
+	 * time to free the head.  If that's true, it has been
+	 * removed from our list and we can move on.
+	 */
+	if (ret == -EAGAIN)
+		head = ERR_PTR(-EAGAIN);
+
+	return head;
+}
+
 /*
  * Returns 0 on success or if called with an already aborted transaction.
  * Returns -ENOMEM or -EIO on failure and will abort the transaction.
@@ -2526,24 +2560,10 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			if (count >= nr)
 				break;
 
-			spin_lock(&delayed_refs->lock);
-			locked_ref = btrfs_select_ref_head(trans);
-			if (!locked_ref) {
-				spin_unlock(&delayed_refs->lock);
+			locked_ref = btrfs_obtain_ref_head(trans);
+			if (!locked_ref)
 				break;
-			}
-
-			/* grab the lock that says we are going to process
-			 * all the refs for this head */
-			ret = btrfs_delayed_ref_lock(trans, locked_ref);
-			spin_unlock(&delayed_refs->lock);
-			/*
-			 * we may have dropped the spin lock to get the head
-			 * mutex lock, and that might have given someone else
-			 * time to free the head.  If that's true, it has been
-			 * removed from our list and we can move on.
-			 */
-			if (ret == -EAGAIN) {
+			else if (PTR_ERR(locked_ref) == -EAGAIN) {
 				locked_ref = NULL;
 				count++;
 				continue;
-- 
2.7.4
