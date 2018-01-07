Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:38745 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754557AbeAGVyE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Jan 2018 16:54:04 -0500
Received: by mail-pf0-f179.google.com with SMTP id u25so4624368pfg.5
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Jan 2018 13:54:04 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>
Subject: [PATCH] btrfs-progs: treewide: Replace strerror(errno) with %m.
Date: Sun,  7 Jan 2018 13:54:21 -0800
Message-Id: <1515362061-13281-1-git-send-email-rosenp@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As btrfs is specific to Linux, %m can be used instead of strerror(errno)
in format strings. This has some size reduction benefits for embedded
systems.

glibc, musl, and uclibc-ng all support %m as a modifier to printf.
A quick glance at the BIONIC libc source indicates that it has
support for %m as well. BSDs and Windows do not but I do believe
them to be beyond the scope of btrfs-progs.

Compiled sizes on Ubuntu 16.04:

Before:
3916512 btrfs
233688  libbtrfs.so.0.1
4899    bcp
2367672 btrfs-convert
2208488 btrfs-corrupt-block
13302   btrfs-debugfs
2152160 btrfs-debug-tree
2136024 btrfs-find-root
2287592 btrfs-image
2144600 btrfs-map-logical
2130760 btrfs-select-super
2152608 btrfstune
2131760 btrfs-zero-log
2277752 mkfs.btrfs
9166    show-blocks

After:
3908744 btrfs
233256  libbtrfs.so.0.1
4899    bcp
2366560 btrfs-convert
2207432 btrfs-corrupt-block
13302   btrfs-debugfs
2151104 btrfs-debug-tree
2134968 btrfs-find-root
2281864 btrfs-image
2143536 btrfs-map-logical
2129704 btrfs-select-super
2151552 btrfstune
2130696 btrfs-zero-log
2276272 mkfs.btrfs
9166    show-blocks

Total savings: 23928 (24 kilo)bytes

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 btrfs-list.c              | 24 +++++++++----------
 cmds-balance.c            |  9 ++++---
 cmds-device.c             | 25 +++++++++-----------
 cmds-fi-usage.c           | 16 +++++--------
 cmds-filesystem.c         | 26 ++++++++------------
 cmds-inspect-dump-super.c |  4 ++--
 cmds-inspect-tree-stats.c |  4 ++--
 cmds-inspect.c            |  6 ++---
 cmds-qgroup.c             | 18 +++++---------
 cmds-quota.c              | 12 ++++------
 cmds-receive.c            |  2 +-
 cmds-replace.c            | 26 ++++++++++----------
 cmds-restore.c            | 21 ++++++++---------
 cmds-scrub.c              | 23 ++++++++----------
 cmds-subvolume.c          | 32 ++++++++++---------------
 convert/main.c            |  4 ++--
 disk-io.c                 |  7 +++---
 image/main.c              | 60 ++++++++++++++++++++---------------------------
 mkfs/common.c             |  4 ++--
 mkfs/main.c               | 46 +++++++++++++++++-------------------
 send-utils.c              | 17 ++++++--------
 tests/fssum.c             | 27 +++++++++------------
 utils.c                   | 42 ++++++++++++++-------------------
 uuid-tree.c               |  4 ++--
 volumes.c                 |  7 +++---
 25 files changed, 197 insertions(+), 269 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index b6d7658..e01c589 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -644,8 +644,8 @@ static int lookup_ino_path(int fd, struct root_info *ri)
 			ri->ref_tree = 0;
 			return -ENOENT;
 		}
-		error("failed to lookup path for root %llu: %s",
-			(unsigned long long)ri->ref_tree, strerror(errno));
+		error("failed to lookup path for root %llu: %m",
+			(unsigned long long)ri->ref_tree);
 		return ret;
 	}
 
@@ -695,9 +695,8 @@ static u64 find_root_gen(int fd)
 	/* this ioctl fills in ino_args->treeid */
 	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &ino_args);
 	if (ret < 0) {
-		error("failed to lookup path for dirid %llu: %s",
-			(unsigned long long)BTRFS_FIRST_FREE_OBJECTID,
-			strerror(errno));
+		error("failed to lookup path for dirid %llu: %m",
+			(unsigned long long)BTRFS_FIRST_FREE_OBJECTID);
 		return 0;
 	}
 
@@ -721,7 +720,7 @@ static u64 find_root_gen(int fd)
 	while (1) {
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 		if (ret < 0) {
-			error("can't perform the search: %s", strerror(errno));
+			error("can't perform the search: %m");
 			return 0;
 		}
 		/* the ioctl returns the number of item it found in nr_items */
@@ -781,8 +780,8 @@ static char *__ino_resolve(int fd, u64 dirid)
 
 	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
 	if (ret < 0) {
-		error("failed to lookup path for dirid %llu: %s",
-			(unsigned long long)dirid, strerror(errno));
+		error("failed to lookup path for dirid %llu: %m",
+			(unsigned long long)dirid);
 		return ERR_PTR(ret);
 	}
 
@@ -860,7 +859,7 @@ static char *ino_resolve(int fd, u64 ino, u64 *cache_dirid, char **cache_name)
 
 	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 	if (ret < 0) {
-		error("can't perform the search: %s", strerror(errno));
+		error("can't perform the search: %m");
 		return NULL;
 	}
 	/* the ioctl returns the number of item it found in nr_items */
@@ -1496,7 +1495,7 @@ static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
 
 	ret = list_subvol_search(fd, root_lookup);
 	if (ret) {
-		error("can't perform the search: %s", strerror(errno));
+		error("can't perform the search: %m");
 		return ret;
 	}
 
@@ -1732,7 +1731,7 @@ int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen)
 	while(1) {
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 		if (ret < 0) {
-			error("can't perform the search: %s", strerror(errno));
+			error("can't perform the search: %m");
 			break;
 		}
 		/* the ioctl returns the number of item it found in nr_items */
@@ -1926,8 +1925,7 @@ int btrfs_list_get_path_rootid(int fd, u64 *treeid)
 
 	ret = lookup_path_rootid(fd, treeid);
 	if (ret < 0)
-		error("cannot resolve rootid for path: %s",
-			strerror(errno));
+		error("cannot resolve rootid for path: %m");
 
 	return ret;
 }
diff --git a/cmds-balance.c b/cmds-balance.c
index 3cc0f62..0c91bdf 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -475,8 +475,7 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
 				fprintf(stderr, "balance canceled by user\n");
 			ret = 0;
 		} else {
-			error("error during balancing '%s': %s", path,
-					strerror(errno));
+			error("error during balancing '%s': %m", path);
 			if (errno != EINPROGRESS)
 				fprintf(stderr,
 			"There may be more info in syslog - try dmesg | tail\n");
@@ -794,9 +793,9 @@ static int cmd_balance_resume(int argc, char **argv)
 			else
 				ret = 1;
 		} else {
-			error("error during balancing '%s': %s\n"
+			error("error during balancing '%s': %m\n"
 			  "There may be more info in syslog - try dmesg | tail",
-				path, strerror(errno));
+				path);
 			ret = 1;
 		}
 	} else {
@@ -868,7 +867,7 @@ static int cmd_balance_status(int argc, char **argv)
 			ret = 0;
 			goto out;
 		}
-		error("balance status on '%s' failed: %s", path, strerror(errno));
+		error("balance status on '%s' failed: %m", path);
 		ret = 2;
 		goto out;
 	}
diff --git a/cmds-device.c b/cmds-device.c
index f4cdb39..86459d1 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -120,8 +120,8 @@ static int cmd_device_add(int argc, char **argv)
 
 		path = canonicalize_path(argv[i]);
 		if (!path) {
-			error("could not canonicalize pathname '%s': %s",
-				argv[i], strerror(errno));
+			error("could not canonicalize pathname '%s': %m",
+				argv[i]);
 			ret++;
 			goto error_out;
 		}
@@ -130,8 +130,7 @@ static int cmd_device_add(int argc, char **argv)
 		strncpy_null(ioctl_args.name, path);
 		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
 		if (res < 0) {
-			error("error adding device '%s': %s",
-				path, strerror(errno));
+			error("error adding device '%s': %m", path);
 			ret++;
 		}
 		free(path);
