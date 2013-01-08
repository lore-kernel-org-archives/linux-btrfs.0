Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32077 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab3AHOvj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2013 09:51:39 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r08Epcws000463
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2013 14:51:39 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r08Epctv014790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2013 14:51:38 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r08EpbXV005324
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2013 08:51:37 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: fix memory leak on extent map after fsync
Date: Tue,  8 Jan 2013 22:49:21 +0800
Message-Id: <1357656561-24604-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1357656561-24604-1-git-send-email-bo.li.liu@oracle.com>
References: <1357656561-24604-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During fsync, we put the changed parts(i.e. extent map) into the log tree,
and we ship these parts from a list of modified_extents to a local list
to process, of course, we must increment the refs of the extent maps to
avoid it from getting evicted from cache.

The problem is
we don't hold the tree writer lock all the time of iterating the local list,
and it is possible that other threads hack in and delete the extent map from
the local list silently.  So we'll end up with memory leak here.

I hit this when testing xfstest 274 with mount options 'autodefrag,compress=zlib'.

With this fix, the memory leak has gone away.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_map.c |    5 +++--
 fs/btrfs/extent_map.h |    4 ++--
 fs/btrfs/tree-log.c   |   12 +++++-------
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index c025a7a..4c6d271 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -78,6 +78,7 @@ struct extent_map *alloc_extent_map(void)
 	em->generation = 0;
 	atomic_set(&em->refs, 1);
 	INIT_LIST_HEAD(&em->list);
+	INIT_LIST_HEAD(&em->log_list);
 #if LEAK_DEBUG
 	spin_lock_irqsave(&map_leak_lock, flags);
 	list_add(&em->leak_list, &emaps);
@@ -107,6 +108,7 @@ void free_extent_map(struct extent_map *em)
 #endif
 		WARN_ON(em->in_tree);
 		WARN_ON(!list_empty(&em->list));
+		WARN_ON(!list_empty(&em->log_list));
 		kmem_cache_free(extent_map_cache, em);
 	}
 }
@@ -433,8 +435,7 @@ int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
 
 	WARN_ON(test_bit(EXTENT_FLAG_PINNED, &em->flags));
 	rb_erase(&em->rb_node, &tree->map);
-	if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
-		list_del_init(&em->list);
+	list_del_init(&em->list);
 	em->in_tree = 0;
 	return ret;
 }
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index d07a841..ac12389 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -13,8 +13,7 @@
 #define EXTENT_FLAG_COMPRESSED 1
 #define EXTENT_FLAG_VACANCY 2 /* no file extent item found */
 #define EXTENT_FLAG_PREALLOC 3 /* pre-allocated extent */
-#define EXTENT_FLAG_LOGGING 4 /* Logging this extent */
-#define EXTENT_FLAG_FILLING 5 /* Filling in a preallocated extent */
+#define EXTENT_FLAG_FILLING 4 /* Filling in a preallocated extent */
 
 struct extent_map {
 	struct rb_node rb_node;
@@ -35,6 +34,7 @@ struct extent_map {
 	unsigned int in_tree;
 	unsigned int compress_type;
 	struct list_head list;
+	struct list_head log_list;
 	struct list_head leak_list;
 };
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 83186c7..c3ea5bd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3145,8 +3145,8 @@ static int extent_cmp(void *priv, struct list_head *a, struct list_head *b)
 {
 	struct extent_map *em1, *em2;
 
-	em1 = list_entry(a, struct extent_map, list);
-	em2 = list_entry(b, struct extent_map, list);
+	em1 = list_entry(a, struct extent_map, log_list);
+	em2 = list_entry(b, struct extent_map, log_list);
 
 	if (em1->start < em2->start)
 		return -1;
@@ -3400,17 +3400,15 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 			continue;
 		/* Need a ref to keep it from getting evicted from cache */
 		atomic_inc(&em->refs);
-		set_bit(EXTENT_FLAG_LOGGING, &em->flags);
-		list_add_tail(&em->list, &extents);
+		list_add_tail(&em->log_list, &extents);
 	}
 
 	list_sort(NULL, &extents, extent_cmp);
 
 	while (!list_empty(&extents)) {
-		em = list_entry(extents.next, struct extent_map, list);
+		em = list_entry(extents.next, struct extent_map, log_list);
 
-		list_del_init(&em->list);
-		clear_bit(EXTENT_FLAG_LOGGING, &em->flags);
+		list_del_init(&em->log_list);
 
 		/*
 		 * If we had an error we just need to delete everybody from our
-- 
1.7.7.6

