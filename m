Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54971 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936Ab3ENA72 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 20:59:28 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 13 May 2013 20:59:28 -0400
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, dsterba@suse.cz, gregkh@linuxfoundation.org,
        paulmck@linux.vnet.ibm.com, chris.mason@fusionio.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 06/12] VFS hot tracking, seq_file: introduce one set of rcu seq_list interfaces
Date: Tue, 14 May 2013 08:59:38 +0800
Message-Id: <1368493184-5939-7-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
References: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  The patch will introduce one set of rcu interface for seq_list.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/seq_file.c            | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/seq_file.h |  7 +++++++
 2 files changed, 44 insertions(+)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 774c1eb..301caa7 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -795,6 +795,43 @@ struct list_head *seq_list_next(void *v, struct list_head *head, loff_t *ppos)
 }
 EXPORT_SYMBOL(seq_list_next);
 
+struct list_head *seq_list_start_rcu(struct list_head *head, loff_t pos)
+{
+	struct list_head *lh;
+
+	__list_for_each_rcu(lh, head)
+		if (pos-- == 0)
+			return lh;
+
+	return NULL;
+}
+EXPORT_SYMBOL(seq_list_start_rcu);
+
+struct list_head *seq_list_start_head_rcu(struct list_head *head, loff_t pos)
+{
+	if (!pos)
+		return head;
+
+	return seq_list_start_rcu(head, pos - 1);
+}
+EXPORT_SYMBOL(seq_list_start_head_rcu);
+
+struct list_head *seq_list_next_rcu(void *v, struct list_head *head,
+					loff_t *ppos)
+{
+	struct list_head *lh;
+
+	++*ppos;
+	rcu_read_lock();
+	lh = rcu_dereference(((struct list_head *)v)->next);
+	if (lh == head)
+		lh = NULL;
+	rcu_read_unlock();
+
+	return lh;
+}
+EXPORT_SYMBOL(seq_list_next_rcu);
+
 /**
  * seq_hlist_start - start an iteration of a hlist
  * @head: the head of the hlist
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 2da29ac..7e391c9 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -155,6 +155,13 @@ extern struct list_head *seq_list_start_head(struct list_head *head,
 extern struct list_head *seq_list_next(void *v, struct list_head *head,
 		loff_t *ppos);
 
+extern struct list_head *seq_list_start_rcu(struct list_head *head,
+		loff_t pos);
+extern struct list_head *seq_list_start_head_rcu(struct list_head *head,
+		loff_t pos);
+extern struct list_head *seq_list_next_rcu(void *v, struct list_head *head,
+		loff_t *ppos);
+
 /*
  * Helpers for iteration over hlist_head-s in seq_files
  */
-- 
1.7.11.7

