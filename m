Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62491 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbcEZC46 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 22:56:58 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: noah.massey@gmail.com, dsterba@suse.cz, ahferroin7@gmail.com,
        hugo@carfax.org.uk
Subject: [PATCH 2/2] btrfs-progs: Use new random number API
Date: Thu, 26 May 2016 10:56:51 +0800
Message-Id: <1464231411-13261-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1464231411-13261-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1464231411-13261-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace old and not so informal srand()/rand() calls to new random
number API.

Including btrfs-corrupt-block(main user), btrfs-image and btrfs-crc.

Some tests like dir-test/random-test/quick-test is not modified.
As random-test itself can't even pass build.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-corrupt-block.c | 23 +++++++++++------------
 btrfs-crc.c           |  9 +++++----
 btrfs-image.c         |  4 ++--
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index d331f96..2cc9704 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -131,8 +131,8 @@ static void corrupt_keys(struct btrfs_trans_handle *trans,
 	if (nr == 0)
 		return;
 
-	slot = rand() % nr;
-	bad_slot = rand() % nr;
+	slot = rand_range(nr);
+	bad_slot = rand_range(nr);
 
 	if (bad_slot == slot)
 		return;
@@ -181,7 +181,7 @@ static int corrupt_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	int ret;
 	int slot;
-	int should_del = rand() % 3;
+	int should_del = rand_range(3);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -257,7 +257,7 @@ static void btrfs_corrupt_extent_leaf(struct btrfs_trans_handle *trans,
 				      struct extent_buffer *eb)
 {
 	u32 nr = btrfs_header_nritems(eb);
-	u32 victim = rand() % nr;
+	u32 victim = rand_range(nr);
 	u64 objectid;
 	struct btrfs_key key;
 
@@ -281,7 +281,7 @@ static void btrfs_corrupt_extent_tree(struct btrfs_trans_handle *trans,
 	}
 
 	if (btrfs_header_level(eb) == 1 && eb != root->node) {
-		if (rand() % 5)
+		if (rand_range(5))
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
+		del = rand_range(3);
 		/* Never delete the first item to keep the leaf structure */
 		if (path->slots[0] == 0)
 			del = 0;
@@ -971,7 +971,7 @@ static int corrupt_chunk_tree(struct btrfs_trans_handle *trans,
 	while (!btrfs_previous_item(root, path, 0, BTRFS_CHUNK_ITEM_KEY)) {
 		slot = path->slots[0];
 		leaf = path->nodes[0];
-		del = rand() % 3;
+		del = rand_range(3);
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
+		del = rand_range(3);
 		path = btrfs_alloc_path();
 		if (!path) {
 			fprintf(stderr, "path allocation failed\n");
diff --git a/btrfs-crc.c b/btrfs-crc.c
index 723e0b7..b50b951 100644
--- a/btrfs-crc.c
+++ b/btrfs-crc.c
@@ -40,7 +40,7 @@ int main(int argc, char **argv)
 	char *str;
 	char *buf;
 	int length = 10;
-	int seed = getpid() ^ getppid();
+	u64 seed = 0;
 	int loop = 0;
 	int i;
 
@@ -54,7 +54,7 @@ int main(int argc, char **argv)
 			loop = 1;
 			break;
 		case 's':
-			seed = atol(optarg);
+			seed = atoll(optarg);
 			break;
 		case 'h':
 			usage();
@@ -77,11 +77,12 @@ int main(int argc, char **argv)
 	buf = malloc(length);
 	if (!buf)
 		return -ENOMEM;
-	srand(seed);
+	if (seed)
+		rand_seed(seed);
 
 	while (1) {
 		for (i = 0; i < length; i++)
-			buf[i] = rand() % 94 + 33;
+			buf[i] = rand_range(94) + 33;
 		if (crc32c(~1, buf, length) == checksum)
 			printf("%12lu - %.*s\n", checksum, length, buf);
 	}
diff --git a/btrfs-image.c b/btrfs-image.c
index 8a1b799..9488913 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -188,7 +188,7 @@ static char *generate_garbage(u32 name_len)
 		return NULL;
 
 	for (i = 0; i < name_len; i++) {
-		char c = rand() % 94 + 33;
+		char c = rand_range(94) + 33;
 
 		if (c == '/')
 			c++;
@@ -392,7 +392,7 @@ static char *find_collision(struct metadump_struct *md, char *name,
 			"generating normal garbage, it won't match indexes\n",
 			val->len, val->val);
 		for (i = 0; i < name_len; i++) {
-			char c = rand() % 94 + 33;
+			char c = rand_range(94) + 33;
 
 			if (c == '/')
 				c++;
-- 
2.8.2



