Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15660 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932616AbdC3GVf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 02:21:35 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 6744647EE219
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Mar 2017 14:21:30 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Su <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 19/19] btrfs-progs: fsck: Introduce offline scrub function
Date: Thu, 30 Mar 2017 14:21:15 +0800
Message-ID: <20170330062116.14379-20-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
References: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now, btrfs check has a kernel scrub equivalent.
A new option, --scrub is added for "btrfs check".

If --scrub is given, btrfs check will just act like kernel scrub, to
check every copy of extent and do a report on corrupted data and if it's
recoverable.

The advantage compare to kernel scrub is:
1) No race
   Unlike kernel scrub, which is done in parallel, offline scrub is done
   by a single thread.
   Although it may be slower than kernel one, it's safer and no false
   alert.

2) Correctness
   Kernel has a known bug (fix submitted) which will recovery RAID5/6
   data but screw up P/Q, due to the hardness coding in kernel.
   While in btrfs-progs, no page, (almost) no memory size limit, we're
   can focus on the scrub, and make things easier.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Su <suy.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-scrub.asciidoc |   9 +++
 cmds-scrub.c                       | 111 +++++++++++++++++++++++++++++++++++--
 ctree.h                            |   5 ++
 scrub.c                            |  69 +++++++++++++++++++++++
 utils.h                            |   6 ++
 5 files changed, 196 insertions(+), 4 deletions(-)

diff --git a/Documentation/btrfs-scrub.asciidoc b/Documentation/btrfs-scrub.asciidoc
index eb90a1c4..f590474d 100644
--- a/Documentation/btrfs-scrub.asciidoc
+++ b/Documentation/btrfs-scrub.asciidoc
@@ -78,6 +78,15 @@ set IO priority classdata (see `ionice`(1) manpage)
 force starting new scrub even if a scrub is already running,
 this can useful when scrub status file is damaged and reports a running
 scrub although it is not, but should not normally be necessary
+--offline::::
+Do offline scrub.
+NOTE: it's experimental and repair is not supported yet.
+--progress::::
+Show progress status while doing offline scrub.
+NOTE: it's only useful with option --offline.
+--no-progress::::
+Don't show progress status while doing offline scrub.
+NOTE: it's only useful with option --offline.
 
 *status* [-d] <path>|<device>::
 Show status of a running scrub for the filesystem identified by 'path' or
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 5388fdcf..961e2776 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -36,12 +36,14 @@
 #include <signal.h>
 #include <stdarg.h>
 #include <limits.h>
+#include <getopt.h>
 
 #include "ctree.h"
 #include "ioctl.h"
 #include "utils.h"
 #include "volumes.h"
 #include "disk-io.h"
+#include "task-utils.h"
 
 #include "commands.h"
 #include "help.h"
@@ -217,6 +219,32 @@ static void add_to_fs_stat(struct btrfs_scrub_progress *p,
 	_SCRUB_FS_STAT_MIN(ss, finished, fs_stat);
 }
 