@@ -192,8 +191,7 @@ static int _cmd_device_remove(int argc, char **argv,
 		 */
 		if (res < 0 && (errno == ENOTTY || errno == EOPNOTSUPP)) {
 			if (is_devid) {
-				error("device delete by id failed: %s",
-							strerror(errno));
+				error("device delete by id failed: %m");
 				ret++;
 				continue;
 			}
@@ -311,8 +309,7 @@ static int cmd_device_scan(int argc, char **argv)
 		}
 		path = canonicalize_path(argv[i]);
 		if (!path) {
-			error("could not canonicalize path '%s': %s",
-				argv[i], strerror(errno));
+			error("could not canonicalize path '%s': %m", argv[i]);
 			ret = 1;
 			goto out;
 		}
@@ -355,8 +352,8 @@ static int cmd_device_ready(int argc, char **argv)
 
 	path = canonicalize_path(argv[optind]);
 	if (!path) {
-		error("could not canonicalize pathname '%s': %s",
-			argv[optind], strerror(errno));
+		error("could not canonicalize pathname '%s': %m",
+			argv[optind]);
 		ret = 1;
 		goto out;
 	}
@@ -371,8 +368,8 @@ static int cmd_device_ready(int argc, char **argv)
 	strncpy_null(args.name, path);
 	ret = ioctl(fd, BTRFS_IOC_DEVICES_READY, &args);
 	if (ret < 0) {
-		error("unable to determine if device '%s' is ready for mount: %s",
-			path, strerror(errno));
+		error("unable to determine if device '%s' is ready for mount: %m",
+			path);
 		ret = 1;
 	}
 
@@ -466,8 +463,8 @@ static int cmd_device_stats(int argc, char **argv)
 		args.flags = flags;
 
 		if (ioctl(fdmnt, BTRFS_IOC_GET_DEV_STATS, &args) < 0) {
-			error("device stats ioctl failed on %s: %s",
-			      path, strerror(errno));
+			error("device stats ioctl failed on %s: %m",
+			      path);
 			err |= 1;
 		} else {
 			char *canonical_path;
diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 0b0e47f..de7ad66 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -164,8 +164,7 @@ static int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count
 			return -e;
 
 		if (ret < 0) {
-			error("cannot look up chunk tree info: %s",
-				strerror(e));
+			error("cannot look up chunk tree info: %m");
 			return 1;
 		}
 		/* the ioctl returns the number of item it found in nr_items */
@@ -244,8 +243,7 @@ static struct btrfs_ioctl_space_args *load_space_info(int fd, char *path)
 
 	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
 	if (ret < 0) {
-		error("cannot get space info on '%s': %s", path,
-			strerror(errno));
+		error("cannot get space info on '%s': %m", path);
 		free(sargs);
 		return NULL;
 	}
@@ -270,8 +268,8 @@ static struct btrfs_ioctl_space_args *load_space_info(int fd, char *path)
 
 	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
 	if (ret < 0) {
-		error("cannot get space info with %u slots: %s",
-			count, strerror(errno));
+		error("cannot get space info with %u slots: %m",
+			count);
 		free(sargs);
 		return NULL;
 	}
@@ -356,8 +354,7 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 	}
 
 	if (r_total_size == 0) {
-		error("cannot get space info on '%s': %s",
-			path, strerror(errno));
+		error("cannot get space info on '%s': %m", path);
 
 		ret = 1;
 		goto exit;
@@ -554,8 +551,7 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
 	if (ret < 0) {
 		if (errno == EPERM)
 			return -errno;
-		error("cannot get filesystem info: %s",
-				strerror(errno));
+		error("cannot get filesystem info: %m");
 		return 1;
 	}
 
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 17d399d..0d3fc66 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -71,7 +71,7 @@ static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 
 	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
 	if (ret < 0) {
-		error("cannot get space info: %s", strerror(errno));
+		error("cannot get space info: %m");
 		free(sargs);
 		return -errno;
 	}
@@ -92,8 +92,8 @@ static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 	sargs->total_spaces = 0;
 	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
 	if (ret < 0) {
-		error("cannot get space info with %llu slots: %s",
-				count, strerror(errno));
+		error("cannot get space info with %llu slots: %m",
+				count);
 		free(sargs);
 		return -errno;
 	}
@@ -815,7 +815,7 @@ static const char * const cmd_filesystem_sync_usage[] = {
 
 static int cmd_filesystem_sync(int argc, char **argv)
 {
-	int 	fd, res, e;
+	int 	fd, res;
 	char	*path;
 	DIR	*dirstream = NULL;
 
@@ -831,10 +831,9 @@ static int cmd_filesystem_sync(int argc, char **argv)
 		return 1;
 
 	res = ioctl(fd, BTRFS_IOC_SYNC);
-	e = errno;
 	close_file_or_dir(fd, dirstream);
 	if( res < 0 ){
-		error("sync ioctl failed on '%s': %s", path, strerror(e));
+		error("sync ioctl failed on '%s': %m", path);
 		return 1;
 	}
 
@@ -881,7 +880,6 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
 		int typeflag, struct FTW *ftwbuf)
 {
 	int ret = 0;
-	int err = 0;
 	int fd = 0;
 
 	if ((typeflag == FTW_F) && S_ISREG(sb->st_mode)) {
@@ -889,7 +887,6 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
 			printf("%s\n", fpath);
 		fd = open(fpath, O_RDWR);
 		if (fd < 0) {
-			err = errno;
 			goto error;
 		}
 		ret = ioctl(fd, BTRFS_IOC_DEFRAG_RANGE, &defrag_global_range);
@@ -901,14 +898,13 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
 			return ENOTTY;
 		}
 		if (ret) {
-			err = errno;
 			goto error;
 		}
 	}
 	return 0;
 
 error:
-	error("defrag failed on %s: %s", fpath, strerror(err));
+	error("defrag failed on %s: %m", fpath);
 	defrag_global_errors++;
 	return 0;
 }
@@ -1027,16 +1023,14 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 		dirstream = NULL;
 		fd = open_file_or_dir(argv[i], &dirstream);
 		if (fd < 0) {
-			error("cannot open %s: %s", argv[i],
-					strerror(errno));
+			error("cannot open %s: %m", argv[i]);
 			ret = -errno;
 			goto next;
 		}
 
 		ret = fstat(fd, &st);
 		if (ret) {
-			error("failed to stat %s: %s",
-					argv[i], strerror(errno));
+			error("failed to stat %s: %m", argv[i]);
 			ret = -errno;
 			goto next;
 		}
@@ -1117,7 +1111,7 @@ static int cmd_filesystem_resize(int argc, char **argv)
 
 	res = stat(path, &st);
 	if (res < 0) {
-		error("resize: cannot stat %s: %s", path, strerror(errno));
+		error("resize: cannot stat %s: %m", path);
 		return 1;
 	}
 	if (!S_ISDIR(st.st_mode)) {
@@ -1144,7 +1138,7 @@ static int cmd_filesystem_resize(int argc, char **argv)
 				path);
 			break;
 		default:
-			error("unable to resize '%s': %s", path, strerror(e));
+			error("unable to resize '%s': %m", path);
 			break;
 		}
 		return 1;
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 23a7115..150c2e5 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -472,7 +472,7 @@ static int load_and_dump_sb(char *filename, int fd, u64 sb_bytenr, int full,
 
 		error("failed to read the superblock on %s at %llu",
 				filename, (unsigned long long)sb_bytenr);
-		error("error = '%s', errno = %d", strerror(errno), errno);
+		error("error = '%m', errno = %d", errno);
 		return 1;
 	}
 	printf("superblock: bytenr=%llu, device=%s\n", sb_bytenr, filename);
@@ -583,7 +583,7 @@ int cmd_inspect_dump_super(int argc, char **argv)
 		filename = argv[i];
 		fd = open(filename, O_RDONLY);
 		if (fd < 0) {
-			error("cannot open %s: %s", filename, strerror(errno));
+			error("cannot open %s: %m", filename);
 			ret = 1;
 			goto out;
 		}
diff --git a/cmds-inspect-tree-stats.c b/cmds-inspect-tree-stats.c
index 82a6a16..eced0db 100644
--- a/cmds-inspect-tree-stats.c
+++ b/cmds-inspect-tree-stats.c
@@ -336,7 +336,7 @@ static int calc_root_size(struct btrfs_root *tree_root, struct btrfs_key *key,
 	stat.max_cluster_size = root->fs_info->nodesize;
 	path.nodes[level] = root->node;
 	if (gettimeofday(&start, NULL)) {
-		error("cannot get time: %s", strerror(errno));
+		error("cannot get time: %m");
 		goto out;
 	}
 	if (!level) {
@@ -350,7 +350,7 @@ static int calc_root_size(struct btrfs_root *tree_root, struct btrfs_key *key,
 	if (ret)
 		goto out;
 	if (gettimeofday(&end, NULL)) {
-		error("cannot get time: %s", strerror(errno));
+		error("cannot get time: %m");
 		goto out;
 	}
 	timeval_subtract(&diff, &end, &start);
diff --git a/cmds-inspect.c b/cmds-inspect.c
index 885f3ab..afd7fe4 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -52,7 +52,7 @@ static int __ino_to_path_fd(u64 inum, int fd, int verbose, const char *prepend)
 
 	ret = ioctl(fd, BTRFS_IOC_INO_PATHS, &ipa);
 	if (ret < 0) {
-		error("ino paths ioctl: %s", strerror(errno));
+		error("ino paths ioctl: %m");
 		goto out;
 	}
 
@@ -189,7 +189,7 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 
 	ret = ioctl(fd, BTRFS_IOC_LOGICAL_INO, &loi);
 	if (ret < 0) {
-		error("logical ino ioctl: %s", strerror(errno));
+		error("logical ino ioctl: %m");
 		goto out;
 	}
 
@@ -524,7 +524,7 @@ static int print_min_dev_size(int fd, u64 devid)
 
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 		if (ret < 0) {
-			error("tree search ioctl: %s", strerror(errno));
+			error("tree search ioctl: %m");
 			ret = 1;
 			goto out;
 		}
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 38382ea..deb244e 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -96,7 +96,7 @@ static int _cmd_qgroup_assign(int assign, int argc, char **argv,
 
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_ASSIGN, &args);
 	if (ret < 0) {
-		error("unable to assign quota group: %s", strerror(errno));
+		error("unable to assign quota group: %m");
 		close_file_or_dir(fd, dirstream);
 		return 1;
 	}
@@ -117,8 +117,7 @@ static int _cmd_qgroup_assign(int assign, int argc, char **argv,
 			memset(&qargs, 0, sizeof(qargs));
 			ret = ioctl(fd, BTRFS_IOC_QUOTA_RESCAN, &qargs);
 			if (ret < 0)
-				error("quota rescan failed: %s",
-					strerror(errno));
+				error("quota rescan failed: %m");
 		} else {
 			warning("quotas may be inconsistent, rescan needed");
 		}
@@ -131,7 +130,6 @@ static int _cmd_qgroup_create(int create, int argc, char **argv)
 {
 	int ret = 0;
 	int fd;
-	int e;
 	char *path;
 	struct btrfs_ioctl_qgroup_create_args args;
 	DIR *dirstream = NULL;
@@ -149,11 +147,10 @@ static int _cmd_qgroup_create(int create, int argc, char **argv)
 		return 1;
 
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_CREATE, &args);
-	e = errno;
 	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
-		error("unable to %s quota group: %s",
-			create ? "create":"destroy", strerror(e));
+		error("unable to %s quota group: %m",
+			create ? "create":"destroy");
 		return 1;
 	}
 	return 0;
@@ -377,8 +374,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 	if (sync) {
 		ret = ioctl(fd, BTRFS_IOC_SYNC);
 		if (ret < 0)
-			warning("sync ioctl failed on '%s': %s", path,
-			      strerror(errno));
+			warning("sync ioctl failed on '%s': %m", path);
 	}
 
 	if (filter_flag) {
@@ -423,7 +419,6 @@ static int cmd_qgroup_limit(int argc, char **argv)
 {
 	int ret = 0;
 	int fd;
-	int e;
 	char *path = NULL;
 	struct btrfs_ioctl_qgroup_limit_args args;
 	unsigned long long size;
@@ -494,10 +489,9 @@ static int cmd_qgroup_limit(int argc, char **argv)
 		return 1;
 
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_LIMIT, &args);
-	e = errno;
 	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
-		error("unable to limit requested quota group: %s", strerror(e));
+		error("unable to limit requested quota group: %m");
 		return 1;
 	}
 	return 0;
diff --git a/cmds-quota.c b/cmds-quota.c
index 15bd4b9..745889d 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -35,7 +35,6 @@ static int quota_ctl(int cmd, int argc, char **argv)
 {
 	int ret = 0;
 	int fd;
-	int e;
 	char *path = argv[1];
 	struct btrfs_ioctl_quota_ctl_args args;
 	DIR *dirstream = NULL;
@@ -51,10 +50,9 @@ static int quota_ctl(int cmd, int argc, char **argv)
 		return 1;
 
 	ret = ioctl(fd, BTRFS_IOC_QUOTA_CTL, &args);
-	e = errno;
 	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
-		error("quota command failed: %s", strerror(e));
+		error("quota command failed: %m");
 		return 1;
 	}
 	return 0;
@@ -158,8 +156,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 	if (ioctlnum == BTRFS_IOC_QUOTA_RESCAN_STATUS) {
 		close_file_or_dir(fd, dirstream);
 		if (ret < 0) {
-			error("could not obtain quota rescan status: %s",
-			      strerror(e));
+			error("could not obtain quota rescan status: %m");
 			return 1;
 		}
 		if (!args.flags)
@@ -174,7 +171,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 		printf("quota rescan started\n");
 		fflush(stdout);
 	} else if (ret < 0 && (!wait_for_completion || e != EINPROGRESS)) {
-		error("quota rescan failed: %s", strerror(e));
+		error("quota rescan failed: %m");
 		close_file_or_dir(fd, dirstream);
 		return 1;
 	}
@@ -183,8 +180,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 		ret = ioctl(fd, BTRFS_IOC_QUOTA_RESCAN_WAIT, &args);
 		e = errno;
 		if (ret < 0) {
-			error("quota rescan wait failed: %s",
-			      strerror(e));
+			error("quota rescan wait failed: %m");
 			close_file_or_dir(fd, dirstream);
 			return 1;
 		}
diff --git a/cmds-receive.c b/cmds-receive.c
index e584cef..68123a3 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -1330,7 +1330,7 @@ int cmd_receive(int argc, char **argv)
 	if (fromfile[0]) {
 		receive_fd = open(fromfile, O_RDONLY | O_NOATIME);
 		if (receive_fd < 0) {
-			error("cannot open %s: %s", fromfile, strerror(errno));
+			error("cannot open %s: %m", fromfile);
 			goto out;
 		}
 	}
diff --git a/cmds-replace.c b/cmds-replace.c
index a3ea977..032a44f 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -169,8 +169,8 @@ static int cmd_replace_start(int argc, char **argv)
 	ret = ioctl(fdmnt, BTRFS_IOC_DEV_REPLACE, &status_args);
 	if (ret < 0) {
 		fprintf(stderr,
-			"ERROR: ioctl(DEV_REPLACE_STATUS) failed on \"%s\": %s",
-			path, strerror(errno));
+			"ERROR: ioctl(DEV_REPLACE_STATUS) failed on \"%s\": %m",
+			path);
 		if (status_args.result != BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT)
 			fprintf(stderr, ", %s\n",
 				replace_dev_result2string(status_args.result));
@@ -194,8 +194,8 @@ static int cmd_replace_start(int argc, char **argv)
 	srcdev = argv[optind];
 	dstdev = canonicalize_path(argv[optind + 1]);
 	if (!dstdev) {
-		error("cannot canonicalize path '%s': %s",
-			argv[optind + 1], strerror(errno));
+		error("cannot canonicalize path '%s': %m",
+			argv[optind + 1]);
 		goto leave_with_error;
 	}
 
@@ -250,7 +250,7 @@ static int cmd_replace_start(int argc, char **argv)
 
 	fddstdev = open(dstdev, O_RDWR);
 	if (fddstdev < 0) {
-		error("unable to open %s: %s", dstdev, strerror(errno));
+		error("unable to open %s: %m", dstdev);
 		goto leave_with_error;
 	}
 	strncpy((char *)start_args.start.tgtdev_name, dstdev,
@@ -268,7 +268,7 @@ static int cmd_replace_start(int argc, char **argv)
 	dev_replace_handle_sigint(fdmnt);
 	if (!do_not_background) {
 		if (daemon(0, 0) < 0) {
-			error("backgrounding failed: %s", strerror(errno));
+			error("backgrounding failed: %m");
 			goto leave_with_error;
 		}
 	}
@@ -279,8 +279,8 @@ static int cmd_replace_start(int argc, char **argv)
 	if (do_not_background) {
 		if (ret < 0) {
 			fprintf(stderr,
-				"ERROR: ioctl(DEV_REPLACE_START) failed on \"%s\": %s",
-				path, strerror(errno));
+				"ERROR: ioctl(DEV_REPLACE_START) failed on \"%s\": %m",
+				path);
 			if (start_args.result != BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT)
 				fprintf(stderr, ", %s\n",
 					replace_dev_result2string(start_args.result));
@@ -374,8 +374,8 @@ static int print_replace_status(int fd, const char *path, int once)
 		args.result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT;
 		ret = ioctl(fd, BTRFS_IOC_DEV_REPLACE, &args);
 		if (ret < 0) {
-			fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_STATUS) failed on \"%s\": %s",
-				path, strerror(errno));
+			fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_STATUS) failed on \"%s\": %m",
+				path);
 			if (args.result != BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT)
 				fprintf(stderr, ", %s\n",
 					replace_dev_result2string(args.result));
@@ -498,7 +498,6 @@ static int cmd_replace_cancel(int argc, char **argv)
 	int ret;
 	int c;
 	int fd;
-	int e;
 	char *path;
 	DIR *dirstream = NULL;
 
@@ -521,11 +520,10 @@ static int cmd_replace_cancel(int argc, char **argv)
 	args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_CANCEL;
 	args.result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT;
 	ret = ioctl(fd, BTRFS_IOC_DEV_REPLACE, &args);
-	e = errno;
 	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
-		fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_CANCEL) failed on \"%s\": %s",
-			path, strerror(e));
+		fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_CANCEL) failed on \"%s\": %m",
+			path);
 		if (args.result != BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT)
 			fprintf(stderr, ", %s\n",
 				replace_dev_result2string(args.result));
