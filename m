Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57328 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755160AbdLUXpk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 18:45:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBLNfeS1082957
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:40 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2f0prs01ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:39 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBLNjdkw006268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:39 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBLNjcXL008943
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:39 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 01/10] Btrfs: add helper for em merge logic
Date: Thu, 21 Dec 2017 15:42:47 -0700
Message-Id: <20171221224256.18196-2-bo.li.liu@oracle.com>
In-Reply-To: <20171221224256.18196-1-bo.li.liu@oracle.com>
References: <20171221224256.18196-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a prepare work for the following extent map selftest, which
runs tests against em merge logic.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h |   2 ++
 fs/btrfs/inode.c | 101 ++++++++++++++++++++++++++++++-------------------------
 2 files changed, 58 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b2e09fe..328f40f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3148,6 +3148,8 @@ struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
 						    int delay_iput);
 void btrfs_wait_and_free_delalloc_work(struct btrfs_delalloc_work *work);
 
+int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
+			     struct extent_map **em_in, u64 start, u64 len);
 struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
 		struct page *page, size_t pg_offset, u64 start,
 		u64 len, int create);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e1a7f3c..527df6f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6911,6 +6911,61 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 	return ret;
 }
 
+int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
+			     struct extent_map **em_in, u64 start, u64 len)
+{
+	int ret;
+	struct extent_map *em = *em_in;
+
+	ret = add_extent_mapping(em_tree, em, 0);
+	/* it is possible that someone inserted the extent into the tree
+	 * while we had the lock dropped.  It is also possible that
+	 * an overlapping map exists in the tree
+	 */
+	if (ret == -EEXIST) {
+		struct extent_map *existing;
+
+		ret = 0;
+
+		existing = search_extent_mapping(em_tree, start, len);
+
+		/*
+		 * existing will always be non-NULL, since there must be
+		 * extent causing the -EEXIST.
+		 */
+		if (existing->start == em->start &&
+		    extent_map_end(existing) >= extent_map_end(em) &&
+		    em->block_start == existing->block_start) {
+			/*
+			 * The existing extent map already encompasses the
+			 * entire extent map we tried to add.
+			 */
+			free_extent_map(em);
+			*em_in = existing;
+			ret = 0;
+		} else if (start >= extent_map_end(existing) ||
+		    start <= existing->start) {
+			/*
+			 * The existing extent map is the one nearest to
+			 * the [start, start + len) range which overlaps
+			 */
+			ret = merge_extent_mapping(em_tree, existing,
+						   em, start);
+			free_extent_map(existing);
+			if (ret) {
+				free_extent_map(em);
+				*em_in = NULL;
+			}
+		} else {
+			free_extent_map(em);
+			*em_in = existing;
+			ret = 0;
+		}
+	}
+	ASSERT(ret == 0 || ret == -EEXIST);
+	return ret;
+}
+
 /*
  * a bit scary, this does extent mapping from logical file offset to the disk.
  * the ugly parts come from merging extents from the disk with the in-ram
@@ -7147,51 +7202,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 
 	err = 0;
 	write_lock(&em_tree->lock);
-	ret = add_extent_mapping(em_tree, em, 0);
-	/* it is possible that someone inserted the extent into the tree
-	 * while we had the lock dropped.  It is also possible that
-	 * an overlapping map exists in the tree
-	 */
-	if (ret == -EEXIST) {
-		struct extent_map *existing;
-
-		ret = 0;
-
-		existing = search_extent_mapping(em_tree, start, len);
-		/*
-		 * existing will always be non-NULL, since there must be
-		 * extent causing the -EEXIST.
-		 */
-		if (existing->start == em->start &&
-		    extent_map_end(existing) >= extent_map_end(em) &&
-		    em->block_start == existing->block_start) {
-			/*
-			 * The existing extent map already encompasses the
-			 * entire extent map we tried to add.
-			 */
-			free_extent_map(em);
-			em = existing;
-			err = 0;
-
-		} else if (start >= extent_map_end(existing) ||
-		    start <= existing->start) {
-			/*
-			 * The existing extent map is the one nearest to
-			 * the [start, start + len) range which overlaps
-			 */
-			err = merge_extent_mapping(em_tree, existing,
-						   em, start);
-			free_extent_map(existing);
-			if (err) {
-				free_extent_map(em);
-				em = NULL;
-			}
-		} else {
-			free_extent_map(em);
-			em = existing;
-			err = 0;
-		}
-	}
+	err = btrfs_add_extent_mapping(em_tree, &em, start, len);
 	write_unlock(&em_tree->lock);
 out:
 
-- 
2.9.4

