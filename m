From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] Btrfs-progs: add command to get/reset device stats via ioctl
Date: Fri,  9 Dec 2011 17:40:03 +0100
Message-ID: <a25131138df35856fa143b9ddce746e47f147b2e.1323448579.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

"btrfs device stats" is used to retrieve and print the device stats.
"btrfs device stats -z" is used atomically retrieve, reset and print
the stats.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 Makefile     |    4 +-
 btrfs.c      |    5 ++
 btrfs_cmds.c |   67 +++++++++++++++++++++++++++++
 btrfs_cmds.h |    5 ++
 ctree.h      |    6 +++
 devstats.c   |  131 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.h      |   28 ++++++++++++
 print-tree.c |    7 +++
 scrub.c      |   74 +-------------------------------
 9 files changed, 254 insertions(+), 73 deletions(-)

diff --git a/Makefile b/Makefile
index eeb92ad..c7ad82b 100644
--- a/Makefile
+++ b/Makefile
@@ -36,8 +36,8 @@ all: version $(progs) manpages
 version:
 	bash version.sh
 
-btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o
-	$(CC) $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
+btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o devstats.o
+	$(CC) $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o devstats.o \
 		$(objects) $(LDFLAGS) $(LIBS) -lpthread
 
 calc-size: $(objects) calc-size.o
diff --git a/btrfs.c b/btrfs.c
index 1def354..078729a 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -159,6 +159,11 @@ static struct Command commands[] = {
 		"filesystem.",
 	  NULL
 	},
+	{ do_device_stats, -1,
+	  "device stats", "[-z] <path>|<device>\n"
+		"Show current device IO stats. -z to reset stats afterwards.",
+	  NULL
+	},
 	{ do_add_volume, -2,
 	  "device add", "<device> [<device>...] <path>\n"
 		"Add a device to a filesystem.",
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index b59e9cb..065e103 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -117,6 +117,73 @@ int open_file_or_dir(const char *fname)
 	return fd;
 }
 
+int get_device_info(int fd, u64 devid,
+		    struct btrfs_ioctl_dev_info_args *di_args)
+{
+	int ret;
+
+	di_args->devid = devid;
+	memset(&di_args->uuid, '\0', sizeof(di_args->uuid));
+
+	ret = ioctl(fd, BTRFS_IOC_DEV_INFO, di_args);
+	return ret ? -errno : 0;
+}
+
+int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
+		struct btrfs_ioctl_dev_info_args **di_ret)
+{
+	int ret = 0;
+	int ndevs = 0;
+	int i = 1;
+	struct btrfs_fs_devices *fs_devices_mnt = NULL;
+	struct btrfs_ioctl_dev_info_args *di_args;
+	char mp[BTRFS_PATH_NAME_MAX + 1];
+
+	memset(fi_args, 0, sizeof(*fi_args));
+
+	ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
+	if (ret && (errno == EINVAL || errno == ENOTTY)) {
+		/* path is not a mounted btrfs. Try if it's a device */
+		ret = check_mounted_where(fd, path, mp, sizeof(mp),
+					  &fs_devices_mnt);
+		if (!ret)
+			return -EINVAL;
+		if (ret < 0)
+			return ret;
+		fi_args->num_devices = 1;
+		fi_args->max_id = fs_devices_mnt->latest_devid;
+		i = fs_devices_mnt->latest_devid;
+		memcpy(fi_args->fsid, fs_devices_mnt->fsid, BTRFS_FSID_SIZE);
+		close(fd);
+		fd = open_file_or_dir(mp);
+		if (fd < 0)
+			return -errno;
+	} else if (ret) {
+		return -errno;
+	}
+
+	if (!fi_args->num_devices)
+		return 0;
+
+	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
+	if (!di_args)
+		return -errno;
+
+	for (; i <= fi_args->max_id; ++i) {
+		BUG_ON(ndevs >= fi_args->num_devices);
+		ret = get_device_info(fd, i, &di_args[ndevs]);
+		if (ret == -ENODEV)
+			continue;
+		if (ret)
+			return ret;
+		ndevs++;
+	}
+
+	BUG_ON(ndevs == 0);
+
+	return 0;
+}
+
 static u64 parse_size(char *s)
 {
 	int len = strlen(s);
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 81182b1..6be9cc5 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -41,4 +41,9 @@ int do_change_label(int argc, char **argv);
 int open_file_or_dir(const char *fname);
 int do_ino_to_path(int nargs, char **argv);
 int do_logical_to_ino(int nargs, char **argv);
+int do_device_stats(int nargs, char **argv);
+int get_device_info(int fd, u64 devid,
+		    struct btrfs_ioctl_dev_info_args *di_args);
+int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
+		struct btrfs_ioctl_dev_info_args **di_ret);
 char *path_for_root(int fd, u64 root);
