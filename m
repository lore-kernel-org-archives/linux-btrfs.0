Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64066 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab3GCQHv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 12:07:51 -0400
Received: by mail-pa0-f51.google.com with SMTP id lf11so381764pab.24
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jul 2013 09:07:50 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl-fnst@cn.fujitsu.com
Subject: [PATCH 1/2] Btrfs-progs: make pretty_sizes() works less error prone
Date: Thu,  4 Jul 2013 00:07:37 +0800
Message-Id: <1372867658-4144-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

In the original code, pretty_sizes() may return NULL in two cases:
<1> Allocating memory dynamically fails
<2> Overflow happens(size exceeds YB)

The original codes don't handle error gracefully and some places
forget to free memory.

However, just allocating memory before calling pretty_sizes(),and if size exceeds
YB, we just set unit as YB and the integer part larger than 1024 is ok.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 btrfs-calc-size.c | 10 ++++------
 btrfs-fragments.c |  4 +++-
 cmds-filesystem.c | 24 ++++++++++--------------
 cmds-scrub.c      |  5 ++---
 mkfs.c            |  8 ++++----
 utils.c           | 17 +++++++----------
 utils.h           |  3 ++-
 7 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index c4adfb0..708b0d3 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -162,18 +162,16 @@ out_print:
 		       stat.total_inline, stat.total_nodes, stat.total_leaves,
 		       level + 1);
 	} else {
-		char *total_size;
-		char *inline_size;
+		char total_size[MAX_PRETTY_LEN];
+		char inline_size[MAX_PRETTY_LEN];
 
-		total_size = pretty_sizes(stat.total_bytes);
-		inline_size = pretty_sizes(stat.total_inline);
+		pretty_sizes(stat.total_bytes, total_size);
+		pretty_sizes(stat.total_inline, inline_size);
 
 		printf("\t%s total size, %s inline data, %Lu nodes, "
 		       "%Lu leaves, %d levels\n",
 		       total_size, inline_size, stat.total_nodes,
 		       stat.total_leaves, level + 1);
-		free(total_size);
-		free(inline_size);
 	}
 out:
 	btrfs_free_path(path);
diff --git a/btrfs-fragments.c b/btrfs-fragments.c
index a012fe1..56c8683 100644
--- a/btrfs-fragments.c
+++ b/btrfs-fragments.c
@@ -84,10 +84,12 @@ print_bg(FILE *html, char *name, u64 start, u64 len, u64 used, u64 flags,
 	 u64 areas)
 {
 	double frag = (double)areas / (len / 4096) * 2;
+	char str[MAX_PRETTY_LEN];
+	pretty_sizes(len, str);
 
 	fprintf(html, "<p>%s chunk starts at %lld, size is %s, %.2f%% used, "
 		      "%.2f%% fragmented</p>\n", chunk_type(flags), start,
-		      pretty_sizes(len), 100.0 * used / len, 100.0 * frag);
+		      str, 100.0 * used / len, 100.0 * frag);
 	fprintf(html, "<img src=\"%s\" border=\"1\" />\n", name);
 }
 
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f41a72a..a80e495 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -111,8 +111,8 @@ static int cmd_df(int argc, char **argv)
 
 	for (i = 0; i < sargs->total_spaces; i++) {
 		char description[80];
-		char *total_bytes;
-		char *used_bytes;
+		char total_bytes[MAX_PRETTY_LEN];
+		char used_bytes[MAX_PRETTY_LEN];
 		int written = 0;
 		u64 flags = sargs->spaces[i].flags;
 
@@ -155,8 +155,8 @@ static int cmd_df(int argc, char **argv)
 			written += 7;
 		}
 
-		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
-		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes);
+		pretty_sizes(sargs->spaces[i].total_bytes, total_bytes);
+		pretty_sizes(sargs->spaces[i].used_bytes, used_bytes);
 		printf("%s: total=%s, used=%s\n", description, total_bytes,
 		       used_bytes);
 	}
@@ -192,7 +192,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	char uuidbuf[37];
 	struct list_head *cur;
 	struct btrfs_device *device;
-	char *super_bytes_used;
+	char super_bytes_used[MAX_PRETTY_LEN];
 	u64 devs_found = 0;
 	u64 total;
 
@@ -204,25 +204,21 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	else
 		printf("Label: none ");
 
-	super_bytes_used = pretty_sizes(device->super_bytes_used);
+	pretty_sizes(device->super_bytes_used, super_bytes_used);
 
 	total = device->total_devs;
 	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
 	       (unsigned long long)total, super_bytes_used);
 
