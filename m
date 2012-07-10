Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63763 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754949Ab2GJLki (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 07:40:38 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q6ABHmaD004477
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2012 19:17:50 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs: fix btrfs_is_free_space_inode to recognize btree inode
Date: Tue, 10 Jul 2012 19:28:38 +0800
Message-Id: <1341919719-13825-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btree inode, its root is also 'tree root', so btree inode can be
misunderstood as a free space inode.

We should add one more check for btree inode.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 12394a9..b168238 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -194,8 +194,10 @@ static inline void btrfs_i_size_write(struct inode *inode, u64 size)
 static inline bool btrfs_is_free_space_inode(struct btrfs_root *root,
 				       struct inode *inode)
 {
-	if (root == root->fs_info->tree_root ||
-	    BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID)
+	if (root == root->fs_info->tree_root &&
+	    btrfs_ino(inode) != BTRFS_BTREE_INODE_OBJECTID)
+		return true;
+	if (BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID)
 		return true;
 	return false;
 }
-- 
1.6.5.2

