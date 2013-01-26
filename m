Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:50022 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab3AZAYJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 19:24:09 -0500
Received: from twilight.demius.net (c-297271d5.013-195-6c756e10.cust.bredbandsbolaget.se [213.113.114.41])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id AA16940C020
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Jan 2013 01:24:06 +0100 (CET)
From: Ian Kumlien <pomac@demius.net>
To: linux-btrfs@vger.kernel.org
Cc: Ian Kumlien <pomac@demius.net>
Subject: [PATCH] [RFC] Abort on memory allocation failure.
Date: Sat, 26 Jan 2013 01:19:46 +0100
Message-Id: <1359159586-20773-2-git-send-email-pomac@demius.net>
In-Reply-To: <1359159586-20773-1-git-send-email-pomac@demius.net>
References: <1359159586-20773-1-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

declare btrfs_<calloc|malloc|strdup|strndup>, verify the memory
and abort() if allocation fails.

Please verify, there is a small glitch about strndup being redefined
during compilation - haven't had time to figure out why this happened.

Another issue is that there seems to be a malloc failure tracking,
which will no longer work.
---
 bit-radix.c         |  4 +---
 btrfs-image.c       | 32 ++++++++++----------------
 btrfs-list.c        | 66 ++++++++++++-----------------------------------------
 btrfs-map-logical.c |  2 +-
 btrfs-vol.c         |  4 ++--
 btrfsck.c           | 30 +++++++++++-------------
 btrfsctl.c          |  4 ++--
 calc-size.c         |  6 +----
 cmds-filesystem.c   |  4 +---
 cmds-inspect.c      |  8 ++-----
 cmds-receive.c      | 16 ++++++-------
 cmds-scrub.c        | 20 ++++++----------
 cmds-send.c         |  2 +-
 cmds-subvolume.c    | 14 ++++++------
 convert.c           | 40 ++++++++------------------------
 disk-io.c           | 22 ++++++++----------
 extent-cache.c      |  4 +---
 extent_io.c         | 10 ++------
 find-root.c         | 25 +++++++-------------
 kerncompat.h        |  7 +++---
 mkfs.c              | 24 ++++++++-----------
 qgroup.c            |  6 +----
 quick-test.c        |  2 +-
 radix-tree.c        |  8 +++----
 repair.c            |  4 +---
 restore.c           | 27 ++++------------------
 send-stream.c       |  4 +---
 send-utils.c        |  8 +++----
 transaction.h       |  4 +++-
 utils-alloc.h       | 45 ++++++++++++++++++++++++++++++++++++
 utils.c             | 32 ++++++--------------------
 utils.h             |  2 ++
 volumes.c           |  9 ++------
 33 files changed, 189 insertions(+), 306 deletions(-)
 create mode 100644 utils-alloc.h