-	free(super_bytes_used);
-
 	list_for_each(cur, &fs_devices->devices) {
-		char *total_bytes;
-		char *bytes_used;
+		char total_bytes[MAX_PRETTY_LEN];
+		char bytes_used[MAX_PRETTY_LEN];
 		device = list_entry(cur, struct btrfs_device, dev_list);
-		total_bytes = pretty_sizes(device->total_bytes);
-		bytes_used = pretty_sizes(device->bytes_used);
+		pretty_sizes(device->total_bytes, total_bytes);
+		pretty_sizes(device->bytes_used, bytes_used);
 		printf("\tdevid %4llu size %s used %s path %s\n",
 		       (unsigned long long)device->devid,
 		       total_bytes, bytes_used, device->name);
-		free(total_bytes);
-		free(bytes_used);
 		devs_found++;
 	}
 	if (devs_found < total) {
diff --git a/cmds-scrub.c b/cmds-scrub.c
index c0dc584..99526f5 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -139,7 +139,7 @@ static void print_scrub_summary(struct btrfs_scrub_progress *p)
 {
 	u64 err_cnt;
 	u64 err_cnt2;
-	char *bytes;
+	char bytes[MAX_PRETTY_LEN];
 
 	err_cnt = p->read_errors +
 			p->csum_errors +
@@ -151,10 +151,9 @@ static void print_scrub_summary(struct btrfs_scrub_progress *p)
 	if (p->malloc_errors)
 		printf("*** WARNING: memory allocation failed while scrubbing. "
 		       "results may be inaccurate\n");
-	bytes = pretty_sizes(p->data_bytes_scrubbed + p->tree_bytes_scrubbed);
+	pretty_sizes(p->data_bytes_scrubbed + p->tree_bytes_scrubbed, bytes);
 	printf("\ttotal bytes scrubbed: %s with %llu errors\n", bytes,
 		max(err_cnt, err_cnt2));
-	free(bytes);
 	if (err_cnt || err_cnt2) {
 		printf("\terror details:");
 		PRINT_SCRUB_ERROR(p->read_errors, "read");
diff --git a/mkfs.c b/mkfs.c
index 7ff60e5..73a17f8 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1287,7 +1287,7 @@ int main(int ac, char **av)
 	u64 num_of_meta_chunks = 0;
 	u64 size_of_data = 0;
 	u64 source_dir_size = 0;
-	char *pretty_buf;
+	char pretty_buf[MAX_PRETTY_LEN];
 	struct btrfs_super_block *super;
 	u64 flags;
 	int dev_cnt = 0;
@@ -1536,11 +1536,11 @@ raid_groups:
 		printf("Setting RAID5/6 feature flag\n");
 	}
 
+	pretty_sizes(btrfs_super_total_bytes(root->fs_info->super_copy),
+		     pretty_buf);
 	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
 	    "sectorsize %u size %s\n",
-	    label, first_file, nodesize, leafsize, sectorsize,
-	    pretty_buf = pretty_sizes(btrfs_super_total_bytes(root->fs_info->super_copy)));
-	free(pretty_buf);
+	    label, first_file, nodesize, leafsize, sectorsize, pretty_buf);
 
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	btrfs_commit_transaction(trans, root);
diff --git a/utils.c b/utils.c
index 7b4cd74..70d3f18 100644
--- a/utils.c
+++ b/utils.c
@@ -1153,12 +1153,10 @@ out:
 
 static char *size_strs[] = { "", "KB", "MB", "GB", "TB",
 			    "PB", "EB", "ZB", "YB"};
-char *pretty_sizes(u64 size)
+int pretty_sizes(u64 size, char *pretty)
 {
 	int num_divs = 0;
-        int pretty_len = 16;
-	float fraction;
-	char *pretty;
+	double fraction;
 
 	if( size < 1024 ){
 		fraction = size;
@@ -1172,13 +1170,12 @@ char *pretty_sizes(u64 size)
 			num_divs ++;
 		}
 
-		if (num_divs >= ARRAY_SIZE(size_strs))
-			return NULL;
-		fraction = (float)last_size / 1024;
+		if (num_divs >= (ARRAY_SIZE(size_strs)))
+			num_divs = ARRAY_SIZE(size_strs) - 1;
+		fraction = (double)last_size / 1024;
 	}
-	pretty = malloc(pretty_len);
-	snprintf(pretty, pretty_len, "%.2f%s", fraction, size_strs[num_divs]);
-	return pretty;
+	return snprintf(pretty, MAX_PRETTY_LEN, "%.2lf%s",
+			fraction, size_strs[num_divs]);
 }
 
 /*
diff --git a/utils.h b/utils.h
index 3c17e14..34429c5 100644
--- a/utils.h
+++ b/utils.h
@@ -23,6 +23,7 @@
 #include "ctree.h"
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
+#define MAX_PRETTY_LEN 30
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
@@ -44,7 +45,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 			struct btrfs_fs_devices **fs_devices_mnt);
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
-char *pretty_sizes(u64 size);
+int pretty_sizes(u64 size, char *buf);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 int btrfs_scan_block_devices(int run_ioctl);
 u64 parse_size(char *s);
-- 
1.7.11.7

