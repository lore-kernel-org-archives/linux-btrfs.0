Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:34040 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbeH3VqC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:46:02 -0400
Received: by mail-qt0-f172.google.com with SMTP id m13-v6so11332704qth.1
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:42:47 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c15-v6sm4129624qkm.42.2018.08.30.10.42.45
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Aug 2018 10:42:45 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/35] btrfs: fix truncate throttling
Date: Thu, 30 Aug 2018 13:42:00 -0400
Message-Id: <20180830174225.2200-11-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have a bunch of magic to make sure we're throttling delayed refs when
truncating a file.  Now that we have a delayed refs rsv and a mechanism
for refilling that reserve simply use that instead of all of this magic.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 78 ++++++++++++--------------------------------------------
 1 file changed, 16 insertions(+), 62 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 212fa71317d6..10455d0aa71c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4493,31 +4493,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	return err;
 }
 
-static int truncate_space_check(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				u64 bytes_deleted)
-{
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	int ret;
-
-	/*
-	 * This is only used to apply pressure to the enospc system, we don't
-	 * intend to use this reservation at all.
-	 */
-	bytes_deleted = btrfs_csum_bytes_to_leaves(fs_info, bytes_deleted);
-	bytes_deleted *= fs_info->nodesize;
-	ret = btrfs_block_rsv_add(root, &fs_info->trans_block_rsv,
-				  bytes_deleted, BTRFS_RESERVE_NO_FLUSH);
-	if (!ret) {
-		trace_btrfs_space_reservation(fs_info, "transaction",
-					      trans->transid,
-					      bytes_deleted, 1);
-		trans->bytes_reserved += bytes_deleted;
-	}
-	return ret;
-
-}
-
 /*
  * Return this if we need to call truncate_block for the last bit of the
  * truncate.
@@ -4562,7 +4537,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	u64 bytes_deleted = 0;
 	bool be_nice = false;
 	bool should_throttle = false;
-	bool should_end = false;
 
 	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);
 
@@ -4775,15 +4749,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 				btrfs_abort_transaction(trans, ret);
 				break;
 			}
-			if (btrfs_should_throttle_delayed_refs(trans, fs_info))
-				btrfs_async_run_delayed_refs(fs_info,
-					trans->delayed_ref_updates * 2,
-					trans->transid, 0);
 			if (be_nice) {
-				if (truncate_space_check(trans, root,
-							 extent_num_bytes)) {
-					should_end = true;
-				}
 				if (btrfs_should_throttle_delayed_refs(trans,
 								       fs_info))
 					should_throttle = true;
@@ -4795,7 +4761,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 
 		if (path->slots[0] == 0 ||
 		    path->slots[0] != pending_del_slot ||
-		    should_throttle || should_end) {
+		    should_throttle) {
 			if (pending_del_nr) {
 				ret = btrfs_del_items(trans, root, path,
 						pending_del_slot,
@@ -4807,23 +4773,23 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 				pending_del_nr = 0;
 			}
 			btrfs_release_path(path);
-			if (should_throttle) {
-				unsigned long updates = trans->delayed_ref_updates;
-				if (updates) {
-					trans->delayed_ref_updates = 0;
-					ret = btrfs_run_delayed_refs(trans,
-								   updates * 2);
-					if (ret)
-						break;
-				}
-			}
+
 			/*
-			 * if we failed to refill our space rsv, bail out
-			 * and let the transaction restart
+			 * We can generate a lot of delayed refs, so we need to
+			 * throttle every once and a while and make sure we're
+			 * adding enough space to keep up with the work we are
+			 * generating.  Since we hold a transaction here we can
+			 * only FLUSH_LIMIT, if this fails we just return EAGAIN
+			 * and let the normal space allocation stuff do it's
+			 * work.
 			 */
-			if (should_end) {
-				ret = -EAGAIN;
-				break;
+			if (should_throttle) {
+				ret = btrfs_refill_delayed_refs_rsv(fs_info,
+							BTRFS_RESERVE_FLUSH_LIMIT);
+				if (ret) {
+					ret = -EAGAIN;
+					break;
+				}
 			}
 			goto search_again;
 		} else {
@@ -4849,18 +4815,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_free_path(path);
-
-	if (be_nice && bytes_deleted > SZ_32M && (ret >= 0 || ret == -EAGAIN)) {
-		unsigned long updates = trans->delayed_ref_updates;
-		int err;
-
-		if (updates) {
-			trans->delayed_ref_updates = 0;
-			err = btrfs_run_delayed_refs(trans, updates * 2);
-			if (err)
-				ret = err;
-		}
-	}
 	return ret;
 }
 
-- 
2.14.3
