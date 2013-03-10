Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm14.bullet.mail.ird.yahoo.com ([77.238.189.67]:48394 "HELO
	nm14.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751191Ab3CJMWo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 08:22:44 -0400
From: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Zach Brown <zab@zabbo.net>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/8] Add command btrfs filesystem disk-usage
Date: Sun, 10 Mar 2013 13:17:36 +0100
Message-Id: <1362917859-18824-6-git-send-email-goffredo.baroncelli@yahoo.com>
In-Reply-To: <1362917859-18824-1-git-send-email-goffredo.baroncelli@yahoo.com>
References: <1362917859-18824-1-git-send-email-goffredo.baroncelli@yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-fi-disk_usage.c |  432 ++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-fi-disk_usage.h |    3 +
 cmds-filesystem.c    |    2 +
 utils.c              |   58 +++++++
 utils.h              |    3 +
 5 files changed, 498 insertions(+)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 50b2fae..cb680e6 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -20,11 +20,13 @@
 #include <unistd.h>
 #include <sys/ioctl.h>
 #include <errno.h>
+#include <stdarg.h>
 
 #include "utils.h"
 #include "kerncompat.h"
 #include "ctree.h"
 #include "string_list.h"
+#include "string_table.h"
 
 #include "commands.h"
 
@@ -45,6 +47,13 @@ struct chunk_info {
 	u64	num_stripes;
 };
 
+/* to store information about the disks */
+struct disk_info {
+	u64	devid;
+	char	path[BTRFS_DEVICE_PATH_NAME_MAX];
+	u64	size;
+};
+
 /*
  * Pretty print the size
  */
@@ -528,3 +537,426 @@ int cmd_filesystem_df(int argc, char **argv)
 	return 0;
 }
 
