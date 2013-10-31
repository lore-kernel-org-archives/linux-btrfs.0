Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:43386 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab3JaOKw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Oct 2013 10:10:52 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 576FB9A06B1
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Oct 2013 08:10:52 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id 2iQ8YbKgSt7crRo4 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 31 Oct 2013 08:10:51 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: stop committing the transaction so much during relocate
Date: Thu, 31 Oct 2013 10:10:49 -0400
Message-ID: <1383228649-15818-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed with my horrible snapshot excercisor that we were taking forever to
relocate the larger the file system got.  This appeared to be because we were
committing the transaction _constantly_.  There were a few places where we do
braindead things with metadata reservation, like start a transaction and then
try to refill the block rsv, which not only keeps us from committing a
transaction during the enospc stuff, but keeps us from doing some of the harder
flushing work which will make us more likely to need to commit the transaction.
We also were checking the block rsv and committing the transaction if the block
rsv was below a certain threshold, but we were doing this in a place where we
don't actually keep anything in the block rsv so this was always ending up false
so we always committed the transaction in this case.  I tested this to make sure
it didn't break anything, but it takes about 10 hours to get the box to this
state so I don't know how much of an impact it will really make.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/relocation.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 729c91e..92eb483 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2060,7 +2060,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 	LIST_HEAD(inode_list);
 	struct btrfs_key key;
 	struct btrfs_key next_key;
-	struct btrfs_trans_handle *trans;
+	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_root *reloc_root;
 	struct btrfs_root_item *root_item;
 	struct btrfs_path *path;
@@ -2109,18 +2109,19 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 	memset(&next_key, 0, sizeof(next_key));
 
 	while (1) {
-		trans = btrfs_start_transaction(root, 0);
-		BUG_ON(IS_ERR(trans));
-		trans->block_rsv = rc->block_rsv;
-
 		ret = btrfs_block_rsv_refill(root, rc->block_rsv, min_reserved,
 					     BTRFS_RESERVE_FLUSH_ALL);
 		if (ret) {
-			BUG_ON(ret != -EAGAIN);
-			ret = btrfs_commit_transaction(trans, root);
-			BUG_ON(ret);
-			continue;
+			err = ret;
+			goto out;
+		}
+		trans = btrfs_start_transaction(root, 0);
+		if (IS_ERR(trans)) {
+			err = PTR_ERR(trans);
+			trans = NULL;
+			goto out;
 		}
+		trans->block_rsv = rc->block_rsv;
 
 		replaced = 0;
 		max_level = level;
@@ -2166,6 +2167,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 		root_item->drop_level = level;
 
 		btrfs_end_transaction_throttle(trans, root);
+		trans = NULL;
 
 		btrfs_btree_balance_dirty(root);
 
@@ -2194,7 +2196,8 @@ out:
 		btrfs_update_reloc_root(trans, root);
 	}
 
-	btrfs_end_transaction_throttle(trans, root);
+	if (trans)
+		btrfs_end_transaction_throttle(trans, root);
 
 	btrfs_btree_balance_dirty(root);
 
@@ -3994,16 +3997,6 @@ restart:
 			}
 		}
 
-		ret = btrfs_block_rsv_check(rc->extent_root, rc->block_rsv, 5);
-		if (ret < 0) {
-			if (ret != -ENOSPC) {
-				err = ret;
-				WARN_ON(1);
-				break;
-			}
-			rc->commit_transaction = 1;
-		}
-
 		if (rc->commit_transaction) {
 			rc->commit_transaction = 0;
 			ret = btrfs_commit_transaction(trans, rc->extent_root);
-- 
1.8.3.1

