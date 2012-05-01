From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH v2 1/5] btrfs: add command to zero out superblock
Date: Tue,  1 May 2012 14:40:29 +0200
Message-ID: <1335876033-12201-1-git-send-email-kario@wit.edu.pl>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Hubert Kario <kario@wit.edu.pl>

diff --git a/cmds-device.c b/cmds-device.c
index db625a6..05a549c 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -246,11 +246,58 @@ static int cmd_scan_dev(int argc, char **argv)
 	return 0;
 }
 
+static const char * const cmd_zero_dev_usage[] = {
+	"btrfs device zero-superblock <device> [<device> ...]",
+	"Remove btrfs filesystem superblock from devices.",
+	"WARNING! This command will make filesystem residing on the devices",
+	"completely unmountable!",
+	NULL
+};
+
+static int cmd_zero_dev(int argc, char **argv)
+{
+	int fd;
+	char *file;
+	int arg_processed;
+	int ret = 0;
+	int n;
+	u64 device_len;
+	int mixed_mode_needed = 1; /* keep btrfs_prepare_device() quiet */
+	const int ZERO_END = 1;
+
+	if( argc < 2 ) {
+		usage(cmd_zero_dev_usage);
+	}
+
+	for(arg_processed = 1; arg_processed < argc; arg_processed++) {
+		file = argv[arg_processed];
+
+		fd = open(file, O_RDWR);
+		if (fd < 0) {
+			fprintf(stderr, "Unable to open %s\n", file);
+			ret |= 1;
+			continue;
+		}
+
+		n = btrfs_prepare_device(fd, file, ZERO_END, &device_len,
+			&mixed_mode_needed);
+		if (n) {
+			fprintf(stderr, "Error when zeroing out %s\n", file);
+			ret |= n;
+		}
+
+		close(fd);
+	}
+
+	return ret;
+}
+
 const struct cmd_group device_cmd_group = {
 	device_cmd_group_usage, NULL, {
 		{ "add", cmd_add_dev, cmd_add_dev_usage, NULL, 0 },
 		{ "delete", cmd_rm_dev, cmd_rm_dev_usage, NULL, 0 },
 		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
+		{ "zero-superblock", cmd_zero_dev, cmd_zero_dev_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
 	}
 };
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index be478e0..a840f7e 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -39,6 +39,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
 .PP
+\fBbtrfs\fP \fBdevice zero-superblock\fP\fI <device> [<device>...] \fP
+.PP
 \fBbtrfs\fP \fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
 .PP
 \fBbtrfs\fP \fBscrub cancel\fP {\fI<path>\fP|\fI<device>\fP}
@@ -230,6 +232,11 @@ Finally, if \fB--all-devices\fP is passed, all the devices under /dev are
 scanned.
 .TP
 
+\fBdevice zero-superblock\fR\fI <dev> [<dev>..]\fR
+The space on the disk where btrfs metadata can reside is overwritten with
+zeros.
+.TP
+
 \fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
 Start a scrub on all devices of the filesystem identified by \fI<path>\fR or on
 a single \fI<device>\fR. Without options, scrub is started as a background
-- 
1.7.10

