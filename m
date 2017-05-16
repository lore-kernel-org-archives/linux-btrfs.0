Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42588 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752280AbdEPRG3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:06:29 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 57C0AAD23
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:06:27 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: use generic slab for for btrfs_transaction
Date: Tue, 16 May 2017 19:05:29 +0200
Message-Id: <20170516170529.5654-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Observing the number of slab objects of btrfs_transaction, there's just
one active on an almost quiescent filesystem, and the number of objects
goes to about ten when sync is in progress. Then the nubmer goes down to
1.  This matches the expectations of the transaction lifetime.

For such use the separate slab cache is not justified, as we do not
reuse objects frequently. For the shortlived transaction, the generic
slab (size 512) should be ok. We can optimistically expect that the 512
slabs are not all used (fragmentation) and there are free slots to take
when we do the allocation, compared to potentially allocating a whole new
page for the separate slab.

We'll lose the stats about the object use, which could be added later if
we really need them.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h       | 1 -
 fs/btrfs/disk-io.c     | 5 -----
 fs/btrfs/inode.c       | 8 --------
 fs/btrfs/transaction.c | 8 ++++----
 4 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 643c70d2b2e6..e507c9fcaf3e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -48,7 +48,6 @@ struct btrfs_trans_handle;
 struct btrfs_transaction;
 struct btrfs_pending_snapshot;
 extern struct kmem_cache *btrfs_trans_handle_cachep;
-extern struct kmem_cache *btrfs_transaction_cachep;
 extern struct kmem_cache *btrfs_bit_radix_cachep;
 extern struct kmem_cache *btrfs_path_cachep;
 extern struct kmem_cache *btrfs_free_space_cachep;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8685d67185d0..03ca0f77aec9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4576,11 +4576,6 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 
 	cur_trans->state =TRANS_STATE_COMPLETED;
 	wake_up(&cur_trans->commit_wait);
-
-	/*
-	memset(cur_trans, 0, sizeof(*cur_trans));
-	kmem_cache_free(btrfs_transaction_cachep, cur_trans);
-	*/
 }
 
 static int btrfs_cleanup_transaction(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 17cbe9306faf..cf9e3928fdca 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -86,7 +86,6 @@ static const struct extent_io_ops btrfs_extent_io_ops;
 
 static struct kmem_cache *btrfs_inode_cachep;
 struct kmem_cache *btrfs_trans_handle_cachep;
-struct kmem_cache *btrfs_transaction_cachep;
 struct kmem_cache *btrfs_path_cachep;
 struct kmem_cache *btrfs_free_space_cachep;
 
@@ -9514,7 +9513,6 @@ void btrfs_destroy_cachep(void)
 	rcu_barrier();
 	kmem_cache_destroy(btrfs_inode_cachep);
 	kmem_cache_destroy(btrfs_trans_handle_cachep);
-	kmem_cache_destroy(btrfs_transaction_cachep);
 	kmem_cache_destroy(btrfs_path_cachep);
 	kmem_cache_destroy(btrfs_free_space_cachep);
 }
@@ -9534,12 +9532,6 @@ int btrfs_init_cachep(void)
 	if (!btrfs_trans_handle_cachep)
 		goto fail;
 
-	btrfs_transaction_cachep = kmem_cache_create("btrfs_transaction",
-			sizeof(struct btrfs_transaction), 0,
-			SLAB_TEMPORARY | SLAB_MEM_SPREAD, NULL);
-	if (!btrfs_transaction_cachep)
-		goto fail;
-
 	btrfs_path_cachep = kmem_cache_create("btrfs_path",
 			sizeof(struct btrfs_path), 0,
 			SLAB_MEM_SPREAD, NULL);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2168654c90a1..edbcb1b48e96 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -93,7 +93,7 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
 			btrfs_put_block_group_trimming(cache);
 			btrfs_put_block_group(cache);
 		}
-		kmem_cache_free(btrfs_transaction_cachep, transaction);
+		kfree(transaction);
 	}
 }
 
@@ -228,7 +228,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	 */
 	BUG_ON(type == TRANS_JOIN_NOLOCK);
 
-	cur_trans = kmem_cache_alloc(btrfs_transaction_cachep, GFP_NOFS);
+	cur_trans = kmalloc(sizeof(*cur_trans), GFP_NOFS);
 	if (!cur_trans)
 		return -ENOMEM;
 
@@ -238,11 +238,11 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 		 * someone started a transaction after we unlocked.  Make sure
 		 * to redo the checks above
 		 */
-		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
+		kfree(cur_trans);
 		goto loop;
 	} else if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
 		spin_unlock(&fs_info->trans_lock);
-		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
+		kfree(cur_trans);
 		return -EROFS;
 	}
 
-- 
2.12.0

