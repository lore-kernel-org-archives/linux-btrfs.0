Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:62917 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757895Ab2EPQu7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 May 2012 12:50:59 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by ysabell.rzone.de (Postfix) with ESMTP id 36F0CB23
	for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2012 18:50:58 +0200 (MEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/3] Btrfs-progs: add command to get/reset device stats via ioctl
Date: Wed, 16 May 2012 18:50:58 +0200
Message-Id: <1337187058-560-4-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1337187058-560-1-git-send-email-sbehrens@giantdisaster.de>
References: <1337187058-560-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"btrfs device stats" is used to retrieve and print the device stats.
"btrfs device stats -z" is used to atomically retrieve, reset and
print the stats.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-device.c  |  113 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ctree.h        |    6 +++
 ioctl.h        |   27 ++++++++++++++
 man/btrfs.8.in |   14 +++++++
 print-tree.c   |    6 +++
 5 files changed, 166 insertions(+)

diff --git a/cmds-device.c b/cmds-device.c
index db625a6..3417f03 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -246,11 +246,124 @@ static int cmd_scan_dev(int argc, char **argv)
 	return 0;
 }
 
+static const char * const cmd_dev_stats_usage[] = {
+	"btrfs device stats [-z] <path>|<device>",
+	"Show current device IO stats. -z to reset stats afterwards.",
+	NULL
+};
+
+static int cmd_dev_stats(int argc, char **argv)
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
+				BTRFS_IOC_GET_AND_RESET_DEVICE_STATS == cmd ?
+				 "BTRFS_IOC_GET_AND_RESET_DEVICE_STATS" :
+				 "BTRFS_IOC_GET_DEVICE_STATS",
+				path, strerror(errno));
+			err = 1;
+		} else {
+			if (args.nr_items >= 1)
+				printf("[%s].cnt_write_io_errs   %llu\n",
+				       path, (unsigned long long)
+					     args.cnt_write_io_errs);
+			if (args.nr_items >= 2)
+				printf("[%s].cnt_read_io_errs    %llu\n",
+				       path, (unsigned long long)
+					     args.cnt_read_io_errs);
+			if (args.nr_items >= 3)
+				printf("[%s].cnt_flush_io_errs   %llu\n",
+				       path, (unsigned long long)
+					     args.cnt_flush_io_errs);
+			if (args.nr_items >= 4)
+				printf("[%s].cnt_corruption_errs %llu\n",
+				       path, (unsigned long long)
+					     args.cnt_corruption_errs);
+			if (args.nr_items >= 5)
+				printf("[%s].cnt_generation_errs %llu\n",
+				       path, (unsigned long long)
+					     args.cnt_generation_errs);
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
+
 const struct cmd_group device_cmd_group = {
 	device_cmd_group_usage, NULL, {
 		{ "add", cmd_add_dev, cmd_add_dev_usage, NULL, 0 },
 		{ "delete", cmd_rm_dev, cmd_rm_dev_usage, NULL, 0 },
 		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
+		{ "stats", cmd_dev_stats, cmd_dev_stats_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
 	}
 };
diff --git a/ctree.h b/ctree.h
index 6545c50..db0de5e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -943,6 +943,12 @@ struct btrfs_root {
 #define BTRFS_BALANCE_ITEM_KEY	248
 
 /*
+ * Persistantly stores the io stats in the device tree.
+ * One key for all stats, (0, BTRFS_DEVICE_STATS_KEY, devid).
+ */
+#define BTRFS_DEVICE_STATS_KEY	249
+
+/*
  * string items are for debugging.  They just store a short string of
  * data in the FS
  */
diff --git a/ioctl.h b/ioctl.h
index f2e5d8d..f7b58dd 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -272,6 +272,29 @@ struct btrfs_ioctl_logical_ino_args {
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
@@ -330,5 +353,9 @@ struct btrfs_ioctl_logical_ino_args {
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
 					struct btrfs_ioctl_ino_path_args)
+#define BTRFS_IOC_GET_DEVICE_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
+					 struct btrfs_ioctl_get_device_stats)
+#define BTRFS_IOC_GET_AND_RESET_DEVICE_STATS _IOWR(BTRFS_IOCTL_MAGIC, 53, \
+					 struct btrfs_ioctl_get_device_stats)
 
 #endif
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index be478e0..c903fee 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -35,6 +35,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice show\fP\fI [--all-devices|<uuid>|<label>]\fP
 .PP
+\fBbtrfs\fP \fBdevice stats\fP [-z] {\fI<path>\fP|\fI<device>\fP}
+.PP
 \fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
 .PP
 \fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
@@ -214,6 +216,18 @@ Balance the chunks of the filesystem identified by \fI<path>\fR
 across the devices.
 .TP
 
+\fBdevice stats\fP [-z] {\fI<path>\fP|\fI<device>\fP}
+Read and print the device IO stats for all devices of the filesystem
+identified by \fI<path>\fR or for a single \fI<device>\fR.
+
+.RS
+\fIOptions\fR
+.TP
+.B -z
+Reset stats to zero after reading them.
+.RE
+.TP
+
 \fBdevice add\fR\fI <dev> [<dev>..] <path>\fR
 Add device(s) to the filesystem identified by \fI<path>\fR.
 .TP
diff --git a/print-tree.c b/print-tree.c
index fc134c0..7520601 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -357,6 +357,9 @@ static void print_key_type(u8 type)
 	case BTRFS_STRING_ITEM_KEY:
 		printf("STRING_ITEM");
 		break;
+	case BTRFS_DEVICE_STATS_KEY:
+		printf("DEVICE_STATS_ITEM");
+		break;
 	default:
 		printf("UNKNOWN");
 	};
@@ -609,6 +612,9 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			str = l->data + btrfs_item_ptr_offset(l, i);
 			printf("\t\titem data %.*s\n", btrfs_item_size(l, item), str);
 			break;
+		case BTRFS_DEVICE_STATS_KEY:
+			printf("\t\tdevice stats\n");
+			break;
 		};
 		fflush(stdout);
 	}
-- 
1.7.10.2

