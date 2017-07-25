Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35468 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752070AbdGYOsn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 10:48:43 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 97F25AE6E
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 14:48:41 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Make flush_space return void
Date: Tue, 25 Jul 2017 17:48:28 +0300
Message-Id: <1500994108-19285-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20170721161853.GM2866@twin.jikos.cz>
References: <20170721161853.GM2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The return value of flush_space was used to have significance in the early days
when the code was first introduced and before the ticketed enospc rework. Since
the latter got introduced the return value lost any significance whatsoever to
its callers. So let's remove it. While at it also remove the unused ticket
variable in btrfs_async_reclaim_metadata_space. It was used in the initial
version of the ticketed ENOSPC work, however Wang Xiaoguang detected a problem
with this and fixed it in ce129655c9d9 ("btrfs: introduce tickets_id to
determine whether asynchronous metadata reclaim work makes progress").

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a53441ffce71..463063fb4f07 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4901,7 +4901,7 @@ struct reserve_ticket {
 	wait_queue_head_t wait;
 };
 
-static int flush_space(struct btrfs_fs_info *fs_info,
+static void flush_space(struct btrfs_fs_info *fs_info,
 		       struct btrfs_space_info *space_info, u64 num_bytes,
 		       u64 orig_bytes, int state)
 {
@@ -4955,7 +4955,7 @@ static int flush_space(struct btrfs_fs_info *fs_info,
 
 	trace_btrfs_flush_space(fs_info, space_info->flags, num_bytes,
 				orig_bytes, state, ret);
-	return ret;
+	return;
 }
 
 static inline u64
@@ -5057,10 +5057,7 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 
 	flush_state = FLUSH_DELAYED_ITEMS_NR;
 	do {
-		struct reserve_ticket *ticket;
-		int ret;
-
-		ret = flush_space(fs_info, space_info, to_reclaim, to_reclaim,
+		flush_space(fs_info, space_info, to_reclaim, to_reclaim,
 				  flush_state);
 		spin_lock(&space_info->lock);
 		if (list_empty(&space_info->tickets)) {
@@ -5071,8 +5068,6 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 		to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info,
 							      space_info,
 							      false);
-		ticket = list_first_entry(&space_info->tickets,
-					  struct reserve_ticket, list);
 		if (last_tickets_id == space_info->tickets_id) {
 			flush_state++;
 		} else {
-- 
2.7.4