diff --git a/cmds-restore.c b/cmds-restore.c
index 6196a1e..ade35f0 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -442,7 +442,7 @@ again:
 				      pos+total);
 			if (done < 0) {
 				ret = -1;
-				error("cannot write data: %d %s", errno, strerror(errno));
+				error("cannot write data: %d %m", errno);
 				goto out;
 			}
 			total += done;
@@ -587,8 +587,8 @@ static int set_file_xattrs(struct btrfs_root *root, u64 inode,
 			data_len = len;
 
 			if (fsetxattr(fd, name, data, data_len, 0))
-				error("setting extended attribute %s on file %s: %s",
-					name, file_name, strerror(errno));
+				error("setting extended attribute %s on file %s: %m",
+					name, file_name);
 
 			len = sizeof(*di) + name_len + data_len;
 			cur += len;
@@ -624,13 +624,13 @@ static int copy_metadata(struct btrfs_root *root, int fd,
 		ret = fchown(fd, btrfs_inode_uid(path.nodes[0], inode_item),
 				btrfs_inode_gid(path.nodes[0], inode_item));
 		if (ret) {
-			error("failed to change owner: %s", strerror(errno));
+			error("failed to change owner: %m");
 			goto out;
 		}
 
 		ret = fchmod(fd, btrfs_inode_mode(path.nodes[0], inode_item));
 		if (ret) {
-			error("failed to change mode: %s", strerror(errno));
+			error("failed to change mode: %m");
 			goto out;
 		}
 
@@ -644,7 +644,7 @@ static int copy_metadata(struct btrfs_root *root, int fd,
 
 		ret = futimens(fd, times);
 		if (ret) {
-			error("failed to set times: %s", strerror(errno));
+			error("failed to set times: %m");
 			goto out;
 		}
 	}
@@ -904,8 +904,8 @@ static int copy_symlink(struct btrfs_root *root, struct btrfs_key *key,
 	if (!dry_run) {
 		ret = symlink(symlink_target, path_name);
 		if (ret < 0) {
-			fprintf(stderr, "Failed to restore symlink '%s': %s\n",
-					path_name, strerror(errno));
+			fprintf(stderr, "Failed to restore symlink '%s': %m\n",
+					path_name);
 			goto out;
 		}
 	}
@@ -937,8 +937,7 @@ static int copy_symlink(struct btrfs_root *root, struct btrfs_key *key,
 				   btrfs_inode_gid(path.nodes[0], inode_item),
 				   AT_SYMLINK_NOFOLLOW);
 	if (ret) {
-		fprintf(stderr, "Failed to change owner: %s\n",
-				strerror(errno));
+		fprintf(stderr, "Failed to change owner: %m\n");
 		goto out;
 	}
 
@@ -952,7 +951,7 @@ static int copy_symlink(struct btrfs_root *root, struct btrfs_key *key,
 
 	ret = utimensat(-1, file, times, AT_SYMLINK_NOFOLLOW);
 	if (ret)
-		fprintf(stderr, "Failed to set times: %s\n", strerror(errno));
+		fprintf(stderr, "Failed to set times: %m\n");
 out:
 	btrfs_release_path(&path);
 	return ret;
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 5388fdc..dabe7d9 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -849,8 +849,7 @@ static void *scrub_one_dev(void *ctx)
 		      IOPRIO_PRIO_VALUE(sp->ioprio_class,
 					sp->ioprio_classdata));
 	if (ret)
-		warning("setting ioprio failed: %s (ignored)",
-			strerror(errno));
+		warning("setting ioprio failed: %m (ignored)");
 
 	ret = ioctl(sp->fd, BTRFS_IOC_SCRUB, &sp->scrub_args);
 	gettimeofday(&tv, NULL);
@@ -1195,8 +1194,8 @@ static int scrub_start(int argc, char **argv, int resume)
 
 	if (mkdir_p(datafile)) {
 		warning_on(!do_quiet,
-    "cannot create scrub data file, mkdir %s failed: %s. Status recording disabled",
-			datafile, strerror(errno));
+    "cannot create scrub data file, mkdir %s failed: %m. Status recording disabled",
+			datafile);
 		do_record = 0;
 	}
 	free(datafile);
@@ -1267,7 +1266,7 @@ static int scrub_start(int argc, char **argv, int resume)
 	spc.progress = calloc(fi_args.num_devices * 2, sizeof(*spc.progress));
 
 	if (!t_devs || !sp || !spc.progress) {
-		error_on(!do_quiet, "scrub failed: %s", strerror(errno));
+		error_on(!do_quiet, "scrub failed: %m");
 		err = 1;
 		goto out;
 	}
@@ -1346,9 +1345,9 @@ static int scrub_start(int argc, char **argv, int resume)
 		ret = listen(prg_fd, 100);
 	if (ret == -1) {
 		warning_on(!do_quiet,
-   "failed to open the progress status socket at %s: %s. Progress cannot be queried",
+   "failed to open the progress status socket at %s: %m. Progress cannot be queried",
 			sock_path[0] ? sock_path :
-			SCRUB_PROGRESS_SOCKET_PATH, strerror(errno));
+			SCRUB_PROGRESS_SOCKET_PATH);
 		if (prg_fd != -1) {
 			close(prg_fd);
 			prg_fd = -1;
@@ -1372,8 +1371,7 @@ static int scrub_start(int argc, char **argv, int resume)
 	if (do_background) {
 		pid = fork();
 		if (pid == -1) {
-			error_on(!do_quiet, "cannot scrub, fork failed: %s",
-				strerror(errno));
+			error_on(!do_quiet, "cannot scrub, fork failed: %m");
 			err = 1;
 			goto out;
 		}
@@ -1391,8 +1389,8 @@ static int scrub_start(int argc, char **argv, int resume)
 			}
 			ret = wait(&stat);
 			if (ret != pid) {
-				error_on(!do_quiet, "wait failed (ret=%d): %s",
-					ret, strerror(errno));
+				error_on(!do_quiet, "wait failed (ret=%d): %m",
+					ret);
 				err = 1;
 				goto out;
 			}
@@ -1720,8 +1718,7 @@ static int cmd_scrub_status(int argc, char **argv)
 
 	fdres = socket(AF_UNIX, SOCK_STREAM, 0);
 	if (fdres == -1) {
-		error("failed to create socket to receive progress information: %s",
-			strerror(errno));
+		error("failed to create socket to receive progress information: %m");
 		err = 1;
 		goto out;
 	}
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index dc626a6..8a473f7 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -210,7 +210,7 @@ static int cmd_subvol_create(int argc, char **argv)
 	}
 
 	if (res < 0) {
-		error("cannot create subvolume: %s", strerror(errno));
+		error("cannot create subvolume: %m");
 		goto out;
 	}
 
@@ -325,8 +325,7 @@ again:
 	cpath = realpath(path, NULL);
 	if (!cpath) {
 		ret = errno;
-		error("cannot find real path for '%s': %s",
-			path, strerror(errno));
+		error("cannot find real path for '%s': %m", path);
 		goto out;
 	}
 	dupdname = strdup(cpath);
@@ -348,8 +347,7 @@ again:
 	strncpy_null(args.name, vname);
 	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
 	if(res < 0 ){
-		error("cannot delete '%s/%s': %s", dname, vname,
-			strerror(errno));
+		error("cannot delete '%s/%s': %m", dname, vname);
 		ret = 1;
 		goto out;
 	}
@@ -357,8 +355,7 @@ again:
 	if (commit_mode == COMMIT_EACH) {
 		res = wait_for_commit(fd);
 		if (res < 0) {
-			error("unable to wait for commit after '%s': %s",
-				path, strerror(errno));
+			error("unable to wait for commit after '%s': %m", path);
 			ret = 1;
 		}
 	} else if (commit_mode == COMMIT_AFTER) {
@@ -415,8 +412,8 @@ keep_fd:
 				if (res < 0) {
 					uuid_unparse(seen->fsid, uuidbuf);
 					error(
-			"unable to do final sync after deletion: %s, fsid: %s",
-						strerror(errno), uuidbuf);
+			"unable to do final sync after deletion: %m, fsid: %s",
+						uuidbuf);
 					ret = 1;
 				} else if (verbose > 0) {
 					uuid_unparse(seen->fsid, uuidbuf);
@@ -776,7 +773,7 @@ static int cmd_subvol_snapshot(int argc, char **argv)
 	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
 
 	if (res < 0) {
-		error("cannot snapshot '%s': %s", subvol, strerror(errno));
+		error("cannot snapshot '%s': %m", subvol);
 		goto out;
 	}
 
@@ -819,8 +816,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 
 	ret = btrfs_list_get_default_subvolume(fd, &default_id);
 	if (ret) {
-		error("failed to look up default subvolume: %s",
-			strerror(errno));
+		error("failed to look up default subvolume: %m");
 		goto out;
 	}
 
@@ -868,7 +864,7 @@ static const char * const cmd_subvol_set_default_usage[] = {
 
 static int cmd_subvol_set_default(int argc, char **argv)
 {
-	int	ret=0, fd, e;
+	int	ret=0, fd;
 	u64	objectid;
 	char	*path;
 	char	*subvolid;
@@ -915,11 +911,9 @@ static int cmd_subvol_set_default(int argc, char **argv)
 	}
 
 	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
-	e = errno;
 	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
-		error("unable to set a new default subvolume: %s",
-			strerror(e));
+		error("unable to set a new default subvolume: %m");
 		return 1;
 	}
 	return 0;
@@ -963,8 +957,7 @@ static int cmd_subvol_find_new(int argc, char **argv)
 
 	ret = ioctl(fd, BTRFS_IOC_SYNC);
 	if (ret < 0) {
-		error("sync ioctl failed on '%s': %s",
-			subvol, strerror(errno));
+		error("sync ioctl failed on '%s': %m", subvol);
 		close_file_or_dir(fd, dirstream);
 		return 1;
 	}
@@ -1039,8 +1032,7 @@ static int cmd_subvol_show(int argc, char **argv)
 	memset(&get_ri, 0, sizeof(get_ri));
 	fullpath = realpath(argv[optind], NULL);
 	if (!fullpath) {
-		error("cannot find real path for '%s': %s",
-			argv[optind], strerror(errno));
+		error("cannot find real path for '%s': %m", argv[optind]);
 		goto out;
 	}
 
diff --git a/convert/main.c b/convert/main.c
index 89f9261..d31b337 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1115,7 +1115,7 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
 		goto fail;
 	fd = open(devname, O_RDWR);
 	if (fd < 0) {
-		error("unable to open %s: %s", devname, strerror(errno));
+		error("unable to open %s: %m", devname);
 		goto fail;
 	}
 	btrfs_parse_features_to_string(features_buf, features);
@@ -1526,7 +1526,7 @@ static int do_rollback(const char *devname)
 	}
 	fd = open(devname, O_RDWR);
 	if (fd < 0) {
-		error("unable to open %s: %s", devname, strerror(errno));
+		error("unable to open %s: %m", devname);
 		ret = -EIO;
 		goto free_mem;
 	}
diff --git a/disk-io.c b/disk-io.c
index f5edc47..d26d57b 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1212,7 +1212,7 @@ struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 
 	ret = stat(filename, &st);
 	if (ret < 0) {
-		error("cannot stat '%s': %s", filename, strerror(errno));
+		error("cannot stat '%s': %m", filename);
 		return NULL;
 	}
 	if (!(((st.st_mode & S_IFMT) == S_IFREG) || ((st.st_mode & S_IFMT) == S_IFBLK))) {
@@ -1225,7 +1225,7 @@ struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 
 	fp = open(filename, oflags);
 	if (fp < 0) {
-		error("cannot open '%s': %s", filename, strerror(errno));
+		error("cannot open '%s': %m", filename);
 		return NULL;
 	}
 	info = __open_ctree_fd(fp, filename, sb_bytenr, root_tree_bytenr,
@@ -1549,8 +1549,7 @@ write_err:
 	if (ret > 0)
 		fprintf(stderr, "WARNING: failed to write all sb data\n");
 	else
-		fprintf(stderr, "WARNING: failed to write sb: %s\n",
-			strerror(errno));
+		fprintf(stderr, "WARNING: failed to write sb: %m\n");
 	return ret;
 }
 
diff --git a/image/main.c b/image/main.c
index 54a2d7d..9c75c8b 100644
--- a/image/main.c
+++ b/image/main.c
@@ -514,7 +514,7 @@ static int write_buffers(struct metadump_struct *md, u64 *next)
 
 	ret = fwrite(&md->cluster, BLOCK_SIZE, 1, md->out);
 	if (ret != 1) {
-		error("unable to write out cluster: %s", strerror(errno));
+		error("unable to write out cluster: %m");
 		return -errno;
 	}
 
@@ -530,8 +530,7 @@ static int write_buffers(struct metadump_struct *md, u64 *next)
 			ret = fwrite(async->buffer, async->bufsize, 1,
 				     md->out);
 		if (ret != 1) {
-			error("unable to write out cluster: %s",
-				strerror(errno));
+			error("unable to write out cluster: %m");
 			err = -errno;
 			ret = 0;
 		}
@@ -547,8 +546,7 @@ static int write_buffers(struct metadump_struct *md, u64 *next)
 		bytenr += size;
 		ret = write_zero(md->out, size);
 		if (ret != 1) {
-			error("unable to zero out buffer: %s",
-				strerror(errno));
+			error("unable to zero out buffer: %m");
 			err = -errno;
 		}
 	}
@@ -646,9 +644,8 @@ static int flush_pending(struct metadump_struct *md, int done)
 			if (ret < size) {
 				free(async->buffer);
 				free(async);
-				error("unable to read superblock at %llu: %s",
-						(unsigned long long)start,
-						strerror(errno));
+				error("unable to read superblock at %llu: %m",
+						(unsigned long long)start);
 				return -errno;
 			}
 			size = 0;
@@ -1341,8 +1338,7 @@ static void write_backup_supers(int fd, u8 *buf)
 
 	if (fstat(fd, &st)) {
 		error(
-	"cannot stat restore point, won't be able to write backup supers: %s",
-			strerror(errno));
+	"cannot stat restore point, won't be able to write backup supers: %m");
 		return;
 	}
 
@@ -1358,8 +1354,7 @@ static void write_backup_supers(int fd, u8 *buf)
 		if (ret < BTRFS_SUPER_INFO_SIZE) {
 			if (ret < 0)
 				error(
-				"problem writing out backup super block %d: %s",
-						i, strerror(errno));
+				"problem writing out backup super block %d: %m", i);
 			else
 				error("short write writing out backup super block");
 			break;
@@ -1467,8 +1462,7 @@ static void *restore_worker(void *data)
 
 error:
 				if (ret < 0) {
-					error("unable to write to device: %s",
-							strerror(errno));
+					error("unable to write to device: %m");
 					err = errno;
 				} else {
 					error("short write");
@@ -1640,7 +1634,7 @@ static int add_cluster(struct meta_cluster *cluster,
 		}
 		ret = fread(async->buffer, async->bufsize, 1, mdres->in);
 		if (ret != 1) {
-			error("unable to read buffer: %s", strerror(errno));
+			error("unable to read buffer: %m");
 			free(async->buffer);
 			free(async);
 			return -EIO;
@@ -1670,7 +1664,7 @@ static int add_cluster(struct meta_cluster *cluster,
 		bytenr += size;
 		ret = fread(buffer, size, 1, mdres->in);
 		if (ret != 1) {
-			error("failed to read buffer: %s", strerror(errno));
+			error("failed to read buffer: %m");
 			return -EIO;
 		}
 	}
@@ -1848,7 +1842,7 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
 	bytenr = current_cluster;
 	while (1) {
 		if (fseek(mdres->in, current_cluster, SEEK_SET)) {
-			error("seek failed: %s", strerror(errno));
+			error("seek failed: %m");
 			ret = -EIO;
 			break;
 		}
@@ -1867,9 +1861,8 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
 			ret = -EIO;
 			break;
 		} else if (ret < 0) {
-			error("unable to read image at %llu: %s",
-					(unsigned long long)cluster_bytenr,
-					strerror(errno));
+			error("unable to read image at %llu: %m",
+					(unsigned long long)cluster_bytenr);
 			break;
 		}
 		ret = 0;
@@ -1901,7 +1894,7 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
 			if (mdres->compress_method == COMPRESS_ZLIB) {
 				ret = fread(tmp, bufsize, 1, mdres->in);
 				if (ret != 1) {
-					error("read error: %s", strerror(errno));
+					error("read error: %m");
 					ret = -EIO;
 					break;
 				}
@@ -1919,8 +1912,7 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
 			} else {
 				ret = fread(buffer, bufsize, 1, mdres->in);
 				if (ret != 1) {
-					error("read error: %s",
-							strerror(errno));
+					error("read error: %m");
 					ret = -EIO;
 					break;
 				}
@@ -1973,7 +1965,7 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 
 	ret = fread(cluster, BLOCK_SIZE, 1, mdres->in);
 	if (ret <= 0) {
-		error("unable to read cluster: %s", strerror(errno));
+		error("unable to read cluster: %m");
 		return -EIO;
 	}
 	ret = 0;
@@ -1995,7 +1987,7 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 			break;
 		bytenr += le32_to_cpu(item->size);
 		if (fseek(mdres->in, le32_to_cpu(item->size), SEEK_CUR)) {
-			error("seek failed: %s", strerror(errno));
+			error("seek failed: %m");
 			return -EIO;
 		}
 	}
@@ -2014,7 +2006,7 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 
 	ret = fread(buffer, le32_to_cpu(item->size), 1, mdres->in);
 	if (ret != 1) {
-		error("unable to read buffer: %s", strerror(errno));
+		error("unable to read buffer: %m");
 		free(buffer);
 		return -EIO;
 	}
@@ -2196,8 +2188,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 	} else {
 		in = fopen(input, "r");
 		if (!in) {
-			error("unable to open metadump image: %s",
-					strerror(errno));
+			error("unable to open metadump image: %m");
 			return 1;
 		}
 	}
@@ -2238,7 +2229,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 	}
 
 	if (in != stdin && fseek(in, 0, SEEK_SET)) {
-		error("seek failed: %s", strerror(errno));
+		error("seek failed: %m");
 		goto out;
 	}
 
@@ -2278,7 +2269,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 		info = root->fs_info;
 
 		if (stat(target, &st)) {
-			error("stat %s failed: %s", target, strerror(errno));
+			error("stat %s failed: %m", target);
 			close_ctree(info->chunk_root);
 			free(cluster);
 			return 1;
@@ -2359,7 +2350,7 @@ static int update_disk_super_on_device(struct btrfs_fs_info *info,
 	/* update other devices' super block */
 	fp = open(other_dev, O_CREAT | O_RDWR, 0600);
 	if (fp < 0) {
-		error("could not open %s: %s", other_dev, strerror(errno));
+		error("could not open %s: %m", other_dev);
 		ret = -EIO;
 		goto out;
 	}
@@ -2554,8 +2545,7 @@ int main(int argc, char *argv[])
 				       0, target, multi_devices);
 	}
 	if (ret) {
-		error("%s failed: %s", (create) ? "create" : "restore",
-		       strerror(errno));
+		error("%s failed: %m", (create) ? "create" : "restore");
 		goto out;
 	}
 
@@ -2613,8 +2603,8 @@ out:
 
 			unlink_ret = unlink(target);
 			if (unlink_ret)
-				error("unlink output file %s failed: %s",
-						target, strerror(errno));
+				error("unlink output file %s failed: %m",
+						target);
 		}
 	}
 
