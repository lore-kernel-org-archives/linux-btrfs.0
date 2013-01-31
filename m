Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:44416 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab3AaQ21 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 11:28:27 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id eonpuyoOcc6aRtAE (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 09:28:26 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix freeing delayed ref head while still holding its mutex V2
Date: Thu, 31 Jan 2013 11:35:15 -0500
Message-ID: <1359650115-12743-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I hit this error when reproducing a bug that would end in a transaction
abort.  We take the delayed ref head's mutex to keep anybody from processing
it while we're destroying it, but we fail to drop the mutex before we carry
on and free the damned thing.  Fix this by doing the remove logic for the
head ourselves and unlock the mutex, that way we can avoid use after free's
or hung tasks waiting on that mutex to come back so they know the delayed
ref completed.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: don't duplicate the freeing stuff, just unlock if we have a head.

 fs/btrfs/disk-io.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 12ef591..42f83aa 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3615,11 +3615,11 @@ int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	}
 
 	while ((node = rb_first(&delayed_refs->root)) != NULL) {
-		ref = rb_entry(node, struct btrfs_delayed_ref_node, rb_node);
+		struct btrfs_delayed_ref_head *head = NULL;
 
+		ref = rb_entry(node, struct btrfs_delayed_ref_node, rb_node);
 		atomic_set(&ref->refs, 1);
 		if (btrfs_delayed_ref_is_head(ref)) {
-			struct btrfs_delayed_ref_head *head;
 
 			head = btrfs_delayed_node_to_head(ref);
 			if (!mutex_trylock(&head->mutex)) {
@@ -3641,10 +3641,12 @@ int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				delayed_refs->num_heads_ready--;
 			list_del_init(&head->cluster);
 		}
+
 		ref->in_tree = 0;
 		rb_erase(&ref->rb_node, &delayed_refs->root);
 		delayed_refs->num_entries--;
-
+		if (head)
+			mutex_unlock(&head->mutex);
 		spin_unlock(&delayed_refs->lock);
 		btrfs_put_delayed_ref(ref);
 
-- 
1.7.7.6

