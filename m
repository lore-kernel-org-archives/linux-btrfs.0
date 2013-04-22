Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab3DVQMc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 12:12:32 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3MGCW43008108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 12:12:32 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r3MGCV91025983
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 12:12:31 -0400
Message-ID: <5175616F.1010007@redhat.com>
Date: Mon, 22 Apr 2013 11:12:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V3] btrfs: move leak debug code to functions
References: <517387F8.506@redhat.com>
In-Reply-To: <517387F8.506@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Clean up the leak debugging in extent_io.c by moving
the debug code into functions.  This also removes the
list_heads used for debugging from the extent_buffer
and extent_state structures when debug is not enabled.

Since we need a global debug config to do that last
part, implement CONFIG_BTRFS_DEBUG to accommodate.

Thanks to Dave Sterba for the Kconfig bit.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Now we can move other #ifdef DEBUG under this same
config, but not all of them; some look like they
would be way too chatty.  I'll need to review those
before ending another patch to add any of them
under CONFIG_BTRFS_DEBUG.

Thanks,
-Eric

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 9a8622a..42dc602 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -52,3 +52,13 @@ config BTRFS_FS_CHECK_INTEGRITY
 	  In most cases, unless you are a btrfs developer who needs
 	  to verify the integrity of (super)-block write requests
 	  during the run of a regression test, say N
+
+config BTRFS_DEBUG
+	bool "Btrfs debugging support"
+	depends on BTRFS_FS
+	help
+	  Enable run-time debugging support for the btrfs filesystem. This may
+	  enable additional and expensive checks with negative impact on
+	  performance, or export extra information via sysfs.
+
+	  If unsure, say N.
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 223aa6a..6f5eda8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -24,12 +24,62 @@
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
 
+#ifdef CONFIG_BTRFS_DEBUG
 static LIST_HEAD(buffers);
 static LIST_HEAD(states);
 
-#define LEAK_DEBUG 0
-#if LEAK_DEBUG
 static DEFINE_SPINLOCK(leak_lock);
+
+static inline
+void btrfs_leak_debug_add(struct list_head *new, struct list_head *head)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&leak_lock, flags);
+	list_add(new, head);
+	spin_unlock_irqrestore(&leak_lock, flags);
+}
+
+static inline
+void btrfs_leak_debug_del(struct list_head *entry)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&leak_lock, flags);
+	list_del(entry);
+	spin_unlock_irqrestore(&leak_lock, flags);
+}
+
+static inline
+void btrfs_leak_debug_check()
+{
+	struct extent_state *state;
+	struct extent_buffer *eb;
+
+	while (!list_empty(&states)) {
+		state = list_entry(states.next, struct extent_state, leak_list);
+		printk(KERN_ERR "btrfs state leak: start %llu end %llu "
+		       "state %lu in tree %p refs %d\n",
+		       (unsigned long long)state->start,
+		       (unsigned long long)state->end,
+		       state->state, state->tree, atomic_read(&state->refs));
+		list_del(&state->leak_list);
+		kmem_cache_free(extent_state_cache, state);
+	}
+
+	while (!list_empty(&buffers)) {
+		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
+		printk(KERN_ERR "btrfs buffer leak start %llu len %lu "
+		       "refs %d\n", (unsigned long long)eb->start,
+		       eb->len, atomic_read(&eb->refs));
+		list_del(&eb->leak_list);
+		kmem_cache_free(extent_buffer_cache, eb);
+	}
+}
+#else
+#define btrfs_leak_debug_add(new, head)	do {} while (0)
+#define btrfs_leak_debug_del(entry)	do {} while (0)
+#define btrfs_leak_debug_check(entry)	do {} while (0)
 #endif
 
 #define BUFFER_LRU_MAX 64
