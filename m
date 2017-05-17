Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52605 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751676AbdEQPiU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 11:38:20 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5D638ACD2
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 15:38:18 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 3/3] btrfs: remove root usage from can_overcommit
Date: Wed, 17 May 2017 11:38:36 -0400
Message-Id: <1495035516-3217-3-git-send-email-jeffm@suse.com>
In-Reply-To: <1495035516-3217-1-git-send-email-jeffm@suse.com>
References: <1495035516-3217-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

can_overcommit using the root to determine the allocation profile
is the only use of a root in the call graph below reserve_metadata_bytes.

It turns out that we only need to know whether the allocation is for
the chunk root or not -- and we can pass that around as a bool instead.

This allows us to pull root usage out of the reservation path all the
way up to reserve_metadata_bytes itself, which uses it only to compare
against fs_info->chunk_root to set the bool.  In turn, this eliminates
a bunch of races where we use a particular root too early in the mount
process.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 82 ++++++++++++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index cc941fe..4280f97 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -97,10 +97,11 @@ static int btrfs_free_reserved_bytes(struct btrfs_block_group_cache *cache,
 				     u64 num_bytes, int delalloc);
 static int block_rsv_use_bytes(struct btrfs_block_rsv *block_rsv,
 			       u64 num_bytes);
-static int __reserve_metadata_bytes(struct btrfs_root *root,
+static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 				    struct btrfs_space_info *space_info,
 				    u64 orig_bytes,
-				    enum btrfs_reserve_flush_enum flush);
+				    enum btrfs_reserve_flush_enum flush,
+				    bool system_chunk);
 static void space_info_add_new_bytes(struct btrfs_fs_info *fs_info,
 				     struct btrfs_space_info *space_info,
 				     u64 num_bytes);
@@ -4617,11 +4618,11 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int can_overcommit(struct btrfs_root *root,
+static int can_overcommit(struct btrfs_fs_info *fs_info,
 			  struct btrfs_space_info *space_info, u64 bytes,
-			  enum btrfs_reserve_flush_enum flush)
+			  enum btrfs_reserve_flush_enum flush,
+			  bool system_chunk)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
 	u64 profile;
 	u64 space_size;
@@ -4632,7 +4633,11 @@ static int can_overcommit(struct btrfs_root *root,
 	if (space_info->flags & BTRFS_BLOCK_GROUP_DATA)
 		return 0;
 
-	profile = get_alloc_profile_by_root(root, 0);
+	if (system_chunk)
+		profile = btrfs_system_alloc_profile(fs_info);
+	else
+		profile = btrfs_metadata_alloc_profile(fs_info);
+
 	used = btrfs_space_info_used(space_info, false);
 
 	/*
@@ -4719,10 +4724,9 @@ static inline int calc_reclaim_items_nr(struct btrfs_fs_info *fs_info,
 /*
  * shrink metadata reservation for delalloc
  */
-static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
-			    bool wait_ordered)
+static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
+			    u64 orig, bool wait_ordered)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_space_info *space_info;
 	struct btrfs_trans_handle *trans;
@@ -4779,7 +4783,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 		else
 			flush = BTRFS_RESERVE_NO_FLUSH;
 		spin_lock(&space_info->lock);