+/*
+ *  Helper to sort the disk_info structure
+ */
+static int cmp_disk_info(const void *a, const void *b)
+{
+	return strcmp(((struct disk_info *)a)->path,
+			((struct disk_info *)b)->path);
+}
+
+/*
+ *  This function load the disk_info structure and put them in an array
+ */
+static int load_disks_info(int fd,
+			   struct disk_info **disks_info_ptr,
+			   int *disks_info_count)
+{
+
+	int ret, i, ndevs;
+	struct btrfs_ioctl_fs_info_args fi_args;
+	struct btrfs_ioctl_dev_info_args dev_info;
+	struct disk_info *info;
+
+	*disks_info_count = 0;
+	*disks_info_ptr = 0;
+
+	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &fi_args);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: cannot get filesystem info\n");
+		return -1;
+	}
+
+	info = malloc(sizeof(struct disk_info) * fi_args.num_devices);
+	if (!info) {
+		fprintf(stderr, "ERROR: not enough memory\n");
+		return -1;
+	}
+
+	for (i = 0, ndevs = 0 ; i <= fi_args.max_id ; i++) {
+
+		BUG_ON(ndevs >= fi_args.num_devices);
+		ret = get_device_info(fd, i, &dev_info);
+
+		if (ret == -ENODEV)
+			continue;
+		if (ret) {
+			fprintf(stderr,
+			    "ERROR: cannot get info about device devid=%d\n",
+			    i);
+			free(info);
+			return -1;
+		}
+
+		info[ndevs].devid = dev_info.devid;
+		strcpy(info[ndevs].path, (char *)dev_info.path);
+		info[ndevs].size = get_partition_size((char *)dev_info.path);
+		++ndevs;
+	}
+
+	BUG_ON(ndevs != fi_args.num_devices);
+	qsort(info, fi_args.num_devices,
+		sizeof(struct disk_info), cmp_disk_info);
+
+	*disks_info_count = fi_args.num_devices;
+	*disks_info_ptr = info;
+
+	return 0;
+
+}
+
+/*
+ *  This function computes the size of a chunk in a disk
+ */ 
+static u64 calc_chunk_size(struct chunk_info *ci)
+{
+	if (ci->type & BTRFS_BLOCK_GROUP_RAID0)
+		return ci->size / ci->num_stripes;
+	else if (ci->type & BTRFS_BLOCK_GROUP_RAID1)
+		return ci->size ;
+	else if (ci->type & BTRFS_BLOCK_GROUP_DUP)
+		return ci->size ;
+	else if (ci->type & BTRFS_BLOCK_GROUP_RAID5)
+		return ci->size / (ci->num_stripes -1);
+	else if (ci->type & BTRFS_BLOCK_GROUP_RAID6)
+		return ci->size / (ci->num_stripes -2);
+	else if (ci->type & BTRFS_BLOCK_GROUP_RAID10)
+		return ci->size / ci->num_stripes;
+	return ci->size;
+}
+
+/*
+ *  This function print the results of the command btrfs fi disk-usage
+ *  in tabular format
+ */
+static void _cmd_filesystem_disk_usage_tabular(int mode,
+					struct btrfs_ioctl_space_args *sargs,
+					struct chunk_info *chunks_info_ptr,
+					int chunks_info_count,
+					struct disk_info *disks_info_ptr,
+					int disks_info_count)
+{
+	int i;
+	u64 total_unused = 0;
+	struct string_table *matrix = 0;
+	int  ncols, nrows;
+	
+
+	ncols = sargs->total_spaces + 2;
+	nrows = 2 + 1 + disks_info_count + 1 + 2;
+
+	matrix = table_create(ncols, nrows);
+	if (!matrix) {
+		fprintf(stderr, "ERROR: not enough memory\n");
+		return;
+	}
+
+	/* header */
+	for (i = 0; i < sargs->total_spaces; i++) {
+		const char *description;
+
+		u64 flags = sargs->spaces[i].flags;
+		description = btrfs_flags2description(flags);
+
+		table_printf(matrix, 1+i, 0, "<%s", description);
+	}
+
+	for (i = 0; i < sargs->total_spaces; i++) {
+		const char *r_mode;
+
+		u64 flags = sargs->spaces[i].flags;
+		r_mode = btrfs_flags2profile(flags);
+
+		table_printf(matrix, 1+i, 1, "<%s", r_mode);
+	}
+
+	table_printf(matrix, 1+sargs->total_spaces, 1, "<Unallocated");
+
+	/* body */
+	for (i = 0 ; i < disks_info_count ; i++) {
+		int k, col;
+		char *p;
+
+		u64  total_allocated = 0, unused;
+
+		p = strrchr(disks_info_ptr[i].path, '/');
+		if (!p)
+			p = disks_info_ptr[i].path;
+		else
+			p++;
+
+		table_printf(matrix, 0, i+3, "<%s",
+				disks_info_ptr[i].path);
+
+		for (col = 1, k = 0 ; k < sargs->total_spaces ; k++)  {
+			u64	flags = sargs->spaces[k].flags;
+			int	j;
+
+			for (j = 0 ; j < chunks_info_count ; j++) {
+				u64 size = calc_chunk_size(chunks_info_ptr+j);
+
+				if (chunks_info_ptr[j].type != flags ||
+				    chunks_info_ptr[j].devid !=
+					disks_info_ptr[i].devid)
+						continue;
+
+				table_printf(matrix, col, i+3,
+					">%s", sla_pretty_sizes(size, mode));
+				total_allocated += size;
+				col++;
+				break;
+
+			}
+			if (j == chunks_info_count) {
+				table_printf(matrix, col, i+3, ">-");
+				col++;
+			}
+		}
+
+		unused = get_partition_size(disks_info_ptr[i].path) -
+				total_allocated;
+
+		table_printf(matrix, sargs->total_spaces + 1, i + 3,
+			       ">%s", sla_pretty_sizes(unused, mode));
+		total_unused += unused;
+
+	}
+
+	for (i = 0; i <= sargs->total_spaces; i++)
+		table_printf(matrix, i + 1, disks_info_count + 3, "=");
+
+
+	/* footer */
+	table_printf(matrix, 0, disks_info_count + 4, "<Total");
+	for (i = 0; i < sargs->total_spaces; i++)
+		table_printf(matrix, 1 + i, disks_info_count + 4,
+			">%s",
+			sla_pretty_sizes(sargs->spaces[i].total_bytes, mode));
+
+	table_printf(matrix, sargs->total_spaces+1, disks_info_count+4,
+		">%s", sla_pretty_sizes(total_unused, mode));
+
+	table_printf(matrix, 0, disks_info_count+5, "<Used");
+	for (i = 0; i < sargs->total_spaces; i++)
+		table_printf(matrix, 1+i, disks_info_count+5, ">%s",
+			sla_pretty_sizes(sargs->spaces[i].used_bytes, mode));
+
+
+	table_dump(matrix);
+	table_free(matrix);
+
+}
+
+/*
+ *  This function prints the unused space per every disk
+ */
+static void print_unused(struct chunk_info *info_ptr,
+			  int info_count,
+			  struct disk_info *disks_info_ptr,
+			  int disks_info_count,
+			  int mode)
+{
+	int i;
+	for (i = 0 ; i < disks_info_count ; i++) {
+
+		int	j;
+		u64	total = 0;
+		char	*s;
+
+		for (j = 0 ; j < info_count ; j++)
+			if (info_ptr[j].devid == disks_info_ptr[i].devid)
+				total += calc_chunk_size(info_ptr+j);
+
+		s = sla_pretty_sizes(disks_info_ptr[i].size - total, mode);
+		printf("   %s\t%10s\n", disks_info_ptr[i].path, s);
+
+	}
+
+}
+
+/*
+ *  This function prints the allocated chunk per every disk
+ */
+static void print_chunk_disks(u64 chunk_type,
+				struct chunk_info *chunks_info_ptr,
+				int chunks_info_count,
+				struct disk_info *disks_info_ptr,
+				int disks_info_count,
+				int mode)
+{
+	int i;
+
+	for (i = 0 ; i < disks_info_count ; i++) {
+
+		int	j;
+		u64	total = 0;
+		char	*s;
+
+		for (j = 0 ; j < chunks_info_count ; j++) {
+
+			if (chunks_info_ptr[j].type != chunk_type)
+				continue;
+			if (chunks_info_ptr[j].devid != disks_info_ptr[i].devid)
+				continue;
+
+			total += calc_chunk_size(&(chunks_info_ptr[j]));
+			//total += chunks_info_ptr[j].size;
+		}
+
+		if (total > 0) {
+			s = sla_pretty_sizes(total, mode);
+			printf("   %s\t%10s\n", disks_info_ptr[i].path, s);
+		}
+	}
+}
+
+/*
+ *  This function print the results of the command btrfs fi disk-usage
+ *  in linear format
+ */
+static void _cmd_filesystem_disk_usage_linear(int mode,
+					struct btrfs_ioctl_space_args *sargs,
+					struct chunk_info *info_ptr,
+					int info_count,
+					struct disk_info *disks_info_ptr,
+					int disks_info_count)
+{
+	int i;
+
+	for (i = 0; i < sargs->total_spaces; i++) {
+		const char *description;
+		const char *r_mode;
+
+		u64 flags = sargs->spaces[i].flags;
+		description= btrfs_flags2description(flags);
+		r_mode = btrfs_flags2profile(flags);
+
+		printf("%s,%s: Size:%s, Used:%s\n",
+			description,
+			r_mode,
+			sla_pretty_sizes(sargs->spaces[i].total_bytes ,
+			    mode),
+			sla_pretty_sizes(sargs->spaces[i].used_bytes,
+					mode));
+
+		print_chunk_disks(flags, info_ptr, info_count,
+				disks_info_ptr, disks_info_count,
+				mode);
+		printf("\n");
+
+	}
+
+	printf("Unallocated:\n");
+	print_unused(info_ptr, info_count,
+			disks_info_ptr, disks_info_count,
+			mode);
+
+
+
+}
+
+static int _cmd_filesystem_disk_usage(int fd, char *path, int mode, int tabular)
+{
+	struct btrfs_ioctl_space_args *sargs = 0;
+	int info_count = 0;
+	struct chunk_info *info_ptr = 0;
+	struct disk_info *disks_info_ptr = 0;
+	int disks_info_count = 0;
+	int ret = 0;
+
+	if (load_chunk_info(fd, &info_ptr, &info_count) ||
+	    load_disks_info(fd, &disks_info_ptr, &disks_info_count)) {
+		ret = -1;
+		goto exit;
+	}
+
+	if ((sargs = load_space_info(fd, path)) == NULL) {
+		ret = -1;
+		goto exit;
+	}
+
+	if (tabular)
+		_cmd_filesystem_disk_usage_tabular(mode, sargs,
+					info_ptr, info_count,
+					disks_info_ptr, disks_info_count);
+	else
+		_cmd_filesystem_disk_usage_linear(mode, sargs,
+					info_ptr, info_count,
+					disks_info_ptr, disks_info_count);
+
+exit:
+
+	string_list_free();
+	if (sargs)
+		free(sargs);
+	if (disks_info_ptr)
+		free(disks_info_ptr);
+	if (info_ptr)
+		free(info_ptr);
+
+	return ret;
+}
+
+const char * const cmd_filesystem_disk_usage_usage[] = {
+	"btrfs filesystem disk-usage [-b][-t] <path> [<path>..]",
+	"Show in which disk the chunks are allocated.",
+	"",
+	"-b\tSet byte as unit",
+	"-t\tShow data in tabular format",
+	NULL
+};
+
+int cmd_filesystem_disk_usage(int argc, char **argv)
+{
+
+	int	flags =	DF_HUMAN_UNIT;
+	int	i, more_than_one = 0;
+	int	tabular = 0;
+
+	optind = 1;
+	while (1) {
+		char	c = getopt(argc, argv, "bt");
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'b':
+			flags &= ~DF_HUMAN_UNIT;
+			break;
+		case 't':
+			tabular = 1;
+			break;
+		default:
+			usage(cmd_filesystem_disk_usage_usage);
+		}
+	}
+
+	if (check_argc_min(argc - optind, 1)) {
+		usage(cmd_filesystem_disk_usage_usage);
+		return 21;
+	}
+
+	for (i = optind; i < argc ; i++) {
+		int r, fd;
+		if (more_than_one)
+			printf("\n");
+
+		fd = open_file_or_dir(argv[i]);
+		if (fd < 0) {
+			fprintf(stderr, "ERROR: can't access to '%s'\n",
+				argv[1]);
+			return 12;
+		}
+		r = _cmd_filesystem_disk_usage(fd, argv[i], flags, tabular);
+		close(fd);
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
+
diff --git a/cmds-fi-disk_usage.h b/cmds-fi-disk_usage.h
index 9f68bb3..c7459b1 100644
--- a/cmds-fi-disk_usage.h
+++ b/cmds-fi-disk_usage.h
@@ -22,4 +22,7 @@
 extern const char * const cmd_filesystem_df_usage[];
 int cmd_filesystem_df(int argc, char **argv);
 
+extern const char * const cmd_filesystem_disk_usage_usage[];
+int cmd_filesystem_disk_usage(int argc, char **argv);
+
 #endif
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 5301dc3..e9eb0c4 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -403,6 +403,8 @@ const struct cmd_group filesystem_cmd_group = {
 		{ "balance", cmd_balance, NULL, &balance_cmd_group, 1 },
 		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
 		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
+		{ "disk-usage", cmd_filesystem_disk_usage,
+			cmd_filesystem_disk_usage_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 },
 	}
 };
