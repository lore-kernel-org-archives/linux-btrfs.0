Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56807 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754901AbeCHOfu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:35:50 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 40B9AAE22
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:35:49 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 10/22] btrfs: drop fs_info parameter from tree_mod_log_free_eb
Date: Thu,  8 Mar 2018 15:33:29 +0100
Message-Id: <c9868cf8e34fd3d526bc20916dee616e3b932d7f.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's provided by the extent_buffer.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6d2f8562bb36..632beadf5725 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -654,12 +654,10 @@ __tree_mod_log_free_eb(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-static noinline int
-tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
-			 struct extent_buffer *old_root,
-			 struct extent_buffer *new_root,
-			 int log_removal)
+static noinline int tree_mod_log_insert_root(struct extent_buffer *old_root,
+			 struct extent_buffer *new_root, int log_removal)
 {
+	struct btrfs_fs_info *fs_info = old_root->fs_info;
 	struct tree_mod_elem *tm = NULL;
 	struct tree_mod_elem **tm_list = NULL;
 	int nritems = 0;
@@ -932,8 +930,7 @@ tree_mod_log_set_root_pointer(struct btrfs_root *root,
 			      int log_removal)
 {
 	int ret;
-	ret = tree_mod_log_insert_root(root->fs_info, root->node,
-				       new_root_node, log_removal);
+	ret = tree_mod_log_insert_root(root->node, new_root_node, log_removal);
 	BUG_ON(ret < 0);
 }
 
-- 
2.16.2

