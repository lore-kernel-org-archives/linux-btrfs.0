Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:49048 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727762AbeILDIK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 23:08:10 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not wait after queue async work for delaye refs
Date: Wed, 12 Sep 2018 06:06:27 +0800
Message-Id: <1536703587-94565-8-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If metadata space is hungry, how fast flush_space() can run determines
the latency we spend in reserve_metadata_space().

flush_space()
   case FLUSH_DELAYED_ITEMS:
      ...
      btrfs_end_transaction()
   case ALLOC_CHUNK:
      ...
      btrfs_end_transaction()

btrfs_end_transaction()
   btrfs_async_run_delayed_refs()
       // queue a work to process delayed refs
       ...
       if (wait)
           wait_for_completion()

Although processing delayed refs can add to pinned bytes, pinned bytes
can only be used after committing transaction, so waiting async in
flush_space() doesn't help.

In fact we don't have to wait for asynchronous delayed refs processing
as delayed refs are not blocking the subsequent operations(unless within
committing transaction we need to make sure filesystem is consistent).

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/extent-tree.c | 18 ++----------------
 fs/btrfs/inode.c       |  2 +-
 fs/btrfs/transaction.c |  3 +--
 4 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 00e506de70ba..4c3a733ee4cf 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2620,7 +2620,7 @@ void btrfs_dec_block_group_reservations(struct btrfs_fs_info *fs_info,
 int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			   unsigned long count);
 int btrfs_async_run_delayed_refs(struct btrfs_fs_info *fs_info,
-				 unsigned long count, u64 transid, int wait);
+				 unsigned long count, u64 transid);
 int btrfs_lookup_data_extent(struct btrfs_fs_info *fs_info, u64 start, u64 len);
 int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info, u64 bytenr,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b6767f9031b5..cac9a9d04d0c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2852,14 +2852,11 @@ static void delayed_ref_async_start(struct btrfs_work *work)
 	if (ret && !async->error)
 		async->error = ret;
 done:
-	if (async->sync)
-		complete(&async->wait);
-	else
-		kfree(async);
+	kfree(async);
 }
 
 int btrfs_async_run_delayed_refs(struct btrfs_fs_info *fs_info,
-				 unsigned long count, u64 transid, int wait)
+				 unsigned long count, u64 transid)
 {
 	struct async_delayed_refs *async;
 	int ret;
@@ -2872,23 +2869,12 @@ int btrfs_async_run_delayed_refs(struct btrfs_fs_info *fs_info,
 	async->count = count;
 	async->error = 0;
 	async->transid = transid;
-	if (wait)
-		async->sync = 1;
-	else
-		async->sync = 0;
-	init_completion(&async->wait);
 
 	btrfs_init_work(&async->work, btrfs_extent_refs_helper,
 			delayed_ref_async_start, NULL, NULL);
 
 	btrfs_queue_work(fs_info->extent_workers, &async->work);
 
-	if (wait) {
-		wait_for_completion(&async->wait);
-		ret = async->error;
-		kfree(async);
-		return ret;
-	}
 	return 0;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 99ab0203b701..fd4af54f0d3b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4736,7 +4736,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			if (btrfs_should_throttle_delayed_refs(trans, fs_info))
 				btrfs_async_run_delayed_refs(fs_info,
 					trans->delayed_ref_updates * 2,
-					trans->transid, 0);
+					trans->transid);
 			if (be_nice) {
 				if (truncate_space_check(trans, root,
 							 extent_num_bytes)) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 772963a61072..a816c0999fb2 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -889,8 +889,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 	if (must_run_delayed_refs) {
-		btrfs_async_run_delayed_refs(info, cur, transid,
-					     must_run_delayed_refs == 1);
+		btrfs_async_run_delayed_refs(info, cur, transid);
 	}
 	return err;
 }
-- 
1.8.3.1