diff --git a/utils.c b/utils.c
index 029729c..60f05e4 100644
--- a/utils.c
+++ b/utils.c
@@ -1400,3 +1400,61 @@ u64 disk_size(char *path)
 
 }
 
+u64 get_partition_size(char *dev)
+{
+	u64 result;
+	int fd = open(dev, O_RDONLY);
+
+	if (fd < 0)
+		return 0;
+	if (ioctl(fd, BLKGETSIZE64, &result) < 0) {
+		close(fd);
+		return 0;
+	}
+	close(fd);
+
+	return result;
+}
+
+/*
+ *  Convert a chunk type to a chunk description
+ */
+const char * btrfs_flags2description(u64 flags)
+{
+	if (flags & BTRFS_BLOCK_GROUP_DATA) {
+		if (flags & BTRFS_BLOCK_GROUP_METADATA)
+			return "Data+Metadata";
+		else
+			return "Data";
+	} else if (flags & BTRFS_BLOCK_GROUP_SYSTEM) {
+		return "System";
+	} else if (flags & BTRFS_BLOCK_GROUP_METADATA) {
+		return "Metadata";
+	} else {
+		return "Unknown";
+	}
+}
+
+/*
+ *  Convert a chunk type to a chunk profile description
+ */
+const char * btrfs_flags2profile(u64 flags)
+{
+	if (flags & BTRFS_BLOCK_GROUP_RAID0) {
+		return "RAID0";
+	} else if (flags & BTRFS_BLOCK_GROUP_RAID1) {
+		return "RAID1";
+	} else if (flags & BTRFS_BLOCK_GROUP_RAID5) {
+		return "RAID5";
+	} else if (flags & BTRFS_BLOCK_GROUP_RAID6) {
+		return "RAID6";
+	} else if (flags & BTRFS_BLOCK_GROUP_DUP) {
+		return "DUP";
+	} else if (flags & BTRFS_BLOCK_GROUP_RAID10) {
+		return "RAID10";
+	} else {
+		return "Single";
+	}
+}
+
+
diff --git a/utils.h b/utils.h
index 7974d00..84fdd0e 100644
--- a/utils.h
+++ b/utils.h
@@ -60,4 +60,7 @@ char *__strncpy__null(char *dest, const char *src, size_t n);
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 
 u64 disk_size(char *path);
+u64 get_partition_size(char *dev);
+const char * btrfs_flags2profile(u64 flags);
+const char * btrfs_flags2description(u64 flags);
 #endif
-- 
1.7.10.4