diff --git a/mkfs/common.c b/mkfs/common.c
index dd5e7ec..56d53de 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -693,11 +693,11 @@ int test_dev_for_mkfs(const char *file, int force_overwrite)
 	/* check if the device is busy */
 	fd = open(file, O_RDWR|O_EXCL);
 	if (fd < 0) {
-		error("unable to open %s: %s", file, strerror(errno));
+		error("unable to open %s: %m", file);
 		return 1;
 	}
 	if (fstat(fd, &st)) {
-		error("unable to stat %s: %s", file, strerror(errno));
+		error("unable to stat %s: %m", file);
 		close(fd);
 		return 1;
 	}
diff --git a/mkfs/main.c b/mkfs/main.c
index d817ad8..1f751f7 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -595,8 +595,7 @@ static int add_xattr_item(struct btrfs_trans_handle *trans,
 	if (ret < 0) {
 		if(errno == ENOTSUP)
 			return 0;
-		error("getting a list of xattr failed for %s: %s", file_name,
-				strerror(errno));
+		error("getting a list of xattr failed for %s: %m", file_name);
 		return ret;
 	}
 	if (ret == 0)
@@ -611,8 +610,8 @@ static int add_xattr_item(struct btrfs_trans_handle *trans,
 		if (ret < 0) {
 			if(errno == ENOTSUP)
 				return 0;
-			error("gettig a xattr value failed for %s attr %s: %s",
-				file_name, cur_name, strerror(errno));
+			error("gettig a xattr value failed for %s attr %s: %m",
+				file_name, cur_name);
 			return ret;
 		}
 
@@ -639,7 +638,7 @@ static int add_symbolic_link(struct btrfs_trans_handle *trans,
 
 	ret = readlink(path_name, buf, sizeof(buf));
 	if (ret <= 0) {
-		error("readlink failed for %s: %s", path_name, strerror(errno));
+		error("readlink failed for %s: %m", path_name);
 		goto fail;
 	}
 	if (ret >= sizeof(buf)) {
@@ -678,7 +677,7 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 
 	fd = open(path_name, O_RDONLY);
 	if (fd == -1) {
-		error("cannot open %s: %s", path_name, strerror(errno));
+		error("cannot open %s: %m", path_name);
 		return ret;
 	}
 
@@ -696,10 +695,9 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 
 		ret_read = pread64(fd, buffer, st->st_size, bytes_read);
 		if (ret_read == -1) {
-			error("cannot read %s at offset %llu length %llu: %s",
+			error("cannot read %s at offset %llu length %llu: %m",
 				path_name, (unsigned long long)bytes_read,
-				(unsigned long long)st->st_size,
-				strerror(errno));
+				(unsigned long long)st->st_size);
 			free(buffer);
 			goto end;
 		}
@@ -744,11 +742,10 @@ again:
 
 		ret_read = pread64(fd, eb->data, sectorsize, file_pos + bytes_read);
 		if (ret_read == -1) {
-			error("cannot read %s at offset %llu length %llu: %s",
+			error("cannot read %s at offset %llu length %llu: %m",
 				path_name,
 				(unsigned long long)file_pos + bytes_read,
-				(unsigned long long)sectorsize,
-				strerror(errno));
+				(unsigned long long)sectorsize);
 			goto end;
 		}
 
@@ -824,7 +821,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 	dir_entry->dir_name = dir_name;
 	dir_entry->path = realpath(dir_name, real_path);
 	if (!dir_entry->path) {
-		error("realpath  failed for %s: %s", dir_name, strerror(errno));
+		error("realpath  failed for %s: %m", dir_name);
 		ret = -1;
 		goto fail_no_dir;
 	}
@@ -863,8 +860,8 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 		parent_inum = parent_dir_entry->inum;
 		parent_dir_name = parent_dir_entry->dir_name;
 		if (chdir(parent_dir_entry->path)) {
-			error("chdir failed for %s: %s",
-				parent_dir_name, strerror(errno));
+			error("chdir failed for %s: %m",
+				parent_dir_name);
 			ret = -1;
 			goto fail_no_files;
 		}
@@ -873,8 +870,8 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 				directory_select, NULL);
 		if (count == -1)
 		{
-			error("scandir failed for %s: %s",
-				parent_dir_name, strerror (errno));
+			error("scandir failed for %s: %m",
+				parent_dir_name);
 			ret = -1;
 			goto fail;
 		}
@@ -883,8 +880,8 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 			cur_file = files[i];
 
 			if (lstat(cur_file->d_name, &st) == -1) {
-				error("lstat failed for %s: %s",
-					cur_file->d_name, strerror(errno));
+				error("lstat failed for %s: %m",
+					cur_file->d_name);
 				ret = -1;
 				goto fail;
 			}
@@ -1049,7 +1046,7 @@ static int make_image(const char *source_dir, struct btrfs_root *root)
 
 	ret = lstat(source_dir, &root_st);
 	if (ret) {
-		error("unable to lstat %s: %s", source_dir, strerror(errno));
+		error("unable to lstat %s: %m", source_dir);
 		ret = -errno;
 		goto out;
 	}
@@ -1132,8 +1129,7 @@ static u64 size_sourcedir(const char *dir_name, u64 sectorsize,
 	ret = ftw(dir_name, ftw_add_entry_size, 10);
 	dir_size = global_total_size;
 	if (ret < 0) {
-		error("ftw subdir walk of %s failed: %s", dir_name,
-			strerror(errno));
+		error("ftw subdir walk of %s failed: %m", dir_name);
 		exit(1);
 	}
 
@@ -1718,7 +1714,7 @@ int main(int argc, char **argv)
 		 */
 		fd = open(file, O_RDWR);
 		if (fd < 0) {
-			error("unable to open %s: %s", file, strerror(errno));
+			error("unable to open %s: %m", file);
 			goto error;
 		}
 		ret = btrfs_prepare_device(fd, file, &dev_block_count,
@@ -1740,7 +1736,7 @@ int main(int argc, char **argv)
 		fd = open(file, O_CREAT | O_RDWR,
 				S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
 		if (fd < 0) {
-			error("unable to open %s: %s", file, strerror(errno));
+			error("unable to open %s: %m", file);
 			goto error;
 		}
 
@@ -1843,7 +1839,7 @@ int main(int argc, char **argv)
 		 */
 		fd = open(file, O_RDWR);
 		if (fd < 0) {
-			error("unable to open %s: %s", file, strerror(errno));
+			error("unable to open %s: %m", file);
 			goto error;
 		}
 		ret = btrfs_device_already_in_root(root, fd,
diff --git a/send-utils.c b/send-utils.c
index 384cc5b..b5289e7 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -83,8 +83,7 @@ static int btrfs_read_root_item_raw(int mnt_fd, u64 root_id, size_t buf_len,
 		ret = ioctl(mnt_fd, BTRFS_IOC_TREE_SEARCH, &args);
 		if (ret < 0) {
 			fprintf(stderr,
-				"ERROR: can't perform the search - %s\n",
-				strerror(errno));
+				"ERROR: can't perform the search - %m\n");
 			return 0;
 		}
 		/* the ioctl returns the number of item it found in nr_items */
@@ -267,8 +266,8 @@ static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *path_len,
 	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &search_arg);
 	if (ret < 0) {
 		fprintf(stderr,
-			"ioctl(BTRFS_IOC_TREE_SEARCH, subvol_id %llu) ret=%d, error: %s\n",
-			(unsigned long long)subvol_id, ret, strerror(errno));
+			"ioctl(BTRFS_IOC_TREE_SEARCH, subvol_id %llu) ret=%d, error: %m\n",
+			(unsigned long long)subvol_id, ret);
 		return ret;
 	}
 
@@ -306,8 +305,8 @@ static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *path_len,
 		ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &ino_lookup_arg);
 		if (ret < 0) {
 			fprintf(stderr,
-				"ioctl(BTRFS_IOC_INO_LOOKUP) ret=%d, error: %s\n",
-				ret, strerror(errno));
+				"ioctl(BTRFS_IOC_INO_LOOKUP) ret=%d, error: %m\n",
+				ret);
 			return ret;
 		}
 
@@ -586,8 +585,7 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 	ret = is_uuid_tree_supported(mnt_fd);
 	if (ret < 0) {
 		fprintf(stderr,
-			"ERROR: check if we support uuid tree fails - %s\n",
-			strerror(errno));
+			"ERROR: check if we support uuid tree fails - %m\n");
 		return ret;
 	} else if (ret) {
 		/* uuid tree is supported */
@@ -608,8 +606,7 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 	while (1) {
 		ret = ioctl(mnt_fd, BTRFS_IOC_TREE_SEARCH, &args);
 		if (ret < 0) {
-			fprintf(stderr, "ERROR: can't perform the search - %s\n",
-				strerror(errno));
+			fprintf(stderr, "ERROR: can't perform the search - %m\n");
 			return ret;
 		}
 		if (sk->nr_items == 0)
diff --git a/tests/fssum.c b/tests/fssum.c
index 5dde998..2bda5df 100644
--- a/tests/fssum.c
+++ b/tests/fssum.c
@@ -532,8 +532,8 @@ sum(int dirfd, int level, sum_t *dircs, char *path_prefix, char *path_in)
 		}
 		ret = lstat64(namelist[i], &st);
 		if (ret) {
-			fprintf(stderr, "stat failed for %s/%s: %s\n",
-				path_prefix, path, strerror(errno));
+			fprintf(stderr, "stat failed for %s/%s: %m\n",
+				path_prefix, path);
 			exit(-1);
 		}
 		sum_add_u64(&meta, level);
@@ -557,8 +557,8 @@ sum(int dirfd, int level, sum_t *dircs, char *path_prefix, char *path_in)
 			if (fd == -1 && flags[FLAG_OPEN_ERROR]) {
 				sum_add_u64(&meta, errno);
 			} else if (fd == -1) {
-				fprintf(stderr, "open failed for %s/%s: %s\n",
-					path_prefix, path, strerror(errno));
+				fprintf(stderr, "open failed for %s/%s: %m\n",
+					path_prefix, path);
 				exit(-1);
 			} else {
 				sum(fd, level + 1, &cs, path_prefix, path);
@@ -575,9 +575,8 @@ sum(int dirfd, int level, sum_t *dircs, char *path_prefix, char *path_in)
 					sum_add_u64(&meta, errno);
 				} else if (fd == -1) {
 					fprintf(stderr,
-						"open failed for %s/%s: %s\n",
-						path_prefix, path,
-						strerror(errno));
+						"open failed for %s/%s: %m\n",
+						path_prefix, path);
 					exit(-1);
 				}
 				if (fd != -1) {
@@ -585,9 +584,8 @@ sum(int dirfd, int level, sum_t *dircs, char *path_prefix, char *path_in)
 					if (ret < 0) {
 						fprintf(stderr,
 							"read failed for "
-							"%s/%s: %s\n",
-							path_prefix, path,
-							strerror(errno));
+							"%s/%s: %m\n",
+							path_prefix, path);
 						exit(-1);
 					}
 					close(fd);
@@ -693,8 +691,7 @@ main(int argc, char *argv[])
 			out_fp = fopen(optarg, "w");
 			if (!out_fp) {
 				fprintf(stderr,
-					"failed to open output file: %s\n",
-					strerror(errno));
+					"failed to open output file: %m\n");
 				exit(-1);
 			}
 			break;
@@ -702,8 +699,7 @@ main(int argc, char *argv[])
 			in_fp = fopen(optarg, "r");
 			if (!in_fp) {
 				fprintf(stderr,
-					"failed to open input file: %s\n",
-					strerror(errno));
+					"failed to open input file: %m\n");
 				exit(-1);
 			}
 			break;
