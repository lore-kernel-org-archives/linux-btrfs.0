Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54331 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3FCUoU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 16:44:20 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id DBCF67C0434
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Jun 2013 14:44:19 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id eNFPXIPAUfBghWFI (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 03 Jun 2013 14:44:19 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not pin while under spin lock
Date: Mon, 3 Jun 2013 16:44:17 -0400
Message-ID: <1370292257-1591-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When testing a corrupted fs I noticed I was getting sleep while atomic errors
when the transaction aborted.  This is because btrfs_pin_extent may need to
allocate memory and we are calling this under the spin lock.  Fix this by moving
it out and doing the pin after dropping the spin lock but before dropping the
mutex, the same way it works when delayed refs run normally.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5d18997..15f31c7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3762,6 +3762,7 @@ int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 
 	while ((node = rb_first(&delayed_refs->root)) != NULL) {
 		struct btrfs_delayed_ref_head *head = NULL;
+		bool pin_bytes = false;
 
 		ref = rb_entry(node, struct btrfs_delayed_ref_node, rb_node);
 		atomic_set(&ref->refs, 1);
@@ -3782,8 +3783,7 @@ int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 			}
 
 			if (head->must_insert_reserved)
-				btrfs_pin_extent(root, ref->bytenr,
-						 ref->num_bytes, 1);
+				pin_bytes = true;
 			btrfs_free_delayed_extent_op(head->extent_op);
 			delayed_refs->num_heads--;
 			if (list_empty(&head->cluster))
@@ -3794,9 +3794,13 @@ int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 		ref->in_tree = 0;
 		rb_erase(&ref->rb_node, &delayed_refs->root);
 		delayed_refs->num_entries--;
-		if (head)
-			mutex_unlock(&head->mutex);
 		spin_unlock(&delayed_refs->lock);
+		if (head) {
+			if (pin_bytes)
+				btrfs_pin_extent(root, ref->bytenr,
+						 ref->num_bytes, 1);
+			mutex_unlock(&head->mutex);
+		}
 		btrfs_put_delayed_ref(ref);
 
 		cond_resched();
-- 
1.7.7.6

