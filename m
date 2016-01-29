Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8403 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbcA2FNk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 00:13:40 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>
Subject: [PATCH v3 04/22] btrfs-progs: utils: Introduce new function for convert
Date: Fri, 29 Jan 2016 13:03:14 +0800
Message-Id: <1454043812-7893-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function make_convert_btrfs() for convert.

This new function will have the following features:
1) Alloc temporary sb/metadata/system chunk, avoiding old used data
2) More structurizd functions
   No more over 1000 lines function, better function split and code
   reuse

This will finally replace current make_btrfs(), but now only used for
convert.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 btrfs-convert.c | 24 +--------------
 mkfs.c          |  2 +-
 utils.c         | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 utils.h         | 26 ++++++++++++++++-
 4 files changed, 117 insertions(+), 26 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 8026907..1573e41 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -96,28 +96,6 @@ struct btrfs_convert_operations {
 	void (*close_fs)(struct btrfs_convert_context *cctx);
 };
 
-struct btrfs_convert_context {
-	u32 blocksize;
-	u32 first_data_block;
-	u32 block_count;
-	u32 inodes_count;
-	u32 free_inodes_count;
-	u64 total_bytes;
-	char *volume_name;
-	const struct btrfs_convert_operations *convert_ops;
-
-	/* The accurate used space of old filesystem */
-	struct cache_tree used;
-
-	/* Batched ranges which must be covered by data chunks */
-	struct cache_tree data_chunks;
-
-	/* Free space which is not covered by data_chunks */
-	struct cache_tree free;
-
-	void *fs_data;
-};
-
 static void init_convert_context(struct btrfs_convert_context *cctx)
 {
 	cache_tree_init(&cctx->used);
@@ -2807,7 +2785,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 	mkfs_cfg.stripesize = blocksize;
 	mkfs_cfg.features = features;
 
-	ret = make_btrfs(fd, &mkfs_cfg);
+	ret = make_btrfs(fd, &mkfs_cfg, NULL);
 	if (ret) {
 		fprintf(stderr, "unable to create initial ctree: %s\n",
 			strerror(-ret));
diff --git a/mkfs.c b/mkfs.c
index ea58404..5b77324 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1675,7 +1675,7 @@ int main(int ac, char **av)
 	mkfs_cfg.stripesize = stripesize;
 	mkfs_cfg.features = features;
 
-	ret = make_btrfs(fd, &mkfs_cfg);
+	ret = make_btrfs(fd, &mkfs_cfg, NULL);
 	if (ret) {
 		fprintf(stderr, "error during mkfs: %s\n", strerror(-ret));
 		exit(1);
diff --git a/utils.c b/utils.c
index 3df8b42..bc10293 100644
--- a/utils.c
+++ b/utils.c
@@ -179,9 +179,96 @@ int test_uuid_unique(char *fs_uuid)
 }
 
 /*
+ * Reserve space from free_tree.
+ * The algorithm is very simple, find the first cache_extent with enough space
+ * and allocate from its beginning.
+ */
+static int reserve_free_space(struct cache_tree *free_tree, u64 len,
+			      u64 *ret_start)
+{
+	struct cache_extent *cache;
+	int found = 0;
+
+	BUG_ON(!ret_start);
+	cache = first_cache_extent(free_tree);
+	while (cache) {
+		if (cache->size > len) {
+			found = 1;
+			*ret_start = cache->start;
+
+			cache->size -= len;
+			if (cache->size == 0) {
+				remove_cache_extent(free_tree, cache);
+				free(cache);
+			} else {
+				cache->start += len;
+			}
+			break;
+		}
+		cache = next_cache_extent(cache);
+	}
+	if (!found)
+		return -ENOSPC;
+	return 0;
+}
+
+/*
+ * Improved version of make_btrfs().
+ *
+ * This one will
+ * 1) Do chunk allocation to avoid used data
+ *    And after this function, extent type matches chunk type
+ * 2) Better structurized code
+ *    No super long hand written codes to initialized all tree blocks
+ *    Split into small blocks and reuse codes.
+ *    TODO: Reuse tree operation facilities by introducing new flags
+ */
+static int make_convert_btrfs(int fd, struct btrfs_mkfs_config *cfg,
+			      struct btrfs_convert_context *cctx)
+{
+	struct cache_tree *free = &cctx->free;
+	struct cache_tree *used = &cctx->used;
+	u64 sys_chunk_start;
+	u64 meta_chunk_start;
+	int ret;
+
+	/* Shouldn't happen */
+	BUG_ON(cache_tree_empty(used));
+
+	/*
+	 * reserve space for temporary superblock first
+	 * Here we allocate a little larger space, to keep later
+	 * free space will be STRIPE_LEN aligned
+	 */
+	ret = reserve_free_space(free, BTRFS_STRIPE_LEN,
+				 &cfg->super_bytenr);
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * Then reserve system chunk space
+	 * TODO: Change system group size depending on cctx->total_bytes.
+	 * If using current 4M, it can only handle less than one TB for
+	 * worst case and then run out of sys space.
+	 */
+	ret = reserve_free_space(free, BTRFS_MKFS_SYSTEM_GROUP_SIZE,
+				 &sys_chunk_start);
+	if (ret < 0)
+		goto out;
+	ret = reserve_free_space(free, BTRFS_CONVERT_META_GROUP_SIZE,
+				 &meta_chunk_start);
+	if (ret < 0)
+		goto out;
+
+out:
+	return ret;
+}
+
+/*
  * @fs_uuid - if NULL, generates a UUID, returns back the new filesystem UUID
  */
-int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
+int make_btrfs(int fd, struct btrfs_mkfs_config *cfg,
+		struct btrfs_convert_context *cctx)
 {
 	struct btrfs_super_block super;
 	struct extent_buffer *buf;
@@ -206,6 +293,8 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 				 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 	u64 num_bytes;
 
+	if (cctx)
+		return make_convert_btrfs(fd, cfg, cctx);
 	buf = malloc(sizeof(*buf) + max(cfg->sectorsize, cfg->nodesize));
 	if (!buf)
 		return -ENOMEM;
diff --git a/utils.h b/utils.h
index d53357a..feccebd 100644
--- a/utils.h
+++ b/utils.h
@@ -43,6 +43,7 @@
 	| BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF			\
 	| BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA		\
 	| BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+#define BTRFS_CONVERT_META_GROUP_SIZE (32 * 1024 * 1024)
 
 #define BTRFS_FEATURE_LIST_ALL		(1ULL << 63)
 
@@ -121,7 +122,30 @@ struct btrfs_mkfs_config {
 	u64 super_bytenr;
 };
 
-int make_btrfs(int fd, struct btrfs_mkfs_config *cfg);
+struct btrfs_convert_context {
+	u32 blocksize;
+	u32 first_data_block;
+	u32 block_count;
+	u32 inodes_count;
+	u32 free_inodes_count;
+	u64 total_bytes;
+	char *volume_name;
+	const struct btrfs_convert_operations *convert_ops;
+
+	/* The accurate used space of old filesystem */
+	struct cache_tree used;
+
+	/* Batched ranges which must be covered by data chunks */
+	struct cache_tree data_chunks;
+
+	/* Free space which is not covered by data_chunks */
+	struct cache_tree free;
+
+	void *fs_data;
+};
+
+int make_btrfs(int fd, struct btrfs_mkfs_config *cfg,
+		struct btrfs_convert_context *cctx);
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);
 int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
-- 
2.7.0



