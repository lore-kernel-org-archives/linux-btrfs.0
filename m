Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab3FDWSG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Jun 2013 18:18:06 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r54MI6Cv018477
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Jun 2013 18:18:06 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r54MI2Q6002655
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Jun 2013 18:18:06 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs: simplify finding next/prev delayed items
Date: Tue,  4 Jun 2013 15:17:58 -0700
Message-Id: <1370384280-28652-5-git-send-email-zab@redhat.com>
In-Reply-To: <1370384280-28652-1-git-send-email-zab@redhat.com>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'd like to use the currently unused next/prev arguments to
__btrfs_lookup_delayed_item() in a future patch.  I noticed that the
code could be simplified.

We don't need to use rb_next() or rb_prev() to walk back up the tree
once we've failed to find the key at a leaf.  We can record the most
recent next and prev items as we descend and return those when the
search fails.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/delayed-inode.c | 54 +++++++++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index bc753fc..67e0f9f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -326,11 +326,11 @@ static struct btrfs_delayed_item *btrfs_alloc_delayed_item(u32 data_len)
  * __btrfs_lookup_delayed_item - look up the delayed item by key
  * @delayed_node: pointer to the delayed node
  * @key:	  the key to look up
- * @prev:	  used to store the prev item if the right item isn't found
- * @next:	  used to store the next item if the right item isn't found
+ * @prev:	  set to the item before @key when it isn't found
+ * @next:	  set to the item after @key when it isn't found
  *
- * Note: if we don't find the right item, we will return the prev item and
- * the next item.
+ * @prev and @next are only correct if the search terminates at a leaf so
+ * they're only set if an item with @key is not found.
  */
 static struct btrfs_delayed_item *__btrfs_lookup_delayed_item(
 				struct rb_root *root,
@@ -338,48 +338,36 @@ static struct btrfs_delayed_item *__btrfs_lookup_delayed_item(
 				struct btrfs_delayed_item **prev,
 				struct btrfs_delayed_item **next)
 {
-	struct rb_node *node, *prev_node = NULL;
+	struct rb_node *node = root->rb_node;
+	struct btrfs_delayed_item *prev_item = NULL;
+	struct btrfs_delayed_item *next_item = NULL;
 	struct btrfs_delayed_item *delayed_item = NULL;
-	int ret = 0;
+	int ret;
 
-	node = root->rb_node;
+	if (prev)
+		*prev = NULL;
+	if (next)
+		*next = NULL;
 
 	while (node) {
 		delayed_item = rb_entry(node, struct btrfs_delayed_item,
 					rb_node);
-		prev_node = node;
 		ret = btrfs_comp_cpu_keys(&delayed_item->key, key);
-		if (ret < 0)
+		if (ret < 0) {
+			prev_item = delayed_item;
 			node = node->rb_right;
-		else if (ret > 0)
+		} else if (ret > 0) {
+			next_item = delayed_item;
 			node = node->rb_left;
-		else
+		} else
 			return delayed_item;
 	}
 
-	if (prev) {
-		if (!prev_node)
-			*prev = NULL;
-		else if (ret < 0)
-			*prev = delayed_item;
-		else if ((node = rb_prev(prev_node)) != NULL) {
-			*prev = rb_entry(node, struct btrfs_delayed_item,
-					 rb_node);
-		} else
-			*prev = NULL;
-	}
+	if (prev)
+		*prev = prev_item;
+	if (next)
+		*next = next_item;
 
-	if (next) {
-		if (!prev_node)
-			*next = NULL;
-		else if (ret > 0)
-			*next = delayed_item;
-		else if ((node = rb_next(prev_node)) != NULL) {
-			*next = rb_entry(node, struct btrfs_delayed_item,
-					 rb_node);
-		} else
-			*next = NULL;
-	}
 	return NULL;
 }
 
-- 
1.7.11.7

