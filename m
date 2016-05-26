Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44880 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751128AbcEZJnT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 05:43:19 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id A1FB0489F97E
	for <linux-btrfs@vger.kernel.org>; Thu, 26 May 2016 17:43:09 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: make btrfs-image restore to support dup
Date: Thu, 26 May 2016 17:43:00 +0800
Message-ID: <1464255780-14429-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously btrfs-image restore would set the chunk items to have 1 stripe,
even if the chunk is dup. If you use btrfsck on the restored file system,
some dev_extent will not find any relative chunk stripe, and the
bytes-used of dev_item will not equal to the dev_extents's total_bytes.
This patch store a additional physical just for the dup case when build
the in-memory chunk-tree.
Currently btrfsck on the restored file system, only single and dup is no
problem. raid* support should be added in the future.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-image.c | 143 +++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 97 insertions(+), 46 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 8a1b799..d121951 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -68,6 +68,12 @@ struct meta_cluster {
 struct fs_chunk {
 	u64 logical;
 	u64 physical;
+	/* physical_dup only store additonal physical for BTRFS_BLOCK_GROUP_DUP
+	 * currently restore only support single and dup
+	 * TODO: modify this structure and the function related to this
+	 * structure for support raid*
+	 */
+	u64 physical_dup;
 	u64 bytes;
 	struct rb_node l;
 	struct rb_node p;
@@ -290,7 +296,8 @@ static struct rb_node *tree_search(struct rb_root *root,
 	return NULL;
 }
 
-static u64 logical_to_physical(struct mdrestore_struct *mdres, u64 logical, u64 *size)
+static u64 logical_to_physical(struct mdrestore_struct *mdres, u64 logical,
+			       u64 *size, u64 *physical_dup)
 {
 	struct fs_chunk *fs_chunk;
 	struct rb_node *entry;
@@ -312,6 +319,14 @@ static u64 logical_to_physical(struct mdrestore_struct *mdres, u64 logical, u64
 		BUG();
 	offset = search.logical - fs_chunk->logical;
 
+	if (physical_dup) {
+		/* only in dup case, physical_dup is not equal to 0 */
+		if (fs_chunk->physical_dup)
+			*physical_dup = fs_chunk->physical_dup + offset;
+		else
+			*physical_dup = 0;
+	}
+
 	*size = min(*size, fs_chunk->bytes + fs_chunk->logical - logical);
 	return fs_chunk->physical + offset;
 }
@@ -1451,20 +1466,26 @@ static int update_super(struct mdrestore_struct *mdres, u8 *buffer)
 		cur += sizeof(*disk_key);
 
 		if (key.type == BTRFS_CHUNK_ITEM_KEY) {
-			u64 physical, size = 0;
+			u64 type, physical, physical_dup, size = 0;
 
 			chunk = (struct btrfs_chunk *)ptr;
 			old_num_stripes = btrfs_stack_chunk_num_stripes(chunk);
 			chunk = (struct btrfs_chunk *)write_ptr;
 
 			memmove(write_ptr, ptr, sizeof(*chunk));
-			btrfs_set_stack_chunk_num_stripes(chunk, 1);
 			btrfs_set_stack_chunk_sub_stripes(chunk, 0);
-			btrfs_set_stack_chunk_type(chunk,
-						   BTRFS_BLOCK_GROUP_SYSTEM);
+			type = btrfs_stack_chunk_type(chunk);
+			if (type & BTRFS_BLOCK_GROUP_DUP) {
+				new_array_size += sizeof(struct btrfs_stripe);
+				write_ptr += sizeof(struct btrfs_stripe);
+			} else {
+				btrfs_set_stack_chunk_num_stripes(chunk, 1);
+				btrfs_set_stack_chunk_type(chunk,
+						BTRFS_BLOCK_GROUP_SYSTEM);
+			}
 			chunk->stripe.devid = super->dev_item.devid;
 			physical = logical_to_physical(mdres, key.offset,
-						       &size);
+						       &size, &physical_dup);
 			if (size != (u64)-1)
 				btrfs_set_stack_stripe_offset(&chunk->stripe,
 							      physical);
@@ -1573,41 +1594,47 @@ static int fixup_chunk_tree_block(struct mdrestore_struct *mdres,
 			goto next;
 
 		for (i = 0; i < btrfs_header_nritems(eb); i++) {
-			struct btrfs_chunk chunk;
+			struct btrfs_chunk *chunk;
 			struct btrfs_key key;
-			u64 type, physical, size = (u64)-1;
+			u64 type, physical, physical_dup, size = (u64)-1;
 
 			btrfs_item_key_to_cpu(eb, &key, i);
 			if (key.type != BTRFS_CHUNK_ITEM_KEY)
 				continue;
-			truncate_item(eb, i, sizeof(chunk));
-			read_extent_buffer(eb, &chunk,
-					   btrfs_item_ptr_offset(eb, i),
-					   sizeof(chunk));
 
 			size = 0;
 			physical = logical_to_physical(mdres, key.offset,
-						       &size);
+						       &size, &physical_dup);
+
+			if (!physical_dup)
+				truncate_item(eb, i, sizeof(*chunk));
+			chunk = btrfs_item_ptr(eb, i, struct btrfs_chunk);
+
 
 			/* Zero out the RAID profile */
-			type = btrfs_stack_chunk_type(&chunk);
+			type = btrfs_chunk_type(eb, chunk);
 			type &= (BTRFS_BLOCK_GROUP_DATA |
 				 BTRFS_BLOCK_GROUP_SYSTEM |
 				 BTRFS_BLOCK_GROUP_METADATA |
 				 BTRFS_BLOCK_GROUP_DUP);
-			btrfs_set_stack_chunk_type(&chunk, type);
+			btrfs_set_chunk_type(eb, chunk, type);
 
-			btrfs_set_stack_chunk_num_stripes(&chunk, 1);
-			btrfs_set_stack_chunk_sub_stripes(&chunk, 0);
-			btrfs_set_stack_stripe_devid(&chunk.stripe, mdres->devid);
+			if (!physical_dup)
+				btrfs_set_chunk_num_stripes(eb, chunk, 1);
+			btrfs_set_chunk_sub_stripes(eb, chunk, 0);
+			btrfs_set_stripe_devid_nr(eb, chunk, 0, mdres->devid);
 			if (size != (u64)-1)
-				btrfs_set_stack_stripe_offset(&chunk.stripe,
-							      physical);
-			memcpy(chunk.stripe.dev_uuid, mdres->uuid,
-			       BTRFS_UUID_SIZE);
-			write_extent_buffer(eb, &chunk,
-					    btrfs_item_ptr_offset(eb, i),
-					    sizeof(chunk));
+				btrfs_set_stripe_offset_nr(eb, chunk, 0,
+							   physical);
+			/* update stripe 2 offset */
+			if (physical_dup)
+				btrfs_set_stripe_offset_nr(eb, chunk, 1,
+							   physical_dup);
+
+			write_extent_buffer(eb, mdres->uuid,
+					(unsigned long)btrfs_stripe_dev_uuid_nr(
+						chunk, 0),
+					BTRFS_UUID_SIZE);
 		}
 		memcpy(buffer, eb->data, eb->len);
 		csum_block(buffer, eb->len);
@@ -1680,7 +1707,7 @@ static void *restore_worker(void *data)
 	}
 
 	while (1) {
-		u64 bytenr;
+		u64 bytenr, physical_dup;
 		off_t offset = 0;
 		int err = 0;
 
@@ -1732,27 +1759,37 @@ static void *restore_worker(void *data)
 				u64 chunk_size = size;
 				if (!mdres->multi_devices && !mdres->old_restore)
 					bytenr = logical_to_physical(mdres,
-								     async->start + offset,
-								     &chunk_size);
+						     async->start + offset,
+						     &chunk_size,
+						     &physical_dup);
 				else
 					bytenr = async->start + offset;
 
 				ret = pwrite64(outfd, outbuf+offset, chunk_size,
 					       bytenr);
-				if (ret != chunk_size) {
-					if (ret < 0) {
-						fprintf(stderr, "Error writing to "
-							"device %d\n", errno);
-						err = errno;
-						break;
-					} else {
-						fprintf(stderr, "Short write\n");
-						err = -EIO;
-						break;
-					}
-				}
+				if (ret != chunk_size)
+					goto error;
+
+				if (physical_dup)
+					ret = pwrite64(outfd, outbuf+offset,
+						       chunk_size,
+						       physical_dup);
+				if (ret != chunk_size)
+					goto error;
+
 				size -= chunk_size;
 				offset += chunk_size;
+				continue;
+
+error:
+				if (ret < 0) {
+					fprintf(stderr, "Error writing to device %d\n",
+							errno);
+					err = errno;
+				} else {
+					fprintf(stderr, "Short write\n");
+					err = -EIO;
+				}
 			}
 		} else if (async->start != BTRFS_SUPER_INFO_OFFSET) {
 			ret = write_data_to_disk(mdres->info, outbuf, async->start, size, 0);
@@ -2017,9 +2054,10 @@ static int read_chunk_block(struct mdrestore_struct *mdres, u8 *buffer,
 	}
 
 	for (i = 0; i < btrfs_header_nritems(eb); i++) {
-		struct btrfs_chunk chunk;
+		struct btrfs_chunk *chunk;
 		struct fs_chunk *fs_chunk;
 		struct btrfs_key key;
+		u64 type;
 
 		if (btrfs_header_level(eb)) {
 			u64 blockptr = btrfs_node_blockptr(eb, i);
@@ -2043,12 +2081,11 @@ static int read_chunk_block(struct mdrestore_struct *mdres, u8 *buffer,
 			break;
 		}
 		memset(fs_chunk, 0, sizeof(*fs_chunk));
-		read_extent_buffer(eb, &chunk, btrfs_item_ptr_offset(eb, i),
-				   sizeof(chunk));
+		chunk = btrfs_item_ptr(eb, i, struct btrfs_chunk);
 
 		fs_chunk->logical = key.offset;
-		fs_chunk->physical = btrfs_stack_stripe_offset(&chunk.stripe);
-		fs_chunk->bytes = btrfs_stack_chunk_length(&chunk);
+		fs_chunk->physical = btrfs_stripe_offset_nr(eb, chunk, 0);
+		fs_chunk->bytes = btrfs_chunk_length(eb, chunk);
 		INIT_LIST_HEAD(&fs_chunk->list);
 		if (tree_search(&mdres->physical_tree, &fs_chunk->p,
 				physical_cmp, 1) != NULL)
@@ -2056,11 +2093,25 @@ static int read_chunk_block(struct mdrestore_struct *mdres, u8 *buffer,
 		else
 			tree_insert(&mdres->physical_tree, &fs_chunk->p,
 				    physical_cmp);
-		if (fs_chunk->physical + fs_chunk->bytes >
+
+		type = btrfs_chunk_type(eb, chunk);
+		if (type & BTRFS_BLOCK_GROUP_DUP) {
+			fs_chunk->physical_dup =
+					btrfs_stripe_offset_nr(eb, chunk, 1);
+		}
+
+		if (fs_chunk->physical_dup + fs_chunk->bytes >
+		    mdres->last_physical_offset)
+			mdres->last_physical_offset = fs_chunk->physical_dup +
+				fs_chunk->bytes;
+		else if (fs_chunk->physical + fs_chunk->bytes >
 		    mdres->last_physical_offset)
 			mdres->last_physical_offset = fs_chunk->physical +
 				fs_chunk->bytes;
 		mdres->alloced_chunks += fs_chunk->bytes;
+		/* in dup case, fs_chunk->bytes should add twice */
+		if (fs_chunk->physical_dup)
+			mdres->alloced_chunks += fs_chunk->bytes;
 		tree_insert(&mdres->chunk_tree, &fs_chunk->l, chunk_cmp);
 	}
 out:
-- 
2.5.5



