From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix panic when trying to destroy a newly allocated
	inode
Date: Fri, 16 Oct 2009 12:08:55 -0400
Message-ID: <20091016160854.GA4779@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cjb@laptop.org, chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There is a problem where iget5_locked will look for an inode, not find it, and
then subsequently try to allocate it.  Another CPU will have raced in and
allocated the inode instead, so when iget5_locked gets the inode spin lock again
and does a search, it finds the new inode.  So it goes ahead and calls
destroy_inode on the inode it just allocated.  The problem is we don't set
BTRFS_I(inode)->root until the new inode is completely initialized.  This patch
makes us set root to NULL when alloc'ing a new inode, so when we get to
btrfs_destroy_inode and we see that root is NULL we can just free up the memory
and continue on.  This fixes the panic

http://www.kerneloops.org/submitresult.php?number=812690

Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 78139ef..f69e5e0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5128,6 +5128,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->logged_trans = 0;
 	ei->outstanding_extents = 0;
 	ei->reserved_extents = 0;
+	ei->root = NULL;
 	spin_lock_init(&ei->accounting_lock);
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
 	INIT_LIST_HEAD(&ei->i_orphan);
@@ -5144,6 +5145,14 @@ void btrfs_destroy_inode(struct inode *inode)
 	WARN_ON(inode->i_data.nrpages);
 
 	/*
+	 * This can happen where we create an inode, but somebody else also
+	 * created the same inode and we need to destroy the one we already
+	 * created.
+	 */
+	if (!root)
+		goto free;
+
+	/*
 	 * Make sure we're properly removed from the ordered operation
 	 * lists.
 	 */
@@ -5178,6 +5187,7 @@ void btrfs_destroy_inode(struct inode *inode)
 	}
 	inode_tree_del(inode);
 	btrfs_drop_extent_cache(inode, 0, (u64)-1, 0);
+free:
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
 }
 
-- 
1.6.2.5

