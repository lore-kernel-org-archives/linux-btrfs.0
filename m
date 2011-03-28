From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't warn in btrfs_add_orphan
Date: Mon, 28 Mar 2011 09:43:25 -0400
Message-ID: <1301319805-24556-1-git-send-email-josef@redhat.com>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When I moved the orphan adding to btrfs_truncate I missed the fact that during
orphan cleanup we just add the orphan items to the orphan list without going
through btrfs_orphan_add, which results in lots of warnings on mount if you have
any orphan items that need to be truncated.  Just remove this warning since it's
ok, this will allow all of the normal space accounting take place.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e010000..160d2a5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2212,8 +2212,6 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 			insert = 1;
 #endif
 		insert = 1;
-	} else {
-		WARN_ON(!BTRFS_I(inode)->orphan_meta_reserved);
 	}
 
 	if (!BTRFS_I(inode)->orphan_meta_reserved) {
-- 
1.7.2.3

