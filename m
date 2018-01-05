Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52852 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752913AbeAEUyK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 15:54:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w05Kqdpe146657
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:09 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2fag5k06ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jan 2018 20:54:09 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w05Ks9sx000454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:09 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w05Ks8R8027708
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:09 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 03/10] Btrfs: add helper for em merge logic
Date: Fri,  5 Jan 2018 12:51:10 -0700
Message-Id: <20180105195117.5131-4-bo.li.liu@oracle.com>
In-Reply-To: <20180105195117.5131-1-bo.li.liu@oracle.com>
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a prepare work for the following extent map selftest, which
runs tests against em merge logic.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h |  2 ++
 fs/btrfs/inode.c | 80 ++++++++++++++++++++++++++++++++------------------------
 2 files changed, 48 insertions(+), 34 deletions(-)

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
index a270fe2..876118c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6911,6 +6911,51 @@ static noinline int uncompress_inline(struct btrfs_path *path,
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
+		/*
+		 * existing will always be non-NULL, since there must be
+		 * extent causing the -EEXIST.
+		 */
+		if (start >= existing->start &&
+		    start < extent_map_end(existing)) {
+			free_extent_map(em);
+			*em_in = existing;
+			ret = 0;
+		} else {
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
+		}
+	}
+
+	ASSERT(ret == 0 || ret == -EEXIST);
+	return ret;
+}
+
 /*
  * a bit scary, this does extent mapping from logical file offset to the disk.
  * the ugly parts come from merging extents from the disk with the in-ram
@@ -7147,40 +7192,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 
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
-		if (start >= existing->start &&
-		    start < extent_map_end(existing)) {
-			free_extent_map(em);
-			em = existing;
-			err = 0;
-		} else {
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
-		}
-	}
+	err = btrfs_add_extent_mapping(em_tree, &em, start, len);
 	write_unlock(&em_tree->lock);
 out:
 
-- 
2.9.4

