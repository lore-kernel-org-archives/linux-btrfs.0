Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbbKJRzf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 12:55:35 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3A5FCACB5
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2015 17:55:13 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/3] btrfs: allocate root item at snapshot ioctl time
Date: Tue, 10 Nov 2015 18:54:00 +0100
Message-Id: <df7bb4de0c195b9314b9d0256038a955f791eb31.1447177256.git.dsterba@suse.com>
In-Reply-To: <cover.1447177256.git.dsterba@suse.com>
References: <cover.1447177256.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The actual snapshot creation is delayed until transaction commit. If we
cannot get enough memory for the root item there, we have to fail the
whole transaction commit which is bad. So we'll allocate the memory at
the ioctl call and pass it along with the pending_snapshot struct. The
potential ENOMEM will be returned to the caller of snapshot ioctl.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c       | 9 +++++++++
 fs/btrfs/transaction.c | 9 +++------
 fs/btrfs/transaction.h | 1 +
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bf7d8ba7dd00..040faa8eebc9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -659,6 +659,13 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	if (!pending_snapshot)
 		return -ENOMEM;
 
+	pending_snapshot->root_item = kzalloc(sizeof(struct btrfs_root_item),
+			GFP_NOFS);
+	if (!pending_snapshot->root_item) {
+		ret = -ENOMEM;
+		goto free_pending;
+	}
+
 	atomic_inc(&root->will_be_snapshoted);
 	smp_mb__after_atomic();
 	btrfs_wait_for_no_snapshoting_writes(root);
@@ -738,6 +745,8 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 dec_and_free:
 	if (atomic_dec_and_test(&root->will_be_snapshoted))
 		wake_up_atomic_t(&root->will_be_snapshoted);
+free_pending:
+	kfree(pending_snapshot->root_item);
 	kfree(pending_snapshot);
 
 	return ret;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a5b06442f0bf..09129b65dd4b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1320,11 +1320,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	new_root_item = kmalloc(sizeof(*new_root_item), GFP_NOFS);
-	if (!new_root_item) {
-		pending->error = -ENOMEM;
-		goto root_item_alloc_fail;
-	}
+	ASSERT(pending->root_item);
+	new_root_item = pending->root_item;
 
 	pending->error = btrfs_find_free_objectid(tree_root, &objectid);
 	if (pending->error)
@@ -1557,7 +1554,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_clear_skip_qgroup(trans);
 no_free_objectid:
 	kfree(new_root_item);
-root_item_alloc_fail:
+	pending->root_item = NULL;
 	btrfs_free_path(path);
 	return ret;
 }
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index a994bb097ee5..a4e1c1a40880 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -138,6 +138,7 @@ struct btrfs_pending_snapshot {
 	struct dentry *dentry;
 	struct inode *dir;
 	struct btrfs_root *root;
+	struct btrfs_root_item *root_item;
 	struct btrfs_root *snap;
 	struct btrfs_qgroup_inherit *inherit;
 	/* block reservation for the operation */
-- 
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
