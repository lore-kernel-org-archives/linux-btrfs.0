From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] Btrfs-progs: make scrub IO priority configurable
Date: Mon,  6 Feb 2012 17:14:41 +0100
Message-ID: <1328544881-31880-1-git-send-email-sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs tool is changed in order to support command line parameters
to configure the IO priority of the scrub tasks. Also the default is
changed. The default IO priority for scrub is the idle class now.

Some basic performance measurements have been done with the goal to
measure which IO priority for scrub gives the best overall disk data
throughput. The kernel was configured to use the CFQ IO scheduler
with default configuration and without support for throttling. The
summary is, that the more the disk head movements are avoided, the
faster the overall disk transfer capacity is, which is not really a
big surprise. Therefore it makes sense that the best data throughput
was measured setting the scrub IO priority and the scrub readahead
IO priority to the idle class priority. Running with idle class IO
priority means that scrub and scrub readahead IO is paused while
other tasks access the disk. Doing the tasks one after the other
instead of concurrently avoids many disk head movements. The
overall data throughput of rotating disks is improved this way.

However, if it is desired to have the scrub task done within a
reasonable time, and if at the same time the filesystem is heavily
loaded, the idle IO priority should be avoided. Otherwise the scrub
operation will never take place and thus never terminate.

The best effort IO priority class with the subclass 7 (the lowest
one in the best effort class) is recommended in the case of always
heavily loaded hard disks. If the filesystem is not loaded all the
time and leaves some idle slots for scrub, the idle class IO priority
is recommended. The idle class now is the default if the scrub
operation is started with the btrfs-progs tools.

Please note that the scrub readahead IO priority is set in the
kernel, but the regular (non-readahead) scrub IO priority is set
in user mode, in the btrfs-progs tool that starts the scrub
operation. That means, you need to apply the patch for the kernel
and for the btrfs-progs as well.

Also note that the IO priority of the scrub readahead threads is
not configurable with this commit. With the related kernel commit it
is statically set to the idle class. This setting has shown the best
performance during all measurements, there is no need to configure
the scrub readahead IO priority.

