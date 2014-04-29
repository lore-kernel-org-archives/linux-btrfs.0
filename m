Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757458AbaD2P6V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 11:58:21 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E3AE5AC4F
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 15:58:20 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 03/14] btrfs-progs: move device usage to cmds-device, more cleanups
Date: Tue, 29 Apr 2014 17:58:09 +0200
Message-Id: <4c5844eab0052ba549bf31f56a581856d2e6b768.1398786620.git.dsterba@suse.cz>
In-Reply-To: <cover.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move the command definitions where they belong, keep common 'usage'
functions in cmds-fi-disk_usage.c and add exports.

Rename structures containing 'disk' to 'device'.

Fix whitespace in the modified code.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-device.c        |  96 +++++++++++++++++-
 cmds-fi-disk_usage.c | 281 ++++++++++++---------------------------------------
 cmds-fi-disk_usage.h |  30 +++++-
 3 files changed, 188 insertions(+), 219 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index a9b4a3859390..7a9d808b36dd 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -423,6 +423,98 @@ out:
 	return err;
 }
 
+const char * const cmd_device_usage_usage[] = {
+	"btrfs device usage [-b] <path> [<path>..]",
+	"Show which chunks are in a device.",
+	"",
+	"-b\tSet byte as unit",
+	NULL
+};
+
+static int _cmd_device_usage(int fd, char *path, int mode)
+{
+	int i;
+	int ret = 0;
+	int info_count = 0;
+	struct chunk_info *info_ptr = 0;
+	struct device_info *device_info_ptr = 0;
+	int device_info_count = 0;
+
+	if (load_chunk_info(fd, &info_ptr, &info_count) ||
+	    load_device_info(fd, &device_info_ptr, &device_info_count)) {
+		ret = -1;
+		goto exit;
+	}
+
+	for (i = 0; i < device_info_count; i++) {
+		printf("%s\t%10s\n", device_info_ptr[i].path,
+			df_pretty_sizes(device_info_ptr[i].size, mode));
+
+		print_device_chunks(fd, device_info_ptr[i].devid,
+				device_info_ptr[i].size,
+				info_ptr, info_count,
+				mode);
+		printf("\n");
+	}
+
+exit:
+	if (device_info_ptr)
+		free(device_info_ptr);
+	if (info_ptr)
+		free(info_ptr);
+
+	return ret;
+}
+
+int cmd_device_usage(int argc, char **argv)
+{
+
+	int	flags = DF_HUMAN_UNIT;
+	int	i, more_than_one = 0;
+
+	optind = 1;
+	while (1) {
+		char	c = getopt(argc, argv, "b");
+
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'b':
+			flags &= ~DF_HUMAN_UNIT;
+			break;
+		default:
+			usage(cmd_device_usage_usage);
+		}
+	}
+
+	if (check_argc_min(argc - optind, 1))
+		usage(cmd_device_usage_usage);
+
+	for (i = optind; i < argc ; i++) {
+		int r, fd;
+		DIR	*dirstream = NULL;
+		if (more_than_one)
+			printf("\n");
+
+		fd = open_file_or_dir(argv[i], &dirstream);
+		if (fd < 0) {
+			fprintf(stderr, "ERROR: can't access to '%s'\n",
+				argv[1]);
+			return 12;
+		}
+		r = _cmd_device_usage(fd, argv[i], flags);
+		close_file_or_dir(fd, dirstream);
+
+		if (r)
+			return r;
+		more_than_one = 1;
+
+	}
+
+	return 0;
+}
+
 const struct cmd_group device_cmd_group = {
 	device_cmd_group_usage, NULL, {
 		{ "add", cmd_add_dev, cmd_add_dev_usage, NULL, 0 },
@@ -430,8 +522,8 @@ const struct cmd_group device_cmd_group = {
 		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
 		{ "ready", cmd_ready_dev, cmd_ready_dev_usage, NULL, 0 },
 		{ "stats", cmd_dev_stats, cmd_dev_stats_usage, NULL, 0 },
-		{ "disk-usage", cmd_device_disk_usage,
-			cmd_device_disk_usage_usage, NULL, 0 },
+		{ "usage", cmd_device_usage,
+			cmd_device_usage_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	}
 };
diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 400863d9764f..17202de1b6e8 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -26,38 +26,16 @@
 #include "kerncompat.h"
 #include "ctree.h"
 #include "string_table.h"
-
+#include "cmds-fi-disk_usage.h"
 #include "commands.h"
 
 #include "version.h"
 
-#define DF_HUMAN_UNIT		(1<<0)
-
-/*
- * To store the size information about the chunks:
- * the chunks info are grouped by the tuple (type, devid, num_stripes),
- * i.e. if two chunks are of the same type (RAID1, DUP...), are on the
- * same disk, have the same stripes then their sizes are grouped
- */
-struct chunk_info {
-	u64	type;
-	u64	size;
-	u64	devid;
-	u64	num_stripes;
-};
-
-/* to store information about the disks */
-struct disk_info {
-	u64	devid;
-	char	path[BTRFS_DEVICE_PATH_NAME_MAX];
-	u64	size;
-};
-
 /*
  * Pretty print the size
  * PAY ATTENTION: it return a statically buffer
  */
-static char *df_pretty_sizes(u64 size, int mode)
+char *df_pretty_sizes(u64 size, int mode)
 {
 	static char buf[30];
 
@@ -162,14 +140,8 @@ static int cmp_chunk_info(const void *a, const void *b)
 		((struct chunk_info *)b)->type);
 }
 
-/*
- * This function load all the chunk info from the 'fd' filesystem
- */
-static int load_chunk_info(int fd,
-			  struct chunk_info **info_ptr,
-			  int *info_count)
+int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count)
 {
-
 	int ret;
 	struct btrfs_ioctl_search_args args;
 	struct btrfs_ioctl_search_key *sk = &args.key;
@@ -177,7 +149,6 @@ static int load_chunk_info(int fd,
 	unsigned long off = 0;
 	int i, e;
 
-
 	memset(&args, 0, sizeof(args));
 
 	/*
@@ -185,8 +156,6 @@ static int load_chunk_info(int fd,
 	 * snapshots pending deletion, we have to loop through
 	 * them.
 	 */
-
-
 	sk->tree_id = BTRFS_CHUNK_TREE_OBJECTID;
 
 	sk->min_objectid = 0;
@@ -253,7 +222,6 @@ static int load_chunk_info(int fd,
 		cmp_chunk_info);
 
 	return 0;
-
 }
 
 /*
@@ -333,7 +301,7 @@ static struct btrfs_ioctl_space_args *load_space_info(int fd, char *path)
 /*
  * This function computes the space occuped by a *single* RAID5/RAID6 chunk.
  * The computation is performed on the basis of the number of stripes
- * which compose the chunk, which could be different from the number of disks
+ * which compose the chunk, which could be different from the number of devices
  * if a disk is added later.
  */
 static int get_raid56_used(int fd, u64 *raid5_used, u64 *raid6_used)
@@ -367,7 +335,7 @@ static int _cmd_disk_free(int fd, char *path, int mode)
 	int ret = 0;
 	int e, width;
 	u64 total_disk;		/* filesystem size == sum of
-				   disks sizes */
+				   device sizes */
 	u64 total_chunks;	/* sum of chunks sizes on disk(s) */
 	u64 total_used;		/* logical space used */
 	u64 total_free;		/* logical space un-used */
@@ -470,29 +438,27 @@ exit:
 #endif
 
 /*
- *  Helper to sort the disk_info structure
+ *  Helper to sort the device_info structure
  */
-static int cmp_disk_info(const void *a, const void *b)
+static int cmp_device_info(const void *a, const void *b)
 {
-	return strcmp(((struct disk_info *)a)->path,
-			((struct disk_info *)b)->path);
+	return strcmp(((struct device_info *)a)->path,
+			((struct device_info *)b)->path);
 }
 
 /*
- *  This function load the disk_info structure and put them in an array
+ *  This function loads the device_info structure and put them in an array
  */
-static int load_disks_info(int fd,
-			   struct disk_info **disks_info_ptr,
-			   int *disks_info_count)
+int load_device_info(int fd, struct device_info **device_info_ptr,
+			   int *device_info_count)
 {
-
 	int ret, i, ndevs;
 	struct btrfs_ioctl_fs_info_args fi_args;
 	struct btrfs_ioctl_dev_info_args dev_info;
-	struct disk_info *info;
+	struct device_info *info;
 
-	*disks_info_count = 0;
-	*disks_info_ptr = 0;
+	*device_info_count = 0;
+	*device_info_ptr = 0;
 
 	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &fi_args);
 	if (ret < 0) {
@@ -500,7 +466,7 @@ static int load_disks_info(int fd,
 		return -1;
 	}
 
-	info = malloc(sizeof(struct disk_info) * fi_args.num_devices);
+	info = malloc(sizeof(struct device_info) * fi_args.num_devices);
 	if (!info) {
 		fprintf(stderr, "ERROR: not enough memory\n");
 		return -1;
@@ -529,13 +495,12 @@ static int load_disks_info(int fd,
 
 	BUG_ON(ndevs != fi_args.num_devices);
 	qsort(info, fi_args.num_devices,
-		sizeof(struct disk_info), cmp_disk_info);
+		sizeof(struct device_info), cmp_device_info);
 
-	*disks_info_count = fi_args.num_devices;
-	*disks_info_ptr = info;
+	*device_info_count = fi_args.num_devices;
+	*device_info_ptr = info;
 
 	return 0;
-
 }
 
 /*
@@ -566,8 +531,8 @@ static void _cmd_filesystem_usage_tabular(int mode,
 					struct btrfs_ioctl_space_args *sargs,
 					struct chunk_info *chunks_info_ptr,
 					int chunks_info_count,
-					struct disk_info *disks_info_ptr,
-					int disks_info_count)
+					struct device_info *device_info_ptr,
+					int device_info_count)
 {
 	int i;
 	u64 total_unused = 0;
@@ -575,7 +540,7 @@ static void _cmd_filesystem_usage_tabular(int mode,
 	int  ncols, nrows;
 
 	ncols = sargs->total_spaces + 2;
-	nrows = 2 + 1 + disks_info_count + 1 + 2;
+	nrows = 2 + 1 + device_info_count + 1 + 2;
 
 	matrix = table_create(ncols, nrows);
 	if (!matrix) {
@@ -605,24 +570,23 @@ static void _cmd_filesystem_usage_tabular(int mode,
 	table_printf(matrix, 1+sargs->total_spaces, 1, "<Unallocated");
 
 	/* body */
-	for (i = 0 ; i < disks_info_count ; i++) {
+	for (i = 0; i < device_info_count; i++) {
 		int k, col;
 		char *p;
 
 		u64  total_allocated = 0, unused;
 
-		p = strrchr(disks_info_ptr[i].path, '/');
+		p = strrchr(device_info_ptr[i].path, '/');
 		if (!p)
-			p = disks_info_ptr[i].path;
+			p = device_info_ptr[i].path;
 		else
 			p++;
 
-		table_printf(matrix, 0, i+3, "<%s",
-				disks_info_ptr[i].path);
+		table_printf(matrix, 0, i + 3, "<%s", device_info_ptr[i].path);
 
 		for (col = 1, k = 0 ; k < sargs->total_spaces ; k++)  {
 			u64	flags = sargs->spaces[k].flags;
-			u64 devid = disks_info_ptr[i].devid;
+			u64 devid = device_info_ptr[i].devid;
 			int	j;
 			u64 size = 0;
 
@@ -645,8 +609,8 @@ static void _cmd_filesystem_usage_tabular(int mode,
 			col++;
 		}
 
-		unused = get_partition_size(disks_info_ptr[i].path) -
-				total_allocated;
+		unused = get_partition_size(device_info_ptr[i].path)
+				- total_allocated;
 
 		table_printf(matrix, sargs->total_spaces + 1, i + 3,
 			       ">%s", df_pretty_sizes(unused, mode));
@@ -655,28 +619,24 @@ static void _cmd_filesystem_usage_tabular(int mode,
 	}
 
 	for (i = 0; i <= sargs->total_spaces; i++)
-		table_printf(matrix, i + 1, disks_info_count + 3, "=");
-
+		table_printf(matrix, i + 1, device_info_count + 3, "=");
 
 	/* footer */
-	table_printf(matrix, 0, disks_info_count + 4, "<Total");
+	table_printf(matrix, 0, device_info_count + 4, "<Total");
 	for (i = 0; i < sargs->total_spaces; i++)
-		table_printf(matrix, 1 + i, disks_info_count + 4,
-			">%s",
+		table_printf(matrix, 1 + i, device_info_count + 4, ">%s",
 			df_pretty_sizes(sargs->spaces[i].total_bytes, mode));
 
-	table_printf(matrix, sargs->total_spaces+1, disks_info_count+4,
-		">%s", df_pretty_sizes(total_unused, mode));
+	table_printf(matrix, sargs->total_spaces + 1, device_info_count + 4,
+			">%s", df_pretty_sizes(total_unused, mode));
 
-	table_printf(matrix, 0, disks_info_count+5, "<Used");
+	table_printf(matrix, 0, device_info_count + 5, "<Used");
 	for (i = 0; i < sargs->total_spaces; i++)
-		table_printf(matrix, 1+i, disks_info_count+5, ">%s",
+		table_printf(matrix, 1 + i, device_info_count+5, ">%s",
 			df_pretty_sizes(sargs->spaces[i].used_bytes, mode));
 
-
 	table_dump(matrix);
 	table_free(matrix);
-
 }
 
 /*
@@ -684,50 +644,46 @@ static void _cmd_filesystem_usage_tabular(int mode,
  */
 static void print_unused(struct chunk_info *info_ptr,
 			  int info_count,
-			  struct disk_info *disks_info_ptr,
-			  int disks_info_count,
+			  struct device_info *device_info_ptr,
+			  int device_info_count,
 			  int mode)
 {
 	int i;
-	for (i = 0 ; i < disks_info_count ; i++) {
-
+	for (i = 0; i < device_info_count; i++) {
 		int	j;
 		u64	total = 0;
 
-		for (j = 0 ; j < info_count ; j++)
-			if (info_ptr[j].devid == disks_info_ptr[i].devid)
+		for (j = 0; j < info_count; j++)
+			if (info_ptr[j].devid == device_info_ptr[i].devid)
 				total += calc_chunk_size(info_ptr+j);
 
 		printf("   %s\t%10s\n",
-			disks_info_ptr[i].path,
-			df_pretty_sizes(disks_info_ptr[i].size - total, mode));
-
+			device_info_ptr[i].path,
+			df_pretty_sizes(device_info_ptr[i].size - total, mode));
 	}
-
 }
 
 /*
  *  This function prints the allocated chunk per every disk
  */
-static void print_chunk_disks(u64 chunk_type,
+static void print_chunk_device(u64 chunk_type,
 				struct chunk_info *chunks_info_ptr,
 				int chunks_info_count,
-				struct disk_info *disks_info_ptr,
-				int disks_info_count,
+				struct device_info *device_info_ptr,
+				int device_info_count,
 				int mode)
 {
 	int i;
 
-	for (i = 0 ; i < disks_info_count ; i++) {
-
+	for (i = 0; i < device_info_count; i++) {
 		int	j;
 		u64	total = 0;
 
-		for (j = 0 ; j < chunks_info_count ; j++) {
+		for (j = 0; j < chunks_info_count; j++) {
 
 			if (chunks_info_ptr[j].type != chunk_type)
 				continue;
-			if (chunks_info_ptr[j].devid != disks_info_ptr[i].devid)
+			if (chunks_info_ptr[j].devid != device_info_ptr[i].devid)
 				continue;
 
 			total += calc_chunk_size(&(chunks_info_ptr[j]));
@@ -736,7 +692,7 @@ static void print_chunk_disks(u64 chunk_type,
 
 		if (total > 0)
 			printf("   %s\t%10s\n",
-				disks_info_ptr[i].path,
+				device_info_ptr[i].path,
 				df_pretty_sizes(total, mode));
 	}
 }
@@ -749,8 +705,8 @@ static void _cmd_filesystem_usage_linear(int mode,
 					struct btrfs_ioctl_space_args *sargs,
 					struct chunk_info *info_ptr,
 					int info_count,
-					struct disk_info *disks_info_ptr,
-					int disks_info_count)
+					struct device_info *device_info_ptr,
+					int device_info_count)
 {
 	int i;
 
@@ -768,22 +724,15 @@ static void _cmd_filesystem_usage_linear(int mode,
 			df_pretty_sizes(sargs->spaces[i].total_bytes ,
 			    mode));
 		printf("Used:%s\n",
-			df_pretty_sizes(sargs->spaces[i].used_bytes,
-					mode));
-		print_chunk_disks(flags, info_ptr, info_count,
-				disks_info_ptr, disks_info_count,
-				mode);
+			df_pretty_sizes(sargs->spaces[i].used_bytes, mode));
+		print_chunk_device(flags, info_ptr, info_count,
+				device_info_ptr, device_info_count, mode);
 		printf("\n");
-
 	}
 
 	printf("Unallocated:\n");
-	print_unused(info_ptr, info_count,
-			disks_info_ptr, disks_info_count,
+	print_unused(info_ptr, info_count, device_info_ptr, device_info_count,
 			mode);
-
-
-
 }
 
 static int _cmd_filesystem_usage(int fd, char *path, int mode, int tabular)
@@ -791,12 +740,12 @@ static int _cmd_filesystem_usage(int fd, char *path, int mode, int tabular)
 	struct btrfs_ioctl_space_args *sargs = 0;
 	int info_count = 0;
 	struct chunk_info *info_ptr = 0;
-	struct disk_info *disks_info_ptr = 0;
-	int disks_info_count = 0;
+	struct device_info *device_info_ptr = 0;
+	int device_info_count = 0;
 	int ret = 0;
 
 	if (load_chunk_info(fd, &info_ptr, &info_count) ||
-	    load_disks_info(fd, &disks_info_ptr, &disks_info_count)) {
+	    load_device_info(fd, &device_info_ptr, &device_info_count)) {
 		ret = -1;
 		goto exit;
 	}
@@ -809,18 +758,18 @@ static int _cmd_filesystem_usage(int fd, char *path, int mode, int tabular)
 	if (tabular)
 		_cmd_filesystem_usage_tabular(mode, sargs,
 					info_ptr, info_count,
-					disks_info_ptr, disks_info_count);
+					device_info_ptr, device_info_count);
 	else
 		_cmd_filesystem_usage_linear(mode, sargs,
 					info_ptr, info_count,
-					disks_info_ptr, disks_info_count);
+					device_info_ptr, device_info_count);
 
 exit:
 
 	if (sargs)
 		free(sargs);
-	if (disks_info_ptr)
-		free(disks_info_ptr);
+	if (device_info_ptr)
+		free(device_info_ptr);
 	if (info_ptr)
 		free(info_ptr);
 
@@ -887,12 +836,9 @@ int cmd_filesystem_usage(int argc, char **argv)
 	return 0;
 }
 
-static void print_disk_chunks(int fd,
-				u64 devid,
-				u64 total_size,
-				struct chunk_info *chunks_info_ptr,
-				int chunks_info_count,
-				int mode)
+void print_device_chunks(int fd, u64 devid, u64 total_size,
+		struct chunk_info *chunks_info_ptr,
+		int chunks_info_count, int mode)
 {
 	int i;
 	u64 allocated = 0;
@@ -925,98 +871,3 @@ static void print_disk_chunks(int fd,
 		df_pretty_sizes(total_size - allocated, mode));
 
 }
-
-static int _cmd_device_disk_usage(int fd, char *path, int mode)
-{
-	int i;
-	int ret = 0;
-	int info_count = 0;
-	struct chunk_info *info_ptr = 0;
-	struct disk_info *disks_info_ptr = 0;
-	int disks_info_count = 0;
-
-	if (load_chunk_info(fd, &info_ptr, &info_count) ||
-	    load_disks_info(fd, &disks_info_ptr, &disks_info_count)) {
-		ret = -1;
-		goto exit;
-	}
-
-	for (i = 0 ; i < disks_info_count ; i++) {
-		printf("%s\t%10s\n", disks_info_ptr[i].path,
-			df_pretty_sizes(disks_info_ptr[i].size, mode));
-
-		print_disk_chunks(fd, disks_info_ptr[i].devid,
-				disks_info_ptr[i].size,
-				info_ptr, info_count,
-				mode);
-		printf("\n");
-
-	}
-
-
-exit:
-
-	if (disks_info_ptr)
-		free(disks_info_ptr);
-	if (info_ptr)
-		free(info_ptr);
-
-	return ret;
-}
-
-const char * const cmd_device_disk_usage_usage[] = {
-	"btrfs device disk-usage [-b] <path> [<path>..]",
-	"Show which chunks are in a device.",
-	"",
-	"-b\tSet byte as unit",
-	NULL
-};
-
-int cmd_device_disk_usage(int argc, char **argv)
-{
-
-	int	flags = DF_HUMAN_UNIT;
-	int	i, more_than_one = 0;
-
-	optind = 1;
-	while (1) {
-		char	c = getopt(argc, argv, "b");
-
-		if (c < 0)
-			break;
-
-		switch (c) {
-		case 'b':
-			flags &= ~DF_HUMAN_UNIT;
-			break;
-		default:
-			usage(cmd_device_disk_usage_usage);
-		}
-	}
-
-	if (check_argc_min(argc - optind, 1))
-		usage(cmd_device_disk_usage_usage);
-
-	for (i = optind; i < argc ; i++) {
-		int r, fd;
-		DIR	*dirstream = NULL;
-		if (more_than_one)
-			printf("\n");
-
-		fd = open_file_or_dir(argv[i], &dirstream);
-		if (fd < 0) {
-			fprintf(stderr, "ERROR: can't access to '%s'\n",
-				argv[1]);
-			return 12;
-		}
-		r = _cmd_device_disk_usage(fd, argv[i], flags);
-		close_file_or_dir(fd, dirstream);
-
-		if (r)
-			return r;
-		more_than_one = 1;
-
-	}
-
-	return 0;
-}
diff --git a/cmds-fi-disk_usage.h b/cmds-fi-disk_usage.h
index 95cf4aabefb4..787b4eb56acf 100644
--- a/cmds-fi-disk_usage.h
+++ b/cmds-fi-disk_usage.h
@@ -19,10 +19,36 @@
 #ifndef __CMDS_FI_DISK_USAGE__
 #define __CMDS_FI_DISK_USAGE__
 
+#define DF_HUMAN_UNIT		(1<<0)
+
 extern const char * const cmd_filesystem_usage_usage[];
 int cmd_filesystem_usage(int argc, char **argv);
 
-extern const char * const cmd_device_disk_usage_usage[];
-int cmd_device_disk_usage(int argc, char **argv);
+struct device_info {
+	u64	devid;
+	char	path[BTRFS_DEVICE_PATH_NAME_MAX];
+	u64	size;
+};
+
+/*
+ * To store the size information about the chunks:
+ * the chunks info are grouped by the tuple (type, devid, num_stripes),
+ * i.e. if two chunks are of the same type (RAID1, DUP...), are on the
+ * same disk, have the same stripes then their sizes are grouped
+ */
+struct chunk_info {
+	u64	type;
+	u64	size;
+	u64	devid;
+	u64	num_stripes;
+};
+
+int load_device_info(int fd, struct device_info **device_info_ptr,
+		int *device_info_count);
+int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count);
+char *df_pretty_sizes(u64 size, int mode);
+void print_device_chunks(int fd, u64 devid, u64 total_size,
+		struct chunk_info *chunks_info_ptr,
+		int chunks_info_count, int mode);
 
 #endif
-- 
1.9.0

