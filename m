From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v5 1/8] Balance progress monitoring.
Date: Sun, 10 Apr 2011 22:16:27 +0100
Message-ID: <c8b30357982549c03cbe4e1aa9eeb4b3274ad381.1302469689.git.hugo@carfax.org.uk>
References: <cover.1302469689.git.hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1302469689.git.hugo@carfax.org.uk>
In-Reply-To: <cover.1302469689.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces a basic form of progress monitoring for balance
operations, by counting the number of block groups remaining. The
information is exposed to userspace by an ioctl.

We also add "btrfs balance start" as an alias for "btrfs filesystem
balance", so that all balance-related functions are available under
one prefix.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs.c        |    8 +++++++
 btrfs_cmds.c   |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 btrfs_cmds.h   |    1 +
 ioctl.h        |    7 ++++++
 man/btrfs.8.in |   11 ++++++++++
 5 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 46314cf..0b6186c 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -95,6 +95,14 @@ static struct Command commands[] = {
 	  "filesystem balance", "<path>\n"
 		"Balance the chunks across the device."
 	},
+	{ do_balance, 1,
+	  "balance start", "<path>\n"
+		"Synonym for \"btrfs filesystem balance\"."
+	},
+	{ do_balance_progress, -1,
+	  "balance progress", "[-m|--monitor] <path>\n"
+		"Show progress of the balance operation running on <path>."
+	},
 	{ do_scan,
 	  999, "device scan", "[<device> [<device>..]\n"
 		"Scan all device for or the passed device for a btrfs\n"
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..2745d64 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -28,6 +28,7 @@
 #include <limits.h>
 #include <uuid/uuid.h>
 #include <ctype.h>
+#include <getopt.h>
 
 #undef ULONG_MAX
 
@@ -776,6 +777,65 @@ int do_balance(int argc, char **argv)
 	}
 	return 0;
 }
+
+int get_balance_progress(char *path, struct btrfs_ioctl_balance_progress *bal)
+{
+	int fdmnt;
+	int ret = 0;
+	int err = 0;
+
+	fdmnt = open_file_or_dir(path);
+	if(fdmnt < 0) {
+		return -1;
+	}
+
+	ret = ioctl(fdmnt, BTRFS_IOC_BALANCE_PROGRESS, bal);
+	if(ret)
+		err = errno;
+	close(fdmnt);
+
+	return err;
+}
+
+int do_balance_progress(int argc, char **argv)
+{
+	char *path;
+	int ret = 0;
+	int err = 0;
+	struct btrfs_ioctl_balance_progress bal;
+
+	path = argv[1];
+
+	ret = get_balance_progress(path, &bal);
+	if (!ret)
+		printf("\r%llu/%llu block groups moved, "
+		       "%0.2f%% complete.\n",
+		       bal.completed,
+		       bal.expected,
+		       (float)bal.completed/bal.expected*100.0);
+
+	switch(ret) {
+	case 0:
+		break;
+	case -1:
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 13;
+	case EINVAL:
+		if (!monitor) {
+			fprintf(stderr,
+				"No balance operation running on '%s'.\n",
+				path);
+			return 20;
+		}
+		break;
+	default:
+		fprintf(stderr, "ERROR: ioctl returned error %d.", err);
+		return 21;
+	}
+
+	return 0;
+}
+
 int do_remove_volume(int nargs, char **args)
 {
 
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 7bde191..47b0a27 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -23,6 +23,7 @@ int do_defrag(int argc, char **argv);
 int do_show_filesystem(int nargs, char **argv);
 int do_add_volume(int nargs, char **args);
 int do_balance(int nargs, char **argv);
+int do_balance_progress(int nargs, char **argv);
 int do_remove_volume(int nargs, char **args);
 int do_scan(int nargs, char **argv);
 int do_resize(int nargs, char **argv);
diff --git a/ioctl.h b/ioctl.h
index 776d7a9..f07d3a2 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -132,6 +132,11 @@ struct btrfs_ioctl_space_args {
 	struct btrfs_ioctl_space_info spaces[0];
 };
 
+struct btrfs_ioctl_balance_progress {
+	__u32 expected;
+	__u32 completed;
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -169,4 +174,6 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 25, \
+					struct btrfs_ioctl_balance_progress)
 #endif
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 26ef982..5c953ca 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -23,6 +23,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
 .PP
+\fBbtrfs\fP \fBbalance progress\fP\fI <path>\fP
+.PP
 \fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
 .PP
 \fBbtrfs\fP \fBdevice balance\fP\fI <path> \fP
@@ -152,10 +154,19 @@ across the devices.
 Add device(s) to the filesystem identified by \fI<path>\fR.
 .TP
 
+.SS
+\fBdevice balance \fI<path>\fP
+Balance the chunks of the filesystem identified by \fI<path>\fP
+across the devices.
+
 \fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
 Remove device(s) from a filesystem identified by \fI<path>\fR.
 .PP
 
+\fBbalance progress\fP \fI<path>\fP
+Report progress on the currently-running balance operation on the
+filesystem mounted at \fI<path>\fP.
+
 .SH EXIT STATUS
 \fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in
 case of failure.
-- 
1.7.2.5

