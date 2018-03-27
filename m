Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52224 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbeC0HTn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:19:43 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F3100B045
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 07:19:41 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 08/10] btrfs-progs: Drop ext_ref arument from check_fs_root
Date: Tue, 27 Mar 2018 10:19:30 +0300
Message-Id: <1522135172-8276-9-git-send-email-nborisov@suse.com>
In-Reply-To: <1522135172-8276-1-git-send-email-nborisov@suse.com>
References: <1522135172-8276-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's no longer used so just remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/mode-lowmem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index daa088c056b6..eb6ca6453dc5 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4342,12 +4342,11 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
  * Iterate all items in the tree and call check_inode_item() to check.
  *
  * @root:	the root of the tree to be checked.
- * @ext_ref:	the EXTENDED_IREF feature
  *
  * Return 0 if no error found.
  * Return <0 for error.
  */
-static int check_fs_root(struct btrfs_root *root, unsigned int ext_ref)
+static int check_fs_root(struct btrfs_root *root)
 {
 	reset_cached_block_groups(root->fs_info);
 	return check_btrfs_root(NULL, root, 0);
@@ -4503,7 +4502,7 @@ int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info)
 				goto next;
 			}
 
-			ret = check_fs_root(cur_root, ext_ref);
+			ret = check_fs_root(cur_root);
 			err |= ret;
 
 			if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
-- 
2.7.4

