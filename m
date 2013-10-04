Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:48064 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3JDTzr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Oct 2013 15:55:47 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <sekharan@us.ibm.com>;
	Fri, 4 Oct 2013 13:55:47 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 4DEAE1FF0021
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Oct 2013 13:55:37 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r94JthVE367318
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Oct 2013 13:55:44 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r94JthUT007299
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Oct 2013 13:55:43 -0600
Received: from [9.41.106.170] (chandra-dt.austin.ibm.com [9.41.106.170])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id r94JtgPo007246
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Oct 2013 13:55:42 -0600
Subject: [PATCH] Btrfs: Simplify the logic in alloc_extent_buffer() for
 existing extent buffer case
From: Chandra Seetharaman <sekharan@us.ibm.com>
Reply-To: sekharan@us.ibm.com
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Oct 2013 14:55:29 -0500
Message-ID: <1380916529.22521.122.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

alloc_extent_buffer() uses radix_tree_lookup() when radix_tree_insert() fails
with EEXIST. That part of the code is very similar to the code in
find_extent_buffer(). This patch replaces radix_tree_lookup() and surrounding
code in alloc_extent_buffer() with find_extent_buffer().

While at it, this patch also changes the other usage of radix_tree_lookup() in
alloc_extent_buffer() with find_extent_buffer() to reduce redundancy.

Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c09a40d..50345fb 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4451,6 +4451,23 @@ static void mark_extent_buffer_accessed(struct extent_buffer *eb)
 	}
 }
 
+struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
+					 u64 start, unsigned long len)
+{
+	struct extent_buffer *eb;
+
+	rcu_read_lock();
+	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
+	if (eb && atomic_inc_not_zero(&eb->refs)) {
+		rcu_read_unlock();
+		mark_extent_buffer_accessed(eb);
+		return eb;
+	}
+	rcu_read_unlock();
+
+	return NULL;
+}
+
 struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 					  u64 start, unsigned long len)
 {
@@ -4464,14 +4481,10 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 	int uptodate = 1;
 	int ret;
 
-	rcu_read_lock();
-	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
-	if (eb && atomic_inc_not_zero(&eb->refs)) {
-		rcu_read_unlock();
-		mark_extent_buffer_accessed(eb);
+
+	eb = find_extent_buffer(tree, start, len);
+	if (eb)
 		return eb;
-	}
-	rcu_read_unlock();
 
 	eb = __alloc_extent_buffer(tree, start, len, GFP_NOFS);
 	if (!eb)
@@ -4530,24 +4543,17 @@ again:
 
 	spin_lock(&tree->buffer_lock);
 	ret = radix_tree_insert(&tree->buffer, start >> PAGE_CACHE_SHIFT, eb);
+	spin_unlock(&tree->buffer_lock);
+	radix_tree_preload_end();
 	if (ret == -EEXIST) {
-		exists = radix_tree_lookup(&tree->buffer,
-						start >> PAGE_CACHE_SHIFT);
-		if (!atomic_inc_not_zero(&exists->refs)) {
-			spin_unlock(&tree->buffer_lock);
-			radix_tree_preload_end();
-			exists = NULL;
+		exists = find_extent_buffer(tree, start, len);
+		if (exists)
+			goto free_eb;
+		else
 			goto again;
-		}
-		spin_unlock(&tree->buffer_lock);
-		radix_tree_preload_end();
-		mark_extent_buffer_accessed(exists);
-		goto free_eb;
 	}
 	/* add one reference for the tree */
 	check_buffer_tree_ref(eb);
-	spin_unlock(&tree->buffer_lock);
-	radix_tree_preload_end();
 
 	/*
 	 * there is a race where release page may have
@@ -4578,23 +4584,6 @@ free_eb:
 	return exists;
 }
 
-struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
-					 u64 start, unsigned long len)
-{
-	struct extent_buffer *eb;
-
-	rcu_read_lock();
-	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
-	if (eb && atomic_inc_not_zero(&eb->refs)) {
-		rcu_read_unlock();
-		mark_extent_buffer_accessed(eb);
-		return eb;
-	}
-	rcu_read_unlock();
-
-	return NULL;
-}
-
 static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
 {
 	struct extent_buffer *eb =


