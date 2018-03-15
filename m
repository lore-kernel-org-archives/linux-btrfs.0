Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37722 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752045AbeCOMgi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 08:36:38 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 96D4CAD3C
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 12:36:37 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 8/8] btrfs: Remove unused flush var in shrink_delalloc
Date: Thu, 15 Mar 2018 14:36:29 +0200
Message-Id: <1521117389-13712-9-git-send-email-nborisov@suse.com>
In-Reply-To: <1521117389-13712-1-git-send-email-nborisov@suse.com>
References: <1521117389-13712-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added by 08e007d2e577 ("Btrfs: improve the noflush reservation") and
made redundant by 17024ad0a0fd ("Btrfs: fix early ENOSPC due to
delalloc")

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e15ef42a5d4d..bb1861033071 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4829,7 +4829,6 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 	long time_left;
 	unsigned long nr_pages;
 	int loops;
-	enum btrfs_reserve_flush_enum flush;
 
 	/* Calc the number of the pages we need flush for space reservation */
 	items = calc_reclaim_items_nr(fs_info, to_reclaim);
@@ -4870,10 +4869,6 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 			   atomic_read(&fs_info->async_delalloc_pages) <=
 			   (int)max_reclaim);
 skip_async:
-		if (!trans)
-			flush = BTRFS_RESERVE_FLUSH_ALL;
-		else
-			flush = BTRFS_RESERVE_NO_FLUSH;
 		spin_lock(&space_info->lock);
 		if (list_empty(&space_info->tickets) &&
 		    list_empty(&space_info->priority_tickets)) {
-- 
2.7.4

