From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v2 2/3] Add --monitor option to btrfs balance progress.
Date: Mon, 8 Nov 2010 20:05:25 +0000
Message-ID: <6e6e59176fd2704de00d10e4f968e406c0a83bd3.1289521433.git.hugo@carfax.org.uk>
References: <cover.1289521433.git.hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@libero.it>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1289521433.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

For the impatient, this patch introduces the pot-watching --monitor
option, which checks the balance progress at regular intervals, and
updates a single status line with the current progress and an
estimated completion time.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs_cmds.c   |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 man/btrfs.8.in |    4 +-
 2 files changed, 96 insertions(+), 10 deletions(-)

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 2745d64..c681b5a 100644
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
 
-	path = argv[1];
+	path = argv[optind];
+	do {
+		int prs = 0;
 
-	ret = get_balance_progress(path, &bal);
-	if (!ret)
-		printf("\r%llu/%llu block groups moved, "
-		       "%0.2f%% complete.\n",
-		       bal.completed,
-		       bal.expected,
-		       (float)bal.completed/bal.expected*100.0);
+		ret = get_balance_progress(path, &bal);
+		if (ret)
+			break;
+
+		if (last_completed != bal.completed) {
+			printf("\r%llu/%llu block groups moved, "
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
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 69d8613..3f7642e 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -21,7 +21,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\fP
 .PP
-\fBbtrfs\fP \fBbalance progress\fP \fI<path>\fP
+\fBbtrfs\fP \fBbalance progress\fP [\fB-m\fP|\fB--monitor\fP] \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
 .PP
@@ -150,7 +150,7 @@ Balance the chunks of the filesystem identified by \fI<path>\fR
 across the devices.
 .TP
 
-\fBbalance progress\fP \fI<path>\fP
+\fBbalance progress\fP [\fB-m\fP|\fB--monitor\fP] \fI<path>\fP
 Report progress on the currently-running balance operation on
 \fI<path>\fP.
 .TP
-- 
1.7.1


