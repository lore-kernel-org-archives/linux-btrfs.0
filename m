Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:48618 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3EHTkz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 May 2013 15:40:55 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 766AB9A041D
	for <linux-btrfs@vger.kernel.org>; Wed,  8 May 2013 13:40:54 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 29vANKZQp14aPz9f (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 13:40:53 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make image restore with the original device offsets
Date: Wed, 8 May 2013 15:40:50 -0400
Message-ID: <1368042050-4186-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed a slight problem with btrfs-image, since it was building a chunk tree
by setting the physical offset of the stripes to the same as the logical offset
it created this problem where the super block was now mapped into the file
system differently than it was before.  This isn't a huge deal except that we
also carry along the free space cache with us, which is setup with the idea that
super at physical X is at logical Y.  So this would make the free space checker
in fsck freak out because it would see that the cache says that the super block
is free space, and that the area where it thought the super block was located is
in fact used.  In the mount case we'd end up overwriting real metadata with
backup super blocks.  So we need to maintain the physical offsets in our
stripes.  This is a huge pain because we store the logical bytenrs of all of our
metadata.  This patch scans the entire image looking for chunk tree blocks and
builds an in memory chunk tree so we can write logical blocks to their physical
offsets.  With this patch we no longer have the problems I described above.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfs-image.c |  476 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 443 insertions(+), 33 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index d0c3093..c82aefb 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -65,6 +65,13 @@ struct meta_cluster {
 #define ITEMS_PER_CLUSTER ((BLOCK_SIZE - sizeof(struct meta_cluster)) / \
 			   sizeof(struct meta_cluster_item))
 
+struct fs_chunk {
+	u64 logical;
+	u64 physical;
+	u64 bytes;
+	struct rb_node n;
+};
+
 struct async_work {
 	struct list_head list;
 	struct list_head ordered;
@@ -117,6 +124,7 @@ struct mdrestore_struct {
 	pthread_mutex_t mutex;
 	pthread_cond_t cond;
 
+	struct rb_root chunk_tree;
 	struct list_head list;
 	size_t num_items;
 	u64 leafsize;
@@ -130,6 +138,8 @@ struct mdrestore_struct {
 	int old_restore;
 };
 
+static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
+				   u64 search, u64 cluster_bytenr);
 static struct extent_buffer *alloc_dummy_eb(u64 bytenr, u32 size);
 
 static void csum_block(u8 *buf, size_t len)
@@ -175,21 +185,44 @@ static char *generate_garbage(u32 name_len)
 	return buf;
 }
 
-static void tree_insert(struct rb_root *root, struct name *ins)
+static int name_cmp(struct rb_node *a, struct rb_node *b, int fuzz)
+{
+	struct name *entry = rb_entry(a, struct name, n);
+	struct name *ins = rb_entry(b, struct name, n);
+	u32 len;
+
+	len = min(ins->len, entry->len);
+	return memcmp(ins->val, entry->val, len);
+}
+
+static int chunk_cmp(struct rb_node *a, struct rb_node *b, int fuzz)
+{
+	struct fs_chunk *entry = rb_entry(a, struct fs_chunk, n);
+	struct fs_chunk *ins = rb_entry(b, struct fs_chunk, n);
+
+	if (fuzz && ins->logical >= entry->logical &&
+	    ins->logical < entry->logical + entry->bytes)
+		return 0;
+
+	if (ins->logical < entry->logical)
+		return -1;
+	else if (ins->logical > entry->logical)
+		return 1;
+	return 0;
+}
+
+static void tree_insert(struct rb_root *root, struct rb_node *ins,
+			int (*cmp)(struct rb_node *a, struct rb_node *b,
+				   int fuzz))
 {
 	struct rb_node ** p = &root->rb_node;
 	struct rb_node * parent = NULL;
-	struct name *entry;
-	u32 len;
 	int dir;
 
 	while(*p) {
 		parent = *p;
-		entry = rb_entry(parent, struct name, n);
-
-		len = min(ins->len, entry->len);
-		dir = memcmp(ins->val, entry->val, len);
 
+		dir = cmp(*p, ins, 0);
 		if (dir < 0)
 			p = &(*p)->rb_left;
 		else if (dir > 0)
@@ -198,29 +231,27 @@ static void tree_insert(struct rb_root *root, struct name *ins)
 			BUG();
 	}
 
-	rb_link_node(&ins->n, parent, p);
-	rb_insert_color(&ins->n, root);
+	rb_link_node(ins, parent, p);
+	rb_insert_color(ins, root);
 }
 
-static struct name *name_search(struct rb_root *root, char *name, u32 name_len)
+static struct rb_node *tree_search(struct rb_root *root,
+				   struct rb_node *search,
+				   int (*cmp)(struct rb_node *a,
+					      struct rb_node *b, int fuzz),
+				   int fuzz)
 {
 	struct rb_node *n = root->rb_node;
-	struct name *entry = NULL;
-	u32 len;
 	int dir;
 
 	while (n) {
-		entry = rb_entry(n, struct name, n);
-
-		len = min(entry->len, name_len);
-
-		dir = memcmp(name, entry->val, len);
+		dir = cmp(n, search, fuzz);
 		if (dir < 0)
 			n = n->rb_left;
 		else if (dir > 0)
 			n = n->rb_right;
 		else
-			return entry;
+			return n;
 	}
 
 	return NULL;
@@ -230,12 +261,17 @@ static char *find_collision(struct metadump_struct *md, char *name,
 			    u32 name_len)
 {
 	struct name *val;
+	struct rb_node *entry;
+	struct name tmp;
 	unsigned long checksum;
 	int found = 0;
 	int i;
 
-	val = name_search(&md->name_tree, name, name_len);
-	if (val) {
+	tmp.val = name;
+	tmp.len = name_len;
+	entry = tree_search(&md->name_tree, &tmp.n, name_cmp, 0);
+	if (entry) {
+		val = rb_entry(entry, struct name, n);
 		free(name);
 		return val->sub;
 	}
@@ -302,7 +338,7 @@ static char *find_collision(struct metadump_struct *md, char *name,
 		}
 	}
 
-	tree_insert(&md->name_tree, val);
+	tree_insert(&md->name_tree, &val->n, name_cmp);
 	return val->sub;
 }
 
@@ -1341,7 +1377,6 @@ static int update_super(u8 *buffer)
 			btrfs_set_stack_chunk_type(chunk,
 						   BTRFS_BLOCK_GROUP_SYSTEM);
 			chunk->stripe.devid = super->dev_item.devid;
-			chunk->stripe.offset = cpu_to_le64(key.offset);
 			memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid,
 			       BTRFS_UUID_SIZE);
 			new_array_size += sizeof(*chunk);
@@ -1466,7 +1501,6 @@ static int fixup_chunk_tree_block(struct mdrestore_struct *mdres,
 			btrfs_set_stack_chunk_num_stripes(&chunk, 1);
 			btrfs_set_stack_chunk_sub_stripes(&chunk, 0);
 			btrfs_set_stack_stripe_devid(&chunk.stripe, mdres->devid);
-			btrfs_set_stack_stripe_offset(&chunk.stripe, key.offset);
 			memcpy(chunk.stripe.dev_uuid, mdres->uuid,
 			       BTRFS_UUID_SIZE);
 			write_extent_buffer(eb, &chunk,
@@ -1486,6 +1520,7 @@ next:
 
 static void write_backup_supers(int fd, u8 *buf)
 {
+	struct btrfs_super_block *super = (struct btrfs_super_block *)buf;
 	struct stat st;
 	u64 size;
 	u64 bytenr;
@@ -1504,6 +1539,8 @@ static void write_backup_supers(int fd, u8 *buf)
 		bytenr = btrfs_sb_offset(i);
 		if (bytenr + 4096 > size)
 			break;
+		btrfs_set_super_bytenr(super, bytenr);
+		csum_block(buf, 4096);
 		ret = pwrite64(fd, buf, 4096, bytenr);
 		if (ret < 4096) {
 			if (ret < 0)
@@ -1517,6 +1554,32 @@ static void write_backup_supers(int fd, u8 *buf)
 	}
 }
 
+static u64 logical_to_physical(struct mdrestore_struct *mdres, u64 logical, u64 *size)
+{
+	struct fs_chunk *fs_chunk;
+	struct rb_node *entry;
+	struct fs_chunk search;
+	u64 offset;
+
+	if (logical == BTRFS_SUPER_INFO_OFFSET)
+		return logical;
+
+	search.logical = logical;
+	entry = tree_search(&mdres->chunk_tree, &search.n, chunk_cmp, 1);
+	if (!entry) {
+		if (mdres->in != stdin)
+			printf("Couldn't find a chunk, using logical\n");
+		return logical;
+	}
+	fs_chunk = rb_entry(entry, struct fs_chunk, n);
+	if (fs_chunk->logical > logical || fs_chunk->logical + fs_chunk->bytes < logical)
+		BUG();
+	offset = search.logical - fs_chunk->logical;
+
+	*size = min(*size, fs_chunk->bytes + fs_chunk->logical - logical);
+	return fs_chunk->physical + offset;
+}
+
 static void *restore_worker(void *data)
 {
 	struct mdrestore_struct *mdres = (struct mdrestore_struct *)data;
@@ -1539,6 +1602,8 @@ static void *restore_worker(void *data)
 	}
 
 	while (1) {
+		u64 bytenr;
+		off_t offset = 0;
 		int err = 0;
 
 		pthread_mutex_lock(&mdres->mutex);
@@ -1582,16 +1647,27 @@ static void *restore_worker(void *data)
 				err = ret;
 		}
 
-		ret = pwrite64(outfd, outbuf, size, async->start);
-		if (ret < size) {
-			if (ret < 0) {
-				fprintf(stderr, "Error writing to device %d\n",
-					errno);
-				err = errno;
-			} else {
-				fprintf(stderr, "Short write\n");
-				err = -EIO;
+		while (size) {
+			u64 chunk_size = size;
+			bytenr = logical_to_physical(mdres,
+						     async->start + offset,
+						     &chunk_size);
+			ret = pwrite64(outfd, outbuf+offset, chunk_size,
+				       bytenr);
+			if (ret < chunk_size) {
+				if (ret < 0) {
+					fprintf(stderr, "Error writing to "
+						"device %d\n", errno);
+					err = errno;
+					break;
+				} else {
+					fprintf(stderr, "Short write\n");
+					err = -EIO;
+					break;
+				}
 			}
+			size -= chunk_size;
+			offset += chunk_size;
 		}
 
 		if (async->start == BTRFS_SUPER_INFO_OFFSET)
@@ -1613,7 +1689,16 @@ out:
 
 static void mdrestore_destroy(struct mdrestore_struct *mdres)
 {
+	struct rb_node *n;
 	int i;
+
+	while ((n = rb_first(&mdres->chunk_tree))) {
+		struct fs_chunk *entry;
+
+		entry = rb_entry(n, struct fs_chunk, n);
+		rb_erase(n, &mdres->chunk_tree);
+		free(entry);
+	}
 	pthread_mutex_lock(&mdres->mutex);
 	mdres->done = 1;
 	pthread_cond_broadcast(&mdres->cond);
@@ -1640,6 +1725,7 @@ static int mdrestore_init(struct mdrestore_struct *mdres,
 	mdres->in = in;
 	mdres->out = out;
 	mdres->old_restore = old_restore;
+	mdres->chunk_tree.rb_node = NULL;
 
 	if (!num_threads)
 		return 0;
@@ -1667,6 +1753,10 @@ static int fill_mdres_info(struct mdrestore_struct *mdres,
 	u8 *outbuf;
 	int ret;
 
+	/* We've already been initialized */
+	if (mdres->leafsize)
+		return 0;
+
 	if (mdres->compress_method == COMPRESS_ZLIB) {
 		size_t size = MAX_PENDING_SIZE * 2;
 
@@ -1785,6 +1875,317 @@ static int wait_for_worker(struct mdrestore_struct *mdres)
 	return ret;
 }
 
+static int read_chunk_block(struct mdrestore_struct *mdres, u8 *buffer,
+			    u64 bytenr, u64 item_bytenr, u32 bufsize,
+			    u64 cluster_bytenr)
+{
+	struct extent_buffer *eb;
+	int ret = 0;
+	int i;
+
+	eb = alloc_dummy_eb(bytenr, mdres->leafsize);
+	if (!eb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	while (item_bytenr != bytenr) {
+		buffer += mdres->leafsize;
+		item_bytenr += mdres->leafsize;
+	}
+
+	memcpy(eb->data, buffer, mdres->leafsize);
+	if (btrfs_header_bytenr(eb) != bytenr) {
+		fprintf(stderr, "Eb bytenr doesn't match found bytenr\n");
+		ret = -EIO;
+		goto out;
+	}
+
+	if (memcmp(mdres->fsid, eb->data + offsetof(struct btrfs_header, fsid),
+		   BTRFS_FSID_SIZE)) {
+		fprintf(stderr, "Fsid doesn't match\n");
+		ret = -EIO;
+		goto out;
+	}
+
+	if (btrfs_header_owner(eb) != BTRFS_CHUNK_TREE_OBJECTID) {
+		fprintf(stderr, "Does not belong to the chunk tree\n");
+		ret = -EIO;
+		goto out;
+	}
+
+	for (i = 0; i < btrfs_header_nritems(eb); i++) {
+		struct btrfs_chunk chunk;
+		struct fs_chunk *fs_chunk;
+		struct btrfs_key key;
+
+		if (btrfs_header_level(eb)) {
+			u64 blockptr = btrfs_node_blockptr(eb, i);
+
+			ret = search_for_chunk_blocks(mdres, blockptr,
+						      cluster_bytenr);
+			if (ret)
+				break;
+			continue;
+		}
+
+		/* Yay a leaf!  We loves leafs! */
+		btrfs_item_key_to_cpu(eb, &key, i);
+		if (key.type != BTRFS_CHUNK_ITEM_KEY)
+			continue;
+
+		fs_chunk = malloc(sizeof(struct fs_chunk));
+		if (!fs_chunk) {
+			fprintf(stderr, "Erorr allocating chunk\n");
+			ret = -ENOMEM;
+			break;
+		}
+		memset(fs_chunk, 0, sizeof(*fs_chunk));
+		read_extent_buffer(eb, &chunk, btrfs_item_ptr_offset(eb, i),
+				   sizeof(chunk));
+
+		fs_chunk->logical = key.offset;
+		fs_chunk->physical = btrfs_stack_stripe_offset(&chunk.stripe);
+		fs_chunk->bytes = btrfs_stack_chunk_length(&chunk);
+		tree_insert(&mdres->chunk_tree, &fs_chunk->n, chunk_cmp);
+	}
+out:
+	free(eb);
+	return ret;
+}
+
+/* If you have to ask you aren't worthy */
+static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
+				   u64 search, u64 cluster_bytenr)
+{
+	struct meta_cluster *cluster;
+	struct meta_cluster_header *header;
+	struct meta_cluster_item *item;
+	u64 current_cluster = cluster_bytenr, bytenr;
+	u64 item_bytenr;
+	u32 bufsize, nritems, i;
+	u8 *buffer, *tmp = NULL;
+	int ret = 0;
+
+	cluster = malloc(BLOCK_SIZE);
+	if (!cluster) {
+		fprintf(stderr, "Error allocating cluster\n");
+		return -ENOMEM;
+	}
+
+	buffer = malloc(MAX_PENDING_SIZE * 2);
+	if (!buffer) {
+		fprintf(stderr, "Error allocing buffer\n");
+		free(cluster);
+		return -ENOMEM;
+	}
+
+	if (mdres->compress_method == COMPRESS_ZLIB) {
+		tmp = malloc(MAX_PENDING_SIZE * 2);
+		if (!tmp) {
+			fprintf(stderr, "Error allocing tmp buffer\n");
+			free(cluster);
+			free(buffer);
+			return -ENOMEM;
+		}
+	}
+
+	bytenr = current_cluster;
+	while (1) {
+		if (fseek(mdres->in, current_cluster, SEEK_SET)) {
+			fprintf(stderr, "Error seeking: %d\n", errno);
+			ret = -EIO;
+			break;
+		}
+
+		ret = fread(cluster, BLOCK_SIZE, 1, mdres->in);
+		if (ret == 0) {
+			if (cluster_bytenr != 0) {
+				cluster_bytenr = 0;
+				current_cluster = 0;
+				bytenr = 0;
+				continue;
+			}
+			printf("ok this is where we screwed up?\n");
+			ret = -EIO;
+			break;
+		} else if (ret < 0) {
+			fprintf(stderr, "Error reading image\n");
+			break;
+		}
+		ret = 0;
+
+		header = &cluster->header;
+		if (le64_to_cpu(header->magic) != HEADER_MAGIC ||
+		    le64_to_cpu(header->bytenr) != current_cluster) {
+			fprintf(stderr, "bad header in metadump image\n");
+			ret = -EIO;
+			break;
+		}
+
+		bytenr += BLOCK_SIZE;
+		nritems = le32_to_cpu(header->nritems);
+		for (i = 0; i < nritems; i++) {
+			size_t size;
+
+			item = &cluster->items[i];
+			bufsize = le32_to_cpu(item->size);
+			item_bytenr = le64_to_cpu(item->bytenr);
+
+			if (mdres->compress_method == COMPRESS_ZLIB) {
+				ret = fread(tmp, bufsize, 1, mdres->in);
+				if (ret != 1) {
+					fprintf(stderr, "Error reading: %d\n",
+						errno);
+					ret = -EIO;
+					break;
+				}
+
+				size = MAX_PENDING_SIZE * 2;
+				ret = uncompress(buffer,
+						 (unsigned long *)&size, tmp,
+						 bufsize);
+				if (ret != Z_OK) {
+					fprintf(stderr, "Error decompressing "
+						"%d\n", ret);
+					ret = -EIO;
+					break;
+				}
+			} else {
+				ret = fread(buffer, bufsize, 1, mdres->in);
+				if (ret != 1) {
+					fprintf(stderr, "Error reading: %d\n",
+						errno);
+					ret = -EIO;
+					break;
+				}
+				size = bufsize;
+			}
+			ret = 0;
+
+			if (item_bytenr <= search &&
+			    item_bytenr + size > search) {
+				ret = read_chunk_block(mdres, buffer, search,
+						       item_bytenr, size,
+						       current_cluster);
+				if (!ret)
+					ret = 1;
+				break;
+			}
+			bytenr += bufsize;
+		}
+		if (ret) {
+			if (ret > 0)
+				ret = 0;
+			break;
+		}
+		if (bytenr & BLOCK_MASK)
+			bytenr += BLOCK_SIZE - (bytenr & BLOCK_MASK);
+		current_cluster = bytenr;
+	}
+
+	free(tmp);
+	free(buffer);
+	free(cluster);
+	return ret;
+}
+
+static int build_chunk_tree(struct mdrestore_struct *mdres,
+			    struct meta_cluster *cluster)
+{
+	struct btrfs_super_block *super;
+	struct meta_cluster_header *header;
+	struct meta_cluster_item *item = NULL;
+	u64 chunk_root_bytenr = 0;
+	u32 i, nritems;
+	u64 bytenr = 0;
+	u8 *buffer;
+	int ret;
+
+	/* We can't seek with stdin so don't bother doing this */
+	if (mdres->in == stdin)
+		return 0;
+
+	ret = fread(cluster, BLOCK_SIZE, 1, mdres->in);
+	if (ret <= 0) {
+		fprintf(stderr, "Error reading in cluster: %d\n", errno);
+		return -EIO;
+	}
+	ret = 0;
+
+	header = &cluster->header;
+	if (le64_to_cpu(header->magic) != HEADER_MAGIC ||
+	    le64_to_cpu(header->bytenr) != 0) {
+		fprintf(stderr, "bad header in metadump image\n");
+		return -EIO;
+	}
+
+	bytenr += BLOCK_SIZE;
+	mdres->compress_method = header->compress;
+	nritems = le32_to_cpu(header->nritems);
+	for (i = 0; i < nritems; i++) {
+		item = &cluster->items[i];
+
+		if (le64_to_cpu(item->bytenr) == BTRFS_SUPER_INFO_OFFSET)
+			break;
+		bytenr += le32_to_cpu(item->size);
+		if (fseek(mdres->in, le32_to_cpu(item->size), SEEK_CUR)) {
+			fprintf(stderr, "Error seeking: %d\n", errno);
+			return -EIO;
+		}
+	}
+
+	if (!item || le64_to_cpu(item->bytenr) != BTRFS_SUPER_INFO_OFFSET) {
+		fprintf(stderr, "Huh, didn't find the super?\n");
+		return -EINVAL;
+	}
+
+	buffer = malloc(le32_to_cpu(item->size));
+	if (!buffer) {
+		fprintf(stderr, "Error allocing buffer\n");
+		return -ENOMEM;
+	}
+
+	ret = fread(buffer, le32_to_cpu(item->size), 1, mdres->in);
+	if (ret != 1) {
+		fprintf(stderr, "Error reading buffer: %d\n", errno);
+		free(buffer);
+		return -EIO;
+	}
+
+	if (mdres->compress_method == COMPRESS_ZLIB) {
+		size_t size = MAX_PENDING_SIZE * 2;
+		u8 *tmp;
+
+		tmp = malloc(MAX_PENDING_SIZE * 2);
+		if (!tmp) {
+			free(buffer);
+			return -ENOMEM;
+		}
+		ret = uncompress(tmp, (unsigned long *)&size,
+				 buffer, le32_to_cpu(item->size));
+		if (ret != Z_OK) {
+			fprintf(stderr, "Error decompressing %d\n", ret);
+			free(buffer);
+			free(tmp);
+			return -EIO;
+		}
+		free(buffer);
+		buffer = tmp;
+	}
+
+	super = (struct btrfs_super_block *)buffer;
+	chunk_root_bytenr = btrfs_super_chunk_root(super);
+	mdres->leafsize = btrfs_super_leafsize(super);
+	memcpy(mdres->fsid, super->fsid, BTRFS_FSID_SIZE);
+	memcpy(mdres->uuid, super->dev_item.uuid,
+		       BTRFS_UUID_SIZE);
+	mdres->devid = le64_to_cpu(super->dev_item.devid);
+	free(buffer);
+
+	return search_for_chunk_blocks(mdres, chunk_root_bytenr, 0);
+}
+
 static int restore_metadump(const char *input, FILE *out, int old_restore,
 			    int num_threads)
 {
@@ -1822,6 +2223,15 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 		return ret;
 	}
 
+	ret = build_chunk_tree(&mdrestore, cluster);
+	if (ret)
+		goto out;
+
+	if (in != stdin && fseek(in, 0, SEEK_SET)) {
+		fprintf(stderr, "Error seeking %d\n", errno);
+		goto out;
+	}
+
 	while (1) {
 		ret = fread(cluster, BLOCK_SIZE, 1, in);
 		if (!ret)
@@ -1847,7 +2257,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 			break;
 		}
 	}
-
+out:
 	mdrestore_destroy(&mdrestore);
 	free(cluster);
 	if (in != stdin)
-- 
1.7.7.6