Another fact which is no big surprise is that the overall data
throughput of SSDs does not improve from the modified IO priority.
The only effect on SSDs is that it is now possible to control the
amount of IO time slice spent for scrub.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 btrfs.c        |    8 ++++++--
 man/btrfs.8.in |   21 +++++++++++++++++----
 scrub.c        |   33 +++++++++++++++++++++++++++++++--
 3 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 1def354..ab9fcee 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -131,12 +131,15 @@ static struct Command commands[] = {
 	  "The filesystem must be unmounted.\n"
 	},
 	{ do_scrub_start, -1,
-	  "scrub start", "[-Bdqr] <path>|<device>\n"
+	  "scrub start",
+	  "[-Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>\n"
 		"Start a new scrub.",
 		"\n-B  do not background\n"
 		"-d  stats per device (-B only)\n"
 		"-q  quiet\n"
 		"-r  read only mode\n"
+		"-c  set ioprio class (see ionice(1) manpage)\n"
+		"-n  set ioprio classdata (see ionice(1) manpage)\n"
 	},
 	{ do_scrub_cancel, 1,
 	  "scrub cancel", "<path>|<device>\n"
@@ -144,7 +147,8 @@ static struct Command commands[] = {
 	  NULL
 	},
 	{ do_scrub_resume, -1,
-	  "scrub resume", "[-Bdqr] <path>|<device>\n"
+	  "scrub resume",
+	  "[-Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>\n"
 		"Resume previously canceled or interrupted scrub.",
 	  NULL
 	},
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index be478e0..7eac91c 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -39,11 +39,11 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
 .PP
-\fBbtrfs\fP \fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
+\fBbtrfs\fP \fBscrub start\fP [-Bdqru] [-c ioprio_class -n ioprio_classdata] {\fI<path>\fP|\fI<device>\fP}
 .PP
 \fBbtrfs\fP \fBscrub cancel\fP {\fI<path>\fP|\fI<device>\fP}
 .PP
-\fBbtrfs\fP \fBscrub resume\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
+\fBbtrfs\fP \fBscrub resume\fP [-Bdqru] [-c ioprio_class -n ioprio_classdata] {\fI<path>\fP|\fI<device>\fP}
 .PP
 \fBbtrfs\fP \fBscrub status\fP [-d] {\fI<path>\fP|\fI<device>\fP}
 .PP
@@ -230,12 +230,16 @@ Finally, if \fB--all-devices\fP is passed, all the devices under /dev are
 scanned.
 .TP
 
-\fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
+\fBscrub start\fP [-Bdqru] [-c ioprio_class -n ioprio_classdata] {\fI<path>\fP|\fI<device>\fP}
 Start a scrub on all devices of the filesystem identified by \fI<path>\fR or on
 a single \fI<device>\fR. Without options, scrub is started as a background
 process. Progress can be obtained with the \fBscrub status\fR command. Scrubbing
 involves reading all data from all disks and verifying checksums. Errors are
 corrected along the way if possible.
+.IP
+The default IO priority of scrub is the idle class. The priority can be configured similar to the
+.BR ionice (1)
+syntax.
 .RS
 
 \fIOptions\fR
@@ -249,6 +253,14 @@ Quiet. Omit error messages and statistics.
 Read only mode. Do not attempt to correct anything.
 .IP -u 5
 Scrub unused space as well. (NOT IMPLEMENTED)
+.IP -c 5
+Set IO priority class (see
+.BR ionice (1)
+manpage).
+.IP -n 5
+Set IO priority classdata (see
+.BR ionice (1)
+manpage).
 .RE
 .TP
 
@@ -260,7 +272,7 @@ If a \fI<device>\fR is given, the corresponding filesystem is found and
 \fBscrub cancel\fP behaves as if it was called on that filesystem.
 .TP
 
-\fBscrub resume\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
+\fBscrub resume\fP [-Bdqru] [-c ioprio_class -n ioprio_classdata] {\fI<path>\fP|\fI<device>\fP}
 Resume a canceled or interrupted scrub cycle on the filesystem identified by
 \fI<path>\fR or on a given \fI<device>\fR. Does not start a new scrub if the
 last scrub finished successfully.
@@ -320,3 +332,4 @@ Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 .SH SEE ALSO
 .BR mkfs.btrfs (8)
+.BR ionice (1)
diff --git a/scrub.c b/scrub.c
index 9dca5f6..3db7752 100644
--- a/scrub.c
+++ b/scrub.c
@@ -22,6 +22,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/un.h>
+#include <sys/syscall.h>
 #include <poll.h>
 #include <sys/file.h>
 #include <uuid/uuid.h>
@@ -52,6 +53,11 @@ struct scrub_stats {
 	u64 canceled;
 };
 
+#define IOPRIO_WHO_PROCESS 1
+#define IOPRIO_CLASS_SHIFT 13
+#define IOPRIO_PRIO_VALUE(class, data) \
+		(((class) << IOPRIO_CLASS_SHIFT) | (data))
+
 struct scrub_progress {
 	struct btrfs_ioctl_scrub_args scrub_args;
 	int fd;
@@ -61,6 +67,8 @@ struct scrub_progress {
 	struct scrub_file_record *resumed;
 	int ioctl_errno;
 	pthread_mutex_t progress_mutex;
+	int ioprio_class;
+	int ioprio_classdata;
 };
 
 struct scrub_file_record {
@@ -801,6 +809,13 @@ static void *scrub_one_dev(void *ctx)
 	sp->stats.duration = 0;
 	sp->stats.finished = 0;
 
+	ret = syscall(SYS_ioprio_set, IOPRIO_WHO_PROCESS, 0,
+		      IOPRIO_PRIO_VALUE(sp->ioprio_class,
+					sp->ioprio_classdata));
+	if (ret)
+		fprintf(stderr, "WARNING: setting ioprio failed: %s"
+				" (ignored).\n", strerror(errno));
+
 	ret = ioctl(sp->fd, BTRFS_IOC_SCRUB, &sp->scrub_args);
 	gettimeofday(&tv, NULL);
 	sp->ret = ret;
@@ -1068,6 +1083,8 @@ static int scrub_start(int argc, char **argv, int resume)
 	int do_record = 1;
 	int readonly = 0;
 	int do_stats_per_dev = 0;
+	int ioprio_class = 3; /* IOPRIO_CLASS_IDLE */
+	int ioprio_classdata = 0;
 	int n_start = 0;
 	int n_skip = 0;
 	int n_resume = 0;
@@ -1093,7 +1110,7 @@ static int scrub_start(int argc, char **argv, int resume)
 	u64 devid;
 
 	optind = 1;
-	while ((c = getopt(argc, argv, "BdqrR")) != -1) {
+	while ((c = getopt(argc, argv, "BdqrRc:n:")) != -1) {
 		switch (c) {
 		case 'B':
 			do_background = 0;
@@ -1112,13 +1129,23 @@ static int scrub_start(int argc, char **argv, int resume)
 		case 'R':
 			print_raw = 1;
 			break;
+		case 'c':
+			ioprio_class = (int)strtol(optarg, NULL, 10);
+			break;
+		case 'n':
+			ioprio_classdata = (int)strtol(optarg, NULL, 10);
+			break;
 		case '?':
 		default:
 			fprintf(stderr, "ERROR: scrub args invalid.\n"
 					" -B  do not background\n"
 					" -d  stats per device (-B only)\n"
 					" -q  quiet\n"
-					" -r  read only mode\n");
+					" -r  read only mode\n"
+					" -c  set ioprio class (see ionice(1)"
+					 " manpage)\n"
+					" -n  set ioprio classdata (see"
+					 " ionice(1) manpage)\n");
 			return 1;
 		}
 	}
@@ -1225,6 +1252,8 @@ static int scrub_start(int argc, char **argv, int resume)
 		sp[i].skip = 0;
 		sp[i].scrub_args.end = (u64)-1ll;
 		sp[i].scrub_args.flags = readonly ? BTRFS_SCRUB_READONLY : 0;
+		sp[i].ioprio_class = ioprio_class;
+		sp[i].ioprio_classdata = ioprio_classdata;
 	}
 
 	if (!n_start && !n_resume) {
-- 
1.7.3.4

