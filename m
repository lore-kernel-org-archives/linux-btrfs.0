Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59077 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab2FZDuP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 23:50:15 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Cc: <jbacik@fusionio.com>
Subject: [PATCH] Btrfs: fix wrong check during log recovery
Date: Tue, 26 Jun 2012 11:59:09 +0800
Message-Id: <1340683149-19940-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we're evicting an inode during log recovery, we need to ensure that the inode
is not in orphan state any more, which means inode's run_time flags has _no_
BTRFS_INODE_HAS_ORPHAN_ITEM.  Thus, the BUG_ON was triggered because of a wrong
check for the flags.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3f2c8cb..1e25847 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3754,7 +3754,7 @@ void btrfs_evict_inode(struct inode *inode)
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
 	if (root->fs_info->log_root_recovering) {
-		BUG_ON(!test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+		BUG_ON(test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 				 &BTRFS_I(inode)->runtime_flags));
 		goto no_delete;
 	}
-- 
1.6.5.2

