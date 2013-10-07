Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:41008 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab3JGPrD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 11:47:03 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <sekharan@us.ibm.com>;
	Mon, 7 Oct 2013 09:47:02 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 28BE919D8051
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Oct 2013 09:46:59 -0600 (MDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r97Fl0XF273024
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 09:47:00 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r97Fo8Gn031501
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 09:50:08 -0600
Subject: [PATCH] Btrfs: Simplify the logic in alloc_extent_buffer() for
 existing extent buffer case
From: Chandra Seetharaman <sekharan@us.ibm.com>
Reply-To: sekharan@us.ibm.com
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Cc: Zach Brown <zab@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Oct 2013 10:45:25 -0500
Message-ID: <1381160725.22521.143.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

alloc_extent_buffer() uses radix_tree_lookup() when radix_tree_insert()
fails with EEXIST. That part of the code is very similar to the code in
find_extent_buffer(). This patch replaces radix_tree_lookup() and
surrounding code in alloc_extent_buffer() with find_extent_buffer().

Note that radix_tree_lookup() does not need to be protected by
tree->buffer_lock. It is protected by eb->refs.

While at it, this patch 
  - changes the other usage of radix_tree_lookup() in alloc_extent_buffer()
    with find_extent_buffer() to reduce redundancy.
  - removes the unused argument 'len' to find_extent_buffer().

Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Reviewed-by: Zach Brown <zab@redhat.com>

---
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4ae17ed..daa04d2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1105,8 +1105,7 @@ struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 {
 	struct inode *btree_inode = root->fs_info->btree_inode;
 	struct extent_buffer *eb;
-	eb = find_extent_buffer(&BTRFS_I(btree_inode)->io_tree,
-				bytenr, blocksize);
+	eb = find_extent_buffer(&BTRFS_I(btree_inode)->io_tree, bytenr);
 	return eb;
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c09a40d..f45b4e8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4451,6 +4451,23 @@ static void mark_extent_buffer_accessed(struct extent_buffer *eb)
 	}
 }
 
+struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
+					 		u64 start)
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
+	eb = find_extent_buffer(tree, start);
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
+		exists = find_extent_buffer(tree, start);
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
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 6dbc645..a4b75af 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -271,7 +271,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 struct extent_buffer *alloc_dummy_extent_buffer(u64 start, unsigned long len);
 struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src);
 struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
-					 u64 start, unsigned long len);
+					 u64 start);
 void free_extent_buffer(struct extent_buffer *eb);
 void free_extent_buffer_stale(struct extent_buffer *eb);
 #define WAIT_NONE	0


