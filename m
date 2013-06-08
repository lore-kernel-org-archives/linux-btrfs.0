Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51830 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3FHJpb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Jun 2013 05:45:31 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r589jUuq026057
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 8 Jun 2013 09:45:31 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r589jT49014812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 8 Jun 2013 09:45:30 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r589jTH0012914
	for <linux-btrfs@vger.kernel.org>; Sat, 8 Jun 2013 09:45:29 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: elaborate error handling of mkfs
Date: Sat,  8 Jun 2013 17:45:14 +0800
Message-Id: <1370684714-30373-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

$./mkfs.btrfs -f /dev/sdd -b 2M
[...]
mkfs.btrfs: volumes.c:845: btrfs_alloc_chunk: Assertion `!(ret)' failed.
Aborted (core dumped).

We should return error to userspace instead of the above.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 mkfs.c    |   23 +++++++++++++++--------
 volumes.c |   16 +++++++++++-----
 2 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 7ff60e5..e3789cc 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -74,31 +74,36 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 				     BTRFS_BLOCK_GROUP_SYSTEM,
 				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     0, BTRFS_MKFS_SYSTEM_GROUP_SIZE);
-	BUG_ON(ret);
+	if (ret)
+		goto err;
 
 	if (mixed) {
 		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
 					&chunk_start, &chunk_size,
 					BTRFS_BLOCK_GROUP_METADATA |
 					BTRFS_BLOCK_GROUP_DATA);
-		BUG_ON(ret);
+		if (ret)
+			goto err;
 		ret = btrfs_make_block_group(trans, root, 0,
 					     BTRFS_BLOCK_GROUP_METADATA |
 					     BTRFS_BLOCK_GROUP_DATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
-		BUG_ON(ret);
+		if (ret)
+			goto err;
 		printf("Created a data/metadata chunk of size %llu\n", chunk_size);
 	} else {
 		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
 					&chunk_start, &chunk_size,
 					BTRFS_BLOCK_GROUP_METADATA);
-		BUG_ON(ret);
+		if (ret)
+			goto err;
 		ret = btrfs_make_block_group(trans, root, 0,
 					     BTRFS_BLOCK_GROUP_METADATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
-		BUG_ON(ret);
+		if (ret)
+			goto err;
 	}
 
 	root->fs_info->system_allocs = 0;
@@ -110,12 +115,14 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
 					&chunk_start, &chunk_size,
 					BTRFS_BLOCK_GROUP_DATA);
-		BUG_ON(ret);
+		if (ret)
+			goto err;
 		ret = btrfs_make_block_group(trans, root, 0,
 					     BTRFS_BLOCK_GROUP_DATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
-		BUG_ON(ret);
+		if (ret)
+			goto err;
 	}
 
 	ret = btrfs_make_root_dir(trans, root->fs_info->tree_root,
@@ -1460,7 +1467,7 @@ int main(int ac, char **av)
 
 	ret = make_root_dir(root, mixed);
 	if (ret) {
-		fprintf(stderr, "failed to setup the root directory\n");
+		fprintf(stderr, "failed to setup the root directory %d\n", ret);
 		exit(1);
 	}
 
diff --git a/volumes.c b/volumes.c
index d6f81f8..8285240 100644
--- a/volumes.c
+++ b/volumes.c
@@ -842,11 +842,13 @@ again:
 			     info->chunk_root->root_key.objectid,
 			     BTRFS_FIRST_CHUNK_TREE_OBJECTID, key.offset,
 			     calc_size, &dev_offset);
-		BUG_ON(ret);
+		if (ret)
+			goto out;
 
 		device->bytes_used += calc_size;
 		ret = btrfs_update_device(trans, device);
-		BUG_ON(ret);
+		if (ret)
+			goto out;
 
 		map->stripes[index].dev = device;
 		map->stripes[index].physical = dev_offset;
@@ -878,7 +880,6 @@ again:
 
 	ret = btrfs_insert_item(trans, chunk_root, &key, chunk,
 				btrfs_chunk_item_size(num_stripes));
-	BUG_ON(ret);
 	*start = key.offset;;
 
 	map->ce.start = key.offset;
@@ -887,14 +888,19 @@ again:
 	ret = insert_existing_cache_extent(
 			   &extent_root->fs_info->mapping_tree.cache_tree,
 			   &map->ce);
-	BUG_ON(ret);
+	if (ret)
+		goto out;
 
 	if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		ret = btrfs_add_system_chunk(trans, chunk_root, &key,
 				    chunk, btrfs_chunk_item_size(num_stripes));
-		BUG_ON(ret);
+		if (ret)
+			goto out;
 	}
 
+out:
+	if (ret)
+		kfree(map);
 	kfree(chunk);
 	return ret;
 }
-- 
1.7.7

