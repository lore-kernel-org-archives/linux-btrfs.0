Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33682 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaKYP5k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 10:57:40 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so9594079wid.9
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 07:57:38 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/4] Add the code for the btrfs chunk list command
Date: Tue, 25 Nov 2014 16:57:23 +0100
Message-Id: <1416931045-24259-3-git-send-email-kreijack@inwind.it>
In-Reply-To: <1416931045-24259-1-git-send-email-kreijack@inwind.it>
References: <1416931045-24259-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the code for the btrfs chunk list command. The code iterates
through the chunk, grouping these by chunk type (data, metadata,
system) and chunk profiles (linear, dup, raid1, radi5, raid10,
raid6..); then it displays the devices belong each group.
If a device is missing, it is marked as 'Missing'.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-chunk.c | 699 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 699 insertions(+)
 create mode 100644 cmds-chunk.c

diff --git a/cmds-chunk.c b/cmds-chunk.c
new file mode 100644
index 0000000..3afa2b1
--- /dev/null
+++ b/cmds-chunk.c
@@ -0,0 +1,699 @@
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
+#include <stdarg.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <linux/fs.h>
+#include <dirent.h>
+#include <linux/limits.h>
+#include <uuid/uuid.h>
+
+#include "utils.h"
+#include "kerncompat.h"
+#include "ctree.h"
+
+#include "commands.h"
+
+#include "version.h"
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
+/* to store information about the disks */
+struct disk_info {
+	u64	devid;
+	char	path[BTRFS_DEVICE_PATH_NAME_MAX];
+	u64	size;
+};
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
+
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
+static struct btrfs_ioctl_space_args *load_space_info(int fd, const char *path)
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
+ *  Helper to sort the disk_info structure
+ */
+static int cmp_disk_info(const void *a, const void *b)
+{
+	return strcmp(((struct disk_info *)a)->path,
+			((struct disk_info *)b)->path);
+}
+
+
+/*
+ *	check if the device 'devpath' is used by the btrfs filesystem
+ *	fsid; check devpath against /fs/btrfs/<uuid>/<dev>/dev by
+ *	major, minor
+ */
+static int is_device_used(char *devpath, u8 *fsid) {
+	char fsid_c[BTRFS_UUID_UNPARSED_SIZE];
+	char dirname[PATH_MAX];
+	struct stat devstat;
+	int dev_major, dev_minor;
+	DIR *dir;
+
+
+
+	if (stat(devpath, &devstat)<0)
+		return 0;
+
+	dev_major = major(devstat.st_rdev);
+	dev_minor = minor(devstat.st_rdev);
+
+	uuid_unparse(fsid, fsid_c);
+	snprintf(dirname, PATH_MAX-1,
+			"/sys/fs/btrfs/%s/devices",
+			fsid_c);
+
+	/*
+	 *	if /sys/btrfs doesn't exist; return 0
+	 */
+	if ((dir=opendir(dirname))==NULL)
+		return 0;
+
+	for(;;) {
+		char path[PATH_MAX];
+		struct dirent *direntry;
+		char buf[100];
+		FILE *fp;
+		int mj, mn;
+		char *r;
+
+		direntry = readdir(dir);
+
+		/* entry not found */
+		if (!direntry) {
+			closedir(dir);
+			return 0;
+		}
+
+		if (!strcmp(direntry->d_name, "."))
+			continue;
+		if (!strcmp(direntry->d_name, ".."))
+			continue;
+
+		snprintf(path, PATH_MAX-1,
+			"%s/%s/dev",
+			dirname, direntry->d_name);
+
+		fp = fopen(path, "r");
+		if (!fp)
+			continue;
+
+		r = fgets(buf, 99, fp);
+		fclose(fp);
+		if (!r)
+			continue;
+
+		if (sscanf(buf, "%d:%d", &mj, &mn) != 2)
+			continue;
+
+		if (mj == dev_major && mn == dev_minor) {
+			closedir(dir);
+			return 1;
+		}
+
+	}
+
+	/* we don't reach here */
+	BUG_ON(1);
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
+		if(is_device_used((char*)dev_info.path, fi_args.fsid)) {
+			strcpy(info[ndevs].path, (char *)dev_info.path);
+		} else {
+			snprintf(info[ndevs].path,
+				BTRFS_DEVICE_PATH_NAME_MAX-1,
+				"[Missing: %s]",
+				(char *)dev_info.path);
+		}
+
+		info[ndevs].size = dev_info.total_bytes;
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
+			pretty_size_mode(disks_info_ptr[i].size-total, mode));
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
+		}
+
+		if (total > 0) {
+			printf("   %s\t%10s\n",
+				disks_info_ptr[i].path,
+				pretty_size_mode(total, mode));
+		}
+	}
+}
+
+/*
+ *  This function print the results of the command btrfs fi disk-usage
+ *  in linear format
+ */
+static void write_chunks_info(int mode,
+					struct btrfs_ioctl_space_args *sargs,
+					struct chunk_info *info_ptr,
+					int info_count,
+					struct disk_info *disks_info_ptr,
+					int disks_info_count)
+{
+	int i;
+
+	for (i = 0; i < sargs->total_spaces; i++) {
+		int j = 0;
+		for (j=0 ; j < info_count ; j++)
+			if (info_ptr[j].type == sargs->spaces[i].flags)
+				break;
+
+		/* skip spaces without chunk */
+		if(j == info_count)
+			continue;
+
+		printf("%s,%s: Size:%s, Used:%s\n",
+			group_type_str(sargs->spaces[i].flags),
+			group_profile_str(sargs->spaces[i].flags),
+			pretty_size_mode(sargs->spaces[i].total_bytes ,
+			    mode),
+			pretty_size_mode(sargs->spaces[i].used_bytes,
+					mode));
+
+		print_chunk_disks(sargs->spaces[i].flags, info_ptr,
+				info_count, disks_info_ptr,
+				disks_info_count, mode);
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
+static int _dump_chunks(int fd, const char *path, int mode)
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
+	write_chunks_info(mode, sargs,
+				info_ptr, info_count,
+				disks_info_ptr, disks_info_count);
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
+static const char * const chunk_cmd_group_usage[] = {
+	"btrfs chunk list <filesystem>",
+	NULL
+};
+
+static const char * const cmd_chunk_list_usage[] = {
+	"btrfs chunk list <filesystem>",
+	"Shows the filesystem chunks.",
+	NULL
+};
+
+static int dump_chunks(const char * path, int mode) {
+
+	int fd, r;
+	DIR *dirp;
+
+	fd = open_file_or_dir(path, &dirp);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+	r = _dump_chunks(fd, path, UNITS_BINARY);
+	close(fd);
+	if (r < 0) {
+		int e = errno;
+		fprintf(stderr, "ERROR: errno = %d, %s\n",
+			e, strerror(e));
+		return 12;
+	}
+
+	return r;
+}
+
+static int cmd_chunk_list(int argc, char **argv)
+{
+	int ret;
+	char *path = NULL;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_chunk_list_usage);
+
+	path = argv[1];
+
+	ret = dump_chunks(path, 0);
+	return ret;
+
+}
+
+const struct cmd_group chunk_cmd_group = {
+	chunk_cmd_group_usage, NULL, {
+		{ "list", cmd_chunk_list, cmd_chunk_list_usage, NULL, 0 },
+		NULL_CMD_STRUCT
+	}
+};
+
+int cmd_chunk(int argc, char **argv)
+{
+	return handle_command_group(&chunk_cmd_group, argc, argv);
+}
-- 
2.1.3

