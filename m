Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31045 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3JNFBO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 01:01:14 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r9E51CTP000600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:13 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E51BNs016387
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:12 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E51Bbi029817
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:11 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v7 08/13] Btrfs: make ordered extent aware of dedup
Date: Mon, 14 Oct 2013 12:59:50 +0800
Message-Id: <1381726796-27191-9-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
References: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds a dedup flag and dedup hash into ordered extent so that
we can insert dedup extents to dedup tree at endio time.

The benefit is simplicity, we don't need to fall back to cleanup dedup
structures if the write is cancelled for some reasons.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ordered-data.c |   38 ++++++++++++++++++++++++++++++++------
 fs/btrfs/ordered-data.h |   13 ++++++++++++-
 2 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index c702cb6..48fecc9 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -183,7 +183,8 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
  */
 static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int dio, int compress_type)
+				      int type, int dio, int compress_type,
+				      int dedup, struct btrfs_dedup_hash *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ordered_inode_tree *tree;
@@ -199,10 +200,23 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	entry->start = start;
 	entry->len = len;
 	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM) &&
-	    !(type == BTRFS_ORDERED_NOCOW))
+	    !(type == BTRFS_ORDERED_NOCOW) && !dedup)
 		entry->csum_bytes_left = disk_len;
 	entry->disk_len = disk_len;
 	entry->bytes_left = len;
+	entry->dedup = dedup;
+	entry->hash = NULL;
+
+	if (!dedup && hash) {
+		entry->hash = kzalloc(btrfs_dedup_hash_size(hash->type),
+				      GFP_NOFS);
+		if (!entry->hash) {
+			kmem_cache_free(btrfs_ordered_extent_cache, entry);
+			return -ENOMEM;
+		}
+		memcpy(entry->hash, hash, btrfs_dedup_hash_size(hash->type));
+	}
+
 	entry->inode = igrab(inode);
 	entry->compress_type = compress_type;
 	entry->truncated_len = (u64)-1;
@@ -251,7 +265,17 @@ int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 0,
-					  BTRFS_COMPRESS_NONE);
+					  BTRFS_COMPRESS_NONE, 0, NULL);
+}
+
+int btrfs_add_ordered_extent_dedup(struct inode *inode, u64 file_offset,
+				   u64 start, u64 len, u64 disk_len, int type,
+				   int dedup, struct btrfs_dedup_hash *hash,
+				   int compress_type)
+{
+	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
+					  disk_len, type, 0,
+					  compress_type, dedup, hash);
 }
 
 int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
@@ -259,16 +283,17 @@ int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 1,
-					  BTRFS_COMPRESS_NONE);
+					  BTRFS_COMPRESS_NONE, 0, NULL);
 }
 
 int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int compress_type)
+				      int type, int compress_type,
+				      struct btrfs_dedup_hash *hash)
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 0,
-					  compress_type);
+					  compress_type, 0, hash);
 }
 
 /*
@@ -501,6 +526,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 			list_del(&sum->list);
 			kfree(sum);
 		}
+		kfree(entry->hash);
 		kmem_cache_free(btrfs_ordered_extent_cache, entry);
 	}
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 0c0b356..e5eac12 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -109,6 +109,9 @@ struct btrfs_ordered_extent {
 	/* compression algorithm */
 	int compress_type;
 
+	/* whether this ordered extent is marked for dedup or not */
+	int dedup;
+
 	/* reference count */
 	atomic_t refs;
 
@@ -135,6 +138,9 @@ struct btrfs_ordered_extent {
 	struct completion completion;
 	struct btrfs_work flush_work;
 	struct list_head work_list;
+
+	/* dedup hash of sha256 type */
+	struct btrfs_dedup_hash *hash;
 };
 
 /*
@@ -168,11 +174,16 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 				   int uptodate);
 int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 			     u64 start, u64 len, u64 disk_len, int type);
+int btrfs_add_ordered_extent_dedup(struct inode *inode, u64 file_offset,
+				   u64 start, u64 len, u64 disk_len, int type,
+				   int dedup, struct btrfs_dedup_hash *hash,
+				   int compress_type);
 int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 				 u64 start, u64 len, u64 disk_len, int type);
 int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int compress_type);
+				      int type, int compress_type,
+				      struct btrfs_dedup_hash *hash);
 void btrfs_add_ordered_sum(struct inode *inode,
 			   struct btrfs_ordered_extent *entry,
 			   struct btrfs_ordered_sum *sum);
-- 
1.7.7

