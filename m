From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] BTRFS: Remove unused node_lock
Date: Tue, 17 May 2011 17:11:22 -0700
Message-ID: <1305677482-17188-1-git-send-email-andi@firstfloor.org>
Cc: linux-btrfs@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Andi Kleen <ak@linux.intel.com>

240f62c8756 replaced the node_lock with rcu_read_lock, but forgot
to remove the actual lock in the data structure. Remove it here.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/btrfs/ctree.h   |    3 ---
 fs/btrfs/disk-io.c |    1 -
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8f4b81d..f290b98 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1088,9 +1088,6 @@ struct btrfs_fs_info {
 struct btrfs_root {
 	struct extent_buffer *node;
 
-	/* the node lock is held while changing the node pointer */
-	spinlock_t node_lock;
-
 	struct extent_buffer *commit_root;
 	struct btrfs_root *log_root;
 	struct btrfs_root *reloc_root;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 228cf36..64b2896 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1064,7 +1064,6 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	INIT_LIST_HEAD(&root->dirty_list);
 	INIT_LIST_HEAD(&root->orphan_list);
 	INIT_LIST_HEAD(&root->root_list);
-	spin_lock_init(&root->node_lock);
 	spin_lock_init(&root->orphan_lock);
 	spin_lock_init(&root->inode_lock);
 	spin_lock_init(&root->accounting_lock);
-- 
1.7.4.4