@@ -788,8 +784,7 @@ main(int argc, char *argv[])
 
 	fd = open(path, O_RDONLY);
 	if (fd == -1) {
-		fprintf(stderr, "failed to open %s: %s\n", path,
-			strerror(errno));
+		fprintf(stderr, "failed to open %s: %m\n", path);
 		exit(-1);
 	}
 
diff --git a/utils.c b/utils.c
index 524f463..944aa71 100644
--- a/utils.c
+++ b/utils.c
@@ -298,7 +298,7 @@ static int btrfs_wipe_existing_sb(int fd)
 	memset(buf, 0, len);
 	ret = pwrite(fd, buf, len, offset);
 	if (ret < 0) {
-		error("cannot wipe existing superblock: %s", strerror(errno));
+		error("cannot wipe existing superblock: %m");
 		ret = -1;
 	} else if (ret != len) {
 		error("cannot wipe existing superblock: wrote %d of %zd", ret, len);
@@ -320,7 +320,7 @@ int btrfs_prepare_device(int fd, const char *file, u64 *block_count_ret,
 
 	ret = fstat(fd, &st);
 	if (ret < 0) {
-		error("unable to stat %s: %s", file, strerror(errno));
+		error("unable to stat %s: %m", file);
 		return 1;
 	}
 
@@ -519,7 +519,7 @@ int get_btrfs_mount(const char *dev, char *mp, size_t mp_size)
 	fd = open(dev, O_RDONLY);
 	if (fd < 0) {
 		ret = -errno;
-		error("cannot open %s: %s", dev, strerror(errno));
+		error("cannot open %s: %m", dev);
 		goto out;
 	}
 
@@ -557,8 +557,8 @@ int open_path_or_dev_mnt(const char *path, DIR **dirstream, int verbose)
 			return -1;
 		}
 		ret = open_file_or_dir(mp, dirstream);
-		error_on(verbose && ret < 0, "can't access '%s': %s",
-			 path, strerror(errno));
+		error_on(verbose && ret < 0, "can't access '%s': %m",
+			 path);
 	} else {
 		ret = btrfs_open_dir(path, dirstream, 1);
 	}
