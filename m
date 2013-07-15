Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42746 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab3GOLhC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 07:37:02 -0400
Received: by mail-pb0-f52.google.com with SMTP id xa12so11087041pbc.11
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 04:37:01 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([223.65.188.205])
        by mx.google.com with ESMTPSA id dg3sm60496520pbc.24.2013.07.15.04.36.57
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 15 Jul 2013 04:37:00 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix closing of opendir()
Date: Mon, 15 Jul 2013 19:36:50 +0800
Message-Id: <1373888210-5351-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

valgrind complains open_file_or_dir() causes a memory leak.That is because
if we open a directoy by opendir(), and then we should call closedir()
to free memory.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 btrfs-fragments.c |  4 +++-
 cmds-balance.c    | 25 +++++++++++++++----------
 cmds-device.c     | 15 +++++++++------
 cmds-filesystem.c | 39 +++++++++++++++++++--------------------
 cmds-inspect.c    | 22 ++++++++++++----------
 cmds-qgroup.c     | 20 ++++++++++++--------
 cmds-quota.c      | 10 ++++++----
 cmds-replace.c    | 15 +++++++++------
 cmds-scrub.c      | 15 +++++++++------
 cmds-subvolume.c  | 55 ++++++++++++++++++++++++++++---------------------------
 utils.c           | 37 ++++++++++++++++++++++---------------
 utils.h           |  6 ++++--
 12 files changed, 148 insertions(+), 115 deletions(-)

diff --git a/btrfs-fragments.c b/btrfs-fragments.c
index a012fe1..1fdcb9a 100644
--- a/btrfs-fragments.c
+++ b/btrfs-fragments.c
@@ -403,6 +403,7 @@ int main(int argc, char **argv)
 	int ret;
 	u64 flags = 0;
 	char *dir = "html";
+	DIR *dirstream = NULL;
 
 	while (1) {
 		int c = getopt(argc, argv, "cmso:h");
@@ -437,7 +438,7 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		exit(1);
@@ -447,6 +448,7 @@ int main(int argc, char **argv)
 		flags = BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA;
 
 	ret = list_fragments(fd, flags, dir);
+	close_file_or_dir(fd, dirstream);
 	if (ret)
 		exit(1);
 
diff --git a/cmds-balance.c b/cmds-balance.c
index cffa807..c78b726 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -294,8 +294,9 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
 	int fd;
 	int ret;
 	int e;
+	DIR *dirstream = NULL;
 
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
 		return 12;
@@ -339,7 +340,7 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
 	}
 
 out:
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 	return ret;
 }
 
@@ -487,13 +488,14 @@ static int cmd_balance_pause(int argc, char **argv)
 	int fd;
 	int ret;
 	int e;
+	DIR *dirstream = NULL;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_balance_pause_usage);
 
 	path = argv[1];
 
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
 		return 12;
@@ -501,7 +503,7 @@ static int cmd_balance_pause(int argc, char **argv)
 
 	ret = ioctl(fd, BTRFS_IOC_BALANCE_CTL, BTRFS_BALANCE_CTL_PAUSE);
 	e = errno;
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: balance pause on '%s' failed - %s\n",
@@ -524,13 +526,14 @@ static int cmd_balance_cancel(int argc, char **argv)
 	int fd;
 	int ret;
 	int e;
+	DIR *dirstream = NULL;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_balance_cancel_usage);
 
 	path = argv[1];
 
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
 		return 12;
