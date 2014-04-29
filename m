Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863AbaD2QC7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 12:02:59 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 8CC21AC4F
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 16:02:58 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 13/14] btrfs-progs: clean up return codes and paths
Date: Tue, 29 Apr 2014 18:02:56 +0200
Message-Id: <4ef54c3972de3163f6f9cde47682131dce2590bb.1398786620.git.dsterba@suse.cz>
In-Reply-To: <cover.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the common patterns with one return statement at the end, pass down error

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-device.c        | 27 +++++++++++++--------------
 cmds-fi-disk_usage.c | 39 +++++++++++++++++++++------------------
 2 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index b2773f249cba..41a5a5c6ca8e 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -442,10 +442,8 @@ static int _cmd_device_usage(int fd, char *path, int mode)
 
 	ret = load_chunk_and_device_info(fd, &chunkinfo, &chunkcount, &devinfo,
 			&devcount);
-	if (ret) {
-		ret = -1;
-		goto exit;
-	}
+	if (ret)
+		goto out;
 
 	for (i = 0; i < devcount; i++) {
 		printf("%s, ID: %llu\n", devinfo[i].path, devinfo[i].devid);
@@ -455,7 +453,7 @@ static int _cmd_device_usage(int fd, char *path, int mode)
 		printf("\n");
 	}
 
-exit:
+out:
 	free(devinfo);
 	free(chunkinfo);
 
@@ -466,6 +464,7 @@ int cmd_device_usage(int argc, char **argv)
 {
 
 	int mode = UNITS_HUMAN;
+	int ret = 0;
 	int	i, more_than_one = 0;
 
 	optind = 1;
@@ -488,28 +487,28 @@ int cmd_device_usage(int argc, char **argv)
 		usage(cmd_device_usage_usage);
 
 	for (i = optind; i < argc ; i++) {
-		int r, fd;
+		int fd;
 		DIR	*dirstream = NULL;
 		if (more_than_one)
 			printf("\n");
 
 		fd = open_file_or_dir(argv[i], &dirstream);
 		if (fd < 0) {
-			fprintf(stderr, "ERROR: can't access to '%s'\n",
+			fprintf(stderr, "ERROR: can't access '%s'\n",
 				argv[1]);
-			return 12;
+			ret = 1;
+			goto out;
 		}
 
-		r = _cmd_device_usage(fd, argv[i], mode);
+		ret = _cmd_device_usage(fd, argv[i], mode);
 		close_file_or_dir(fd, dirstream);
 
-		if (r)
-			return r;
+		if (ret)
+			goto out;
 		more_than_one = 1;
-
 	}
-
-	return 0;
+out:
+	return !!ret;
 }
 
 const struct cmd_group device_cmd_group = {
diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 632ded0d21ab..d0b061ec7eb0 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -67,7 +67,7 @@ static int add_info_to_list(struct chunk_info **info_ptr,
 
 			if (!res) {
 				fprintf(stderr, "ERROR: not enough memory\n");
-				return -1;
+				return -ENOMEM;
 			}
 
 			*info_ptr = res;
@@ -162,7 +162,7 @@ static int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count
 			fprintf(stderr,
 				"ERROR: can't perform the search - %s\n",
 				strerror(e));
-			return -99;
+			return ret;
 		}
 		/* the ioctl returns the number of item it found in nr_items */
 
@@ -178,10 +178,11 @@ static int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count
 			off += sizeof(*sh);
 			item = (struct btrfs_chunk *)(args.buf + off);
 
-			if (add_info_to_list(info_ptr, info_count, item)) {
+			ret = add_info_to_list(info_ptr, info_count, item);
+			if (ret) {
 				*info_ptr = 0;
 				free(*info_ptr);
-				return -100;
+				return ret;
 			}
 
 			off += sh->len;
@@ -319,8 +320,9 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 	double K;
 	u64 raid5_used, raid6_used;
 
-	if ((sargs = load_space_info(fd, path)) == NULL) {
-		ret = -1;
+	sargs = load_space_info(fd, path);
+	if (!sargs) {
+		ret = 1;
 		goto exit;
 	}
 
@@ -331,7 +333,7 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 			"ERROR: couldn't get space info on '%s' - %s\n",
 			path, strerror(e));
 
-		ret = 19;
+		ret = 1;
 		goto exit;
 	}
 	get_raid56_used(fd, chunkinfo, chunkcount, &raid5_used, &raid6_used);
@@ -439,13 +441,13 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
 		return ret;
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: cannot get filesystem info\n");
-		return -1;
+		return ret;
 	}
 
 	info = calloc(fi_args.num_devices, sizeof(struct device_info));
 	if (!info) {
 		fprintf(stderr, "ERROR: not enough memory\n");
-		return -1;
+		return ret;
 	}
 
 	for (i = 0, ndevs = 0 ; i <= fi_args.max_id ; i++) {
@@ -460,7 +462,7 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
 			    "ERROR: cannot get info about device devid=%d\n",
 			    i);
 			free(info);
-			return -1;
+			return ret;
 		}
 
 		info[ndevs].devid = dev_info.devid;
@@ -749,7 +751,7 @@ static int print_filesystem_usage_by_chunk(int fd,
 	sargs = load_space_info(fd, path);
 	if (!sargs) {
 		ret = 1;
-		goto exit;
+		goto out;
 	}
 
 	if (tabular)
@@ -759,9 +761,8 @@ static int print_filesystem_usage_by_chunk(int fd,
 		_cmd_filesystem_usage_linear(mode, sargs, chunkinfo,
 				chunkcount, devinfo, devcount);
 
-exit:
 	free(sargs);
-
+out:
 	return ret;
 }
 
@@ -777,6 +778,7 @@ const char * const cmd_filesystem_usage_usage[] = {
 int cmd_filesystem_usage(int argc, char **argv)
 {
 	int mode = UNITS_HUMAN;
+	int ret = 0;
 	int	i, more_than_one = 0;
 	int	tabular = 0;
 
@@ -803,7 +805,6 @@ int cmd_filesystem_usage(int argc, char **argv)
 		usage(cmd_filesystem_usage_usage);
 
 	for (i = optind; i < argc; i++) {
-		int ret;
 		int fd;
 		DIR *dirstream = NULL;
 		struct chunk_info *chunkinfo = NULL;
@@ -813,9 +814,10 @@ int cmd_filesystem_usage(int argc, char **argv)
 
 		fd = open_file_or_dir(argv[i], &dirstream);
 		if (fd < 0) {
-			fprintf(stderr, "ERROR: can't access to '%s'\n",
+			fprintf(stderr, "ERROR: can't access '%s'\n",
 				argv[1]);
-			return 12;
+			ret = 1;
+			goto out;
 		}
 		if (more_than_one)
 			printf("\n");
@@ -838,11 +840,12 @@ cleanup:
 		free(devinfo);
 
 		if (ret)
-			return ret;
+			goto out;
 		more_than_one = 1;
 	}
 
-	return 0;
+out:
+	return !!ret;
 }
 
 void print_device_chunks(int fd, struct device_info *devinfo,
-- 
1.9.0

