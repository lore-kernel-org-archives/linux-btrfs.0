Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10968 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750892AbbHQPLI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Aug 2015 11:11:08 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7HFB1pb025142
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2015 23:11:01 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: Introduce warning() and error() for common use
Date: Mon, 17 Aug 2015 23:09:28 +0800
Message-ID: <5383bdc400123fe513ca6774c07803f7b14f4a3e.1439824137.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current code use fprintf(stderr, "...") to output warnning and
error information.

The error message have different style, as:
 # grep fprintf *.c
 fprintf(stderr, "Open ctree failed\n");
 fprintf(stderr, "%s: open ctree failed\n", __func__);
 fprintf(stderr, "ERROR: cannot open ctree\n");
 ...

And sometimes, we forgot add tailed '\n', or use printf instead:
 printf("warning, device %llu is missing\n",

This patch introduce warning() and error() as common function,
to make:
1: Each warning and error information have same format
2: Easy to search/change all error message
3: Easy to modify function's internal for debug or other requirement,
   as:
   print function/linenumber in error()
   dumpstack in error()
   add some trace for some style of message
   add support for -v, -vv, ...
   ...something is joke, just for example...

Converting all source is a big work, this patch convert cmds-scrub.c
I'll convert others these days, and new code can use these function
directly.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-scrub.c | 171 +++++++++++++++++++++++++++++------------------------------
 utils.c      |  20 +++++++
 utils.h      |  12 +++++
 3 files changed, 117 insertions(+), 86 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 5a85dc4..c971b2e 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -127,11 +127,6 @@ static void print_scrub_full(struct btrfs_scrub_progress *sp)
 	printf("\tlast_physical: %lld\n", sp->last_physical);
 }
 
-#define ERR(test, ...) do {			\
-	if (test)				\
-		fprintf(stderr, __VA_ARGS__);	\
-} while (0)
-
 #define PRINT_SCRUB_ERROR(test, desc) do {	\
 	if (test)				\
 		printf(" %s=%llu", desc, test);	\
