From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v5 4/8] Run userspace tool in background for balances.
Date: Sun, 10 Apr 2011 22:16:30 +0100
Message-ID: <f452790c4dc3ee40474ae830c690d38cae93ec7f.1302469689.git.hugo@carfax.org.uk>
References: <cover.1302469689.git.hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1302469689.git.hugo@carfax.org.uk>
In-Reply-To: <cover.1302469689.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes a balance operation fork and detach from the current
terminal, to run the userspace side of the balance in the background.

Introduce a --wait switch so that a synchronous balance can be done if
the user requires.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs.c        |    8 ++++----
 btrfs_cmds.c   |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 man/btrfs.8.in |   19 ++++++++++---------
 3 files changed, 64 insertions(+), 15 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 93f7886..7b42658 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -91,12 +91,12 @@ static struct Command commands[] = {
 	  "filesystem df", "<path>\n"
 		"Show space usage information for a mount point\n."
 	},
-	{ do_balance, 1,
-	  "filesystem balance", "<path>\n"
+	{ do_balance, -1,
+	  "filesystem balance", "[-w|--wait] <path>\n"
 		"Balance the chunks across the device."
 	},
-	{ do_balance, 1,
-	  "balance start", "<path>\n"
+	{ do_balance, -1,
+	  "balance start", "[-w|--wait] <path>\n"
 		"Synonym for \"btrfs filesystem balance\"."
 	},
 	{ do_balance_progress, -1,
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index d246a8b..fadcb4f 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -754,12 +754,41 @@ int do_add_volume(int nargs, char **args)
 
 }
 
+const struct option balance_options[] = {
+	{ "wait", 0, NULL, 'w' },
+	{ NULL, 0, NULL, 0 }
+};
+
 int do_balance(int argc, char **argv)
 {
-
 	int	fdmnt, ret=0;
+	int background = 1;
 	struct btrfs_ioctl_vol_args args;
-	char	*path = argv[1];
+	char *path;
+	int ttyfd;
+
+	optind = 1;
+	while(1) {
+		int c = getopt_long(argc, argv, "w", balance_options, NULL);
+		if (c < 0)
+			break;
+		switch(c) {
+		case 'w':
+			background = 0;
+			break;
+		default:
+			fprintf(stderr, "Invalid arguments for balance\n");
+			free(argv);
+			return 1;
+		}
+	}
+
+	if(optind >= argc) {
+		fprintf(stderr, "No filesystem path given for balance\n");
+		return 1;
+	}
+
+	path = argv[optind];
 
 	fdmnt = open_file_or_dir(path);
 	if (fdmnt < 0) {
@@ -767,6 +796,25 @@ int do_balance(int argc, char **argv)
 		return 12;
 	}
 
+	if (background) {
+		int pid = fork();
+		if (pid == 0) {
+			/* We're in the child, and can run in the background */
+			ttyfd = open("/dev/tty", O_RDWR);
+			if (ttyfd > 0)
+				ioctl(ttyfd, TIOCNOTTY, 0);
+			/* Fall through to the BTRFS_IOC_BALANCE ioctl */
+		} else if (pid > 0) {
+			/* We're in the parent, and the fork succeeded */
+			printf("Background balance started\n");
+			return 0;
+		} else {
+			/* We're in the parent, and the fork failed */
+			fprintf(stderr, "ERROR: can't start background process -- %s\n",
+					strerror(errno));
+		}
+	}
+
 	memset(&args, 0, sizeof(args));
 	ret = ioctl(fdmnt, BTRFS_IOC_BALANCE, &args);
 	close(fdmnt);
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index d7fab80..95e39c3 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -23,13 +23,15 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
 .PP
+\fBbtrfs\fP \fBbalance start\fP [\fB-w\fP|\fB--wait\fP] \fI<path>\fP
+.PP
 \fBbtrfs\fP \fBbalance progress\fP [\fB-m\fP|\fB--monitor\fP] \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBbalance cancel\fP \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
 .PP
-\fBbtrfs\fP \fBdevice balance\fP\fI <path> \fP
+\fBbtrfs\fP \fBfilesystem balance\fP [\fB-w\fP|\fB--wait\fP] \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBdevice add\fP\fI <dev> [<dev>..] <path> \fP
 .PP
@@ -147,20 +149,19 @@ Show the btrfs filesystem with some additional info. If no UUID or label is
 passed, \fBbtrfs\fR show info of all the btrfs filesystem.
 .TP
 
-\fBdevice balance\fR \fI<path>\fR
-Balance the chunks of the filesystem identified by \fI<path>\fR
-across the devices.
+\fBdevice balance\fR [\fB-w\fP|\fB--wait\fP] \fI<path>\fR
+
+\fBbalance start\fR [\fB-w\fP|\fB--wait\fP] \fI<path>\fR
+
+Balance the chunks of the filesystem identified by \fI<path>\fR across
+the devices. The process runs in the background. Use \fB--wait\fP to
+wait in the foreground for completion of the balance.
 .TP
 
 \fBdevice add\fR\fI <dev> [<dev>..] <path>\fR
 Add device(s) to the filesystem identified by \fI<path>\fR.
 .TP
 
-.SS
-\fBdevice balance \fI<path>\fP
-Balance the chunks of the filesystem identified by \fI<path>\fP
-across the devices.
-
 \fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
 Remove device(s) from a filesystem identified by \fI<path>\fR.
 .PP
-- 
1.7.2.5