diff --git a/ctree.h b/ctree.h
index 54748c8..12a0603 100644
--- a/ctree.h
+++ b/ctree.h
@@ -912,6 +912,12 @@ struct btrfs_root {
 #define BTRFS_CHUNK_ITEM_KEY	228
 
 /*
+ * Persistantly stores the io stats in the device tree.
+ * One key for all stats, (0, BTRFS_DEVICE_STATS_KEY, devid).
+ */
+#define BTRFS_DEVICE_STATS_KEY	248
+
+/*
  * string items are for debugging.  They just store a short string of
  * data in the FS
  */
diff --git a/devstats.c b/devstats.c
new file mode 100644
index 0000000..ae517ae
--- /dev/null
+++ b/devstats.c
@@ -0,0 +1,131 @@
+/*
+ * Copyright (C) STRATO AG 2011.  All rights reserved.
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
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+#include "ctree.h"
+#include "ioctl.h"
+#include "btrfs_cmds.h"
+#include "utils.h"
+#include "volumes.h"
+#include "disk-io.h"
+
+
+int do_device_stats(int argc, char **argv)
+{
+	char *path;
+	struct btrfs_ioctl_fs_info_args fi_args;
+	struct btrfs_ioctl_dev_info_args *di_args = NULL;
+	int ret;
+	int fdmnt;
+	int i;
+	char c;
+	int fdres = -1;
+	int err = 0;
+	int cmd = BTRFS_IOC_GET_DEVICE_STATS;
+
+	optind = 1;
+	while ((c = getopt(argc, argv, "z")) != -1) {
+		switch (c) {
+		case 'z':
+			cmd = BTRFS_IOC_GET_AND_RESET_DEVICE_STATS;
+			break;
+		case '?':
+		default:
+			fprintf(stderr, "ERROR: device stat args invalid.\n"
+					" device stat [-z] <path>|<device>\n"
+					" -z  to reset stats after reading.\n");
+			return 1;
+		}
+	}
+
+	if (optind + 1 != argc) {
+		fprintf(stderr, "ERROR: device stat needs path|device as single"
+			" argument\n");
+		return 1;
+	}
+
+	path = argv[optind];
+
+	fdmnt = open_file_or_dir(path);
+	if (fdmnt < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = get_fs_info(fdmnt, path, &fi_args, &di_args);
+	if (ret) {
+		fprintf(stderr, "ERROR: getting dev info for devstats failed: "
+				"%s\n", strerror(-ret));
+		err = 1;
+		goto out;
+	}
+	if (!fi_args.num_devices) {
+		fprintf(stderr, "ERROR: no devices found\n");
+		err = 1;
+		goto out;
+	}
+
+	printf("num_devices=%llu\n", (unsigned long long)fi_args.num_devices);
+	for (i = 0; i < fi_args.num_devices; i++) {
+		struct btrfs_ioctl_get_device_stats args = {0};
+		__u8 path[BTRFS_DEVICE_PATH_NAME_MAX + 1];
+
+		strncpy((char *)path, (char *)di_args[i].path,
+			BTRFS_DEVICE_PATH_NAME_MAX);
+		path[BTRFS_DEVICE_PATH_NAME_MAX] = '\0';
+
+		args.devid = di_args[i].devid;
+		args.nr_items = BTRFS_IOCTL_GET_DEVICE_STATS_MAX_NR_ITEMS;
+
+		if (ioctl(fdmnt, cmd, &args) < 0) {
+			fprintf(stderr, "ERROR: ioctl(%s) on %s failed: %s\n",
+			        BTRFS_IOC_GET_AND_RESET_DEVICE_STATS == cmd ?
+			         "BTRFS_IOC_GET_AND_RESET_DEVICE_STATS" :
+			         "BTRFS_IOC_GET_DEVICE_STATS",
+			        path, strerror(errno));
+			err = 1;
+		} else {
+			if (args.nr_items >= 1) 
+				printf("[%s].cnt_write_io_errs   %llu\n",
+				       path, args.cnt_write_io_errs);
+			if (args.nr_items >= 2) 
+				printf("[%s].cnt_read_io_errs    %llu\n",
+				       path, args.cnt_read_io_errs);
+			if (args.nr_items >= 3) 
+				printf("[%s].cnt_flush_io_errs   %llu\n",
+				       path, args.cnt_flush_io_errs);
+			if (args.nr_items >= 4) 
+				printf("[%s].cnt_corruption_errs %llu\n",
+				       path, args.cnt_corruption_errs);
+			if (args.nr_items >= 5) 
+				printf("[%s].cnt_generation_errs %llu\n",
+				       path, args.cnt_generation_errs);
+		}
+	}
+
+out:
+	free(di_args);
+	close(fdmnt);
+	if (fdres > -1)
+		close(fdres);
+
+	return err;
+}
diff --git a/ioctl.h b/ioctl.h
index 1ae7537..340eccc 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -224,6 +224,29 @@ struct btrfs_ioctl_logical_ino_args {
 	__u64				inodes;
 };
 
+#define BTRFS_IOCTL_GET_DEVICE_STATS_MAX_NR_ITEMS	5
+struct btrfs_ioctl_get_device_stats {
+	__u64 devid;				/* in */
+	__u64 nr_items;				/* in/out */
+
+	/* out values: */
+
+	/* disk I/O failure stats */
+	__u64 cnt_write_io_errs; /* EIO or EREMOTEIO from lower layers */
+	__u64 cnt_read_io_errs; /* EIO or EREMOTEIO from lower layers */
+	__u64 cnt_flush_io_errs; /* EIO or EREMOTEIO from lower layers */
+
+	/* stats for indirect indications for I/O failures */
+	__u64 cnt_corruption_errs; /* checksum error, bytenr error or
+				    * contents is illegal: this is an
+				    * indication that the block was damaged
+				    * during read or write, or written to
+				    * wrong location or read from wrong
+				    * location */
+	__u64 cnt_generation_errs; /* an indication that blocks have not
+				    * been written */
+};
+
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
@@ -277,5 +300,10 @@ struct btrfs_ioctl_logical_ino_args {
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
 					struct btrfs_ioctl_ino_path_args)
