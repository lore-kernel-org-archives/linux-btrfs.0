Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbbKJRzi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 12:55:38 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 70760AD06
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2015 17:55:16 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/3] btrfs: preallocate path for snapshot creation at ioctl time
Date: Tue, 10 Nov 2015 18:54:03 +0100
Message-Id: <9f263bcb56ab8edb01a1951ecdaa4d12d3b1eba0.1447177256.git.dsterba@suse.com>
In-Reply-To: <cover.1447177256.git.dsterba@suse.com>
References: <cover.1447177256.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can also preallocate btrfs_path that's used during pending snapshot
creation and avoid another late ENOMEM failure.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c       | 4 +++-
 fs/btrfs/transaction.c | 9 ++++-----
 fs/btrfs/transaction.h | 1 +
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 040faa8eebc9..d318971d3085 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -661,7 +661,8 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 
 	pending_snapshot->root_item = kzalloc(sizeof(struct btrfs_root_item),
 			GFP_NOFS);
-	if (!pending_snapshot->root_item) {
+	pending_snapshot->path = btrfs_alloc_path();
+	if (!pending_snapshot->root_item || !pending_snapshot->path) {
 		ret = -ENOMEM;
 		goto free_pending;
 	}
@@ -747,6 +748,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 		wake_up_atomic_t(&root->will_be_snapshoted);
 free_pending:
 	kfree(pending_snapshot->root_item);
+	btrfs_free_path(pending_snapshot->path);
 	kfree(pending_snapshot);
 
 	return ret;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 09129b65dd4b..732ad46bf015 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1314,11 +1314,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	u64 root_flags;
 	uuid_le new_uuid;
 
-	path = btrfs_alloc_path();
-	if (!path) {
-		pending->error = -ENOMEM;
-		return 0;
-	}
+	ASSERT(pending->path);
+	path = pending->path;
 
 	ASSERT(pending->root_item);
 	new_root_item = pending->root_item;
@@ -1556,6 +1553,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	kfree(new_root_item);
 	pending->root_item = NULL;
 	btrfs_free_path(path);
+	pending->path = NULL;
+
 	return ret;
 }
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index a4e1c1a40880..9c94344fe204 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -141,6 +141,7 @@ struct btrfs_pending_snapshot {
 	struct btrfs_root_item *root_item;
 	struct btrfs_root *snap;
 	struct btrfs_qgroup_inherit *inherit;
+	struct btrfs_path *path;
 	/* block reservation for the operation */
 	struct btrfs_block_rsv block_rsv;
 	u64 qgroup_reserved;
-- 
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
