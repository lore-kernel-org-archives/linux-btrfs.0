From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v5 3/8] User-space tool for cancelling balance operations.
Date: Sun, 10 Apr 2011 22:16:29 +0100
Message-ID: <4bd034d604ce77f80ffc2600015025da6f31c75a.1302469689.git.hugo@carfax.org.uk>
References: <cover.1302469689.git.hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1302469689.git.hugo@carfax.org.uk>
In-Reply-To: <cover.1302469689.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Add an option to the btrfs tool to use the ioctl for cancelling
balance operations.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs.c        |    4 ++++
 btrfs_cmds.c   |   41 +++++++++++++++++++++++++++++++++++++++++
 btrfs_cmds.h   |    1 +
 ioctl.h        |    1 +
 man/btrfs.8.in |    6 ++++++
 5 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 0b6186c..93f7886 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -103,6 +103,10 @@ static struct Command commands[] = {
 	  "balance progress", "[-m|--monitor] <path>\n"
 		"Show progress of the balance operation running on <path>."
 	},
+	{ do_balance_cancel, 1,
+	  "balance cancel", "<path>\n"
+		"Cancel the balance operation running on <path>."
+	},
 	{ do_scan,
 	  999, "device scan", "[<device> [<device>..]\n"
 		"Scan all device for or the passed device for a btrfs\n"
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index c681b5a..d246a8b 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -922,6 +922,47 @@ int do_balance_progress(int argc, char **argv)
 	return 0;
 }
 
+int do_balance_cancel(int nargs, char **argv)
+{
+	char *path = argv[1];
+	int fdmnt;
+	int ret = 0;
+	int err = 0;
+
+	fdmnt = open_file_or_dir(path);
+	if(fdmnt < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fdmnt, BTRFS_IOC_BALANCE_CANCEL, NULL);
+	err = errno;
+
+	if(ret) {
+		switch(err) {
+		case 0:
+			break;
+		case EINVAL:
+			fprintf(stderr, "ERROR: no balance in progress.\n");
+			err = 20;
+			break;
+		case ECANCELED:
+			fprintf(stderr, "ERROR: operation already cancelled.\n");
+			err = 21;
+			break;
+		default:
+			fprintf(stderr, "ERROR: ioctl returned error '%d'.\n",
+				err);
+			err = 22;
+			break;
+		}
+	}
+
+	close(fdmnt);
+
+	return err;
+}
+
 int do_remove_volume(int nargs, char **args)
 {
 
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 47b0a27..5cb0d9c 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -24,6 +24,7 @@ int do_show_filesystem(int nargs, char **argv);
 int do_add_volume(int nargs, char **args);
 int do_balance(int nargs, char **argv);
 int do_balance_progress(int nargs, char **argv);
+int do_balance_cancel(int nargs, char **argv);
 int do_remove_volume(int nargs, char **args);
 int do_scan(int nargs, char **argv);
 int do_resize(int nargs, char **argv);
diff --git a/ioctl.h b/ioctl.h
index 3eeaa33..40c0b57 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -176,4 +176,5 @@ struct btrfs_ioctl_balance_progress {
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 27, \
 					struct btrfs_ioctl_balance_progress)
+#define BTRFS_IOC_BALANCE_CANCEL _IO(BTRFS_IOCTL_MAGIC, 28)
 #endif
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 90be97e..d7fab80 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -25,6 +25,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBbalance progress\fP [\fB-m\fP|\fB--monitor\fP] \fI<path>\fP
 .PP
+\fBbtrfs\fP \fBbalance cancel\fP \fI<path>\fP
+.PP
 \fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
 .PP
 \fBbtrfs\fP \fBdevice balance\fP\fI <path> \fP
@@ -168,6 +170,10 @@ Report progress on the currently-running balance operation on the
 filesystem mounted at \fI<path>\fP. Use --monitor to report progress
 continually, including an estimate of completion time.
 
+\fbalance cancel\fP \fI<path>\fP
+Cancel the balance currently running on the filesystem mounted at
+\fI<path>\fP.
+
 .SH EXIT STATUS
 \fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in
 case of failure.
-- 
1.7.2.5