+#define BTRFS_IOC_GET_DEVICE_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
+					 struct btrfs_ioctl_get_device_stats)
+#define BTRFS_IOC_GET_AND_RESET_DEVICE_STATS _IOWR(BTRFS_IOCTL_MAGIC, 53, \
+					 struct btrfs_ioctl_get_device_stats)
+
 
 #endif
diff --git a/print-tree.c b/print-tree.c
index 6039699..58178af 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -354,6 +354,9 @@ static void print_key_type(u8 type)
 	case BTRFS_STRING_ITEM_KEY:
 		printf("STRING_ITEM");
 		break;
+	case BTRFS_DEVICE_STATS_KEY:
+		printf("DEVICE_STATS_ITEM");
+		break;
 	default:
 		printf("UNKNOWN");
 	};
@@ -603,6 +606,10 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			str = l->data + btrfs_item_ptr_offset(l, i);
 			printf("\t\titem data %.*s\n", btrfs_item_size(l, item), str);
 			break;
+
+		case BTRFS_DEVICE_STATS_KEY:
+			printf("\t\tdevice stats\n");
+			break;
 		};
 		fflush(stdout);
 	}
diff --git a/scrub.c b/scrub.c
index 9dca5f6..ab3dc96 100644
--- a/scrub.c
+++ b/scrub.c
@@ -961,74 +961,6 @@ static struct scrub_file_record *last_dev_scrub(
 	return NULL;
 }
 
