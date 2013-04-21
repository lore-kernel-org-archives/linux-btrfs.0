Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab3DUGcV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Apr 2013 02:32:21 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3L6WKSU007583
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Apr 2013 02:32:20 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r3L6WIqw028323
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Apr 2013 02:32:19 -0400
Message-ID: <517387F8.506@redhat.com>
Date: Sun, 21 Apr 2013 01:32:24 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: move leak debug code to functions
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There was a time when sprinkling #ifdefs around was
bad form.  ;)  We can clean up the code a bit by moving
the leak-list adds/removes into functions and make things
more readable.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

p.s. maybe _debug_ should be in the function names?
*shrug* 

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 223aa6a..c4f163c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -30,6 +30,29 @@ static LIST_HEAD(states);
 #define LEAK_DEBUG 0
 #if LEAK_DEBUG
 static DEFINE_SPINLOCK(leak_lock);
+
+static inline
+void btrfs_leak_list_add(struct list_head *new, struct list_head *head)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&leak_lock, flags);
+	list_add(new, head);
+	spin_unlock_irqrestore(&leak_lock, flags);
+}
+
+static inline
+void btrfs_leak_list_del(struct list_head *entry)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&leak_lock, flags);
+	list_del(entry);
+	spin_unlock_irqrestore(&leak_lock, flags);
+}
+#else
+#define btrfs_leak_list_add(new, head)	do {} while (0);
+#define btrfs_leak_list_del(entry)	do {} while (0);
 #endif
 
 #define BUFFER_LRU_MAX 64
@@ -96,7 +119,6 @@ void extent_io_exit(void)
 		       state->state, state->tree, atomic_read(&state->refs));
 		list_del(&state->leak_list);
 		kmem_cache_free(extent_state_cache, state);
-
 	}
 
 	while (!list_empty(&buffers)) {
@@ -134,9 +156,6 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 static struct extent_state *alloc_extent_state(gfp_t mask)
 {
 	struct extent_state *state;
-#if LEAK_DEBUG
-	unsigned long flags;
-#endif
 
 	state = kmem_cache_alloc(extent_state_cache, mask);
 	if (!state)
@@ -144,11 +163,7 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 	state->state = 0;
 	state->private = 0;
 	state->tree = NULL;
-#if LEAK_DEBUG
-	spin_lock_irqsave(&leak_lock, flags);
-	list_add(&state->leak_list, &states);
-	spin_unlock_irqrestore(&leak_lock, flags);
-#endif
+	btrfs_leak_list_add(&state->leak_list, &states);
 	atomic_set(&state->refs, 1);
 	init_waitqueue_head(&state->wq);
 	trace_alloc_extent_state(state, mask, _RET_IP_);
@@ -160,15 +175,8 @@ void free_extent_state(struct extent_state *state)
 	if (!state)
 		return;
 	if (atomic_dec_and_test(&state->refs)) {
-#if LEAK_DEBUG
-		unsigned long flags;
-#endif
 		WARN_ON(state->tree);
-#if LEAK_DEBUG
-		spin_lock_irqsave(&leak_lock, flags);
-		list_del(&state->leak_list);
-		spin_unlock_irqrestore(&leak_lock, flags);
-#endif
+		btrfs_leak_list_del(&state->leak_list);
 		trace_free_extent_state(state, _RET_IP_);
 		kmem_cache_free(extent_state_cache, state);
 	}
@@ -4010,12 +4018,7 @@ out:
 
 static void __free_extent_buffer(struct extent_buffer *eb)
 {
-#if LEAK_DEBUG
-	unsigned long flags;
-	spin_lock_irqsave(&leak_lock, flags);
-	list_del(&eb->leak_list);
-	spin_unlock_irqrestore(&leak_lock, flags);
-#endif
+	btrfs_leak_list_del(&eb->leak_list);
 	kmem_cache_free(extent_buffer_cache, eb);
 }
 
@@ -4025,9 +4028,6 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 						   gfp_t mask)
 {
 	struct extent_buffer *eb = NULL;
-#if LEAK_DEBUG
-	unsigned long flags;
-#endif
 
 	eb = kmem_cache_zalloc(extent_buffer_cache, mask);
 	if (eb == NULL)
@@ -4047,11 +4047,8 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	init_waitqueue_head(&eb->write_lock_wq);
 	init_waitqueue_head(&eb->read_lock_wq);
 
-#if LEAK_DEBUG
-	spin_lock_irqsave(&leak_lock, flags);
-	list_add(&eb->leak_list, &buffers);
-	spin_unlock_irqrestore(&leak_lock, flags);
-#endif
+	btrfs_leak_list_add(&eb->leak_list, &buffers);
+
 	spin_lock_init(&eb->refs_lock);
 	atomic_set(&eb->refs, 1);
 	atomic_set(&eb->io_pages, 0);


