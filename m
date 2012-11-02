Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44956 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab2KBKO7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 06:14:59 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1719891eek.19
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 03:14:57 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/8] Enhance the command btrfs filesystem df.
Date: Fri,  2 Nov 2012 11:15:32 +0100
Message-Id: <1351851339-19150-2-git-send-email-kreijack@inwind.it>
In-Reply-To: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Enhance the command "btrfs filesystem df" to show space usage information
for a mount point(s). It shows also an estimation of the space available,
on the basis of the current one used.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Makefile             |    2 +-
 cmds-fi-disk_usage.c |  334 ++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-fi-disk_usage.h |   25 ++++
 cmds-filesystem.c    |  125 +------------------
 ctree.h              |   11 ++
 utils.c              |   13 ++
 utils.h              |    4 +
 7 files changed, 390 insertions(+), 124 deletions(-)
 create mode 100644 cmds-fi-disk_usage.c
 create mode 100644 cmds-fi-disk_usage.h

diff --git a/Makefile b/Makefile
index 4894903..4a9b6e0 100644
--- a/Makefile
+++ b/Makefile
@@ -8,7 +8,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  send-stream.o send-utils.o qgroup.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
-	       cmds-quota.o cmds-qgroup.o
+	       cmds-quota.o cmds-qgroup.o cmds-fi-disk_usage.o
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
new file mode 100644
index 0000000..9131c47
--- /dev/null
+++ b/cmds-fi-disk_usage.c
@@ -0,0 +1,334 @@
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
+/* to store the information about the chunk */
+struct chunk_info {
+	u64	type;
+	u64	size;
+	u64	devid;
+	int	processed:1;
+};
+
+struct disk_info {
+	u64	devid;
+	char	path[BTRFS_DEVICE_PATH_NAME_MAX];
+	u64	size;
+};
+
+/* to store the tmp strings */
+static void **strings_to_free;
+static int count_string_to_free;
+
+static void add_strings_to_free(char *s)
+{
+	int  size;
+
+	size = sizeof(void *) * ++count_string_to_free;
+	strings_to_free = realloc(strings_to_free, size);
+
+	/* if we don't have enough memory, we have more serius
+	   problem than that a wrong handling of not enough memory */
+	if (!strings_to_free) {
+		fprintf(stderr, "add_string_to_free(): Not enough memory\n");
+		strings_to_free = 0;
+		count_string_to_free = 0;
+	}
+
+	strings_to_free[count_string_to_free-1] = s;
+}
+
+static void free_strings_to_free()
+{
+	int	i;
+	for (i = 0 ; i < count_string_to_free ; i++)
+		free(strings_to_free[i]);
+
+	free(strings_to_free);
+
+	strings_to_free = 0;
+	count_string_to_free = 0;
+}
+
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
+	add_strings_to_free(s);
+	return s;
+}
+
+static int cmp_chunk_block_group(u64 f1, u64 f2)
+{
+
+	u64 mask;
+
+	if ((f1 & BTRFS_BLOCK_GROUP_TYPE_MASK) ==
+		(f2 & BTRFS_BLOCK_GROUP_TYPE_MASK))
+			mask = BTRFS_BLOCK_GROUP_PROFILE_MASK;
+	else if (f2 & BTRFS_BLOCK_GROUP_SYSTEM)
+		return -1;
+	else if (f1 & BTRFS_BLOCK_GROUP_SYSTEM)
+		return +1;
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
+static int cmp_btrfs_ioctl_space_info(const void *a, const void *b)
+{
+	return cmp_chunk_block_group(
+		((struct btrfs_ioctl_space_info *)a)->flags,
+		((struct btrfs_ioctl_space_info *)b)->flags);
+}
+
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
+
+	total_chunks = total_used = total_free = 0;
+
+	for (i = 0; i < sargs->total_spaces; i++) {
+		int  ratio = 1;
+		u64  allocated;
+
+		u64 flags = sargs->spaces[i].flags;
+
+		if (flags & BTRFS_BLOCK_GROUP_RAID0)
+			ratio = 1;
+		else if (flags & BTRFS_BLOCK_GROUP_RAID1)
+			ratio = 2;
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
+	free_strings_to_free();
+	if (sargs)
+		free(sargs);
+
+	return ret;
+}
+
+const char * const cmd_filesystem_df_usage[] = {
+	"btrfs filesystem df [-k] <path> [<path>..]",
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
index 9c43d35..1b915e4 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -33,134 +33,13 @@
 
 #include "commands.h"
 #include "btrfslabel.h"
+#include "cmds-fi-disk_usage.h"
 
 static const char * const filesystem_cmd_group_usage[] = {
 	"btrfs filesystem [<group>] <command> [<args>]",
 	NULL
 };
 
-static const char * const cmd_df_usage[] = {
-	"btrfs filesystem df <path>",
-	"Show space usage information for a mount point",
-	NULL
-};
-
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
@@ -537,7 +416,7 @@ static int cmd_label(int argc, char **argv)
 
 const struct cmd_group filesystem_cmd_group = {
 	filesystem_cmd_group_usage, NULL, {
-		{ "df", cmd_df, cmd_df_usage, NULL, 0 },
+		{ "df", cmd_filesystem_df, cmd_filesystem_df_usage, NULL, 0 },
 		{ "show", cmd_show, cmd_show_usage, NULL, 0 },
 		{ "sync", cmd_sync, cmd_sync_usage, NULL, 0 },
 		{ "defragment", cmd_defrag, cmd_defrag_usage, NULL, 0 },
diff --git a/ctree.h b/ctree.h
index 293b24f..7c7d077 100644
--- a/ctree.h
+++ b/ctree.h
@@ -780,6 +780,17 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_DUP		(1ULL << 5)
 #define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
 #define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
+#define BTRFS_NR_RAID_TYPES             5
+
+#define BTRFS_BLOCK_GROUP_TYPE_MASK     (BTRFS_BLOCK_GROUP_DATA |    \
+					 BTRFS_BLOCK_GROUP_SYSTEM |  \
+					 BTRFS_BLOCK_GROUP_METADATA)
+
+#define BTRFS_BLOCK_GROUP_PROFILE_MASK  (BTRFS_BLOCK_GROUP_RAID0 |   \
+					 BTRFS_BLOCK_GROUP_RAID1 |   \
+					 BTRFS_BLOCK_GROUP_DUP |     \
+					 BTRFS_BLOCK_GROUP_RAID10)
+
 
 /* used in struct btrfs_balance_args fields */
 #define BTRFS_AVAIL_ALLOC_BIT_SINGLE	(1ULL << 48)
diff --git a/utils.c b/utils.c
index 205e667..fba11e0 100644
--- a/utils.c
+++ b/utils.c
@@ -35,6 +35,8 @@
 #include <linux/major.h>
 #include <linux/kdev_t.h>
 #include <limits.h>
+#include <sys/vfs.h>
+
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "ctree.h"
@@ -1220,3 +1222,14 @@ scan_again:
 	return 0;
 }
 
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
index 3a0368b..a82b81c 100644
--- a/utils.h
+++ b/utils.h
@@ -19,6 +19,9 @@
 #ifndef __UTILS__
 #define __UTILS__
 
+#include "kerncompat.h"
+#include "ctree.h"
+
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 
 int make_btrfs(int fd, const char *device, const char *label,
@@ -46,4 +49,5 @@ int check_label(char *input);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 
 int btrfs_scan_block_devices(int run_ioctl);
+u64 disk_size(char *path);
 #endif
-- 
1.7.10.4

