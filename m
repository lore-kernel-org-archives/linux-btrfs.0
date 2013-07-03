Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:36202 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab3GCOAi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 10:00:38 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r63DODNv003961
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 21:24:15 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 11/12] Btrfs-progs: Add chunk rebuild function for RAID1/SINGLE/DUP
Date: Wed, 3 Jul 2013 21:25:19 +0800
Message-Id: <1372857920-4678-12-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add chunk rebuild for RAID1/SINGLE/DUP to chunk-recover command.

Before this patch chunk-recover can only scan and reuse the old chunk
data to recover. With this patch, chunk-recover can use the reference
between chunk/block group/dev extent to rebuild the whole chunk tree
even when old chunks are not available.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 btrfsck.h    |   1 +
 cmds-check.c |  31 ++++++-----
 cmds-chunk.c | 175 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 volumes.c    |  11 ++--
 volumes.h    |   5 +-
 5 files changed, 197 insertions(+), 26 deletions(-)

diff --git a/btrfsck.h b/btrfsck.h
index a6151d5..f73c605 100644
--- a/btrfsck.h
+++ b/btrfsck.h
@@ -140,6 +140,7 @@ static inline unsigned long btrfs_chunk_record_size(int num_stripes)
 }
 void free_chunk_cache_tree(struct cache_tree *chunk_cache);
 
+u64 calc_stripe_length(u64 type, u64 length, int num_stripes);
 /* For block group tree */
 static inline void block_group_tree_init(struct block_group_tree *tree)
 {
diff --git a/cmds-check.c b/cmds-check.c
index c3c7575..185d91f 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4926,24 +4926,24 @@ repair_abort:
 	return err;
 }
 