@@ -578,8 +578,7 @@ int btrfs_open(const char *path, DIR **dirstream, int verbose, int dir_only)
 	int ret;
 
 	if (statfs(path, &stfs) != 0) {
-		error_on(verbose, "cannot access '%s': %s", path,
-				strerror(errno));
+		error_on(verbose, "cannot access '%s': %m", path);
 		return -1;
 	}
 
@@ -589,8 +588,7 @@ int btrfs_open(const char *path, DIR **dirstream, int verbose, int dir_only)
 	}
 
 	if (stat(path, &st) != 0) {
-		error_on(verbose, "cannot access '%s': %s", path,
-				strerror(errno));
+		error_on(verbose, "cannot access '%s': %m", path);
 		return -1;
 	}
 
@@ -601,8 +599,7 @@ int btrfs_open(const char *path, DIR **dirstream, int verbose, int dir_only)
 
 	ret = open_file_or_dir(path, dirstream);
 	if (ret < 0) {
-		error_on(verbose, "cannot access '%s': %s", path,
-				strerror(errno));
+		error_on(verbose, "cannot access '%s': %m", path);
 	}
 
 	return ret;
@@ -888,8 +885,7 @@ int check_mounted(const char* file)
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0) {
-		error("mount check: cannot open %s: %s", file,
-				strerror(errno));
+		error("mount check: cannot open %s: %m", file);
 		return -errno;
 	}
 
