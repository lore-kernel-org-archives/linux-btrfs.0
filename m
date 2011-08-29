From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: set truncate block rsv's size
Date: Mon, 29 Aug 2011 11:02:45 -0400
Message-ID: <1314630165-13019-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While debugging a different issue I noticed that we were always reserving space
when we tried to use our truncate block rsv's.  This is because they didn't have
a ->size value, so use_block_rsv just assumes there is nothing reserved and it
does a reserve_metadata_bytes.  This is because btrfs_check_block_rsv() doesn't
actually add to the size of the block rsv.  That seems to be the right thing to
do so set ->size to the minimum truncate size we need, since we will always only
refill to that size anyway, and this way everything works out correctly.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6e79a76..0ee0677 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3557,6 +3557,7 @@ void btrfs_evict_inode(struct inode *inode)
 		btrfs_orphan_del(NULL, inode);
 		goto no_delete;
 	}
+	rsv->size = min_size;
 
 	btrfs_i_size_write(inode, 0);
 
@@ -6519,6 +6520,7 @@ static int btrfs_truncate(struct inode *inode)
 	rsv = btrfs_alloc_block_rsv(root);
 	if (!rsv)
 		return -ENOMEM;
+	rsv->size = min_size;
 
 	/*
 	 * 1 for the truncate slack space
-- 
1.7.5.2

