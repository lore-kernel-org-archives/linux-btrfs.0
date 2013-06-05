Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59379 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3FEDcx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jun 2013 23:32:53 -0400
Date: Tue, 4 Jun 2013 22:03:41 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arne Jansen <sensille@gmx.net>
Cc: Chris Mason <clmason@fusionio.com>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] list: add while_list_drain_entry
Message-ID: <20130605020341.GA27240@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <20130603204930.GA28299@infradead.org>
 <20130603193647.GB10200@logfs.org>
 <20130603195555.GC10200@logfs.org>
 <20130604144856.GA12302@infradead.org>
 <20130604145322.4088.78915@localhost.localdomain>
 <51AE4969.8050709@gmx.net>
 <20130604184435.GA23436@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20130604184435.GA23436@logfs.org>
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
	while_list_drain_entry(pos, head, list) {
		...
	}

The patch also adds a while_list_drain variant, even though I have
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
+ * while_list_drain - removes an entry from the list until it is empty
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head of your list.
+ */
+#define while_list_drain(pos, head) \
+	while (list_empty(head) ? 0 : (pos = (head)->next, list_del(pos), 1))
+
+/**
+ * while_list_drain_entry - removes an entry from the list until it is empty
+ * @pos:	the type * to use as loop cursor.
+ * @head:	the head of your list.
+ * @member:	the name of the list_struct within the struct
+ */
+#define while_list_drain_entry(pos, head, member) \
+	while (list_empty(head) && (pos = list_first_entry((head), \
+		typeof(*pos), member), list_del((head)->next), 1))
+
 /*
  * Double linked lists with a single pointer list head.
  * Mostly useful for hash tables where the two pointer list head is
-- 
1.7.10.4

