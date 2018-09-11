Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:43056 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbeIKW7E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:59:04 -0400
Received: by mail-qt0-f196.google.com with SMTP id g53-v6so29156859qtg.10
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:58:39 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 15/36] btrfs: don't enospc all tickets on flush failure
Date: Tue, 11 Sep 2018 13:57:46 -0400
Message-Id: <20180911175807.26181-16-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the introduction of the per-inode block_rsv it became possible to
have really really large reservation requests made because of data
fragmentation.  Since the ticket stuff assumed that we'd always have
relatively small reservation requests it just killed all tickets if we
were unable to satisfy the current request.  However this is generally
not the case anymore.  So fix this logic to instead see if we had a
ticket that we were able to give some reservation to, and if we were
continue the flushing loop again.  Likewise we make the tickets use the
space_info_add_old_bytes() method of returning what reservation they did
receive in hopes that it could satisfy reservations down the line.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 44d59bee6e5e..76941fc5af79 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4779,6 +4779,7 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 }
 
 struct reserve_ticket {
+	u64 orig_bytes;
 	u64 bytes;
 	int error;
 	struct list_head list;
@@ -5000,7 +5001,7 @@ static inline int need_do_async_reclaim(struct btrfs_fs_info *fs_info,
 		!test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state));
 }
 
-static void wake_all_tickets(struct list_head *head)
+static bool wake_all_tickets(struct list_head *head)
 {
 	struct reserve_ticket *ticket;
 
@@ -5009,7 +5010,10 @@ static void wake_all_tickets(struct list_head *head)
 		list_del_init(&ticket->list);
 		ticket->error = -ENOSPC;
 		wake_up(&ticket->wait);
+		if (ticket->bytes != ticket->orig_bytes)
+			return true;
 	}
+	return false;
 }
 
 /*
@@ -5077,8 +5081,12 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 		if (flush_state > COMMIT_TRANS) {
 			commit_cycles++;
 			if (commit_cycles > 2) {
-				wake_all_tickets(&space_info->tickets);
-				space_info->flush = 0;
+				if (wake_all_tickets(&space_info->tickets)) {
+					flush_state = FLUSH_DELAYED_ITEMS_NR;
+					commit_cycles--;
+				} else {
+					space_info->flush = 0;
+				}
 			} else {
 				flush_state = FLUSH_DELAYED_ITEMS_NR;
 			}
@@ -5130,10 +5138,11 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 
 static int wait_reserve_ticket(struct btrfs_fs_info *fs_info,
 			       struct btrfs_space_info *space_info,
-			       struct reserve_ticket *ticket, u64 orig_bytes)
+			       struct reserve_ticket *ticket)
 
 {
 	DEFINE_WAIT(wait);
+	u64 reclaim_bytes = 0;
 	int ret = 0;
 
 	spin_lock(&space_info->lock);
@@ -5154,14 +5163,12 @@ static int wait_reserve_ticket(struct btrfs_fs_info *fs_info,
 		ret = ticket->error;
 	if (!list_empty(&ticket->list))
 		list_del_init(&ticket->list);
-	if (ticket->bytes && ticket->bytes < orig_bytes) {
-		u64 num_bytes = orig_bytes - ticket->bytes;
-		space_info->bytes_may_use -= num_bytes;
-		trace_btrfs_space_reservation(fs_info, "space_info",
-					      space_info->flags, num_bytes, 0);
-	}
+	if (ticket->bytes && ticket->bytes < ticket->orig_bytes)
+		reclaim_bytes = ticket->orig_bytes - ticket->bytes;
 	spin_unlock(&space_info->lock);
 
+	if (reclaim_bytes)
+		space_info_add_old_bytes(fs_info, space_info, reclaim_bytes);
 	return ret;
 }
 
@@ -5187,6 +5194,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 {
 	struct reserve_ticket ticket;
 	u64 used;
+	u64 reclaim_bytes = 0;
 	int ret = 0;
 
 	ASSERT(orig_bytes);
@@ -5222,6 +5230,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 	 * the list and we will do our own flushing further down.
 	 */
 	if (ret && flush != BTRFS_RESERVE_NO_FLUSH) {
+		ticket.orig_bytes = orig_bytes;
 		ticket.bytes = orig_bytes;
 		ticket.error = 0;
 		init_waitqueue_head(&ticket.wait);
@@ -5262,25 +5271,21 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 		return ret;
 
 	if (flush == BTRFS_RESERVE_FLUSH_ALL)
-		return wait_reserve_ticket(fs_info, space_info, &ticket,
-					   orig_bytes);
+		return wait_reserve_ticket(fs_info, space_info, &ticket);
 
 	ret = 0;
 	priority_reclaim_metadata_space(fs_info, space_info, &ticket);
 	spin_lock(&space_info->lock);
 	if (ticket.bytes) {
-		if (ticket.bytes < orig_bytes) {
-			u64 num_bytes = orig_bytes - ticket.bytes;
-			space_info->bytes_may_use -= num_bytes;
-			trace_btrfs_space_reservation(fs_info, "space_info",
-						      space_info->flags,
-						      num_bytes, 0);
-
-		}
+		if (ticket.bytes < orig_bytes)
+			reclaim_bytes = orig_bytes - ticket.bytes;
 		list_del_init(&ticket.list);
 		ret = -ENOSPC;
 	}
 	spin_unlock(&space_info->lock);
+
+	if (reclaim_bytes)
+		space_info_add_old_bytes(fs_info, space_info, reclaim_bytes);
 	ASSERT(list_empty(&ticket.list));
 	return ret;
 }
-- 
2.14.3
