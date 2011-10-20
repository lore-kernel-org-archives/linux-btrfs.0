From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: add a missing block_rsv reset
Date: Thu, 20 Oct 2011 17:25:18 +0800
Message-ID: <1319102718-17767-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <josef@redhat.com>, <chb@muc.de>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In commit ab1ca99b51df63901617b9f10f9a36d5d4972d78
(Btrfs: reset to appropriate block rsv after orphan operations),
we miss a block_rsv reset and this sometimes leads us to
the WARNING of btrfs_orphan_commit_root().

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 41ac927..d96815c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -199,8 +199,10 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 	ret = btrfs_block_rsv_check(trans, root,
 				    root->orphan_block_rsv,
 				    0, 5);
-	if (ret)
+	if (ret) {
+		trans->block_rsv = rsv;
 		return ret;
+	}
 
 	oldsize = i_size_read(inode);
 	btrfs_i_size_write(inode, 0);
-- 
1.6.5.2