+static void *print_offline_status(void *p)
+{
+	struct task_context *ctx = p;
+	const char work_indicator[] = {'.', 'o', 'O', 'o' };
+	uint32_t count = 0;
+
+	task_period_start(ctx->info, 1000 /* 1s */);
+
+	while (1) {
+		printf("Doing offline scrub [%c] [%llu/%llu]\r",
+		       work_indicator[count % 4], ctx->cur, ctx->all);
+		count++;
+		fflush(stdout);
+		task_period_wait(ctx->info);
+	}
+	return NULL;
+}
+
+static int print_offline_return(void *p)
+{
+	printf("\n");
+	fflush(stdout);
+
+	return 0;
+}
+
 static void init_fs_stat(struct scrub_fs_stat *fs_stat)
 {
 	memset(fs_stat, 0, sizeof(*fs_stat));
@@ -1100,7 +1128,7 @@ static const char * const cmd_scrub_resume_usage[];
 
 static int scrub_start(int argc, char **argv, int resume)
 {
-	int fdmnt;
+	int fdmnt = -1;
 	int prg_fd = -1;
 	int fdres = -1;
 	int ret;
@@ -1124,10 +1152,14 @@ static int scrub_start(int argc, char **argv, int resume)
 	int n_start = 0;
 	int n_skip = 0;
 	int n_resume = 0;
+	int offline = 0;
+	int progress_set = -1;
 	struct btrfs_ioctl_fs_info_args fi_args;
 	struct btrfs_ioctl_dev_info_args *di_args = NULL;
 	struct scrub_progress *sp = NULL;
 	struct scrub_fs_stat fs_stat;
+	struct task_context task = {0};
+	struct btrfs_fs_info *fs_info = NULL;
 	struct timeval tv;
 	struct sockaddr_un addr = {
 		.sun_family = AF_UNIX,
@@ -1147,7 +1179,18 @@ static int scrub_start(int argc, char **argv, int resume)
 	int force = 0;
 	int nothing_to_resume = 0;
 
-	while ((c = getopt(argc, argv, "BdqrRc:n:f")) != -1) {
+	enum { GETOPT_VAL_OFFLINE = 257,
+	       GETOPT_VAL_PROGRESS,
+	       GETOPT_VAL_NO_PROGRESS};
+	static const struct option long_options[] = {
+		{ "offline", no_argument, NULL, GETOPT_VAL_OFFLINE},
+		{ "progress", no_argument, NULL, GETOPT_VAL_PROGRESS},
+		{ "no-progress", no_argument, NULL, GETOPT_VAL_NO_PROGRESS},
+		{ NULL, 0, NULL, 0}
+	};
+
+	while ((c = getopt_long(argc, argv, "BdqrRc:n:f", long_options,
+				NULL)) != -1) {
 		switch (c) {
 		case 'B':
 			do_background = 0;
@@ -1175,6 +1218,15 @@ static int scrub_start(int argc, char **argv, int resume)
 		case 'f':
 			force = 1;
 			break;
+		case GETOPT_VAL_OFFLINE:
+			offline = 1;
+			break;
+		case GETOPT_VAL_PROGRESS:
+			progress_set = 1;
+			break;
+		case GETOPT_VAL_NO_PROGRESS:
+			progress_set = 0;
+			break;
 		case '?':
 		default:
 			usage(resume ? cmd_scrub_resume_usage :
@@ -1189,6 +1241,51 @@ static int scrub_start(int argc, char **argv, int resume)
 					cmd_scrub_start_usage);
 	}
 
+	if (progress_set && !offline)
+		warning("Option --progress is only with --offline, ignored.");
+	if (!progress_set && !offline)
+		warning("Option --no-progress is only with --offline, ignored.");
+
+	if (offline) {
+		ret = check_mounted(argv[optind]);
+		if (ret < 0) {
+			error("could not check mount status: %s", strerror(-ret));
+			err |= !!ret;
+			goto out;
+		} else if (ret) {
+			error("%s is currently mounted, aborting", argv[optind]);
+			ret = -EBUSY;
+			err |= !!ret;
+			goto out;
+		}
+
+		if (!do_background || do_wait || do_print ||
+		    do_stats_per_dev || do_quiet || readonly || print_raw ||
+		    ioprio_class != IOPRIO_CLASS_IDLE || ioprio_classdata ||
+		    force)
+			warning("Option offline does not support some options");
+
+		fs_info = open_ctree_fs_info(argv[optind], 0, 0, 0, 0);
+		if (!fs_info) {
+			error("cannot open file system");
+			ret = -EIO;
+			err = 1;
+			goto out;
+		}
+
+		if (progress_set) {
+			task.info = task_init(print_offline_status,
+					      print_offline_return, &task);
+			ret = btrfs_scrub(fs_info, &task);
+			task_deinit(task.info);
+		} else {
+			ret = btrfs_scrub(fs_info, NULL);
+		}
+
+		goto out;
+	}
+
+
 	spc.progress = NULL;
 	if (do_quiet && do_print)
 		do_print = 0;
@@ -1545,7 +1642,10 @@ out:
 		if (sock_path[0])
 			unlink(sock_path);
 	}
-	close_file_or_dir(fdmnt, dirstream);
+	if (fdmnt >= 0)
+		close_file_or_dir(fdmnt, dirstream);
+	if (fs_info)
+		close_ctree_fs_info(fs_info);
 
 	if (err)
 		return 1;
@@ -1563,7 +1663,7 @@ out:
 }
 
 static const char * const cmd_scrub_start_usage[] = {
-	"btrfs scrub start [-BdqrRf] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
+	"btrfs scrub start [-BdqrRf] [-c ioprio_class -n ioprio_classdata] [--offline] [--progress][no-progress] <path>|<device>",
 	"Start a new scrub. If a scrub is already running, the new one fails.",
 	"",
 	"-B     do not background",
@@ -1574,6 +1674,9 @@ static const char * const cmd_scrub_start_usage[] = {
 	"-c     set ioprio class (see ionice(1) manpage)",
 	"-n     set ioprio classdata (see ionice(1) manpage)",
 	"-f     force starting new scrub even if a scrub is already running",
+	"--offline     start an offline scrub, not support other options",
+	"--progress    show progress status, only work with option --offline",
+	"--no-progress do not show progress status, only work only with option --offline",
 	"       this is useful when scrub stats record file is damaged",
 	NULL
 };
diff --git a/ctree.h b/ctree.h
index d3ddf752..328e9dca 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2785,4 +2785,9 @@ int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
 int btrfs_read_data_csums(struct btrfs_fs_info *fs_info, u64 start, u64 len,
 			  void *csum_ret, unsigned long *bitmap_ret);
 
+
+/* scrub.c */
+struct task_context;
+int btrfs_scrub(struct btrfs_fs_info *fs_info, struct task_context *ctx);
+
 #endif
diff --git a/scrub.c b/scrub.c
index 99eff5dc..68edc776 100644
--- a/scrub.c
+++ b/scrub.c
@@ -25,6 +25,7 @@
 #include "volumes.h"
 #include "disk-io.h"
 #include "utils.h"
+#include "task-utils.h"
 #include "kernel-lib/raid56.h"
 
 /*
@@ -969,3 +970,71 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
+
+int btrfs_scrub(struct btrfs_fs_info *fs_info, struct task_context *task)
+{
+	u64 bg_nr = 0;
+	struct btrfs_block_group_cache *bg_cache;
+	struct btrfs_scrub_progress scrub_ctx = {0};
+	int ret = 0;
+
+	ASSERT(fs_info);
+
+	bg_cache = btrfs_lookup_first_block_group(fs_info, 0);
+	if (!bg_cache) {
+		error("no block group is found");
+		return -ENOENT;
+	}
+	++bg_nr;
+
+	if (task) {
+		/* get block group numbers for progress */
+		while (1) {
+			u64 bg_offset = bg_cache->key.objectid +
+				bg_cache->key.offset;
+			bg_cache = btrfs_lookup_first_block_group(fs_info,
+								  bg_offset);
+			if (!bg_cache)
+				break;
+			++bg_nr;
+		}
+		task->all = bg_nr;
+		task->cur = 1;
+		task_start(task->info);
+
+		bg_cache = btrfs_lookup_first_block_group(fs_info, 0);
+	}
+
+	while (1) {
+		ret = scrub_one_block_group(fs_info, &scrub_ctx, bg_cache);
+		if (ret < 0 && ret != -EIO)
+			break;
+		if (task)
+			task->cur++;
+
+		bg_cache = btrfs_lookup_first_block_group(fs_info,
+				bg_cache->key.objectid + bg_cache->key.offset);
+		if (!bg_cache)
+			break;
+	}
+
+	if (task)
+		task_stop(task->info);
+
+	printf("Scrub result:\n");
+	printf("Tree bytes scrubbed: %llu\n", scrub_ctx.tree_bytes_scrubbed);
+	printf("Tree extents scrubbed: %llu\n", scrub_ctx.tree_extents_scrubbed);
+	printf("Data bytes scrubbed: %llu\n", scrub_ctx.data_bytes_scrubbed);
+	printf("Data extents scrubbed: %llu\n", scrub_ctx.data_extents_scrubbed);
+	printf("Data bytes without csum: %llu\n", scrub_ctx.csum_discards *
+			fs_info->tree_root->sectorsize);
+	printf("Read error: %llu\n", scrub_ctx.read_errors);
+	printf("Verify error: %llu\n", scrub_ctx.verify_errors);
+	printf("Csum error: %llu\n", scrub_ctx.csum_errors);
+	if (scrub_ctx.csum_errors || scrub_ctx.read_errors ||
+	    scrub_ctx.uncorrectable_errors || scrub_ctx.verify_errors)
+		ret = 1;
+	else
+		ret = 0;
+	return ret;
+}
diff --git a/utils.h b/utils.h
index 24d0a200..574dccef 100644
--- a/utils.h
+++ b/utils.h
@@ -167,4 +167,10 @@ u64 rand_u64(void);
 unsigned int rand_range(unsigned int upper);
 void init_rand_seed(u64 seed);
 
+struct task_context {
+	u64 cur;
+	u64 all;
+	struct task_info *info;
+};
+
 #endif
-- 
2.12.1



