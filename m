Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:48598 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaBMTTr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:19:47 -0500
Received: from venice.bhome (151.28.65.181) by outrelay08.libero.it (8.6.033) (authenticated as kreijack@libero.it)
        id 52EA6A1903103067 for linux-btrfs@vger.kernel.org; Thu, 13 Feb 2014 20:19:45 +0100
Message-ID: <52FD1AD6.50500@libero.it>
Date: Thu, 13 Feb 2014 20:19:50 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/8] Add command btrfs filesystem disk-usage
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <52FD1A72.5060307@libero.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-fi-disk_usage.c | 428 +++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-fi-disk_usage.h |   3 +
 cmds-filesystem.c    |   3 +
 utils.c              |  63 ++++++++
 utils.h              |   3 +
 5 files changed, 500 insertions(+)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 4012c78..16b3ab2 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -20,10 +20,12 @@
 #include <unistd.h>
 #include <sys/ioctl.h>
 #include <errno.h>
+#include <stdarg.h>
 
 #include "utils.h"
 #include "kerncompat.h"
 #include "ctree.h"
+#include "string_table.h"
 
 #include "commands.h"
 
@@ -44,6 +46,13 @@ struct chunk_info {
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
  * PAY ATTENTION: it return a statically buffer
@@ -514,3 +523,422 @@ int cmd_filesystem_df(int argc, char **argv)
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
+		description = group_type_str(flags);
+
+		table_printf(matrix, 1+i, 0, "<%s", description);
+	}
+
+	for (i = 0; i < sargs->total_spaces; i++) {
+		const char *r_mode;
+
+		u64 flags = sargs->spaces[i].flags;
+		r_mode = group_profile_str(flags);
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
+			u64 devid = disks_info_ptr[i].devid;
+			int	j;
+			u64 size = 0;
+
+			for (j = 0 ; j < chunks_info_count ; j++) {
+				if (chunks_info_ptr[j].type != flags )
+						continue;
+				if (chunks_info_ptr[j].devid != devid)
+						continue;
+
+				size += calc_chunk_size(chunks_info_ptr+j);
+			}
+
+			if (size)
+				table_printf(matrix, col, i+3,
+					">%s", df_pretty_sizes(size, mode));
+			else
+				table_printf(matrix, col, i+3, ">-");
+
+			total_allocated += size;
+			col++;
+		}
+
+		unused = get_partition_size(disks_info_ptr[i].path) -
+				total_allocated;
+
+		table_printf(matrix, sargs->total_spaces + 1, i + 3,
+			       ">%s", df_pretty_sizes(unused, mode));
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
+			df_pretty_sizes(sargs->spaces[i].total_bytes, mode));
+
+	table_printf(matrix, sargs->total_spaces+1, disks_info_count+4,
+		">%s", df_pretty_sizes(total_unused, mode));
+
+	table_printf(matrix, 0, disks_info_count+5, "<Used");
+	for (i = 0; i < sargs->total_spaces; i++)
+		table_printf(matrix, 1+i, disks_info_count+5, ">%s",
+			df_pretty_sizes(sargs->spaces[i].used_bytes, mode));
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
+
+		for (j = 0 ; j < info_count ; j++)
+			if (info_ptr[j].devid == disks_info_ptr[i].devid)
+				total += calc_chunk_size(info_ptr+j);
+
+		printf("   %s\t%10s\n",
+			disks_info_ptr[i].path,
+			df_pretty_sizes(disks_info_ptr[i].size - total, mode));
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
+		if (total > 0)
+			printf("   %s\t%10s\n",
+				disks_info_ptr[i].path,
+				df_pretty_sizes(total, mode));
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
+		description= group_type_str(flags);
+		r_mode = group_profile_str(flags);
+
+		printf("%s,%s: Size:%s, ",
+			description,
+			r_mode,
+			df_pretty_sizes(sargs->spaces[i].total_bytes ,
+			    mode));
+		printf("Used:%s\n",
+			df_pretty_sizes(sargs->spaces[i].used_bytes,
+					mode));
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
+		r = _cmd_filesystem_disk_usage(fd, argv[i], flags, tabular);
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
index fc85eef..d4cab63 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -798,6 +798,9 @@ const struct cmd_group filesystem_cmd_group = {
 		{ "balance", cmd_balance, NULL, &balance_cmd_group, 1 },
 		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
 		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
+		{ "disk-usage", cmd_filesystem_disk_usage,
+			cmd_filesystem_disk_usage_usage, NULL, 0 },
+
 		NULL_CMD_STRUCT
 	}
 };
diff --git a/utils.c b/utils.c
index 69295b5..8b27552 100644
--- a/utils.c
+++ b/utils.c
@@ -2121,3 +2121,66 @@ u64 disk_size(char *path)
 		return sfs.f_bsize * sfs.f_blocks;
 
 }
+
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
+
+
+
+/*
+ *  Convert a chunk type to a chunk description
+ */
+const char *group_type_str(u64 flag)
+{
+	switch (flag & BTRFS_BLOCK_GROUP_TYPE_MASK) {
+	case BTRFS_BLOCK_GROUP_DATA:
+		return "Data";
+	case BTRFS_BLOCK_GROUP_SYSTEM:
+		return "System";
+	case BTRFS_BLOCK_GROUP_METADATA:
+		return "Metadata";
+	case BTRFS_BLOCK_GROUP_DATA|BTRFS_BLOCK_GROUP_METADATA:
+		return "Data+Metadata";
+	default:
+		return "unknown";
+	}
+}
+
+/*
+ *  Convert a chunk type to a chunk profile description
+ */
+const char *group_profile_str(u64 flag)
+{
+	switch (flag & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+	case 0:
+		return "single";
+	case BTRFS_BLOCK_GROUP_RAID0:
+		return "RAID0";
+	case BTRFS_BLOCK_GROUP_RAID1:
+		return "RAID1";
+	case BTRFS_BLOCK_GROUP_RAID5:
+		return "RAID5";
+	case BTRFS_BLOCK_GROUP_RAID6:
+		return "RAID6";
+	case BTRFS_BLOCK_GROUP_DUP:
+		return "DUP";
+	case BTRFS_BLOCK_GROUP_RAID10:
+		return "RAID10";
+	default:
+		return "unknown";
+	}
+}
diff --git a/utils.h b/utils.h
index 58fb4a7..8469d4a 100644
--- a/utils.h
+++ b/utils.h
@@ -99,4 +99,7 @@ int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 u64 disk_size(char *path);
 int get_device_info(int fd, u64 devid,
 		struct btrfs_ioctl_dev_info_args *di_args);
+u64 get_partition_size(char *dev);
+const char * group_type_str(u64 flags);
+const char * group_profile_str(u64 flags);
 #endif
-- 
1.8.5.3



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
