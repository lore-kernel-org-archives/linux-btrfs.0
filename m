From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs-progs: add restriper commands
Date: Fri,  6 Jan 2012 16:38:00 +0200
Message-ID: <1325860680-19403-2-git-send-email-idryomov@gmail.com>
References: <1325860680-19403-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860680-19403-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Import restriper commands under btrfs fi balance:

  btrfs fi balance start
  btrfs fi balance cancel
  btrfs fi balance pause
  btrfs fi balance resume
  btrfs fi balance status

NOTE: Backwards compatibility is broken for now, to get the old "balance
everything" behaviour one has to call 'btrfs fi balance start' with no
options instead of 'btrfs fi balance'.  This is because btrfs utility
sub-command parser is not flexible enough.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 btrfs.c      |   27 +++-
 btrfs_cmds.c |  577 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 btrfs_cmds.h |    8 +-
 ctree.h      |   23 ++-
 ioctl.h      |   53 ++++++
 print-tree.c |    6 +
 volumes.h    |   30 +++
 7 files changed, 687 insertions(+), 37 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 1def354..b639e83 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -119,9 +119,30 @@ static struct Command commands[] = {
 		"Show space usage information for a mount point.",
 	  NULL
 	},
-	{ do_balance, 1,
-	  "filesystem balance", "<path>\n"
-		"Balance the chunks across the device.",
+	{ do_balance, -1,
+	  "filesystem balance start", "[-d [filters]] [-m [filters]] "
+	  "[-s [filters]] [-vf] <path>\n"
+		"Balance chunks across the devices.",
+	  NULL
+	},
+	{ do_balance_pause, 1,
+	  "filesystem balance pause", "<path>\n"
+		"Pause running balance.",
+	  NULL
+	},
+	{ do_balance_cancel, 1,
+	  "filesystem balance cancel", "<path>\n"
+		"Cancel running or paused balance.",
+	  NULL
+	},
+	{ do_balance_resume, 1,
+	  "filesystem balance resume", "<path>\n"
+		"Resume interrupted balance.",
+	  NULL
+	},
+	{ do_balance_progress, -1,
+	  "filesystem balance status", "[-v] <path>\n"
+		"Show status of running or paused balance.",
 	  NULL
 	},
 	{ do_change_label, -1,
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index b59e9cb..f3ea9ab 100644
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
@@ -888,31 +889,6 @@ int do_add_volume(int nargs, char **args)
 
 }
 
-int do_balance(int argc, char **argv)
-{
-
-	int	fdmnt, ret=0, e;
-	struct btrfs_ioctl_vol_args args;
-	char	*path = argv[1];
-
-	fdmnt = open_file_or_dir(path);
-	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
-	}
-
-	memset(&args, 0, sizeof(args));
-	ret = ioctl(fdmnt, BTRFS_IOC_BALANCE, &args);
-	e = errno;
-	close(fdmnt);
-	if(ret<0){
-		fprintf(stderr, "ERROR: error during balancing '%s' - %s\n", 
-			path, strerror(e));
-
-		return 19;
-	}
-	return 0;
-}
 int do_remove_volume(int nargs, char **args)
 {
 
@@ -946,6 +922,557 @@ int do_remove_volume(int nargs, char **args)
 		return 0;
 }
 
