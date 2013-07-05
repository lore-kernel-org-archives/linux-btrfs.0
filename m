Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59751 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab3GEWMR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 18:12:17 -0400
Date: Fri, 5 Jul 2013 16:41:29 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] list: add list_del_each_entry
Message-ID: <20130705204129.GB15943@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <20130705204100.GA15943@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20130705204100.GA15943@logfs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have seen a lot of boilerplate code that either follows the pattern of
	while (!list_empty(head)) {
		pos = list_entry(head->next, struct foo, list);
		list_del(pos->list);
		...
	}
or some variant thereof.

With this patch in, people can use
	list_del_each_entry(pos, head, list) {
		...
	}

The patch also adds a list_del_each variant, even though I have
only found a single user for that one so far.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 include/linux/list.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/list.h b/include/linux/list.h
index 6a1f8df..ab39c7d 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -557,6 +557,24 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_safe_reset_next(pos, n, member)				\
 	n = list_entry(pos->member.next, typeof(*pos), member)
 
+/**
+ * list_del_each - removes an entry from the list until it is empty
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head of your list.
+ */
+#define list_del_each(pos, head) \
+	while (list_empty(head) ? 0 : (pos = (head)->next, list_del(pos), 1))
+
+/**
+ * list_del_each_entry - removes an entry from the list until it is empty
+ * @pos:	the type * to use as loop cursor.
+ * @head:	the head of your list.
+ * @member:	the name of the list_struct within the struct
+ */
+#define list_del_each_entry(pos, head, member) \
+	while (list_empty(head) && (pos = list_first_entry((head), \
+		typeof(*pos), member), list_del((head)->next), 1))
+
 /*
  * Double linked lists with a single pointer list head.
  * Mostly useful for hash tables where the two pointer list head is
-- 
1.7.10.4