@@ -538,7 +541,7 @@ static int cmd_balance_cancel(int argc, char **argv)
 
 	ret = ioctl(fd, BTRFS_IOC_BALANCE_CTL, BTRFS_BALANCE_CTL_CANCEL);
 	e = errno;
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: balance cancel on '%s' failed - %s\n",
@@ -559,6 +562,7 @@ static int cmd_balance_resume(int argc, char **argv)
 {
 	struct btrfs_ioctl_balance_args args;
 	const char *path;
+	DIR *dirstream = NULL;
 	int fd;
 	int ret;
 	int e;
@@ -568,7 +572,7 @@ static int cmd_balance_resume(int argc, char **argv)
 
 	path = argv[1];
 
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
 		return 12;
@@ -579,7 +583,7 @@ static int cmd_balance_resume(int argc, char **argv)
 
 	ret = ioctl(fd, BTRFS_IOC_BALANCE_V2, &args);
 	e = errno;
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 
 	if (ret < 0) {
 		if (e == ECANCELED) {
@@ -626,6 +630,7 @@ static int cmd_balance_status(int argc, char **argv)
 {
 	struct btrfs_ioctl_balance_args args;
 	const char *path;
+	DIR *dirstream = NULL;
 	int fd;
 	int verbose = 0;
 	int ret;
@@ -657,7 +662,7 @@ static int cmd_balance_status(int argc, char **argv)
 
 	path = argv[optind];
 
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
 		return 2;
@@ -665,7 +670,7 @@ static int cmd_balance_status(int argc, char **argv)
 
 	ret = ioctl(fd, BTRFS_IOC_BALANCE_PROGRESS, &args);
 	e = errno;
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 
 	if (ret < 0) {
 		if (e == ENOTCONN) {
diff --git a/cmds-device.c b/cmds-device.c
index 41e79d3..4834cd4 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -54,13 +54,14 @@ static int cmd_add_dev(int argc, char **argv)
 {
 	char	*mntpnt;
 	int	i, fdmnt, ret=0, e;
+	DIR	*dirstream = NULL;
 
 	if (check_argc_min(argc, 3))
 		usage(cmd_add_dev_usage);
 
 	mntpnt = argv[argc - 1];
 
-	fdmnt = open_file_or_dir(mntpnt);
+	fdmnt = open_file_or_dir(mntpnt, &dirstream);
 	if (fdmnt < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", mntpnt);
 		return 12;
@@ -127,7 +128,7 @@ static int cmd_add_dev(int argc, char **argv)
 
 	}
 
-	close(fdmnt);
+	close_file_or_dir(fdmnt, dirstream);
 	if (ret)
 		return ret+20;
 	else
@@ -144,13 +145,14 @@ static int cmd_rm_dev(int argc, char **argv)
 {
 	char	*mntpnt;
 	int	i, fdmnt, ret=0, e;
+	DIR	*dirstream = NULL;
 
 	if (check_argc_min(argc, 3))
 		usage(cmd_rm_dev_usage);
 
 	mntpnt = argv[argc - 1];
 
-	fdmnt = open_file_or_dir(mntpnt);
+	fdmnt = open_file_or_dir(mntpnt, &dirstream);
 	if (fdmnt < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", mntpnt);
 		return 12;
@@ -170,7 +172,7 @@ static int cmd_rm_dev(int argc, char **argv)
 		}
 	}
 
-	close(fdmnt);
+	close_file_or_dir(fdmnt, dirstream);
 	if( ret)
 		return ret+20;
 	else
@@ -297,6 +299,7 @@ static int cmd_dev_stats(int argc, char **argv)
 	char c;
 	int err = 0;
 	__u64 flags = 0;
+	DIR *dirstream = NULL;
 
 	optind = 1;
 	while ((c = getopt(argc, argv, "z")) != -1) {
@@ -321,7 +324,7 @@ static int cmd_dev_stats(int argc, char **argv)
 
 	path = argv[optind];
 
-	fdmnt = open_path_or_dev_mnt(path);
+	fdmnt = open_path_or_dev_mnt(path, &dirstream);
 
 	if (fdmnt < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
@@ -389,7 +392,7 @@ static int cmd_dev_stats(int argc, char **argv)
 
 out:
 	free(di_args);
-	close(fdmnt);
+	close_file_or_dir(fdmnt, dirstream);
 
 	return err;
 }
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f41a72a..eee8be7 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -52,13 +52,14 @@ static int cmd_df(int argc, char **argv)
 	int fd;
 	int e;
 	char *path;
+	DIR  *dirstream = NULL;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_df_usage);
 
 	path = argv[1];
 
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
 		return 12;
@@ -76,14 +77,11 @@ static int cmd_df(int argc, char **argv)
 	if (ret) {
 		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
 			path, strerror(e));
-		close(fd);
-		free(sargs);
-		return ret;
+		goto out;
 	}
 	if (!sargs->total_spaces) {
-		close(fd);
-		free(sargs);
-		return 0;
+		ret = 0;
+		goto out;
 	}
 
 	count = sargs->total_spaces;
@@ -91,9 +89,8 @@ static int cmd_df(int argc, char **argv)
 	sargs = realloc(sargs, sizeof(struct btrfs_ioctl_space_args) +
 			(count * sizeof(struct btrfs_ioctl_space_info)));
 	if (!sargs) {
-		close(fd);
-		free(sargs_orig);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	sargs->space_slots = count;
@@ -104,9 +101,7 @@ static int cmd_df(int argc, char **argv)
 	if (ret) {
 		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
 			path, strerror(e));
-		close(fd);
-		free(sargs);
-		return ret;
+		goto out;
 	}
 
 	for (i = 0; i < sargs->total_spaces; i++) {
@@ -160,7 +155,8 @@ static int cmd_df(int argc, char **argv)
 		printf("%s: total=%s, used=%s\n", description, total_bytes,
 		       used_bytes);
 	}
-	close(fd);
+out:
+	close_file_or_dir(fd, dirstream);
 	free(sargs);
 
 	return 0;
@@ -291,13 +287,14 @@ static int cmd_sync(int argc, char **argv)
 {
 	int 	fd, res, e;
 	char	*path;
+	DIR	*dirstream = NULL;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_sync_usage);
 
 	path = argv[1];
 
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
 		return 12;
@@ -306,7 +303,7 @@ static int cmd_sync(int argc, char **argv)
 	printf("FSSync '%s'\n", path);
 	res = ioctl(fd, BTRFS_IOC_SYNC);
 	e = errno;
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 	if( res < 0 ){
 		fprintf(stderr, "ERROR: unable to fs-syncing '%s' - %s\n", 
 			path, strerror(e));
@@ -356,6 +353,7 @@ static int cmd_defrag(int argc, char **argv)
 	struct btrfs_ioctl_defrag_range_args range;
 	int e=0;
 	int compress_type = BTRFS_COMPRESS_NONE;
+	DIR *dirstream = NULL;
 
 	optind = 1;
 	while(1) {
@@ -411,7 +409,7 @@ static int cmd_defrag(int argc, char **argv)
 	for (i = optind; i < argc; i++) {
 		if (verbose)
 			printf("%s\n", argv[i]);
-		fd = open_file_or_dir(argv[i]);
+		fd = open_file_or_dir(argv[i], &dirstream);
 		if (fd < 0) {
 			fprintf(stderr, "failed to open %s\n", argv[i]);
 			perror("open:");
@@ -438,7 +436,7 @@ static int cmd_defrag(int argc, char **argv)
 				argv[i], strerror(e));
 			errors++;
 		}
-		close(fd);
+		close_file_or_dir(fd, dirstream);
 	}
 	if (verbose)
 		printf("%s\n", BTRFS_BUILD_VERSION);
@@ -463,6 +461,7 @@ static int cmd_resize(int argc, char **argv)
 	struct btrfs_ioctl_vol_args	args;
 	int	fd, res, len, e;
 	char	*amount, *path;
+	DIR	*dirstream = NULL;
 
 	if (check_argc_exact(argc, 3))
 		usage(cmd_resize_usage);
@@ -477,7 +476,7 @@ static int cmd_resize(int argc, char **argv)
 		return 14;
 	}
 
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
 		return 12;
@@ -487,7 +486,7 @@ static int cmd_resize(int argc, char **argv)
 	strncpy_null(args.name, amount);
 	res = ioctl(fd, BTRFS_IOC_RESIZE, &args);
 	e = errno;
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 	if( res < 0 ){
 		fprintf(stderr, "ERROR: unable to resize '%s' - %s\n", 
 			path, strerror(e));
diff --git a/cmds-inspect.c b/cmds-inspect.c
index 30b41fc..231819d 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -92,6 +92,7 @@ static int cmd_inode_resolve(int argc, char **argv)
 	int fd;
 	int verbose = 0;
 	int ret;
+	DIR *dirstream = NULL;
 
 	optind = 1;
 	while (1) {
@@ -111,7 +112,7 @@ static int cmd_inode_resolve(int argc, char **argv)
 	if (check_argc_exact(argc - optind, 2))
 		usage(cmd_inode_resolve_usage);
 
-	fd = open_file_or_dir(argv[optind+1]);
+	fd = open_file_or_dir(argv[optind+1], &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", argv[optind+1]);
 		return 12;
@@ -119,7 +120,7 @@ static int cmd_inode_resolve(int argc, char **argv)
 
 	ret = __ino_to_path_fd(atoll(argv[optind]), fd, verbose,
 			       argv[optind+1]);
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 	return ret;
 
 }
@@ -148,6 +149,7 @@ static int cmd_logical_resolve(int argc, char **argv)
 	u64 size = 4096;
 	char full_path[4096];
 	char *path_ptr;
+	DIR *dirstream = NULL;
 
 	optind = 1;
 	while (1) {
@@ -183,7 +185,7 @@ static int cmd_logical_resolve(int argc, char **argv)
 	loi.size = size;
 	loi.inodes = (uintptr_t)inodes;
 
-	fd = open_file_or_dir(argv[optind+1]);
+	fd = open_file_or_dir(argv[optind+1], &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", argv[optind+1]);
 		ret = 12;
@@ -216,6 +218,7 @@ static int cmd_logical_resolve(int argc, char **argv)
 		u64 root = inodes->val[i+2];
 		int path_fd;
 		char *name;
+		DIR *dirs = NULL;
 
 		if (getpath) {
 			name = btrfs_list_path_for_root(fd, root);
@@ -232,7 +235,7 @@ static int cmd_logical_resolve(int argc, char **argv)
 						name);
 				BUG_ON(ret >= bytes_left);
 				free(name);
-				path_fd = open_file_or_dir(full_path);
+				path_fd = open_file_or_dir(full_path, &dirs);
 				if (path_fd < 0) {
 					fprintf(stderr, "ERROR: can't access "
 						"'%s'\n", full_path);
@@ -241,7 +244,7 @@ static int cmd_logical_resolve(int argc, char **argv)
 			}
 			__ino_to_path_fd(inum, path_fd, verbose, full_path);
 			if (path_fd != fd)
-				close(path_fd);
+				close_file_or_dir(path_fd, dirs);
 		} else {
 			printf("inode %llu offset %llu root %llu\n", inum,
 				offset, root);
@@ -249,8 +252,7 @@ static int cmd_logical_resolve(int argc, char **argv)
 	}
 
 out:
-	if (fd >= 0)
-		close(fd);
+	close_file_or_dir(fd, dirstream);
 	free(inodes);
 	return ret;
 }
@@ -267,11 +269,12 @@ static int cmd_subvolid_resolve(int argc, char **argv)
 	int fd = -1;
 	u64 subvol_id;
 	char path[BTRFS_PATH_NAME_MAX + 1];
+	DIR *dirstream = NULL;
 
 	if (check_argc_exact(argc, 3))
 		usage(cmd_subvolid_resolve_usage);
 
-	fd = open_file_or_dir(argv[2]);
+	fd = open_file_or_dir(argv[2], &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", argv[2]);
 		ret = -ENOENT;
@@ -292,8 +295,7 @@ static int cmd_subvolid_resolve(int argc, char **argv)
 	printf("%s\n", path);
 
 out:
-	if (fd >= 0)
-		close(fd);
+	close_file_or_dir(fd, dirstream);
 	return ret ? 1 : 0;
 }
 
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 95aca9b..29b3405 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -39,6 +39,7 @@ static int qgroup_assign(int assign, int argc, char **argv)
 	int e;
 	char *path = argv[3];
 	struct btrfs_ioctl_qgroup_assign_args args;
+	DIR *dirstream = NULL;
 
 	if (check_argc_exact(argc, 4))
 		return -1;
@@ -55,7 +56,7 @@ static int qgroup_assign(int assign, int argc, char **argv)
 		fprintf(stderr, "ERROR: bad relation requested '%s'\n", path);
 		return 12;
 	}
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 12;
@@ -63,7 +64,7 @@ static int qgroup_assign(int assign, int argc, char **argv)
 
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_ASSIGN, &args);
 	e = errno;
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: unable to assign quota group: %s\n",
 			strerror(e));
@@ -79,6 +80,7 @@ static int qgroup_create(int create, int argc, char **argv)
 	int e;
 	char *path = argv[2];
 	struct btrfs_ioctl_qgroup_create_args args;
+	DIR *dirstream = NULL;
 
 	if (check_argc_exact(argc, 3))
 		return -1;
@@ -87,7 +89,7 @@ static int qgroup_create(int create, int argc, char **argv)
 	args.create = create;
 	args.qgroupid = parse_qgroupid(argv[1]);
 
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 12;
@@ -95,7 +97,7 @@ static int qgroup_create(int create, int argc, char **argv)
 
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_CREATE, &args);
 	e = errno;
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: unable to create quota group: %s\n",
 			strerror(e));
@@ -300,11 +302,12 @@ static int cmd_qgroup_show(int argc, char **argv)
 	int fd;
 	int e;
 	char *path = argv[1];
+	DIR *dirstream = NULL;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_qgroup_show_usage);
 
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 12;
@@ -312,7 +315,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	ret = list_qgroups(fd);
 	e = errno;
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: can't list qgroups: %s\n",
 				strerror(e));
@@ -342,6 +345,7 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	unsigned long long size;
 	int compressed = 0;
 	int exclusive = 0;
+	DIR *dirstream = NULL;
 
 	optind = 1;
 	while (1) {
@@ -405,7 +409,7 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	} else
 		usage(cmd_qgroup_limit_usage);
 
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 12;
@@ -413,7 +417,7 @@ static int cmd_qgroup_limit(int argc, char **argv)
 
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_LIMIT, &args);
 	e = errno;
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: unable to limit requested quota group: "
 			"%s\n", strerror(e));
