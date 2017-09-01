Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26802 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752605AbdIAXQT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 19:16:19 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v81NGFdl028355
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v81NGFlP026134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:15 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v81NGFnj028562
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:15 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: avoid wake_up if possible
Date: Fri,  1 Sep 2017 16:14:27 -0600
Message-Id: <20170901221430.10131-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

wake_up() will go to check whether someone is on the waiting list with
holding spin_lock().

Around some btrfs code, we don't check waitqueue_active() firstly, so
the spin_lock() pair in wake_up() is called even if no one is waiting
on the queue.

There are more wake_up()s without waitqueue_active(), but these two
are the hottest one I've run into so far.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c    | 9 ++++++++-
 fs/btrfs/ordered-data.c | 8 +++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 825fad6..e2dc042 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -536,8 +536,15 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 	clear_state_cb(tree, state, bits);
 	add_extent_changeset(state, bits_to_clear, changeset, 0);
 	state->state &= ~bits_to_clear;
-	if (wake)
+
+	assert_spin_locked(&tree->lock);
+	/*
+	 * spin_lock is acquired by both waker and waiter, thus no
+	 * need to restrict the order.
+	 **/
+	if (wake && waitqueue_active(&state->wq))
 		wake_up(&state->wq);
+
 	if (state->state == 0) {
 		next = next_state(state);
 		if (extent_state_in_tree(state)) {
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a3aca49..e439fb4 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -647,7 +647,13 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 		spin_unlock(&fs_info->ordered_root_lock);
 	}
 	spin_unlock(&root->ordered_extent_lock);
-	wake_up(&entry->wait);
+
+	/*
+	 * setting flag is protected by spin_lock pair, which has a
+	 * implicit memory barrier.
+	 */
+	if (waitqueue_active(&entry->wait))
+		wake_up(&entry->wait);
 }
 
 static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
-- 
2.9.4

