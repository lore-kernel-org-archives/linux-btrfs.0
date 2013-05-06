Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:42170 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab3EFIxG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 May 2013 04:53:06 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 6 May 2013 02:53:06 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id DA9EC1FF001D
	for <linux-btrfs@vger.kernel.org>; Mon,  6 May 2013 02:47:59 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r468r4qA129982
	for <linux-btrfs@vger.kernel.org>; Mon, 6 May 2013 02:53:04 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r468r3mm006066
	for <linux-btrfs@vger.kernel.org>; Mon, 6 May 2013 02:53:04 -0600
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: sekharan@us.ibm.com, chris.mason@fusionio.com, idryomov@gmail.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC 1/5] vfs: add one list_head field
Date: Mon,  6 May 2013 16:53:34 +0800
Message-Id: <1367830418-26865-2-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
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
index 3b0002c..7071ac8 100644
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
index 2272975..49f901c 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -68,6 +68,7 @@ struct hot_comm_item {
 	struct rb_node rb_node;			/* rbtree index */
 	unsigned long delete_flag;
 	struct list_head track_list;		/* link to *_map[] */
+	struct list_head reloc_list;		/* used in hot relocation*/
 };
 
 /* An item representing an inode and its access frequency */
-- 
1.7.11.7