diff --git a/bit-radix.c b/bit-radix.c
index 57f6f3c..1acb57e 100644
--- a/bit-radix.c
+++ b/bit-radix.c
@@ -34,9 +34,7 @@ int set_radix_bit(struct radix_tree_root *radix, unsigned long bit)
 
 	bits = radix_tree_lookup(radix, slot);
 	if (!bits) {
-		bits = malloc(BIT_ARRAY_BYTES);
-		if (!bits)
-			return -ENOMEM;
+		bits = btrfs_malloc(BIT_ARRAY_BYTES);
 		memset(bits + 1, 0, BIT_ARRAY_BYTES - sizeof(unsigned long));
 		bits[0] = slot;
 		radix_tree_preload(GFP_NOFS);
diff --git a/btrfs-image.c b/btrfs-image.c
index f2bbcc8..a4484e8 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -214,7 +214,7 @@ static void *dump_worker(void *data)
 			u8 *orig = async->buffer;
 
 			async->bufsize = compressBound(async->size);
-			async->buffer = malloc(async->bufsize);
+			async->buffer = btrfs_malloc(async->bufsize);
 
 			ret = compress2(async->buffer,
 					 (unsigned long *)&async->bufsize,
@@ -260,18 +260,15 @@ static int metadump_init(struct metadump_struct *md, struct btrfs_root *root,
 	md->out = out;
 	md->pending_start = (u64)-1;
 	md->compress_level = compress_level;
-	md->cluster = calloc(1, BLOCK_SIZE);
-	if (!md->cluster)
-		return -ENOMEM;
+	md->cluster = btrfs_calloc(1, BLOCK_SIZE);
 
 	meta_cluster_init(md, 0);
 	if (!num_threads)
 		return 0;
 
 	md->num_threads = num_threads;
-	md->threads = calloc(num_threads, sizeof(pthread_t));
-	if (!md->threads)
-		return -ENOMEM;
+	md->threads = btrfs_calloc(num_threads, sizeof(pthread_t));
+
 	for (i = 0; i < num_threads; i++) {
 		ret = pthread_create(md->threads + i, NULL, dump_worker, md);
 		if (ret)
@@ -377,14 +374,12 @@ static int flush_pending(struct metadump_struct *md, int done)
 	int ret;
 
 	if (md->pending_size) {
-		async = calloc(1, sizeof(*async));
-		if (!async)
-			return -ENOMEM;
+		async = btrfs_calloc(1, sizeof(*async));
 
 		async->start = md->pending_start;
 		async->size = md->pending_size;
 		async->bufsize = async->size;
-		async->buffer = malloc(async->bufsize);
+		async->buffer = btrfs_malloc(async->bufsize);
 
 		offset = 0;
 		start = async->start;
@@ -610,8 +605,7 @@ static void *restore_worker(void *data)
 	int ret;
 
 	outfd = fileno(mdres->out);
-	buffer = malloc(MAX_PENDING_SIZE * 2);
-	BUG_ON(!buffer);
+	buffer = btrfs_malloc(MAX_PENDING_SIZE * 2);
 
 	while (1) {
 		pthread_mutex_lock(&mdres->mutex);
@@ -671,9 +665,8 @@ static int mdresotre_init(struct mdrestore_struct *mdres,
 		return 0;
 
 	mdres->num_threads = num_threads;
-	mdres->threads = calloc(num_threads, sizeof(pthread_t));
-	if (!mdres->threads)
-		return -ENOMEM;
+	mdres->threads = btrfs_calloc(num_threads, sizeof(pthread_t));
+
 	for (i = 0; i < num_threads; i++) {
 		ret = pthread_create(mdres->threads + i, NULL, restore_worker,
 				     mdres);
@@ -716,10 +709,10 @@ static int add_cluster(struct meta_cluster *cluster,
 	nritems = le32_to_cpu(header->nritems);
 	for (i = 0; i < nritems; i++) {
 		item = &cluster->items[i];
-		async = calloc(1, sizeof(*async));
+		async = btrfs_calloc(1, sizeof(*async));
 		async->start = le64_to_cpu(item->bytenr);
 		async->bufsize = le32_to_cpu(item->size);
-		async->buffer = malloc(async->bufsize);
+		async->buffer = btrfs_malloc(async->bufsize);
 		ret = fread(async->buffer, async->bufsize, 1, mdres->in);
 		BUG_ON(ret != 1);
 		bytenr += async->bufsize;
@@ -777,8 +770,7 @@ static int restore_metadump(const char *input, FILE *out, int num_threads)
 		}
 	}
 
-	cluster = malloc(BLOCK_SIZE);
-	BUG_ON(!cluster);
+	cluster = btrfs_malloc(BLOCK_SIZE);
 
 	ret = mdresotre_init(&mdrestore, in, out, num_threads);
 	BUG_ON(ret);
diff --git a/btrfs-list.c b/btrfs-list.c
index e5f0f96..0fe021d 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -264,11 +264,7 @@ struct btrfs_list_comparer_set *btrfs_list_alloc_comparer_set(void)
 
 	size = sizeof(struct btrfs_list_comparer_set) +
 	       BTRFS_LIST_NCOMPS_INCREASE * sizeof(struct btrfs_list_comparer);
-	set = malloc(size);
-	if (!set) {
-		fprintf(stderr, "memory allocation failed\n");
-		exit(1);
-	}
+	set = btrfs_malloc(size);
 
 	memset(set, 0, size);
 	set->total = BTRFS_LIST_NCOMPS_INCREASE;
@@ -446,11 +442,7 @@ static int update_root(struct root_lookup *root_lookup,
 		if (ri->name)
 			free(ri->name);
 
-		ri->name = malloc(name_len + 1);
-		if (!ri->name) {
-			fprintf(stderr, "memory allocation failed\n");
-			exit(1);
-		}
+		ri->name = btrfs_malloc(name_len + 1);
 		strncpy(ri->name, name, name_len);
 		ri->name[name_len] = 0;
 	}
@@ -503,20 +495,12 @@ static int add_root(struct root_lookup *root_lookup,
 	if (!ret)
 		return 0;
 
-	ri = malloc(sizeof(*ri));
-	if (!ri) {
-		printf("memory allocation failed\n");
-		exit(1);
-	}
+	ri = btrfs_malloc(sizeof(*ri));
 	memset(ri, 0, sizeof(*ri));
 	ri->root_id = root_id;
 
 	if (name && name_len > 0) {
-		ri->name = malloc(name_len + 1);
-		if (!ri->name) {
-			fprintf(stderr, "memory allocation failed\n");
-			exit(1);
-		}
+		ri->name = btrfs_malloc(name_len + 1);
 		strncpy(ri->name, name, name_len);
 		ri->name[name_len] = 0;
 	}
@@ -602,11 +586,7 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 		int add_len = strlen(found->path);
 
 		/* room for / and for null */
-		tmp = malloc(add_len + 2 + len);
-		if (!tmp) {
-			perror("malloc failed");
-			exit(1);
-		}
+		tmp = btrfs_malloc(add_len + 2 + len);
 		if (full_path) {
 			memcpy(tmp + add_len + 1, full_path, len);
 			tmp[add_len] = '/';
@@ -616,7 +596,7 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 			full_path = tmp;
 			len += add_len + 1;
 		} else {
-			full_path = strdup(found->path);
+			full_path = btrfs_strdup(found->path);
 			len = add_len;
 		}
 
@@ -631,7 +611,7 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 			char p[] = "<FS_TREE>";
 			add_len = strlen(p);
 			len = strlen(full_path);
-			tmp = malloc(len + add_len + 2);
+			tmp = btrfs_malloc(len + add_len + 2);
 			memcpy(tmp + add_len + 1, full_path, len);
 			tmp[add_len] = '/';
 			memcpy(tmp, p, add_len);
@@ -690,20 +670,12 @@ static int lookup_ino_path(int fd, struct root_info *ri)
 		 * we're in a subdirectory of ref_tree, the kernel ioctl
 		 * puts a / in there for us
 		 */
-		ri->path = malloc(strlen(ri->name) + strlen(args.name) + 1);
-		if (!ri->path) {
-			perror("malloc failed");
-			exit(1);
-		}
+		ri->path = btrfs_malloc(strlen(ri->name) + strlen(args.name) + 1);
 		strcpy(ri->path, args.name);
 		strcat(ri->path, ri->name);
 	} else {
 		/* we're at the root of ref_tree */
-		ri->path = strdup(ri->name);
-		if (!ri->path) {
-			perror("strdup failed");
-			exit(1);
-		}
+		ri->path = btrfs_strdup(ri->name);
 	}
 	return 0;
 }
@@ -834,11 +806,7 @@ static char *__ino_resolve(int fd, u64 dirid)
 		 * we're in a subdirectory of ref_tree, the kernel ioctl
 		 * puts a / in there for us
 		 */
-		full = strdup(args.name);
-		if (!full) {
-			perror("malloc failed");
-			return ERR_PTR(-ENOMEM);
-		}
+		full = btrfs_strdup(args.name);
 	} else {
 		/* we're at the root of ref_tree */
 		full = NULL;
@@ -854,11 +822,9 @@ char *build_name(char *dirid, char *name)
 {
 	char *full;
 	if (!dirid)
-		return strdup(name);
+		return btrfs_strdup(name);
 
-	full = malloc(strlen(dirid) + strlen(name) + 1);
-	if (!full)
-		return NULL;
+	full = btrfs_malloc(strlen(dirid) + strlen(name) + 1);
 	strcpy(full, dirid);
 	strcat(full, name);
 	return full;
@@ -923,7 +889,7 @@ static char *ino_resolve(int fd, u64 ino, u64 *cache_dirid, char **cache_name)
 		namelen = btrfs_stack_inode_ref_name_len(ref);
 
 		name = (char *)(ref + 1);
-		name = strndup(name, namelen);
+		name = btrfs_strndup(name, namelen);
 
 		/* use our cached value */
 		if (dirid == *cache_dirid && *cache_name) {
@@ -1196,11 +1162,7 @@ struct btrfs_list_filter_set *btrfs_list_alloc_filter_set(void)
 
 	size = sizeof(struct btrfs_list_filter_set) +
 	       BTRFS_LIST_NFILTERS_INCREASE * sizeof(struct btrfs_list_filter);
-	set = malloc(size);
-	if (!set) {
-		fprintf(stderr, "memory allocation failed\n");
-		exit(1);
-	}
+	set = btrfs_malloc(size);
 
 	memset(set, 0, size);
 	set->total = BTRFS_LIST_NFILTERS_INCREASE;
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index fa4fb3f..d28a5fb 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -148,7 +148,7 @@ int main(int ac, char **av)
 				}
 				break;
 			case 'o':
-				output_file = strdup(optarg);
+				output_file = btrfs_strdup(optarg);
 				break;
 			default:
 				print_usage();
diff --git a/btrfs-vol.c b/btrfs-vol.c
index ad824bd..591c799 100644
--- a/btrfs-vol.c
+++ b/btrfs-vol.c
@@ -91,14 +91,14 @@ int main(int ac, char **av)
 			break;
 		switch(c) {
 			case 'a':
-				device = strdup(optarg);
+				device = btrfs_strdup(optarg);
 				cmd = BTRFS_IOC_ADD_DEV;
 				break;
 			case 'b':
 				cmd = BTRFS_IOC_BALANCE;
 				break;
 			case 'r':
-				device = strdup(optarg);
+				device = btrfs_strdup(optarg);
 				cmd = BTRFS_IOC_RM_DEV;
 				break;
 			default:
diff --git a/btrfsck.c b/btrfsck.c
index 67f4a9d..30f0755 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -230,14 +230,14 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 	struct inode_backref *orig;
 	size_t size;
 
-	rec = malloc(sizeof(*rec));
+	rec = btrfs_malloc(sizeof(*rec));
 	memcpy(rec, orig_rec, sizeof(*rec));
 	rec->refs = 1;
 	INIT_LIST_HEAD(&rec->backrefs);
 
 	list_for_each_entry(orig, &orig_rec->backrefs, list) {
 		size = sizeof(*orig) + orig->namelen + 1;
-		backref = malloc(size);
+		backref = btrfs_malloc(size);
 		memcpy(backref, orig, size);
 		list_add_tail(&backref->list, &rec->backrefs);
 	}
@@ -262,14 +262,14 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 			rec = node->data;
 		}
 	} else if (mod) {
-		rec = calloc(1, sizeof(*rec));
+		rec = btrfs_calloc(1, sizeof(*rec));
 		rec->ino = ino;
 		rec->extent_start = (u64)-1;
 		rec->first_extent_gap = (u64)-1;
 		rec->refs = 1;
 		INIT_LIST_HEAD(&rec->backrefs);
 
-		node = malloc(sizeof(*node));
+		node = btrfs_malloc(sizeof(*node));
 		node->cache.start = ino;
 		node->cache.size = 1;
 		node->data = rec;
@@ -427,7 +427,7 @@ static struct inode_backref *get_inode_backref(struct inode_record *rec,
 		return backref;
 	}
 
-	backref = malloc(sizeof(*backref) + namelen + 1);
+	backref = btrfs_malloc(sizeof(*backref) + namelen + 1);
 	memset(backref, 0, sizeof(*backref));
 	backref->dir = dir;
 	backref->namelen = namelen;
@@ -590,7 +590,7 @@ again:
 			remove_cache_extent(src, &node->cache);
 			ins = node;
 		} else {
-			ins = malloc(sizeof(*ins));
+			ins = btrfs_malloc(sizeof(*ins));
 			ins->cache.start = node->cache.start;
 			ins->cache.size = node->cache.size;
 			ins->data = rec;
@@ -667,7 +667,7 @@ static int add_shared_node(struct cache_tree *shared, u64 bytenr, u32 refs)
 	int ret;
 	struct shared_node *node;
 
-	node = calloc(1, sizeof(*node));
+	node = btrfs_calloc(1, sizeof(*node));
 	node->cache.start = bytenr;
 	node->cache.size = 1;
 	cache_tree_init(&node->root_cache);
@@ -1357,7 +1357,7 @@ static struct root_record *get_root_rec(struct cache_tree *root_cache,
 	if (cache) {
 		rec = container_of(cache, struct root_record, cache);
 	} else {
-		rec = calloc(1, sizeof(*rec));
+		rec = btrfs_calloc(1, sizeof(*rec));
 		rec->objectid = objectid;
 		INIT_LIST_HEAD(&rec->backrefs);
 		rec->cache.start = objectid;
@@ -1384,7 +1384,7 @@ static struct root_backref *get_root_backref(struct root_record *rec,
 		return backref;
 	}
 
-	backref = malloc(sizeof(*backref) + namelen + 1);
+	backref = btrfs_malloc(sizeof(*backref) + namelen + 1);
 	memset(backref, 0, sizeof(*backref));
 	backref->ref_root = ref_root;
 	backref->dir = dir;
@@ -2084,7 +2084,7 @@ static struct tree_backref *find_tree_backref(struct extent_record *rec,
 static struct tree_backref *alloc_tree_backref(struct extent_record *rec,
 						u64 parent, u64 root)
 {
-	struct tree_backref *ref = malloc(sizeof(*ref));
+	struct tree_backref *ref = btrfs_malloc(sizeof(*ref));
 	memset(&ref->node, 0, sizeof(ref->node));
 	if (parent > 0) {
 		ref->parent = parent;
@@ -2133,7 +2133,7 @@ static struct data_backref *alloc_data_backref(struct extent_record *rec,
 						u64 owner, u64 offset,
 						u64 max_size)
 {
-	struct data_backref *ref = malloc(sizeof(*ref));
+	struct data_backref *ref = btrfs_malloc(sizeof(*ref));
 	memset(&ref->node, 0, sizeof(ref->node));
 	ref->node.is_data = 1;
 
@@ -2207,7 +2207,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 		maybe_free_extent_rec(extent_cache, rec);
 		return ret;
 	}
-	rec = malloc(sizeof(*rec));
+	rec = btrfs_malloc(sizeof(*rec));
 	rec->start = start;
 	rec->max_size = max_size;
 	rec->nr = max(nr, max_size);
@@ -3402,11 +3402,7 @@ static int check_extents(struct btrfs_trans_handle *trans,
 	}
 
 	bits_nr = 1024;
-	bits = malloc(bits_nr * sizeof(struct block_info));
-	if (!bits) {
-		perror("malloc");
-		exit(1);
-	}
+	bits = btrfs_malloc(bits_nr * sizeof(struct block_info));
 
 	add_root_to_pending(root->fs_info->tree_root->node, bits, bits_nr,
 			    &extent_cache, &pending, &seen, &reada, &nodes,
diff --git a/btrfsctl.c b/btrfsctl.c
index 518684c..e2c8f66 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -125,12 +125,12 @@ int main(int ac, char **av)
 			}
 			fullpath = av[i + 1];
 
-			snap_location = strdup(fullpath);
+			snap_location = btrfs_strdup(fullpath);
 			snap_location = dirname(snap_location);
 
 			snap_fd = open_file_or_dir(snap_location);
 
-			name = strdup(fullpath);
+			name = btrfs_strdup(fullpath);
 			name = basename(name);
 			len = strlen(name);
 
diff --git a/calc-size.c b/calc-size.c
index c4adfb0..70fba54 100644
--- a/calc-size.c
+++ b/calc-size.c
@@ -232,11 +232,7 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	roots = malloc(fs_roots_size);
-	if (!roots) {
-		fprintf(stderr, "No memory\n");
-		goto out;
-	}
+	roots = btrfs_malloc(fs_roots_size);
 
 	printf("Calculating size of root tree\n");
 	key.objectid = BTRFS_ROOT_TREE_OBJECTID;
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 9c43d35..a726631 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -65,9 +65,7 @@ static int cmd_df(int argc, char **argv)
 		return 12;
 	}
 
-	sargs_orig = sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
-	if (!sargs)
-		return -ENOMEM;
+	sargs_orig = sargs = btrfs_malloc(sizeof(struct btrfs_ioctl_space_args));
 
 	sargs->space_slots = 0;
 	sargs->total_spaces = 0;
diff --git a/cmds-inspect.c b/cmds-inspect.c
index edabff5..70e5665 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -38,9 +38,7 @@ static int __ino_to_path_fd(u64 inum, int fd, int verbose, const char *prepend)
 	struct btrfs_ioctl_ino_path_args ipa;
 	struct btrfs_data_container *fspath;
 
-	fspath = malloc(4096);
-	if (!fspath)
-		return 1;
+	fspath = btrfs_malloc(4096);
 
 	ipa.inum = inum;
 	ipa.size = 4096;
@@ -162,9 +160,7 @@ static int cmd_logical_resolve(int argc, char **argv)
 		usage(cmd_logical_resolve_usage);
 
 	size = min(size, (u64)64 * 1024);
-	inodes = malloc(size);
-	if (!inodes)
-		return 1;
+	inodes = btrfs_malloc(size);
 
 	loi.logical = atoll(argv[optind]);
 	loi.size = size;
diff --git a/cmds-receive.c b/cmds-receive.c
index a8be6fa..0222456 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -147,10 +147,10 @@ static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
 	if (ret < 0)
 		goto out;
 
-	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
+	r->cur_subvol = btrfs_calloc(1, sizeof(*r->cur_subvol));
 	r->parent_subvol = NULL;
 
-	r->cur_subvol->path = strdup(path);
+	r->cur_subvol->path = btrfs_strdup(path);
 	r->full_subvol_path = path_cat(r->root_path, path);
 
 	fprintf(stderr, "At subvol %s\n", path);
@@ -192,10 +192,10 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 	if (ret < 0)
 		goto out;
 
-	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
+	r->cur_subvol = btrfs_calloc(1, sizeof(*r->cur_subvol));
 	r->parent_subvol = NULL;
 
-	r->cur_subvol->path = strdup(path);
+	r->cur_subvol->path = btrfs_strdup(path);
 	r->full_subvol_path = path_cat(r->root_path, path);
 
 	fprintf(stderr, "At snapshot %s\n", path);
@@ -487,7 +487,7 @@ static int open_inode_for_write(struct btrfs_receive *r, const char *path)
 		goto out;
 	}
 	free(r->write_path);
-	r->write_path = strdup(path);
+	r->write_path = btrfs_strdup(path);
 
 out:
 	return ret;
@@ -562,7 +562,7 @@ static int process_clone(const char *path, u64 offset, u64 len,
 		if (memcmp(clone_uuid, r->cur_subvol->received_uuid,
 				BTRFS_FSID_SIZE) == 0) {
 			/* TODO check generation of extent */
-			subvol_path = strdup(r->cur_subvol->path);
+			subvol_path = btrfs_strdup(r->cur_subvol->path);
 		} else {
 			ret = -ENOENT;
 			fprintf(stderr, "ERROR: did not find source subvol.\n");
@@ -584,7 +584,7 @@ static int process_clone(const char *path, u64 offset, u64 len,
 						r->subvol_parent_name);
 			}
 		}*/
-		subvol_path = strdup(si->path);
+		subvol_path = btrfs_strdup(si->path);
 	}
 
 	full_clone_path = path_cat3(r->root_path, subvol_path, clone_path);
@@ -792,7 +792,7 @@ int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
 	int ret;
 	int end = 0;
 
-	r->root_path = strdup(tomnt);
+	r->root_path = btrfs_strdup(tomnt);
 	r->mnt_fd = open(tomnt, O_RDONLY | O_NOATIME);
 	if (r->mnt_fd < 0) {
 		ret = -errno;
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 24be20f..22112d7 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -510,8 +510,8 @@ again:
 			++curr;
 			p = realloc(p, (curr + 2) * sizeof(*p));
 			if (p)
-				p[curr] = malloc(sizeof(**p));
-			if (!p || !p[curr])
+				p[curr] = btrfs_malloc(sizeof(**p));
+			else
 				return ERR_PTR(-errno);
 			memset(p[curr], 0, sizeof(**p));
 			p[curr + 1] = NULL;
@@ -1026,7 +1026,7 @@ static int scrub_fs_info(char *path,
 		return 0;
 	}
 
-	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
+	di_args = *di_ret = btrfs_malloc(fi_args->num_devices * sizeof(*di_args));
 	if (!di_args) {
 		close(fd);
 		return -errno;
@@ -1108,7 +1108,7 @@ static int scrub_start(int argc, char **argv, int resume)
 	pthread_attr_t t_attr;
 	struct scrub_file_record **past_scrubs = NULL;
 	struct scrub_file_record *last_scrub = NULL;
-	char *datafile = strdup(SCRUB_DATA_FILE);
+	char *datafile = btrfs_strdup(SCRUB_DATA_FILE);
 	char fsid[37];
 	char sock_path[BTRFS_PATH_NAME_MAX + 1] = "";
 	struct scrub_progress_cycle spc;
@@ -1196,15 +1196,9 @@ static int scrub_start(int argc, char **argv, int resume)
 		close(fdres);
 	}
 
-	t_devs = malloc(fi_args.num_devices * sizeof(*t_devs));
-	sp = calloc(fi_args.num_devices, sizeof(*sp));
-	spc.progress = calloc(fi_args.num_devices * 2, sizeof(*spc.progress));
-
-	if (!t_devs || !sp || !spc.progress) {
-		ERR(!do_quiet, "ERROR: scrub failed: %s", strerror(errno));
-		err = 1;
-		goto out;
-	}
+	t_devs = btrfs_malloc(fi_args.num_devices * sizeof(*t_devs));
+	sp = btrfs_calloc(fi_args.num_devices, sizeof(*sp));
+	spc.progress = btrfs_calloc(fi_args.num_devices * 2, sizeof(*spc.progress));
 
 	ret = pthread_attr_init(&t_attr);
 	if (ret) {
diff --git a/cmds-send.c b/cmds-send.c
index 9b47e70..5885219 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -76,7 +76,7 @@ int find_mount_root(const char *path, char **mount_root)
 			if (longest_matchlen < len) {
 				free(longest_match);
 				longest_matchlen = len;
-				longest_match = strdup(ent->mnt_dir);
+				longest_match = btrfs_strdup(ent->mnt_dir);
 			}
 		}
 	}
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ac39f7b..9ff6481 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -106,9 +106,9 @@ static int cmd_subvol_create(int argc, char **argv)
 		return 12;
 	}
 
-	newname = strdup(dst);
+	newname = btrfs_strdup(dst);
 	newname = basename(newname);
-	dstdir = strdup(dst);
+	dstdir = btrfs_strdup(dst);
 	dstdir = dirname(dstdir);
 
 	if( !strcmp(newname,".") || !strcmp(newname,"..") ||
@@ -218,9 +218,9 @@ again:
 	}
 
 	cpath = realpath(path, 0);
-	dname = strdup(cpath);
+	dname = btrfs_strdup(cpath);
 	dname = dirname(dname);
-	vname = strdup(cpath);
+	vname = btrfs_strdup(cpath);
 	vname = basename(vname);
 	free(cpath);
 
@@ -485,13 +485,13 @@ static int cmd_snapshot(int argc, char **argv)
 	}
 
 	if(res>0){
-		newname = strdup(subvol);
+		newname = btrfs_strdup(subvol);
 		newname = basename(newname);
 		dstdir = dst;
 	}else{
-		newname = strdup(dst);
+		newname = btrfs_strdup(dst);
 		newname = basename(newname);
-		dstdir = strdup(dst);
+		dstdir = btrfs_strdup(dst);
 		dstdir = dirname(dstdir);
 	}
 
diff --git a/convert.c b/convert.c
index fa7bf8c..7639472 100644
--- a/convert.c
+++ b/convert.c
@@ -385,9 +385,7 @@ static int record_file_extent(struct btrfs_trans_handle *trans,
 		char *buffer;
 
 		ret = -ENOMEM;
-		buffer = malloc(blocksize);
-		if (!buffer)
-			goto fail;
+		buffer = btrfs_malloc(blocksize);
 		for (offset = 0; offset < num_bytes; offset += blocksize) {
 			ret = read_disk_extent(root, disk_bytenr + offset,
 						blocksize, buffer);
@@ -601,9 +599,7 @@ static int create_file_extents(struct btrfs_trans_handle *trans,
 		u64 disk_bytenr = data.disk_block * sectorsize;
 		u64 nbytes;
 
-		buffer = malloc(num_bytes);
-		if (!buffer)
-			return -ENOMEM;
+		buffer = btrfs_malloc(num_bytes);
 		ret = read_disk_extent(root, disk_bytenr, num_bytes, buffer);
 		if (ret)
 			goto fail;
@@ -848,9 +844,7 @@ static int copy_single_xattr(struct btrfs_trans_handle *trans,
 
 	if (name_index == 2 || name_index == 3) {
 		size_t bufsize = acl_ea_size(ext2_acl_count(datalen));
-		databuf = malloc(bufsize);
-		if (!databuf)
-		       return -ENOMEM;
+		databuf = btrfs_malloc(bufsize);
 		ret = ext2_acl_to_xattr(databuf, data, bufsize, datalen);
 		if (ret)
 			goto out;
@@ -893,9 +887,7 @@ static int copy_extended_attrs(struct btrfs_trans_handle *trans,
 	if (inode_size <= EXT2_GOOD_OLD_INODE_SIZE) {
 		ext2_inode = (struct ext2_inode_large *)inode_buf;
 	} else {
-		ext2_inode = (struct ext2_inode_large *)malloc(inode_size);
-		if (!ext2_inode)
-		       return -ENOMEM;
+		ext2_inode = (struct ext2_inode_large *)btrfs_malloc(inode_size);
 	}
 	err = ext2fs_read_inode_full(ext2_fs, ext2_ino, (void *)ext2_inode,
 				     inode_size);
@@ -945,11 +937,7 @@ static int copy_extended_attrs(struct btrfs_trans_handle *trans,
 	if (ext2_inode->i_file_acl == 0)
 		goto out;
 
-	buffer = malloc(block_size);
-	if (!buffer) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	buffer = btrfs_malloc(block_size);
 	err = ext2fs_read_ext_attr(ext2_fs, ext2_inode->i_file_acl, buffer);
 	if (err) {
 		fprintf(stderr, "ext2fs_read_ext_attr: %s\n",
@@ -1103,9 +1091,7 @@ static int copy_disk_extent(struct btrfs_root *root, u64 dst_bytenr,
 	char *buffer;
 	struct btrfs_fs_devices *fs_devs = root->fs_info->fs_devices;
 
-	buffer = malloc(num_bytes);
-	if (!buffer)
-		return -ENOMEM;
+	buffer = btrfs_malloc(num_bytes);
 	ret = pread(fs_devs->latest_bdev, buffer, num_bytes, src_bytenr);
 	if (ret != num_bytes)
 		goto fail;
@@ -1730,9 +1716,7 @@ static int migrate_super_block(int fd, u64 old_bytenr, u32 sectorsize)
 	u32 bytenr;
 
 	BUG_ON(sectorsize < sizeof(*super));
-	buf = malloc(sizeof(*buf) + sectorsize);
-	if (!buf)
-		return -ENOMEM;
+	buf = btrfs_malloc(sizeof(*buf) + sectorsize);
 
 	buf->len = sectorsize;
 	ret = pread(fd, buf->data, sectorsize, old_bytenr);
@@ -1810,9 +1794,7 @@ static int prepare_system_chunk(int fd, u64 sb_bytenr, u32 sectorsize)
 	struct btrfs_super_block *super;
 
 	BUG_ON(sectorsize < sizeof(*super));
-	buf = malloc(sizeof(*buf) + sectorsize);
-	if (!buf)
-		return -ENOMEM;
+	buf = btrfs_malloc(sizeof(*buf) + sectorsize);
 
 	buf->len = sectorsize;
 	ret = pread(fd, buf->data, sectorsize, sb_bytenr);
@@ -2498,11 +2480,7 @@ int do_rollback(const char *devname, int force)
 	}
 
 	sectorsize = root->sectorsize;
-	buf = malloc(sectorsize);
-	if (!buf) {
-		fprintf(stderr, "unable to allocate memory\n");
-		goto fail;
-	}
+	buf = btrfs_malloc(sectorsize);
 
 	btrfs_init_path(&path);
 
diff --git a/disk-io.c b/disk-io.c
index 0395205..e8de66a 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -79,9 +79,7 @@ int csum_tree_block_size(struct extent_buffer *buf, u16 csum_size,
 	u32 len;
 	u32 crc = ~(u32)0;
 
-	result = malloc(csum_size * sizeof(char));
-	if (!result)
-		return 1;
+	result = btrfs_malloc(csum_size * sizeof(char));
 
 	len = buf->len - BTRFS_CSUM_SIZE;
 	crc = crc32c(crc, buf->data + BTRFS_CSUM_SIZE, len);
@@ -456,7 +454,7 @@ static int find_and_setup_log_root(struct btrfs_root *tree_root,
 {
 	u32 blocksize;
 	u64 blocknr = btrfs_super_log_root(disk_super);
-	struct btrfs_root *log_root = malloc(sizeof(struct btrfs_root));
+	struct btrfs_root *log_root = btrfs_malloc(sizeof(struct btrfs_root));
 
 	if (blocknr == 0)
 		return 0;
@@ -518,9 +516,7 @@ struct btrfs_root *btrfs_read_fs_root_no_cache(struct btrfs_fs_info *fs_info,
 	u32 blocksize;
 	int ret = 0;
 
-	root = malloc(sizeof(*root));
-	if (!root)
-		return ERR_PTR(-ENOMEM);
+	root = btrfs_malloc(sizeof(*root));
 	memset(root, 0, sizeof(*root));
 	if (location->offset == (u64)-1) {
 		ret = find_and_setup_root(tree_root, fs_info,
@@ -617,12 +613,12 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	u32 stripesize;
 	u64 generation;
 	struct btrfs_key key;
-	struct btrfs_root *tree_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *extent_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *chunk_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *dev_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *csum_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_fs_info *fs_info = malloc(sizeof(*fs_info));
+	struct btrfs_root *tree_root = btrfs_malloc(sizeof(struct btrfs_root));
+	struct btrfs_root *extent_root = btrfs_malloc(sizeof(struct btrfs_root));
+	struct btrfs_root *chunk_root = btrfs_malloc(sizeof(struct btrfs_root));
+	struct btrfs_root *dev_root = btrfs_malloc(sizeof(struct btrfs_root));
+	struct btrfs_root *csum_root = btrfs_malloc(sizeof(struct btrfs_root));
+	struct btrfs_fs_info *fs_info = btrfs_malloc(sizeof(*fs_info));
 	int ret;
 	struct btrfs_super_block *disk_super;
 	struct btrfs_fs_devices *fs_devices = NULL;
diff --git a/extent-cache.c b/extent-cache.c
index 3dd6434..40d56a4 100644
--- a/extent-cache.c
+++ b/extent-cache.c
@@ -83,10 +83,8 @@ static struct rb_node *__tree_search(struct rb_root *root, u64 offset,
 
 struct cache_extent *alloc_cache_extent(u64 start, u64 size)
 {
-	struct cache_extent *pe = malloc(sizeof(*pe));
+	struct cache_extent *pe = btrfs_malloc(sizeof(*pe));
 
-	if (!pe)
-		return pe;
 	pe->start = start;
 	pe->size = size;
 	return pe;
diff --git a/extent_io.c b/extent_io.c
index ebb35b2..02e376a 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -43,9 +43,7 @@ static struct extent_state *alloc_extent_state(void)
 {
 	struct extent_state *state;
 
-	state = malloc(sizeof(*state));
-	if (!state)
-		return NULL;
+	state = btrfs_malloc(sizeof(*state));
 	state->refs = 1;
 	state->state = 0;
 	state->private = 0;
@@ -565,11 +563,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	struct extent_buffer *eb;
 	int ret;
 
-	eb = malloc(sizeof(struct extent_buffer) + blocksize);
-	if (!eb) {
-		BUG();
-		return NULL;
-	}
+	eb = btrfs_malloc(sizeof(struct extent_buffer) + blocksize);
 	memset(eb, 0, sizeof(struct extent_buffer) + blocksize);
 
 	eb->start = bytenr;
diff --git a/find-root.c b/find-root.c
index c0f38b8..5bb1bf8 100644
--- a/find-root.c
+++ b/find-root.c
@@ -50,11 +50,7 @@ int csum_block(void *buf, u32 len)
 	u32 crc = ~(u32)0;
 	int ret = 0;
 
-	result = malloc(csum_size * sizeof(char));
-	if (!result) {
-		fprintf(stderr, "No memory\n");
-		return 1;
-	}
+	result = btrfs_malloc(csum_size * sizeof(char));
 
 	len -= BTRFS_CSUM_SIZE;
 	crc = crc32c(crc, buf + BTRFS_CSUM_SIZE, len);
@@ -116,12 +112,12 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	u32 blocksize;
 	u32 stripesize;
 	u64 generation;
-	struct btrfs_root *tree_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *extent_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *chunk_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *dev_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *csum_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_fs_info *fs_info = malloc(sizeof(*fs_info));
+	struct btrfs_root *tree_root = btrfs_malloc(sizeof(struct btrfs_root));
+	struct btrfs_root *extent_root = btrfs_malloc(sizeof(struct btrfs_root));
+	struct btrfs_root *chunk_root = btrfs_malloc(sizeof(struct btrfs_root));
+	struct btrfs_root *dev_root = btrfs_malloc(sizeof(struct btrfs_root));
+	struct btrfs_root *csum_root = btrfs_malloc(sizeof(struct btrfs_root));
+	struct btrfs_fs_info *fs_info = btrfs_malloc(sizeof(*fs_info));
 	int ret;
 	struct btrfs_super_block *disk_super;
 	struct btrfs_fs_devices *fs_devices = NULL;
@@ -309,16 +305,11 @@ next:
 static int read_physical(struct btrfs_root *root, int fd, u64 offset,
 			 u64 bytenr, u64 len)
 {
-	char *iobuf = malloc(len);
+	char *iobuf = btrfs_malloc(len);
 	ssize_t done;
 	size_t total_read = 0;
 	int ret = 1;
 
-	if (!iobuf) {
-		fprintf(stderr, "No memory\n");
-		return -1;
-	}
-
 	while (total_read < len) {
 		done = pread64(fd, iobuf + total_read, len - total_read,
 			       bytenr + total_read);
diff --git a/kerncompat.h b/kerncompat.h
index 46236cd..1eeef73 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -25,6 +25,7 @@
 #include <endian.h>
 #include <byteswap.h>
 #include <assert.h>
+#include "utils-alloc.h"
 
 #ifndef READ
 #define READ 0
@@ -200,9 +201,9 @@ static inline long IS_ERR(const void *ptr)
 /*
  * kmalloc/kfree
  */
-#define kmalloc(x, y) malloc(x)
-#define kzalloc(x, y) calloc(1, x)
-#define kstrdup(x, y) strdup(x)
+#define kmalloc(x, y) btrfs_malloc(x)
+#define kzalloc(x, y) btrfs_calloc(1, x)
+#define kstrdup(x, y) btrfs_strdup(x)
 #define kfree(x) free(x)
 
 #define BUG_ON(c) assert(!(c))
diff --git a/mkfs.c b/mkfs.c
index 47f0c9c..261a6dc 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -61,7 +61,7 @@ static u64 parse_size(char *s)
 	u64 mult = 1;
 	u64 ret;
 
-	s = strdup(s);
+	s = btrfs_strdup(s);
 
 	if (len && !isdigit(s[len - 1])) {
 		c = tolower(s[len - 1]);
@@ -395,7 +395,7 @@ static char *parse_label(char *input)
 			exit(1);
 		}
 	}
-	return strdup(input);
+	return btrfs_strdup(input);
 }
 
 static struct option long_options[] = {
@@ -770,7 +770,7 @@ static int add_symbolic_link(struct btrfs_trans_handle *trans,
 {
 	int ret;
 	u64 sectorsize = root->sectorsize;
-	char *buf = malloc(sectorsize);
+	char *buf = btrfs_malloc(sectorsize);
 
 	ret = readlink(path_name, buf, sectorsize);
 	if (ret <= 0) {
@@ -819,7 +819,7 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 		blocks += 1;
 
 	if (st->st_size <= BTRFS_MAX_INLINE_DATA_SIZE(root)) {
-		buffer = malloc(st->st_size);
+		buffer = btrfs_malloc(st->st_size);
 		ret_read = pread64(fd, buffer, st->st_size, bytes_read);
 		if (ret_read == -1) {
 			fprintf(stderr, "%s read failed\n", path_name);
@@ -837,7 +837,7 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 
 	first_block = key.objectid;
 	bytes_read = 0;
-	buffer = malloc(sectorsize);
+	buffer = btrfs_malloc(sectorsize);
 
 	do {
 		memset(buffer, 0, sectorsize);
@@ -887,9 +887,7 @@ static char *make_path(char *dir, char *name)
 {
 	char *path;
 
-	path = malloc(strlen(dir) + strlen(name) + 2);
-	if (!path)
-		return NULL;
+	path = btrfs_malloc(strlen(dir) + strlen(name) + 2);
 	strcpy(path, dir);
 	if (dir[strlen(dir) - 1] != '/')
 		strcat(path, "/");
@@ -919,9 +917,9 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 	u64 root_dir_inode_size = 0;
 
 	/* Add list for source directory */
-	dir_entry = malloc(sizeof(struct directory_name_entry));
+	dir_entry = btrfs_malloc(sizeof(struct directory_name_entry));
 	dir_entry->dir_name = dir_name;
-	dir_entry->path = strdup(dir_name);
+	dir_entry->path = btrfs_strdup(dir_name);
 
 	parent_inum = highest_inum + BTRFS_FIRST_FREE_OBJECTID;
 	dir_entry->inum = parent_inum;
@@ -1008,7 +1006,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 			}
 
 			if (S_ISDIR(st.st_mode)) {
-				dir_entry = malloc(sizeof(struct directory_name_entry));
+				dir_entry = btrfs_malloc(sizeof(struct directory_name_entry));
 				dir_entry->dir_name = cur_file->d_name;
 				dir_entry->path = make_path(parent_dir_entry->path,
 							    cur_file->d_name);
@@ -1184,12 +1182,10 @@ static int zero_output_file(int out_fd, u64 size, u32 sectorsize)
 	int len = sectorsize;
 	int loop_num = size / sectorsize;
 	u64 location = 0;
-	char *buf = malloc(len);
+	char *buf = btrfs_malloc(len);
 	int ret = 0, i;
 	ssize_t written;
 
-	if (!buf)
-		return -ENOMEM;
 	memset(buf, 0, len);
 	for (i = 0; i < loop_num; i++) {
 		written = pwrite64(out_fd, buf, len, location);
diff --git a/qgroup.c b/qgroup.c
index 4083b57..5758f80 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -52,11 +52,7 @@ int qgroup_inherit_realloc(struct btrfs_qgroup_inherit **inherit, int n,
 			 (*inherit)->num_excl_copies;
 	}
 
-	out = calloc(sizeof(*out) + sizeof(out->qgroups[0]) * (nitems + n), 1);
-	if (out == NULL) {
-		fprintf(stderr, "ERROR: Not enough memory\n");
-		return 13;
-	}
+	out = btrfs_calloc(sizeof(*out) + sizeof(out->qgroups[0]) * (nitems + n), 1);
 
 	if (*inherit) {
 		struct btrfs_qgroup_inherit *i = *inherit;
diff --git a/quick-test.c b/quick-test.c
index fa6fd83..bfc6da8 100644
--- a/quick-test.c
+++ b/quick-test.c
@@ -46,7 +46,7 @@ int main(int ac, char **av) {
 	struct btrfs_root *root;
 	struct btrfs_trans_handle *trans;
 
-	buf = malloc(512);
+	buf = btrfs_malloc(512);
 	memset(buf, 0, 512);
 
 	radix_tree_init();
diff --git a/radix-tree.c b/radix-tree.c
index ed01810..2399550 100644
--- a/radix-tree.c
+++ b/radix-tree.c
@@ -89,11 +89,9 @@ static struct radix_tree_node *
 radix_tree_node_alloc(struct radix_tree_root *root)
 {
 	struct radix_tree_node *ret;
-	ret = malloc(sizeof(struct radix_tree_node));
-	if (ret) {
-		memset(ret, 0, sizeof(struct radix_tree_node));
-		internal_nodes++;
-	}
+	ret = btrfs_malloc(sizeof(struct radix_tree_node));
+	memset(ret, 0, sizeof(struct radix_tree_node));
+	internal_nodes++;
 	return ret;
 }
 
diff --git a/repair.c b/repair.c
index e640465..48b92b8 100644
--- a/repair.c
+++ b/repair.c
@@ -32,9 +32,7 @@ int btrfs_add_corrupt_extent_record(struct btrfs_fs_info *info,
 	if (!info->corrupt_blocks)
 		return 0;
 
-	corrupt = malloc(sizeof(*corrupt));
-	if (!corrupt)
-		return -ENOMEM;
+	corrupt = btrfs_malloc(sizeof(*corrupt));
 
 	memcpy(&corrupt->key, first_key, sizeof(*first_key));
 	corrupt->cache.start = start;
diff --git a/restore.c b/restore.c
index b9e5381..7d5ec90 100644
--- a/restore.c
+++ b/restore.c
@@ -156,11 +156,7 @@ static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
 	}
 
 	ram_size = btrfs_file_extent_ram_bytes(leaf, fi);
-	outbuf = malloc(ram_size);
-	if (!outbuf) {
-		fprintf(stderr, "No memory\n");
-		return -1;
-	}
+	outbuf = btrfs_malloc(ram_size);
 
 	ret = decompress(buf, outbuf, len, ram_size);
 	if (ret) {
@@ -208,19 +204,10 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	if (disk_size == 0)
 		return 0;
 
-	inbuf = malloc(disk_size);
-	if (!inbuf) {
-		fprintf(stderr, "No memory\n");
-		return -1;
-	}
+	inbuf = btrfs_malloc(disk_size);
 
 	if (compress != BTRFS_COMPRESS_NONE) {
-		outbuf = malloc(ram_size);
-		if (!outbuf) {
-			fprintf(stderr, "No memory\n");
-			free(inbuf);
-			return -1;
-		}
+		outbuf = btrfs_malloc(ram_size);
 	}
 again:
 	length = size_left;
@@ -592,13 +579,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 			}
 		} else if (type == BTRFS_FT_DIR) {
 			struct btrfs_root *search_root = root;
-			char *dir = strdup(path_name);
-
-			if (!dir) {
-				fprintf(stderr, "Ran out of memory\n");
-				btrfs_free_path(path);
-				return -1;
-			}
+			char *dir = btrfs_strdup(path_name);
 
 			if (location.type == BTRFS_ROOT_ITEM_KEY) {
 				/*
diff --git a/send-stream.c b/send-stream.c
index 55fa728..577154a 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -220,9 +220,7 @@ static int tlv_get_string(struct btrfs_send_stream *s, int attr, char **str)
 
 	TLV_GET(s, attr, &data, &len);
 
-	*str = malloc(len + 1);
-	if (!*str)
-		return -ENOMEM;
+	*str = btrfs_malloc(len + 1);
 
 	memcpy(*str, data, len);
 	(*str)[len] = 0;
diff --git a/send-utils.c b/send-utils.c
index fcde5c2..31fc878 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -247,7 +247,7 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 				path = btrfs_list_path_for_root(mnt_fd,
 								sh->objectid);
 				if (!path)
-					path = strdup("");
+					path = btrfs_strdup("");
 				if (IS_ERR(path)) {
 					ret = PTR_ERR(path);
 					fprintf(stderr, "ERROR: unable to "
@@ -257,7 +257,7 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 					goto out;
 				}
 
-				si = calloc(1, sizeof(*si));
+				si = btrfs_calloc(1, sizeof(*si));
 				si->root_id = sh->objectid;
 				memcpy(si->uuid, root_item.uuid,
 						BTRFS_UUID_SIZE);
@@ -309,7 +309,7 @@ char *path_cat(const char *p1, const char *p2)
 {
 	int p1_len = strlen(p1);
 	int p2_len = strlen(p2);
-	char *new = malloc(p1_len + p2_len + 3);
+	char *new = btrfs_malloc(p1_len + p2_len + 3);
 
 	if (p1_len && p1[p1_len - 1] == '/')
 		p1_len--;
@@ -325,7 +325,7 @@ char *path_cat3(const char *p1, const char *p2, const char *p3)
 	int p1_len = strlen(p1);
 	int p2_len = strlen(p2);
 	int p3_len = strlen(p3);
-	char *new = malloc(p1_len + p2_len + p3_len + 4);
+	char *new = btrfs_malloc(p1_len + p2_len + p3_len + 4);
 
 	if (p1_len && p1[p1_len - 1] == '/')
 		p1_len--;
diff --git a/transaction.h b/transaction.h
index a1070e0..3b7559d 100644
--- a/transaction.h
+++ b/transaction.h
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include "utils.h"
+
 #ifndef __TRANSACTION__
 #define __TRANSACTION__
 
@@ -32,7 +34,7 @@ static inline struct btrfs_trans_handle *
 btrfs_start_transaction(struct btrfs_root *root, int num_blocks)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_trans_handle *h = malloc(sizeof(*h));
+	struct btrfs_trans_handle *h = btrfs_malloc(sizeof(*h));
 
 	BUG_ON(root->commit_root);
 	BUG_ON(fs_info->running_transaction);
diff --git a/utils-alloc.h b/utils-alloc.h
new file mode 100644
index 0000000..0ae945a
--- /dev/null
+++ b/utils-alloc.h
@@ -0,0 +1,45 @@
+#ifndef __UTILS_ALLOC__
+#define __UTILS_ALLOC__
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+
+static void *btrfs_malloc(size_t size) __attribute__((unused));
+static void *btrfs_calloc(size_t nmemb, size_t size) __attribute__((unused));
+static char *btrfs_strdup(const char *s) __attribute__((unused));
+static char *btrfs_strndup(const char *s, size_t n) __attribute__((unused));
+
+static void *btrfs_malloc(size_t size)
+{
+        void *tmp = malloc(size);
+        if (!tmp)
+                abort();
+        return tmp;
+}
+
+static void *btrfs_calloc(size_t nmemb, size_t size)
+{
+        void *tmp = calloc(1, size);
+        if (!tmp)
+                abort();
+        return tmp;
+}
+
+static char *btrfs_strdup(const char *s)
+{
+        char *tmp = strdup(s);
+        if (!tmp)
+                abort();
+        return tmp;
+}
+
+static char *btrfs_strndup(const char *s, size_t n)
+{
+        char *tmp = strndup(s, n);
+        if (!tmp)
+                abort();
+        return tmp;
+}
+
+#endif /* __UTILS_ALLOC__ */
diff --git a/utils.c b/utils.c
index 205e667..981bdf1 100644
--- a/utils.c
+++ b/utils.c
@@ -125,7 +125,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	if (label)
 		strncpy(super.label, label, BTRFS_LABEL_SIZE - 1);
 
-	buf = malloc(sizeof(*buf) + max(sectorsize, leafsize));
+	buf = btrfs_malloc(sizeof(*buf) + max(sectorsize, leafsize));
 
 	/* create the tree of root objects */
 	memset(buf->data, 0, leafsize);
@@ -427,12 +427,10 @@ static u64 device_size(int fd, struct stat *st)
 
 static int zero_blocks(int fd, off_t start, size_t len)
 {
-	char *buf = malloc(len);
+	char *buf = btrfs_malloc(len);
 	int ret = 0;
 	ssize_t written;
 
-	if (!buf)
-		return -ENOMEM;
 	memset(buf, 0, len);
 	written = pwrite(fd, buf, len, start);
 	if (written != len)
@@ -962,21 +960,15 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
 
 	INIT_LIST_HEAD(&pending_list);
 
-	pending = malloc(sizeof(*pending));
-	if (!pending)
-		return -ENOMEM;
+	pending = btrfs_malloc(sizeof(*pending));
 	strcpy(pending->name, dirname);
 
 again:
 	dirname_len = strlen(pending->name);
 	pathlen = 1024;
-	fullpath = malloc(pathlen);
+	fullpath = btrfs_malloc(pathlen);
 	dirname = pending->name;
 
-	if (!fullpath) {
-		ret = -ENOMEM;
-		goto fail;
-	}
 	dirp = opendir(dirname);
 	if (!dirp) {
 		fprintf(stderr, "Unable to open %s for scanning\n", dirname);
@@ -1001,11 +993,7 @@ again:
 		if (S_ISLNK(st.st_mode))
 			continue;
 		if (S_ISDIR(st.st_mode)) {
-			struct pending_dir *next = malloc(sizeof(*next));
-			if (!next) {
-				ret = -ENOMEM;
-				goto fail;
-			}
+			struct pending_dir *next = btrfs_malloc(sizeof(*next));
 			strcpy(next->name, fullpath);
 			list_add_tail(&next->list, &pending_list);
 		}
@@ -1061,11 +1049,7 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 	char *buf;
 	int ret = 0;
 
-	buf = malloc(BTRFS_SUPER_INFO_SIZE);
-	if (!buf) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	buf = btrfs_malloc(BTRFS_SUPER_INFO_SIZE);
 	ret = pread(fd, buf, BTRFS_SUPER_INFO_SIZE, super_offset);
 	if (ret != BTRFS_SUPER_INFO_SIZE)
 		goto brelse;
@@ -1081,7 +1065,6 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 		ret = 1;
 brelse:
 	free(buf);
-out:
 	return ret;
 }
 
@@ -1110,7 +1093,7 @@ char *pretty_sizes(u64 size)
 			return NULL;
 		fraction = (float)last_size / 1024;
 	}
-	pretty = malloc(pretty_len);
+	pretty = btrfs_malloc(pretty_len);
 	snprintf(pretty, pretty_len, "%.2f%s", fraction, size_strs[num_divs]);
 	return pretty;
 }
@@ -1219,4 +1202,3 @@ scan_again:
 	}
 	return 0;
 }
-
diff --git a/utils.h b/utils.h
index 3a0368b..8f60a3e 100644
--- a/utils.h
+++ b/utils.h
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include "utils-alloc.h"
+
 #ifndef __UTILS__
 #define __UTILS__
 
diff --git a/volumes.c b/volumes.c
index 8dca5e1..86bcd8e 100644
--- a/volumes.c
+++ b/volumes.c
@@ -117,7 +117,7 @@ static int device_list_add(const char *path,
 		list_add(&device->dev_list, &fs_devices->devices);
 		device->fs_devices = fs_devices;
 	} else if (!device->name || strcmp(device->name, path)) {
-		char *name = strdup(path);
+		char *name = btrfs_strdup(path);
                 if (!name)
                         return -ENOMEM;
                 kfree(device->name);
@@ -200,11 +200,7 @@ int btrfs_scan_one_device(int fd, const char *path,
 	u64 devid;
 	char uuidbuf[37];
 
-	buf = malloc(4096);
-	if (!buf) {
-		ret = -ENOMEM;
-		goto error;
-	}
+	buf = btrfs_malloc(4096);
 	disk_super = (struct btrfs_super_block *)buf;
 	ret = btrfs_read_dev_super(fd, disk_super, super_offset);
 	if (ret < 0) {
@@ -222,7 +218,6 @@ int btrfs_scan_one_device(int fd, const char *path,
 
 error_brelse:
 	free(buf);
-error:
 	return ret;
 }
 
-- 
1.8.1.1

