Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731251AbeGTPTG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 11:19:06 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 49821AD96
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 14:30:32 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: merge free_fs_root helpers
Date: Fri, 20 Jul 2018 16:30:25 +0200
Message-Id: <5dec751d7fc32ffda2e2fb9c00e0bab9244a90dc.1532096607.git.dsterba@suse.com>
In-Reply-To: <cover.1532096607.git.dsterba@suse.com>
References: <cover.1532096607.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The exported helper just calls the static one. There's no obvious reason
to have them separate eg. for performance reasons where the static one
could be better optimized in the same unit. There's a slight decrease in
code size and stack consumption.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c1d287a766c1..468365dd3b59 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -52,7 +52,6 @@
 
 static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
-static void free_fs_root(struct btrfs_root *root);
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_fs_info *fs_info);
@@ -1504,7 +1503,7 @@ int btrfs_init_fs_root(struct btrfs_root *root)
 
 	return 0;
 fail:
-	/* the caller is responsible to call free_fs_root */
+	/* the caller is responsible to call btrfs_free_fs_root */
 	return ret;
 }
 
@@ -1609,14 +1608,14 @@ struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
 	ret = btrfs_insert_fs_root(fs_info, root);
 	if (ret) {
 		if (ret == -EEXIST) {
-			free_fs_root(root);
+			btrfs_free_fs_root(root);
 			goto again;
 		}
 		goto fail;
 	}
 	return root;
 fail:
-	free_fs_root(root);
+	btrfs_free_fs_root(root);
 	return ERR_PTR(ret);
 }
 
@@ -3831,10 +3830,10 @@ void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
 		__btrfs_remove_free_space_cache(root->free_ino_pinned);
 	if (root->free_ino_ctl)
 		__btrfs_remove_free_space_cache(root->free_ino_ctl);
-	free_fs_root(root);
+	btrfs_free_fs_root(root);
 }
 
-static void free_fs_root(struct btrfs_root *root)
+void btrfs_free_fs_root(struct btrfs_root *root)
 {
 	iput(root->ino_cache_inode);
 	WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
@@ -3849,11 +3848,6 @@ static void free_fs_root(struct btrfs_root *root)
 	btrfs_put_fs_root(root);
 }
 
-void btrfs_free_fs_root(struct btrfs_root *root)
-{
-	free_fs_root(root);
-}
-
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)
 {
 	u64 root_objectid = 0;
-- 
2.18.0

