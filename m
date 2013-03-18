Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:43998 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3CRSna (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 14:43:30 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 783757C0446
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 12:43:30 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id O09Sz7hGGIJGQ03I (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 12:43:29 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: cleanup error handling in btrfs-image
Date: Mon, 18 Mar 2013 14:50:45 -0400
Message-ID: <1363632645-5884-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We use BUG_ON() everywhere in btrfs-image.  When users are going to use this
command things are pretty dire, so I'd rather have really good error messages so
I know what happened rather than figure out which one of the 20 BUG_ON()'s made
the stupid thing exit early.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfs-image.c |  289 +++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 230 insertions(+), 59 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index e553e7e..ee9ab56 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -72,6 +72,7 @@ struct async_work {
 	u64 size;
 	u8 *buffer;
 	size_t bufsize;
+	int error;
 };
 
 struct metadump_struct {
@@ -111,6 +112,7 @@ struct mdrestore_struct {
 
 	int compress_method;
 	int done;
+	int error;
 };
 
 static void csum_block(u8 *buf, size_t len)
@@ -219,7 +221,9 @@ static void *dump_worker(void *data)
 			ret = compress2(async->buffer,
 					 (unsigned long *)&async->bufsize,
 					 orig, async->size, md->compress_level);
-			BUG_ON(ret != Z_OK);
+
+			if (ret != Z_OK)
+				async->error = 1;
 
 			free(orig);
 		}
@@ -261,8 +265,11 @@ static int metadump_init(struct metadump_struct *md, struct btrfs_root *root,
 	md->pending_start = (u64)-1;
 	md->compress_level = compress_level;
 	md->cluster = calloc(1, BLOCK_SIZE);
-	if (!md->cluster)
+	if (!md->cluster) {
+		pthread_cond_destroy(&md->cond);
+		pthread_mutex_destroy(&md->mutex);
 		return -ENOMEM;
+	}
 
 	meta_cluster_init(md, 0);
 	if (!num_threads)
@@ -270,13 +277,34 @@ static int metadump_init(struct metadump_struct *md, struct btrfs_root *root,
 
 	md->num_threads = num_threads;
 	md->threads = calloc(num_threads, sizeof(pthread_t));
-	if (!md->threads)
+	if (!md->threads) {
+		free(md->cluster);
+		pthread_cond_destroy(&md->cond);
+		pthread_mutex_destroy(&md->mutex);
 		return -ENOMEM;
+	}
+
 	for (i = 0; i < num_threads; i++) {
 		ret = pthread_create(md->threads + i, NULL, dump_worker, md);
 		if (ret)
 			break;
 	}
+
+	if (ret) {
+		pthread_mutex_lock(&md->mutex);
+		md->done = 1;
+		pthread_cond_broadcast(&md->cond);
+		pthread_mutex_unlock(&md->mutex);
+
+		for (i--; i >= 0; i--)
+			pthread_join(md->threads[i], NULL);
+
+		pthread_cond_destroy(&md->cond);
+		pthread_mutex_destroy(&md->mutex);
+		free(md->cluster);
+		free(md->threads);
+	}
+
 	return ret;
 }
 
@@ -311,6 +339,7 @@ static int write_buffers(struct metadump_struct *md, u64 *next)
 	u64 bytenr = 0;
 	u32 nritems = 0;
 	int ret;
+	int err = 0;
 
 	if (list_empty(&md->ordered))
 		goto out;
@@ -336,7 +365,10 @@ static int write_buffers(struct metadump_struct *md, u64 *next)
 	header->nritems = cpu_to_le32(nritems);
 
 	ret = fwrite(md->cluster, BLOCK_SIZE, 1, md->out);
-	BUG_ON(ret != 1);
+	if (ret != 1) {
+		fprintf(stderr, "Error writing out cluster: %d\n", errno);
+		return -EIO;
+	}
 
 	/* write buffers */
 	bytenr += le64_to_cpu(header->bytenr) + BLOCK_SIZE;
@@ -346,24 +378,35 @@ static int write_buffers(struct metadump_struct *md, u64 *next)
 		list_del_init(&async->ordered);
 
 		bytenr += async->bufsize;
-		ret = fwrite(async->buffer, async->bufsize, 1, md->out);
-		BUG_ON(ret != 1);
+		if (!err)
+			ret = fwrite(async->buffer, async->bufsize, 1,
+				     md->out);
+		if (ret != 1) {
+			err = -EIO;
+			ret = 0;
+			fprintf(stderr, "Error writing out cluster: %d\n",
+				errno);
+		}
 
 		free(async->buffer);
 		free(async);
 	}
 
 	/* zero unused space in the last block */
-	if (bytenr & BLOCK_MASK) {
+	if (!err && bytenr & BLOCK_MASK) {
 		size_t size = BLOCK_SIZE - (bytenr & BLOCK_MASK);
 
 		bytenr += size;
 		ret = write_zero(md->out, size);
-		BUG_ON(ret != 1);
+		if (ret != 1) {
+			fprintf(stderr, "Error zeroing out buffer: %d\n",
+				errno);
+			err = -EIO;
+		}
 	}
 out:
 	*next = bytenr;
-	return 0;
+	return err;
 }
 
 static int flush_pending(struct metadump_struct *md, int done)
@@ -374,7 +417,7 @@ static int flush_pending(struct metadump_struct *md, int done)
 	u64 start;
 	u64 size;
 	size_t offset;
-	int ret;
+	int ret = 0;
 
 	if (md->pending_size) {
 		async = calloc(1, sizeof(*async));
@@ -385,13 +428,22 @@ static int flush_pending(struct metadump_struct *md, int done)
 		async->size = md->pending_size;
 		async->bufsize = async->size;
 		async->buffer = malloc(async->bufsize);
-
+		if (!async->buffer) {
+			free(async);
+			return -ENOMEM;
+		}
 		offset = 0;
 		start = async->start;
 		size = async->size;
 		while (size > 0) {
 			eb = read_tree_block(md->root, start, blocksize, 0);
-			BUG_ON(!eb);
+			if (!eb) {
+				free(async->buffer);
+				free(async);
+				fprintf(stderr, "Error reading metadata "
+					"block\n");
+				return -EIO;
+			}
 			copy_buffer(async->buffer + offset, eb);
 			free_extent_buffer(eb);
 			start += blocksize;
@@ -418,11 +470,14 @@ static int flush_pending(struct metadump_struct *md, int done)
 	}
 	if (md->num_items >= ITEMS_PER_CLUSTER || done) {
 		ret = write_buffers(md, &start);
-		BUG_ON(ret);
-		meta_cluster_init(md, start);
+		if (ret)
+			fprintf(stderr, "Error writing buffers %d\n",
+				errno);
+		else
+			meta_cluster_init(md, start);
 	}
 	pthread_mutex_unlock(&md->mutex);
-	return 0;
+	return ret;
 }
 
 static int add_metadata(u64 start, u64 size, struct metadump_struct *md)
@@ -455,7 +510,8 @@ static int is_tree_block(struct btrfs_root *extent_root,
 		path->slots[0]++;
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(extent_root, path);
-			BUG_ON(ret < 0);
+			if (ret < 0)
+				return ret;
 			if (ret > 0)
 				break;
 			leaf = path->nodes[0];
@@ -481,7 +537,7 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 {
 	struct btrfs_root *root;
 	struct btrfs_root *extent_root;
-	struct btrfs_path *path;
+	struct btrfs_path *path = NULL;
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *ei;
 	struct btrfs_key key;
@@ -489,38 +545,60 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 	u64 bytenr;
 	u64 num_bytes;
 	int ret;
+	int err = 0;
 
 	root = open_ctree(input, 0, 0);
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
-		exit(1);
+		return -EIO;
 	}
 
 	BUG_ON(root->nodesize != root->leafsize);
 
 	ret = metadump_init(&metadump, root, out, num_threads,
 			    compress_level);
-	BUG_ON(ret);
+	if (ret) {
+		fprintf(stderr, "Error initing metadump %d\n", ret);
+		close_ctree(root);
+		return ret;
+	}
 
 	ret = add_metadata(BTRFS_SUPER_INFO_OFFSET, 4096, &metadump);
-	BUG_ON(ret);
+	if (ret) {
+		fprintf(stderr, "Error adding metadata %d\n", ret);
+		err = ret;
+		goto out;
+	}
 
 	extent_root = root->fs_info->extent_root;
 	path = btrfs_alloc_path();
-
+	if (!path) {
+		fprintf(stderr, "Out of memory allocing path\n");
+		err = -ENOMEM;
+		goto out;
+	}
 	bytenr = BTRFS_SUPER_INFO_OFFSET + 4096;
 	key.objectid = bytenr;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
 	key.offset = 0;
 
 	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
-	BUG_ON(ret < 0);
+	if (ret < 0) {
+		fprintf(stderr, "Error searching extent root %d\n", ret);
+		err = ret;
+		goto out;
+	}
 
 	while (1) {
 		leaf = path->nodes[0];
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(extent_root, path);
-			BUG_ON(ret < 0);
+			if (ret < 0) {
+				fprintf(stderr, "Error going to next leaf %d"
+					"\n", ret);
+				err = ret;
+				goto out;
+			}
 			if (ret > 0)
 				break;
 			leaf = path->nodes[0];
@@ -547,30 +625,56 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 			    BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 				ret = add_metadata(bytenr, num_bytes,
 						   &metadump);
-				BUG_ON(ret);
+				if (ret) {
+					fprintf(stderr, "Error adding block "
+						"%d\n", ret);
+					err = ret;
+					goto out;
+				}
 			}
 		} else {
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
-			if (is_tree_block(extent_root, path, bytenr)) {
+			ret = is_tree_block(extent_root, path, bytenr);
+			if (ret < 0) {
+				fprintf(stderr, "Error checking tree block "
+					"%d\n", ret);
+				err = ret;
+				goto out;
+			}
+
+			if (ret) {
 				ret = add_metadata(bytenr, num_bytes,
 						   &metadump);
-				BUG_ON(ret);
+				if (ret) {
+					fprintf(stderr, "Error adding block "
+						"%d\n", ret);
+					err = ret;
+					goto out;
+				}
 			}
 #else
-			BUG_ON(1);
+			fprintf(stderr, "Either extent tree corruption or "
+				"you haven't built with V0 support\n");
+			err = -EIO;
+			goto out;
 #endif
 		}
 		bytenr += num_bytes;
 	}
 
+out:
 	ret = flush_pending(&metadump, 1);
-	BUG_ON(ret);
+	if (ret) {
+		if (!err)
+			ret = err;
+		fprintf(stderr, "Error flushing pending %d\n", ret);
+	}
 
 	metadump_destroy(&metadump);
 
 	btrfs_free_path(path);
 	ret = close_ctree(root);
-	return 0;
+	return err ? err : ret;
 }
 
 static void update_super(u8 *buffer)
@@ -620,9 +724,18 @@ static void *restore_worker(void *data)
 
 	outfd = fileno(mdres->out);
 	buffer = malloc(MAX_PENDING_SIZE * 2);
-	BUG_ON(!buffer);
+	if (!buffer) {
+		fprintf(stderr, "Error allocing buffer\n");
+		pthread_mutex_lock(&mdres->mutex);
+		if (!mdres->error)
+			mdres->error = -ENOMEM;
+		pthread_mutex_unlock(&mdres->mutex);
+		goto out;
+	}
 
 	while (1) {
+		int err = 0;
+
 		pthread_mutex_lock(&mdres->mutex);
 		while (list_empty(&mdres->list)) {
 			if (mdres->done) {
@@ -639,7 +752,11 @@ static void *restore_worker(void *data)
 			size = MAX_PENDING_SIZE * 2;
 			ret = uncompress(buffer, (unsigned long *)&size,
 					 async->buffer, async->bufsize);
-			BUG_ON(ret != Z_OK);
+			if (ret != Z_OK) {
+				fprintf(stderr, "Error decompressing %d\n",
+					ret);
+				err = -EIO;
+			}
 			outbuf = buffer;
 		} else {
 			outbuf = async->buffer;
@@ -650,9 +767,20 @@ static void *restore_worker(void *data)
 			update_super(outbuf);
 
 		ret = pwrite64(outfd, outbuf, size, async->start);
-		BUG_ON(ret != size);
+		if (ret < size) {
+			if (ret < 0) {
+				fprintf(stderr, "Error writing to device %d\n",
+					errno);
+				err = errno;
+			} else {
+				fprintf(stderr, "Short write\n");
+				err = -EIO;
+			}
+		}
 
 		pthread_mutex_lock(&mdres->mutex);
+		if (err && !mdres->error)
+			mdres->error = err;
 		mdres->num_items--;
 		pthread_mutex_unlock(&mdres->mutex);
 
@@ -664,6 +792,22 @@ out:
 	pthread_exit(NULL);
 }
 
+static void mdrestore_destroy(struct mdrestore_struct *mdres)
+{
+	int i;
+	pthread_mutex_lock(&mdres->mutex);
+	mdres->done = 1;
+	pthread_cond_broadcast(&mdres->cond);
+	pthread_mutex_unlock(&mdres->mutex);
+
+	for (i = 0; i < mdres->num_threads; i++)
+		pthread_join(mdres->threads[i], NULL);
+
+	pthread_cond_destroy(&mdres->cond);
+	pthread_mutex_destroy(&mdres->mutex);
+	free(mdres->threads);
+}
+
 static int mdrestore_init(struct mdrestore_struct *mdres,
 			  FILE *in, FILE *out, int num_threads)
 {
@@ -689,25 +833,11 @@ static int mdrestore_init(struct mdrestore_struct *mdres,
 		if (ret)
 			break;
 	}
+	if (ret)
+		mdrestore_destroy(mdres);
 	return ret;
 }
 
-static void mdrestore_destroy(struct mdrestore_struct *mdres)
-{
-	int i;
-	pthread_mutex_lock(&mdres->mutex);
-	mdres->done = 1;
-	pthread_cond_broadcast(&mdres->cond);
-	pthread_mutex_unlock(&mdres->mutex);
-
-	for (i = 0; i < mdres->num_threads; i++)
-		pthread_join(mdres->threads[i], NULL);
-
-	pthread_cond_destroy(&mdres->cond);
-	pthread_mutex_destroy(&mdres->mutex);
-	free(mdres->threads);
-}
-
 static int add_cluster(struct meta_cluster *cluster,
 		       struct mdrestore_struct *mdres, u64 *next)
 {
@@ -726,11 +856,25 @@ static int add_cluster(struct meta_cluster *cluster,
 	for (i = 0; i < nritems; i++) {
 		item = &cluster->items[i];
 		async = calloc(1, sizeof(*async));
+		if (!async) {
+			fprintf(stderr, "Error allocating async\n");
+			return -ENOMEM;
+		}
 		async->start = le64_to_cpu(item->bytenr);
 		async->bufsize = le32_to_cpu(item->size);
 		async->buffer = malloc(async->bufsize);
+		if (!async->buffer) {
+			fprintf(stderr, "Error allocing async buffer\n");
+			free(async);
+			return -ENOMEM;
+		}
 		ret = fread(async->buffer, async->bufsize, 1, mdres->in);
-		BUG_ON(ret != 1);
+		if (ret != 1) {
+			fprintf(stderr, "Error reading buffer %d\n", errno);
+			free(async->buffer);
+			free(async);
+			return -EIO;
+		}
 		bytenr += async->bufsize;
 
 		pthread_mutex_lock(&mdres->mutex);
@@ -745,7 +889,10 @@ static int add_cluster(struct meta_cluster *cluster,
 
 		bytenr += size;
 		ret = fread(buffer, size, 1, mdres->in);
-		BUG_ON(ret != 1);
+		if (ret != 1) {
+			fprintf(stderr, "Error reading in buffer %d\n", errno);
+			return -EIO;
+		}
 	}
 	*next = bytenr;
 	return 0;
@@ -753,8 +900,11 @@ static int add_cluster(struct meta_cluster *cluster,
 
 static int wait_for_worker(struct mdrestore_struct *mdres)
 {
+	int ret = 0;
+
 	pthread_mutex_lock(&mdres->mutex);
-	while (mdres->num_items > 0) {
+	ret = mdres->error;
+	while (!ret && mdres->num_items > 0) {
 		struct timespec ts = {
 			.tv_sec = 0,
 			.tv_nsec = 10000000,
@@ -762,9 +912,10 @@ static int wait_for_worker(struct mdrestore_struct *mdres)
 		pthread_mutex_unlock(&mdres->mutex);
 		nanosleep(&ts, NULL);
 		pthread_mutex_lock(&mdres->mutex);
+		ret = mdres->error;
 	}
 	pthread_mutex_unlock(&mdres->mutex);
-	return 0;
+	return ret;
 }
 
 static int restore_metadump(const char *input, FILE *out, int num_threads)
@@ -774,7 +925,7 @@ static int restore_metadump(const char *input, FILE *out, int num_threads)
 	struct mdrestore_struct mdrestore;
 	u64 bytenr = 0;
 	FILE *in;
-	int ret;
+	int ret = 0;
 
 	if (!strcmp(input, "-")) {
 		in = stdin;
@@ -787,10 +938,21 @@ static int restore_metadump(const char *input, FILE *out, int num_threads)
 	}
 
 	cluster = malloc(BLOCK_SIZE);
-	BUG_ON(!cluster);
+	if (!cluster) {
+		fprintf(stderr, "Error allocating cluster\n");
+		if (in != stdin)
+			fclose(in);
+		return -ENOMEM;
+	}
 
 	ret = mdrestore_init(&mdrestore, in, out, num_threads);
-	BUG_ON(ret);
+	if (ret) {
+		fprintf(stderr, "Error initing mdrestore %d\n", ret);
+		if (in != stdin)
+			fclose(in);
+		free(cluster);
+		return ret;
+	}
 
 	while (1) {
 		ret = fread(cluster, BLOCK_SIZE, 1, in);
@@ -801,12 +963,21 @@ static int restore_metadump(const char *input, FILE *out, int num_threads)
 		if (le64_to_cpu(header->magic) != HEADER_MAGIC ||
 		    le64_to_cpu(header->bytenr) != bytenr) {
 			fprintf(stderr, "bad header in metadump image\n");
-			return 1;
+			ret = -EIO;
+			break;
 		}
 		ret = add_cluster(cluster, &mdrestore, &bytenr);
-		BUG_ON(ret);
+		if (ret) {
+			fprintf(stderr, "Error adding cluster\n");
+			break;
+		}
 
-		wait_for_worker(&mdrestore);
+		ret = wait_for_worker(&mdrestore);
+		if (ret) {
+			fprintf(stderr, "One of the threads errored out %d\n",
+				ret);
+			break;
+		}
 	}
 
 	mdrestore_destroy(&mdrestore);
@@ -891,5 +1062,5 @@ int main(int argc, char *argv[])
 	else
 		fclose(out);
 
-	exit(ret);
+	return ret;
 }
-- 
1.7.7.6

