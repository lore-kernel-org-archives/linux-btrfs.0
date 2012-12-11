Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:22503 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab2LKQuD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 11:50:03 -0500
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp4) (RZmta 31.8 OK)
	with ESMTP id 6068e9oBBBseMF for <linux-btrfs@vger.kernel.org>;
	Tue, 11 Dec 2012 17:50:00 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs-progs: add support for device replace procedure
Date: Tue, 11 Dec 2012 17:50:00 +0100
Message-Id: <3344706e9c44b0dbfaf2e74aa60c1185fa193721.1355244128.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the user mode part of the device replace patch series.

The command group "btrfs replace" is added with three commands:
- btrfs replace start srcdev|srcdevid targetdev [-Bfr] mount_point
- btrfs replace status mount_point [-1]
- btrfs replace cancel mount_point

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---

Changes v1 -> v2:
- The only change is that the parameters to "btrfs replace start"
  are reordered as suggested by users.

The patch depends on two patches that I have sent long time ago
and that Goffredo and partially also Anand have resend some weeks ago:
"Move scrub_fs_info() and scrub_dev_info() in utils.c", the old name
was: "Btrfs-progs: make two utility functions globally available", and
"Move open_file_or_dir() in utils.c", the old name was:
"Btrfs-progs: move open_file_or_dir() to utils.c".

 Makefile       |   2 +-
 btrfs.c        |   1 +
 cmds-replace.c | 579 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 commands.h     |   2 +
 ctree.h        |  12 ++
 ioctl.h        |  44 +++++
 man/btrfs.8.in |  54 ++++++
 print-tree.c   |   3 +
 volumes.c      |  16 ++
 volumes.h      |   2 +
 10 files changed, 714 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 25ac6d6..3275284 100644
--- a/Makefile
+++ b/Makefile
@@ -6,7 +6,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
 	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
