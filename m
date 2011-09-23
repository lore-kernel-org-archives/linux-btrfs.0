From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] btrfs/delayed-inode.c: quiet sparse noise
Date: Fri, 23 Sep 2011 11:48:37 -0700
Message-ID: <201109231148.38095.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Quiet the following sparse noise:

warning: symbol 'btrfs_first_delayed_node' was not declared. Should it be static?
warning: symbol 'btrfs_next_delayed_node' was not declared. Should it be static?
warning: symbol 'btrfs_first_prepared_delayed_node' was not declared. Should it be static?
warning: symbol 'btrfs_alloc_delayed_item' was not declared. Should it be static?
warning: symbol '__btrfs_lookup_delayed_insertion_item' was not declared. Should it be static?
warning: symbol '__btrfs_lookup_delayed_deletion_item' was not declared. Should it be static?
warning: symbol '__btrfs_search_delayed_insertion_item' was not declared. Should it be static?
warning: symbol '__btrfs_search_delayed_deletion_item' was not declared. Should it be static?
warning: symbol '__btrfs_first_delayed_insertion_item' was not declared. Should it be static?
warning: symbol '__btrfs_first_delayed_deletion_item' was not declared. Should it be static?
warning: symbol '__btrfs_next_delayed_item' was not declared. Should it be static?

The functions __btrfs_lookup_delayed_deletion_item,
__btrfs_search_delayed_insertion_item, and __btrfs_search_delayed_deletion_item
are not currently being used by the code. They may be eventually, so make them
inline to for to now make sparse happy and allow the linker to discard them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chris Mason <chris.mason@oracle.com>

---

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index b52c672..5d3c397 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -199,8 +199,8 @@ static void btrfs_dequeue_delayed_node(struct btrfs_delayed_root *root,
 	spin_unlock(&root->lock);
 }
 
-struct btrfs_delayed_node *btrfs_first_delayed_node(
-			struct btrfs_delayed_root *delayed_root)
+static struct btrfs_delayed_node *
+btrfs_first_delayed_node(struct btrfs_delayed_root *delayed_root)
 {
 	struct list_head *p;
 	struct btrfs_delayed_node *node = NULL;
@@ -218,8 +218,8 @@ out:
 	return node;
 }
 
-struct btrfs_delayed_node *btrfs_next_delayed_node(
-						struct btrfs_delayed_node *node)
+static struct btrfs_delayed_node *
+btrfs_next_delayed_node(struct btrfs_delayed_node *node)
 {
 	struct btrfs_delayed_root *delayed_root;
 	struct list_head *p;
@@ -279,8 +279,8 @@ static inline void btrfs_release_delayed_node(struct btrfs_delayed_node *node)
 	__btrfs_release_delayed_node(node, 0);
 }
 
-struct btrfs_delayed_node *btrfs_first_prepared_delayed_node(
-					struct btrfs_delayed_root *delayed_root)
+static struct btrfs_delayed_node *
+btrfs_first_prepared_delayed_node(struct btrfs_delayed_root *delayed_root)
 {
 	struct list_head *p;
 	struct btrfs_delayed_node *node = NULL;
@@ -305,7 +305,7 @@ static inline void btrfs_release_prepared_delayed_node(
 	__btrfs_release_delayed_node(node, 1);
 }
 
-struct btrfs_delayed_item *btrfs_alloc_delayed_item(u32 data_len)
+static struct btrfs_delayed_item *btrfs_alloc_delayed_item(u32 data_len)
 {
 	struct btrfs_delayed_item *item;
 	item = kmalloc(sizeof(*item) + data_len, GFP_NOFS);
@@ -380,9 +380,9 @@ static struct btrfs_delayed_item *__btrfs_lookup_delayed_item(
 	return NULL;
 }
 
-struct btrfs_delayed_item *__btrfs_lookup_delayed_insertion_item(
-					struct btrfs_delayed_node *delayed_node,
-					struct btrfs_key *key)
+static struct btrfs_delayed_item *
+__btrfs_lookup_delayed_insertion_item(struct btrfs_delayed_node *delayed_node,
+				      struct btrfs_key *key)
 {
 	struct btrfs_delayed_item *item;
 
@@ -391,9 +391,9 @@ struct btrfs_delayed_item *__btrfs_lookup_delayed_insertion_item(
 	return item;
 }
 
-struct btrfs_delayed_item *__btrfs_lookup_delayed_deletion_item(
-					struct btrfs_delayed_node *delayed_node,
-					struct btrfs_key *key)
+static inline struct btrfs_delayed_item *
+__btrfs_lookup_delayed_deletion_item(struct btrfs_delayed_node *delayed_node,
+				     struct btrfs_key *key)
 {
 	struct btrfs_delayed_item *item;
 
@@ -402,9 +402,9 @@ struct btrfs_delayed_item *__btrfs_lookup_delayed_deletion_item(
 	return item;
 }
 
-struct btrfs_delayed_item *__btrfs_search_delayed_insertion_item(
-					struct btrfs_delayed_node *delayed_node,
-					struct btrfs_key *key)
+static inline struct btrfs_delayed_item *
+__btrfs_search_delayed_insertion_item(struct btrfs_delayed_node *delayed_node,
+				      struct btrfs_key *key)
 {
 	struct btrfs_delayed_item *item, *next;
 
@@ -416,9 +416,9 @@ struct btrfs_delayed_item *__btrfs_search_delayed_insertion_item(
 	return item;
 }
 
-struct btrfs_delayed_item *__btrfs_search_delayed_deletion_item(
-					struct btrfs_delayed_node *delayed_node,
-					struct btrfs_key *key)
+static inline struct btrfs_delayed_item *
+__btrfs_search_delayed_deletion_item(struct btrfs_delayed_node *delayed_node,
+				     struct btrfs_key *key)
 {
 	struct btrfs_delayed_item *item, *next;
 
@@ -525,8 +525,8 @@ static void btrfs_release_delayed_item(struct btrfs_delayed_item *item)
 	}
 }
 
-struct btrfs_delayed_item *__btrfs_first_delayed_insertion_item(
-					struct btrfs_delayed_node *delayed_node)
+static struct btrfs_delayed_item *
+__btrfs_first_delayed_insertion_item(struct btrfs_delayed_node *delayed_node)
 {
 	struct rb_node *p;
 	struct btrfs_delayed_item *item = NULL;
@@ -538,8 +538,8 @@ struct btrfs_delayed_item *__btrfs_first_delayed_insertion_item(
 	return item;
 }
 
-struct btrfs_delayed_item *__btrfs_first_delayed_deletion_item(
-					struct btrfs_delayed_node *delayed_node)
+static struct btrfs_delayed_item *
+__btrfs_first_delayed_deletion_item(struct btrfs_delayed_node *delayed_node)
 {
 	struct rb_node *p;
 	struct btrfs_delayed_item *item = NULL;
@@ -551,8 +551,8 @@ struct btrfs_delayed_item *__btrfs_first_delayed_deletion_item(
 	return item;
 }
 
-struct btrfs_delayed_item *__btrfs_next_delayed_item(
-						struct btrfs_delayed_item *item)
+static struct btrfs_delayed_item *
+__btrfs_next_delayed_item(struct btrfs_delayed_item *item)
 {
 	struct rb_node *p;
 	struct btrfs_delayed_item *next = NULL;