-static int scrub_device_info(int fd, u64 devid,
-			     struct btrfs_ioctl_dev_info_args *di_args)
-{
-	int ret;
-
-	di_args->devid = devid;
-	memset(&di_args->uuid, '\0', sizeof(di_args->uuid));
-
-	ret = ioctl(fd, BTRFS_IOC_DEV_INFO, di_args);
-	return ret ? -errno : 0;
-}
-
-static int scrub_fs_info(int fd, char *path,
-				struct btrfs_ioctl_fs_info_args *fi_args,
-				struct btrfs_ioctl_dev_info_args **di_ret)
-{
-	int ret = 0;
-	int ndevs = 0;
-	int i = 1;
-	struct btrfs_fs_devices *fs_devices_mnt = NULL;
-	struct btrfs_ioctl_dev_info_args *di_args;
-	char mp[BTRFS_PATH_NAME_MAX + 1];
-
-	memset(fi_args, 0, sizeof(*fi_args));
-
-	ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
-	if (ret && errno == EINVAL) {
-		/* path is no mounted btrfs. try if it's a device */
-		ret = check_mounted_where(fd, path, mp, sizeof(mp),
-						&fs_devices_mnt);
-		if (!ret)
-			return -EINVAL;
-		if (ret < 0)
-			return ret;
-		fi_args->num_devices = 1;
-		fi_args->max_id = fs_devices_mnt->latest_devid;
-		i = fs_devices_mnt->latest_devid;
-		memcpy(fi_args->fsid, fs_devices_mnt->fsid, BTRFS_FSID_SIZE);
-		close(fd);
-		fd = open_file_or_dir(mp);
-		if (fd < 0)
-			return -errno;
-	} else if (ret) {
-		return -errno;
-	}
-
-	if (!fi_args->num_devices)
-		return 0;
-
-	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
-	if (!di_args)
-		return -errno;
-
-	for (; i <= fi_args->max_id; ++i) {
-		BUG_ON(ndevs >= fi_args->num_devices);
-		ret = scrub_device_info(fd, i, &di_args[ndevs]);
-		if (ret == -ENODEV)
-			continue;
-		if (ret)
-			return ret;
-		++ndevs;
-	}
-
-	BUG_ON(ndevs == 0);
-
-	return 0;
-}
-
 int mkdir_p(char *path)
 {
 	int i;
@@ -1151,7 +1083,7 @@ static int scrub_start(int argc, char **argv, int resume)
 		return 12;
 	}
 
-	ret = scrub_fs_info(fdmnt, path, &fi_args, &di_args);
+	ret = get_fs_info(fdmnt, path, &fi_args, &di_args);
 	if (ret) {
 		ERR(!do_quiet, "ERROR: getting dev info for scrub failed: "
 		    "%s\n", strerror(-ret));
@@ -1543,7 +1475,6 @@ int do_scrub_status(int argc, char **argv)
 	int ret;
 	int fdmnt;
 	int i;
-	optind = 1;
 	int print_raw = 0;
 	int do_stats_per_dev = 0;
 	char c;
@@ -1551,6 +1482,7 @@ int do_scrub_status(int argc, char **argv)
 	int fdres = -1;
 	int err = 0;
 
+	optind = 1;
 	while ((c = getopt(argc, argv, "dR")) != -1) {
 		switch (c) {
 		case 'd':
@@ -1581,7 +1513,7 @@ int do_scrub_status(int argc, char **argv)
 		return 12;
 	}
 
-	ret = scrub_fs_info(fdmnt, path, &fi_args, &di_args);
+	ret = get_fs_info(fdmnt, path, &fi_args, &di_args);
 	if (ret) {
 		fprintf(stderr, "ERROR: getting dev info for scrub failed: "
 				"%s\n", strerror(-ret));
-- 
1.7.3.4

