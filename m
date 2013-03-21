Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51675 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab3CUOba (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 10:31:30 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 50EF79A04E9
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 08:31:30 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id rzBYgJXH37ocBFLS (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 08:31:29 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make btrfs-image restore with a valid chunk tree
Date: Thu, 21 Mar 2013 10:38:47 -0400
Message-ID: <1363876727-3303-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously btrfs-image would set a METADUMP flag and would make one big system
chunk to cover the entire file system in the super in order to get around the
unpleasant business of having to adjust the chunk tree.  This meant that you
could use the progs stuff on a restored file system, which is great for testing
btrfsck and other such things.  But we want to be able to run the tree log
replay on a file system that is not able to run the tree log replay.  So in
order to do this we need to fixup the super's chunk array and the chunk tree
itself.  This is pretty easy since we restore using the logical offsets of the
metadata, so we just have to set the chunk items to have 1 stripe and have the
stripes point at the primary device and then use the logical offset of the chunk
as the physical offset.  With this patch I can restore a file system image that
had a tree log and mount the file system and have the log be replayed
successfully.  This patch also gives you the -o option in case you want the old
restore way, in the case where we want to make sure the system chunks as they
were given to us are correct.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfs-image.c        |  311 ++++++++++++++++++++++++++++++++++++++++++++++++--
 man/btrfs-image.8.in |    4 +
 utils.c              |    4 +-
 utils.h              |    2 +
 4 files changed, 309 insertions(+), 12 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index b39174b..6befb94 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -110,10 +110,15 @@ struct mdrestore_struct {
 
 	struct list_head list;
 	size_t num_items;
+	u64 leafsize;
+	u64 devid;
+	u8 uuid[BTRFS_UUID_SIZE];
+	u8 fsid[BTRFS_FSID_SIZE];
 
 	int compress_method;
 	int done;
 	int error;
+	int old_restore;
 };
 
 static void csum_block(u8 *buf, size_t len)
@@ -254,7 +259,7 @@ static void meta_cluster_init(struct metadump_struct *md, u64 start)
 static int metadump_init(struct metadump_struct *md, struct btrfs_root *root,
 			 FILE *out, int num_threads, int compress_level)
 {
-	int i, ret;
+	int i, ret = 0;
 
 	memset(md, 0, sizeof(*md));
 	pthread_cond_init(&md->cond, NULL);
@@ -898,7 +903,7 @@ out:
 	return err ? err : ret;
 }
 
-static void update_super(u8 *buffer)
+static void update_super_old(u8 *buffer)
 {
 	struct btrfs_super_block *super = (struct btrfs_super_block *)buffer;
 	struct btrfs_chunk *chunk;
@@ -933,6 +938,221 @@ static void update_super(u8 *buffer)
 	csum_block(buffer, 4096);
 }
 
+static int update_super(u8 *buffer)
+{
+	struct btrfs_super_block *super = (struct btrfs_super_block *)buffer;
+	struct btrfs_chunk *chunk;
+	struct btrfs_disk_key *disk_key;
+	struct btrfs_key key;
+	u32 new_array_size = 0;
+	u32 array_size;
+	u32 cur = 0;
+	u32 new_cur = 0;
+	u8 *ptr, *write_ptr;
+	int old_num_stripes;
+
+	write_ptr = ptr = super->sys_chunk_array;
+	array_size = btrfs_super_sys_array_size(super);
+
+	while (cur < array_size) {
+		disk_key = (struct btrfs_disk_key *)ptr;
+		btrfs_disk_key_to_cpu(&key, disk_key);
+
+		new_array_size += sizeof(*disk_key);
+		memmove(write_ptr, ptr, sizeof(*disk_key));
+
+		write_ptr += sizeof(*disk_key);
+		ptr += sizeof(*disk_key);
+		cur += sizeof(*disk_key);
+		new_cur += sizeof(*disk_key);
+
+		if (key.type == BTRFS_CHUNK_ITEM_KEY) {
+			chunk = (struct btrfs_chunk *)ptr;
+			old_num_stripes = btrfs_stack_chunk_num_stripes(chunk);
+			chunk = (struct btrfs_chunk *)write_ptr;
+
+			memmove(write_ptr, ptr, sizeof(*chunk));
+			btrfs_set_stack_chunk_num_stripes(chunk, 1);
+			btrfs_set_stack_chunk_sub_stripes(chunk, 0);
+			btrfs_set_stack_chunk_type(chunk,
+						   BTRFS_BLOCK_GROUP_SYSTEM);
+			chunk->stripe.devid = super->dev_item.devid;
+			chunk->stripe.offset = cpu_to_le64(key.offset);
+			memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid,
+			       BTRFS_UUID_SIZE);
+			new_array_size += sizeof(*chunk);
+			new_cur += sizeof(*chunk);
+		} else {
+			fprintf(stderr, "Bogus key in the sys chunk array "
+				"%d\n", key.type);
+			return -EIO;
+		}
+		write_ptr += sizeof(*chunk);
+		ptr += btrfs_chunk_item_size(old_num_stripes);
+		cur += btrfs_chunk_item_size(old_num_stripes);
+	}
+
+	btrfs_set_super_sys_array_size(super, new_array_size);
+	csum_block(buffer, 4096);
+
+	return 0;
+}
+
+static struct extent_buffer *alloc_dummy_eb(u64 bytenr, u32 size)
+{
+	struct extent_buffer *eb;
+
+	eb = malloc(sizeof(struct extent_buffer) + size);
+	if (!eb)
+		return NULL;
+	memset(eb, 0, sizeof(struct extent_buffer) + size);
+
+	eb->start = bytenr;
+	eb->len = size;
+	return eb;
+}
+
+static void truncate_item(struct extent_buffer *eb, int slot, u32 new_size)
+{
+	struct btrfs_item *item;
+	u32 nritems;
+	u32 old_size;
+	u32 old_data_start;
+	u32 size_diff;
+	u32 data_end;
+	int i;
+
+	old_size = btrfs_item_size_nr(eb, slot);
+	if (old_size == new_size)
+		return;
+
+	nritems = btrfs_header_nritems(eb);
+	data_end = btrfs_item_offset_nr(eb, nritems - 1);
+
+	old_data_start = btrfs_item_offset_nr(eb, slot);
+	size_diff = old_size - new_size;
+
+	for (i = slot; i < nritems; i++) {
+		u32 ioff;
+		item = btrfs_item_nr(eb, i);
+		ioff = btrfs_item_offset(eb, item);
+		btrfs_set_item_offset(eb, item, ioff + size_diff);
+	}
+
+	memmove_extent_buffer(eb, btrfs_leaf_data(eb) + data_end + size_diff,
+			      btrfs_leaf_data(eb) + data_end,
+			      old_data_start + new_size - data_end);
+	item = btrfs_item_nr(eb, slot);
+	btrfs_set_item_size(eb, item, new_size);
+}
+
+static int fixup_chunk_tree_block(struct mdrestore_struct *mdres,
+				  struct async_work *async, u8 *buffer)
+{
+	struct extent_buffer *eb;
+	size_t size_left = async->bufsize;
+	u64 bytenr = async->start;
+	int i;
+
+	if (async->bufsize % mdres->leafsize)
+		return 0;
+
+	eb = alloc_dummy_eb(bytenr, mdres->leafsize);
+	if (!eb)
+		return -ENOMEM;
+
+	while (size_left) {
+		eb->start = bytenr;
+		memcpy(eb->data, buffer, mdres->leafsize);
+		if (btrfs_header_bytenr(eb) != bytenr) {
+			break;
+		}
+		if (memcmp(mdres->fsid,
+			   eb->data + offsetof(struct btrfs_header, fsid),
+			   BTRFS_FSID_SIZE)) {
+			break;
+		}
+
+		if (btrfs_header_owner(eb) != BTRFS_CHUNK_TREE_OBJECTID)
+			goto next;
+
+		if (btrfs_header_level(eb) != 0)
+			goto next;
+
+		for (i = 0; i < btrfs_header_nritems(eb); i++) {
+			struct btrfs_chunk chunk;
+			struct btrfs_key key;
+			u64 type;
+
+			btrfs_item_key_to_cpu(eb, &key, i);
+			if (key.type != BTRFS_CHUNK_ITEM_KEY)
+				continue;
+			truncate_item(eb, i, sizeof(chunk));
+			read_extent_buffer(eb, &chunk,
+					   btrfs_item_ptr_offset(eb, i),
+					   sizeof(chunk));
+
+			/* Zero out the RAID profile */
+			type = btrfs_stack_chunk_type(&chunk);
+			type &= (BTRFS_BLOCK_GROUP_DATA |
+				 BTRFS_BLOCK_GROUP_SYSTEM |
+				 BTRFS_BLOCK_GROUP_METADATA);
+			btrfs_set_stack_chunk_type(&chunk, type);
+
+			btrfs_set_stack_chunk_num_stripes(&chunk, 1);
+			btrfs_set_stack_chunk_sub_stripes(&chunk, 0);
+			chunk.stripe.devid = cpu_to_le32(mdres->devid);
+			chunk.stripe.offset = cpu_to_le32(key.offset);
+			memcpy(chunk.stripe.dev_uuid, mdres->uuid,
+			       BTRFS_UUID_SIZE);
+			write_extent_buffer(eb, &chunk,
+					    btrfs_item_ptr_offset(eb, i),
+					    sizeof(chunk));
+		}
+		memcpy(buffer, eb->data, eb->len);
+		csum_block(buffer, eb->len);
+next:
+		size_left -= mdres->leafsize;
+		buffer += mdres->leafsize;
+		bytenr += mdres->leafsize;
+	}
+
+	return 0;
+}
+
+static void write_backup_supers(int fd, u8 *buf)
+{
+	struct stat st;
+	u64 size;
+	u64 bytenr;
+	int i;
+	int ret;
+
+	if (fstat(fd, &st)) {
+		fprintf(stderr, "Couldn't stat restore point, won't be able "
+			"to write backup supers: %d\n", errno);
+		return;
+	}
+
+	size = btrfs_device_size(fd, &st);
+
+	for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		bytenr = btrfs_sb_offset(i);
+		if (bytenr + 4096 > size)
+			break;
+		ret = pwrite64(fd, buf, 4096, bytenr);
+		if (ret < 4096) {
+			if (ret < 0)
+				fprintf(stderr, "Problem writing out backup "
+					"super block %d, err %d\n", i, errno);
+			else
+				fprintf(stderr, "Short write writing out "
+					"backup super block\n");
+			break;
+		}
+	}
+}
+
 static void *restore_worker(void *data)
 {
 	struct mdrestore_struct *mdres = (struct mdrestore_struct *)data;
@@ -958,7 +1178,7 @@ static void *restore_worker(void *data)
 		int err = 0;
 
 		pthread_mutex_lock(&mdres->mutex);
-		while (list_empty(&mdres->list)) {
+		while (!mdres->leafsize || list_empty(&mdres->list)) {
 			if (mdres->done) {
 				pthread_mutex_unlock(&mdres->mutex);
 				goto out;
@@ -984,8 +1204,19 @@ static void *restore_worker(void *data)
 			size = async->bufsize;
 		}
 
-		if (async->start == BTRFS_SUPER_INFO_OFFSET)
-			update_super(outbuf);
+		if (async->start == BTRFS_SUPER_INFO_OFFSET) {
+			if (mdres->old_restore) {
+				update_super_old(outbuf);
+			} else {
+				ret = update_super(outbuf);
+				if (ret)
+					err = ret;
+			}
+		} else if (!mdres->old_restore) {
+			ret = fixup_chunk_tree_block(mdres, async, outbuf);
+			if (ret)
+				err = ret;
+		}
 
 		ret = pwrite64(outfd, outbuf, size, async->start);
 		if (ret < size) {
@@ -999,6 +1230,9 @@ static void *restore_worker(void *data)
 			}
 		}
 
+		if (async->start == BTRFS_SUPER_INFO_OFFSET)
+			write_backup_supers(outfd, outbuf);
+
 		pthread_mutex_lock(&mdres->mutex);
 		if (err && !mdres->error)
 			mdres->error = err;
@@ -1030,7 +1264,8 @@ static void mdrestore_destroy(struct mdrestore_struct *mdres)
 }
 
 static int mdrestore_init(struct mdrestore_struct *mdres,
-			  FILE *in, FILE *out, int num_threads)
+			  FILE *in, FILE *out, int old_restore,
+			  int num_threads)
 {
 	int i, ret = 0;
 
@@ -1040,6 +1275,7 @@ static int mdrestore_init(struct mdrestore_struct *mdres,
 	INIT_LIST_HEAD(&mdres->list);
 	mdres->in = in;
 	mdres->out = out;
+	mdres->old_restore = old_restore;
 
 	if (!num_threads)
 		return 0;
@@ -1059,6 +1295,42 @@ static int mdrestore_init(struct mdrestore_struct *mdres,
 	return ret;
 }
 
+static int fill_mdres_info(struct mdrestore_struct *mdres,
+			   struct async_work *async)
+{
+	struct btrfs_super_block *super;
+	u8 *buffer = NULL;
+	u8 *outbuf;
+	int ret;
+
+	if (mdres->compress_method == COMPRESS_ZLIB) {
+		size_t size;
+
+		buffer = malloc(MAX_PENDING_SIZE * 2);
+		if (!buffer)
+			return -ENOMEM;
+		ret = uncompress(buffer, (unsigned long *)&size,
+				 async->buffer, async->bufsize);
+		if (ret != Z_OK) {
+			fprintf(stderr, "Error decompressing %d\n", ret);
+			free(buffer);
+			return -EIO;
+		}
+		outbuf = buffer;
+	} else {
+		outbuf = async->buffer;
+	}
+
+	super = (struct btrfs_super_block *)outbuf;
+	mdres->leafsize = btrfs_super_leafsize(super);
+	memcpy(mdres->fsid, super->fsid, BTRFS_FSID_SIZE);
+	memcpy(mdres->uuid, super->dev_item.uuid,
+		       BTRFS_UUID_SIZE);
+	mdres->devid = le64_to_cpu(super->dev_item.devid);
+	free(buffer);
+	return 0;
+}
+
 static int add_cluster(struct meta_cluster *cluster,
 		       struct mdrestore_struct *mdres, u64 *next)
 {
@@ -1099,6 +1371,16 @@ static int add_cluster(struct meta_cluster *cluster,
 		bytenr += async->bufsize;
 
 		pthread_mutex_lock(&mdres->mutex);
+		if (async->start == BTRFS_SUPER_INFO_OFFSET) {
+			ret = fill_mdres_info(mdres, async);
+			if (ret) {
+				fprintf(stderr, "Error setting up restore\n");
+				pthread_mutex_unlock(&mdres->mutex);
+				free(async->buffer);
+				free(async);
+				return ret;
+			}
+		}
 		list_add_tail(&async->list, &mdres->list);
 		mdres->num_items++;
 		pthread_cond_signal(&mdres->cond);
@@ -1139,7 +1421,8 @@ static int wait_for_worker(struct mdrestore_struct *mdres)
 	return ret;
 }
 
-static int restore_metadump(const char *input, FILE *out, int num_threads)
+static int restore_metadump(const char *input, FILE *out, int old_restore,
+			    int num_threads)
 {
 	struct meta_cluster *cluster;
 	struct meta_cluster_header *header;
@@ -1166,7 +1449,7 @@ static int restore_metadump(const char *input, FILE *out, int num_threads)
 		return -ENOMEM;
 	}
 
-	ret = mdrestore_init(&mdrestore, in, out, num_threads);
+	ret = mdrestore_init(&mdrestore, in, out, old_restore, num_threads);
 	if (ret) {
 		fprintf(stderr, "Error initing mdrestore %d\n", ret);
 		if (in != stdin)
@@ -1214,6 +1497,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-r      \trestore metadump image\n");
 	fprintf(stderr, "\t-c value\tcompression level (0 ~ 9)\n");
 	fprintf(stderr, "\t-t value\tnumber of threads (1 ~ 32)\n");
+	fprintf(stderr, "\t-o      \tdon't mess with the chunk tree when restoring\n");
 	exit(1);
 }
 
@@ -1224,11 +1508,12 @@ int main(int argc, char *argv[])
 	int num_threads = 0;
 	int compress_level = 0;
 	int create = 1;
+	int old_restore = 0;
 	int ret;
 	FILE *out;
 
 	while (1) {
-		int c = getopt(argc, argv, "rc:t:");
+		int c = getopt(argc, argv, "rc:t:o");
 		if (c < 0)
 			break;
 		switch (c) {
@@ -1245,11 +1530,17 @@ int main(int argc, char *argv[])
 			if (compress_level < 0 || compress_level > 9)
 				print_usage();
 			break;
+		case 'o':
+			old_restore = 1;
+			break;
 		default:
 			print_usage();
 		}
 	}
 
+	if (old_restore && create)
+		print_usage();
+
 	argc = argc - optind;
 	if (argc != 2)
 		print_usage();
@@ -1276,7 +1567,7 @@ int main(int argc, char *argv[])
 		ret = create_metadump(source, out, num_threads,
 				      compress_level);
 	else
-		ret = restore_metadump(source, out, 1);
+		ret = restore_metadump(source, out, old_restore, 1);
 
 	if (out == stdout)
 		fflush(out);
diff --git a/man/btrfs-image.8.in b/man/btrfs-image.8.in
index 7a348f8..617ba2e 100644
--- a/man/btrfs-image.8.in
+++ b/man/btrfs-image.8.in
@@ -24,6 +24,10 @@ compression level (0 ~ 9).
 .TP
 \fB\-t\fR \fIvalue\fP
 number of threads (1 ~ 32) to be used to process the image dump or restore.
+.TP
+\fB\-o\fP
+use the old restore method, this does not fixup the chunk tree so the restored
+file system will not be able to be mounted.
 .SH AVAILABILITY
 .B btrfs-image
 is part of btrfs-progs. Btrfs is currently under heavy development,
diff --git a/utils.c b/utils.c
index d660507..b96fb93 100644
--- a/utils.c
+++ b/utils.c
@@ -413,7 +413,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	return 0;
 }
 
-static u64 device_size(int fd, struct stat *st)
+u64 btrfs_device_size(int fd, struct stat *st)
 {
 	u64 size;
 	if (S_ISREG(st->st_mode)) {
@@ -553,7 +553,7 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 		exit(1);
 	}
 
-	block_count = device_size(fd, &st);
+	block_count = btrfs_device_size(fd, &st);
 	if (block_count == 0) {
 		fprintf(stderr, "unable to find %s size\n", file);
 		exit(1);
diff --git a/utils.h b/utils.h
index 60a0fea..da92ef7 100644
--- a/utils.h
+++ b/utils.h
@@ -19,6 +19,7 @@
 #ifndef __UTILS__
 #define __UTILS__
 
+#include <sys/stat.h>
 #include "ctree.h"
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
@@ -56,6 +57,7 @@ int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 
 char *__strncpy__null(char *dest, const char *src, size_t n);
 int is_swap_device(const char *file);
+u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 
-- 
1.7.7.6

