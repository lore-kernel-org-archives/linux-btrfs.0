Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9331 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932920AbbI1OAA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 10:00:00 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8SDxZx7005925
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 21:59:36 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v3 2/2] btrfs-progs: use common warning/error for cmds-scrub.c
Date: Mon, 28 Sep 2015 21:58:14 +0800
Message-ID: <5e813636f201c95addb0793a1386bc4c55c7fe03.1443448527.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1443448527.git.zhaolei@cn.fujitsu.com>
References: <cover.1443448527.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use common warning/error functions in cmds-scrub.c, it can make
message format unified and make code simple.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-scrub.c | 176 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 87 insertions(+), 89 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index f2611a0..19eaa93 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -128,11 +128,6 @@ static void print_scrub_full(struct btrfs_scrub_progress *sp)
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
@@ -461,7 +456,7 @@ static int scrub_kvread(int *i, int len, int avail, const char *buf,
 
 #define _SCRUB_INVALID do {						\
 	if (report_errors)						\
-		fprintf(stderr, "WARNING: invalid data in line %d pos "	\
+		warning("invalid data in line %d pos "			\
 			"%d state %d (near \"%.*s\") at %s:%d\n",	\
 			lineno, i, state, 20 > avail ? avail : 20,	\
 			l + i,	__FILE__, __LINE__);			\
@@ -848,8 +843,7 @@ static void *scrub_one_dev(void *ctx)
 		      IOPRIO_PRIO_VALUE(sp->ioprio_class,
 					sp->ioprio_classdata));
 	if (ret)
-		fprintf(stderr,
-			"WARNING: setting ioprio failed: %s (ignored).\n",
+		warning("setting ioprio failed: %s (ignored).\n",
 			strerror(errno));
 
 	ret = ioctl(sp->fd, BTRFS_IOC_SCRUB, &sp->scrub_args);
@@ -1195,9 +1189,9 @@ static int scrub_start(int argc, char **argv, int resume)
 		do_print = 0;
 
 	if (mkdir_p(datafile)) {
-		ERR(!do_quiet, "WARNING: cannot create scrub data "
-			       "file, mkdir %s failed: %s. Status recording "
-			       "disabled\n", datafile, strerror(errno));
+		warning_on(!do_quiet,
+			   "cannot create scrub data file, mkdir %s failed: %s. Status recording disabled\n",
+			   datafile, strerror(errno));
 		do_record = 0;
 	}
 	free(datafile);
@@ -1208,24 +1202,27 @@ static int scrub_start(int argc, char **argv, int resume)
 
 	if (fdmnt < 0) {
 		if (errno == EINVAL)
-			ERR(!do_quiet,
-			    "ERROR: '%s' is not a mounted btrfs device\n",
-			    path);
+			error_on(!do_quiet,
+				 "'%s' is not a mounted btrfs device\n",
+				 path);
 		else
-			ERR(!do_quiet, "ERROR: can't access '%s': %s\n",
-			    path, strerror(errno));
+			error_on(!do_quiet,
+				 "can't access '%s': %s\n",
+				 path, strerror(errno));
 		return 1;
 	}
 
 	ret = get_fs_info(path, &fi_args, &di_args);
 	if (ret) {
-		ERR(!do_quiet, "ERROR: getting dev info for scrub failed: "
-		    "%s\n", strerror(-ret));
+		error_on(!do_quiet,
+			 "getting dev info for scrub failed: %s\n",
+			 strerror(-ret));
 		err = 1;
 		goto out;
 	}
 	if (!fi_args.num_devices) {
-		ERR(!do_quiet, "ERROR: no devices found\n");
+		error_on(!do_quiet,
+			 "no devices found\n");
 		err = 1;
 		goto out;
 	}
@@ -1233,13 +1230,15 @@ static int scrub_start(int argc, char **argv, int resume)
 	uuid_unparse(fi_args.fsid, fsid);
 	fdres = scrub_open_file_r(SCRUB_DATA_FILE, fsid);
 	if (fdres < 0 && fdres != -ENOENT) {
-		ERR(!do_quiet, "WARNING: failed to open status file: "
-		    "%s\n", strerror(-fdres));
+		warning_on(!do_quiet,
+			   "failed to open status file: %s\n",
+			   strerror(-fdres));
 	} else if (fdres >= 0) {
 		past_scrubs = scrub_read_file(fdres, !do_quiet);
 		if (IS_ERR(past_scrubs))
-			ERR(!do_quiet, "WARNING: failed to read status file: "
-			    "%s\n", strerror(-PTR_ERR(past_scrubs)));
+			warning_on(!do_quiet,
+				   "failed to read status file: %s\n",
+				   strerror(-PTR_ERR(past_scrubs)));
 		close(fdres);
 	}
 
@@ -1262,11 +1261,11 @@ static int scrub_start(int argc, char **argv, int resume)
 	 * single devices, there is no reason to prevent this.
 	 */
 	if (!force && is_scrub_running_on_fs(&fi_args, di_args, past_scrubs)) {
-		ERR(!do_quiet,
-		    "ERROR: scrub is already running.\n"
-		    "To cancel use 'btrfs scrub cancel %s'.\n"
-		    "To see the status use 'btrfs scrub status [-d] %s'.\n",
-		    path, path);
+		error_on(!do_quiet,
+			 "scrub is already running.\n"
+			 "To cancel use 'btrfs scrub cancel %s'.\n"
+			 "To see the status use 'btrfs scrub status [-d] %s'.\n",
+			 path, path);
 		err = 1;
 		goto out;
 	}
@@ -1276,7 +1275,8 @@ static int scrub_start(int argc, char **argv, int resume)
 	spc.progress = calloc(fi_args.num_devices * 2, sizeof(*spc.progress));
 
 	if (!t_devs || !sp || !spc.progress) {
-		ERR(!do_quiet, "ERROR: scrub failed: %s", strerror(errno));
+		error_on(!do_quiet,
+			 "scrub failed: %s", strerror(errno));
 		err = 1;
 		goto out;
 	}
@@ -1285,8 +1285,8 @@ static int scrub_start(int argc, char **argv, int resume)
 		devid = di_args[i].devid;
 		ret = pthread_mutex_init(&sp[i].progress_mutex, NULL);
 		if (ret) {
-			ERR(!do_quiet, "ERROR: pthread_mutex_init failed: "
-			    "%s\n", strerror(ret));
+			error_on(!do_quiet, "pthread_mutex_init failed: %s\n",
+				 strerror(ret));
 			err = 1;
 			goto out;
 		}
@@ -1340,7 +1340,7 @@ static int scrub_start(int argc, char **argv, int resume)
 		ret = connect(prg_fd, (struct sockaddr *)&addr, sizeof(addr));
 		if (!ret || errno != ECONNREFUSED) {
 			/* ... yes, so scrub must be running. error out */
-			fprintf(stderr, "ERROR: scrub already running\n");
+			error("scrub already running\n");
 			close(prg_fd);
 			prg_fd = -1;
 			goto out;
@@ -1354,10 +1354,10 @@ static int scrub_start(int argc, char **argv, int resume)
 	if (ret != -1)
 		ret = listen(prg_fd, 100);
 	if (ret == -1) {
-		ERR(!do_quiet, "WARNING: failed to open the progress status "
-		    "socket at %s: %s. Progress cannot be queried\n",
-		    sock_path[0] ? sock_path : SCRUB_PROGRESS_SOCKET_PATH,
-		    strerror(errno));
+		warning_on(!do_quiet,
+			   "failed to open the progress status socket at %s: %s. Progress cannot be queried\n",
+			   sock_path[0] ? sock_path :
+			   SCRUB_PROGRESS_SOCKET_PATH, strerror(errno));
 		if (prg_fd != -1) {
 			close(prg_fd);
 			prg_fd = -1;
@@ -1371,9 +1371,9 @@ static int scrub_start(int argc, char **argv, int resume)
 		ret = scrub_write_progress(&spc_write_mutex, fsid, sp,
 					   fi_args.num_devices);
 		if (ret) {
-			ERR(!do_quiet, "WARNING: failed to write the progress "
-			    "status file: %s. Status recording disabled\n",
-			    strerror(-ret));
+			warning_on(!do_quiet,
+				   "failed to write the progress status file: %s. Status recording disabled\n",
+				   strerror(-ret));
 			do_record = 0;
 		}
 	}
@@ -1381,8 +1381,9 @@ static int scrub_start(int argc, char **argv, int resume)
 	if (do_background) {
 		pid = fork();
 		if (pid == -1) {
-			ERR(!do_quiet, "ERROR: cannot scrub, fork failed: "
-					"%s\n", strerror(errno));
+			error_on(!do_quiet,
+				 "cannot scrub, fork failed: %s\n",
+				 strerror(errno));
 			err = 1;
 			goto out;
 		}
@@ -1400,13 +1401,15 @@ static int scrub_start(int argc, char **argv, int resume)
 			}
 			ret = wait(&stat);
 			if (ret != pid) {
-				ERR(!do_quiet, "ERROR: wait failed: (ret=%d) "
-				    "%s\n", ret, strerror(errno));
+				error_on(!do_quiet,
+					 "wait failed: (ret=%d) %s\n",
+					 ret, strerror(errno));
 				err = 1;
 				goto out;
 			}
 			if (!WIFEXITED(stat) || WEXITSTATUS(stat)) {
-				ERR(!do_quiet, "ERROR: scrub process failed\n");
+				error_on(!do_quiet,
+					 "scrub process failed\n");
 				err = WIFEXITED(stat) ? WEXITSTATUS(stat) : -1;
 				goto out;
 			}
@@ -1432,9 +1435,8 @@ static int scrub_start(int argc, char **argv, int resume)
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
@@ -1449,8 +1451,8 @@ static int scrub_start(int argc, char **argv, int resume)
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
@@ -1463,9 +1465,8 @@ static int scrub_start(int argc, char **argv, int resume)
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
@@ -1473,20 +1474,18 @@ static int scrub_start(int argc, char **argv, int resume)
 			switch (sp[i].ioctl_errno) {
 			case ENODEV:
 				if (do_print)
-					fprintf(stderr,
-					    "WARNING: device %lld not present\n",
-					    devid);
+					warning("device %lld not present\n",
+						devid);
 				continue;
 			case ECANCELED:
 				++err;
 				break;
 			default:
 				if (do_print)
-					fprintf(stderr,
-	"ERROR: scrubbing %s failed for device id %lld: ret=%d, errno=%d (%s)\n",
-						path, devid,
-						sp[i].ret, sp[i].ioctl_errno,
-						strerror(sp[i].ioctl_errno));
+					error("scrubbing %s failed for device id %lld: ret=%d, errno=%d (%s)\n",
+					      path, devid,
+					      sp[i].ret, sp[i].ioctl_errno,
+					      strerror(sp[i].ioctl_errno));
 				++err;
 				continue;
 			}
@@ -1528,22 +1527,22 @@ static int scrub_start(int argc, char **argv, int resume)
 
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
 
@@ -1567,11 +1566,12 @@ out:
 	if (nothing_to_resume)
 		return 2;
 	if (e_uncorrectable) {
-		ERR(!do_quiet, "ERROR: There are uncorrectable errors.\n");
+		error_on(!do_quiet, "There are uncorrectable errors.\n");
 		return 3;
 	}
 	if (e_correctable)
-		ERR(!do_quiet, "WARNING: errors detected during scrubbing, corrected.\n");
+		warning_on(!do_quiet,
+			   "errors detected during scrubbing, corrected.\n");
 
 	return 0;
 }
@@ -1618,12 +1618,11 @@ static int cmd_scrub_cancel(int argc, char **argv)
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
@@ -1631,8 +1630,9 @@ static int cmd_scrub_cancel(int argc, char **argv)
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
@@ -1723,24 +1723,23 @@ static int cmd_scrub_status(int argc, char **argv)
 
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
@@ -1749,9 +1748,8 @@ static int cmd_scrub_status(int argc, char **argv)
 
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
@@ -1764,8 +1762,8 @@ static int cmd_scrub_status(int argc, char **argv)
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
@@ -1774,7 +1772,7 @@ static int cmd_scrub_status(int argc, char **argv)
 	if (fdres >= 0) {
 		past_scrubs = scrub_read_file(fdres, 1);
 		if (IS_ERR(past_scrubs))
-			fprintf(stderr, "WARNING: failed to read status: %s\n",
+			warning("failed to read status: %s\n",
 				strerror(-PTR_ERR(past_scrubs)));
 	}
 	in_progress = is_scrub_running_in_kernel(fdmnt, di_args, fi_args.num_devices);
-- 
1.8.5.1

