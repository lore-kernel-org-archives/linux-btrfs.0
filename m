Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59360 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab3FCS5o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 14:57:44 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 1/2] list: add list_for_each_entry_del
Date: Mon,  3 Jun 2013 13:28:04 -0400
Message-Id: <1370280485-10047-2-git-send-email-joern@logfs.org>
In-Reply-To: <1370280485-10047-1-git-send-email-joern@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
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
	list_for_each_entry_del(pos, head, list) {
		...
	}

The patch also adds a list_for_each_del variant, even though I have
only found a single user for that one so far.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 include/linux/list.h |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/linux/list.h b/include/linux/list.h
index 6a1f8df..e09fe10 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -361,6 +361,17 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_first_entry(ptr, type, member) \
 	list_entry((ptr)->next, type, member)
 
+static inline struct list_head *list_first_del(struct list_head *head)
+{
+	struct list_head *item;
+
+	if (list_empty(head))
+		return NULL;
+	item = head->next;
+	list_del(item);
+	return item;
+}
+
 /**
  * list_for_each	-	iterate over a list
  * @pos:	the &struct list_head to use as a loop cursor.
@@ -483,6 +494,28 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
+ * list_for_each_remove - iterate over a list, deleting each entry
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head of your list.
+ *
+ * Calls list_del() on pos on each iteration
+ */
+#define list_for_each_del(pos, head) \
+	while ((pos = list_first_del(head)))
+
+/**
+ * list_for_each_entry_remove - iterate over a list of given type, deleting each entry
+ * @pos:	the type * to use as loop cursor.
+ * @head:	the head of your list.
+ * @member:	the name of the list_struct within the struct
+ *
+ * Calls list_del() on pos on each iteration
+ */
+#define list_for_each_entry_del(pos, head, member) \
+	while (pos = list_entry(list_first_del(head), typeof(*pos), member), \
+			&pos->member)
+
+/**
  * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
-- 
1.7.10.4

