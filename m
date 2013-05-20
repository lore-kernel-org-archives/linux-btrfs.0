Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:44729 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216Ab3ETPKu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 May 2013 11:10:50 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 20 May 2013 09:10:49 -0600
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 1/5] BTRFS hot reloc, vfs: add one list_head field
Date: Mon, 20 May 2013 23:11:23 +0800
Message-Id: <1369062687-23544-2-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1369062687-23544-1-git-send-email-zwu.kernel@gmail.com>
References: <1369062687-23544-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add one list_head field 'reloc_list' to accommodate
hot relocation support.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            | 1 +
 include/linux/hot_tracking.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 46d2f7d..2a59b09 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -41,6 +41,7 @@ static void hot_comm_item_init(struct hot_comm_item *ci, int type)
 	clear_bit(HOT_IN_LIST, &ci->delete_flag);
 	clear_bit(HOT_DELETING, &ci->delete_flag);
 	INIT_LIST_HEAD(&ci->track_list);
+	INIT_LIST_HEAD(&ci->reloc_list);
 	memset(&ci->hot_freq_data, 0, sizeof(struct hot_freq_data));
 	ci->hot_freq_data.avg_delta_reads = (u64) -1;
 	ci->hot_freq_data.avg_delta_writes = (u64) -1;
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 008a5c1..faf1acc 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -74,6 +74,7 @@ struct hot_comm_item {
 	unsigned long delete_flag;
 	struct rcu_head c_rcu;
 	struct list_head track_list;		/* link to *_map[] */
+	struct list_head reloc_list;		/* used in hot relocation*/
 };
 
 /* An item representing an inode and its access frequency */
-- 
1.7.11.7

