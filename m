Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaKCWxT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Nov 2014 17:53:19 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id C010DAC0F
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Nov 2014 22:53:18 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: libbtrfs, make exported headers compatible with C++
Date: Mon,  3 Nov 2014 23:53:17 +0100
Message-Id: <1415055197-22806-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add externs and don't use a reserved keyword.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 rbtree-utils.h     |  8 ++++++++
 rbtree.h           | 10 +++++++++-
 rbtree_augmented.h |  8 ++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/rbtree-utils.h b/rbtree-utils.h
index 7298c72eba3d..718581ff105c 100644
--- a/rbtree-utils.h
+++ b/rbtree-utils.h
@@ -21,6 +21,10 @@
 
 #include "rbtree.h"
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 /* The common insert/search/free functions */
 typedef int (*rb_compare_nodes)(struct rb_node *node1, struct rb_node *node2);
 typedef int (*rb_compare_keys)(struct rb_node *node, void *key);
@@ -42,4 +46,8 @@ static void free_##name##_tree(struct rb_root *root)	\
 	rb_free_nodes(root, free_func);			\
 }
 
+#ifdef __cplusplus
+}
+#endif
+
 #endif
diff --git a/rbtree.h b/rbtree.h
index 03c06d8ec16a..0d4f2bfd5a5e 100644
--- a/rbtree.h
+++ b/rbtree.h
@@ -34,6 +34,10 @@
 #include <btrfs/kerncompat.h>
 #endif /* BTRFS_FLAT_INCLUDES */
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 struct rb_node {
 	unsigned long  __rb_parent_color;
 	struct rb_node *rb_right;
@@ -75,7 +79,7 @@ extern struct rb_node *rb_first_postorder(const struct rb_root *);
 extern struct rb_node *rb_next_postorder(const struct rb_node *);
 
 /* Fast replacement of a single node without remove/rebalance/add/rebalance */
-extern void rb_replace_node(struct rb_node *victim, struct rb_node *new, 
+extern void rb_replace_node(struct rb_node *victim, struct rb_node *new_node,
 			    struct rb_root *root);
 
 static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
@@ -107,4 +111,8 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
 			typeof(*pos), field); 1; }); \
 	     pos = n)
 
+#ifdef __cplusplus
+}
+#endif
+
 #endif	/* _LINUX_RBTREE_H */
diff --git a/rbtree_augmented.h b/rbtree_augmented.h
index 079eb978dc4d..cbc963981667 100644
--- a/rbtree_augmented.h
+++ b/rbtree_augmented.h
@@ -26,6 +26,10 @@
 
 #include "rbtree.h"
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 /*
  * Please note - only struct rb_augment_callbacks and the prototypes for
  * rb_insert_augmented() and rb_erase_augmented() are intended to be public.
@@ -228,4 +232,8 @@ rb_erase_augmented(struct rb_node *node, struct rb_root *root,
 		__rb_erase_color(rebalance, root, augment->rotate);
 }
 
+#ifdef __cplusplus
+}
+#endif
+
 #endif	/* _LINUX_RBTREE_AUGMENTED_H */
-- 
2.1.1

