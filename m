Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:41274 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab3A3U7b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 15:59:31 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id wHXERsGCo3ZpjaFg (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 13:59:30 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix freeing delayed ref head while still holding its mutex
Date: Wed, 30 Jan 2013 16:06:18 -0500
Message-ID: <1359579978-2916-1-git-send-email-jbacik@fusionio.com>
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
 fs/btrfs/disk-io.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 12a9547..51bff86 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3640,10 +3640,15 @@ int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 			if (list_empty(&head->cluster))
 				delayed_refs->num_heads_ready--;
 			list_del_init(&head->cluster);
+			ref->in_tree = 0;
+			rb_erase(&ref->rb_node, &delayed_refs->root);
+			delayed_refs->num_entries--;
+			mutex_unlock(&head->mutex);
+		} else {
+			ref->in_tree = 0;
+			rb_erase(&ref->rb_node, &delayed_refs->root);
+			delayed_refs->num_entries--;
 		}
-		ref->in_tree = 0;
-		rb_erase(&ref->rb_node, &delayed_refs->root);
-		delayed_refs->num_entries--;
 
 		spin_unlock(&delayed_refs->lock);
 		btrfs_put_delayed_ref(ref);
-- 
1.7.7.6