@@ -84,29 +134,7 @@ free_state_cache:
 
 void extent_io_exit(void)
 {
-	struct extent_state *state;
-	struct extent_buffer *eb;
-
-	while (!list_empty(&states)) {
-		state = list_entry(states.next, struct extent_state, leak_list);
-		printk(KERN_ERR "btrfs state leak: start %llu end %llu "
-		       "state %lu in tree %p refs %d\n",
-		       (unsigned long long)state->start,
-		       (unsigned long long)state->end,
-		       state->state, state->tree, atomic_read(&state->refs));
-		list_del(&state->leak_list);
-		kmem_cache_free(extent_state_cache, state);
-
-	}
-
-	while (!list_empty(&buffers)) {
-		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
-		printk(KERN_ERR "btrfs buffer leak start %llu len %lu "
-		       "refs %d\n", (unsigned long long)eb->start,
-		       eb->len, atomic_read(&eb->refs));
-		list_del(&eb->leak_list);
-		kmem_cache_free(extent_buffer_cache, eb);
-	}
+	btrfs_leak_debug_check();
 
 	/*
 	 * Make sure all delayed rcu free are flushed before we
@@ -134,9 +162,6 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 static struct extent_state *alloc_extent_state(gfp_t mask)
 {
 	struct extent_state *state;
-#if LEAK_DEBUG
-	unsigned long flags;
-#endif
 
 	state = kmem_cache_alloc(extent_state_cache, mask);
 	if (!state)
@@ -144,11 +169,7 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 	state->state = 0;
 	state->private = 0;
 	state->tree = NULL;
-#if LEAK_DEBUG
-	spin_lock_irqsave(&leak_lock, flags);
-	list_add(&state->leak_list, &states);
-	spin_unlock_irqrestore(&leak_lock, flags);
-#endif
+	btrfs_leak_debug_add(&state->leak_list, &states);
 	atomic_set(&state->refs, 1);
 	init_waitqueue_head(&state->wq);
 	trace_alloc_extent_state(state, mask, _RET_IP_);
@@ -160,15 +181,8 @@ void free_extent_state(struct extent_state *state)
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
+		btrfs_leak_debug_del(&state->leak_list);
 		trace_free_extent_state(state, _RET_IP_);
 		kmem_cache_free(extent_state_cache, state);
 	}
@@ -4010,12 +4024,7 @@ out:
 
 static void __free_extent_buffer(struct extent_buffer *eb)
 {
-#if LEAK_DEBUG
-	unsigned long flags;
-	spin_lock_irqsave(&leak_lock, flags);
-	list_del(&eb->leak_list);
-	spin_unlock_irqrestore(&leak_lock, flags);
-#endif
+	btrfs_leak_debug_del(&eb->leak_list);
 	kmem_cache_free(extent_buffer_cache, eb);
 }
 
@@ -4025,9 +4034,6 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 						   gfp_t mask)
 {
 	struct extent_buffer *eb = NULL;
-#if LEAK_DEBUG
-	unsigned long flags;
-#endif
 
 	eb = kmem_cache_zalloc(extent_buffer_cache, mask);
 	if (eb == NULL)
@@ -4047,11 +4053,8 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	init_waitqueue_head(&eb->write_lock_wq);
 	init_waitqueue_head(&eb->read_lock_wq);
 
-#if LEAK_DEBUG
-	spin_lock_irqsave(&leak_lock, flags);
-	list_add(&eb->leak_list, &buffers);
-	spin_unlock_irqrestore(&leak_lock, flags);
-#endif
+	btrfs_leak_debug_add(&eb->leak_list, &buffers);
+
 	spin_lock_init(&eb->refs_lock);
 	atomic_set(&eb->refs, 1);
 	atomic_set(&eb->io_pages, 0);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 295c888..a478250 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -116,7 +116,9 @@ struct extent_state {
 	/* for use by the FS */
 	u64 private;
 
+#ifdef CONFIG_BTRFS_DEBUG
 	struct list_head leak_list;
+#endif
 };
 
 #define INLINE_EXTENT_BUFFER_PAGES 16
@@ -132,7 +134,6 @@ struct extent_buffer {
 	atomic_t refs;
 	atomic_t io_pages;
 	int read_mirror;
-	struct list_head leak_list;
 	struct rcu_head rcu_head;
 	pid_t lock_owner;
 
@@ -159,6 +160,9 @@ struct extent_buffer {
 	wait_queue_head_t read_lock_wq;
 	wait_queue_head_t lock_wq;
 	struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
+#ifdef CONFIG_BTRFS_DEBUG
+	struct list_head leak_list;
+#endif
 };
 
 static inline void extent_set_compress_type(unsigned long *bio_flags,


