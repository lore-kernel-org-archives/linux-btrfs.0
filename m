Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44956 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933895Ab2KBKPE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 06:15:04 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1719891eek.19
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 03:15:03 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/8] Add command btrfs filesystem disk-usage
Date: Fri,  2 Nov 2012 11:15:36 +0100
Message-Id: <1351851339-19150-6-git-send-email-kreijack@inwind.it>
In-Reply-To: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-fi-disk_usage.c |  662 +++++++++++++++++++++++++++++++++++++++++++++++++-
 cmds-fi-disk_usage.h |    2 +
 cmds-filesystem.c    |    2 +
 utils.c              |   15 ++
 utils.h              |    1 +
 5 files changed, 680 insertions(+), 2 deletions(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 9131c47..4bec167 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -20,6 +20,7 @@
 #include <unistd.h>
 #include <sys/ioctl.h>
 #include <errno.h>
+#include <stdarg.h>
 
 #include "utils.h"
 #include "kerncompat.h"
@@ -31,14 +32,14 @@
 
 #define DF_HUMAN_UNIT		(1<<0)
 
-/* to store the information about the chunk */
+/* to store the information about the chunks */
 struct chunk_info {
 	u64	type;
 	u64	size;
 	u64	devid;
-	int	processed:1;
 };
 
+/* to store information about the disks */
 struct disk_info {
 	u64	devid;
 	char	path[BTRFS_DEVICE_PATH_NAME_MAX];
@@ -79,6 +80,95 @@ static void free_strings_to_free()
 	count_string_to_free = 0;
 }
 
+static int cmd_info_add_info(struct chunk_info **info_ptr,
+			int *info_count,
+			struct btrfs_chunk *chunk)
+{
+
+	u64	type = btrfs_stack_chunk_type(chunk);
+	u64	size = btrfs_stack_chunk_length(chunk);
+	int	num_stripes = btrfs_stack_chunk_num_stripes(chunk);
+	int	sub_stripes = btrfs_stack_chunk_sub_stripes(chunk);
+	int	j;
+
+	for (j = 0 ; j < num_stripes ; j++) {
+		int i;
+		struct chunk_info *p = 0;
+		struct btrfs_stripe *stripe;
+		u64    devid;
+
+		stripe = btrfs_stripe_nr(chunk, j);
+		devid = btrfs_stack_stripe_devid(stripe);
+
+		for (i = 0 ; i < *info_count ; i++)
+			if ((*info_ptr)[i].type == type &&
+			    (*info_ptr)[i].devid == devid) {
+				p = (*info_ptr) + i;
+				break;
+			}
+
+		if (!p) {
+			int size = sizeof(struct btrfs_chunk) * (*info_count+1);
+			struct chunk_info *res = realloc(*info_ptr, size);
+
+			if (!res) {
+				fprintf(stderr, "ERROR: not enough memory\n");
+				return -1;
+			}
+
+			*info_ptr = res;
+			p = res + *info_count;
+			(*info_count)++;
+
+			p->devid = devid;
+			p->type = type;
+			p->size = 0;
+		}
+
+		if (type & (BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_DUP))
+			p->size += size;
+		else if (type & BTRFS_BLOCK_GROUP_RAID10)
+			p->size += size / (num_stripes / sub_stripes);
+		else
+			p->size += size / num_stripes;
+
+	}
+
+	return 0;
+
+}
+
+static void btrfs_flags2description(u64 flags, char **description)
+{
+	if (flags & BTRFS_BLOCK_GROUP_DATA) {
+		if (flags & BTRFS_BLOCK_GROUP_METADATA)
+			*description = "Data+Metadata";
+		else
+			*description = "Data";
+	} else if (flags & BTRFS_BLOCK_GROUP_SYSTEM) {
+		*description = "System";
+	} else if (flags & BTRFS_BLOCK_GROUP_METADATA) {
+		*description = "Metadata";
+	} else {
+		*description = "Unknown";
+	}
+}
+
+static void btrfs_flags2profile(u64 flags, char **profile)
+{
+	if (flags & BTRFS_BLOCK_GROUP_RAID0) {
+		*profile = "RAID0";
+	} else if (flags & BTRFS_BLOCK_GROUP_RAID1) {
+		*profile = "RAID1";
+	} else if (flags & BTRFS_BLOCK_GROUP_DUP) {
+		*profile = "DUP";
+	} else if (flags & BTRFS_BLOCK_GROUP_RAID10) {
+		*profile = "RAID10";
+	} else {
+		*profile = "Single";
+	}
+}
+
 static char *df_pretty_sizes(u64 size, int mode)
 {
 	char *s;
@@ -332,3 +422,571 @@ int cmd_filesystem_df(int argc, char **argv)
 	return 0;
 }
 
+static int cmp_chunk_info(const void *a, const void *b)
+{
+	return cmp_chunk_block_group(
+		((struct chunk_info *)a)->type,
+		((struct chunk_info *)b)->type);
+}
+
+static int load_chunk_info(int fd,
+			  struct chunk_info **info_ptr,
+			  int *info_count)
+{
+
+	int ret;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header *sh;
+	unsigned long off = 0;
+	int i, e;
+
+
+	memset(&args, 0, sizeof(args));
+
+	/*
+	 * there may be more than one ROOT_ITEM key if there are
+	 * snapshots pending deletion, we have to loop through
+	 * them.
+	 */
+
+
+	sk->tree_id = BTRFS_CHUNK_TREE_OBJECTID;
+
+	sk->min_objectid = 0;
+	sk->max_objectid = (u64)-1;
+	sk->max_type = 0;
+	sk->min_type = (u8)-1;
+	sk->min_offset = 0;
+	sk->max_offset = (u64)-1;
+	sk->min_transid = 0;
+	sk->max_transid = (u64)-1;
+	sk->nr_items = 4096;
+
+	while (1) {
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		e = errno;
+		if (ret < 0) {
+			fprintf(stderr,
+				"ERROR: can't perform the search - %s\n",
+				strerror(e));
+			return 0;
+		}
+		/* the ioctl returns the number of item it found in nr_items */
+
+		if (sk->nr_items == 0)
+			break;
+
+		off = 0;
+		for (i = 0; i < sk->nr_items; i++) {
+			struct btrfs_chunk *item;
+			sh = (struct btrfs_ioctl_search_header *)(args.buf +
+								  off);
+
+			off += sizeof(*sh);
+			item = (struct btrfs_chunk *)(args.buf + off);
+
+			if (cmd_info_add_info(info_ptr, info_count, item)) {
+				*info_ptr = 0;
+				free(*info_ptr);
+				return 100;
+			}
+
+			off += sh->len;
+
+			sk->min_objectid = sh->objectid;
+			sk->min_type = sh->type;
+			sk->min_offset = sh->offset+1;
+
+		}
+		if (!sk->min_offset)	/* overflow */
+			sk->min_type++;
+		else
+			continue;
+
+		if (!sk->min_type)
+			sk->min_objectid++;
+		 else
+			continue;
+
+		if (!sk->min_objectid)
+			break;
+	}
+
+	qsort(*info_ptr, *info_count, sizeof(struct chunk_info),
+		cmp_chunk_info);
+
+	return 0;
+
+}
+
+static int cmp_disk_info(const void *a, const void *b)
+{
+	return strcmp(((struct disk_info *)a)->path,
+			((struct disk_info *)b)->path);
+}
+
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
+				total += info_ptr[j].size;
+
+		s = df_pretty_sizes(disks_info_ptr[i].size - total, mode);
+		printf("   %s\t%10s\n", disks_info_ptr[i].path, s);
+
+	}
+
+}
+
+static void print_chunk_disks(u64 chunk_type,
+				struct chunk_info *chunks_info_ptr,
+				int chunks_info_count,
+				struct disk_info *disks_info_ptr,
+				int disks_info_count,
+				int mode)
+{
+	int i;
+	for (i = 0 ; i < disks_info_count ; i++) {
+
+		int	j;
+		u64	total = 0;
+		char	*s;
+
+		for (j = 0 ; j < chunks_info_count ; j++) {
+			if (chunks_info_ptr[j].type != chunk_type)
+				continue;
+			if (chunks_info_ptr[j].devid != disks_info_ptr[i].devid)
+				continue;
+
+			total += chunks_info_ptr[j].size;
+		}
+
+		if (total > 0) {
+			s = df_pretty_sizes(total, mode);
+			printf("   %s\t%10s\n", disks_info_ptr[i].path, s);
+		}
+	}
+}
+
+static char **create_table(int columns, int rows)
+{
+	char **p = calloc(rows * columns, sizeof(char *));
+	if (p)
+		add_strings_to_free((char *)p);
+	return p;
+}
+
+/*
+ * If fmt  starts with '<', the text is left aligned; if fmt starts with
+ * '>' the text is right aligned. If fmt is equal to '=' the text will
+ * be replaced by a '=====' dimensioned in the basis of the column width
+ */
+static char *vprintf_table(char **p, int num_cols, int column, int row,
+			  char *fmt, va_list ap)
+{
+	int idx =  num_cols*row+column;
+	char *msg = calloc(100, sizeof(char));
+
+	if (!msg)
+		return NULL;
+
+	add_strings_to_free(msg);
+	p[idx] = msg;
+	vsnprintf(msg, 99, fmt, ap);
+
+	return msg;
+}
+
+static char *printf_table(char **p, int num_cols, int column, int row,
+			  char *fmt, ...)
+{
+	va_list ap;
+	char *ret;
+
+	va_start(ap, fmt);
+	ret = vprintf_table(p, num_cols, column, row, fmt, ap);
+	va_end(ap);
+
+	return ret;
+}
+
+static void dump_table(char **p, int ncols, int nrows)
+{
+	int	sizes[ncols];
+	int	i, j;
+
+	for (i = 0 ; i < ncols ; i++) {
+		sizes[i] = 0;
+		for (j = 0 ; j < nrows ; j++) {
+			int idx = i + j*ncols;
+			int s;
+
+			if (!p[idx])
+				continue;
+
+			s = strlen(p[idx]) - 1;
+			if (s < 1 || p[idx][0] == '=')
+				continue;
+
+			if (s > sizes[i])
+				sizes[i] = s;
+		}
+	}
+
+
+	for (j = 0 ; j < nrows ; j++) {
+		for (i = 0 ; i < ncols ; i++) {
+
+			int idx = i + j*ncols;
+
+			if (!p[idx] || !strlen(p[idx])) {
+				printf("%*s", sizes[i], "");
+			} else if (p[idx][0] == '=') {
+				int k;
+				for (k = 0 ; k < sizes[i] ; k++)
+					putchar('=');
+			} else {
+				printf("%*s",
+					p[idx][0] == '<' ? -sizes[i] : sizes[i],
+					p[idx]+1);
+			}
+			if (i != (ncols - 1))
+				putchar(' ');
+		}
+		putchar('\n');
+	}
+
+}
+
+
+static void _cmd_filesystem_disk_usage_tabular(int mode,
+					struct btrfs_ioctl_space_args *sargs,
+					struct chunk_info *chunks_info_ptr,
+					int chunks_info_count,
+					struct disk_info *disks_info_ptr,
+					int disks_info_count)
+{
+	int i;
+	u64 total_unused = 0;
+	char **matrix = 0;
+	int  ncols, nrows;
+
+	ncols = sargs->total_spaces + 2;
+	nrows = 2 + 1 + disks_info_count + 1 + 2;
+
+	matrix = create_table(ncols, nrows);
+	if (!matrix) {
+		fprintf(stderr, "ERROR: not enough memory\n");
+		return;
+	}
+
+	/* header */
+	for (i = 0; i < sargs->total_spaces; i++) {
+		char *description;
+
+		u64 flags = sargs->spaces[i].flags;
+		btrfs_flags2description(flags, &description);
+
+		printf_table(matrix, ncols, 1+i, 0, "<%s", description);
+	}
+
+	for (i = 0; i < sargs->total_spaces; i++) {
+		char *r_mode;
+
+		u64 flags = sargs->spaces[i].flags;
+		btrfs_flags2profile(flags, &r_mode);
+
+		printf_table(matrix, ncols, 1+i, 1, "<%s", r_mode);
+	}
+
+	printf_table(matrix, ncols, 1+sargs->total_spaces, 1, "<Unallocated");
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
+		printf_table(matrix, ncols, 0, i+3, "<%s",
+				disks_info_ptr[i].path);
+
+		for (col = 1, k = 0 ; k < sargs->total_spaces ; k++)  {
+			u64	flags = sargs->spaces[k].flags;
+			int	j;
+
+			for (j = 0 ; j < chunks_info_count ; j++) {
+				u64 size = chunks_info_ptr[j].size;
+
+				if (chunks_info_ptr[j].type != flags ||
+				    chunks_info_ptr[j].devid !=
+					disks_info_ptr[i].devid)
+						continue;
+
+				printf_table(matrix, ncols, col, i+3,
+					">%s", df_pretty_sizes(size, mode));
+				total_allocated += size;
+				col++;
+				break;
+
+			}
+			if (j == chunks_info_count) {
+				printf_table(matrix, ncols, col, i+3, ">-");
+				col++;
+			}
+		}
+
+		unused = get_partition_size(disks_info_ptr[i].path) -
+				total_allocated;
+
+		printf_table(matrix, ncols, sargs->total_spaces + 1, i + 3,
+			       ">%s", df_pretty_sizes(unused, mode));
+		total_unused += unused;
+
+	}
+
+	for (i = 0; i <= sargs->total_spaces; i++)
+		printf_table(matrix, ncols, i + 1, disks_info_count + 3, "=");
+
+
+	/* footer */
+	printf_table(matrix, ncols, 0, disks_info_count + 4, "<Total");
+	for (i = 0; i < sargs->total_spaces; i++)
+		printf_table(matrix, ncols, 1 + i, disks_info_count + 4,
+			">%s",
+			df_pretty_sizes(sargs->spaces[i].total_bytes, mode));
+
+	printf_table(matrix, ncols, sargs->total_spaces+1, disks_info_count+4,
+		">%s", df_pretty_sizes(total_unused, mode));
+
+	printf_table(matrix, ncols, 0, disks_info_count+5, "<Used");
+	for (i = 0; i < sargs->total_spaces; i++)
+		printf_table(matrix, ncols, 1+i, disks_info_count+5,
+			">%s",
+			df_pretty_sizes(sargs->spaces[i].used_bytes, mode));
+
+
+	dump_table(matrix, ncols, nrows);
+
+}
+
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
+		char *description;
+		char *r_mode;
+
+		u64 flags = sargs->spaces[i].flags;
+		btrfs_flags2description(flags, &description);
+		btrfs_flags2profile(flags, &r_mode);
+
+		printf("%s,%s: Size:%s, Used:%s\n",
+			description,
+			r_mode,
+			df_pretty_sizes(sargs->spaces[i].total_bytes ,
+			    mode),
+			df_pretty_sizes(sargs->spaces[i].used_bytes,
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
+	free_strings_to_free();
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
index 9f68bb3..ae11570 100644
--- a/cmds-fi-disk_usage.h
+++ b/cmds-fi-disk_usage.h
@@ -21,5 +21,7 @@
 
 extern const char * const cmd_filesystem_df_usage[];
 int cmd_filesystem_df(int argc, char **argv);
+extern const char * const cmd_filesystem_disk_usage_usage[];
+int cmd_filesystem_disk_usage(int argc, char **argv);
 
 #endif
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 1b915e4..7a833b4 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -423,6 +423,8 @@ const struct cmd_group filesystem_cmd_group = {
 		{ "balance", cmd_balance, NULL, &balance_cmd_group, 1 },
 		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
 		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
+		{ "disk-usage", cmd_filesystem_disk_usage,
+			cmd_filesystem_disk_usage_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 },
 	}
 };
diff --git a/utils.c b/utils.c
index 023fbca..2b12890 100644
--- a/utils.c
+++ b/utils.c
@@ -1341,3 +1341,18 @@ u64 disk_size(char *path)
 
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
diff --git a/utils.h b/utils.h
index 34a814d..e1caaae 100644
--- a/utils.h
+++ b/utils.h
@@ -56,4 +56,5 @@ int get_mountpt(char *dev, char *mntpt, size_t size);
 
 int btrfs_scan_block_devices(int run_ioctl);
 u64 disk_size(char *path);
+u64 get_partition_size(char *dev);
 #endif
-- 
1.7.10.4

