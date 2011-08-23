From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs-progs: add restriper commands
Date: Tue, 23 Aug 2011 23:08:16 +0300
Message-ID: <1314130096-3723-2-git-send-email-idryomov@gmail.com>
References: <1314130096-3723-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314130096-3723-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 btrfs.c      |   25 +++-
 btrfs_cmds.c |  508 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 btrfs_cmds.h |    5 +
 ctree.h      |    9 +
 ioctl.h      |   44 +++++
 print-tree.c |    3 +
 volumes.h    |   42 +++++
 7 files changed, 632 insertions(+), 4 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 4cd4210..ae088f5 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -95,8 +95,29 @@ static struct Command commands[] = {
 	  "filesystem balance", "<path>\n"
 		"Balance the chunks across the device."
 	},
-	{ do_scan, 999, 
-	  "device scan", "[<device>...]\n"
+	{ do_restripe, -1,
+	  "filesystem restripe start", "[-d [filters]] [-m [filters]] "
+	  "[-s [filters]] [-vf] <path>\n"
+		"Start restriper."
+	},
+	{ do_restripe_cancel, 1,
+	  "filesystem restripe cancel", "<path>\n"
+		"Cancel restriper."
+	},
+	{ do_restripe_pause, 1,
+	  "filesystem restripe pause", "<path>\n"
+		"Pause restriper."
+	},
+	{ do_restripe_resume, 1,
+	  "filesystem restripe resume", "<path>\n"
+		"Resume interrupted restripe operation."
+	},
+	{ do_restripe_progress, -1,
+	  "filesystem restripe status", "[-v] <path>\n"
+		"Show status of running or paused restripe operation."
+	},
+	{ do_scan,
+	  999, "device scan", "[<device> [<device>..]\n"
 		"Scan all device for or the passed device for a btrfs\n"
 		"filesystem."
 	},
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 32f6b25..c386f74 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -18,6 +18,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <getopt.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
 #include <dirent.h>
@@ -819,13 +820,516 @@ int do_balance(int argc, char **argv)
 	e = errno;
 	close(fdmnt);
 	if(ret<0){
-		fprintf(stderr, "ERROR: error during balancing '%s' - %s\n", 
-			path, strerror(e));
+		if (e == ECANCELED) {
+			fprintf(stderr, "restripe interrupted by user\n");
+		} else {
+			fprintf(stderr, "ERROR: error during restriping '%s' "
+				"- %s\n", path, strerror(e));
+			return 19;
+		}
+	}
+	return 0;
+}
+
+static int parse_one_profile(char *profile, u64 *flags)
+{
+	if (!strcmp(profile, "raid0")) {
+		*flags |= BTRFS_BLOCK_GROUP_RAID0;
+	} else if (!strcmp(profile, "raid1")) {
+		*flags |= BTRFS_BLOCK_GROUP_RAID1;
+	} else if (!strcmp(profile, "raid10")) {
+		*flags |= BTRFS_BLOCK_GROUP_RAID10;
+	} else if (!strcmp(profile, "dup")) {
+		*flags |= BTRFS_BLOCK_GROUP_DUP;
+	} else if (!strcmp(profile, "single")) {
+		*flags |= BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+	} else {
+		fprintf(stderr, "Unknown profile '%s'\n", profile);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int parse_profiles(char *profiles, u64 *flags)
+{
+	char *this_char;
+	char *save_ptr;
+
+	for (this_char = strtok_r(profiles, "|", &save_ptr);
+	     this_char != NULL;
+	     this_char = strtok_r(NULL, "|", &save_ptr)) {
+		if (parse_one_profile(this_char, flags))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int parse_range(char *range, u64 *start, u64 *end)
+{
+	char *dots;
+
+	dots = strstr(range, "..");
+	if (dots) {
+		const char *rest = dots + 2;
+		int skipped = 0;
+
+		*dots = 0;
+
+		if (!*rest) {
+			*end = (u64)-1;
+			skipped++;
+		} else {
+			*end = strtoull(rest, (char **)NULL, 10);
+		}
+		if (dots == range) {
+			*start = 0;
+			skipped++;
+		} else {
+			*start = strtoull(range, (char **)NULL, 10);
+		}
+
+		if (skipped <= 1)
+			return 0;
+	}
+
+	return 1;
+}
+
+static int parse_filters(char *filters, struct btrfs_restripe_args *rargs)
+{
+	char *this_char;
+	char *value;
+	char *save_ptr;
+
+	if (!filters)
+		return 0;
+
+	for (this_char = strtok_r(filters, ",", &save_ptr);
+	     this_char != NULL;
+	     this_char = strtok_r(NULL, ",", &save_ptr)) {
+		if ((value = strchr(this_char, '=')) != NULL)
+			*value++ = 0;
+		if (!strcmp(this_char, "profiles")) {
+			if (!value || !*value) {
+				fprintf(stderr, "the profiles filter requires "
+				       "an argument\n");
+				return 1;
+			}
+			if (parse_profiles(value, &rargs->profiles)) {
+				fprintf(stderr, "Invalid profiles argument\n");
+				return 1;
+			}
+			rargs->flags |= BTRFS_RESTRIPE_ARGS_PROFILES;
+		} else if (!strcmp(this_char, "usage")) {
+			if (!value || !*value) {
+				fprintf(stderr, "the usage filter requires "
+				       "an argument\n");
+				return 1;
+			}
+			rargs->usage = strtoull(value, (char **)NULL, 10);
+			if (rargs->usage < 1 || rargs->usage > 100) {
+				fprintf(stderr, "Invalid usage argument: %s\n",
+				       value);
+				return 1;
+			}
+			rargs->flags |= BTRFS_RESTRIPE_ARGS_USAGE;
+		} else if (!strcmp(this_char, "devid")) {
+			if (!value || !*value) {
+				fprintf(stderr, "the devid filter requires "
+				       "an argument\n");
+				return 1;
+			}
+			rargs->devid = strtoull(value, (char **)NULL, 10);
+			if (rargs->devid == 0) {
+				fprintf(stderr, "Invalid devid argument: %s\n",
+				       value);
+				return 1;
+			}
+			rargs->flags |= BTRFS_RESTRIPE_ARGS_DEVID;
+		} else if (!strcmp(this_char, "drange")) {
+			if (!value || !*value) {
+				fprintf(stderr, "the drange filter requires "
+				       "an argument\n");
+				return 1;
+			}
+			if (parse_range(value, &rargs->pstart, &rargs->pend)) {
+				fprintf(stderr, "Invalid drange argument\n");
+				return 1;
+			}
+			rargs->flags |= BTRFS_RESTRIPE_ARGS_DRANGE;
+		} else if (!strcmp(this_char, "vrange")) {
+			if (!value || !*value) {
+				fprintf(stderr, "the vrange filter requires "
+				       "an argument\n");
+				return 1;
+			}
+			if (parse_range(value, &rargs->vstart, &rargs->vend)) {
+				fprintf(stderr, "Invalid vrange argument\n");
+				return 1;
+			}
+			rargs->flags |= BTRFS_RESTRIPE_ARGS_VRANGE;
+		} else if (!strcmp(this_char, "convert")) {
+			if (!value || !*value) {
+				fprintf(stderr, "the convert option requires "
+				       "an argument\n");
+				return 1;
+			}
+			if (parse_one_profile(value, &rargs->target)) {
+				fprintf(stderr, "Invalid convert argument\n");
+				return 1;
+			}
+			rargs->flags |= BTRFS_RESTRIPE_ARGS_CONVERT;
+		} else if (!strcmp(this_char, "soft")) {
+			rargs->flags |= BTRFS_RESTRIPE_ARGS_SOFT;
+		} else {
+			fprintf(stderr, "Unrecognized restripe option '%s'\n",
+				this_char);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static void dump_ioctl_restripe_args(struct btrfs_ioctl_restripe_args *args);
+
+static struct option restripe_longopts[] = {
+	{ "data", 2, NULL, 'd'},
+	{ "metadata", 2, NULL, 'm' },
+	{ "system", 2, NULL, 's' },
+	{ "force", 0, NULL, 'f' },
+	{ "verbose", 0, NULL, 'v' },
+	{ 0, 0, 0, 0}
+};
+
+/*
+ * [-d [filters]] [-m [filters]] [-s [filters]] [-vf]
+ */
+int do_restripe(int ac, char **av)
+{
+	int fd;
+	char *path;
+	struct btrfs_ioctl_restripe_args args;
+	struct btrfs_restripe_args *ptrs[] = { &args.data, &args.sys,
+						&args.meta, NULL };
+	int force = 0;
+	int verbose = 0;
+	int nofilters = 1;
+	int i;
+	int longindex;
+	int ret;
+	int e;
+
+	memset(&args, 0, sizeof(args));
+
+	while (1) {
+		int opt = getopt_long(ac, av, "d::s::m::fv", restripe_longopts,
+				      &longindex);
+		if (opt < 0)
+			break;
+
+		switch (opt) {
+		case 'd':
+			nofilters = 0;
+			args.flags |= BTRFS_RESTRIPE_DATA;
+
+			if (parse_filters(optarg, &args.data))
+				return 1;
+			break;
+		case 's':
+			nofilters = 0;
+			args.flags |= BTRFS_RESTRIPE_SYSTEM;
+
+			if (parse_filters(optarg, &args.sys))
+				return 1;
+			break;
+		case 'm':
+			nofilters = 0;
+			args.flags |= BTRFS_RESTRIPE_METADATA;
+
+			if (parse_filters(optarg, &args.meta))
+				return 1;
+			break;
+		case 'f':
+			force = 1;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		default:
+			fprintf(stderr, "Invalid arguments for restripe\n");
+			return 1;
+		}
+	}
+
+	if (ac - optind != 1) {
+		fprintf(stderr, "Invalid arguments for restripe\n");
+		return 1;
+	}
+
+	if (nofilters) {
+		/* relocate everything - no filters */
+		args.flags |= BTRFS_RESTRIPE_TYPE_MASK;
+	}
+
+	/* drange makes sense only when devid is set */
+	for (i = 0; ptrs[i]; i++) {
+		if ((ptrs[i]->flags & BTRFS_RESTRIPE_ARGS_DRANGE) &&
+		    !(ptrs[i]->flags & BTRFS_RESTRIPE_ARGS_DEVID)) {
+			fprintf(stderr, "drange filter can be used only if "
+				"devid filter is used\n");
+			return 1;
+		}
+	}
+
+	/* soft makes sense only when convert for corresponding type is set */
+	for (i = 0; ptrs[i]; i++) {
+		if ((ptrs[i]->flags & BTRFS_RESTRIPE_ARGS_SOFT) &&
+		    !(ptrs[i]->flags & BTRFS_RESTRIPE_ARGS_CONVERT)) {
+			fprintf(stderr, "'soft' option can be used only if "
+				"changing profiles\n");
+			return 1;
+		}
+	}
+
+	path = av[optind];
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	if (force)
+		args.flags |= BTRFS_RESTRIPE_FORCE;
+	if (verbose)
+		dump_ioctl_restripe_args(&args);
+
+	ret = ioctl(fd, BTRFS_IOC_RESTRIPE, &args);
+	e = errno;
+	close(fd);
+
+	if (ret < 0) {
+		if (e == ECANCELED) {
+			fprintf(stderr, "restripe interrupted by user\n");
+		} else {
+			fprintf(stderr, "ERROR: error during restriping '%s' "
+				"- %s\n", path, strerror(e));
+			return 19;
+		}
+	}
+
+	return 0;
+}
+
+int do_restripe_cancel(int ac, char **av)
+{
+	int fd;
+	char *path = av[1];
+	int ret;
+	int e;
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_RESTRIPE_CTL, BTRFS_RESTRIPE_CTL_CANCEL);
+	e = errno;
+	close(fd);
+
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: restripe cancel on '%s' failed - %s\n",
+			path, (e == ENOTCONN) ? "Not in progress" : strerror(e));
+		return 19;
+	}
+
+	return 0;
+}
+
+int do_restripe_pause(int ac, char **av)
+{
+	int fd;
+	char *path = av[1];
+	int ret;
+	int e;
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_RESTRIPE_CTL, BTRFS_RESTRIPE_CTL_PAUSE);
+	e = errno;
+	close(fd);
+
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: restripe pause on '%s' failed - %s\n",
+			path, (e == ENOTCONN) ? "Not running" : strerror(e));
+		return 19;
+	}
+
+	return 0;
+}
+
+int do_restripe_resume(int ac, char **av)
+{
+	int fd;
+	char *path = av[1];
+	int ret;
+	int e;
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_RESTRIPE_CTL, BTRFS_RESTRIPE_CTL_RESUME);
+	e = errno;
+	close(fd);
 
+	if (ret < 0) {
+		if (e == ECANCELED) {
+			fprintf(stderr, "restripe interrupted by user\n");
+		} else if (e == ENOTCONN || e == EINPROGRESS) {
+			fprintf(stderr, "ERROR: restripe resume on '%s' "
+				"failed - %s\n", path,
+				(e == ENOTCONN) ? "Not in progress" :
+						  "Already running");
+			return 19;
+		} else {
+			fprintf(stderr, "ERROR: error during restriping '%s' "
+				"- %s\n", path, strerror(e));
+			return 19;
+		}
+	}
+
+	return 0;
+}
+
+static struct option restripe_progress_longopts[] = {
+	{ "verbose", 0, NULL, 'v' },
+	{ 0, 0, 0, 0}
+};
+
+int do_restripe_progress(int ac, char **av)
+{
+	int fd;
+	char *path;
+	struct btrfs_ioctl_restripe_args args;
+	int verbose = 0;
+	int longindex;
+	int ret;
+	int e;
+
+	while (1) {
+		int opt = getopt_long(ac, av, "v", restripe_progress_longopts,
+				      &longindex);
+		if (opt < 0)
+			break;
+
+		switch (opt) {
+		case 'v':
+			verbose = 1;
+			break;
+		default:
+			fprintf(stderr, "Invalid arguments for restripe "
+				"status\n");
+			return 1;
+		}
+	}
+
+	if (ac - optind != 1) {
+		fprintf(stderr, "Invalid arguments for restripe status\n");
+		return 1;
+	}
+
+	path = av[optind];
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_RESTRIPE_PROGRESS, &args);
+	e = errno;
+	close(fd);
+
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: restripe status on '%s' failed - %s\n",
+			path, (e == ENOTCONN) ? "Not in progress" : strerror(e));
 		return 19;
 	}
