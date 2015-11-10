Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbbKJRzb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 12:55:31 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CA8ACACB5
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2015 17:55:09 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/3] btrfs: do an allocation earlier during snapshot creation
Date: Tue, 10 Nov 2015 18:53:56 +0100
Message-Id: <f5f6b6ba10a5b97fd6950e30f188cbfd9b7e3493.1447177256.git.dsterba@suse.com>
In-Reply-To: <cover.1447177256.git.dsterba@suse.com>
References: <cover.1447177256.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can allocate pending_snapshot earlier and do not have to do cleanup
in case of failure.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8d20f3b1cab0..bf7d8ba7dd00 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -655,22 +655,20 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		return -EINVAL;
 
+	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_NOFS);
+	if (!pending_snapshot)
+		return -ENOMEM;
+
 	atomic_inc(&root->will_be_snapshoted);
 	smp_mb__after_atomic();
 	btrfs_wait_for_no_snapshoting_writes(root);
 
 	ret = btrfs_start_delalloc_inodes(root, 0);
 	if (ret)
-		goto out;
+		goto dec_and_free;
 
 	btrfs_wait_ordered_extents(root, -1);
 
-	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_NOFS);
-	if (!pending_snapshot) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	btrfs_init_block_rsv(&pending_snapshot->block_rsv,
 			     BTRFS_BLOCK_RSV_TEMP);
 	/*
@@ -686,7 +684,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 					&pending_snapshot->qgroup_reserved,
 					false);
 	if (ret)
-		goto free;
+		goto dec_and_free;
 
 	pending_snapshot->dentry = dentry;
 	pending_snapshot->root = root;
@@ -737,11 +735,11 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	btrfs_subvolume_release_metadata(BTRFS_I(dir)->root,
 					 &pending_snapshot->block_rsv,
 					 pending_snapshot->qgroup_reserved);
-free:
-	kfree(pending_snapshot);
-out:
+dec_and_free:
 	if (atomic_dec_and_test(&root->will_be_snapshoted))
 		wake_up_atomic_t(&root->will_be_snapshoted);
+	kfree(pending_snapshot);
+
 	return ret;
 }
 
-- 
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
