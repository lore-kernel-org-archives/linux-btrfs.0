From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: delay iput when deleting a block group
Date: Mon, 19 Sep 2011 12:27:03 -0400
Message-ID: <1316449623-10514-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I kept getting warnings from evict because we were calling
btrfs_start_transaction() with a transaction already started when doing a
balance.  This is because we remove a block group which requires a transaction,
and the put the last reference on the cache inode.  Instead of doing this we
need to delay the iput so it is done not within a transaction having started.
This gets rid of our warnings.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9bb7159..5498bda 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7266,7 +7266,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			spin_unlock(&block_group->lock);
 		}
 		/* One for our lookup ref */
-		iput(inode);
+		btrfs_add_delayed_iput(inode);
 	}
 
 	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
-- 
1.7.5.2