@@ -978,16 +974,14 @@ int btrfs_register_one_device(const char *fname)
 	fd = open("/dev/btrfs-control", O_RDWR);
 	if (fd < 0) {
 		warning(
-	"failed to open /dev/btrfs-control, skipping device registration: %s",
-			strerror(errno));
+	"failed to open /dev/btrfs-control, skipping device registration: %m");
 		return -errno;
 	}
 	memset(&args, 0, sizeof(args));
 	strncpy_null(args.name, fname);
 	ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
 	if (ret < 0) {
-		error("device scan failed on '%s': %s", fname,
-				strerror(errno));
+		error("device scan failed on '%s': %m", fname);
 		ret = -errno;
 	}
 	close(fd);
@@ -1257,15 +1251,14 @@ static int set_label_mounted(const char *mount_path, const char *labelp)
 
 	fd = open(mount_path, O_RDONLY | O_NOATIME);
 	if (fd < 0) {
-		error("unable to access %s: %s", mount_path, strerror(errno));
+		error("unable to access %s: %m", mount_path);
 		return -1;
 	}
 
 	memset(label, 0, sizeof(label));
 	__strncpy_null(label, labelp, BTRFS_LABEL_SIZE - 1);
 	if (ioctl(fd, BTRFS_IOC_SET_FSLABEL, label) < 0) {
-		error("unable to set label of %s: %s", mount_path,
-				strerror(errno));
+		error("unable to set label of %s: %m", mount_path);
 		close(fd);
 		return -1;
 	}
