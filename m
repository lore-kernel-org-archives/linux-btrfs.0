From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v3 2/3] Btrfs-progs: added ioctls and commands to resolve inodes and logical addrs
Date: Thu, 28 Jul 2011 19:13:05 +0200
Message-ID: <a469476a1510f90874d2711f4d8301c5080c9483.1311872884.git.list.btrfs@jan-o-sch.net>
References: <cover.1311872884.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1311872884.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1311872884.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

two new commands that make use of the new path resolving functions
implemented for scrub, doing the resolving in-kernel. the result for both
commands is a list of files belonging to that inode / logical address.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 btrfs-list.c |   35 +++++++++++
 btrfs.c      |   10 +++
 btrfs_cmds.c |  183 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 btrfs_cmds.h |    3 +
 ioctl.h      |   30 ++++++++++
 5 files changed, 261 insertions(+), 0 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index dd685c2..cbf6a08 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -900,3 +900,38 @@ int find_updated_files(int fd, u64 root_id, u64 oldest_gen)
 	printf("transid marker was %llu\n", (unsigned long long)max_found);
 	return ret;
 }
+
+char *path_for_root(int fd, u64 root)
+{
+	struct root_lookup root_lookup;
+	struct rb_node *n;
+	char *ret_path = NULL;
+	int ret;
+
+	ret = __list_subvol_search(fd, &root_lookup);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	ret = __list_subvol_fill_paths(fd, &root_lookup);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	n = rb_last(&root_lookup.root);
+	while (n) {
+		struct root_info *entry;
+		u64 root_id;
+		u64 parent_id;
+		u64 level;
+		char *path;
+		entry = rb_entry(n, struct root_info, rb_node);
+		resolve_root(&root_lookup, entry, &root_id, &parent_id, &level,
+				&path);
+		if (root_id == root)
+			ret_path = path;
+		else
+			free(path);
+		n = rb_prev(n);
+	}
+
+	return ret_path;
+}
diff --git a/btrfs.c b/btrfs.c
index 67d6f6f..5d483ed 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -178,6 +178,16 @@ static struct Command commands[] = {
 		"Remove a device from a filesystem.",
 	  NULL
 	},
+	{ do_ino_to_path, -2,
+	  "inspect-internal inode-resolve", "[-v] <inode> <path>\n"
+		"get file system paths for the given inode.",
+	  NULL
+	},
+	{ do_logical_to_ino, -2,
+	  "inspect-internal logical-resolve", "[-v] [-P] <logical> <path>\n"
+		"get file system paths for the given logical address.",
+	  NULL
+	},
 	{ 0, 0, 0, 0 }
 };
 
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 0612f34..e4c9b10 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -1545,3 +1545,186 @@ int do_df_filesystem(int nargs, char **argv)
 
 	return 0;
 }
