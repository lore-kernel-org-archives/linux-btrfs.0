Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758050AbaD2QCk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 12:02:40 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 293CEAC4F
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 16:02:39 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 10/14] btrfs-progs: cleanup filesystem/device usage code
Date: Tue, 29 Apr 2014 18:02:38 +0200
Message-Id: <ecd622b28c80c5f82d099df1780c0aa43f905a9c.1398786620.git.dsterba@suse.cz>
In-Reply-To: <cover.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The main point of this is to load the device and chunk infos at one
place and pass down to the printers. The EPERM is handled separately, in
case kernel does not give us all the information about chunks or
devices, but we want to warn and print at least something.

For non-root users, 'filesystem usage' prints only the overall stats and
warns about RAID5/6.

The sole cleanup changes affect mostly the modified code and the related
functions, should be reasonably small.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-device.c        |  31 +++++-----
 cmds-fi-disk_usage.c | 163 +++++++++++++++++++++++++++------------------------
 cmds-fi-disk_usage.h |   5 +-
 3 files changed, 105 insertions(+), 94 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index d7889f93d343..29eeaf6bbd0f 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -435,31 +435,29 @@ static int _cmd_device_usage(int fd, char *path, int mode)
 {
 	int i;
 	int ret = 0;
-	int info_count = 0;
-	struct chunk_info *info_ptr = 0;
-	struct device_info *device_info_ptr = 0;
-	int device_info_count = 0;
+	struct chunk_info *chunkinfo = NULL;
+	struct device_info *devinfo = NULL;
+	int chunkcount = 0;
+	int devcount = 0;
 
-	if (load_chunk_info(fd, &info_ptr, &info_count) ||
-	    load_device_info(fd, &device_info_ptr, &device_info_count)) {
+	ret = load_chunk_and_device_info(fd, &chunkinfo, &chunkcount, &devinfo,
+			&devcount);
+	if (ret) {
 		ret = -1;
 		goto exit;
 	}
 
-	for (i = 0; i < device_info_count; i++) {
-		printf("%s, ID: %llu\n", device_info_ptr[i].path,
-				device_info_ptr[i].devid);
-		print_device_sizes(fd, &device_info_ptr[i], mode);
-		print_device_chunks(fd, &device_info_ptr[i],
-				info_ptr, info_count, mode);
+	for (i = 0; i < devcount; i++) {
+		printf("%s, ID: %llu\n", devinfo[i].path, devinfo[i].devid);
+		print_device_sizes(fd, &devinfo[i], mode);
+		print_device_chunks(fd, &devinfo[i], chunkinfo, chunkcount,
+				mode);
 		printf("\n");
 	}
 
 exit:
-	if (device_info_ptr)
-		free(device_info_ptr);
-	if (info_ptr)
-		free(info_ptr);
+	free(devinfo);
+	free(chunkinfo);
 
 	return ret;
 }
@@ -501,6 +499,7 @@ int cmd_device_usage(int argc, char **argv)
 				argv[1]);
 			return 12;
 		}
+
 		r = _cmd_device_usage(fd, argv[i], flags);
 		close_file_or_dir(fd, dirstream);
 
diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index d76fa3552136..e472833c646d 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -140,7 +140,7 @@ static int cmp_chunk_info(const void *a, const void *b)
 		((struct chunk_info *)b)->type);
 }
 
