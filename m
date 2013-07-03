Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54910 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab3GCOAc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 10:00:32 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r63DODWw003963
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 21:24:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/12] Btrfs-progs: introduce list_{first, next}_entry/list_splice_tail{_init}
Date: Wed, 3 Jul 2013 21:25:18 +0800
Message-Id: <1372857920-4678-11-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 list.h | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 59 insertions(+), 9 deletions(-)

diff --git a/list.h b/list.h
index 50f4619..db7a58c 100644
--- a/list.h
+++ b/list.h
@@ -223,18 +223,18 @@ static inline int list_empty_careful(const struct list_head *head)
 	return (next == head) && (next == head->prev);
 }
 
-static inline void __list_splice(struct list_head *list,
-				 struct list_head *head)
+static inline void __list_splice(const struct list_head *list,
+				 struct list_head *prev,
+				 struct list_head *next)
 {
 	struct list_head *first = list->next;
 	struct list_head *last = list->prev;
-	struct list_head *at = head->next;
 
-	first->prev = head;
-	head->next = first;
+	first->prev = prev;
+	prev->next = first;
 
-	last->next = at;
-	at->prev = last;
+	last->next = next;
+	next->prev = last;
 }
 
 /**
@@ -245,7 +245,19 @@ static inline void __list_splice(struct list_head *list,
 static inline void list_splice(struct list_head *list, struct list_head *head)
 {
 	if (!list_empty(list))
-		__list_splice(list, head);
+		__list_splice(list, head, head->next);
+}
+
+/**
+ * list_splice_tail - join two lists, each list being a queue
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ */
+static inline void list_splice_tail(struct list_head *list,
+				struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice(list, head->prev, head);
 }
 
 /**
@@ -259,7 +271,24 @@ static inline void list_splice_init(struct list_head *list,
 				    struct list_head *head)
 {
 	if (!list_empty(list)) {
-		__list_splice(list, head);
+		__list_splice(list, head, head->next);
+		INIT_LIST_HEAD(list);
+	}
+}
+
+/**
+ * list_splice_tail_init - join two lists and reinitialise the emptied list
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ *
+ * Each of the lists is a queue.
+ * The list at @list is reinitialised
+ */
+static inline void list_splice_tail_init(struct list_head *list,
+					 struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice(list, head->prev, head);
 		INIT_LIST_HEAD(list);
 	}
 }
@@ -274,6 +303,27 @@ static inline void list_splice_init(struct list_head *list,
 	container_of(ptr, type, member)
 
 /**
+ * list_first_entry - get the first element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define list_first_entry(ptr, type, member) \
+	list_entry((ptr)->next, type, member)
+
+/**
+ * list_next_entry - get the next element from a list
+ * @ptr:	the list head to take the element from.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Note, that next is expected to be not null.
+ */
+#define list_next_entry(ptr, member) \
+	list_entry((ptr)->member.next, typeof(*ptr), member)
+
+/**
  * list_for_each	-	iterate over a list
  * @pos:	the &struct list_head to use as a loop cursor.
  * @head:	the head for your list.
-- 
1.8.1.4

