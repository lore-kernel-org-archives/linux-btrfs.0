Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54217 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3CVOuG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 10:50:06 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 87B417C0643
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 08:50:06 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id asAmd9LDSgt1JWSE (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 08:50:05 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-image: add the ability to santize file names when making an image
Date: Fri, 22 Mar 2013 10:57:26 -0400
Message-ID: <1363964246-2648-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've had a few users who wouldn't (or couldn't) provide us btrfs-images because
we maintain the file names when making an image.  So introduce a sanitize
option.  There are two uses, one that is fast and the other that is dog slow.
The fast way just generates garbage that's equal in length to the original name.
The slow way will try and find a crc32c collision for the file name that is also
the same length.  Finding a crc32c collision for the file name "btrfs-progs" on
my box without CPU crc32c support takes a little more than 3 minutes, and a
little less than 2 minutes for my box that has CPU crc32c support, so it's a
lengthy and CPU intensive process.

The idea is that we use -s for most cases, and then only use -ss when we need
the file system tree to be somewhat sane.  I could probably do a better job
about finding collisions, but I'll have to revist that later.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfs-image.c        |  358 ++++++++++++++++++++++++++++++++++++++++++++++++--
 man/btrfs-image.8.in |    9 ++
 2 files changed, 358 insertions(+), 9 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 6befb94..39903a4 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -85,6 +85,7 @@ struct metadump_struct {
 	size_t num_threads;
 	pthread_mutex_t mutex;
 	pthread_cond_t cond;
+	struct rb_root name_tree;
 
 	struct list_head list;
 	struct list_head ordered;
@@ -97,6 +98,14 @@ struct metadump_struct {
 	int compress_level;
 	int done;
 	int data;
+	int sanitize_names;
+};
+
+struct name {
+	struct rb_node n;
+	char *val;
+	char *sub;
+	u32 len;
 };
 
 struct mdrestore_struct {
@@ -121,6 +130,8 @@ struct mdrestore_struct {
 	int old_restore;
 };
 
+static struct extent_buffer *alloc_dummy_eb(u64 bytenr, u32 size);
+
 static void csum_block(u8 *buf, size_t len)
 {
 	char result[BTRFS_CRC32_SIZE];
@@ -130,10 +141,309 @@ static void csum_block(u8 *buf, size_t len)
 	memcpy(buf, result, BTRFS_CRC32_SIZE);
 }
 
+static int has_name(struct btrfs_key *key)
+{
+	switch (key->type) {
+	case BTRFS_DIR_ITEM_KEY:
+	case BTRFS_DIR_INDEX_KEY:
+	case BTRFS_INODE_REF_KEY:
+	case BTRFS_INODE_EXTREF_KEY:
+		return 1;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static char *generate_garbage(u32 name_len)
+{
+	char *buf = malloc(name_len);
+	int i;
+
+	if (!buf)
+		return NULL;
+
+	for (i = 0; i < name_len; i++) {
+		char c = rand() % 94 + 33;
+
+		if (c == '/')
+			c++;
+		buf[i] = c;
+	}
+
+	return buf;
+}
+
+static void tree_insert(struct rb_root *root, struct name *ins)
+{
+	struct rb_node ** p = &root->rb_node;
+	struct rb_node * parent = NULL;
+	struct name *entry;
+	u32 len;
+	int dir;
+
+	while(*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct name, n);
+
+		len = min(ins->len, entry->len);
+		dir = memcmp(ins->val, entry->val, len);
+
+		if (dir < 0)
+			p = &(*p)->rb_left;
+		else if (dir > 0)
+			p = &(*p)->rb_right;
+		else
+			BUG();
+	}
+
+	rb_link_node(&ins->n, parent, p);
+	rb_insert_color(&ins->n, root);
+}
+
+static struct name *name_search(struct rb_root *root, char *name, u32 name_len)
+{
+	struct rb_node *n = root->rb_node;
+	struct name *entry = NULL;
+	u32 len;
+	int dir;
+
+	while (n) {
+		entry = rb_entry(n, struct name, n);
+
+		len = min(entry->len, name_len);
+
+		dir = memcmp(name, entry->val, len);
+		if (dir < 0)
+			n = n->rb_left;
+		else if (dir > 0)
+			n = n->rb_right;
+		else
+			return entry;
+	}
+
+	return NULL;
+}
+
+static char *find_collision(struct metadump_struct *md, char *name,
+			    u32 name_len)
+{
+	struct name *val;
+	unsigned long checksum;
+	int found = 0;
+	int i;
+
+	val = name_search(&md->name_tree, name, name_len);
+	if (val) {
+		free(name);
+		return val->sub;
+	}
+
+	val = malloc(sizeof(struct name));
+	if (!val) {
+		fprintf(stderr, "Couldn't sanitize name, enomem\n");
+		return NULL;
+	}
+
+	memset(val, 0, sizeof(val));
+
+	val->val = name;
+	val->len = name_len;
+	val->sub = malloc(name_len);
+	if (!val->sub) {
+		fprintf(stderr, "Couldn't sanitize name, enomem\n");
+		free(val);
+		return NULL;
+	}
+
+	checksum = crc32c(~1, val->val, name_len);
+	memset(val->sub, ' ', name_len);
+	i = 0;
+	while (1) {
+		if (crc32c(~1, val->sub, name_len) == checksum &&
+		    memcmp(val->sub, val->val, val->len)) {
+			found = 1;
+			break;
+		}
+
+		if (val->sub[i] == 127) {
+			do {
+				i++;
+				if (i > name_len)
+					break;
+			} while (val->sub[i] == 127);
+
+			if (i > name_len)
+				break;
+			val->sub[i]++;
+			if (val->sub[i] == '/')
+				val->sub[i]++;
+			memset(val->sub, ' ', i);
+			i = 0;
+			continue;
+		} else {
+			val->sub[i]++;
+			if (val->sub[i] == '/')
+				val->sub[i]++;
+		}
+	}
+
+	if (!found) {
+		fprintf(stderr, "Couldn't find a collision for '%.*s', "
+			"generating normal garbage, it won't match indexes\n",
+			val->len, val->val);
+		for (i = 0; i < name_len; i++) {
+			char c = rand() % 94 + 33;
+
+			if (c == '/')
+				c++;
+			val->sub[i] = c;
+		}
+	}
+
+	tree_insert(&md->name_tree, val);
+	return val->sub;
+}
+
+static void sanitize_dir_item(struct metadump_struct *md, struct extent_buffer *eb,
+			      int slot)
+{
+	struct btrfs_dir_item *dir_item;
+	char *buf;
+	char *garbage;
+	unsigned long name_ptr;
+	u32 total_len;
+	u32 cur = 0;
+	u32 this_len;
+	u32 name_len;
+	int free_garbage = (md->sanitize_names == 1);
+
+	dir_item = btrfs_item_ptr(eb, slot, struct btrfs_dir_item);
+	total_len = btrfs_item_size_nr(eb, slot);
+	while (cur < total_len) {
+		this_len = sizeof(*dir_item) +
+			btrfs_dir_name_len(eb, dir_item) +
+			btrfs_dir_data_len(eb, dir_item);
+		name_ptr = (unsigned long)(dir_item + 1);
+		name_len = btrfs_dir_name_len(eb, dir_item);
+
+		if (md->sanitize_names > 1) {
+			buf = malloc(name_len);
+			if (!buf) {
+				fprintf(stderr, "Couldn't sanitize name, "
+					"enomem\n");
+				return;
+			}
+			read_extent_buffer(eb, buf, name_ptr, name_len);
+			garbage = find_collision(md, buf, name_len);
+		} else {
+			garbage = generate_garbage(name_len);
+		}
+		if (!garbage) {
+			fprintf(stderr, "Couldn't sanitize name, enomem\n");
+			return;
+		}
+		write_extent_buffer(eb, garbage, name_ptr, name_len);
+		cur += this_len;
+		dir_item = (struct btrfs_dir_item *)((char *)dir_item +
+						     this_len);
+		if (free_garbage)
+			free(garbage);
+	}
+}
+
+static void sanitize_inode_ref(struct metadump_struct *md,
+			       struct extent_buffer *eb, int slot, int ext)
+{
+	struct btrfs_inode_extref *extref;
+	struct btrfs_inode_ref *ref;
+	char *garbage, *buf;
+	unsigned long ptr;
+	unsigned long name_ptr;
+	u32 item_size;
+	u32 cur_offset = 0;
+	int len;
+	int free_garbage = (md->sanitize_names == 1);
+
+	item_size = btrfs_item_size_nr(eb, slot);
+	ptr = btrfs_item_ptr_offset(eb, slot);
+	while (cur_offset < item_size) {
+		if (ext) {
+			extref = (struct btrfs_inode_extref *)(ptr +
+							       cur_offset);
+			name_ptr = (unsigned long)(&extref->name);
+			len = btrfs_inode_extref_name_len(eb, extref);
+			cur_offset += sizeof(*extref);
+		} else {
+			ref = (struct btrfs_inode_ref *)(ptr + cur_offset);
+			len = btrfs_inode_ref_name_len(eb, ref);
+			name_ptr = (unsigned long)(ref + 1);
+			cur_offset += sizeof(*ref);
+		}
+		cur_offset += len;
+
+		if (md->sanitize_names > 1) {
+			buf = malloc(len);
+			if (!buf) {
+				fprintf(stderr, "Couldn't sanitize name, "
+					"enomem\n");
+				return;
+			}
+			read_extent_buffer(eb, buf, name_ptr, len);
+			garbage = find_collision(md, buf, len);
+		} else {
+			garbage = generate_garbage(len);
+		}
+
+		if (!garbage) {
+			fprintf(stderr, "Couldn't sanitize name, enomem\n");
+			return;
+		}
+		write_extent_buffer(eb, garbage, name_ptr, len);
+		if (free_garbage)
+			free(garbage);
+	}
+}
+
+static void sanitize_name(struct metadump_struct *md, u8 *dst,
+			  struct extent_buffer *src, struct btrfs_key *key,
+			  int slot)
+{
+	struct extent_buffer *eb;
+
+	eb = alloc_dummy_eb(src->start, src->len);
+	if (!eb) {
+		fprintf(stderr, "Couldn't sanitize name, no memory\n");
+		return;
+	}
+
+	memcpy(eb->data, dst, eb->len);
+
+	switch (key->type) {
+	case BTRFS_DIR_ITEM_KEY:
+	case BTRFS_DIR_INDEX_KEY:
+		sanitize_dir_item(md, eb, slot);
+		break;
+	case BTRFS_INODE_REF_KEY:
+		sanitize_inode_ref(md, eb, slot, 0);
+		break;
+	case BTRFS_INODE_EXTREF_KEY:
+		sanitize_inode_ref(md, eb, slot, 1);
+		break;
+	default:
+		break;
+	}
+
+	memcpy(dst, eb->data, eb->len);
+	free(eb);
+}
+
 /*
  * zero inline extents and csum items
  */
-static void zero_items(u8 *dst, struct extent_buffer *src)
+static void zero_items(struct metadump_struct *md, u8 *dst,
+		       struct extent_buffer *src)
 {
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_item *item;
@@ -152,6 +462,12 @@ static void zero_items(u8 *dst, struct extent_buffer *src)
 			       btrfs_item_offset_nr(src, i), 0, size);
 			continue;
 		}
+
+		if (md->sanitize_names && has_name(&key)) {
+			sanitize_name(md, dst, src, &key, i);
+			continue;
+		}
+
 		if (key.type != BTRFS_EXTENT_DATA_KEY)
 			continue;
 
@@ -169,7 +485,8 @@ static void zero_items(u8 *dst, struct extent_buffer *src)
 /*
  * copy buffer and zero useless data in the buffer
  */
-static void copy_buffer(u8 *dst, struct extent_buffer *src)
+static void copy_buffer(struct metadump_struct *md, u8 *dst,
+			struct extent_buffer *src)
 {
 	int level;
 	size_t size;
@@ -190,7 +507,7 @@ static void copy_buffer(u8 *dst, struct extent_buffer *src)
 			btrfs_item_offset_nr(src, nritems - 1) -
 			btrfs_item_nr_offset(nritems);
 		memset(dst + btrfs_item_nr_offset(nritems), 0, size);
-		zero_items(dst, src);
+		zero_items(md, dst, src);
 	} else {
 		size = offsetof(struct btrfs_node, ptrs) +
 			sizeof(struct btrfs_key_ptr) * nritems;
@@ -257,7 +574,8 @@ static void meta_cluster_init(struct metadump_struct *md, u64 start)
 }
 
 static int metadump_init(struct metadump_struct *md, struct btrfs_root *root,
-			 FILE *out, int num_threads, int compress_level)
+			 FILE *out, int num_threads, int compress_level,
+			 int sanitize_names)
 {
 	int i, ret = 0;
 
@@ -271,6 +589,10 @@ static int metadump_init(struct metadump_struct *md, struct btrfs_root *root,
 	md->pending_start = (u64)-1;
 	md->compress_level = compress_level;
 	md->cluster = calloc(1, BLOCK_SIZE);
+	md->sanitize_names = sanitize_names;
+	if (sanitize_names > 1)
+		crc32c_optimization_init();
+
 	if (!md->cluster) {
 		pthread_cond_destroy(&md->cond);
 		pthread_mutex_destroy(&md->mutex);
@@ -281,6 +603,7 @@ static int metadump_init(struct metadump_struct *md, struct btrfs_root *root,
 	if (!num_threads)
 		return 0;
 
+	md->name_tree.rb_node = NULL;
 	md->num_threads = num_threads;
 	md->threads = calloc(num_threads, sizeof(pthread_t));
 	if (!md->threads) {
@@ -317,6 +640,8 @@ static int metadump_init(struct metadump_struct *md, struct btrfs_root *root,
 static void metadump_destroy(struct metadump_struct *md)
 {
 	int i;
+	struct rb_node *n;
+
 	pthread_mutex_lock(&md->mutex);
 	md->done = 1;
 	pthread_cond_broadcast(&md->cond);
@@ -327,6 +652,16 @@ static void metadump_destroy(struct metadump_struct *md)
 
 	pthread_cond_destroy(&md->cond);
 	pthread_mutex_destroy(&md->mutex);
+
+	while ((n = rb_first(&md->name_tree))) {
+		struct name *name;
+
+		name = rb_entry(n, struct name, n);
+		rb_erase(n, &md->name_tree);
+		free(name->val);
+		free(name->sub);
+		free(name);
+	}
 	free(md->threads);
 	free(md->cluster);
 }
@@ -514,7 +849,7 @@ static int flush_pending(struct metadump_struct *md, int done)
 					"block\n");
 				return -EIO;
 			}
-			copy_buffer(async->buffer + offset, eb);
+			copy_buffer(md, async->buffer + offset, eb);
 			free_extent_buffer(eb);
 			start += blocksize;
 			offset += blocksize;
@@ -750,7 +1085,7 @@ static int copy_space_cache(struct btrfs_root *root,
 }
 
 static int create_metadump(const char *input, FILE *out, int num_threads,
-			   int compress_level)
+			   int compress_level, int sanitize)
 {
 	struct btrfs_root *root;
 	struct btrfs_root *extent_root;
@@ -773,7 +1108,7 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 	BUG_ON(root->nodesize != root->leafsize);
 
 	ret = metadump_init(&metadump, root, out, num_threads,
-			    compress_level);
+			    compress_level, sanitize);
 	if (ret) {
 		fprintf(stderr, "Error initing metadump %d\n", ret);
 		close_ctree(root);
@@ -1498,6 +1833,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-c value\tcompression level (0 ~ 9)\n");
 	fprintf(stderr, "\t-t value\tnumber of threads (1 ~ 32)\n");
 	fprintf(stderr, "\t-o      \tdon't mess with the chunk tree when restoring\n");
+	fprintf(stderr, "\t-s      \tsanitize file names, use once to just use garbage, use twice if you want crc collisions");
 	exit(1);
 }
 
@@ -1510,10 +1846,11 @@ int main(int argc, char *argv[])
 	int create = 1;
 	int old_restore = 0;
 	int ret;
+	int sanitize = 0;
 	FILE *out;
 
 	while (1) {
-		int c = getopt(argc, argv, "rc:t:o");
+		int c = getopt(argc, argv, "rc:t:os");
 		if (c < 0)
 			break;
 		switch (c) {
@@ -1533,6 +1870,9 @@ int main(int argc, char *argv[])
 		case 'o':
 			old_restore = 1;
 			break;
+		case 's':
+			sanitize++;
+			break;
 		default:
 			print_usage();
 		}
@@ -1565,7 +1905,7 @@ int main(int argc, char *argv[])
 
 	if (create)
 		ret = create_metadump(source, out, num_threads,
-				      compress_level);
+				      compress_level, sanitize);
 	else
 		ret = restore_metadump(source, out, old_restore, 1);
 
diff --git a/man/btrfs-image.8.in b/man/btrfs-image.8.in
index 617ba2e..f8fed15 100644
--- a/man/btrfs-image.8.in
+++ b/man/btrfs-image.8.in
@@ -28,6 +28,15 @@ number of threads (1 ~ 32) to be used to process the image dump or restore.
 \fB\-o\fP
 use the old restore method, this does not fixup the chunk tree so the restored
 file system will not be able to be mounted.
+.TP
+\fB\-s\fP
+Sanitize the file names when generating the image. One \fB-s\fP means just
+generate random garbage, which means that the directory indexes won't match up
+since the hashes won't match with the garbage filenames. Using \fB-ss\fP will
+calculate a collision for the filename so that the hashes match, and if it
+can't calculate a collision then it will just generate garbage.  The collision
+calculator is very time and CPU intensive so only use it if you are having
+problems with your file system tree and need to have it mostly working.
 .SH AVAILABILITY
 .B btrfs-image
 is part of btrfs-progs. Btrfs is currently under heavy development,
-- 
1.7.7.6