-	       cmds-inspect.o cmds-balance.o
+	       cmds-inspect.o cmds-balance.o cmds-replace.o
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
diff --git a/btrfs.c b/btrfs.c
index 88238d6..cc602e4 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -246,6 +246,7 @@ const struct cmd_group btrfs_cmd_group = {
 		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
 		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
 		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
+		{ "replace", cmd_replace, NULL, &replace_cmd_group, 0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
diff --git a/cmds-replace.c b/cmds-replace.c
new file mode 100644
index 0000000..4d8239d
--- /dev/null
+++ b/cmds-replace.c
@@ -0,0 +1,579 @@
+/*
+ * Copyright (C) 2012 STRATO.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+#include <sys/stat.h>
+#include <time.h>
+#include <assert.h>
+#include <inttypes.h>
+#include <sys/wait.h>
+
+#include "kerncompat.h"
+#include "ctree.h"
+#include "ioctl.h"
+#include "utils.h"
+#include "volumes.h"
+#include "disk-io.h"
+
+#include "commands.h"
+
+
+static int print_replace_status(int fd, const char *path, int once);
+static char *time2string(char *buf, size_t s, __u64 t);
+static char *progress2string(char *buf, size_t s, int progress_1000);
+
+
+static const char *replace_dev_result2string(__u64 result)
+{
+	switch (result) {
+	case BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR:
+		return "no error";
+	case BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED:
+		return "not started";
+	case BTRFS_IOCTL_DEV_REPLACE_RESULT_ALREADY_STARTED:
+		return "already started";
+	default:
+		return "<illegal result value>";
+	}
+}
+
+static const char * const replace_cmd_group_usage[] = {
+	"btrfs replace <command> [<args>]",
+	NULL
+};
+
+static int is_numerical(const char *str)
+{
+	if (!(*str >= '0' && *str <= '9'))
+		return 0;
+	while (*str >= '0' && *str <= '9')
+		str++;
+	if (*str != '\0')
+		return 0;
+	return 1;
+}
+
+static int dev_replace_cancel_fd = -1;
+static void dev_replace_sigint_handler(int signal)
+{
+	struct btrfs_ioctl_dev_replace_args args = {0};
+
+	args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_CANCEL;
+	ioctl(dev_replace_cancel_fd, BTRFS_IOC_DEV_REPLACE, &args);
+}
+
+static int dev_replace_handle_sigint(int fd)
+{
+	struct sigaction sa = {
+		.sa_handler = fd == -1 ? SIG_DFL : dev_replace_sigint_handler
+	};
+
+	dev_replace_cancel_fd = fd;
+	return sigaction(SIGINT, &sa, NULL);
+}
+
+static const char *const cmd_start_replace_usage[] = {
+	"btrfs replace start srcdev|devid targetdev [-Bfr] mount_point",
+	"Replace device of a btrfs filesystem.",
+	"On a live filesystem, duplicate the data to the target device which",
+	"is currently stored on the source device. If the source device is not",
+	"available anymore, or if the -r option is set, the data is built",
+	"only using the RAID redundancy mechanisms. After completion of the",
+	"operation, the source device is removed from the filesystem.",
+	"If the srcdev is a numerical value, it is assumed to be the device id",
+	"of the filesystem which is mounted at mount_point, otherwise it is",
+	"the path to the source device. If the source device is disconnected,",
+	"from the system, you have to use the devid parameter format.",
+	"The targetdev needs to be same size or larger than the srcdev.",
+	"",
+	"-r     only read from srcdev if no other zero-defect mirror exists",
+	"       (enable this if your drive has lots of read errors, the access",
+	"       would be very slow)",
+	"-f     force using and overwriting targetdev even if it looks like",
+	"       containing a valid btrfs filesystem. A valid filesystem is",
+	"       assumed if a btrfs superblock is found which contains a",
+	"       correct checksum. Devices which are currently mounted are",
+	"       never allowed to be used as the targetdev",
+	"-B     do not background",
+	NULL
+};
+
+static int cmd_start_replace(int argc, char **argv)
+{
+	struct btrfs_ioctl_dev_replace_args start_args = {0};
+	struct btrfs_ioctl_dev_replace_args status_args = {0};
+	int ret;
+	int i;
+	int c;
+	int fdmnt = -1;
+	int fdsrcdev = -1;
+	int fddstdev = -1;
+	char *path;
+	char *srcdev;
+	char *dstdev;
+	int avoid_reading_from_srcdev = 0;
+	int force_using_targetdev = 0;
+	u64 total_devs = 1;
+	struct btrfs_fs_devices *fs_devices_mnt = NULL;
+	struct stat st;
+	u64 dstdev_block_count;
+	int do_not_background = 0;
+	int mixed = 0;
+
+	while ((c = getopt(argc, argv, "Brf")) != -1) {
+		switch (c) {
+		case 'B':
+			do_not_background = 1;
+			break;
+		case 'r':
+			avoid_reading_from_srcdev = 1;
+			break;
+		case 'f':
+			force_using_targetdev = 1;
+			break;
+		case '?':
+		default:
+			usage(cmd_start_replace_usage);
+		}
+	}
+
+	start_args.start.cont_reading_from_srcdev_mode =
+		avoid_reading_from_srcdev ?
+		 BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID :
+		 BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_ALWAYS;
+	if (check_argc_exact(argc - optind, 3))
+		usage(cmd_start_replace_usage);
+	path = argv[optind + 2];
+	fdmnt = open_file_or_dir(path);
+	if (fdmnt < 0) {
+		fprintf(stderr, "ERROR: can't access \"%s\": %s\n",
+			path, strerror(errno));
+		goto leave_with_error;
+	}
+
+	/* check for possible errors before backgrounding */
+	status_args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_STATUS;
+	ret = ioctl(fdmnt, BTRFS_IOC_DEV_REPLACE, &status_args);
+	if (ret) {
+		fprintf(stderr,
+			"ERROR: ioctl(DEV_REPLACE_STATUS) failed on \"%s\": %s, %s\n",
+			path, strerror(errno),
+			replace_dev_result2string(status_args.result));
+		goto leave_with_error;
+	}
+
+	if (status_args.result != BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR) {
+		fprintf(stderr,
+			"ERROR: ioctl(DEV_REPLACE_STATUS) on \"%s\" returns error: %s\n",
+			path, replace_dev_result2string(status_args.result));
+		goto leave_with_error;
+	}
+
+	if (status_args.status.replace_state ==
+	    BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED) {
+		fprintf(stderr,
+			"ERROR: btrfs replace on \"%s\" already started!\n",
+			path);
+		goto leave_with_error;
+	}
+
+	srcdev = argv[optind];
+	dstdev = argv[optind + 1];
+
+	if (is_numerical(srcdev)) {
+		struct btrfs_ioctl_fs_info_args fi_args;
+		struct btrfs_ioctl_dev_info_args *di_args = NULL;
+
+		if (atoi(srcdev) == 0) {
+			fprintf(stderr, "Error: Failed to parse the numerical devid value '%s'\n",
+				srcdev);
+			goto leave_with_error;
+		}
+		start_args.start.srcdevid = (__u64)atoi(srcdev);
+
+		ret = get_fs_info(fdmnt, path, &fi_args, &di_args);
+		if (ret) {
+			fprintf(stderr, "ERROR: getting dev info for devstats failed: "
+					"%s\n", strerror(-ret));
+			free(di_args);
+			goto leave_with_error;
+		}
+		if (!fi_args.num_devices) {
+			fprintf(stderr, "ERROR: no devices found\n");
+			free(di_args);
+			goto leave_with_error;
+		}
+
+		for (i = 0; i < fi_args.num_devices; i++)
+			if (start_args.start.srcdevid == di_args[i].devid)
+				break;
+		if (i == fi_args.num_devices) {
+			fprintf(stderr, "Error: '%s' is not a valid devid for filesystem '%s'\n",
+				srcdev, path);
+			goto leave_with_error;
+		}
+	} else {
+		fdsrcdev = open(srcdev, O_RDWR);
+		if (!fdsrcdev) {
+			fprintf(stderr, "Error: Unable to open device '%s'\n",
+				srcdev);
+			goto leave_with_error;
+		}
+		ret = fstat(fdsrcdev, &st);
+		if (ret) {
+			fprintf(stderr, "Error: Unable to stat '%s'\n", srcdev);
+			goto leave_with_error;
+		}
+		if (!S_ISBLK(st.st_mode)) {
+			fprintf(stderr, "Error: '%s' is not a block device\n",
+				srcdev);
+			goto leave_with_error;
+		}
+		strncpy((char *)start_args.start.srcdev_name, srcdev,
+			BTRFS_PATH_NAME_MAX);
+		close(fdsrcdev);
+		fdsrcdev = -1;
+		start_args.start.srcdevid = 0;
+	}
+
+	ret = check_mounted(dstdev);
+	if (ret < 0) {
+		fprintf(stderr, "Error checking %s mount status\n", dstdev);
+		goto leave_with_error;
+	}
+	if (ret == 1) {
+		fprintf(stderr,
+			"Error, target device %s is in use and currently mounted!\n",
+			dstdev);
+		goto leave_with_error;
+	}
+	fddstdev = open(dstdev, O_RDWR);
+	if (fddstdev < 0) {
+		fprintf(stderr, "Unable to open %s\n", dstdev);
+		goto leave_with_error;
+	}
+	ret = btrfs_scan_one_device(fddstdev, dstdev, &fs_devices_mnt,
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+	if (ret >= 0 && !force_using_targetdev) {
+		fprintf(stderr,
+			"Error, target device %s contains filesystem, use '-f' to force overwriting.\n",
+			dstdev);
+		goto leave_with_error;
+	}
+	ret = fstat(fddstdev, &st);
+	if (ret) {
+		fprintf(stderr, "Error: Unable to stat '%s'\n", dstdev);
+		goto leave_with_error;
+	}
+	if (!S_ISBLK(st.st_mode)) {
+		fprintf(stderr, "Error: '%s' is not a block device\n", dstdev);
+		goto leave_with_error;
+	}
+	strncpy((char *)start_args.start.tgtdev_name, dstdev,
+		BTRFS_PATH_NAME_MAX);
+	if (btrfs_prepare_device(fddstdev, dstdev, 1, &dstdev_block_count,
+				 &mixed)) {
+		fprintf(stderr, "Error: Failed to prepare device '%s'\n",
+			dstdev);
+		goto leave_with_error;
+	}
+	close(fddstdev);
+	fddstdev = -1;
+
+	dev_replace_handle_sigint(fdmnt);
+	if (!do_not_background) {
+		if (daemon(0, 0) < 0) {
+			fprintf(stderr, "ERROR, backgrounding failed: %s\n",
+				strerror(errno));
+			goto leave_with_error;
+		}
+	}
+
+	start_args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_START;
+	ret = ioctl(fdmnt, BTRFS_IOC_DEV_REPLACE, &start_args);
+	if (do_not_background) {
+		if (ret) {
+			fprintf(stderr,
+				"ERROR: ioctl(DEV_REPLACE_START) failed on \"%s\": %s, %s\n",
+				path, strerror(errno),
+				replace_dev_result2string(start_args.result));
+			goto leave_with_error;
+		}
+
+		if (start_args.result !=
+		    BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR) {
+			fprintf(stderr,
+				"ERROR: ioctl(DEV_REPLACE_START) on \"%s\" returns error: %s\n",
+				path,
+				replace_dev_result2string(start_args.result));
+			goto leave_with_error;
+		}
+	}
+	close(fdmnt);
+	return 0;
+
+leave_with_error:
+	if (fdmnt != -1)
+		close(fdmnt);
+	if (fdsrcdev != -1)
+		close(fdsrcdev);
+	if (fddstdev != -1)
+		close(fddstdev);
+	return -1;
+}
+
+static const char *const cmd_status_replace_usage[] = {
+	"btrfs replace status mount_point [-1]",
+	"Print status and progress information of a running device replace",
+	"operation",
+	"",
+	"-1     print once instead of print continously until the replace",
+	"       operation finishes (or is canceled)",
+	NULL
+};
+
+static int cmd_status_replace(int argc, char **argv)
+{
+	int fd;
+	int e;
+	int c;
+	char *path;
+	int once = 0;
+	int ret;
+
+	while ((c = getopt(argc, argv, "1")) != -1) {
+		switch (c) {
+		case '1':
+			once = 1;
+			break;
+		case '?':
+		default:
+			usage(cmd_status_replace_usage);
+		}
+	}
+
+	if (check_argc_exact(argc - optind, 1))
+		usage(cmd_status_replace_usage);
+
+	path = argv[optind];
+	fd = open_file_or_dir(path);
+	e = errno;
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access \"%s\": %s\n",
+			path, strerror(e));
+		return -1;
+	}
+
+	ret = print_replace_status(fd, path, once);
+	close(fd);
+	return ret;
+}
+
+static int print_replace_status(int fd, const char *path, int once)
+{
+	struct btrfs_ioctl_dev_replace_args args = {0};
+	struct btrfs_ioctl_dev_replace_status_params *status;
+	int ret;
+	int prevent_loop = 0;
+	int skip_stats;
+	int num_chars;
+	char string1[80];
+	char string2[80];
+	char string3[80];
+
+	for (;;) {
+		args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_STATUS;
+		ret = ioctl(fd, BTRFS_IOC_DEV_REPLACE, &args);
+		if (ret) {
+			fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_STATUS) failed on \"%s\": %s, %s\n",
+				path, strerror(errno),
+				replace_dev_result2string(args.result));
+			return ret;
+		}
+
+		status = &args.status;
+		if (args.result != BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR) {
+			fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_STATUS) on \"%s\" returns error: %s\n",
+				path,
+				replace_dev_result2string(args.result));
+			return -1;
+		}
+
+		skip_stats = 0;
+		num_chars = 0;
+		switch (status->replace_state) {
+		case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
+			num_chars =
+				printf("%s done",
+				       progress2string(string3,
+						       sizeof(string3),
+						       status->progress_1000));
+			break;
+		case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
+			prevent_loop = 1;
+			printf("Started on %s, finished on %s",
+			       time2string(string1, sizeof(string1),
+					   status->time_started),
+			       time2string(string2, sizeof(string2),
+					   status->time_stopped));
+			break;
+		case BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED:
+			prevent_loop = 1;
+			printf("Started on %s, canceled on %s at %s",
+			       time2string(string1, sizeof(string1),
+					   status->time_started),
+			       time2string(string2, sizeof(string2),
+					   status->time_stopped),
+			       progress2string(string3, sizeof(string3),
+					       status->progress_1000));
+			break;
+		case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
+			prevent_loop = 1;
+			printf("Started on %s, suspended on %s at %s",
+			       time2string(string1, sizeof(string1),
+					   status->time_started),
+			       time2string(string2, sizeof(string2),
+					   status->time_stopped),
+			       progress2string(string3, sizeof(string3),
+					       status->progress_1000));
+			break;
+		case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
+			prevent_loop = 1;
+			skip_stats = 1;
+			printf("Never started");
+			break;
+		default:
+			prevent_loop = 1;
+			assert(0);
+			break;
+		}
+
+		if (!skip_stats)
+			num_chars += printf(
+				", %llu write errs, %llu uncorr. read errs",
+				(unsigned long long)status->num_write_errors,
+				(unsigned long long)
+				 status->num_uncorrectable_read_errors);
+		if (once || prevent_loop) {
+			printf("\n");
+			return 0;
+		}
+
+		fflush(stdout);
+		sleep(1);
+		while (num_chars > 0) {
+			putchar('\b');
+			num_chars--;
+		}
+	}
+
+	return 0;
+}
+
+static char *
+time2string(char *buf, size_t s, __u64 t)
+{
+	struct tm t_tm;
+	time_t t_time_t;
+
+	t_time_t = (time_t)t;
+	assert((__u64)t_time_t == t);
+	localtime_r(&t_time_t, &t_tm);
+	strftime(buf, s, "%e.%b %T", &t_tm);
+	return buf;
+}
+
+static char *
+progress2string(char *buf, size_t s, int progress_1000)
+{
+	snprintf(buf, s, "%d.%01d%%", progress_1000 / 10, progress_1000 % 10);
+	assert(s > 0);
+	buf[s - 1] = '\0';
+	return buf;
+}
+
+static const char *const cmd_cancel_replace_usage[] = {
+	"btrfs replace cancel mount_point",
+	"Cancel a running device replace operation.",
+	NULL
+};
+
+static int cmd_cancel_replace(int argc, char **argv)
+{
+	struct btrfs_ioctl_dev_replace_args args = {0};
+	int ret;
+	int c;
+	int fd;
+	int e;
+	char *path;
+
+	while ((c = getopt(argc, argv, "")) != -1) {
+		switch (c) {
+		case '?':
+		default:
+			usage(cmd_cancel_replace_usage);
+		}
+	}
+
+	if (check_argc_exact(argc - optind, 1))
+		usage(cmd_cancel_replace_usage);
+
+	path = argv[optind];
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access \"%s\": %s\n",
+			path, strerror(errno));
+		return -1;
+	}
+
+	args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_CANCEL;
+	ret = ioctl(fd, BTRFS_IOC_DEV_REPLACE, &args);
+	e = errno;
+	close(fd);
+	if (ret) {
+		fprintf(stderr, "ERROR: ioctl(DEV_REPLACE_CANCEL) failed on \"%s\": %s, %s\n",
+			path, strerror(e),
+			replace_dev_result2string(args.result));
+		return ret;
+	}
+
+	return 0;
+}
+
+const struct cmd_group replace_cmd_group = {
+	replace_cmd_group_usage, NULL, {
+		{ "start", cmd_start_replace, cmd_start_replace_usage, NULL,
+		  0 },
+		{ "status", cmd_status_replace, cmd_status_replace_usage, NULL,
+		  0 },
+		{ "cancel", cmd_cancel_replace, cmd_cancel_replace_usage, NULL,
+		  0 },
+		{ 0, 0, 0, 0, 0 }
+	}
+};
+
+int cmd_replace(int argc, char **argv)
+{
+	return handle_command_group(&replace_cmd_group, argc, argv);
+}
diff --git a/commands.h b/commands.h
index aea4cb1..8559168 100644
--- a/commands.h
+++ b/commands.h
@@ -85,6 +85,7 @@ extern const struct cmd_group balance_cmd_group;
 extern const struct cmd_group device_cmd_group;
 extern const struct cmd_group scrub_cmd_group;
 extern const struct cmd_group inspect_cmd_group;
