Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56023 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752082AbcKGIGx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 03:06:53 -0500
Received: from localhost.localdomain (unknown [10.167.226.107])
        by cn.fujitsu.com (Postfix) with ESMTP id 6371741B4BC3
        for <linux-btrfs@vger.kernel.org>; Mon,  7 Nov 2016 16:06:38 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: increase tickets_id even for failed metadata request
Date: Mon,  7 Nov 2016 15:59:17 +0800
Message-Id: <1478505557-1406-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
In-Reply-To: <1478505557-1406-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
References: <1478505557-1406-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not functional change, it just makes codes logic more reasonable, then
at least tickets_id can reflect the number of metadata requests we already
handled.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4607af3..d63bf40 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4949,14 +4949,16 @@ static inline int need_do_async_reclaim(struct btrfs_space_info *space_info,
 			  &root->fs_info->fs_state));
 }
 
-static void wake_all_tickets(struct list_head *head)
+static void wake_all_tickets(struct btrfs_space_info *space_info)
 {
 	struct reserve_ticket *ticket;
+	struct list_head *head = &space_info->tickets;
 
 	while (!list_empty(head)) {
 		ticket = list_first_entry(head, struct reserve_ticket, list);
 		list_del_init(&ticket->list);
 		ticket->error = -ENOSPC;
+		space_info->tickets_id++;
 		wake_up(&ticket->wait);
 	}
 }
@@ -5018,7 +5020,7 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 		if (flush_state > COMMIT_TRANS) {
 			commit_cycles++;
 			if (commit_cycles > 2) {
-				wake_all_tickets(&space_info->tickets);
+				wake_all_tickets(space_info);
 				space_info->flush = 0;
 			} else {
 				flush_state = FLUSH_DELAYED_ITEMS_NR;
-- 
2.5.0