+
+static int __ino_to_path_fd(u64 inum, int fd, int verbose, const char *prepend)
+{
+	int ret;
+	int i;
+	struct btrfs_ioctl_ino_path_args ipa;
+	struct btrfs_data_container *fspath;
+
+	fspath = malloc(4096);
+	if (!fspath)
+		return 1;
+
+	ipa.inum = inum;
+	ipa.size = 4096;
+	ipa.fspath = fspath;
+
+	ret = ioctl(fd, BTRFS_IOC_INO_PATHS, &ipa);
+	if (ret) {
+		printf("ioctl ret=%d, error: %s\n", ret, strerror(errno));
+		goto out;
+	}
+
+	if (verbose)
+		printf("ioctl ret=%d, bytes_left=%lu, bytes_missing=%lu, "
+			"cnt=%d, missed=%d\n", ret,
+			(unsigned long)fspath->bytes_left,
+			(unsigned long)fspath->bytes_missing,
+			fspath->elem_cnt, fspath->elem_missed);
+
+	for (i = 0; i < fspath->elem_cnt; ++i) {
+		fspath->str[i] += (unsigned long)fspath->str;
+		if (prepend)
+			printf("%s/%s\n", prepend, fspath->str[i]);
+		else
+			printf("%s\n", fspath->str[i]);
+	}
+
+out:
+	free(fspath);
+	return ret;
+}
+
+int do_ino_to_path(int nargs, char **argv)
+{
+	int fd;
+	int verbose = 0;
+
+	optind = 1;
+	while (1) {
+		int c = getopt(nargs, argv, "v");
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'v':
+			verbose = 1;
+			break;
+		default:
+			fprintf(stderr, "invalid arguments for ipath\n");
+			return 1;
+		}
+	}
+	if (nargs - optind != 2) {
+		fprintf(stderr, "invalid arguments for ipath\n");
+		return 1;
+	}
+
+	fd = open_file_or_dir(argv[optind+1]);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", argv[optind+1]);
+		return 12;
+	}
+
+	return __ino_to_path_fd(atoll(argv[optind]), fd, verbose,
+				argv[optind+1]);
+}
+
+int do_logical_to_ino(int nargs, char **argv)
+{
+	int ret;
+	int fd;
+	int i;
+	int verbose = 0;
+	int getpath = 1;
+	int bytes_left;
+	struct btrfs_ioctl_logical_ino_args loi;
+	struct btrfs_data_container *inodes;
+	char full_path[4096];
+	char *path_ptr;
+
+	optind = 1;
+	while (1) {
+		int c = getopt(nargs, argv, "Pv");
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'P':
+			getpath = 0;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		default:
+			fprintf(stderr, "invalid arguments for ipath\n");
+			return 1;
+		}
+	}
+	if (nargs - optind != 2) {
+		fprintf(stderr, "invalid arguments for ipath\n");
+		return 1;
+	}
+
+	inodes = malloc(4096);
+	if (!inodes)
+		return 1;
+
+	loi.logical = atoll(argv[optind]);
+	loi.size = 4096;
+	loi.inodes = inodes;
+
+	fd = open_file_or_dir(argv[optind+1]);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", argv[optind+1]);
+		ret = 12;
+		goto out;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_LOGICAL_INO, &loi);
+	if (ret) {
+		printf("ioctl ret=%d, error: %s\n", ret, strerror(errno));
+		goto out;
+	}
+
+	if (verbose)
+		printf("ioctl ret=%d, bytes_left=%lu, bytes_missing=%lu, "
+			"cnt=%d, missed=%d\n", ret,
+			(unsigned long)inodes->bytes_left,
+			(unsigned long)inodes->bytes_missing,
+			inodes->elem_cnt, inodes->elem_missed);
+
+	bytes_left = sizeof(full_path);
+	ret = snprintf(full_path, bytes_left, "%s/", argv[optind+1]);
+	path_ptr = full_path + ret;
+	bytes_left -= ret + 1;
+	BUG_ON(bytes_left < 0);
+
+	for (i = 0; i < inodes->elem_cnt; i += 3) {
+		u64 inum = inodes->val[i];
+		u64 offset = inodes->val[i+1];
+		u64 root = inodes->val[i+2];
+		int path_fd;
+		char *name;
+
+		if (getpath) {
+			name = path_for_root(fd, root);
+			if (IS_ERR(name))
+				return PTR_ERR(name);
+			if (!name) {
+				path_ptr[-1] = '\0';
+				path_fd = fd;
+			} else {
+				path_ptr[-1] = '/';
+				ret = snprintf(path_ptr, bytes_left, "%s",
+						name);
+				BUG_ON(ret >= bytes_left);
+				free(name);
+				path_fd = open_file_or_dir(full_path);
+				if (path_fd < 0) {
+					fprintf(stderr, "ERROR: can't access "
+						"'%s'\n", full_path);
+					goto out;
+				}
+			}
+			__ino_to_path_fd(inum, path_fd, verbose, full_path);
+		} else {
+			printf("inode %llu offset %llu root %llu\n", inum,
+				offset, root);
+		}
+	}
+
+out:
+	free(inodes);
+	return ret;
+}
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 83faa5b..0a3f88f 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -40,3 +40,6 @@ int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int do_find_newer(int argc, char **argv);
 int do_change_label(int argc, char **argv);
 int open_file_or_dir(const char *fname);
+int do_ino_to_path(int nargs, char **argv);
+int do_logical_to_ino(int nargs, char **argv);
+char *path_for_root(int fd, u64 root);
diff --git a/ioctl.h b/ioctl.h
index 4accbfd..32592e7 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -240,6 +240,31 @@ struct btrfs_ioctl_balance_start {
 					   * bytes for future expansion */
 };
 
+struct btrfs_data_container {
+	__u32	bytes_left;	/* out -- bytes not needed to deliver output */
+	__u32	bytes_missing;	/* out -- additional bytes needed for result */
+	__u32	elem_cnt;	/* out */
+	__u32	elem_missed;	/* out */
+	union {
+		char	*str[0];	/* out */
+		__u64	val[0];		/* out */
+	};
+};
+
+struct btrfs_ioctl_ino_path_args {
+	__u64				inum;		/* in */
+	__u32				size;		/* in */
+	__u64				reserved[4];
+	struct btrfs_data_container	*fspath;	/* out */
+};
+
+struct btrfs_ioctl_logical_ino_args {
+	__u64				logical;	/* in */
+	__u32				size;		/* in */
+	__u64				reserved[4];
+	struct btrfs_data_container	*inodes;	/* out */
+};
+
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
@@ -294,4 +319,9 @@ struct btrfs_ioctl_balance_start {
 #define BTRFS_IOC_BALANCE_CANCEL _IO(BTRFS_IOCTL_MAGIC, 33)
 #define BTRFS_IOC_BALANCE_FILTERED _IOWR(BTRFS_IOCTL_MAGIC, 34, \
 				struct btrfs_ioctl_balance_start)
+#define BTRFS_IOC_INO_PATHS _IOWR(BTRFS_IOCTL_MAGIC, 35, \
+					struct btrfs_ioctl_ino_path_args)
+#define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
+					struct btrfs_ioctl_ino_path_args)
+
 #endif
-- 
1.7.3.4