diff --git a/cmds-quota.c b/cmds-quota.c
index 2e2971a..792aa7e 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -37,6 +37,7 @@ int quota_ctl(int cmd, int argc, char **argv)
 	int e;
 	char *path = argv[1];
 	struct btrfs_ioctl_quota_ctl_args args;
+	DIR *dirstream = NULL;
 
 	if (check_argc_exact(argc, 2))
 		return -1;
@@ -44,7 +45,7 @@ int quota_ctl(int cmd, int argc, char **argv)
 	memset(&args, 0, sizeof(args));
 	args.cmd = cmd;
 
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 12;
@@ -52,7 +53,7 @@ int quota_ctl(int cmd, int argc, char **argv)
 
 	ret = ioctl(fd, BTRFS_IOC_QUOTA_CTL, &args);
 	e = errno;
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: quota command failed: %s\n",
 			strerror(e));
@@ -108,6 +109,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 	char *path = NULL;
 	struct btrfs_ioctl_quota_rescan_args args;
 	int ioctlnum = BTRFS_IOC_QUOTA_RESCAN;
+	DIR *dirstream = NULL;
 
 	optind = 1;
 	while (1) {
@@ -129,7 +131,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 	memset(&args, 0, sizeof(args));
 
 	path = argv[optind];
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 12;
@@ -137,7 +139,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 
 	ret = ioctl(fd, ioctlnum, &args);
 	e = errno;
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 
 	if (ioctlnum == BTRFS_IOC_QUOTA_RESCAN) {
 		if (ret < 0) {
diff --git a/cmds-replace.c b/cmds-replace.c
index 6397bb5..5d3c2f0 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -143,6 +143,7 @@ static int cmd_start_replace(int argc, char **argv)
 	u64 dstdev_block_count;
 	int do_not_background = 0;
 	int mixed = 0;
+	DIR *dirstream = NULL;
 
 	while ((c = getopt(argc, argv, "Brf")) != -1) {
 		switch (c) {
@@ -169,7 +170,7 @@ static int cmd_start_replace(int argc, char **argv)
 		usage(cmd_start_replace_usage);
 	path = argv[optind + 2];
 
-	fdmnt = open_path_or_dev_mnt(path);
+	fdmnt = open_path_or_dev_mnt(path, &dirstream);
 
 	if (fdmnt < 0) {
 		fprintf(stderr, "ERROR: can't access \"%s\": %s\n",
@@ -336,7 +337,7 @@ static int cmd_start_replace(int argc, char **argv)
 			goto leave_with_error;
 		}
 	}
-	close(fdmnt);
+	close_file_or_dir(fdmnt, dirstream);
 	return 0;
 
 leave_with_error:
@@ -367,6 +368,7 @@ static int cmd_status_replace(int argc, char **argv)
 	char *path;
 	int once = 0;
 	int ret;
+	DIR *dirstream = NULL;
 
 	while ((c = getopt(argc, argv, "1")) != -1) {
 		switch (c) {
@@ -383,7 +385,7 @@ static int cmd_status_replace(int argc, char **argv)
 		usage(cmd_status_replace_usage);
 
 	path = argv[optind];
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	e = errno;
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access \"%s\": %s\n",
@@ -392,7 +394,7 @@ static int cmd_status_replace(int argc, char **argv)
 	}
 
 	ret = print_replace_status(fd, path, once);
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 	return ret;
 }
 
@@ -533,6 +535,7 @@ static int cmd_cancel_replace(int argc, char **argv)
 	int fd;
 	int e;
 	char *path;
+	DIR *dirstream = NULL;
 
 	while ((c = getopt(argc, argv, "")) != -1) {
 		switch (c) {
@@ -546,7 +549,7 @@ static int cmd_cancel_replace(int argc, char **argv)
 		usage(cmd_cancel_replace_usage);
 
 	path = argv[optind];
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access \"%s\": %s\n",
 			path, strerror(errno));
@@ -556,7 +559,7 @@ static int cmd_cancel_replace(int argc, char **argv)
 	args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_CANCEL;
 	ret = ioctl(fd, BTRFS_IOC_DEV_REPLACE, &args);
 	e = errno;
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 	if (ret) {
 		fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_CANCEL) failed on \"%s\": %s, %s\n",
 			path, strerror(e),
diff --git a/cmds-scrub.c b/cmds-scrub.c
index c0dc584..4cc6968 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1074,6 +1074,7 @@ static int scrub_start(int argc, char **argv, int resume)
 	pthread_mutex_t spc_write_mutex = PTHREAD_MUTEX_INITIALIZER;
 	void *terr;
 	u64 devid;
+	DIR *dirstream = NULL;
 
 	optind = 1;
 	while ((c = getopt(argc, argv, "BdqrRc:n:")) != -1) {
@@ -1129,7 +1130,7 @@ static int scrub_start(int argc, char **argv, int resume)
 
 	path = argv[optind];
 
-	fdmnt = open_path_or_dev_mnt(path);
+	fdmnt = open_path_or_dev_mnt(path, &dirstream);
 
 	if (fdmnt < 0) {
 		ERR(!do_quiet, "ERROR: can't access '%s'\n", path);
@@ -1453,7 +1454,7 @@ out:
 		if (sock_path[0])
 			unlink(sock_path);
 	}
-	close(fdmnt);
+	close_file_or_dir(fdmnt, dirstream);
 
 	if (err)
 		return 1;
@@ -1493,13 +1494,14 @@ static int cmd_scrub_cancel(int argc, char **argv)
 	char *path;
 	int ret;
 	int fdmnt = -1;
+	DIR *dirstream = NULL;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_scrub_cancel_usage);
 
 	path = argv[1];
 
-	fdmnt = open_path_or_dev_mnt(path);
+	fdmnt = open_path_or_dev_mnt(path, &dirstream);
 	if (fdmnt < 0) {
 		fprintf(stderr, "ERROR: could not open %s: %s\n",
 			path, strerror(errno));
@@ -1520,8 +1522,7 @@ static int cmd_scrub_cancel(int argc, char **argv)
 	printf("scrub cancelled\n");
 
 out:
-	if (fdmnt != -1)
-		close(fdmnt);
+	close_file_or_dir(fdmnt, dirstream);
 	return ret;
 }
 
@@ -1572,6 +1573,7 @@ static int cmd_scrub_status(int argc, char **argv)
 	char fsid[37];
 	int fdres = -1;
 	int err = 0;
+	DIR *dirstream = NULL;
 
 	optind = 1;
 	while ((c = getopt(argc, argv, "dR")) != -1) {
@@ -1593,7 +1595,7 @@ static int cmd_scrub_status(int argc, char **argv)
 
 	path = argv[optind];
 
-	fdmnt = open_path_or_dev_mnt(path);
+	fdmnt = open_path_or_dev_mnt(path, &dirstream);
 
 	if (fdmnt < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
@@ -1680,6 +1682,7 @@ out:
 	free(di_args);
 	if (fdres > -1)
 		close(fdres);
+	close_file_or_dir(fdmnt, dirstream);
 
 	return err;
 }
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ccb4762..9c3c609 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -79,6 +79,7 @@ static int cmd_subvol_create(int argc, char **argv)
 	char	*dstdir;
 	char	*dst;
 	struct btrfs_qgroup_inherit *inherit = NULL;
+	DIR	*dirstream = NULL;
 
 	optind = 1;
 	while (1) {
@@ -133,7 +134,7 @@ static int cmd_subvol_create(int argc, char **argv)
 		goto out;
 	}
 
-	fddst = open_file_or_dir(dstdir);
+	fddst = open_file_or_dir(dstdir, &dirstream);
 	if (fddst < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
 		goto out;
@@ -167,8 +168,7 @@ static int cmd_subvol_create(int argc, char **argv)
 
 	retval = 0;	/* success */
 out:
-	if (fddst != -1)
-		close(fddst);
+	close_file_or_dir(fddst, dirstream);
 	free(inherit);
 
 	return retval;
@@ -205,6 +205,7 @@ static int cmd_subvol_delete(int argc, char **argv)
 	struct btrfs_ioctl_vol_args	args;
 	char	*dname, *vname, *cpath;
 	char	*path;
+	DIR	*dirstream = NULL;
 
 	if (argc < 2)
 		usage(cmd_subvol_delete_usage);
@@ -247,7 +248,7 @@ again:
 		goto out;
 	}
 
-	fd = open_file_or_dir(dname);
+	fd = open_file_or_dir(dname, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", dname);
 		ret = 12;
@@ -259,7 +260,7 @@ again:
 	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
 	e = errno;
 
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 
 	if(res < 0 ){
 		fprintf( stderr, "ERROR: cannot delete '%s/%s' - %s\n",
@@ -328,6 +329,7 @@ static int cmd_subvol_list(int argc, char **argv)
 		{"sort", 1, NULL, 'S'},
 		{0, 0, 0, 0}
 	};
+	DIR *dirstream = NULL;
 
 	filter_set = btrfs_list_alloc_filter_set();
 	comparer_set = btrfs_list_alloc_comparer_set();
@@ -432,7 +434,7 @@ static int cmd_subvol_list(int argc, char **argv)
 		goto out;
 	}
 
-	fd = open_file_or_dir(subvol);
+	fd = open_file_or_dir(subvol, &dirstream);
 	if (fd < 0) {
 		ret = -1;
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
@@ -470,8 +472,7 @@ static int cmd_subvol_list(int argc, char **argv)
 				!is_list_all && !is_only_in_path, NULL);
 
 out:
-	if (fd != -1)
-		close(fd);
+	close_file_or_dir(fd, dirstream);
 	if (filter_set)
 		btrfs_list_free_filter_set(filter_set);
 	if (comparer_set)
@@ -505,6 +506,7 @@ static int cmd_snapshot(int argc, char **argv)
 	char	*dstdir;
 	struct btrfs_ioctl_vol_args_v2	args;
 	struct btrfs_qgroup_inherit *inherit = NULL;
+	DIR *dirstream1 = NULL, *dirstream2 = NULL;
 
 	optind = 1;
 	memset(&args, 0, sizeof(args));
@@ -585,13 +587,13 @@ static int cmd_snapshot(int argc, char **argv)
 		goto out;
 	}
 
-	fddst = open_file_or_dir(dstdir);
+	fddst = open_file_or_dir(dstdir, &dirstream1);
 	if (fddst < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
 		goto out;
 	}
 
-	fd = open_file_or_dir(subvol);
+	fd = open_file_or_dir(subvol, &dirstream2);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
 		goto out;
@@ -625,10 +627,8 @@ static int cmd_snapshot(int argc, char **argv)
 	retval = 0;	/* success */
 
 out:
-	if (fd != -1)
-		close(fd);
-	if (fddst != -1)
-		close(fddst);
+	close_file_or_dir(fddst, dirstream1);
+	close_file_or_dir(fd, dirstream2);
 	free(inherit);
 
 	return retval;
@@ -647,6 +647,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 	char *subvol;
 	struct btrfs_list_filter_set *filter_set;
 	u64 default_id;
+	DIR *dirstream = NULL;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_subvol_get_default_usage);
@@ -663,7 +664,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 		return 1;
 	}
 
-	fd = open_file_or_dir(subvol);
+	fd = open_file_or_dir(subvol, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 1;
@@ -704,8 +705,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 	if (filter_set)
 		btrfs_list_free_filter_set(filter_set);
 out:
-	if (fd != -1)
-		close(fd);
+	close_file_or_dir(fd, dirstream);
 	if (ret)
 		return 1;
 	return 0;
@@ -723,6 +723,7 @@ static int cmd_subvol_set_default(int argc, char **argv)
 	u64	objectid;
 	char	*path;
 	char	*subvolid;
+	DIR	*dirstream = NULL;
 
 	if (check_argc_exact(argc, 3))
 		usage(cmd_subvol_set_default_usage);
@@ -736,7 +737,7 @@ static int cmd_subvol_set_default(int argc, char **argv)
 		return 1;
 	}
 
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
 		return 1;
@@ -744,7 +745,7 @@ static int cmd_subvol_set_default(int argc, char **argv)
 
 	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
 	e = errno;
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: unable to set a new default subvolume - %s\n",
 			strerror(e));
@@ -765,6 +766,7 @@ static int cmd_find_new(int argc, char **argv)
 	int ret;
 	char *subvol;
 	u64 last_gen;
+	DIR *dirstream = NULL;
 
 	if (check_argc_exact(argc, 3))
 		usage(cmd_find_new_usage);
@@ -782,13 +784,13 @@ static int cmd_find_new(int argc, char **argv)
 		return 13;
 	}
 
-	fd = open_file_or_dir(subvol);
+	fd = open_file_or_dir(subvol, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
 	ret = btrfs_list_find_updated_files(fd, 0, last_gen);
-	close(fd);
+	close_file_or_dir(fd, dirstream);
 	if (ret)
 		return 19;
 	return 0;
@@ -811,6 +813,7 @@ static int cmd_subvol_show(int argc, char **argv)
 	u64 sv_id, mntid;
 	int fd = -1, mntfd = -1;
 	int ret = -1;
+	DIR *dirstream1 = NULL, *dirstream2 = NULL;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_subvol_show_usage);
@@ -842,7 +845,7 @@ static int cmd_subvol_show(int argc, char **argv)
 	ret = -1;
 	svpath = get_subvol_name(mnt, fullpath);
 
-	fd = open_file_or_dir(fullpath);
+	fd = open_file_or_dir(fullpath, &dirstream1);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", fullpath);
 		goto out;
@@ -855,7 +858,7 @@ static int cmd_subvol_show(int argc, char **argv)
 		goto out;
 	}
 
-	mntfd = open_file_or_dir(mnt);
+	mntfd = open_file_or_dir(mnt, &dirstream2);
 	if (mntfd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", mnt);
 		goto out;
@@ -936,10 +939,8 @@ static int cmd_subvol_show(int argc, char **argv)
 		btrfs_list_free_filter_set(filter_set);
 
 out:
-	if (mntfd >= 0)
-		close(mntfd);
-	if (fd >= 0)
-		close(fd);
+	close_file_or_dir(fd, dirstream1);
+	close_file_or_dir(mntfd, dirstream2);
 	if (mnt)
 		free(mnt);
 	if (fullpath)
diff --git a/utils.c b/utils.c
index a411725..5da9b9c 100644
--- a/utils.c
+++ b/utils.c
@@ -31,7 +31,6 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <uuid/uuid.h>
-#include <dirent.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <mntent.h>
@@ -706,7 +705,7 @@ out:
  *
  * On error, return -1, errno should be set.
  */
-int open_path_or_dev_mnt(const char *path)
+int open_path_or_dev_mnt(const char *path, DIR **dirstream)
 {
 	char mp[BTRFS_PATH_NAME_MAX + 1];
 	int fdmnt;
@@ -720,9 +719,9 @@ int open_path_or_dev_mnt(const char *path)
 			errno = EINVAL;
 			return -1;
 		}
-		fdmnt = open_file_or_dir(mp);
+		fdmnt = open_file_or_dir(mp, dirstream);
 	} else {
-		fdmnt = open_file_or_dir(path);
+		fdmnt = open_file_or_dir(path, dirstream);
 	}
 
 	return fdmnt;
@@ -1476,11 +1475,11 @@ u64 parse_size(char *s)
 	return strtoull(s, NULL, 10) * mult;
 }
 
-int open_file_or_dir(const char *fname)
+int open_file_or_dir(const char *fname, DIR **dirstream)
 {
 	int ret;
 	struct stat st;
-	DIR *dirstream = NULL;
+	*dirstream = NULL;
 	int fd;
 
 	ret = stat(fname, &st);
@@ -1488,22 +1487,30 @@ int open_file_or_dir(const char *fname)
 		return -1;
 	}
 	if (S_ISDIR(st.st_mode)) {
-		dirstream = opendir(fname);
-		if (!dirstream) {
+		*dirstream = opendir(fname);
+		if (!*dirstream)
 			return -2;
-		}
-		fd = dirfd(dirstream);
+		fd = dirfd(*dirstream);
 	} else {
 		fd = open(fname, O_RDWR);
 	}
 	if (fd < 0) {
 		fd = -3;
-		if (dirstream)
-			closedir(dirstream);
+		if (*dirstream)
+			closedir(*dirstream);
 	}
 	return fd;
 }
 
