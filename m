Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12296 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751436AbbDUGVv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 02:21:51 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3L6KcGc025456
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2015 14:20:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 16/18] btrfs: ulist: Add ulist_del() function.
Date: Tue, 21 Apr 2015 14:21:32 +0800
Message-ID: <1429597294-11875-17-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1429597294-11875-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1429597294-11875-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function will delete unode with given (val,aux) pair.
And with this patch, seqnum for debug usage doesn't have any meaning
now, so remove them.

This is used by later patches to skip snapshot root.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ulist.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/ulist.h |  1 +
 2 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 840a38b..91feb2b 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -132,6 +132,15 @@ static struct ulist_node *ulist_rbtree_search(struct ulist *ulist, u64 val)
 	return NULL;
 }
 
+static void ulist_rbtree_erase(struct ulist *ulist, struct ulist_node *node)
+{
+	rb_erase(&node->rb_node, &ulist->root);
+	list_del(&node->list);
+	kfree(node);
+	BUG_ON(ulist->nnodes == 0);
+	ulist->nnodes--;
+}
+
 static int ulist_rbtree_insert(struct ulist *ulist, struct ulist_node *ins)
 {
 	struct rb_node **p = &ulist->root.rb_node;
@@ -197,9 +206,6 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 
 	node->val = val;
 	node->aux = aux;
-#ifdef CONFIG_BTRFS_DEBUG
-	node->seqnum = ulist->nnodes;
-#endif
 
 	ret = ulist_rbtree_insert(ulist, node);
 	ASSERT(!ret);
@@ -209,6 +215,33 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 	return 1;
 }
 
+/*
+ * ulist_del - delete one node from ulist
+ * @ulist:	ulist to remove node from
+ * @val:	value to delete
+ * @aux:	aux to delete
+ *
+ * The deletion will only be done when *BOTH* val and aux matches.
+ * Return 0 for successful delete.
+ * Return > 0 for not found.
+ */
+int ulist_del(struct ulist *ulist, u64 val, u64 aux)
+{
+	struct ulist_node *node;
+
+	node = ulist_rbtree_search(ulist, val);
+	/* Not found */
+	if (!node)
+		return 1;
+
+	if (node->aux != aux)
+		return 1;
+
+	/* Found and delete */
+	ulist_rbtree_erase(ulist, node);
+	return 0;
+}
+
 /**
  * ulist_next - iterate ulist
  * @ulist:	ulist to iterate
@@ -237,15 +270,7 @@ struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)
 		uiter->cur_list = uiter->cur_list->next;
 	} else {
 		uiter->cur_list = ulist->nodes.next;
-#ifdef CONFIG_BTRFS_DEBUG
-		uiter->i = 0;
-#endif
 	}
 	node = list_entry(uiter->cur_list, struct ulist_node, list);
-#ifdef CONFIG_BTRFS_DEBUG
-	ASSERT(node->seqnum == uiter->i);
-	ASSERT(uiter->i >= 0 && uiter->i < ulist->nnodes);
-	uiter->i++;
-#endif
 	return node;
 }
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index 4c29db6..a01a2c4 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -57,6 +57,7 @@ void ulist_free(struct ulist *ulist);
 int ulist_add(struct ulist *ulist, u64 val, u64 aux, gfp_t gfp_mask);
 int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 		    u64 *old_aux, gfp_t gfp_mask);
+int ulist_del(struct ulist *ulist, u64 val, u64 aux);
 
 /* just like ulist_add_merge() but take a pointer for the aux data */
 static inline int ulist_add_merge_ptr(struct ulist *ulist, u64 val, void *aux,
-- 
2.3.5