+static int parse_one_profile(const char *profile, u64 *flags)
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
+static int parse_u64(const char *str, u64 *result)
+{
+	char *endptr;
+	u64 val;
+
+	val = strtoull(str, &endptr, 10);
+	if (*endptr)
+		return 1;
+
+	*result = val;
+	return 0;
+}
+
+static int parse_range(const char *range, u64 *start, u64 *end)
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
+			if (parse_u64(rest, end))
+				return 1;
+		}
+		if (dots == range) {
+			*start = 0;
+			skipped++;
+		} else {
+			if (parse_u64(range, start))
+				return 1;
+		}
+
+		if (*start >= *end) {
+			fprintf(stderr, "Range %llu..%llu doesn't make "
+				"sense\n", (unsigned long long)*start,
+				(unsigned long long)*end);
+			return 1;
+		}
+
+		if (skipped <= 1)
+			return 0;
+	}
+
+	return 1;
+}
+
+static int parse_filters(char *filters, struct btrfs_balance_args *args)
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
+			if (parse_profiles(value, &args->profiles)) {
+				fprintf(stderr, "Invalid profiles argument\n");
+				return 1;
+			}
+			args->flags |= BTRFS_BALANCE_ARGS_PROFILES;
+		} else if (!strcmp(this_char, "usage")) {
+			if (!value || !*value) {
+				fprintf(stderr, "the usage filter requires "
+				       "an argument\n");
+				return 1;
+			}
+			if (parse_u64(value, &args->usage) ||
+			    args->usage < 1 || args->usage > 100) {
+				fprintf(stderr, "Invalid usage argument: %s\n",
+				       value);
+				return 1;
+			}
+			args->flags |= BTRFS_BALANCE_ARGS_USAGE;
+		} else if (!strcmp(this_char, "devid")) {
+			if (!value || !*value) {
+				fprintf(stderr, "the devid filter requires "
+				       "an argument\n");
+				return 1;
+			}
+			if (parse_u64(value, &args->devid) ||
+			    args->devid == 0) {
+				fprintf(stderr, "Invalid devid argument: %s\n",
+				       value);
+				return 1;
+			}
+			args->flags |= BTRFS_BALANCE_ARGS_DEVID;
+		} else if (!strcmp(this_char, "drange")) {
+			if (!value || !*value) {
+				fprintf(stderr, "the drange filter requires "
+				       "an argument\n");
+				return 1;
+			}
+			if (parse_range(value, &args->pstart, &args->pend)) {
+				fprintf(stderr, "Invalid drange argument\n");
+				return 1;
+			}
+			args->flags |= BTRFS_BALANCE_ARGS_DRANGE;
+		} else if (!strcmp(this_char, "vrange")) {
+			if (!value || !*value) {
+				fprintf(stderr, "the vrange filter requires "
+				       "an argument\n");
+				return 1;
+			}
+			if (parse_range(value, &args->vstart, &args->vend)) {
+				fprintf(stderr, "Invalid vrange argument\n");
+				return 1;
+			}
+			args->flags |= BTRFS_BALANCE_ARGS_VRANGE;
+		} else if (!strcmp(this_char, "convert")) {
+			if (!value || !*value) {
+				fprintf(stderr, "the convert option requires "
+				       "an argument\n");
+				return 1;
+			}
+			if (parse_one_profile(value, &args->target)) {
+				fprintf(stderr, "Invalid convert argument\n");
+				return 1;
+			}
+			args->flags |= BTRFS_BALANCE_ARGS_CONVERT;
+		} else if (!strcmp(this_char, "soft")) {
+			args->flags |= BTRFS_BALANCE_ARGS_SOFT;
+		} else {
+			fprintf(stderr, "Unrecognized balance option '%s'\n",
+				this_char);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static void dump_ioctl_balance_args(struct btrfs_ioctl_balance_args *args);
+
+static struct option balance_longopts[] = {
+	{ "data", optional_argument, NULL, 'd'},
+	{ "metadata", optional_argument, NULL, 'm' },
+	{ "system", optional_argument, NULL, 's' },
+	{ "force", no_argument, NULL, 'f' },
+	{ "verbose", no_argument, NULL, 'v' },
+	{ 0, 0, 0, 0}
+};
+
+/*
+ * [-d [filters]] [-m [filters]] [-s [filters]] [-vf]
+ */
+int do_balance(int argc, char **argv)
+{
+	int fd;
+	char *path;
+	struct btrfs_ioctl_balance_args args;
+	struct btrfs_balance_args *ptrs[] = { &args.data, &args.sys,
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
+		int opt = getopt_long(argc, argv, "d::s::m::fv",
+				      balance_longopts, &longindex);
+		if (opt < 0)
+			break;
+
+		switch (opt) {
+		case 'd':
+			nofilters = 0;
+			args.flags |= BTRFS_BALANCE_DATA;
+
+			if (parse_filters(optarg, &args.data))
+				return 1;
+			break;
+		case 's':
+			nofilters = 0;
+			args.flags |= BTRFS_BALANCE_SYSTEM;
+
+			if (parse_filters(optarg, &args.sys))
+				return 1;
+			break;
+		case 'm':
+			nofilters = 0;
+			args.flags |= BTRFS_BALANCE_METADATA;
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
+			fprintf(stderr, "Invalid arguments for balance\n");
+			return 1;
+		}
+	}
+
+	if (argc - optind != 1) {
+		fprintf(stderr, "Invalid arguments for balance\n");
+		return 1;
+	}
+
+	/* 
+	 * allow -s only under --force, otherwise do with system chunks
+	 * the same thing we were ordered to do with meta chunks
+	 */
+	if (args.flags & BTRFS_BALANCE_SYSTEM) {
+		if (!force) {
+			fprintf(stderr,
+"Refusing to explicitly operate on system chunks.\n"
+"Pass --force if you really want to do that.\n");
+			return 1;
+		}
+	} else if (args.flags & BTRFS_BALANCE_METADATA) {
+		args.flags |= BTRFS_BALANCE_SYSTEM;
+		memcpy(&args.sys, &args.meta,
+			sizeof(struct btrfs_balance_args));
+	}
+
+	if (nofilters) {
+		/* relocate everything - no filters */
+		args.flags |= BTRFS_BALANCE_TYPE_MASK;
+	}
+
+	/* drange makes sense only when devid is set */
+	for (i = 0; ptrs[i]; i++) {
+		if ((ptrs[i]->flags & BTRFS_BALANCE_ARGS_DRANGE) &&
+		    !(ptrs[i]->flags & BTRFS_BALANCE_ARGS_DEVID)) {
+			fprintf(stderr, "drange filter can be used only if "
+				"devid filter is used\n");
+			return 1;
+		}
+	}
+
+	/* soft makes sense only when convert for corresponding type is set */
+	for (i = 0; ptrs[i]; i++) {
+		if ((ptrs[i]->flags & BTRFS_BALANCE_ARGS_SOFT) &&
+		    !(ptrs[i]->flags & BTRFS_BALANCE_ARGS_CONVERT)) {
+			fprintf(stderr, "'soft' option can be used only if "
+				"changing profiles\n");
+			return 1;
+		}
+	}
+
+	path = argv[optind];
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	if (force)
+		args.flags |= BTRFS_BALANCE_FORCE;
+	if (verbose)
+		dump_ioctl_balance_args(&args);
+
+	ret = ioctl(fd, BTRFS_IOC_BALANCE_V2, &args);
+	e = errno;
+	close(fd);
+
+	if (ret < 0) {
+		if (e == ECANCELED) {
+			fprintf(stderr, "balance interrupted by user\n");
+		} else {
+			fprintf(stderr, "ERROR: error during balancing '%s' "
+				"- %s\n", path, strerror(e));
+			if (e != EINPROGRESS)
+				fprintf(stderr, "There may be more info in "
+					"syslog - try dmesg | tail\n");
+			return 19;
+		}
+	}
+
+	return 0;
+}
+
+int do_balance_pause(int argc, char **argv)
+{
+	int fd;
+	char *path = argv[1];
+	int ret;
+	int e;
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_BALANCE_CTL, BTRFS_BALANCE_CTL_PAUSE);
+	e = errno;
+	close(fd);
+
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: balance pause on '%s' failed - %s\n",
+			path, (e == ENOTCONN) ? "Not running" : strerror(e));
+		return 19;
+	}
+
+	return 0;
+}
+
+int do_balance_cancel(int argc, char **argv)
+{
+	int fd;
+	char *path = argv[1];
+	int ret;
+	int e;
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_BALANCE_CTL, BTRFS_BALANCE_CTL_CANCEL);
+	e = errno;
+	close(fd);
+
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: balance cancel on '%s' failed - %s\n",
+			path, (e == ENOTCONN) ? "Not in progress" : strerror(e));
+		return 19;
+	}
+
+	return 0;
+}
+
+int do_balance_resume(int argc, char **argv)
+{
+	int fd;
+	char *path = argv[1];
+	int ret;
+	int e;
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_BALANCE_CTL, BTRFS_BALANCE_CTL_RESUME);
+	e = errno;
+	close(fd);
+
+	if (ret < 0) {
+		if (e == ECANCELED) {
+			fprintf(stderr, "balance interrupted by user\n");
+		} else if (e == ENOTCONN || e == EINPROGRESS) {
+			fprintf(stderr, "ERROR: balance resume on '%s' "
+				"failed - %s\n", path,
+				(e == ENOTCONN) ? "Not in progress" :
+						  "Already running");
+			return 19;
+		} else {
+			fprintf(stderr,
+"ERROR: error during balancing '%s' - %s\n"
+"There may be more info in syslog - try dmesg | tail\n", path, strerror(e));
+			return 19;
+		}
+	}
+
+	return 0;
+}
+
+static struct option balance_progress_longopts[] = {
+	{ "verbose", no_argument, NULL, 'v' },
+	{ 0, 0, 0, 0}
+};
+
+int do_balance_progress(int argc, char **argv)
+{
+	int fd;
+	char *path;
+	struct btrfs_ioctl_balance_args args;
+	int verbose = 0;
+	int longindex;
+	int ret;
+	int e;
+
+	while (1) {
+		int opt = getopt_long(argc, argv, "v",
+				      balance_progress_longopts, &longindex);
+		if (opt < 0)
+			break;
+
+		switch (opt) {
+		case 'v':
+			verbose = 1;
+			break;
+		default:
+			fprintf(stderr, "Invalid arguments for balance "
+				"status\n");
+			return 1;
+		}
+	}
+
+	if (argc - optind != 1) {
+		fprintf(stderr, "Invalid arguments for balance status\n");
+		return 1;
+	}
+
+	path = argv[optind];
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_BALANCE_PROGRESS, &args);
+	e = errno;
+	close(fd);
+
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: balance status on '%s' failed - %s\n",
+			path, (e == ENOTCONN) ? "Not in progress" : strerror(e));
+		return 19;
+	}
+
+	if (args.state & BTRFS_BALANCE_STATE_RUNNING) {
+		printf("Balance on '%s' is running", path);
+		if (args.state & BTRFS_BALANCE_STATE_CANCEL_REQ)
+			printf(", cancel requested\n");
+		else if (args.state & BTRFS_BALANCE_STATE_PAUSE_REQ)
+			printf(", pause requested\n");
+		else
+			printf("\n");
+	} else {
+		printf("Balance on '%s' is paused\n", path);
+	}
+
+	printf("%llu out of about %llu chunks balanced (%llu considered), "
+	       "%3.f%% left\n", (unsigned long long)args.stat.completed,
+	       (unsigned long long)args.stat.expected,
+	       (unsigned long long)args.stat.considered,
+	       100 * (1 - (float)args.stat.completed/args.stat.expected));
+
+	if (verbose)
+		dump_ioctl_balance_args(&args);
+
+	return 0;
+}
+
+static void dump_balance_args(struct btrfs_balance_args *args)
+{
+	if (args->flags & BTRFS_BALANCE_ARGS_CONVERT) {
+		printf("converting, target=%llu, soft is %s",
+		       (unsigned long long)args->target,
+		       (args->flags & BTRFS_BALANCE_ARGS_SOFT) ? "on" : "off");
+	} else {
+		printf("balancing");
+	}
+
+	if (args->flags & BTRFS_BALANCE_ARGS_PROFILES)
+		printf(", profiles=%llu", (unsigned long long)args->profiles);
+	if (args->flags & BTRFS_BALANCE_ARGS_USAGE)
+		printf(", usage=%llu", (unsigned long long)args->usage);
+	if (args->flags & BTRFS_BALANCE_ARGS_DEVID)
+		printf(", devid=%llu", (unsigned long long)args->devid);
+	if (args->flags & BTRFS_BALANCE_ARGS_DRANGE)
+		printf(", drange=%llu..%llu",
+		       (unsigned long long)args->pstart,
+		       (unsigned long long)args->pend);
+	if (args->flags & BTRFS_BALANCE_ARGS_VRANGE)
+		printf(", vrange=%llu..%llu",
+		       (unsigned long long)args->vstart,
+		       (unsigned long long)args->vend);
+
+	printf("\n");
+}
+
+static void dump_ioctl_balance_args(struct btrfs_ioctl_balance_args *args)
+{
+	printf("Dumping filters: flags 0x%llx, state 0x%llx, force is %s\n",
+	       (unsigned long long)args->flags, (unsigned long long)args->state,
+	       (args->flags & BTRFS_BALANCE_FORCE) ? "on" : "off");
+	if (args->flags & BTRFS_BALANCE_DATA) {
+		printf("  DATA (flags 0x%llx): ",
+		       (unsigned long long)args->data.flags);
+		dump_balance_args(&args->data);
+	}
+	if (args->flags & BTRFS_BALANCE_METADATA) {
+		printf("  METADATA (flags 0x%llx): ",
+		       (unsigned long long)args->meta.flags);
+		dump_balance_args(&args->meta);
+	}
+	if (args->flags & BTRFS_BALANCE_SYSTEM) {
+		printf("  SYSTEM (flags 0x%llx): ",
+		       (unsigned long long)args->sys.flags);
+		dump_balance_args(&args->sys);
+	}
+}
+
 int do_set_default_subvol(int nargs, char **argv)
 {
 	int	ret=0, fd, e;
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 81182b1..53d51d6 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -22,12 +22,16 @@ int do_fssync(int nargs, char **argv);
 int do_defrag(int argc, char **argv);
 int do_show_filesystem(int nargs, char **argv);
 int do_add_volume(int nargs, char **args);
-int do_balance(int nargs, char **argv);
+int do_remove_volume(int nargs, char **args);
+int do_balance(int argc, char **argv);
+int do_balance_pause(int argc, char **argv);
+int do_balance_cancel(int argc, char **argv);
+int do_balance_resume(int argc, char **argv);
+int do_balance_progress(int argc, char **argv);
 int do_scrub_start(int nargs, char **argv);
 int do_scrub_status(int argc, char **argv);
 int do_scrub_resume(int argc, char **argv);
 int do_scrub_cancel(int nargs, char **argv);
-int do_remove_volume(int nargs, char **args);
 int do_scan(int nargs, char **argv);
 int do_resize(int nargs, char **argv);
 int do_subvol_list(int nargs, char **argv);
diff --git a/ctree.h b/ctree.h
index 54748c8..1c3740c 100644
--- a/ctree.h
+++ b/ctree.h
@@ -61,6 +61,9 @@ struct btrfs_trans_handle;
 #define BTRFS_CSUM_TREE_OBJECTID 7ULL
 
 
+/* for storing balance parameters in the root tree */
+#define BTRFS_BALANCE_OBJECTID -4ULL
+
 /* oprhan objectid for tracking unlinked/truncated files */
 #define BTRFS_ORPHAN_OBJECTID -5ULL
 
@@ -697,13 +700,17 @@ struct btrfs_csum_item {
 } __attribute__ ((__packed__));
 
 /* tag for the radix tree of block groups in ram */
-#define BTRFS_BLOCK_GROUP_DATA     (1 << 0)
-#define BTRFS_BLOCK_GROUP_SYSTEM   (1 << 1)
-#define BTRFS_BLOCK_GROUP_METADATA (1 << 2)
-#define BTRFS_BLOCK_GROUP_RAID0    (1 << 3)
-#define BTRFS_BLOCK_GROUP_RAID1    (1 << 4)
-#define BTRFS_BLOCK_GROUP_DUP	   (1 << 5)
-#define BTRFS_BLOCK_GROUP_RAID10   (1 << 6)
+#define BTRFS_BLOCK_GROUP_DATA		(1ULL << 0)
+#define BTRFS_BLOCK_GROUP_SYSTEM	(1ULL << 1)
+#define BTRFS_BLOCK_GROUP_METADATA	(1ULL << 2)
+#define BTRFS_BLOCK_GROUP_RAID0		(1ULL << 3)
+#define BTRFS_BLOCK_GROUP_RAID1		(1ULL << 4)
+#define BTRFS_BLOCK_GROUP_DUP		(1ULL << 5)
+#define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
+#define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
+
+/* used in struct btrfs_balance_args fields */
+#define BTRFS_AVAIL_ALLOC_BIT_SINGLE	(1ULL << 48)
 
 struct btrfs_block_group_item {
 	__le64 used;
@@ -911,6 +918,8 @@ struct btrfs_root {
 #define BTRFS_DEV_ITEM_KEY	216
 #define BTRFS_CHUNK_ITEM_KEY	228
 
+#define BTRFS_BALANCE_ITEM_KEY	248
+
 /*
  * string items are for debugging.  They just store a short string of
  * data in the FS
diff --git a/ioctl.h b/ioctl.h
index 1ae7537..78aebce 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -91,6 +91,54 @@ struct btrfs_ioctl_fs_info_args {
 	__u64 reserved[124];			/* pad to 1k */
 };
 
+/* balance control ioctl modes */
+#define BTRFS_BALANCE_CTL_PAUSE		1
+#define BTRFS_BALANCE_CTL_CANCEL	2
+#define BTRFS_BALANCE_CTL_RESUME	3
+
+/*
+ * this is packed, because it should be exactly the same as its disk
+ * byte order counterpart (struct btrfs_disk_balance_args)
+ */
+struct btrfs_balance_args {
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
+struct btrfs_balance_progress {
+	__u64 expected;
+	__u64 considered;
+	__u64 completed;
+};
+
+#define BTRFS_BALANCE_STATE_RUNNING	(1ULL << 0)
+#define BTRFS_BALANCE_STATE_CANCEL_REQ	(1ULL << 1)
+#define BTRFS_BALANCE_STATE_PAUSE_REQ	(1ULL << 2)
+
+struct btrfs_ioctl_balance_args {
+	__u64 flags;				/* in/out */
+	__u64 state;				/* out */
+
+	struct btrfs_balance_args data;		/* in/out */
+	struct btrfs_balance_args meta;		/* in/out */
+	struct btrfs_balance_args sys;		/* in/out */
+
+	struct btrfs_balance_progress stat;	/* out */
+
+	__u64 unused[72];			/* pad to 1k */
+};
+
 struct btrfs_ioctl_search_key {
 	/* which root are we searching.  0 is the tree of tree roots */
 	__u64 tree_id;
@@ -273,6 +321,11 @@ struct btrfs_ioctl_logical_ino_args {
 					struct btrfs_ioctl_dev_info_args)
 #define BTRFS_IOC_FS_INFO _IOR(BTRFS_IOCTL_MAGIC, 31, \
                                  struct btrfs_ioctl_fs_info_args)
+#define BTRFS_IOC_BALANCE_V2 _IOW(BTRFS_IOCTL_MAGIC, 32, \
+				  struct btrfs_ioctl_balance_args)
+#define BTRFS_IOC_BALANCE_CTL _IOW(BTRFS_IOCTL_MAGIC, 33, int)
+#define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 34, \
+					struct btrfs_ioctl_balance_args)
 #define BTRFS_IOC_INO_PATHS _IOWR(BTRFS_IOCTL_MAGIC, 35, \
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
diff --git a/print-tree.c b/print-tree.c
index 6039699..494ba8b 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -351,6 +351,9 @@ static void print_key_type(u8 type)
 	case BTRFS_DEV_EXTENT_KEY:
 		printf("DEV_EXTENT");
 		break;
+	case BTRFS_BALANCE_ITEM_KEY:
+		printf("BALANCE_ITEM");
+		break;
 	case BTRFS_STRING_ITEM_KEY:
 		printf("STRING_ITEM");
 		break;
@@ -391,6 +394,9 @@ static void print_objectid(unsigned long long objectid, u8 type)
 	case BTRFS_CSUM_TREE_OBJECTID:
 		printf("CSUM_TREE");
 		break;
+	case BTRFS_BALANCE_OBJECTID:
+		printf("BALANCE");
+		break;
 	case BTRFS_ORPHAN_OBJECTID:
 		printf("ORPHAN");
 		break;
diff --git a/volumes.h b/volumes.h
index 7104d36..3c2457e 100644
--- a/volumes.h
+++ b/volumes.h
@@ -91,6 +91,36 @@ struct btrfs_multi_bio {
 #define btrfs_multi_bio_size(n) (sizeof(struct btrfs_multi_bio) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
+/*
+ * Restriper's general type filter
+ */
+#define BTRFS_BALANCE_DATA		(1ULL << 0)
+#define BTRFS_BALANCE_SYSTEM		(1ULL << 1)
+#define BTRFS_BALANCE_METADATA		(1ULL << 2)
+
+#define BTRFS_BALANCE_TYPE_MASK		(BTRFS_BALANCE_DATA |	    \
+					 BTRFS_BALANCE_SYSTEM |	    \
+					 BTRFS_BALANCE_METADATA)
+
+#define BTRFS_BALANCE_FORCE		(1ULL << 3)
+
+/*
+ * Balance filters
+ */
+#define BTRFS_BALANCE_ARGS_PROFILES	(1ULL << 0)
+#define BTRFS_BALANCE_ARGS_USAGE	(1ULL << 1)
+#define BTRFS_BALANCE_ARGS_DEVID	(1ULL << 2)
+#define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
+#define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
+
+/*
+ * Profile changing flags.  When SOFT is set we won't relocate chunk if
+ * it already has the target profile (even though it may be
+ * half-filled).
+ */
+#define BTRFS_BALANCE_ARGS_CONVERT	(1ULL << 8)
+#define BTRFS_BALANCE_ARGS_SOFT		(1ULL << 9)
+
 int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 			   struct btrfs_device *device,
 			   u64 chunk_tree, u64 chunk_objectid,
-- 
1.7.6.3

