Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47909 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161052Ab3FUMW2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 08:22:28 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Fri, 21 Jun 2013 08:22:28 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 1905F6E804F
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 08:22:20 -0400 (EDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r5LCLrUv315474
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 08:21:54 -0400
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r5LCLpWf012425
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 06:21:53 -0600
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, chris.mason@fusionio.com, jbacik@fusionio.com,
        idryomov@gmail.com, Martin@lichtvoll.de,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 1/5] BTRFS hot reloc, vfs: add one list_head field
Date: Fri, 21 Jun 2013 20:20:56 +0800
Message-Id: <1371817260-8615-2-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1371817260-8615-1-git-send-email-zwu.kernel@gmail.com>
References: <1371817260-8615-1-git-send-email-zwu.kernel@gmail.com>
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
index dbc90d4..f013182 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -44,6 +44,7 @@ static void hot_comm_item_init(struct hot_comm_item *ci, int type)
 	clear_bit(HOT_IN_LIST, &ci->delete_flag);
 	clear_bit(HOT_DELETING, &ci->delete_flag);
 	INIT_LIST_HEAD(&ci->track_list);
+	INIT_LIST_HEAD(&ci->reloc_list);
 	memset(&ci->hot_freq_data, 0, sizeof(struct hot_freq_data));
 	ci->hot_freq_data.avg_delta_reads = (u64) -1;
 	ci->hot_freq_data.avg_delta_writes = (u64) -1;
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 1009377..98bb092 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -75,6 +75,7 @@ struct hot_comm_item {
 	unsigned long delete_flag;
 	struct rcu_head c_rcu;
 	struct list_head track_list;		/* link to *_map[] */
+	struct list_head reloc_list;		/* used in hot relocation*/
 };
 
 /* An item representing an inode and its access frequency */
-- 
1.7.11.7

