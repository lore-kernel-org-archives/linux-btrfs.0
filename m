From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] Btrfs: swap order of two spinlocks (lockdep complains)
Date: Tue, 24 Apr 2012 16:02:09 +0200
Message-ID: <1335276129-2059-1-git-send-email-sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

may_commit_transaction() calls
        spin_lock(&space_info->lock);
        spin_lock(&delayed_rsv->lock);
and update_global_block_rsv() calls
        spin_lock(&block_rsv->lock);
        spin_lock(&sinfo->lock);

Lockdep complains about this at run time.
Everywhere except in update_global_block_rsv(), the space_info lock is
the outer lock, therefore the locking order in update_global_block_rsv()
is changed.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/extent-tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 84497f8..6fc2e6f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4214,8 +4214,8 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 
 	num_bytes = calc_global_metadata_size(fs_info);
 
-	spin_lock(&block_rsv->lock);
 	spin_lock(&sinfo->lock);
+	spin_lock(&block_rsv->lock);
 
 	block_rsv->size = num_bytes;
 
@@ -4241,8 +4241,8 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 		block_rsv->full = 1;
 	}
 
-	spin_unlock(&sinfo->lock);
 	spin_unlock(&block_rsv->lock);
+	spin_unlock(&sinfo->lock);
 }
 
 static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
-- 
1.7.10