+
+	if (args.state & BTRFS_RESTRIPE_ST_RUNNING) {
+		printf("Restripe on '%s' is running", path);
+		if (args.state & BTRFS_RESTRIPE_ST_CANCEL_REQ)
+			printf(", cancel requested\n");
+		else if (args.state & BTRFS_RESTRIPE_ST_PAUSE_REQ)
+			printf(", pause requested\n");
+		else
+			printf("\n");
+	} else {
+		printf("Restripe on '%s' is paused\n", path);
+	}
+
+	printf("%llu out of about %llu chunks restriped (%llu considered), "
+	       "%3.f%% left\n", args.stat.completed, args.stat.expected,
+	       args.stat.considered,
+	       100 * (1 - (float)args.stat.completed/args.stat.expected));
+
+	if (verbose)
+		dump_ioctl_restripe_args(&args);
+
 	return 0;
 }
+
+static void dump_restripe_args(struct btrfs_restripe_args *args)
+{
+	if (args->flags & BTRFS_RESTRIPE_ARGS_CONVERT) {
+		printf("converting, target=%llu, soft is %s", args->target,
+		       (args->flags & BTRFS_RESTRIPE_ARGS_SOFT) ? "on" : "off");
+	} else {
+		printf("balancing");
+	}
+
+	if (args->flags & BTRFS_RESTRIPE_ARGS_PROFILES)
+		printf(", profiles=%llu", args->profiles);
+	if (args->flags & BTRFS_RESTRIPE_ARGS_USAGE)
+		printf(", usage=%llu", args->usage);
+	if (args->flags & BTRFS_RESTRIPE_ARGS_DEVID)
+		printf(", devid=%llu", args->devid);
+	if (args->flags & BTRFS_RESTRIPE_ARGS_DRANGE)
+		printf(", drange=%llu..%llu", args->pstart, args->pend);
+	if (args->flags & BTRFS_RESTRIPE_ARGS_VRANGE)
+		printf(", vrange=%llu..%llu", args->vstart, args->vend);
+
+	printf("\n");
+}
+
+static void dump_ioctl_restripe_args(struct btrfs_ioctl_restripe_args *args)
+{
+	printf("Dumping filters: flags 0x%llx, state 0x%llx, force is %s\n",
+	       args->flags, args->state,
+	       (args->flags & BTRFS_RESTRIPE_FORCE) ? "on" : "off");
+	if (args->flags & BTRFS_RESTRIPE_DATA) {
+		printf("  DATA (flags 0x%llx): ", args->data.flags);
+		dump_restripe_args(&args->data);
+	}
+	if (args->flags & BTRFS_RESTRIPE_METADATA) {
+		printf("  METADATA (flags 0x%llx): ", args->meta.flags);
+		dump_restripe_args(&args->meta);
+	}
+	if (args->flags & BTRFS_RESTRIPE_SYSTEM) {
+		printf("  SYSTEM (flags 0x%llx): ", args->sys.flags);
+		dump_restripe_args(&args->sys);
+	}
+}
+
 int do_remove_volume(int nargs, char **args)
 {
 
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index ab722d4..de09b65 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -23,6 +23,11 @@ int do_defrag(int argc, char **argv);
 int do_show_filesystem(int nargs, char **argv);
 int do_add_volume(int nargs, char **args);
 int do_balance(int nargs, char **argv);
+int do_restripe(int ac, char **av);
+int do_restripe_cancel(int ac, char **av);
+int do_restripe_pause(int ac, char **av);
+int do_restripe_resume(int ac, char **av);
+int do_restripe_progress(int ac, char **av);
 int do_remove_volume(int nargs, char **args);
 int do_scan(int nargs, char **argv);
 int do_resize(int nargs, char **argv);
diff --git a/ctree.h b/ctree.h
index 61eb639..46bb860 100644
--- a/ctree.h
+++ b/ctree.h
@@ -60,6 +60,9 @@ struct btrfs_trans_handle;
 #define BTRFS_CSUM_TREE_OBJECTID 7ULL
 
 
+/* for storing restripe params in the root tree */
+#define BTRFS_RESTRIPE_OBJECTID -4ULL
+
 /* oprhan objectid for tracking unlinked/truncated files */
 #define BTRFS_ORPHAN_OBJECTID -5ULL
 
@@ -651,6 +654,12 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_DUP	   (1 << 5)
 #define BTRFS_BLOCK_GROUP_RAID10   (1 << 6)
 
+/*
+ * to avoid troubles..
+ */
+#define BTRFS_AVAIL_ALLOC_BIT_SINGLE	(1 << 7)
+#define BTRFS_BLOCK_GROUP_RESERVED	(1 << 7)
+
 struct btrfs_block_group_item {
 	__le64 used;
 	__le64 chunk_objectid;
diff --git a/ioctl.h b/ioctl.h
index bb7b9e0..6eb5d70 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -30,6 +30,45 @@ struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
+#define BTRFS_RESTRIPE_CTL_CANCEL	1
+#define BTRFS_RESTRIPE_CTL_PAUSE	2
+#define BTRFS_RESTRIPE_CTL_RESUME	3
+
+struct btrfs_restripe_args {
+	__u64 profiles;
+	__u64 usage;
+	__u64 devid;
+	__u64 pstart;
+	__u64 pend;
+	__u64 vstart;
+	__u64 vend;
+
+	__u64 target;
+
+	__u64 flags;
+
+	__u64 unused[8];
+} __attribute__ ((__packed__));
+
+struct btrfs_restripe_progress {
+	__u64 expected;
+	__u64 considered;
+	__u64 completed;
+};
+
+struct btrfs_ioctl_restripe_args {
+	__u64 flags;
+	__u64 state;
+
+	struct btrfs_restripe_args data;
+	struct btrfs_restripe_args sys;
+	struct btrfs_restripe_args meta;
+
+	struct btrfs_restripe_progress stat;
+
+	__u64 unused[72]; /* pad to 1k */
+};
+
 struct btrfs_ioctl_search_key {
 	/* which root are we searching.  0 is the tree of tree roots */
 	__u64 tree_id;
@@ -176,4 +215,9 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_RESTRIPE _IOW(BTRFS_IOCTL_MAGIC, 32, \
+				struct btrfs_ioctl_restripe_args)
+#define BTRFS_IOC_RESTRIPE_CTL _IOW(BTRFS_IOCTL_MAGIC, 33, int)
+#define BTRFS_IOC_RESTRIPE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 34, \
+				struct btrfs_ioctl_restripe_args)
 #endif
diff --git a/print-tree.c b/print-tree.c
index ac575d5..14480d6 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -391,6 +391,9 @@ static void print_objectid(unsigned long long objectid, u8 type)
 	case BTRFS_CSUM_TREE_OBJECTID:
 		printf("CSUM_TREE");
 		break;
+	case BTRFS_RESTRIPE_OBJECTID:
+		printf("RESTRIPE");
+		break;
 	case BTRFS_ORPHAN_OBJECTID:
 		printf("ORPHAN");
 		break;
diff --git a/volumes.h b/volumes.h
index 93b0e48..5aaa61b 100644
--- a/volumes.h
+++ b/volumes.h
@@ -91,6 +91,48 @@ struct btrfs_multi_bio {
 #define btrfs_multi_bio_size(n) (sizeof(struct btrfs_multi_bio) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
+/*
+ * Restriper's general "type" filter.  Shares bits with chunk type for
+ * simplicity, RESTRIPE prefix is used to avoid confusion.
+ */
+#define BTRFS_RESTRIPE_DATA		(1ULL << 0)
+#define BTRFS_RESTRIPE_SYSTEM		(1ULL << 1)
+#define BTRFS_RESTRIPE_METADATA		(1ULL << 2)
+
+#define BTRFS_RESTRIPE_TYPE_MASK	(BTRFS_RESTRIPE_DATA |		    \
+					 BTRFS_RESTRIPE_SYSTEM |	    \
+					 BTRFS_RESTRIPE_METADATA)
+
+#define BTRFS_RESTRIPE_FORCE		(1ULL << 3)
+
+/*
+ * Restripe filters
+ */
+#define BTRFS_RESTRIPE_ARGS_PROFILES	(1ULL << 0)
+#define BTRFS_RESTRIPE_ARGS_USAGE	(1ULL << 1)
+#define BTRFS_RESTRIPE_ARGS_DEVID	(1ULL << 2)
+#define BTRFS_RESTRIPE_ARGS_DRANGE	(1ULL << 3)
+#define BTRFS_RESTRIPE_ARGS_VRANGE	(1ULL << 4)
+
+/*
+ * Profile changing flags.  When SOFT is set we won't relocate chunk if
+ * it already has the target profile (even though it may be
+ * half-filled).
+ */
+#define BTRFS_RESTRIPE_ARGS_CONVERT	(1ULL << 8)
+#define BTRFS_RESTRIPE_ARGS_SOFT	(1ULL << 9)
+
+/*
+ * Restripe state bits
+ */
+#define RESTRIPE_RUNNING	0
+#define RESTRIPE_CANCEL_REQ	1
+#define RESTRIPE_PAUSE_REQ	2
+
+#define BTRFS_RESTRIPE_ST_RUNNING	(1ULL << RESTRIPE_RUNNING)
+#define BTRFS_RESTRIPE_ST_CANCEL_REQ	(1ULL << RESTRIPE_CANCEL_REQ)
+#define BTRFS_RESTRIPE_ST_PAUSE_REQ	(1ULL << RESTRIPE_PAUSE_REQ)
+
 int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 			   struct btrfs_device *device,
 			   u64 chunk_tree, u64 chunk_objectid,
-- 
1.7.5.4

