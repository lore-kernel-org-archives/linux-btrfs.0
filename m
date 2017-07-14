Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50171 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750799AbdGNIqd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 04:46:33 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7FBDAAAB9
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 08:46:31 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove unused variables from btrfs_async_reclaim_metadata_space
Date: Fri, 14 Jul 2017 11:46:24 +0300
Message-Id: <1500021984-10079-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The ret from flush_space is ignored so no point in assigning it to a variable.
The ticket variable was used in the initial version of the ticketed ENOSPC
work, however Wang Xiaoguang detected a problem with this and fixed it in
ce129655c9d9 ("btrfs: introduce tickets_id to determine whether asynchronous
metadata reclaim work makes progress").

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d57f1f161fa2..31924c834049 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
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

