Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm1.bullet.mail.ird.yahoo.com ([77.238.189.58]:45454 "HELO
	nm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755553Ab3BRVD7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 16:03:59 -0500
From: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/8] Enhance the command btrfs filesystem df.
Date: Mon, 18 Feb 2013 22:04:27 +0100
Message-Id: <1361221473-20347-3-git-send-email-goffredo.baroncelli@yahoo.com>
In-Reply-To: <1361221473-20347-1-git-send-email-goffredo.baroncelli@yahoo.com>
References: <1361221473-20347-1-git-send-email-goffredo.baroncelli@yahoo.com>
Reply-to: kreijack@inwind.it
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Enhance the command "btrfs filesystem df" to show space usage information
for a mount point(s). It shows also an estimation of the space available,
on the basis of the current one used.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Makefile             |    2 +-
 cmds-fi-disk_usage.c |  520 ++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-fi-disk_usage.h |   25 +++
 cmds-filesystem.c    |  125 +-----------
 ctree.h              |   17 +-
 utils.c              |   14 ++
 utils.h              |    2 +
 7 files changed, 579 insertions(+), 126 deletions(-)
 create mode 100644 cmds-fi-disk_usage.c
 create mode 100644 cmds-fi-disk_usage.h

diff --git a/Makefile b/Makefile
index 0d6c43a..bd792b6 100644
--- a/Makefile
+++ b/Makefile
@@ -9,7 +9,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  string_list.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
-	       cmds-quota.o cmds-qgroup.o cmds-replace.o
+	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-fi-disk_usage.o
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
new file mode 100644
index 0000000..1e3589f
--- /dev/null
+++ b/cmds-fi-disk_usage.c
@@ -0,0 +1,520 @@
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
+#include "string_list.h"
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
+	int	num_stripes;
+};
+
+/*
+ * Pretty print the size
+ */
+static char *df_pretty_sizes(u64 size, int mode)
+{
+	char *s;
+
+	if (mode & DF_HUMAN_UNIT) {
+		s = pretty_sizes(size);
+		if (!s)
+			return NULL;
+	} else {
+		s = malloc(20);
+		if (!s)
+			return NULL;
+		sprintf(s, "%llu", size);
+	}
+
+	string_list_add(s);
+	return s;
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
+		/* TODO: the raid5/raid6 ratio depends by the number
+		   of disk used by every chunk. It is computed separately
+		*/
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
+		width = 9;
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
+	printf("Free (Estimated):\t%*s\t(Max: %s, min: %s)\n",
+		width,
+		df_pretty_sizes((u64)(K*total_disk-total_used), mode),
+		df_pretty_sizes(total_disk-total_chunks+total_free, mode),
+		df_pretty_sizes((total_disk-total_chunks)/2+total_free, mode));
+	printf("Data to disk ratio:\t%*.0f %%\n",
+		width-2, K*100);
+
+exit:
+
+	string_list_free();
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
+		if (more_than_one)
+			printf("\n");
+
+		fd = open_file_or_dir(argv[i]);
+		if (fd < 0) {
+			fprintf(stderr, "ERROR: can't access to '%s'\n",
+				argv[1]);
+			return 12;
+		}
+		r = _cmd_disk_free(fd, argv[i], flags);
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
index bdbd2ee..5301dc3 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -33,6 +33,7 @@
 
 #include "commands.h"
 #include "btrfslabel.h"
+#include "cmds-fi-disk_usage.h"
 
 static const char * const filesystem_cmd_group_usage[] = {
 	"btrfs filesystem [<group>] <command> [<args>]",
@@ -45,128 +46,6 @@ static const char * const cmd_df_usage[] = {
 	NULL
 };
 
-static int cmd_df(int argc, char **argv)
-{
-	struct btrfs_ioctl_space_args *sargs, *sargs_orig;
-	u64 count = 0, i;
-	int ret;
-	int fd;
-	int e;
-	char *path;
-
-	if (check_argc_exact(argc, 2))
-		usage(cmd_df_usage);
-
-	path = argv[1];
-
-	fd = open_file_or_dir(path);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
-	}
-
-	sargs_orig = sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
-	if (!sargs)
-		return -ENOMEM;
-
-	sargs->space_slots = 0;
-	sargs->total_spaces = 0;
-
-	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
-	e = errno;
-	if (ret) {
-		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
-			path, strerror(e));
-		close(fd);
-		free(sargs);
-		return ret;
-	}
-	if (!sargs->total_spaces) {
-		close(fd);
-		free(sargs);
-		return 0;
-	}
-
-	count = sargs->total_spaces;
-
-	sargs = realloc(sargs, sizeof(struct btrfs_ioctl_space_args) +
-			(count * sizeof(struct btrfs_ioctl_space_info)));
-	if (!sargs) {
-		close(fd);
-		free(sargs_orig);
-		return -ENOMEM;
-	}
-
-	sargs->space_slots = count;
-	sargs->total_spaces = 0;
-
-	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
-	e = errno;
-	if (ret) {
-		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
-			path, strerror(e));
-		close(fd);
-		free(sargs);
-		return ret;
-	}
-
-	for (i = 0; i < sargs->total_spaces; i++) {
-		char description[80];
-		char *total_bytes;
-		char *used_bytes;
-		int written = 0;
-		u64 flags = sargs->spaces[i].flags;
-
-		memset(description, 0, 80);
-
-		if (flags & BTRFS_BLOCK_GROUP_DATA) {
-			if (flags & BTRFS_BLOCK_GROUP_METADATA) {
-				snprintf(description, 14, "%s",
-					 "Data+Metadata");
-				written += 13;
-			} else {
-				snprintf(description, 5, "%s", "Data");
-				written += 4;
-			}
-		} else if (flags & BTRFS_BLOCK_GROUP_SYSTEM) {
-			snprintf(description, 7, "%s", "System");
-			written += 6;
-		} else if (flags & BTRFS_BLOCK_GROUP_METADATA) {
-			snprintf(description, 9, "%s", "Metadata");
-			written += 8;
-		}
-
-		if (flags & BTRFS_BLOCK_GROUP_RAID0) {
-			snprintf(description+written, 8, "%s", ", RAID0");
-			written += 7;
-		} else if (flags & BTRFS_BLOCK_GROUP_RAID1) {
-			snprintf(description+written, 8, "%s", ", RAID1");
-			written += 7;
-		} else if (flags & BTRFS_BLOCK_GROUP_DUP) {
-			snprintf(description+written, 6, "%s", ", DUP");
-			written += 5;
-		} else if (flags & BTRFS_BLOCK_GROUP_RAID10) {
-			snprintf(description+written, 9, "%s", ", RAID10");
-			written += 8;
-		} else if (flags & BTRFS_BLOCK_GROUP_RAID5) {
-			snprintf(description+written, 9, "%s", ", RAID5");
-			written += 7;
-		} else if (flags & BTRFS_BLOCK_GROUP_RAID6) {
-			snprintf(description+written, 9, "%s", ", RAID6");
-			written += 7;
-		}
-
-		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
-		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes);
-		printf("%s: total=%s, used=%s\n", description, total_bytes,
-		       used_bytes);
-	}
-	close(fd);
-	free(sargs);
-
-	return 0;
-}
-
 static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
 {
 	char uuidbuf[37];
@@ -517,7 +396,7 @@ static int cmd_label(int argc, char **argv)
 
 const struct cmd_group filesystem_cmd_group = {
 	filesystem_cmd_group_usage, NULL, {
-		{ "df", cmd_df, cmd_df_usage, NULL, 0 },
+		{ "df", cmd_filesystem_df, cmd_filesystem_df_usage, NULL, 0 },
 		{ "show", cmd_show, cmd_show_usage, NULL, 0 },
 		{ "sync", cmd_sync, cmd_sync_usage, NULL, 0 },
 		{ "defragment", cmd_defrag, cmd_defrag_usage, NULL, 0 },
diff --git a/ctree.h b/ctree.h
index 12f8fe3..a029368 100644
--- a/ctree.h
+++ b/ctree.h
@@ -798,9 +798,22 @@ struct btrfs_csum_item {
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
 
 /* used in struct btrfs_balance_args fields */
 #define BTRFS_AVAIL_ALLOC_BIT_SINGLE	(1ULL << 48)
diff --git a/utils.c b/utils.c
index f9ee812..029729c 100644
--- a/utils.c
+++ b/utils.c
@@ -38,6 +38,8 @@
 #include <linux/major.h>
 #include <linux/kdev_t.h>
 #include <limits.h>
+#include <sys/vfs.h>
+
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "ctree.h"
@@ -1386,3 +1388,15 @@ int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 
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
+
diff --git a/utils.h b/utils.h
index bbcaf6a..7974d00 100644
--- a/utils.h
+++ b/utils.h
@@ -19,6 +19,7 @@
 #ifndef __UTILS__
 #define __UTILS__
 
+#include "kerncompat.h"
 #include "ctree.h"
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
@@ -58,4 +59,5 @@ char *__strncpy__null(char *dest, const char *src, size_t n);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 
+u64 disk_size(char *path);
 #endif
-- 
1.7.10.4

