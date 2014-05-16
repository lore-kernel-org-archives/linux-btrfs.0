Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29891 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751298AbaEPB2X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 21:28:23 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4G1SKSB009229
	for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 09:28:20 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: add sys_chunk_array and backup roots info to show-super
Date: Fri, 16 May 2014 09:23:37 +0800
Message-ID: <1400203417-22875-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add sys chunk array and backup roots info if the new option '-f'
if specified.
This may be useful for debugging sys_chunk related issues.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
Changelog:
	v1->v2: add malloc failure check
---
 btrfs-show-super.c | 142 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 print-tree.c       |   2 +-
 print-tree.h       |   2 +
 3 files changed, 132 insertions(+), 14 deletions(-)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index d4df0ac..c2ad332 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -38,18 +38,18 @@
 #include "crc32c.h"
 
 static void print_usage(void);
-static void dump_superblock(struct btrfs_super_block *sb);
+static void dump_superblock(struct btrfs_super_block *sb, int full);
 int main(int argc, char **argv);
-static int load_and_dump_sb(char *, int fd, u64 sb_bytenr);
+static int load_and_dump_sb(char *, int fd, u64 sb_bytenr, int full);
 
 
 static void print_usage(void)
 {
 	fprintf(stderr,
-		"usage: btrfs-show-super [-i super_mirror|-a] dev [dev..]\n");
-	fprintf(stderr, "\tThe super_mirror number is between 0 and %d.\n",
-		BTRFS_SUPER_MIRROR_MAX - 1);
-	fprintf(stderr, "\tIf -a is passed all the superblocks are showed.\n");
+		"usage: btrfs-show-super [-i super_mirror|-a|-f] dev [dev..]\n");
+	fprintf(stderr, "\t-f : print full superblock information\n");
+	fprintf(stderr, "\t-a : print information of all superblocks\n");
+	fprintf(stderr, "\t-i <super_mirror> : specify which mirror to print out\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 }
 
@@ -57,13 +57,14 @@ int main(int argc, char **argv)
 {
 	int opt;
 	int all = 0;
+	int full = 0;
 	char *filename;
 	int fd = -1;
 	int i;
 	u64 arg;
 	u64 sb_bytenr = btrfs_sb_offset(0);
 
-	while ((opt = getopt(argc, argv, "ai:")) != -1) {
+	while ((opt = getopt(argc, argv, "fai:")) != -1) {
 		switch (opt) {
 		case 'i':
 			arg = arg_strtou64(optarg);
@@ -80,7 +81,9 @@ int main(int argc, char **argv)
 		case 'a':
 			all = 1;
 			break;
-
+		case 'f':
+			full = 1;
+			break;
 		default:
 			print_usage();
 			exit(1);
@@ -104,7 +107,8 @@ int main(int argc, char **argv)
 			int idx;
 			for (idx = 0; idx < BTRFS_SUPER_MIRROR_MAX; idx++) {
 				sb_bytenr = btrfs_sb_offset(idx);
-				if (load_and_dump_sb(filename, fd, sb_bytenr)) {
+				if (load_and_dump_sb(filename, fd,
+							sb_bytenr, full)) {
 					close(fd);
 					exit(1);
 				}
@@ -112,7 +116,7 @@ int main(int argc, char **argv)
 				putchar('\n');
 			}
 		} else {
-			load_and_dump_sb(filename, fd, sb_bytenr);
+			load_and_dump_sb(filename, fd, sb_bytenr, full);
 			putchar('\n');
 		}
 		close(fd);
@@ -121,7 +125,7 @@ int main(int argc, char **argv)
 	exit(0);
 }
 
-static int load_and_dump_sb(char *filename, int fd, u64 sb_bytenr)
+static int load_and_dump_sb(char *filename, int fd, u64 sb_bytenr, int full)
 {
 	u8 super_block_data[BTRFS_SUPER_INFO_SIZE];
 	struct btrfs_super_block *sb;
@@ -146,7 +150,7 @@ static int load_and_dump_sb(char *filename, int fd, u64 sb_bytenr)
 	}
 	printf("superblock: bytenr=%llu, device=%s\n", sb_bytenr, filename);
 	printf("---------------------------------------------------------\n");
-	dump_superblock(sb);
+	dump_superblock(sb, full);
 	return 0;
 }
 
@@ -162,7 +166,113 @@ static int check_csum_sblock(void *sb, int csum_size)
 	return !memcmp(sb, &result, csum_size);
 }
 
-static void dump_superblock(struct btrfs_super_block *sb)
+static void print_sys_chunk_array(struct btrfs_super_block *sb)
+{
+	struct extent_buffer *buf;
+	struct btrfs_disk_key *disk_key;
+	struct btrfs_chunk *chunk;
+	struct btrfs_key key;
+	u8 *ptr, *array_end;
+	u32 num_stripes;
+	u32 len = 0;
+	int i = 0;
+
+	buf = malloc(sizeof(*buf) + sizeof(*sb));
+	if (!buf) {
+		fprintf(stderr, "%s\n", strerror(ENOMEM));
+		exit(1);
+	}
+	write_extent_buffer(buf, sb, 0, sizeof(*sb));
+	ptr = sb->sys_chunk_array;
+	array_end = ptr + btrfs_super_sys_array_size(sb);
+
+	while (ptr < array_end) {
+		disk_key = (struct btrfs_disk_key *)ptr;
+		btrfs_disk_key_to_cpu(&key, disk_key);
+
+		printf("\titem %d ", i);
+		btrfs_print_key(disk_key);
+
+		len = sizeof(*disk_key);
+		putchar('\n');
+		ptr += len;
+
+		if (key.type == BTRFS_CHUNK_ITEM_KEY) {
+			chunk = (struct btrfs_chunk *)(ptr - (u8 *)sb);
+			print_chunk(buf, chunk);
+			num_stripes = btrfs_chunk_num_stripes(buf, chunk);
+			len = btrfs_chunk_item_size(num_stripes);
+		} else {
+			BUG();
+		}
+
+		ptr += len;
+		i++;
+	}
+
+	free(buf);
+}
+
+static int empty_backup(struct btrfs_root_backup *backup)
+{
+	if (backup == NULL ||
+		(backup->tree_root == 0 &&
+		 backup->tree_root_gen == 0))
+		return 1;
+	return 0;
+}
+
+static void print_root_backup(struct btrfs_root_backup *backup)
+{
+	printf("\t\tbackup_tree_root:\t%llu\tgen: %llu\tlevel: %d\n",
+			btrfs_backup_tree_root(backup),
+			btrfs_backup_tree_root_gen(backup),
+			btrfs_backup_tree_root_level(backup));
+	printf("\t\tbackup_chunk_root:\t%llu\tgen: %llu\tlevel: %d\n",
+			btrfs_backup_chunk_root(backup),
+			btrfs_backup_chunk_root_gen(backup),
+			btrfs_backup_chunk_root_level(backup));
+	printf("\t\tbackup_extent_root:\t%llu\tgen: %llu\tlevel: %d\n",
+			btrfs_backup_extent_root(backup),
+			btrfs_backup_extent_root_gen(backup),
+			btrfs_backup_extent_root_level(backup));
+	printf("\t\tbackup_fs_root:\t\t%llu\tgen: %llu\tlevel: %d\n",
+			btrfs_backup_fs_root(backup),
+			btrfs_backup_fs_root_gen(backup),
+			btrfs_backup_fs_root_level(backup));
+	printf("\t\tbackup_dev_root:\t%llu\tgen: %llu\tlevel: %d\n",
+			btrfs_backup_dev_root(backup),
+			btrfs_backup_dev_root_gen(backup),
+			btrfs_backup_dev_root_level(backup));
+	printf("\t\tbackup_csum_root:\t%llu\tgen: %llu\tlevel: %d\n",
+			btrfs_backup_csum_root(backup),
+			btrfs_backup_csum_root_gen(backup),
+			btrfs_backup_csum_root_level(backup));
+
+	printf("\t\tbackup_total_bytes:\t%llu\n",
+					btrfs_backup_total_bytes(backup));
+	printf("\t\tbackup_bytes_used:\t%llu\n",
+					btrfs_backup_bytes_used(backup));
+	printf("\t\tbackup_num_devices:\t%llu\n",
+					btrfs_backup_num_devices(backup));
+	putchar('\n');
+}
+
+static void print_backup_roots(struct btrfs_super_block *sb)
+{
+	struct btrfs_root_backup *backup;
+	int i;
+
+	for (i = 0; i < BTRFS_NUM_BACKUP_ROOTS; i++) {
+		backup = sb->super_roots + i;
+		if (!empty_backup(backup)) {
+			printf("\tbackup %d:\n", i);
+			print_root_backup(backup);
+		}
+	}
+}
+
+static void dump_superblock(struct btrfs_super_block *sb, int full)
 {
 	int i;
 	char *s, buf[BTRFS_UUID_UNPARSED_SIZE];
@@ -280,4 +390,10 @@ static void dump_superblock(struct btrfs_super_block *sb)
 	       btrfs_stack_device_bandwidth(&sb->dev_item));
 	printf("dev_item.generation\t%llu\n", (unsigned long long)
 	       btrfs_stack_device_generation(&sb->dev_item));
+	if (full) {
+		printf("sys_chunk_array[%d]:\n", BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
+		print_sys_chunk_array(sb);
+		printf("backup_roots[%d]:\n", BTRFS_NUM_BACKUP_ROOTS);
+		print_backup_roots(sb);
+	}
 }
diff --git a/print-tree.c b/print-tree.c
index 7263b09..d46ab42 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -160,7 +160,7 @@ static int print_inode_ref_item(struct extent_buffer *eb, struct btrfs_item *ite
 	return 0;
 }
 
-static void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
+void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 {
 	int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
 	int i;
diff --git a/print-tree.h b/print-tree.h
index 495b81a..479f64b 100644
--- a/print-tree.h
+++ b/print-tree.h
@@ -21,4 +21,6 @@
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l);
 void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *t, int follow);
 void btrfs_print_key(struct btrfs_disk_key *disk_key);
+/* for btrfs-show-super to print the system chunk array */
+void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk);
 #endif
-- 
1.8.1.4

