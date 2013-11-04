Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23866 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3KDHJV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 02:09:21 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: define BTRFS_UUID_UNPARSE_SIZE for uuid unparse buf size
Date: Mon,  4 Nov 2013 15:17:41 +0800
Message-Id: <1383549461-6764-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

we use 37 as the allocation size to hold the uuid_unparse, here
it defines BTRFS_UUID_UNPARSE_SIZE for the same.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-debug-tree.c |    5 +++--
 btrfs-list.c       |    2 +-
 btrfs-show-super.c |    2 +-
 cmds-check.c       |    2 +-
 cmds-filesystem.c  |   17 +++++++++--------
 cmds-scrub.c       |    6 +++---
 cmds-subvolume.c   |    2 +-
 print-tree.c       |    9 +++++----
 utils.h            |    2 ++
 9 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 4a83770..f37de9d 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -27,6 +27,7 @@
 #include "print-tree.h"
 #include "transaction.h"
 #include "version.h"
+#include "utils.h"
 
 static int print_usage(void)
 {
@@ -125,7 +126,7 @@ int main(int ac, char **av)
 	struct extent_buffer *leaf;
 	struct btrfs_disk_key disk_key;
 	struct btrfs_key found_key;
-	char uuidbuf[37];
+	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	int ret;
 	int slot;
 	int extent_only = 0;
@@ -392,7 +393,7 @@ no_node:
 	       (unsigned long long)btrfs_super_total_bytes(info->super_copy));
 	printf("bytes used %llu\n",
 	       (unsigned long long)btrfs_super_bytes_used(info->super_copy));
-	uuidbuf[36] = '\0';
+	uuidbuf[BTRFS_UUID_UNPARSED_SIZE - 1] = '\0';
 	uuid_unparse(info->super_copy->fsid, uuidbuf);
 	printf("uuid %s\n", uuidbuf);
 	printf("%s\n", BTRFS_BUILD_VERSION);
