Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:35665 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaBMTS6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:18:58 -0500
Received: from venice.bhome (151.28.65.181) by outrelay06.libero.it (8.6.033) (authenticated as kreijack@libero.it)
        id 52EA67DC0314F882 for linux-btrfs@vger.kernel.org; Thu, 13 Feb 2014 20:18:56 +0100
Message-ID: <52FD1AA5.4070007@libero.it>
Date: Thu, 13 Feb 2014 20:19:01 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/8] Enhance the command btrfs filesystem df.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <52FD1A72.5060307@libero.it>


Enhance the command "btrfs filesystem df" to show space usage information
for a mount point(s). It shows also an estimation of the space available,
on the basis of the current one used.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Makefile             |   3 +-
 cmds-fi-disk_usage.c | 516 +++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-fi-disk_usage.h |  25 +++
 cmds-filesystem.c    |  91 +--------
 ctree.h              |  17 +-
 utils.c              |  13 ++
 utils.h              |   2 +
 7 files changed, 575 insertions(+), 92 deletions(-)
 create mode 100644 cmds-fi-disk_usage.c
 create mode 100644 cmds-fi-disk_usage.h

diff --git a/Makefile b/Makefile
index 0874a41..db470b6 100644
--- a/Makefile
+++ b/Makefile
@@ -13,7 +13,8 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
-	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o
+	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
+	       cmds-fi-disk_usage.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
 		   uuid-tree.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
