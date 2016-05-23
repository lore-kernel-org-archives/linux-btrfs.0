Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56191 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbcEWDLF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 May 2016 23:11:05 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: utils: use better wrappered random generator
Date: Mon, 23 May 2016 11:10:49 +0800
Message-Id: <1463973049-3480-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs was using normal srand()/rand() pseudo-random number generator
functions.

Although it's mostly fine, but it's quite easy to forget to initialize
the seed.

This patch will introduce new random number generator wrappers:
rand_int(), rand_u8/16/32/64(), and use uniformly distributed
pseudo-random number generator as backend.

The new wrappers will always set new seed based on time and pid/ppid to
avoid manually setting for seed.

Suggested-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-corrupt-block.c | 23 +++++++++++------------
 btrfs-image.c         |  4 ++--
 dir-test.c            |  8 ++++----
 quick-test.c          |  7 +------
 utils.c               | 20 ++++++++++++++++++++
 utils.h               | 26 ++++++++++++++++++++++++++
 6 files changed, 64 insertions(+), 24 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index d331f96..c7c4490 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -131,8 +131,8 @@ static void corrupt_keys(struct btrfs_trans_handle *trans,
 	if (nr == 0)
 		return;
 
-	slot = rand() % nr;
-	bad_slot = rand() % nr;
+	slot = rand_int() % nr;
+	bad_slot = rand_int() % nr;
 
 	if (bad_slot == slot)
 		return;
@@ -181,7 +181,7 @@ static int corrupt_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	int ret;
 	int slot;
-	int should_del = rand() % 3;
+	int should_del = rand_int() % 3;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -257,7 +257,7 @@ static void btrfs_corrupt_extent_leaf(struct btrfs_trans_handle *trans,
 				      struct extent_buffer *eb)
 {
 	u32 nr = btrfs_header_nritems(eb);
-	u32 victim = rand() % nr;
+	u32 victim = rand_u32() % nr;
 	u64 objectid;
 	struct btrfs_key key;
 
@@ -281,7 +281,7 @@ static void btrfs_corrupt_extent_tree(struct btrfs_trans_handle *trans,
 	}
 
 	if (btrfs_header_level(eb) == 1 && eb != root->node) {
-		if (rand() % 5)
+		if (rand_int() % 5)
 			return;
 	}
 
@@ -390,7 +390,7 @@ static u64 generate_u64(u64 orig)
 {
 	u64 ret;
 	do {
-		ret = rand();
+		ret = rand_u64();
 	} while (ret == orig);
 	return ret;
 }
@@ -399,7 +399,7 @@ static u32 generate_u32(u32 orig)
 {
 	u32 ret;
 	do {
-		ret = rand();
+		ret = rand_u32();
 	} while (ret == orig);
 	return ret;
 }
@@ -408,7 +408,7 @@ static u8 generate_u8(u8 orig)
 {
 	u8 ret;
 	do {
-		ret = rand();
+		ret = rand_u8();
 	} while (ret == orig);
 	return ret;
 }
@@ -944,7 +944,7 @@ static int corrupt_chunk_tree(struct btrfs_trans_handle *trans,
 	while (!btrfs_previous_item(root, path, 0, BTRFS_DEV_ITEM_KEY)) {
 		slot = path->slots[0];
 		leaf = path->nodes[0];
-		del = rand() % 3;
+		del = rand_int() % 3;
 		/* Never delete the first item to keep the leaf structure */
 		if (path->slots[0] == 0)
 			del = 0;
@@ -971,7 +971,7 @@ static int corrupt_chunk_tree(struct btrfs_trans_handle *trans,
 	while (!btrfs_previous_item(root, path, 0, BTRFS_CHUNK_ITEM_KEY)) {
 		slot = path->slots[0];
 		leaf = path->nodes[0];
-		del = rand() % 3;
+		del = rand_int() % 3;
 		btrfs_item_key_to_cpu(leaf, &found_key, slot);
 		ret = corrupt_item_nocow(trans, root, path, del);
 		if (ret)
@@ -1040,7 +1040,6 @@ int main(int argc, char **argv)
 	char field[FIELD_BUF_LEN];
 
 	field[0] = '\0';
-	srand(128);
 	memset(&key, 0, sizeof(key));
 
 	while(1) {
@@ -1179,7 +1178,7 @@ int main(int argc, char **argv)
 
 		if (logical == (u64)-1)
 			print_usage(1);
-		del = rand() % 3;
+		del = rand_int() % 3;
 		path = btrfs_alloc_path();
 		if (!path) {
 			fprintf(stderr, "path allocation failed\n");
diff --git a/btrfs-image.c b/btrfs-image.c
index 8a1b799..42e3781 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -188,7 +188,7 @@ static char *generate_garbage(u32 name_len)
 		return NULL;
 
 	for (i = 0; i < name_len; i++) {
-		char c = rand() % 94 + 33;
+		char c = rand_int() % 94 + 33;
 
 		if (c == '/')
 			c++;
@@ -392,7 +392,7 @@ static char *find_collision(struct metadump_struct *md, char *name,
 			"generating normal garbage, it won't match indexes\n",
 			val->len, val->val);
 		for (i = 0; i < name_len; i++) {
-			char c = rand() % 94 + 33;
+			char c = rand_int() % 94 + 33;
 
 			if (c == '/')
 				c++;
diff --git a/dir-test.c b/dir-test.c
index a54b777..ae37b66 100644
--- a/dir-test.c
+++ b/dir-test.c
@@ -38,7 +38,7 @@ static u64 file_oid = 33778;
 static int find_num(struct radix_tree_root *root, unsigned long *num_ret,
 		     int exists)
 {
-	unsigned long num = rand();
+	unsigned long num = rand_u32();
 	unsigned long res[2];
 	int ret;
 
@@ -384,7 +384,7 @@ static int bulk_op(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct radix_tree_root *radix)
 {
 	int ret;
-	int nr = rand() % 5000;
+	int nr = rand_int() % 5000;
 	static int run_nr = 0;
 
 	/* do the bulk op much less frequently */
@@ -473,8 +473,8 @@ int main(int ac, char **av)
 		goto out;
 	}
 	for (i = 0; i < iterations; i++) {
-		op = rand() % ARRAY_SIZE(ops);
-		count = rand() % 128;
+		op = rand_int() % ARRAY_SIZE(ops);
+		count = rand_int() % 128;
 		if (i % 2000 == 0) {
 			printf("%d\n", i);
 			fflush(stdout);
diff --git a/quick-test.c b/quick-test.c
index ffde85d..b6dec5a 100644
--- a/quick-test.c
+++ b/quick-test.c
@@ -28,7 +28,7 @@
 
 /* for testing only */
 static int next_key(int i, int max_key) {
-	return rand() % max_key;
+	return rand_int() % max_key;
 	// return i;
 }
 
@@ -56,7 +56,6 @@ int main(int ac, char **av) {
 		exit(1);
 	}
 	trans = btrfs_start_transaction(root, 1);
-	srand(55);
 	btrfs_set_key_type(&ins, BTRFS_STRING_ITEM_KEY);
 	for (i = 0; i < run_size; i++) {
 		num = next_key(i, max_key);
@@ -83,7 +82,6 @@ int main(int ac, char **av) {
 		exit(1);
 	}
 	printf("starting search\n");
-	srand(55);
 	for (i = 0; i < run_size; i++) {
 		num = next_key(i, max_key);
 		ins.objectid = num;
@@ -112,7 +110,6 @@ int main(int ac, char **av) {
 		btrfs_header_nritems(root->node));
 	printf("all searches good, deleting some items\n");
 	i = 0;
-	srand(55);
 	trans = btrfs_start_transaction(root, 1);
 	for (i = 0 ; i < run_size/4; i++) {
 		num = next_key(i, max_key);
@@ -138,7 +135,6 @@ int main(int ac, char **av) {
 		exit(1);
 	}
 	trans = btrfs_start_transaction(root, 1);
-	srand(128);
 	for (i = 0; i < run_size; i++) {
 		num = next_key(i, max_key);
 		sprintf(buf, "string-%d", num);
@@ -157,7 +153,6 @@ int main(int ac, char **av) {
 		fprintf(stderr, "Open ctree failed\n");
 		exit(1);
 	}
-	srand(128);
 	printf("starting search2\n");
 	for (i = 0; i < run_size; i++) {
 		num = next_key(i, max_key);
diff --git a/utils.c b/utils.c
index 68a5af4..805fa48 100644
--- a/utils.c
+++ b/utils.c
@@ -4064,3 +4064,23 @@ out:
 
 	return ret;
 }
+
+u32 rand_u32(void)
+{
+	struct timeval tv;
+	unsigned short rand_seed[3];
+	long int ret;
+	int i;
+
+	gettimeofday(&tv, 0);
+	rand_seed[0] = getpid() ^ (tv.tv_sec & 0xFFFF);
+	rand_seed[1] = getppid() ^ (tv.tv_usec & 0xFFFF);
+	rand_seed[2] = (tv.tv_sec ^ tv.tv_usec) >> 16;
+
+	/* Crank the random number generator a few times */
+	gettimeofday(&tv, 0);
+	for (i = (tv.tv_sec ^ tv.tv_sec) ^ 0x1F; i > 0; i--)
+		nrand48(rand_seed);
+	ret = nrand48(rand_seed);
+	return (u32)ret;
+}
diff --git a/utils.h b/utils.h
index ebe6d61..6a00871 100644
--- a/utils.h
+++ b/utils.h
@@ -362,4 +362,30 @@ static inline int error_on(int condition, const char *fmt, ...)
 	return 1;
 }
 
+/*
+ * Random number generator wrappers
+ * Caller has no need to set seed, as all function will set seed based on
+ * pid/ppid and current time
+ */
+u32 rand_u32(void);
+static inline int rand_int(void)
+{
+	return (int)(rand_u32());
+}
+static inline u8 rand_u8(void)
+{
+	return (u8)(rand_u32());
+}
+static inline u16 rand_u16(void)
+{
+	return (u16)(rand_u32());
+}
+static inline u64 rand_u64(void)
+{
+	u64 ret = 0;
+	ret += rand_u32();
+	ret = ret << 32;
+	ret += rand_u32();
+	return ret;
+}
 #endif
-- 
2.8.2