@@ -1313,7 +1306,7 @@ int get_label_mounted(const char *mount_path, char *labelp)
 
 	fd = open(mount_path, O_RDONLY | O_NOATIME);
 	if (fd < 0) {
-		error("unable to access %s: %s", mount_path, strerror(errno));
+		error("unable to access %s: %m", mount_path);
 		return -1;
 	}
 
@@ -1321,8 +1314,7 @@ int get_label_mounted(const char *mount_path, char *labelp)
 	ret = ioctl(fd, BTRFS_IOC_GET_FSLABEL, label);
 	if (ret < 0) {
 		if (errno != ENOTTY)
-			error("unable to get label of %s: %s", mount_path,
-					strerror(errno));
+			error("unable to get label of %s: %m", mount_path);
 		ret = -errno;
 		close(fd);
 		return ret;
@@ -1660,7 +1652,7 @@ int get_fs_info(const char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		fd = open(path, O_RDONLY);
 		if (fd < 0) {
 			ret = -errno;
-			error("cannot open %s: %s", path, strerror(errno));
+			error("cannot open %s: %m", path);
 			goto out;
 		}
 		ret = check_mounted_where(fd, path, mp, sizeof(mp),
@@ -1980,7 +1972,7 @@ int btrfs_scan_devices(void)
 
 		fd = open(path, O_RDONLY);
 		if (fd < 0) {
-			error("cannot open %s: %s", path, strerror(errno));
+			error("cannot open %s: %m", path);
 			continue;
 		}
 		ret = btrfs_scan_one_device(fd, path, &tmp_devices,
diff --git a/uuid-tree.c b/uuid-tree.c
index 8d0b917..320eb67 100644
--- a/uuid-tree.c
+++ b/uuid-tree.c
@@ -60,9 +60,9 @@ static int btrfs_uuid_tree_lookup_any(int fd, const u8 *uuid, u8 type,
 	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &search_arg);
 	if (ret < 0) {
 		fprintf(stderr,
-			"ioctl(BTRFS_IOC_TREE_SEARCH, uuid, key %016llx, UUID_KEY, %016llx) ret=%d, error: %s\n",
+			"ioctl(BTRFS_IOC_TREE_SEARCH, uuid, key %016llx, UUID_KEY, %016llx) ret=%d, error: %m\n",
 			(unsigned long long)key_objectid,
-			(unsigned long long)key_offset, ret, strerror(errno));
+			(unsigned long long)key_offset, ret);
 		ret = -ENOENT;
 		goto out;
 	}
diff --git a/volumes.c b/volumes.c
index ce3a540..9f70acb 100644
--- a/volumes.c
+++ b/volumes.c
@@ -185,8 +185,8 @@ again:
 				    struct btrfs_device, dev_list);
 		if (device->fd != -1) {
 			if (fsync(device->fd) == -1) {
-				warning("fsync on device %llu failed: %s",
-					device->devid, strerror(errno));
+				warning("fsync on device %llu failed: %m",
+					device->devid);
 				ret = -errno;
 			}
 			if (posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED))
@@ -249,8 +249,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)
 		fd = open(device->name, flags);
 		if (fd < 0) {
 			ret = -errno;
-			error("cannot open device '%s': %s", device->name,
-					strerror(errno));
+			error("cannot open device '%s': %m", device->name);
 			goto fail;
 		}
 
-- 
2.7.4