-int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count)
+static int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count)
 {
 	int ret;
 	struct btrfs_ioctl_search_args args;
@@ -171,11 +171,8 @@ int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count)
 	while (1) {
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 		e = errno;
-		if (ret == -EPERM) {
-			fprintf(stderr,
-				"ERROR: can't read detailed chunk info from ioctl(TREE_SEARCH), run as root\n");
-			return 0;
-		}
+		if (ret == -EPERM)
+			return ret;
 
 		if (ret < 0) {
 			fprintf(stderr,
@@ -308,30 +305,23 @@ static struct btrfs_ioctl_space_args *load_space_info(int fd, char *path)
  * which compose the chunk, which could be different from the number of devices
  * if a disk is added later.
  */
-static int get_raid56_used(int fd, u64 *raid5_used, u64 *raid6_used)
+static void get_raid56_used(int fd, struct chunk_info *chunks, int chunkcount,
+		u64 *raid5_used, u64 *raid6_used)
 {
-	struct chunk_info *info_ptr=0, *p;
-	int info_count=0;
-	int ret;
-
-	*raid5_used = *raid6_used =0;
-
-	ret = load_chunk_info(fd, &info_ptr, &info_count);
-	if( ret < 0)
-		return ret;
-
-	for ( p = info_ptr; info_count ; info_count--, p++ ) {
-		if (p->type & BTRFS_BLOCK_GROUP_RAID5)
-			(*raid5_used) += p->size / (p->num_stripes -1);
-		if (p->type & BTRFS_BLOCK_GROUP_RAID6)
-			(*raid6_used) += p->size / (p->num_stripes -2);
+	*raid5_used = 0;
+	*raid6_used = 0;
+
+	while (chunkcount-- > 0) {
+		if (chunks->type & BTRFS_BLOCK_GROUP_RAID5)
+			(*raid5_used) += chunks->size / (chunks->num_stripes - 1);
+		if (chunks->type & BTRFS_BLOCK_GROUP_RAID6)
+			(*raid6_used) += chunks->size / (chunks->num_stripes - 2);
 	}
-	free(info_ptr);
-
-	return 0;
 }
 
-static int _cmd_disk_free(int fd, char *path, int mode)
+static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
+		int chunkcount, struct device_info *devinfo, int devcount,
+		char *path, int mode)
 {
 	struct btrfs_ioctl_space_args *sargs = 0;
 	int i;
@@ -360,15 +350,11 @@ static int _cmd_disk_free(int fd, char *path, int mode)
 		ret = 19;
 		goto exit;
 	}
-	if (get_raid56_used(fd, &raid5_used, &raid6_used) < 0) {
-		fprintf(stderr,
-			"ERROR: couldn't get space info on '%s'\n",
-			path );
-		ret = 20;
-		goto exit;
-	}
+	get_raid56_used(fd, chunkinfo, chunkcount, &raid5_used, &raid6_used);
 
-	total_chunks = total_used = total_free = 0;
+	total_chunks = 0;
+	total_used = 0;
+	total_free = 0;
 
 	for (i = 0; i < sargs->total_spaces; i++) {
 		float ratio = 1;
@@ -453,7 +439,7 @@ static int cmp_device_info(const void *a, const void *b)
 /*
  *  This function loads the device_info structure and put them in an array
  */
-int load_device_info(int fd, struct device_info **device_info_ptr,
+static int load_device_info(int fd, struct device_info **device_info_ptr,
 			   int *device_info_count)
 {
 	int ret, i, ndevs;
@@ -465,10 +451,8 @@ int load_device_info(int fd, struct device_info **device_info_ptr,
 	*device_info_ptr = 0;
 
 	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &fi_args);
-	if (ret == -EPERM) {
-		fprintf(stderr, "ERROR: can't get filesystem info from ioctl(FS_INFO), run as root\n");
-		return -1;
-	}
+	if (ret == -EPERM)
+		return ret;
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: cannot get filesystem info\n");
 		return -1;
@@ -512,6 +496,29 @@ int load_device_info(int fd, struct device_info **device_info_ptr,
 	return 0;
 }
 
+int load_chunk_and_device_info(int fd, struct chunk_info **chunkinfo,
+		int *chunkcount, struct device_info **devinfo, int *devcount)
+{
+	int ret;
+
+	ret = load_chunk_info(fd, chunkinfo, chunkcount);
+	if (ret == -EPERM) {
+		fprintf(stderr,
+			"WARNING: can't read detailed chunk info, RAID5/6 numbers will be incorrect, run as root\n");
+	} else if (ret) {
+		return ret;
+	}
+
+	ret = load_device_info(fd, devinfo, devcount);
+	if (ret == -EPERM) {
+		fprintf(stderr,
+			"WARNING: can't get filesystem info from ioctl(FS_INFO), run as root\n");
+		ret = 0;
+	}
+
+	return ret;
+}
+
 /*
  *  This function computes the size of a chunk in a disk
  */
@@ -744,43 +751,32 @@ static void _cmd_filesystem_usage_linear(int mode,
 			mode);
 }
 
-static int _cmd_filesystem_usage(int fd, char *path, int mode, int tabular)
+static int print_filesystem_usage_by_chunk(int fd,
+		struct chunk_info *chunkinfo, int chunkcount,
+		struct device_info *devinfo, int devcount,
+		char *path, int mode, int tabular)
 {
-	struct btrfs_ioctl_space_args *sargs = 0;
-	int info_count = 0;
-	struct chunk_info *info_ptr = 0;
-	struct device_info *device_info_ptr = 0;
-	int device_info_count = 0;
+	struct btrfs_ioctl_space_args *sargs;
 	int ret = 0;
 
-	if (load_chunk_info(fd, &info_ptr, &info_count) ||
-	    load_device_info(fd, &device_info_ptr, &device_info_count)) {
-		ret = -1;
-		goto exit;
-	}
+	if (!chunkinfo)
+		return 0;
 
-	if ((sargs = load_space_info(fd, path)) == NULL) {
-		ret = -1;
+	sargs = load_space_info(fd, path);
+	if (!sargs) {
+		ret = 1;
 		goto exit;
 	}
 
 	if (tabular)
-		_cmd_filesystem_usage_tabular(mode, sargs,
-					info_ptr, info_count,
-					device_info_ptr, device_info_count);
+		_cmd_filesystem_usage_tabular(mode, sargs, chunkinfo,
+				chunkcount, devinfo, devcount);
 	else
-		_cmd_filesystem_usage_linear(mode, sargs,
-					info_ptr, info_count,
-					device_info_ptr, device_info_count);
+		_cmd_filesystem_usage_linear(mode, sargs, chunkinfo,
+				chunkcount, devinfo, devcount);
 
 exit:
-
-	if (sargs)
-		free(sargs);
-	if (device_info_ptr)
-		free(device_info_ptr);
-	if (info_ptr)
-		free(info_ptr);
+	free(sargs);
 
 	return ret;
 }
@@ -796,16 +792,17 @@ const char * const cmd_filesystem_usage_usage[] = {
 
 int cmd_filesystem_usage(int argc, char **argv)
 {
-
 	int	flags =	DF_HUMAN_UNIT;
 	int	i, more_than_one = 0;
 	int	tabular = 0;
 
 	optind = 1;
 	while (1) {
-		char	c = getopt(argc, argv, "bt");
+		int c = getopt(argc, argv, "bt");
+
 		if (c < 0)
 			break;
+
 		switch (c) {
 		case 'b':
 			flags &= ~DF_HUMAN_UNIT;
@@ -821,9 +818,14 @@ int cmd_filesystem_usage(int argc, char **argv)
 	if (check_argc_min(argc - optind, 1))
 		usage(cmd_filesystem_usage_usage);
 
-	for (i = optind; i < argc ; i++) {
-		int r, fd;
-		DIR	*dirstream = NULL;
+	for (i = optind; i < argc; i++) {
+		int ret;
+		int fd;
+		DIR *dirstream = NULL;
+		struct chunk_info *chunkinfo = NULL;
+		struct device_info *devinfo = NULL;
+		int chunkcount = 0;
+		int devcount = 0;
 
 		fd = open_file_or_dir(argv[i], &dirstream);
 		if (fd < 0) {
@@ -834,15 +836,26 @@ int cmd_filesystem_usage(int argc, char **argv)
 		if (more_than_one)
 			printf("\n");
 
-		r = _cmd_disk_free(fd, argv[i], flags);
+		ret = load_chunk_and_device_info(fd, &chunkinfo, &chunkcount,
+				&devinfo, &devcount);
+		if (ret)
+			goto cleanup;
+
+		ret = print_filesystem_usage_overall(fd, chunkinfo, chunkcount,
+				devinfo, devcount, argv[i], flags);
+		if (ret)
+			goto cleanup;
 		printf("\n");
-		r = _cmd_filesystem_usage(fd, argv[i], flags, tabular);
+		ret = print_filesystem_usage_by_chunk(fd, chunkinfo, chunkcount,
+				devinfo, devcount, argv[i], flags, tabular);
+cleanup:
 		close_file_or_dir(fd, dirstream);
+		free(chunkinfo);
+		free(devinfo);
 
-		if (r)
-			return r;
+		if (ret)
+			return ret;
 		more_than_one = 1;
-
 	}
 
 	return 0;
diff --git a/cmds-fi-disk_usage.h b/cmds-fi-disk_usage.h
index dbc2a10f31eb..0779defc71db 100644
--- a/cmds-fi-disk_usage.h
+++ b/cmds-fi-disk_usage.h
@@ -46,9 +46,8 @@ struct chunk_info {
 	u64	num_stripes;
 };
 
-int load_device_info(int fd, struct device_info **device_info_ptr,
-		int *device_info_count);
-int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count);
+int load_chunk_and_device_info(int fd, struct chunk_info **chunkinfo,
+		int *chunkcount, struct device_info **devinfo, int *devcount);
 char *df_pretty_sizes(u64 size, int mode);
 void print_device_chunks(int fd, struct device_info *devinfo,
 		struct chunk_info *chunks_info_ptr,
-- 
1.9.0

