Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752086AbeC0HTn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:19:43 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B0FE3B049
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 07:19:42 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 07/10] btrfs-progs: Drop ext_ref param from check_fs_first_inode
Date: Tue, 27 Mar 2018 10:19:29 +0300
Message-Id: <1522135172-8276-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1522135172-8276-1-git-send-email-nborisov@suse.com>
References: <1522135172-8276-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's no longer used in that function so can be dropped altogether.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/mode-lowmem.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 76365a214e34..daa088c056b6 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4263,7 +4263,6 @@ static int check_fs_first_inode(struct btrfs_root *root)
  * blocks and integrity of fs tree items.
  *
  * @root:         the root of the tree to be checked.
- * @ext_ref       feature EXTENDED_IREF is enable or not.
  * @account       if NOT 0 means check the tree (including tree)'s treeblocks.
  *                otherwise means check fs tree(s) items relationship and
  *		  @root MUST be a fs tree root.
@@ -4271,8 +4270,7 @@ static int check_fs_first_inode(struct btrfs_root *root)
  * Returns not 0  represents error.
  */
 static int check_btrfs_root(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, unsigned int ext_ref,
-			    int check_all)
+			    struct btrfs_root *root, int check_all)
 {
 	struct btrfs_path path;
 	struct node_refs nrefs;
@@ -4352,7 +4350,7 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
 static int check_fs_root(struct btrfs_root *root, unsigned int ext_ref)
 {
 	reset_cached_block_groups(root->fs_info);
-	return check_btrfs_root(NULL, root, ext_ref, 0);
+	return check_btrfs_root(NULL, root, 0);
 }
 
 /*
@@ -4556,11 +4554,11 @@ int check_chunks_and_extents_lowmem(struct btrfs_fs_info *fs_info)
 	}
 
 	root1 = root->fs_info->chunk_root;
-	ret = check_btrfs_root(trans, root1, 0, 1);
+	ret = check_btrfs_root(trans, root1, 1);
 	err |= ret;
 
 	root1 = root->fs_info->tree_root;
-	ret = check_btrfs_root(trans, root1, 0, 1);
+	ret = check_btrfs_root(trans, root1, 1);
 	err |= ret;
 
 	btrfs_init_path(&path);
@@ -4591,7 +4589,7 @@ int check_chunks_and_extents_lowmem(struct btrfs_fs_info *fs_info)
 			goto next;
 		}
 
-		ret = check_btrfs_root(trans, cur_root, 0, 1);
+		ret = check_btrfs_root(trans, cur_root, 1);
 		err |= ret;
 
 		if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
-- 
2.7.4