new file mode 100644
index 0000000..4012c78
--- /dev/null
+++ b/cmds-fi-disk_usage.c
@@ -0,0 +1,516 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+
+#include "utils.h"
+#include "kerncompat.h"
+#include "ctree.h"
+
+#include "commands.h"
+
+#include "version.h"
+
+#define DF_HUMAN_UNIT		(1<<0)
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
+/*
+ * Pretty print the size
+ * PAY ATTENTION: it return a statically buffer
+ */
+static char *df_pretty_sizes(u64 size, int mode)
+{
+	static char buf[30];
+
+	if (mode & DF_HUMAN_UNIT)
+		(void)pretty_size_snprintf(size, buf, sizeof(buf));
+	else
+		sprintf(buf, "%llu", size);
+
+	return buf;
+}
+
+/*
+ * Add the chunk info to the chunk_info list
+ */
+static int add_info_to_list(struct chunk_info **info_ptr,
+			int *info_count,
+			struct btrfs_chunk *chunk)
+{
+
+	u64 type = btrfs_stack_chunk_type(chunk);
+	u64 size = btrfs_stack_chunk_length(chunk);
+	int num_stripes = btrfs_stack_chunk_num_stripes(chunk);
+	int j;
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
+			    (*info_ptr)[i].devid == devid &&
+			    (*info_ptr)[i].num_stripes == num_stripes ) {
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
+			p->num_stripes = num_stripes;
+		}
+
+		p->size += size;
+
+	}
+
+	return 0;
+
+}
+
+/*
+ *  Helper to sort the chunk type
+ */
+static int cmp_chunk_block_group(u64 f1, u64 f2)
+{
+
+	u64 mask;
+
+	if ((f1 & BTRFS_BLOCK_GROUP_TYPE_MASK) ==
+		(f2 & BTRFS_BLOCK_GROUP_TYPE_MASK))
+			mask = BTRFS_BLOCK_GROUP_PROFILE_MASK;
+	else if (f2 & BTRFS_BLOCK_GROUP_SYSTEM)
+			return -1;
+	else if (f1 & BTRFS_BLOCK_GROUP_SYSTEM)
+			return +1;
+	else
+			mask = BTRFS_BLOCK_GROUP_TYPE_MASK;
+
+	if ((f1 & mask) > (f2 & mask))
+		return +1;
+	else if ((f1 & mask) < (f2 & mask))
+		return -1;
+	else
+		return 0;
+}
+
+/*
+ * Helper to sort the chunk
+ */
+static int cmp_chunk_info(const void *a, const void *b)
+{
+	return cmp_chunk_block_group(
+		((struct chunk_info *)a)->type,
+		((struct chunk_info *)b)->type);
+}
+
+/*
+ * This function load all the chunk info from the 'fd' filesystem
+ */
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
+			return -99;
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
+			if (add_info_to_list(info_ptr, info_count, item)) {
+				*info_ptr = 0;
+				free(*info_ptr);
+				return -100;
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
+/*
+ * Helper to sort the struct btrfs_ioctl_space_info
+ */
+static int cmp_btrfs_ioctl_space_info(const void *a, const void *b)
+{
+	return cmp_chunk_block_group(
+		((struct btrfs_ioctl_space_info *)a)->flags,
+		((struct btrfs_ioctl_space_info *)b)->flags);
+}
+
+/*
+ * This function load all the information about the space usage
+ */
+static struct btrfs_ioctl_space_args *load_space_info(int fd, char *path)
+{
+	struct btrfs_ioctl_space_args *sargs = 0, *sargs_orig = 0;
+	int e, ret, count;
+
+	sargs_orig = sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
+	if (!sargs) {
+		fprintf(stderr, "ERROR: not enough memory\n");
+		return NULL;
+	}
+
+	sargs->space_slots = 0;
+	sargs->total_spaces = 0;
+
+	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
+	e = errno;
+	if (ret) {
+		fprintf(stderr,
+			"ERROR: couldn't get space info on '%s' - %s\n",
+			path, strerror(e));
+		free(sargs);
+		return NULL;
+	}
+	if (!sargs->total_spaces) {
+		free(sargs);
+		printf("No chunks found\n");
+		return NULL;
+	}
+
+	count = sargs->total_spaces;
+
+	sargs = realloc(sargs, sizeof(struct btrfs_ioctl_space_args) +
+			(count * sizeof(struct btrfs_ioctl_space_info)));
+	if (!sargs) {
+		free(sargs_orig);
+		fprintf(stderr, "ERROR: not enough memory\n");
+		return NULL;
+	}
+
+	sargs->space_slots = count;
+	sargs->total_spaces = 0;
+
+	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
+	e = errno;
+
+	if (ret) {
+		fprintf(stderr,
+			"ERROR: couldn't get space info on '%s' - %s\n",
+			path, strerror(e));
+		free(sargs);
+		return NULL;
+	}
+
+	qsort(&(sargs->spaces), count, sizeof(struct btrfs_ioctl_space_info),
+		cmp_btrfs_ioctl_space_info);
+
+	return sargs;
+}
+
+/*
+ * This function computes the space occuped by a *single* RAID5/RAID6 chunk.
+ * The computation is performed on the basis of the number of stripes
+ * which compose the chunk, which could be different from the number of disks
+ * if a disk is added later.
+ */
+static int get_raid56_used(int fd, u64 *raid5_used, u64 *raid6_used)
+{
+	struct chunk_info *info_ptr=0, *p;
+	int info_count=0;
+	int ret;
+
+	*raid5_used = *raid6_used =0;
+
+	ret = load_chunk_info(fd, &info_ptr, &info_count);
+	if( ret < 0)
+		return ret;
+
+	for ( p = info_ptr; info_count ; info_count--, p++ ) {
+		if (p->type & BTRFS_BLOCK_GROUP_RAID5)
+			(*raid5_used) += p->size / (p->num_stripes -1);
+		if (p->type & BTRFS_BLOCK_GROUP_RAID6)
+			(*raid6_used) += p->size / (p->num_stripes -2);
+	}
+
+	return 0;
+
+}
+
+static int _cmd_disk_free(int fd, char *path, int mode)
+{
+	struct btrfs_ioctl_space_args *sargs = 0;
+	int i;
+	int ret = 0;
+	int e, width;
+	u64 total_disk;		/* filesystem size == sum of
+				   disks sizes */
+	u64 total_chunks;	/* sum of chunks sizes on disk(s) */
+	u64 total_used;		/* logical space used */
+	u64 total_free;		/* logical space un-used */
+	double K;
+	u64 raid5_used, raid6_used;
+
+	if ((sargs = load_space_info(fd, path)) == NULL) {
+		ret = -1;
+		goto exit;
+	}
+
+	total_disk = disk_size(path);
+	e = errno;
+	if (total_disk == 0) {
+		fprintf(stderr,
+			"ERROR: couldn't get space info on '%s' - %s\n",
+			path, strerror(e));
+
+		ret = 19;
+		goto exit;
+	}
+	if (get_raid56_used(fd, &raid5_used, &raid6_used) < 0) {
+		fprintf(stderr,
+			"ERROR: couldn't get space info on '%s'\n",
+			path );
+		ret = 20;
+		goto exit;
+	}
+
+	total_chunks = total_used = total_free = 0;
+
+	for (i = 0; i < sargs->total_spaces; i++) {
+		float ratio = 1;
+		u64 allocated;
+		u64 flags = sargs->spaces[i].flags;
+
+		/*
+		 * The raid5/raid6 ratio depends by the stripes number
+		 * used by every chunk. It is computed separately
+		 */
+		if (flags & BTRFS_BLOCK_GROUP_RAID0)
+			ratio = 1;
+		else if (flags & BTRFS_BLOCK_GROUP_RAID1)
+			ratio = 2;
+		else if (flags & BTRFS_BLOCK_GROUP_RAID5)
+			ratio = 0;
+		else if (flags & BTRFS_BLOCK_GROUP_RAID6)
+			ratio = 0;
+		else if (flags & BTRFS_BLOCK_GROUP_DUP)
+			ratio = 2;
+		else if (flags & BTRFS_BLOCK_GROUP_RAID10)
+			ratio = 2;
+		else
+			ratio = 1;
+
+		allocated = sargs->spaces[i].total_bytes * ratio;
+
+		total_chunks += allocated;
+		total_used += sargs->spaces[i].used_bytes;
+		total_free += (sargs->spaces[i].total_bytes -
+					sargs->spaces[i].used_bytes);
+
+	}
+
+	/* add the raid5/6 allocated space */
+	total_chunks += raid5_used + raid6_used;
+
+	K = ((double)total_used + (double)total_free) /	(double)total_chunks;
+
+	if (mode & DF_HUMAN_UNIT)
+		width = 10;
+	else
+		width = 18;
+
+	printf("Disk size:\t\t%*s\n", width,
+		df_pretty_sizes(total_disk, mode));
+	printf("Disk allocated:\t\t%*s\n", width,
+		df_pretty_sizes(total_chunks, mode));
+	printf("Disk unallocated:\t%*s\n", width,
+		df_pretty_sizes(total_disk-total_chunks, mode));
+	printf("Used:\t\t\t%*s\n", width,
+		df_pretty_sizes(total_used, mode));
+	printf("Free (Estimated):\t%*s\t(",
+		width,
+		df_pretty_sizes((u64)(K*total_disk-total_used), mode));
+	printf("Max: %s, ",
+		df_pretty_sizes(total_disk-total_chunks+total_free, mode));
+	printf("min: %s)\n",
+		df_pretty_sizes((total_disk-total_chunks)/2+total_free, mode));
+	printf("Data to disk ratio:\t%*.0f %%\n",
+		width-2, K*100);
+
+exit:
+
+	if (sargs)
+		free(sargs);
+
+	return ret;
+}
+
+const char * const cmd_filesystem_df_usage[] = {
+	"btrfs filesystem df [-b] <path> [<path>..]",
+	"Show space usage information for a mount point(s).",
+	"",
+	"-b\tSet byte as unit",
+	NULL
+};
+
+int cmd_filesystem_df(int argc, char **argv)
+{
+
+	int	flags = DF_HUMAN_UNIT;
+	int	i, more_than_one = 0;
+
+	optind = 1;
+	while (1) {
+		char	c = getopt(argc, argv, "b");
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'b':
+			flags &= ~DF_HUMAN_UNIT;
+			break;
+		default:
+			usage(cmd_filesystem_df_usage);
+		}
+	}
+
+	if (check_argc_min(argc - optind, 1)) {
+		usage(cmd_filesystem_df_usage);
+		return 21;
+	}
+
+	for (i = optind; i < argc ; i++) {
+		int r, fd;
+		DIR *dirstream = NULL;
+		if (more_than_one)
+			printf("\n");
+
+		fd = open_file_or_dir(argv[i], &dirstream);
+		if (fd < 0) {
+			fprintf(stderr, "ERROR: can't access to '%s'\n",
+				argv[1]);
+			return 12;
+		}
+		r = _cmd_disk_free(fd, argv[i], flags);
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
diff --git a/cmds-fi-disk_usage.h b/cmds-fi-disk_usage.h
new file mode 100644
index 0000000..9f68bb3
--- /dev/null
+++ b/cmds-fi-disk_usage.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2007 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#ifndef __CMDS_FI_DISK_USAGE__
+#define __CMDS_FI_DISK_USAGE__
+
+extern const char * const cmd_filesystem_df_usage[];
+int cmd_filesystem_df(int argc, char **argv);
+
+#endif
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 1c1926b..fc85eef 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -36,6 +36,7 @@
 #include "volumes.h"
 #include "version.h"
 #include "commands.h"
+#include "cmds-fi-disk_usage.h"
 #include "list_sort.h"
 
 
@@ -111,49 +112,6 @@ static const char * const filesystem_cmd_group_usage[] = {
 	NULL
 };
 
-static const char * const cmd_df_usage[] = {
-	"btrfs filesystem df <path>",
-	"Show space usage information for a mount point",
-	NULL
-};
-
-static char *group_type_str(u64 flag)
-{
-	switch (flag & BTRFS_BLOCK_GROUP_TYPE_MASK) {
-	case BTRFS_BLOCK_GROUP_DATA:
-		return "Data";
-	case BTRFS_BLOCK_GROUP_SYSTEM:
-		return "System";
-	case BTRFS_BLOCK_GROUP_METADATA:
-		return "Metadata";
-	case BTRFS_BLOCK_GROUP_DATA|BTRFS_BLOCK_GROUP_METADATA:
-		return "Data+Metadata";
-	default:
-		return "unknown";
-	}
-}
-
-static char *group_profile_str(u64 flag)
-{
-	switch (flag & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
-	case 0:
-		return "single";
-	case BTRFS_BLOCK_GROUP_RAID0:
-		return "RAID0";
-	case BTRFS_BLOCK_GROUP_RAID1:
-		return "RAID1";
-	case BTRFS_BLOCK_GROUP_RAID5:
-		return "RAID5";
-	case BTRFS_BLOCK_GROUP_RAID6:
-		return "RAID6";
-	case BTRFS_BLOCK_GROUP_DUP:
-		return "DUP";
-	case BTRFS_BLOCK_GROUP_RAID10:
-		return "RAID10";
-	default:
-		return "unknown";
-	}
-}
 
 static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 {
@@ -203,51 +161,6 @@ static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 	return 0;
 }
 
-static void print_df(struct btrfs_ioctl_space_args *sargs)
-{
-	u64 i;
-	struct btrfs_ioctl_space_info *sp = sargs->spaces;
-
-	for (i = 0; i < sargs->total_spaces; i++, sp++) {
-		printf("%s, %s: total=%s, used=%s\n",
-			group_type_str(sp->flags),
-			group_profile_str(sp->flags),
-			pretty_size(sp->total_bytes),
-			pretty_size(sp->used_bytes));
-	}
-}
-
-static int cmd_df(int argc, char **argv)
-{
-	struct btrfs_ioctl_space_args *sargs = NULL;
-	int ret;
-	int fd;
-	char *path;
-	DIR  *dirstream = NULL;
-
-	if (check_argc_exact(argc, 2))
-		usage(cmd_df_usage);
-
-	path = argv[1];
-
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 1;
-	}
-	ret = get_df(fd, &sargs);
-
-	if (!ret && sargs) {
-		print_df(sargs);
-		free(sargs);
-	} else {
-		fprintf(stderr, "ERROR: get_df failed %s\n", strerror(-ret));
-	}
-
-	close_file_or_dir(fd, dirstream);
-	return !!ret;
-}
-
 static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
 {
 	char uuidbuf[37];
@@ -878,7 +791,7 @@ static int cmd_label(int argc, char **argv)
 
 const struct cmd_group filesystem_cmd_group = {
 	filesystem_cmd_group_usage, NULL, {
-		{ "df", cmd_df, cmd_df_usage, NULL, 0 },
+		{ "df", cmd_filesystem_df, cmd_filesystem_df_usage, NULL, 0 },
 		{ "show", cmd_show, cmd_show_usage, NULL, 0 },
 		{ "sync", cmd_sync, cmd_sync_usage, NULL, 0 },
 		{ "defragment", cmd_defrag, cmd_defrag_usage, NULL, 0 },
diff --git a/ctree.h b/ctree.h
index 2117374..ff7ffee 100644
--- a/ctree.h
+++ b/ctree.h
@@ -830,9 +830,22 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_RAID1		(1ULL << 4)
 #define BTRFS_BLOCK_GROUP_DUP		(1ULL << 5)
 #define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
-#define BTRFS_BLOCK_GROUP_RAID5    (1ULL << 7)
-#define BTRFS_BLOCK_GROUP_RAID6    (1ULL << 8)
+#define BTRFS_BLOCK_GROUP_RAID5    	(1ULL << 7)
+#define BTRFS_BLOCK_GROUP_RAID6    	(1ULL << 8)
 #define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
+#define BTRFS_NR_RAID_TYPES             7
+
+#define BTRFS_BLOCK_GROUP_TYPE_MASK     (BTRFS_BLOCK_GROUP_DATA |    \
+					 BTRFS_BLOCK_GROUP_SYSTEM |  \
+					 BTRFS_BLOCK_GROUP_METADATA)
+
+#define BTRFS_BLOCK_GROUP_PROFILE_MASK  (BTRFS_BLOCK_GROUP_RAID0 |   \
+					 BTRFS_BLOCK_GROUP_RAID1 |   \
+					 BTRFS_BLOCK_GROUP_RAID5 |   \
+					 BTRFS_BLOCK_GROUP_RAID6 |   \
+					 BTRFS_BLOCK_GROUP_DUP |     \
+					 BTRFS_BLOCK_GROUP_RAID10)
+
 
 #define BTRFS_BLOCK_GROUP_TYPE_MASK	(BTRFS_BLOCK_GROUP_DATA |    \
 					 BTRFS_BLOCK_GROUP_SYSTEM |  \
diff --git a/utils.c b/utils.c
index f499023..760db6b 100644
--- a/utils.c
+++ b/utils.c
@@ -38,6 +38,8 @@
 #include <linux/kdev_t.h>
 #include <limits.h>
 #include <blkid/blkid.h>
+#include <sys/vfs.h>
+
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "ctree.h"
@@ -2108,3 +2110,14 @@ int lookup_ino_rootid(int fd, u64 *rootid)
 
 	return 0;
 }
+
+u64 disk_size(char *path)
+{
+	struct statfs	sfs;
+
+	if (statfs(path, &sfs) < 0)
+		return 0;
+	else
+		return sfs.f_bsize * sfs.f_blocks;
+
+}
diff --git a/utils.h b/utils.h
index 6f4b10c..0f7939c 100644
--- a/utils.h
+++ b/utils.h
@@ -20,6 +20,7 @@
 #define __UTILS__
 
 #include <sys/stat.h>
+#include "kerncompat.h"
 #include "ctree.h"
 #include <dirent.h>
 
@@ -95,4 +96,5 @@ int lookup_ino_rootid(int fd, u64 *rootid);
 int btrfs_scan_lblkid(int update_kernel);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 
+u64 disk_size(char *path);
 #endif
-- 
1.8.5.3



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