-		if (can_overcommit(root, space_info, orig, flush)) {
+		if (can_overcommit(fs_info, space_info, orig, flush, false)) {
 			spin_unlock(&space_info->lock);
 			break;
 		}
@@ -4889,7 +4893,7 @@ static int flush_space(struct btrfs_fs_info *fs_info,
 		break;
 	case FLUSH_DELALLOC:
 	case FLUSH_DELALLOC_WAIT:
-		shrink_delalloc(root, num_bytes * 2, orig_bytes,
+		shrink_delalloc(fs_info, num_bytes * 2, orig_bytes,
 				state == FLUSH_DELALLOC_WAIT);
 		break;
 	case ALLOC_CHUNK:
@@ -4920,8 +4924,9 @@ static int flush_space(struct btrfs_fs_info *fs_info,
 }
 
 static inline u64
-btrfs_calc_reclaim_metadata_size(struct btrfs_root *root,
-				 struct btrfs_space_info *space_info)
+btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
+				 struct btrfs_space_info *space_info,
+				 bool system_chunk)
 {
 	struct reserve_ticket *ticket;
 	u64 used;
@@ -4936,14 +4941,15 @@ static int flush_space(struct btrfs_fs_info *fs_info,
 		return to_reclaim;
 
 	to_reclaim = min_t(u64, num_online_cpus() * SZ_1M, SZ_16M);
-	if (can_overcommit(root, space_info, to_reclaim,
-			   BTRFS_RESERVE_FLUSH_ALL))
+	if (can_overcommit(fs_info, space_info, to_reclaim,
+			   BTRFS_RESERVE_FLUSH_ALL, system_chunk))
 		return 0;
 
 	used = space_info->bytes_used + space_info->bytes_reserved +
 	       space_info->bytes_pinned + space_info->bytes_readonly +
 	       space_info->bytes_may_use;
-	if (can_overcommit(root, space_info, SZ_1M, BTRFS_RESERVE_FLUSH_ALL))
+	if (can_overcommit(fs_info, space_info, SZ_1M,
+			   BTRFS_RESERVE_FLUSH_ALL, system_chunk))
 		expected = div_factor_fine(space_info->total_bytes, 95);
 	else
 		expected = div_factor_fine(space_info->total_bytes, 90);
@@ -4957,17 +4963,18 @@ static int flush_space(struct btrfs_fs_info *fs_info,
 	return to_reclaim;
 }
 
-static inline int need_do_async_reclaim(struct btrfs_space_info *space_info,
-					struct btrfs_root *root, u64 used)
+static inline int need_do_async_reclaim(struct btrfs_fs_info *fs_info,
+					struct btrfs_space_info *space_info,
+					u64 used, bool system_chunk)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 thresh = div_factor_fine(space_info->total_bytes, 98);
 
 	/* If we're just plain full then async reclaim just slows us down. */
 	if ((space_info->bytes_used + space_info->bytes_reserved) >= thresh)
 		return 0;
 
-	if (!btrfs_calc_reclaim_metadata_size(root, space_info))
+	if (!btrfs_calc_reclaim_metadata_size(fs_info, space_info,
+					      system_chunk))
 		return 0;
 
 	return (used >= thresh && !btrfs_fs_closing(fs_info) &&
@@ -5004,8 +5011,8 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 	space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
 
 	spin_lock(&space_info->lock);
-	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info->fs_root,
-						      space_info);
+	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info, space_info,
+						      false);
 	if (!to_reclaim) {
 		space_info->flush = 0;
 		spin_unlock(&space_info->lock);
@@ -5027,8 +5034,9 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 			spin_unlock(&space_info->lock);
 			return;
 		}
-		to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info->fs_root,
-							      space_info);
+		to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info,
+							      space_info,
+							      false);
 		ticket = list_first_entry(&space_info->tickets,
 					  struct reserve_ticket, list);
 		if (last_tickets_id == space_info->tickets_id) {
@@ -5066,8 +5074,8 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 	int flush_state = FLUSH_DELAYED_ITEMS_NR;
 
 	spin_lock(&space_info->lock);
-	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info->extent_root,
-						      space_info);
+	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info, space_info,
+						      false);
 	if (!to_reclaim) {
 		spin_unlock(&space_info->lock);
 		return;
@@ -5146,12 +5154,12 @@ static int wait_reserve_ticket(struct btrfs_fs_info *fs_info,
  * regain reservations will be made and this will fail if there is not enough
  * space already.
  */
-static int __reserve_metadata_bytes(struct btrfs_root *root,
+static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 				    struct btrfs_space_info *space_info,
 				    u64 orig_bytes,
-				    enum btrfs_reserve_flush_enum flush)
+				    enum btrfs_reserve_flush_enum flush,
+				    bool system_chunk)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct reserve_ticket ticket;
 	u64 used;
 	int ret = 0;
@@ -5173,7 +5181,8 @@ static int __reserve_metadata_bytes(struct btrfs_root *root,
 		trace_btrfs_space_reservation(fs_info, "space_info",
 					      space_info->flags, orig_bytes, 1);
 		ret = 0;
-	} else if (can_overcommit(root, space_info, orig_bytes, flush)) {
+	} else if (can_overcommit(fs_info, space_info, orig_bytes, flush,
+				  system_chunk)) {
 		space_info->bytes_may_use += orig_bytes;
 		trace_btrfs_space_reservation(fs_info, "space_info",
 					      space_info->flags, orig_bytes, 1);
@@ -5200,7 +5209,7 @@ static int __reserve_metadata_bytes(struct btrfs_root *root,
 							  orig_bytes, flush,
 							  "enospc");
 				queue_work(system_unbound_wq,
-					   &root->fs_info->async_reclaim_work);
+					   &fs_info->async_reclaim_work);
 			}
 		} else {
 			list_add_tail(&ticket.list,
@@ -5214,7 +5223,8 @@ static int __reserve_metadata_bytes(struct btrfs_root *root,
 		 * the async reclaim as we will panic.
 		 */
 		if (!test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags) &&
-		    need_do_async_reclaim(space_info, root, used) &&
+		    need_do_async_reclaim(fs_info, space_info,
+					  used, system_chunk) &&
 		    !work_busy(&fs_info->async_reclaim_work)) {
 			trace_btrfs_trigger_flush(fs_info, space_info->flags,
 						  orig_bytes, flush, "preempt");
@@ -5272,9 +5282,10 @@ static int reserve_metadata_bytes(struct btrfs_root *root,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
 	int ret;
+	bool system_chunk = (root == fs_info->chunk_root);
 
-	ret = __reserve_metadata_bytes(root, block_rsv->space_info, orig_bytes,
-				       flush);
+	ret = __reserve_metadata_bytes(fs_info, block_rsv->space_info,
+				       orig_bytes, flush, system_chunk);
 	if (ret == -ENOSPC &&
 	    unlikely(root->orphan_cleanup_state == ORPHAN_CLEANUP_STARTED)) {
 		if (block_rsv != global_rsv &&
@@ -5397,8 +5408,7 @@ static void space_info_add_old_bytes(struct btrfs_fs_info *fs_info,
 		 * adding the ticket space would be a double count.
 		 */
 		if (check_overcommit &&
-		    !can_overcommit(fs_info->extent_root, space_info, 0,
-				    flush))
+		    !can_overcommit(fs_info, space_info, 0, flush, false))
 			break;
 		if (num_bytes >= ticket->bytes) {
 			list_del_init(&ticket->list);
-- 
1.8.5.6

