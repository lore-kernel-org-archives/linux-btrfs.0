Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:39721 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752227AbeEKH41 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:56:27 -0400
Received: by mail-pf0-f194.google.com with SMTP id a22-v6so2340414pfn.6
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 00:56:27 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 06/11] Btrfs: delete dead code in btrfs_orphan_commit_root()
Date: Fri, 11 May 2018 00:56:11 -0700
Message-Id: <49c85beed52a1a9cb350ae0e197aba8bc806682a.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

btrfs_orphan_commit_root() tries to delete an orphan item for a
subvolume in the tree root, but we don't actually insert that item in
the first place. See commit 0a0d4415e338 ("Btrfs: delete dead code in
btrfs_orphan_add()"). We can get rid of it.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e22f8c9f6459..6110387f0218 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3302,7 +3302,6 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_block_rsv *block_rsv;
-	int ret;
 
 	if (atomic_read(&root->orphan_inodes) ||
 	    root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE)
@@ -3323,17 +3322,6 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 	root->orphan_block_rsv = NULL;
 	spin_unlock(&root->orphan_lock);
 
-	if (test_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state) &&
-	    btrfs_root_refs(&root->root_item) > 0) {
-		ret = btrfs_del_orphan_item(trans, fs_info->tree_root,
-					    root->root_key.objectid);
-		if (ret)
-			btrfs_abort_transaction(trans, ret);
-		else
-			clear_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED,
-				  &root->state);
-	}
-
 	if (block_rsv) {
 		WARN_ON(block_rsv->size > 0);
 		btrfs_free_block_rsv(fs_info, block_rsv);
-- 
2.17.0

