Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32052 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab3AHOvi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2013 09:51:38 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r08Epaq9000400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2013 14:51:37 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r08EpauS022763
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2013 14:51:36 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r08EpaKh005312
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2013 08:51:36 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: add leak debug for extent map
Date: Tue,  8 Jan 2013 22:49:20 +0800
Message-Id: <1357656561-24604-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is for detecting extent map leak.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_map.c |   31 +++++++++++++++++++++++++++++++
 fs/btrfs/extent_map.h |    1 +
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index f169d6b..c025a7a 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -9,6 +9,13 @@
 
 static struct kmem_cache *extent_map_cache;
 
+static LIST_HEAD(emaps);
+
+#define LEAK_DEBUG 0
+#if LEAK_DEBUG
+static DEFINE_SPINLOCK(map_leak_lock);
+#endif
+
 int __init extent_map_init(void)
 {
 	extent_map_cache = kmem_cache_create("btrfs_extent_map",
@@ -21,6 +28,16 @@ int __init extent_map_init(void)
 
 void extent_map_exit(void)
 {
+	struct extent_map *em;
+
+	while (!list_empty(&emaps)) {
+		em = list_entry(emaps.next, struct extent_map, leak_list);
+		printk(KERN_ERR "btrfs ext map leak: start %llu len %llu block %llu flags %llu refs %d in tree %d compress %d\n",
+			em->start, em->len, em->block_start, em->flags, atomic_read(&em->refs), em->in_tree, em->compress_type);
+		list_del(&em->leak_list);
+		kmem_cache_free(extent_map_cache, em);
+	}
+
 	if (extent_map_cache)
 		kmem_cache_destroy(extent_map_cache);
 }
@@ -48,6 +65,9 @@ void extent_map_tree_init(struct extent_map_tree *tree)
  */
 struct extent_map *alloc_extent_map(void)
 {
+#if LEAK_DEBUG
+	unsigned long flags;
+#endif
 	struct extent_map *em;
 	em = kmem_cache_zalloc(extent_map_cache, GFP_NOFS);
 	if (!em)
@@ -58,6 +78,11 @@ struct extent_map *alloc_extent_map(void)
 	em->generation = 0;
 	atomic_set(&em->refs, 1);
 	INIT_LIST_HEAD(&em->list);
+#if LEAK_DEBUG
+	spin_lock_irqsave(&map_leak_lock, flags);
+	list_add(&em->leak_list, &emaps);
+	spin_unlock_irqrestore(&map_leak_lock, flags);
+#endif
 	return em;
 }
 
@@ -74,6 +99,12 @@ void free_extent_map(struct extent_map *em)
 		return;
 	WARN_ON(atomic_read(&em->refs) == 0);
 	if (atomic_dec_and_test(&em->refs)) {
+#if LEAK_DEBUG
+		unsigned long flags;
+		spin_lock_irqsave(&map_leak_lock, flags);
+		list_del(&em->leak_list);
+		spin_unlock_irqrestore(&map_leak_lock, flags);
+#endif
 		WARN_ON(em->in_tree);
 		WARN_ON(!list_empty(&em->list));
 		kmem_cache_free(extent_map_cache, em);
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 922943c..d07a841 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -35,6 +35,7 @@ struct extent_map {
 	unsigned int in_tree;
 	unsigned int compress_type;
 	struct list_head list;
+	struct list_head leak_list;
 };
 
 struct extent_map_tree {
-- 
1.7.7.6

