Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab2EaPFJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 11:05:09 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4VF580i006883
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2012 11:05:08 -0400
Received: from localhost.localdomain.com (vpn-8-248.rdu.redhat.com [10.11.8.248])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q4VF58f7005296
	for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2012 11:05:08 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix locking in btrfs_destroy_delayed_refs
Date: Thu, 31 May 2012 11:05:07 -0400
Message-Id: <1338476707-5175-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The transaction abort stuff was throwing warnings from the list debugging
code because we do a list_del_init outside of the delayed_refs spin lock.
The delayed refs locking makes baby Jesus cry so it's not hard to get wrong,
but we need to take the ref head mutex to make sure it's not being processed
currently, and so if it is we need to drop the spin lock and then take and
drop the mutex and do the search again.  If we can take the mutex then we
can safely remove the head from the list and carry on.  Now when the
transaction aborts I don't get the list debugging warnings.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/disk-io.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b0d49e2..0224c25 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3395,7 +3395,6 @@ int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 
 	delayed_refs = &trans->delayed_refs;
 
-again:
 	spin_lock(&delayed_refs->lock);
 	if (delayed_refs->num_entries == 0) {
 		spin_unlock(&delayed_refs->lock);
@@ -3403,31 +3402,36 @@ again:
 		return ret;
 	}
 
-	node = rb_first(&delayed_refs->root);
-	while (node) {
+	while ((node = rb_first(&delayed_refs->root)) != NULL) {
 		ref = rb_entry(node, struct btrfs_delayed_ref_node, rb_node);
-		node = rb_next(node);
-
-		ref->in_tree = 0;
-		rb_erase(&ref->rb_node, &delayed_refs->root);
-		delayed_refs->num_entries--;
 
 		atomic_set(&ref->refs, 1);
 		if (btrfs_delayed_ref_is_head(ref)) {
 			struct btrfs_delayed_ref_head *head;
 
 			head = btrfs_delayed_node_to_head(ref);
-			spin_unlock(&delayed_refs->lock);
-			mutex_lock(&head->mutex);
+			if (!mutex_trylock(&head->mutex)) {
+				atomic_inc(&ref->refs);
+				spin_unlock(&delayed_refs->lock);
+
+				/* Need to wait for the delayed ref to run */
+				mutex_lock(&head->mutex);
+				mutex_unlock(&head->mutex);
+				btrfs_put_delayed_ref(ref);
+
+				continue;
+			}
+
 			kfree(head->extent_op);
 			delayed_refs->num_heads--;
 			if (list_empty(&head->cluster))
 				delayed_refs->num_heads_ready--;
 			list_del_init(&head->cluster);
-			mutex_unlock(&head->mutex);
-			btrfs_put_delayed_ref(ref);
-			goto again;
 		}
+		ref->in_tree = 0;
+		rb_erase(&ref->rb_node, &delayed_refs->root);
+		delayed_refs->num_entries--;
+
 		spin_unlock(&delayed_refs->lock);
 		btrfs_put_delayed_ref(ref);
 
-- 
1.7.7.6

