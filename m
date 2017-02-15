Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57378 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751583AbdBOV2l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:28:41 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3B628AD39
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Feb 2017 21:28:40 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/8] btrfs: flush_space always takes fs_info->fs_root
Date: Wed, 15 Feb 2017 16:28:28 -0500
Message-Id: <1487194114-12786-3-git-send-email-jeffm@suse.com>
In-Reply-To: <1487194114-12786-1-git-send-email-jeffm@suse.com>
References: <1487194114-12786-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

We don't need to pass a root to flush_space since it always uses
the fs_root.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d4c0f8a..b005378 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4791,11 +4791,10 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
  * get us somewhere and then commit the transaction if it does.  Otherwise it
  * will return -ENOSPC.
  */
-static int may_commit_transaction(struct btrfs_root *root,
+static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 				  struct btrfs_space_info *space_info,
 				  u64 bytes, int force)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_block_rsv;
 	struct btrfs_trans_handle *trans;
 
@@ -4827,7 +4826,7 @@ static int may_commit_transaction(struct btrfs_root *root,
 	spin_unlock(&delayed_rsv->lock);
 
 commit:
-	trans = btrfs_join_transaction(root);
+	trans = btrfs_join_transaction(fs_info->fs_root);
 	if (IS_ERR(trans))
 		return -ENOSPC;
 
@@ -4841,11 +4840,11 @@ struct reserve_ticket {
 	wait_queue_head_t wait;
 };
 
-static int flush_space(struct btrfs_root *root,
+static int flush_space(struct btrfs_fs_info *fs_info,
 		       struct btrfs_space_info *space_info, u64 num_bytes,
 		       u64 orig_bytes, int state)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_root *root = fs_info->fs_root;
 	struct btrfs_trans_handle *trans;
 	int nr;
 	int ret = 0;
@@ -4885,7 +4884,8 @@ static int flush_space(struct btrfs_root *root,
 			ret = 0;
 		break;
 	case COMMIT_TRANS:
-		ret = may_commit_transaction(root, space_info, orig_bytes, 0);
+		ret = may_commit_transaction(fs_info, space_info,
+					     orig_bytes, 0);
 		break;
 	default:
 		ret = -ENOSPC;
@@ -4997,8 +4997,8 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 		struct reserve_ticket *ticket;
 		int ret;
 
-		ret = flush_space(fs_info->fs_root, space_info, to_reclaim,
-			    to_reclaim, flush_state);
+		ret = flush_space(fs_info, space_info, to_reclaim, to_reclaim,
+				  flush_state);
 		spin_lock(&space_info->lock);
 		if (list_empty(&space_info->tickets)) {
 			space_info->flush = 0;
@@ -5053,8 +5053,8 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 	spin_unlock(&space_info->lock);
 
 	do {
-		flush_space(fs_info->fs_root, space_info, to_reclaim,
-			    to_reclaim, flush_state);
+		flush_space(fs_info, space_info, to_reclaim, to_reclaim,
+			    flush_state);
 		flush_state++;
 		spin_lock(&space_info->lock);
 		if (ticket->bytes == 0) {
-- 
2.7.1

