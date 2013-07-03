Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54910 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab3GCOAj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 10:00:39 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r63DODx6003962
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 21:24:15 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/12] Btrfs-progs: recover raid0/raid10/raid5/raid6 metadata chunk
Date: Wed, 3 Jul 2013 21:25:20 +0800
Message-Id: <1372857920-4678-13-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

According to the bytenr of the extent buffer record, we can calculate the index
of the stripes, and we also know which device and where we read out the extent
buffer record, that means we can know the relationship between the device extent
and the stripes in the chunk, by this relationship, we can recover the raid0/radi10/
raid5/raid6 metadata chunk.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-chunk.c | 289 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 279 insertions(+), 10 deletions(-)

diff --git a/cmds-chunk.c b/cmds-chunk.c
index 7b740a3..03314de 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -43,6 +43,7 @@
 
 #define BTRFS_CHUNK_TREE_REBUILD_ABORTED	-7500
 #define BTRFS_STRIPE_LEN			(64 * 1024)
+#define BTRFS_NUM_MIRRORS			2
 
 struct recover_control {
 	int verbose;
@@ -59,11 +60,102 @@ struct recover_control {
 	struct cache_tree chunk;
 	struct block_group_tree bg;
 	struct device_extent_tree devext;
+	struct cache_tree eb_cache;
 
 	struct list_head good_chunks;
 	struct list_head bad_chunks;
+	struct list_head unrepaired_chunks;
 };
 
+struct extent_record {
+	struct cache_extent cache;
+	u64 generation;
+	u8 csum[BTRFS_CSUM_SIZE];
+	struct btrfs_device *devices[BTRFS_NUM_MIRRORS];
+	u64 offsets[BTRFS_NUM_MIRRORS];
+	int nmirrors;
+};
+
+static struct extent_record *btrfs_new_extent_record(struct extent_buffer *eb)
+{
+	struct extent_record *rec;
+
+	rec = malloc(sizeof(*rec));
+	if (!rec) {
+		fprintf(stderr, "Fail to allocate memory for extent record.\n");
+		exit(1);
+	}
+
+	memset(rec, 0, sizeof(*rec));
+	rec->cache.start = btrfs_header_bytenr(eb);
+	rec->cache.size = eb->len;
+	rec->generation = btrfs_header_generation(eb);
+	read_extent_buffer(eb, rec->csum, (unsigned long)btrfs_header_csum(eb),
+			   BTRFS_CSUM_SIZE);
+	return rec;
+}
+
+static int process_extent_buffer(struct cache_tree *eb_cache,
+				 struct extent_buffer *eb,
+				 struct btrfs_device *device, u64 offset)
+{
+	struct extent_record *rec;
+	struct extent_record *exist;
+	struct cache_extent *cache;
+	int ret = 0;
+
+	rec = btrfs_new_extent_record(eb);
+	if (!rec->cache.size)
+		goto free_out;
+again:
+	cache = lookup_cache_extent(eb_cache,
+				    rec->cache.start,
+				    rec->cache.size);
+	if (cache) {
+		exist = container_of(cache, struct extent_record, cache);
+
+		if (exist->generation > rec->generation)
+			goto free_out;
+		if (exist->generation == rec->generation) {
+			if (exist->cache.start != rec->cache.start ||
+			    exist->cache.size != rec->cache.size ||
+			    memcmp(exist->csum, rec->csum, BTRFS_CSUM_SIZE)) {
+				ret = -EEXIST;
+			} else {
+				BUG_ON(exist->nmirrors >= BTRFS_NUM_MIRRORS);
+				exist->devices[exist->nmirrors] = device;
+				exist->offsets[exist->nmirrors] = offset;
+				exist->nmirrors++;
+			}
+			goto free_out;
+		}
+		remove_cache_extent(eb_cache, cache);
+		free(exist);
+		goto again;
+	}
+
+	rec->devices[0] = device;
+	rec->offsets[0] = offset;
+	rec->nmirrors++;
+	ret = insert_cache_extent(eb_cache, &rec->cache);
+	BUG_ON(ret);
+out:
+	return ret;
+free_out:
+	free(rec);
+	goto out;
+}
+
+static void free_extent_record(struct cache_extent *cache)
+{
+	struct extent_record *er;
+
+	er = container_of(cache, struct extent_record, cache);
+	free(er);
+}
+
+FREE_EXTENT_CACHE_BASED_TREE(extent_record, free_extent_record);
+
 static struct btrfs_chunk *create_chunk_item(struct chunk_record *record)
 {
 	struct btrfs_chunk *ret;
@@ -100,11 +192,13 @@ void init_recover_control(struct recover_control *rc, int verbose, int yes)
 {
 	memset(rc, 0, sizeof(struct recover_control));
 	cache_tree_init(&rc->chunk);
+	cache_tree_init(&rc->eb_cache);
 	block_group_tree_init(&rc->bg);
 	device_extent_tree_init(&rc->devext);
 
 	INIT_LIST_HEAD(&rc->good_chunks);
 	INIT_LIST_HEAD(&rc->bad_chunks);
+	INIT_LIST_HEAD(&rc->unrepaired_chunks);
 
 	rc->verbose = verbose;
 	rc->yes = yes;
@@ -115,6 +209,7 @@ void free_recover_control(struct recover_control *rc)
 	free_block_group_tree(&rc->bg);
 	free_chunk_cache_tree(&rc->chunk);
 	free_device_extent_tree(&rc->devext);
+	free_extent_record_tree(&rc->eb_cache);
 }
 
 static int process_block_group_item(struct block_group_tree *bg_cache,
@@ -554,11 +649,12 @@ static int check_all_chunks_by_metadata(struct recover_control *rc,
 					struct btrfs_root *root)
 {
 	struct chunk_record *chunk;
+	struct chunk_record *next;
 	LIST_HEAD(orphan_chunks);
 	int ret = 0;
 	int err;
 
-	list_for_each_entry(chunk, &rc->good_chunks, list) {
+	list_for_each_entry_safe(chunk, next, &rc->good_chunks, list) {
 		err = check_chunk_by_metadata(rc, root, chunk, 0);
 		if (err) {
 			if (err == -ENOENT)
@@ -568,6 +664,14 @@ static int check_all_chunks_by_metadata(struct recover_control *rc,
 		}
 	}
 
+	list_for_each_entry_safe(chunk, next, &rc->unrepaired_chunks, list) {
+		err = check_chunk_by_metadata(rc, root, chunk, 1);
+		if (err == -ENOENT)
+			list_move_tail(&chunk->list, &orphan_chunks);
+		else if (err && !ret)
+			ret = err;
+	}
+
 	list_for_each_entry(chunk, &rc->bad_chunks, list) {
 		err = check_chunk_by_metadata(rc, root, chunk, 1);
 		if (err != -ENOENT && !ret)
@@ -617,7 +721,8 @@ static inline int is_super_block_address(u64 offset)
 	return 0;
 }
 
-static int scan_one_device(struct recover_control *rc, int fd)
+static int scan_one_device(struct recover_control *rc, int fd,
+			   struct btrfs_device *device)
 {
 	struct extent_buffer *buf;
 	u64 bytenr;
@@ -649,6 +754,10 @@ static int scan_one_device(struct recover_control *rc, int fd)
 			continue;
 		}
 
+		ret = process_extent_buffer(&rc->eb_cache, buf, device, bytenr);
+		if (ret)
+			goto out;
+
 		if (btrfs_header_level(buf) != 0)
 			goto next_node;
 
@@ -692,7 +801,7 @@ static int scan_devices(struct recover_control *rc)
 				dev->name);
 			return -1;
 		}
-		ret = scan_one_device(rc, fd);
+		ret = scan_one_device(rc, fd, dev);
 		close(fd);
 		if (ret)
 			return ret;
@@ -1299,7 +1408,7 @@ static int btrfs_verify_device_extents(struct block_group_record *bg,
 	int expected_num_stripes;
 
 	expected_num_stripes = calc_num_stripes(bg->flags);
-	if (!expected_num_stripes && expected_num_stripes != ndevexts)
+	if (expected_num_stripes && expected_num_stripes != ndevexts)
 		return 1;
 
 	strpie_length = calc_stripe_length(bg->flags, bg->offset, ndevexts);
@@ -1337,16 +1446,174 @@ static int btrfs_rebuild_unordered_chunk_stripes(struct recover_control *rc,
 	return 0;
 }
 
+static int btrfs_calc_stripe_index(struct chunk_record *chunk, u64 logical)
+{
+	u64 offset = logical - chunk->offset;
+	int stripe_nr;
+	int nr_data_stripes;
+	int index;
+
+	stripe_nr = offset / chunk->stripe_len;
+	if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID0) {
+		index = stripe_nr % chunk->num_stripes;
+	} else if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID10) {
+		index = stripe_nr % (chunk->num_stripes / chunk->sub_stripes);
+		index *= chunk->sub_stripes;
+	} else if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID5) {
+		nr_data_stripes = chunk->num_stripes - 1;
+		index = stripe_nr % nr_data_stripes;
+		stripe_nr /= nr_data_stripes;
+		index = (index + stripe_nr) % chunk->num_stripes;
+	} else if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID6) {
+		nr_data_stripes = chunk->num_stripes - 2;
+		index = stripe_nr % nr_data_stripes;
+		stripe_nr /= nr_data_stripes;
+		index = (index + stripe_nr) % chunk->num_stripes;
+	} else {
+		BUG_ON(1);
+	}
+	return index;
+}
+
+/* calc the logical offset which is the start of the next stripe. */
+static inline u64 btrfs_next_stripe_logical_offset(struct chunk_record *chunk,
+						   u64 logical)
+{
+	u64 offset = logical - chunk->offset;
+
+	offset /= chunk->stripe_len;
+	offset *= chunk->stripe_len;
+	offset += chunk->stripe_len;
+
+	return offset + chunk->offset;
+}
+
+static int is_extent_record_in_device_extent(struct extent_record *er,
+					     struct device_extent_record *dext,
+					     int *mirror)
+{
+	int i;
+
+	for (i = 0; i < er->nmirrors; i++) {
+		if (er->devices[i]->devid == dext->objectid &&
+		    er->offsets[i] >= dext->offset &&
+		    er->offsets[i] < dext->offset + dext->length) {
+			*mirror = i;
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static int
+btrfs_rebuild_ordered_meta_chunk_stripes(struct recover_control *rc,
+					 struct chunk_record *chunk)
+{
+	u64 start = chunk->offset;
+	u64 end = chunk->offset + chunk->length;
+	struct cache_extent *cache;
+	struct extent_record *er;
+	struct device_extent_record *devext;
+	struct device_extent_record *next;
+	struct btrfs_device *device;
+	LIST_HEAD(devexts);
+	int index;
+	int mirror;
+	int ret;
+
+	cache = lookup_cache_extent(&rc->eb_cache,
+				    start, chunk->length);
+	if (!cache) {
+		/* No used space, we can reorder the stripes freely. */
+		ret = btrfs_rebuild_unordered_chunk_stripes(rc, chunk);
+		return ret;
+	}
+
+	list_splice_init(&chunk->dextents, &devexts);
+again:
+	er = container_of(cache, struct extent_record, cache);
+	index = btrfs_calc_stripe_index(chunk, er->cache.start);
+	if (chunk->stripes[index].devid)
+		goto next;
+	list_for_each_entry_safe(devext, next, &devexts, chunk_list) {
+		if (is_extent_record_in_device_extent(er, devext, &mirror)) {
+			chunk->stripes[index].devid = devext->objectid;
+			chunk->stripes[index].offset = devext->offset;
+			memcpy(chunk->stripes[index].dev_uuid,
+			       er->devices[mirror]->uuid,
+			       BTRFS_UUID_SIZE);
+			index++;
+			list_move(&devext->chunk_list, &chunk->dextents);
+		}
+	}
+next:
+	start = btrfs_next_stripe_logical_offset(chunk, er->cache.start);
+	if (start >= end)
+		goto no_extent_record;
+
+	cache = lookup_cache_extent(&rc->eb_cache, start, end - start);
+	if (cache)
+		goto again;
+no_extent_record:
+	if (list_empty(&devexts))
+		return 0;
+
+	if (chunk->type_flags & (BTRFS_BLOCK_GROUP_RAID5 |
+				 BTRFS_BLOCK_GROUP_RAID6)) {
+		/* Fixme: try to recover the order by the parity block. */
+		list_splice_tail(&devexts, &chunk->dextents);
+		return -EINVAL;
+	}
+
+	/* There is no data on the lost stripes, we can reorder them freely. */
+	for (index = 0; index < chunk->num_stripes; index++) {
+		if (chunk->stripes[index].devid)
+			continue;
+
+		devext = list_first_entry(&devexts,
+					  struct device_extent_record,
+					   chunk_list);
+		list_move(&devext->chunk_list, &chunk->dextents);
+
+		chunk->stripes[index].devid = devext->objectid;
+		chunk->stripes[index].offset = devext->offset;
+		device = btrfs_find_device_by_devid(rc->fs_devices,
+						    devext->objectid,
+						    0);
+		if (!device) {
+			list_splice_tail(&devexts, &chunk->dextents);
+			return -EINVAL;
+		}
+		BUG_ON(btrfs_find_device_by_devid(rc->fs_devices,
+						  devext->objectid,
+						  1));
+		memcpy(chunk->stripes[index].dev_uuid, device->uuid,
+		       BTRFS_UUID_SIZE);
+	}
+	return 0;
+}
+
+#define BTRFS_ORDERED_RAID	(BTRFS_BLOCK_GROUP_RAID0 |	\
+				 BTRFS_BLOCK_GROUP_RAID10 |	\
+				 BTRFS_BLOCK_GROUP_RAID5 |	\
+				 BTRFS_BLOCK_GROUP_RAID6)
+
 static int btrfs_rebuild_chunk_stripes(struct recover_control *rc,
 				       struct chunk_record *chunk)
 {
 	int ret;
 
-	if (chunk->type_flags & (BTRFS_BLOCK_GROUP_RAID10 |
-				 BTRFS_BLOCK_GROUP_RAID0 |
-				 BTRFS_BLOCK_GROUP_RAID5 |
-				 BTRFS_BLOCK_GROUP_RAID6))
-		BUG_ON(1);	/* Fixme: implement in the next patch */
+	/*
+	 * All the data in the system metadata chunk will be dropped,
+	 * so we need not guarantee that the data is right or not, that
+	 * is we can reorder the stripes in the system metadata chunk.
+	 */
+	if ((chunk->type_flags & BTRFS_BLOCK_GROUP_METADATA) &&
+	    (chunk->type_flags & BTRFS_ORDERED_RAID))
+		ret =btrfs_rebuild_ordered_meta_chunk_stripes(rc, chunk);
+	else if ((chunk->type_flags & BTRFS_BLOCK_GROUP_DATA) &&
+		 (chunk->type_flags & BTRFS_ORDERED_RAID))
+		ret = 1;	/* Be handled after the fs is opened. */
 	else
 		ret = btrfs_rebuild_unordered_chunk_stripes(rc, chunk);
 
@@ -1407,7 +1674,9 @@ static int btrfs_recover_chunks(struct recover_control *rc)
 
 		chunk->num_stripes = nstripes;
 		ret = btrfs_rebuild_chunk_stripes(rc, chunk);
-		if (ret)
+		if (ret > 0)
+			list_add_tail(&chunk->list, &rc->unrepaired_chunks);
+		else if (ret < 0)
 			list_add_tail(&chunk->list, &rc->bad_chunks);
 		else
 			list_add_tail(&chunk->list, &rc->good_chunks);
-- 
1.8.1.4

