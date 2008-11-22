From: Sage Weil <sage@newdream.net>
Subject: [PATCH] btrfs: remove unneeded total_trans
Date: Fri, 21 Nov 2008 21:44:06 -0800
Message-ID: <1227332647-1501-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Remove unneeded debugging sanity check.  It gets corrupted anyway when
multiple btrfs file systems are mounted, throwing bad warnings along the
way.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/transaction.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c2c3b42..c38f6a0 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -28,7 +28,6 @@
 #include "ref-cache.h"
 #include "tree-log.h"
 
-static int total_trans = 0;
 extern struct kmem_cache *btrfs_trans_handle_cachep;
 extern struct kmem_cache *btrfs_transaction_cachep;
 
@@ -39,8 +38,6 @@ static noinline void put_transaction(struct btrfs_transaction *transaction)
 	WARN_ON(transaction->use_count == 0);
 	transaction->use_count--;
 	if (transaction->use_count == 0) {
-		WARN_ON(total_trans == 0);
-		total_trans--;
 		list_del_init(&transaction->list);
 		memset(transaction, 0, sizeof(*transaction));
 		kmem_cache_free(btrfs_transaction_cachep, transaction);
@@ -57,7 +54,6 @@ static noinline int join_transaction(struct btrfs_root *root)
 	if (!cur_trans) {
 		cur_trans = kmem_cache_alloc(btrfs_transaction_cachep,
 					     GFP_NOFS);
-		total_trans++;
 		BUG_ON(!cur_trans);
 		root->fs_info->generation++;
 		root->fs_info->last_alloc = 0;
-- 
1.5.6.5