+extern const struct cmd_group replace_cmd_group;
 
 int cmd_subvolume(int argc, char **argv);
 int cmd_filesystem(int argc, char **argv);
@@ -92,3 +93,4 @@ int cmd_balance(int argc, char **argv);
 int cmd_device(int argc, char **argv);
 int cmd_scrub(int argc, char **argv);
 int cmd_inspect(int argc, char **argv);
+int cmd_replace(int argc, char **argv);
diff --git a/ctree.h b/ctree.h
index 86a652d..7e4a7a9 100644
--- a/ctree.h
+++ b/ctree.h
@@ -949,6 +949,18 @@ struct btrfs_root {
 #define BTRFS_DEV_STATS_KEY	249
 
 /*
+ * Persistantly stores the io stats in the device tree.
+ * One key for all stats, (0, BTRFS_DEV_STATS_KEY, devid).
+ */
+#define BTRFS_DEV_STATS_KEY	249
+
+/*
+ * Persistantly stores the device replace state in the device tree.
+ * The key is built like this: (0, BTRFS_DEV_REPLACE_KEY, 0).
+ */
+#define BTRFS_DEV_REPLACE_KEY	250
+
+/*
  * string items are for debugging.  They just store a short string of
  * data in the FS
  */
diff --git a/ioctl.h b/ioctl.h
index 83277c3..77aaf94 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -74,6 +74,48 @@ struct btrfs_ioctl_scrub_args {
 	__u64 unused[(1024-32-sizeof(struct btrfs_scrub_progress))/8];
 };
 
+#define BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_ALWAYS	0
+#define BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID	1
+struct btrfs_ioctl_dev_replace_start_params {
+	__u64 srcdevid;	/* in, if 0, use srcdev_name instead */
+	__u8 srcdev_name[BTRFS_PATH_NAME_MAX + 1];	/* in */
+	__u8 tgtdev_name[BTRFS_PATH_NAME_MAX + 1];	/* in */
+	__u64 cont_reading_from_srcdev_mode;	/* in, see #define
+						 * above */
+};
+
+#define BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED	0
+#define BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED		1
+#define BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED		2
+#define BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED		3
+#define BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED		4
+struct btrfs_ioctl_dev_replace_status_params {
+	__u64 replace_state;	/* out, see #define above */
+	__u64 progress_1000;	/* out, 0 <= x <= 1000 */
+	__u64 time_started;	/* out, seconds since 1-Jan-1970 */
+	__u64 time_stopped;	/* out, seconds since 1-Jan-1970 */
+	__u64 num_write_errors;	/* out */
+	__u64 num_uncorrectable_read_errors;	/* out */
+};
+
+#define BTRFS_IOCTL_DEV_REPLACE_CMD_START			0
+#define BTRFS_IOCTL_DEV_REPLACE_CMD_STATUS			1
+#define BTRFS_IOCTL_DEV_REPLACE_CMD_CANCEL			2
+#define BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR			0
+#define BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED		1
+#define BTRFS_IOCTL_DEV_REPLACE_RESULT_ALREADY_STARTED		2
+struct btrfs_ioctl_dev_replace_args {
+	__u64 cmd;	/* in */
+	__u64 result;	/* out */
+
+	union {
+		struct btrfs_ioctl_dev_replace_start_params start;
+		struct btrfs_ioctl_dev_replace_status_params status;
+	};	/* in/out */
+
+	__u64 spare[64];
+};
+
 #define BTRFS_DEVICE_PATH_NAME_MAX 1024
 struct btrfs_ioctl_dev_info_args {
 	__u64 devid;				/* in/out */
@@ -365,5 +407,7 @@ struct btrfs_ioctl_get_dev_stats {
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
 				      struct btrfs_ioctl_get_dev_stats)
+#define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
+				    struct btrfs_ioctl_dev_replace_args)
 
 #endif
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 5e08468..c28d5cd 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -41,6 +41,12 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
 .PP
+\fBbtrfs\fP \fBreplace start\fP \fI[-Bfr] <srcdev>|<devid> <targetdev> <path>\fP
+.PP
+\fBbtrfs\fP \fBreplace status\fP \fI[-1] <path>\fP
+.PP
+\fBbtrfs\fP \fBreplace cancel\fP \fI<path>\fP
+.PP
 \fBbtrfs\fP \fBscrub start\fP [-Bdqru] [-c ioprio_class -n ioprio_classdata] {\fI<path>\fP|\fI<device>\fP}
 .PP
 \fBbtrfs\fP \fBscrub cancel\fP {\fI<path>\fP|\fI<device>\fP}
@@ -244,6 +250,54 @@ Finally, if \fB--all-devices\fP is passed, all the devices under /dev are
 scanned.
 .TP
 
+\fBreplace start\fR \fI[-Bfr] <srcdev>|<devid> <targetdev> <path>\fR
+Replace device of a btrfs filesystem.
+On a live filesystem, duplicate the data to the target device which
+is currently stored on the source device. If the source device is not
+available anymore, or if the \fB-r\fR option is set, the data is built
+only using the RAID redundancy mechanisms. After completion of the
+operation, the source device is removed from the filesystem.
+If the \fIsrcdev\fR is a numerical value, it is assumed to be the device id
+of the filesystem which is mounted at mount_point, otherwise is is
+the path to the source device. If the source device is disconnected,
+from the system, you have to use the \fIdevid\fR parameter format.
+The targetdev needs to be same size or larger than the \fIsrcdev\fR.
+
+.RS
+\fIOptions\fR
+.TP
+.B -r
+only read from \fIsrcdev\fR if no other zero-defect mirror exists (enable
+this if your drive has lots of read errors, the access would be very slow)
+.TP
+.B -f
+force using and overwriting \fItargetdev\fR even if it looks like
+containing a valid btrfs filesystem. A valid filesystem is
+assumed if a btrfs superblock is found which contains a
+correct checksum. Devices which are currently mounted are
+never allowed to be used as the \fItargetdev\fR
+.TP
+.B -B
+do not background
+.RE
+.TP
+
+\fBreplace status\fR \fI[-1] <path>\fR
+Print status and progress information of a running device replace operation.
+
+.RS
+\fIOptions\fR
+.TP
+.B -1
+print once instead of print continously until the replace
+operation finishes (or is canceled)
+.RE
+.TP
+
+\fBreplace cancel\fR \fI<path>\fR
+Cancel a running device replace operation.
+.TP
+
 \fBscrub start\fP [-Bdqru] [-c ioprio_class -n ioprio_classdata] {\fI<path>\fP|\fI<device>\fP}
 Start a scrub on all devices of the filesystem identified by \fI<path>\fR or on
 a single \fI<device>\fR. Without options, scrub is started as a background
diff --git a/print-tree.c b/print-tree.c
index ff8c5e1..d6e424e 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -354,6 +354,9 @@ static void print_key_type(u8 type)
 	case BTRFS_BALANCE_ITEM_KEY:
 		printf("BALANCE_ITEM");
 		break;
+	case BTRFS_DEV_REPLACE_KEY:
+		printf("DEV_REPLACE_ITEM");
+		break;
 	case BTRFS_STRING_ITEM_KEY:
 		printf("STRING_ITEM");
 		break;
diff --git a/volumes.c b/volumes.c
index 8dca5e1..d57213f 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1217,6 +1217,22 @@ struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 	return NULL;
 }
 
+struct btrfs_device *btrfs_find_device_by_devid(struct btrfs_root *root,
+						u64 devid, int instance)
+{
+	struct list_head *head = &root->fs_info->fs_devices->devices;
+	struct btrfs_device *dev;
+	struct list_head *cur;
+	int num_found = 0;
+
+	list_for_each(cur, head) {
+		dev = list_entry(cur, struct btrfs_device, dev_list);
+		if (dev->devid == devid && num_found++ == instance)
+			return dev;
+	}
+	return NULL;
+}
+
 int btrfs_bootstrap_super_map(struct btrfs_mapping_tree *map_tree,
 			      struct btrfs_fs_devices *fs_devices)
 {
diff --git a/volumes.h b/volumes.h
index 9ff6182..9c08406 100644
--- a/volumes.h
+++ b/volumes.h
@@ -182,4 +182,6 @@ int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, struct btrfs_key *key,
 			   struct btrfs_chunk *chunk, int item_size);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
+struct btrfs_device *btrfs_find_device_by_devid(struct btrfs_root *root,
+                                                u64 devid, int instance);
 #endif
-- 
1.8.0.2