diff --git a/btrfs-list.c b/btrfs-list.c
index f3618b9..6a38dd5 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1331,7 +1331,7 @@ static void print_subvolume_column(struct root_info *subv,
 				   enum btrfs_list_column_enum column)
 {
 	char tstr[256];
-	char uuidparse[37];
+	char uuidparse[BTRFS_UUID_UNPARSED_SIZE];
 
 	BUG_ON(column >= BTRFS_LIST_ALL || column < 0);
 
diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index 0c3c73c..b87f16a 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -165,7 +165,7 @@ static int check_csum_sblock(void *sb, int csum_size)
 static void dump_superblock(struct btrfs_super_block *sb)
 {
 	int i;
-	char *s, buf[36+1];
+	char *s, buf[BTRFS_UUID_UNPARSED_SIZE];
 	u8 *p;
 
 	printf("csum\t\t\t0x");
diff --git a/cmds-check.c b/cmds-check.c
index 573c606..59942d4 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6128,7 +6128,7 @@ int cmd_check(int argc, char **argv)
 	struct btrfs_root *root;
 	struct btrfs_fs_info *info;
 	u64 bytenr = 0;
-	char uuidbuf[37];
+	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	int ret;
 	int num;
 	int option_index = 0;
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f40178a..9295a1a 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -183,10 +183,10 @@ static int cmd_df(int argc, char **argv)
 static int match_search_item_kernel(__u8 *fsid, char *mnt, char *label,
 					char *search)
 {
-	char uuidbuf[37];
+	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	int search_len = strlen(search);
 
-	search_len = min(search_len, 37);
+	search_len = min(search_len, BTRFS_UUID_UNPARSED_SIZE);
 	uuid_unparse(fsid, uuidbuf);
 	if (!strncmp(uuidbuf, search, search_len))
 		return 1;
@@ -202,12 +202,12 @@ static int match_search_item_kernel(__u8 *fsid, char *mnt, char *label,
 
 static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
 {
-	char uuidbuf[37];
+	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	struct list_head *cur;
 	struct btrfs_device *device;
 	int search_len = strlen(search);
 
-	search_len = min(search_len, 37);
+	search_len = min(search_len, BTRFS_UUID_UNPARSED_SIZE);
 	uuid_unparse(fs_devices->fsid, uuidbuf);
 	if (!strncmp(uuidbuf, search, search_len))
 		return 1;
@@ -238,7 +238,7 @@ static int cmp_device_id(void *priv, struct list_head *a,
 
 static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 {
-	char uuidbuf[37];
+	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	struct list_head *cur;
 	struct btrfs_device *device;
 	u64 devs_found = 0;
@@ -292,7 +292,7 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 		char *label, char *path)
 {
 	int i;
-	char uuidbuf[37];
+	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	struct btrfs_ioctl_dev_info_args *tmp_dev_info;
 
 	uuid_unparse(fs_info->fsid, uuidbuf);
@@ -366,7 +366,8 @@ static int check_arg_type(char *input)
 		return BTRFS_ARG_UNKNOWN;
 	}
 
-	if (strlen(input) == 36 && !uuid_parse(input, out))
+	if (strlen(input) == (BTRFS_UUID_UNPARSED_SIZE - 1) &&
+		!uuid_parse(input, out))
 		return BTRFS_ARG_UUID;
 
 	return BTRFS_ARG_UNKNOWN;
@@ -469,7 +470,7 @@ static int cmd_show(int argc, char **argv)
 	char mp[BTRFS_PATH_NAME_MAX + 1];
 	char path[PATH_MAX];
 	__u8 fsid[BTRFS_FSID_SIZE];
-	char uuid_buf[37];
+	char uuid_buf[BTRFS_UUID_UNPARSED_SIZE];
 
 	while (1) {
 		int long_index;
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 605af45..b933770 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -867,7 +867,7 @@ static void *scrub_progress_cycle(void *ctx)
 	int  perr = 0;	/* positive / pthread error returns */
 	int old;
 	int i;
-	char fsid[37];
+	char fsid[BTRFS_UUID_UNPARSED_SIZE];
 	struct scrub_progress *sp;
 	struct scrub_progress *sp_last;
 	struct scrub_progress *sp_shared;
@@ -1089,7 +1089,7 @@ static int scrub_start(int argc, char **argv, int resume)
 	struct scrub_file_record **past_scrubs = NULL;
 	struct scrub_file_record *last_scrub = NULL;
 	char *datafile = strdup(SCRUB_DATA_FILE);
-	char fsid[37];
+	char fsid[BTRFS_UUID_UNPARSED_SIZE];
 	char sock_path[BTRFS_PATH_NAME_MAX + 1] = "";
 	struct scrub_progress_cycle spc;
 	pthread_mutex_t spc_write_mutex = PTHREAD_MUTEX_INITIALIZER;
@@ -1615,7 +1615,7 @@ static int cmd_scrub_status(int argc, char **argv)
 	int print_raw = 0;
 	int do_stats_per_dev = 0;
 	int c;
-	char fsid[37];
+	char fsid[BTRFS_UUID_UNPARSED_SIZE];
 	int fdres = -1;
 	int err = 0;
 	DIR *dirstream = NULL;
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 76dab1f..f9cbc78 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -823,7 +823,7 @@ static int cmd_subvol_show(int argc, char **argv)
 	struct root_info get_ri;
 	struct btrfs_list_filter_set *filter_set;
 	char tstr[256];
-	char uuidparse[37];
+	char uuidparse[BTRFS_UUID_UNPARSED_SIZE];
 	char *fullpath = NULL, *svpath = NULL, *mnt = NULL;
 	char raw_prefix[] = "\t\t\t\t";
 	u64 sv_id, mntid;
diff --git a/print-tree.c b/print-tree.c
index 76037fe..c52e5da 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -24,6 +24,7 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "print-tree.h"
+#include "utils.h"
 
 
 static void print_dir_item_type(struct extent_buffer *eb,
@@ -187,21 +188,21 @@ static void print_dev_item(struct extent_buffer *eb,
 
 static void print_uuids(struct extent_buffer *eb)
 {
-	char fs_uuid[37];
-	char chunk_uuid[37];
+	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE];
+	char chunk_uuid[BTRFS_UUID_UNPARSED_SIZE];
 	u8 disk_uuid[BTRFS_UUID_SIZE];
 
 	read_extent_buffer(eb, disk_uuid, btrfs_header_fsid(),
 			   BTRFS_FSID_SIZE);
 
-	fs_uuid[36] = '\0';
+	fs_uuid[BTRFS_UUID_UNPARSED_SIZE - 1] = '\0';
 	uuid_unparse(disk_uuid, fs_uuid);
 
 	read_extent_buffer(eb, disk_uuid,
 			   (unsigned long)btrfs_header_chunk_tree_uuid(eb),
 			   BTRFS_UUID_SIZE);
 
-	chunk_uuid[36] = '\0';
+	chunk_uuid[BTRFS_UUID_UNPARSED_SIZE - 1] = '\0';
 	uuid_unparse(disk_uuid, chunk_uuid);
 	printf("fs uuid %s\nchunk uuid %s\n", fs_uuid, chunk_uuid);
 }
diff --git a/utils.h b/utils.h
index 8c64575..b91bbee 100644
--- a/utils.h
+++ b/utils.h
@@ -37,6 +37,8 @@
 #define BTRFS_ARG_UUID		2
 #define BTRFS_ARG_BLKDEV	3
 
+#define BTRFS_UUID_UNPARSED_SIZE	37
+
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize, u64 features);
-- 
1.7.1