@@ -462,7 +457,7 @@ static int scrub_kvread(int *i, int len, int avail, const char *buf,
 
 #define _SCRUB_INVALID do {						\
 	if (report_errors)						\
-		fprintf(stderr, "WARNING: invalid data in line %d pos "	\
+		warning("invalid data in line %d pos "			\
 			"%d state %d (near \"%.*s\") at %s:%d\n",	\
 			lineno, i, state, 20 > avail ? avail : 20,	\
 			l + i,	__FILE__, __LINE__);			\
@@ -839,8 +834,7 @@ static void *scrub_one_dev(void *ctx)
 		      IOPRIO_PRIO_VALUE(sp->ioprio_class,
 					sp->ioprio_classdata));
 	if (ret)
-		fprintf(stderr,
-			"WARNING: setting ioprio failed: %s (ignored).\n",
+		warning("setting ioprio failed: %s (ignored).\n",
 			strerror(errno));
 
 	ret = ioctl(sp->fd, BTRFS_IOC_SCRUB, &sp->scrub_args);
@@ -1186,9 +1180,9 @@ static int scrub_start(int argc, char **argv, int resume)
 		do_print = 0;
 
 	if (mkdir_p(datafile)) {
-		ERR(!do_quiet, "WARNING: cannot create scrub data "
-			       "file, mkdir %s failed: %s. Status recording "
-			       "disabled\n", datafile, strerror(errno));
+		warningon(!do_quiet,
+			  "cannot create scrub data file, mkdir %s failed: %s. Status recording disabled\n",
+			  datafile, strerror(errno));
 		do_record = 0;
 	}
 	free(datafile);
@@ -1199,24 +1193,27 @@ static int scrub_start(int argc, char **argv, int resume)
 
 	if (fdmnt < 0) {
 		if (errno == EINVAL)
-			ERR(!do_quiet,
-			    "ERROR: '%s' is not a mounted btrfs device\n",
-			    path);
+			erroron(!do_quiet,
+				"'%s' is not a mounted btrfs device\n",
+				path);
 		else
-			ERR(!do_quiet, "ERROR: can't access '%s': %s\n",
-			    path, strerror(errno));
+			erroron(!do_quiet,
+				"can't access '%s': %s\n",
+				path, strerror(errno));
 		return 1;
 	}
 
 	ret = get_fs_info(path, &fi_args, &di_args);
 	if (ret) {
-		ERR(!do_quiet, "ERROR: getting dev info for scrub failed: "
-		    "%s\n", strerror(-ret));
+		erroron(!do_quiet,
+			"getting dev info for scrub failed: %s\n",
+			strerror(-ret));
 		err = 1;
 		goto out;
 	}
 	if (!fi_args.num_devices) {
-		ERR(!do_quiet, "ERROR: no devices found\n");
+		erroron(!do_quiet,
+			"no devices found\n");
 		err = 1;
 		goto out;
 	}
@@ -1224,13 +1221,15 @@ static int scrub_start(int argc, char **argv, int resume)
 	uuid_unparse(fi_args.fsid, fsid);
 	fdres = scrub_open_file_r(SCRUB_DATA_FILE, fsid);
 	if (fdres < 0 && fdres != -ENOENT) {
-		ERR(!do_quiet, "WARNING: failed to open status file: "
-		    "%s\n", strerror(-fdres));
+		warningon(!do_quiet,
+			  "failed to open status file: %s\n",
+			  strerror(-fdres));
 	} else if (fdres >= 0) {
 		past_scrubs = scrub_read_file(fdres, !do_quiet);
 		if (IS_ERR(past_scrubs))
-			ERR(!do_quiet, "WARNING: failed to read status file: "
-			    "%s\n", strerror(-PTR_ERR(past_scrubs)));
+			warningon(!do_quiet,
+				  "failed to read status file: %s\n",
+				  strerror(-PTR_ERR(past_scrubs)));
 		close(fdres);
 	}
 
@@ -1253,11 +1252,11 @@ static int scrub_start(int argc, char **argv, int resume)
 	 * single devices, there is no reason to prevent this.
 	 */
 	if (!force && is_scrub_running_on_fs(&fi_args, di_args, past_scrubs)) {
-		ERR(!do_quiet,
-		    "ERROR: scrub is already running.\n"
-		    "To cancel use 'btrfs scrub cancel %s'.\n"
-		    "To see the status use 'btrfs scrub status [-d] %s'.\n",
-		    path, path);
+		erroron(!do_quiet,
+			"scrub is already running.\n"
+			"To cancel use 'btrfs scrub cancel %s'.\n"
+			"To see the status use 'btrfs scrub status [-d] %s'.\n",
+			path, path);
 		err = 1;
 		goto out;
 	}
@@ -1267,7 +1266,8 @@ static int scrub_start(int argc, char **argv, int resume)
 	spc.progress = calloc(fi_args.num_devices * 2, sizeof(*spc.progress));
 
 	if (!t_devs || !sp || !spc.progress) {
-		ERR(!do_quiet, "ERROR: scrub failed: %s", strerror(errno));
+		erroron(!do_quiet,
+			"scrub failed: %s", strerror(errno));
 		err = 1;
 		goto out;
 	}
@@ -1276,8 +1276,8 @@ static int scrub_start(int argc, char **argv, int resume)
 		devid = di_args[i].devid;
 		ret = pthread_mutex_init(&sp[i].progress_mutex, NULL);
 		if (ret) {
-			ERR(!do_quiet, "ERROR: pthread_mutex_init failed: "
-			    "%s\n", strerror(ret));
+			erroron(!do_quiet, "pthread_mutex_init failed: %s\n",
+				strerror(ret));
 			err = 1;
 			goto out;
 		}
@@ -1331,7 +1331,7 @@ static int scrub_start(int argc, char **argv, int resume)
 		ret = connect(prg_fd, (struct sockaddr *)&addr, sizeof(addr));
 		if (!ret || errno != ECONNREFUSED) {
 			/* ... yes, so scrub must be running. error out */
-			fprintf(stderr, "ERROR: scrub already running\n");
+			error("scrub already running\n");
 			close(prg_fd);
 			prg_fd = -1;
 			goto out;
@@ -1345,10 +1345,10 @@ static int scrub_start(int argc, char **argv, int resume)
 	if (ret != -1)
 		ret = listen(prg_fd, 100);
 	if (ret == -1) {
-		ERR(!do_quiet, "WARNING: failed to open the progress status "
-		    "socket at %s: %s. Progress cannot be queried\n",
-		    sock_path[0] ? sock_path : SCRUB_PROGRESS_SOCKET_PATH,
-		    strerror(errno));
+		warningon(!do_quiet,
+			  "failed to open the progress status socket at %s: %s. Progress cannot be queried\n",
+			  sock_path[0] ? sock_path : SCRUB_PROGRESS_SOCKET_PATH,
+			  strerror(errno));
 		if (prg_fd != -1) {
 			close(prg_fd);
 			prg_fd = -1;
@@ -1362,9 +1362,9 @@ static int scrub_start(int argc, char **argv, int resume)
 		ret = scrub_write_progress(&spc_write_mutex, fsid, sp,
 					   fi_args.num_devices);
 		if (ret) {
-			ERR(!do_quiet, "WARNING: failed to write the progress "
-			    "status file: %s. Status recording disabled\n",
-			    strerror(-ret));
+			warningon(!do_quiet,
+				  "failed to write the progress status file: %s. Status recording disabled\n",
+				  strerror(-ret));
 			do_record = 0;
 		}
 	}
@@ -1372,8 +1372,9 @@ static int scrub_start(int argc, char **argv, int resume)
 	if (do_background) {
 		pid = fork();
 		if (pid == -1) {
-			ERR(!do_quiet, "ERROR: cannot scrub, fork failed: "
-					"%s\n", strerror(errno));
+			erroron(!do_quiet,
+				"cannot scrub, fork failed: %s\n",
+				strerror(errno));
 			err = 1;
 			goto out;
 		}
@@ -1391,13 +1392,15 @@ static int scrub_start(int argc, char **argv, int resume)
 			}
 			ret = wait(&stat);
 			if (ret != pid) {
-				ERR(!do_quiet, "ERROR: wait failed: (ret=%d) "
-				    "%s\n", ret, strerror(errno));
+				erroron(!do_quiet,
+					"wait failed: (ret=%d) %s\n",
+					ret, strerror(errno));
 				err = 1;
 				goto out;
 			}
 			if (!WIFEXITED(stat) || WEXITSTATUS(stat)) {
-				ERR(!do_quiet, "ERROR: scrub process failed\n");
+				erroron(!do_quiet,
+					"scrub process failed\n");
 				err = WIFEXITED(stat) ? WEXITSTATUS(stat) : -1;
 				goto out;
 			}
@@ -1423,9 +1426,8 @@ static int scrub_start(int argc, char **argv, int resume)
 					scrub_one_dev, &sp[i]);
 		if (ret) {
 			if (do_print)
-				fprintf(stderr, "ERROR: creating "
-					"scrub_one_dev[%llu] thread failed: "
-					"%s\n", devid, strerror(ret));
+				error("creating scrub_one_dev[%llu] thread failed: %s\n",
+				      devid, strerror(ret));
 			err = 1;
 			goto out;
 		}
@@ -1440,8 +1442,8 @@ static int scrub_start(int argc, char **argv, int resume)
 	ret = pthread_create(&t_prog, NULL, scrub_progress_cycle, &spc);
 	if (ret) {
 		if (do_print)
-			fprintf(stderr, "ERROR: creating progress thread "
-				"failed: %s\n", strerror(ret));
+			error("creating progress thread failed: %s\n",
+			      strerror(ret));
 		err = 1;
 		goto out;
 	}
@@ -1454,25 +1456,23 @@ static int scrub_start(int argc, char **argv, int resume)
 		ret = pthread_join(t_devs[i], NULL);
 		if (ret) {
 			if (do_print)
-				fprintf(stderr, "ERROR: pthread_join failed "
-					"for scrub_one_dev[%llu]: %s\n", devid,
-					strerror(ret));
+				error("pthread_join failed for scrub_one_dev[%llu]: %s\n",
+				      devid, strerror(ret));
 			++err;
 			continue;
 		}
 		if (sp[i].ret && sp[i].ioctl_errno == ENODEV) {
 			if (do_print)
-				fprintf(stderr, "WARNING: device %lld not "
-					"present\n", devid);
+				warning("device %lld not present\n",
+					devid);
 			continue;
 		}
 		if (sp[i].ret && sp[i].ioctl_errno == ECANCELED) {
 			++err;
 		} else if (sp[i].ret) {
 			if (do_print)
-				fprintf(stderr, "ERROR: scrubbing %s failed "
-					"for device id %lld (%s)\n", path,
-					devid, strerror(sp[i].ioctl_errno));
+				error("scrubbing %s failed for device id %lld (%s)\n",
+				      path, devid, strerror(sp[i].ioctl_errno));
 			++err;
 			continue;
 		}
@@ -1513,22 +1513,22 @@ static int scrub_start(int argc, char **argv, int resume)
 
 	/* check for errors from the handling of the progress thread */
 	if (do_print && ret) {
-		fprintf(stderr, "ERROR: progress thread handling failed: %s\n",
-			strerror(ret));
+		error("progress thread handling failed: %s\n",
+		      strerror(ret));
 	}
 
 	/* check for errors returned from the progress thread itself */
 	if (do_print && terr && terr != PTHREAD_CANCELED) {
-		fprintf(stderr, "ERROR: recording progress "
-			"failed: %s\n", strerror(-PTR_ERR(terr)));
+		error("recording progress failed: %s\n",
+		      strerror(-PTR_ERR(terr)));
 	}
 
 	if (do_record) {
 		ret = scrub_write_progress(&spc_write_mutex, fsid, sp,
 					   fi_args.num_devices);
 		if (ret && do_print) {
-			fprintf(stderr, "ERROR: failed to record the result: "
-				"%s\n", strerror(-ret));
+			error("failed to record the result: %s\n",
+			      strerror(-ret));
 		}
 	}
 
@@ -1552,11 +1552,12 @@ out:
 	if (nothing_to_resume)
 		return 2;
 	if (e_uncorrectable) {
-		ERR(!do_quiet, "ERROR: There are uncorrectable errors.\n");
+		erroron(!do_quiet, "There are uncorrectable errors.\n");
 		return 3;
 	}
 	if (e_correctable)
-		ERR(!do_quiet, "WARNING: errors detected during scrubbing, corrected.\n");
+		warningon(!do_quiet,
+			  "errors detected during scrubbing, corrected.\n");
 
 	return 0;
 }
@@ -1603,12 +1604,11 @@ static int cmd_scrub_cancel(int argc, char **argv)
 	fdmnt = open_path_or_dev_mnt(path, &dirstream);
 	if (fdmnt < 0) {
 		if (errno == EINVAL)
-			fprintf(stderr,
-				"ERROR: '%s' is not a mounted btrfs device\n",
-				path);
+			error("'%s' is not a mounted btrfs device\n",
+			      path);
 		else
-			fprintf(stderr, "ERROR: can't access '%s': %s\n",
-				path, strerror(errno));
+			error("can't access '%s': %s\n",
+			      path, strerror(errno));
 		ret = 1;
 		goto out;
 	}
@@ -1616,8 +1616,9 @@ static int cmd_scrub_cancel(int argc, char **argv)
 	ret = ioctl(fdmnt, BTRFS_IOC_SCRUB_CANCEL, NULL);
 
 	if (ret < 0) {
-		fprintf(stderr, "ERROR: scrub cancel failed on %s: %s\n", path,
-			errno == ENOTCONN ? "not running" : strerror(errno));
+		error("scrub cancel failed on %s: %s\n",
+		      path,
+		      errno == ENOTCONN ? "not running" : strerror(errno));
 		if (errno == ENOTCONN)
 			ret = 2;
 		else
@@ -1708,24 +1709,23 @@ static int cmd_scrub_status(int argc, char **argv)
 
 	if (fdmnt < 0) {
 		if (errno == EINVAL)
-			fprintf(stderr,
-				"ERROR: '%s' is not a mounted btrfs device\n",
-				path);
+			error("'%s' is not a mounted btrfs device\n",
+			      path);
 		else
-			fprintf(stderr, "ERROR: can't access '%s': %s\n",
-				path, strerror(errno));
+			error("can't access '%s': %s\n",
+			      path, strerror(errno));
 		return 1;
 	}
 
 	ret = get_fs_info(path, &fi_args, &di_args);
 	if (ret) {
-		fprintf(stderr, "ERROR: getting dev info for scrub failed: "
-				"%s\n", strerror(-ret));
+		error("getting dev info for scrub failed: %s\n",
+		      strerror(-ret));
 		err = 1;
 		goto out;
 	}
 	if (!fi_args.num_devices) {
-		fprintf(stderr, "ERROR: no devices found\n");
+		error("no devices found\n");
 		err = 1;
 		goto out;
 	}
@@ -1734,9 +1734,8 @@ static int cmd_scrub_status(int argc, char **argv)
 
 	fdres = socket(AF_UNIX, SOCK_STREAM, 0);
 	if (fdres == -1) {
-		fprintf(stderr, "ERROR: failed to create socket to "
-			"receive progress information: %s\n",
-			strerror(errno));
+		error("failed to create socket to receive progress information: %s\n",
+		      strerror(errno));
 		err = 1;
 		goto out;
 	}
@@ -1749,8 +1748,8 @@ static int cmd_scrub_status(int argc, char **argv)
 		close(fdres);
 		fdres = scrub_open_file_r(SCRUB_DATA_FILE, fsid);
 		if (fdres < 0 && fdres != -ENOENT) {
-			fprintf(stderr, "WARNING: failed to open status file: "
-				"%s\n", strerror(-fdres));
+			warning("failed to open status file: %s\n",
+				strerror(-fdres));
 			err = 1;
 			goto out;
 		}
@@ -1759,7 +1758,7 @@ static int cmd_scrub_status(int argc, char **argv)
 	if (fdres >= 0) {
 		past_scrubs = scrub_read_file(fdres, 1);
 		if (IS_ERR(past_scrubs))
-			fprintf(stderr, "WARNING: failed to read status: %s\n",
+			warning("failed to read status: %s\n",
 				strerror(-PTR_ERR(past_scrubs)));
 	}
 	in_progress = is_scrub_running_in_kernel(fdmnt, di_args, fi_args.num_devices);
diff --git a/utils.c b/utils.c
index 280637d..a1198b6 100644
--- a/utils.c
+++ b/utils.c
@@ -20,6 +20,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <stdarg.h>
 #include <sys/ioctl.h>
 #include <sys/mount.h>
 #include <sys/types.h>
@@ -2890,3 +2891,22 @@ int arg_copy_path(char *dest, const char *src, int destlen)
 
 	return 0;
 }
+
+void warning(const char *fmt, ...)
+{
+	va_list args;
+	va_start(args, fmt);
+	fprintf(stderr, "WARNING: ");
+	vfprintf(stderr, fmt, args);
+	va_end(args);
+}
+
+void error(const char *fmt, ...)
+{
+	va_list args;
+	va_start(args, fmt);
+	fprintf(stderr, "ERROR: ");
+	vfprintf(stderr, fmt, args);
+	va_end(args);
+}
+
diff --git a/utils.h b/utils.h
index 94606ed..8ec23c9 100644
--- a/utils.h
+++ b/utils.h
@@ -244,4 +244,16 @@ int btrfs_check_nodesize(u32 nodesize, u32 sectorsize);
 
 const char *get_argv0_buf(void);
 
+void warning(const char *fmt, ...);
+void error(const char *fmt, ...);
+#define warningon(test, ...) do {	\
+	if (test)			\
+		warning(__VA_ARGS__);	\
+} while (0)
+
+#define erroron(test, ...) do {		\
+	if (test)			\
+		error(__VA_ARGS__);	\
+} while (0)
+
 #endif
-- 
1.8.5.1