+void close_file_or_dir(int fd, DIR *dirstream)
+{
+	if (dirstream)
+		closedir(dirstream);
+	else if (fd >= 0) {
+		close(fd);
+	}
+}
+
 int get_device_info(int fd, u64 devid,
 		    struct btrfs_ioctl_dev_info_args *di_args)
 {
@@ -1536,6 +1543,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 	struct btrfs_fs_devices *fs_devices_mnt = NULL;
 	struct btrfs_ioctl_dev_info_args *di_args;
 	char mp[BTRFS_PATH_NAME_MAX + 1];
+	DIR *dirstream = NULL;
 
 	memset(fi_args, 0, sizeof(*fi_args));
 
@@ -1566,7 +1574,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 	}
 
 	/* at this point path must not be for a block device */
-	fd = open_file_or_dir(path);
+	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		ret = -errno;
 		goto out;
@@ -1603,8 +1611,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 	BUG_ON(ndevs == 0);
 	ret = 0;
 out:
-	if (fd != -1)
-		close(fd);
+	close_file_or_dir(fd, dirstream);
 	return ret;
 }
 
diff --git a/utils.h b/utils.h
index 3c17e14..e15bee8 100644
--- a/utils.h
+++ b/utils.h
@@ -21,6 +21,7 @@
 
 #include <sys/stat.h>
 #include "ctree.h"
+#include <dirent.h>
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 
@@ -48,7 +49,8 @@ char *pretty_sizes(u64 size);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 int btrfs_scan_block_devices(int run_ioctl);
 u64 parse_size(char *s);
-int open_file_or_dir(const char *fname);
+int open_file_or_dir(const char *fname, DIR **dirstream);
+void close_file_or_dir(int fd, DIR *dirstream);
 int get_device_info(int fd, u64 devid,
 		    struct btrfs_ioctl_dev_info_args *di_args);
 int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
@@ -59,7 +61,7 @@ int set_label(const char *btrfs_dev, const char *label);
 char *__strncpy__null(char *dest, const char *src, size_t n);
 int is_block_device(const char *file);
 int get_btrfs_mount(const char *path, char *mp, size_t mp_size);
-int open_path_or_dev_mnt(const char *path);
+int open_path_or_dev_mnt(const char *path, DIR **dirstream);
 int is_swap_device(const char *file);
 u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
-- 
1.8.0.1

