From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't panic if orphan item already exists
Date: Tue, 13 Dec 2011 12:55:51 -0500
Message-ID: <1323798951-4329-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been hitting this BUG_ON() in btrfs_orphan_add when running xfstest 269 in
a loop.  This is because we will add an orphan item, do the truncate, the
truncate will fail for whatever reason (*cough*ENOSPC*cough*) and then we're
left with an orphan item still in the fs.  Then we come back later to do another
truncate and it blows up because we already have an orphan item.  This is ok so
just fix the BUG_ON() to only BUG() if ret is not EEXIST.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ae5b354a..76e6c24 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2047,7 +2047,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	/* insert an orphan item to track this unlinked/truncated file */
 	if (insert >= 1) {
 		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
-		BUG_ON(ret);
+		BUG_ON(ret && ret != -EEXIST);
 	}
 
 	/* insert an orphan item to track subvolume contains orphan files */
-- 
1.7.5.2

