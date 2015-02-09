Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36874 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760813AbbBIUDk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:40 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 07/16] btrfs-progs: fix btrfs-image overlapping chunks
Date: Mon, 9 Feb 2015 15:03:10 -0500
Message-ID: <1423512199-16552-8-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you create a metadump from a striped volume you will have chunks that refer
to different logical offsets with the same physical offset on different devices.
So when we do the restore we just truncate the number of stripes in each chunk
item and carry on, which causes problems because we then have chunks that point
to the same physical offset for different logical offsets.  To handle this
problem we keep track of logical extents that overlap on physical extents.
Then we go back and remap these extents into different physical extents on the
disk we are restoring onto.  This makes us actually able to restore a multi disk
image onto a single disk and have everything work out properly.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-image.c | 170 +++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 134 insertions(+), 36 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 4bcaf6c..aaff26d 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -67,7 +67,9 @@ struct fs_chunk {
 	u64 logical;
 	u64 physical;
 	u64 bytes;
-	struct rb_node n;
+	struct rb_node l;
+	struct rb_node p;
+	struct list_head list;
 };
 
 struct async_work {
@@ -125,10 +127,13 @@ struct mdrestore_struct {
 	pthread_cond_t cond;
 
 	struct rb_root chunk_tree;
+	struct rb_root physical_tree;
 	struct list_head list;
+	struct list_head overlapping_chunks;
 	size_t num_items;
 	u32 leafsize;
 	u64 devid;
+	u64 last_physical_offset;
 	u8 uuid[BTRFS_UUID_SIZE];
 	u8 fsid[BTRFS_FSID_SIZE];
 
@@ -138,6 +143,7 @@ struct mdrestore_struct {
 	int old_restore;
 	int fixup_offset;
 	int multi_devices;
+	int clear_space_cache;
 	struct btrfs_fs_info *info;
 };
 
@@ -202,8 +208,8 @@ static int name_cmp(struct rb_node *a, struct rb_node *b, int fuzz)
 
 static int chunk_cmp(struct rb_node *a, struct rb_node *b, int fuzz)
 {
-	struct fs_chunk *entry = rb_entry(a, struct fs_chunk, n);
-	struct fs_chunk *ins = rb_entry(b, struct fs_chunk, n);
+	struct fs_chunk *entry = rb_entry(a, struct fs_chunk, l);
+	struct fs_chunk *ins = rb_entry(b, struct fs_chunk, l);
 
 	if (fuzz && ins->logical >= entry->logical &&
 	    ins->logical < entry->logical + entry->bytes)
@@ -216,6 +222,26 @@ static int chunk_cmp(struct rb_node *a, struct rb_node *b, int fuzz)
 	return 0;
 }
 
+static int physical_cmp(struct rb_node *a, struct rb_node *b, int fuzz)
+{
+	struct fs_chunk *entry = rb_entry(a, struct fs_chunk, p);
+	struct fs_chunk *ins = rb_entry(b, struct fs_chunk, p);
+
+	if (fuzz && ins->physical >= entry->physical &&
+	    ins->physical < entry->physical + entry->bytes)
+		return 0;
+
+	if (fuzz && entry->physical >= ins->physical &&
+	    entry->physical < ins->physical + ins->bytes)
+		return 0;
+
+	if (ins->physical < entry->physical)
+		return -1;
+	else if (ins->physical > entry->physical)
+		return 1;
+	return 0;
+}
+
 static void tree_insert(struct rb_root *root, struct rb_node *ins,
 			int (*cmp)(struct rb_node *a, struct rb_node *b,
 				   int fuzz))
@@ -227,7 +253,7 @@ static void tree_insert(struct rb_root *root, struct rb_node *ins,
 	while(*p) {
 		parent = *p;
 
-		dir = cmp(*p, ins, 0);
+		dir = cmp(*p, ins, 1);
 		if (dir < 0)
 			p = &(*p)->rb_left;
 		else if (dir > 0)
@@ -262,6 +288,33 @@ static struct rb_node *tree_search(struct rb_root *root,
 	return NULL;
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
+	entry = tree_search(&mdres->chunk_tree, &search.l, chunk_cmp, 1);
+	if (!entry) {
+		if (mdres->in != stdin)
+			printf("Couldn't find a chunk, using logical\n");
+		return logical;
+	}
+	fs_chunk = rb_entry(entry, struct fs_chunk, l);
+	if (fs_chunk->logical > logical || fs_chunk->logical + fs_chunk->bytes < logical)
+		BUG();
+	offset = search.logical - fs_chunk->logical;
+
+	*size = min(*size, fs_chunk->bytes + fs_chunk->logical - logical);
+	return fs_chunk->physical + offset;
+}
+
+
 static char *find_collision(struct metadump_struct *md, char *name,
 			    u32 name_len)
 {
@@ -1396,7 +1449,7 @@ static void update_super_old(u8 *buffer)
 	csum_block(buffer, BTRFS_SUPER_INFO_SIZE);
 }
 
-static int update_super(u8 *buffer)
+static int update_super(struct mdrestore_struct *mdres, u8 *buffer)
 {
 	struct btrfs_super_block *super = (struct btrfs_super_block *)buffer;
 	struct btrfs_chunk *chunk;
@@ -1423,6 +1476,8 @@ static int update_super(u8 *buffer)
 		cur += sizeof(*disk_key);
 
 		if (key.type == BTRFS_CHUNK_ITEM_KEY) {
+			u64 physical, size = 0;
+
 			chunk = (struct btrfs_chunk *)ptr;
 			old_num_stripes = btrfs_stack_chunk_num_stripes(chunk);
 			chunk = (struct btrfs_chunk *)write_ptr;
@@ -1432,7 +1487,13 @@ static int update_super(u8 *buffer)
 			btrfs_set_stack_chunk_sub_stripes(chunk, 0);
 			btrfs_set_stack_chunk_type(chunk,
 						   BTRFS_BLOCK_GROUP_SYSTEM);
-			chunk->stripe.devid = super->dev_item.devid;
+			btrfs_set_stack_stripe_devid(&chunk->stripe,
+						     super->dev_item.devid);
+			physical = logical_to_physical(mdres, key.offset,
+						       &size);
+			if (size != (u64)-1)
+				btrfs_set_stack_stripe_offset(&chunk->stripe,
+							      physical);
 			memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid,
 			       BTRFS_UUID_SIZE);
 			new_array_size += sizeof(*chunk);
@@ -1446,6 +1507,9 @@ static int update_super(u8 *buffer)
 		cur += btrfs_chunk_item_size(old_num_stripes);
 	}
 
+	if (mdres->clear_space_cache)
+		btrfs_set_super_cache_generation(super, 0);
+
 	btrfs_set_super_sys_array_size(super, new_array_size);
 	csum_block(buffer, BTRFS_SUPER_INFO_SIZE);
 
@@ -1536,7 +1600,7 @@ static int fixup_chunk_tree_block(struct mdrestore_struct *mdres,
 		for (i = 0; i < btrfs_header_nritems(eb); i++) {
 			struct btrfs_chunk chunk;
 			struct btrfs_key key;
-			u64 type;
+			u64 type, physical, size = (u64)-1;
 
 			btrfs_item_key_to_cpu(eb, &key, i);
 			if (key.type != BTRFS_CHUNK_ITEM_KEY)
@@ -1546,6 +1610,10 @@ static int fixup_chunk_tree_block(struct mdrestore_struct *mdres,
 					   btrfs_item_ptr_offset(eb, i),
 					   sizeof(chunk));
 
+			size = 0;
+			physical = logical_to_physical(mdres, key.offset,
+						       &size);
+
 			/* Zero out the RAID profile */
 			type = btrfs_stack_chunk_type(&chunk);
 			type &= (BTRFS_BLOCK_GROUP_DATA |
@@ -1557,6 +1625,9 @@ static int fixup_chunk_tree_block(struct mdrestore_struct *mdres,
 			btrfs_set_stack_chunk_num_stripes(&chunk, 1);
 			btrfs_set_stack_chunk_sub_stripes(&chunk, 0);
 			btrfs_set_stack_stripe_devid(&chunk.stripe, mdres->devid);
+			if (size != (u64)-1)
+				btrfs_set_stack_stripe_offset(&chunk.stripe,
+							      physical);
 			memcpy(chunk.stripe.dev_uuid, mdres->uuid,
 			       BTRFS_UUID_SIZE);
 			write_extent_buffer(eb, &chunk,
@@ -1611,32 +1682,6 @@ static void write_backup_supers(int fd, u8 *buf)
 	}
 }
 
-static u64 logical_to_physical(struct mdrestore_struct *mdres, u64 logical, u64 *size)
-{
-	struct fs_chunk *fs_chunk;
-	struct rb_node *entry;
-	struct fs_chunk search;
-	u64 offset;
-
-	if (logical == BTRFS_SUPER_INFO_OFFSET)
-		return logical;
-
-	search.logical = logical;
-	entry = tree_search(&mdres->chunk_tree, &search.n, chunk_cmp, 1);
-	if (!entry) {
-		if (mdres->in != stdin)
-			printf("Couldn't find a chunk, using logical\n");
-		return logical;
-	}
-	fs_chunk = rb_entry(entry, struct fs_chunk, n);
-	if (fs_chunk->logical > logical || fs_chunk->logical + fs_chunk->bytes < logical)
-		BUG();
-	offset = search.logical - fs_chunk->logical;
-
-	*size = min(*size, fs_chunk->bytes + fs_chunk->logical - logical);
-	return fs_chunk->physical + offset;
-}
-
 static void *restore_worker(void *data)
 {
 	struct mdrestore_struct *mdres = (struct mdrestore_struct *)data;
@@ -1696,7 +1741,7 @@ static void *restore_worker(void *data)
 				if (mdres->old_restore) {
 					update_super_old(outbuf);
 				} else {
-					ret = update_super(outbuf);
+					ret = update_super(mdres, outbuf);
 					if (ret)
 						err = ret;
 				}
@@ -1769,8 +1814,9 @@ static void mdrestore_destroy(struct mdrestore_struct *mdres, int num_threads)
 	while ((n = rb_first(&mdres->chunk_tree))) {
 		struct fs_chunk *entry;
 
-		entry = rb_entry(n, struct fs_chunk, n);
+		entry = rb_entry(n, struct fs_chunk, l);
 		rb_erase(n, &mdres->chunk_tree);
+		rb_erase(&entry->p, &mdres->physical_tree);
 		free(entry);
 	}
 	pthread_mutex_lock(&mdres->mutex);
@@ -1797,6 +1843,7 @@ static int mdrestore_init(struct mdrestore_struct *mdres,
 	pthread_cond_init(&mdres->cond, NULL);
 	pthread_mutex_init(&mdres->mutex, NULL);
 	INIT_LIST_HEAD(&mdres->list);
+	INIT_LIST_HEAD(&mdres->overlapping_chunks);
 	mdres->in = in;
 	mdres->out = out;
 	mdres->old_restore = old_restore;
@@ -1804,6 +1851,8 @@ static int mdrestore_init(struct mdrestore_struct *mdres,
 	mdres->fixup_offset = fixup_offset;
 	mdres->info = info;
 	mdres->multi_devices = multi_devices;
+	mdres->clear_space_cache = 0;
+	mdres->last_physical_offset = 0;
 
 	if (!num_threads)
 		return 0;
@@ -2025,7 +2074,18 @@ static int read_chunk_block(struct mdrestore_struct *mdres, u8 *buffer,
 		fs_chunk->logical = key.offset;
 		fs_chunk->physical = btrfs_stack_stripe_offset(&chunk.stripe);
 		fs_chunk->bytes = btrfs_stack_chunk_length(&chunk);
-		tree_insert(&mdres->chunk_tree, &fs_chunk->n, chunk_cmp);
+		INIT_LIST_HEAD(&fs_chunk->list);
+		if (tree_search(&mdres->physical_tree, &fs_chunk->p,
+				physical_cmp, 1) != NULL)
+			list_add(&fs_chunk->list, &mdres->overlapping_chunks);
+		else
+			tree_insert(&mdres->physical_tree, &fs_chunk->p,
+				    physical_cmp);
+		if (fs_chunk->physical + fs_chunk->bytes >
+		    mdres->last_physical_offset)
+			mdres->last_physical_offset = fs_chunk->physical +
+				fs_chunk->bytes;
+		tree_insert(&mdres->chunk_tree, &fs_chunk->l, chunk_cmp);
 	}
 out:
 	free(eb);
@@ -2274,6 +2334,42 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 	return search_for_chunk_blocks(mdres, chunk_root_bytenr, 0);
 }
 
+static int range_contains_super(u64 physical, u64 bytes)
+{
+	u64 super_bytenr;
+	int i;
+
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		super_bytenr = btrfs_sb_offset(i);
+		if (super_bytenr >= physical &&
+		    super_bytenr < physical + bytes)
+			return 1;
+	}
+
+	return 0;
+}
+
+static void remap_overlapping_chunks(struct mdrestore_struct *mdres)
+{
+	struct fs_chunk *fs_chunk;
+
+	while (!list_empty(&mdres->overlapping_chunks)) {
+		fs_chunk = list_first_entry(&mdres->overlapping_chunks,
+					    struct fs_chunk, list);
+		list_del_init(&fs_chunk->list);
+		if (range_contains_super(fs_chunk->physical,
+					 fs_chunk->bytes)) {
+			fprintf(stderr, "Remapping a chunk that had a super "
+				"mirror inside of it, clearing space cache "
+				"so we don't end up with corruption\n");
+			mdres->clear_space_cache = 1;
+		}
+		fs_chunk->physical = mdres->last_physical_offset;
+		tree_insert(&mdres->physical_tree, &fs_chunk->p, physical_cmp);
+		mdres->last_physical_offset += fs_chunk->bytes;
+	}
+}
+
 static int __restore_metadump(const char *input, FILE *out, int old_restore,
 			      int num_threads, int fixup_offset,
 			      const char *target, int multi_devices)
@@ -2328,6 +2424,8 @@ static int __restore_metadump(const char *input, FILE *out, int old_restore,
 		ret = build_chunk_tree(&mdrestore, cluster);
 		if (ret)
 			goto out;
+		if (!list_empty(&mdrestore.overlapping_chunks))
+			remap_overlapping_chunks(&mdrestore);
 	}
 
 	if (in != stdin && fseek(in, 0, SEEK_SET)) {
-- 
1.8.3.1

