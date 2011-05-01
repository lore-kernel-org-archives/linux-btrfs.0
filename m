From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v6 2/8] Add --monitor option to btrfs balance progress.
Date: Sun,  1 May 2011 16:47:10 +0100
Message-ID: <fd3a755f6b2cb5d78c4d4f6883b5a88b5fa35719.1304262467.git.hugo@carfax.org.uk>
References: <cover.1304262467.git.hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1304262467.git.hugo@carfax.org.uk>
In-Reply-To: <cover.1304262467.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

For the impatient, this patch introduces the pot-watching --monitor
option, which checks the balance progress at regular intervals, and
updates a single status line with the current progress and an
estimated completion time.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs.c        |    4 +-
 btrfs_cmds.c   |  109 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 ioctl.h        |    2 +-
 man/btrfs.8.in |    7 ++--
 4 files changed, 106 insertions(+), 16 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 3a24019..0b6186c 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -99,8 +99,8 @@ static struct Command commands[] = {
 	  "balance start", "<path>\n"
 		"Synonym for \"btrfs filesystem balance\"."
 	},
-	{ do_balance_progress, 1,
-	  "balance progress", "<path>\n"
+	{ do_balance_progress, -1,
+	  "balance progress", "[-m|--monitor] <path>\n"
 		"Show progress of the balance operation running on <path>."
 	},
 	{ do_scan,
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 00dda0a..ad2300d 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -797,22 +797,108 @@ int get_balance_progress(char *path, struct btrfs_ioctl_balance_progress *bal)
 	return err;
 }
 
+const struct option progress_options[] = {
+	{ "monitor", 0, NULL, 'm' },
+	{ NULL, 0, NULL, 0 }
+};
+
 int do_balance_progress(int argc, char **argv)
 {
 	char *path;
 	int ret = 0;
 	int err = 0;
 	struct btrfs_ioctl_balance_progress bal;
+	__u64 last_completed = -1;
+	__u64 initial_completed = -1;
+	struct timeval now;
+	struct timeval started;
+	int monitor = 0;
+
+	optind = 1;
+	while(1) {
+		int c = getopt_long(argc, argv, "m", progress_options, NULL);
+		if (c < 0)
+			break;
+		switch(c) {
+		case 'm':
+			monitor = 1;
+			break;
+		default:
+			fprintf(stderr, "Invalid arguments for balance progress\n");
+			free(argv);
+			return 1;
+		}
+	}
+
+	if(optind >= argc) {
+		fprintf(stderr, "No filesystem path given for progress\n");
+		return 1;
+	}
+
+	path = argv[optind];
+	do {
+		int prs = 0;
 
-	path = argv[1];
+		ret = get_balance_progress(path, &bal);
+		if (ret)
+			break;
 
-	ret = get_balance_progress(path, &bal);
-	if (!ret)
-		printf("\r%u/%u block groups moved, "
-		       "%0.2f%% complete.\n",
-		       bal.completed,
-		       bal.expected,
-		       (float)bal.completed/bal.expected*100.0);
+		if (last_completed != bal.completed) {
+			printf("\r%u/%u block groups moved, "
+			       "%0.2f%% complete.",
+			       bal.completed,
+			       bal.expected,
+			       (float)bal.completed/bal.expected*100.0);
+		}
+
+		if (initial_completed != -1
+		    && initial_completed != bal.completed) {
+			ret = gettimeofday(&now, NULL);
+			if (ret) {
+				fprintf(stderr, "Can't read current time\n");
+				return 22;
+			}
+			/* Seconds per block */
+			float rate = (float)(now.tv_sec - started.tv_sec)
+					/ (bal.completed - initial_completed);
+			int secs_remaining = rate
+			  		* (bal.expected - bal.completed);
+			printf(" Time remaining");
+			if (secs_remaining >= 60*60*24) {
+				printf(" %dd", secs_remaining / (60*60*24));
+				secs_remaining %= 60*60*24;
+				prs = 1;
+			}
+			if (prs || secs_remaining >= 60*60) {
+				printf(" %dh", secs_remaining / (60*60));
+				secs_remaining %= 60*60;
+				prs = 1;
+			}
+			if (prs || secs_remaining > 60) {
+				printf(" %dm", secs_remaining / 60);
+				secs_remaining %= 60;
+			}
+			printf(" %ds\x1b[K", secs_remaining);
+		}
+
+		if (last_completed != -1 && last_completed != bal.completed) {
+			initial_completed = bal.completed;
+			ret = gettimeofday(&started, NULL);
+			if (ret) {
+				fprintf(stderr, "Can't read current time\n");
+				return 22;
+			}
+		}
+
+		last_completed = bal.completed;
+
+		if (monitor) {
+			fflush(stdout);
+			sleep(1);
+		} else {
+			printf("\n");
+		}
+	} while(monitor);
 
 	switch(ret) {
 	case 0:
@@ -821,10 +907,13 @@ int do_balance_progress(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
 		return 13;
 	case EINVAL:
-		fprintf(stderr,
+ 		if (!monitor) {
+ 			fprintf(stderr,
 				"No balance operation running on '%s'.\n",
 				path);
-		return 20;
+			return 20;
+		}
+		break;
 	default:
 		fprintf(stderr, "ERROR: ioctl returned error %d.", err);
 		return 21;
diff --git a/ioctl.h b/ioctl.h
index f07d3a2..3eeaa33 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -174,6 +174,6 @@ struct btrfs_ioctl_balance_progress {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
-#define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 25, \
+#define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 27, \
 					struct btrfs_ioctl_balance_progress)
 #endif
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 7b66fb7..5fcad89 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -27,7 +27,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBbalance start\fP\fI <path> \fP
 .PP
-\fBbtrfs\fP \fBbalance progress\fP\fI <path>\fP
+\fBbtrfs\fP \fBbalance progress\fP [\fB-m\fP|\fB--monitor\fP] \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
 .PP
@@ -162,9 +162,10 @@ Add device(s) to the filesystem identified by \fI<path>\fR.
 Remove device(s) from a filesystem identified by \fI<path>\fR.
 .PP
 
-\fBbalance progress\fP \fI<path>\fP
+\fBbalance progress\fP [\fB-m\fP|\fB--monitor\fP] \fI<path>\fP
 Report progress on the currently-running balance operation on the
-filesystem mounted at \fI<path>\fP.
+filesystem mounted at \fI<path>\fP. Use --monitor to report progress
+continually, including an estimate of completion time.
 
 .SH EXIT STATUS
 \fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in
-- 
1.7.2.5

