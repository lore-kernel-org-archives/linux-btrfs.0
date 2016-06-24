Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbcFXWP3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:29 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0DEF3ADB1
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:27 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/31] btrfs: simpilify btrfs_subvol_inherit_props
Date: Fri, 24 Jun 2016 18:15:00 -0400
Message-Id: <1466806524-27508-8-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

We just need a superblock, but we look it up using two different
roots depending on the call site.  Let's just use a superblock
pointer initialized at the outset.

This is mostly for Coccinelle not to choke on my root push up set.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/props.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 3699212..cf0b444 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -350,6 +350,7 @@ int btrfs_subvol_inherit_props(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct btrfs_root *parent_root)
 {
+	struct super_block *sb = root->fs_info->sb;
 	struct btrfs_key key;
 	struct inode *parent_inode, *child_inode;
 	int ret;
@@ -358,12 +359,11 @@ int btrfs_subvol_inherit_props(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 
-	parent_inode = btrfs_iget(parent_root->fs_info->sb, &key,
-				  parent_root, NULL);
+	parent_inode = btrfs_iget(sb, &key, parent_root, NULL);
 	if (IS_ERR(parent_inode))
 		return PTR_ERR(parent_inode);
 
-	child_inode = btrfs_iget(root->fs_info->sb, &key, root, NULL);
+	child_inode = btrfs_iget(sb, &key, root, NULL);
 	if (IS_ERR(child_inode)) {
 		iput(parent_inode);
 		return PTR_ERR(child_inode);
-- 
2.7.1

