Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59363 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab3FCTgG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 15:36:06 -0400
Date: Mon, 3 Jun 2013 14:07:05 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] introduce list_for_each_entry_del
Message-ID: <20130603180705.GA10200@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1370280485-10047-1-git-send-email-joern@logfs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 3 June 2013 13:28:03 -0400, Joern Engel wrote:
> 
> Drawback is that object size is growing.  I think an ideal compiler
> should be able to optimize all the overhead away, but 4.7 just isn't
> there yet.  Or maybe I just messed up - patches are only
> compile-tested after all.  Comments/ideas are welcome.

Actually, replacing the inline function with a bit of macro hell seems
to yield identical object size again.  And in the case of
compression.o, it even removes 528 bytes or so of object code.

New 1/2 below.

Jörn

--
A defeated army first battles and then seeks victory.
-- Sun Tzu

[PATCH 1/2] list: add list_for_each_entry_del

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
 include/linux/list.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/list.h b/include/linux/list.h
index 6a1f8df..49325ca 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -483,6 +483,27 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
+ * list_for_each_remove - iterate over a list, deleting each entry
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head of your list.
+ *
+ * Calls list_del() on pos on each iteration
+ */
+#define list_for_each_del(pos, head) \
+	while (list_empty(head) ? 0 : (pos = (head)->next, list_del(pos), 1))
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
+	while (list_empty(head) ? 0 : (pos = list_first_entry((head), typeof(*pos), member), list_del(&pos->member), 1))
+
+/**
  * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
-- 
1.7.10.4

