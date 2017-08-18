Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36251 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbdHRUJV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 16:09:21 -0400
Received: by mail-qk0-f195.google.com with SMTP id u139so1907817qka.3
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 13:09:21 -0700 (PDT)
From: josef@toxicpanda.com
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH] btrfs: change how we decide to commit transactions during flushing
Date: Fri, 18 Aug 2017 16:09:19 -0400
Message-Id: <1503086959-23467-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Nikolay reported that generic/273 was failing currently with ENOSPC.
Turns out this is because we get to the point where the outstanding
reservations are greater than the pinned space on the fs.  This is a
mistake, previously we used the current reservation amount in
may_commit_transaction, not the entire outstanding reservation amount.
Fix this to find the minimum byte size needed to make progress in
flushing, and pass that into may_commit_transaction.  From there we can
make a smarter decision on whether to commit the transaction or not.
This fixes the failure in generic/273.

Reported-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fac42b8..4509e47 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4872,8 +4872,12 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 		return -ENOSPC;
 
 	spin_lock(&delayed_rsv->lock);
+	if (delayed_rsv->size > bytes)
+		bytes = 0;
+	else
+		bytes -= delayed_rsv->size;
 	if (percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes - delayed_rsv->size) < 0) {
+				   bytes) < 0) {
 		spin_unlock(&delayed_rsv->lock);
 		return -ENOSPC;
 	}
@@ -4901,7 +4905,7 @@ struct reserve_ticket {
  */
 static void flush_space(struct btrfs_fs_info *fs_info,
 		       struct btrfs_space_info *space_info, u64 num_bytes,
-		       int state)
+		       u64 min_bytes, int state)
 {
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_trans_handle *trans;
@@ -4944,7 +4948,7 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 		break;
 	case COMMIT_TRANS:
 		ret = may_commit_transaction(fs_info, space_info,
-					     num_bytes, 0);
+					     min_bytes, 0);
 		break;
 	default:
 		ret = -ENOSPC;
@@ -4959,17 +4963,23 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 static inline u64
 btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
 				 struct btrfs_space_info *space_info,
-				 bool system_chunk)
+				 u64 *min_reclaim, bool system_chunk)
 {
 	struct reserve_ticket *ticket;
 	u64 used;
 	u64 expected;
 	u64 to_reclaim = 0;
 
-	list_for_each_entry(ticket, &space_info->tickets, list)
+	list_for_each_entry(ticket, &space_info->tickets, list) {
+		if (min_reclaim && *min_reclaim == 0)
+			*min_reclaim = ticket->bytes;
 		to_reclaim += ticket->bytes;
-	list_for_each_entry(ticket, &space_info->priority_tickets, list)
+	}
+	list_for_each_entry(ticket, &space_info->priority_tickets, list) {
+		if (min_reclaim && *min_reclaim == 0)
+			*min_reclaim = ticket->bytes;
 		to_reclaim += ticket->bytes;
+	}
 	if (to_reclaim)
 		return to_reclaim;
 
@@ -4992,6 +5002,8 @@ btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
 		to_reclaim = 0;
 	to_reclaim = min(to_reclaim, space_info->bytes_may_use +
 				     space_info->bytes_reserved);
+	if (min_reclaim)
+		*min_reclaim = to_reclaim;
 	return to_reclaim;
 }
 
@@ -5005,7 +5017,7 @@ static inline int need_do_async_reclaim(struct btrfs_fs_info *fs_info,
 	if ((space_info->bytes_used + space_info->bytes_reserved) >= thresh)
 		return 0;
 
-	if (!btrfs_calc_reclaim_metadata_size(fs_info, space_info,
+	if (!btrfs_calc_reclaim_metadata_size(fs_info, space_info, NULL,
 					      system_chunk))
 		return 0;
 
@@ -5038,13 +5050,14 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 	int flush_state;
 	int commit_cycles = 0;
 	u64 last_tickets_id;
+	u64 min_reclaim = 0;
 
 	fs_info = container_of(work, struct btrfs_fs_info, async_reclaim_work);
 	space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
 
 	spin_lock(&space_info->lock);
 	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info, space_info,
-						      false);
+						      &min_reclaim, false);
 	if (!to_reclaim) {
 		space_info->flush = 0;
 		spin_unlock(&space_info->lock);
@@ -5055,15 +5068,18 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 
 	flush_state = FLUSH_DELAYED_ITEMS_NR;
 	do {
-		flush_space(fs_info, space_info, to_reclaim, flush_state);
+		flush_space(fs_info, space_info, to_reclaim, min_reclaim,
+			    flush_state);
 		spin_lock(&space_info->lock);
 		if (list_empty(&space_info->tickets)) {
 			space_info->flush = 0;
 			spin_unlock(&space_info->lock);
 			return;
 		}
+		min_reclaim = 0;
 		to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info,
 							      space_info,
+							      &min_reclaim,
 							      false);
 		if (last_tickets_id == space_info->tickets_id) {
 			flush_state++;
@@ -5097,11 +5113,12 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 					    struct reserve_ticket *ticket)
 {
 	u64 to_reclaim;
+	u64 min_reclaim = 0;
 	int flush_state = FLUSH_DELAYED_ITEMS_NR;
 
 	spin_lock(&space_info->lock);
 	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info, space_info,
-						      false);
+						      &min_reclaim, false);
 	if (!to_reclaim) {
 		spin_unlock(&space_info->lock);
 		return;
@@ -5109,7 +5126,8 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 	spin_unlock(&space_info->lock);
 
 	do {
-		flush_space(fs_info, space_info, to_reclaim, flush_state);
+		flush_space(fs_info, space_info, to_reclaim, min_reclaim,
+			    flush_state);
 		flush_state++;
 		spin_lock(&space_info->lock);
 		if (ticket->bytes == 0) {
-- 
2.7.4

