Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42104 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752386AbdKTUZA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 15:25:00 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 77C79AD98
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 20:24:59 +0000 (UTC)
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: btrfs_inode_log_parent should use defined inode_only values.
Date: Mon, 20 Nov 2017 13:24:47 -0700
Message-Id: <20171120202449.22947-2-enadolski@suse.com>
In-Reply-To: <20171120202449.22947-1-enadolski@suse.com>
References: <20171120202449.22947-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace hardcoded numeric argument values for inode_only with the
constants defined for that use.

Signed-off-by: Edmund Nadolski <enadolski@suse.com>
---
 fs/btrfs/tree-log.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1f79405..95cff91 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5403,11 +5403,10 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 				  struct dentry *parent,
 				  const loff_t start,
 				  const loff_t end,
-				  int exists_only,
+				  int inode_only,
 				  struct btrfs_log_ctx *ctx)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	int inode_only = exists_only ? LOG_INODE_EXISTS : LOG_INODE_ALL;
 	struct super_block *sb;
 	struct dentry *old_parent = NULL;
 	int ret = 0;
@@ -5573,7 +5572,7 @@ int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
 	int ret;
 
 	ret = btrfs_log_inode_parent(trans, root, BTRFS_I(d_inode(dentry)),
-			parent, start, end, 0, ctx);
+			parent, start, end, LOG_INODE_ALL, ctx);
 	dput(parent);
 
 	return ret;
@@ -5836,6 +5835,6 @@ int btrfs_log_new_name(struct btrfs_trans_handle *trans,
 		return 0;
 
 	return btrfs_log_inode_parent(trans, root, inode, parent, 0,
-				      LLONG_MAX, 1, NULL);
+				      LLONG_MAX, LOG_INODE_EXISTS, NULL);
 }
 
-- 
2.10.2