-static u64 calc_stripe_length(struct chunk_record *chunk_rec)
+u64 calc_stripe_length(u64 type, u64 length, int num_stripes)
 {
 	u64 stripe_size;
 
-	if (chunk_rec->type_flags & BTRFS_BLOCK_GROUP_RAID0) {
-		stripe_size = chunk_rec->length;
-		stripe_size /= chunk_rec->num_stripes;
-	} else if (chunk_rec->type_flags & BTRFS_BLOCK_GROUP_RAID10) {
-		stripe_size = chunk_rec->length * 2;
-		stripe_size /= chunk_rec->num_stripes;
-	} else if (chunk_rec->type_flags & BTRFS_BLOCK_GROUP_RAID5) {
-		stripe_size = chunk_rec->length;
-		stripe_size /= (chunk_rec->num_stripes - 1);
-	} else if (chunk_rec->type_flags & BTRFS_BLOCK_GROUP_RAID6) {
-		stripe_size = chunk_rec->length;
-		stripe_size /= (chunk_rec->num_stripes - 2);
+	if (type & BTRFS_BLOCK_GROUP_RAID0) {
+		stripe_size = length;
+		stripe_size /= num_stripes;
+	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
+		stripe_size = length * 2;
+		stripe_size /= num_stripes;
+	} else if (type & BTRFS_BLOCK_GROUP_RAID5) {
+		stripe_size = length;
+		stripe_size /= (num_stripes - 1);
+	} else if (type & BTRFS_BLOCK_GROUP_RAID6) {
+		stripe_size = length;
+		stripe_size /= (num_stripes - 2);
 	} else {
-		stripe_size = chunk_rec->length;
+		stripe_size = length;
 	}
 	return stripe_size;
 }
@@ -5006,7 +5006,8 @@ static int check_chunk_refs(struct chunk_record *chunk_rec,
 		ret = -1;
 	}
 
-	length = calc_stripe_length(chunk_rec);
+	length = calc_stripe_length(chunk_rec->type_flags, chunk_rec->length,
+				    chunk_rec->num_stripes);
 	for (i = 0; i < chunk_rec->num_stripes; ++i) {
 		devid = chunk_rec->stripes[i].devid;
 		offset = chunk_rec->stripes[i].offset;
diff --git a/cmds-chunk.c b/cmds-chunk.c
index 35577ed..7b740a3 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -42,6 +42,7 @@
 #include "commands.h"
 
 #define BTRFS_CHUNK_TREE_REBUILD_ABORTED	-7500
+#define BTRFS_STRIPE_LEN			(64 * 1024)
 
 struct recover_control {
 	int verbose;
@@ -1251,6 +1252,174 @@ again:
 	goto again;
 }
 
+static int btrfs_get_device_extents(u64 chunk_object,
+				    struct list_head *orphan_devexts,
+				    struct list_head *ret_list)
+{
+	struct device_extent_record *devext;
+	struct device_extent_record *next;
+	int count = 0;
+
+	list_for_each_entry_safe(devext, next, orphan_devexts, chunk_list) {
+		if (devext->chunk_offset == chunk_object) {
+			list_move_tail(&devext->chunk_list, ret_list);
+			count++;
+		}
+	}
+	return count;
+}
+
+static int calc_num_stripes(u64 type)
+{
+	if (type & (BTRFS_BLOCK_GROUP_RAID0 |
+		    BTRFS_BLOCK_GROUP_RAID10 |
+		    BTRFS_BLOCK_GROUP_RAID5 |
+		    BTRFS_BLOCK_GROUP_RAID6))
+		return 0;
+	else if (type & (BTRFS_BLOCK_GROUP_RAID1 |
+			 BTRFS_BLOCK_GROUP_DUP))
+		return 2;
+	else
+		return 1;
+}
+
+static inline int calc_sub_nstripes(u64 type)
+{
+	if (type & BTRFS_BLOCK_GROUP_RAID10)
+		return 2;
+	else
+		return 1;
+}
+
+static int btrfs_verify_device_extents(struct block_group_record *bg,
+				       struct list_head *devexts, int ndevexts)
+{
+	struct device_extent_record *devext;
+	u64 strpie_length;
+	int expected_num_stripes;
+
+	expected_num_stripes = calc_num_stripes(bg->flags);
+	if (!expected_num_stripes && expected_num_stripes != ndevexts)
+		return 1;
+
+	strpie_length = calc_stripe_length(bg->flags, bg->offset, ndevexts);
+	list_for_each_entry(devext, devexts, chunk_list) {
+		if (devext->length != strpie_length)
+			return 1;
+	}
+	return 0;
+}
+
+static int btrfs_rebuild_unordered_chunk_stripes(struct recover_control *rc,
+						 struct chunk_record *chunk)
+{
+	struct device_extent_record *devext;
+	struct btrfs_device *device;
+	int i;
+
+	devext = list_first_entry(&chunk->dextents, struct device_extent_record,
+				  chunk_list);
+	for (i = 0; i < chunk->num_stripes; i++) {
+		chunk->stripes[i].devid = devext->objectid;
+		chunk->stripes[i].offset = devext->offset;
+		device = btrfs_find_device_by_devid(rc->fs_devices,
+						    devext->objectid,
+						    0);
+		if (!device)
+			return -ENOENT;
+		BUG_ON(btrfs_find_device_by_devid(rc->fs_devices,
+						  devext->objectid,
+						  1));
+		memcpy(chunk->stripes[i].dev_uuid, device->uuid,
+		       BTRFS_UUID_SIZE);
+		devext = list_next_entry(devext, chunk_list);
+	}
+	return 0;
+}
+
+static int btrfs_rebuild_chunk_stripes(struct recover_control *rc,
+				       struct chunk_record *chunk)
+{
+	int ret;
+
+	if (chunk->type_flags & (BTRFS_BLOCK_GROUP_RAID10 |
+				 BTRFS_BLOCK_GROUP_RAID0 |
+				 BTRFS_BLOCK_GROUP_RAID5 |
+				 BTRFS_BLOCK_GROUP_RAID6))
+		BUG_ON(1);	/* Fixme: implement in the next patch */
+	else
+		ret = btrfs_rebuild_unordered_chunk_stripes(rc, chunk);
+
+	return ret;
+}
+
+static int btrfs_recover_chunks(struct recover_control *rc)
+{
+	struct chunk_record *chunk;
+	struct block_group_record *bg;
+	struct block_group_record *next;
+	LIST_HEAD(new_chunks);
+	LIST_HEAD(devexts);
+	int nstripes;
+	int ret;
+
+	/* create the chunk by block group */
+	list_for_each_entry_safe(bg, next, &rc->bg.block_groups, list) {
+		nstripes = btrfs_get_device_extents(bg->objectid,
+						    &rc->devext.no_chunk_orphans,
+						    &devexts);
+		chunk = malloc(btrfs_chunk_record_size(nstripes));
+		if (!chunk)
+			return -ENOMEM;
+		memset(chunk, 0, btrfs_chunk_record_size(nstripes));
+		INIT_LIST_HEAD(&chunk->dextents);
+		chunk->bg_rec = bg;
+		chunk->cache.start = bg->objectid;
+		chunk->cache.size = bg->offset;
+		chunk->objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+		chunk->type = BTRFS_CHUNK_ITEM_KEY;
+		chunk->offset = bg->objectid;
+		chunk->generation = bg->generation;
+		chunk->length = bg->offset;
+		chunk->owner = BTRFS_CHUNK_TREE_OBJECTID;
+		chunk->stripe_len = BTRFS_STRIPE_LEN;
+		chunk->type_flags = bg->flags;
+		chunk->io_width = BTRFS_STRIPE_LEN;
+		chunk->io_align = BTRFS_STRIPE_LEN;
+		chunk->sector_size = rc->sectorsize;
+		chunk->sub_stripes = calc_sub_nstripes(bg->flags);
+
+		ret = insert_cache_extent(&rc->chunk, &chunk->cache);
+		BUG_ON(ret);
+
+		if (!nstripes) {
+			list_add_tail(&chunk->list, &rc->bad_chunks);
+			continue;
+		}
+
+		list_splice_init(&devexts, &chunk->dextents);
+
+		ret = btrfs_verify_device_extents(bg, &devexts, nstripes);
+		if (ret) {
+			list_add_tail(&chunk->list, &rc->bad_chunks);
+			continue;
+		}
+
+		chunk->num_stripes = nstripes;
+		ret = btrfs_rebuild_chunk_stripes(rc, chunk);
+		if (ret)
+			list_add_tail(&chunk->list, &rc->bad_chunks);
+		else
+			list_add_tail(&chunk->list, &rc->good_chunks);
+	}
+	/*
+	 * Don't worry about the lost orphan device extents, they don't
+	 * have its chunk and block group, they must be the old ones that
+	 * we have dropped.
+	 */
+	return 0;
+}
+
 static int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
 {
 	int ret = 0;
@@ -1287,9 +1456,9 @@ static int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
 	if (ret) {
 		if (!list_empty(&rc.bg.block_groups) ||
 		    !list_empty(&rc.devext.no_chunk_orphans)) {
-			fprintf(stderr,
-				"There are some orphan block groups and device extents, we can't repair them now.\n");
-			goto fail_rc;
+			ret = btrfs_recover_chunks(&rc);
+			if (ret)
+				goto fail_rc;
 		}
 		/*
 		 * If the chunk is healthy, its block group item and device
diff --git a/volumes.c b/volumes.c
index 42cd943..ab282d3 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1386,16 +1386,15 @@ struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 	return NULL;
 }
 
-struct btrfs_device *btrfs_find_device_by_devid(struct btrfs_root *root,
-						u64 devid, int instance)
+struct btrfs_device *
+btrfs_find_device_by_devid(struct btrfs_fs_devices *fs_devices,
+			   u64 devid, int instance)
 {
-	struct list_head *head = &root->fs_info->fs_devices->devices;
+	struct list_head *head = &fs_devices->devices;
 	struct btrfs_device *dev;
-	struct list_head *cur;
 	int num_found = 0;
 
-	list_for_each(cur, head) {
-		dev = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(dev, head, dev_list) {
 		if (dev->devid == devid && num_found++ == instance)
 			return dev;
 	}
diff --git a/volumes.h b/volumes.h
index 91277a7..0b894fd 100644
--- a/volumes.h
+++ b/volumes.h
@@ -190,8 +190,9 @@ int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, struct btrfs_key *key,
 			   struct btrfs_chunk *chunk, int item_size);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
-struct btrfs_device *btrfs_find_device_by_devid(struct btrfs_root *root,
-                                                u64 devid, int instance);
+struct btrfs_device *
+btrfs_find_device_by_devid(struct btrfs_fs_devices *fs_devices,
+			   u64 devid, int instance);
 struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 				       u8 *uuid, u8 *fsid);
 #endif
-- 
1.8.1.4

