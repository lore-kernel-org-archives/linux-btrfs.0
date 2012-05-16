Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:50816 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab2EPQva (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 May 2012 12:51:30 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by mort.rzone.de (Postfix) with ESMTP id E1058244
	for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2012 18:51:28 +0200 (MEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs-progs: make scrub IO priority configurable
Date: Wed, 16 May 2012 18:51:28 +0200
Message-Id: <1337187088-693-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs tool is changed in order to support command line parameters
to configure the IO priority of the scrub tasks. Also the default is
changed. The default IO priority for scrub is the idle class now.

The behavior is the same as when one would type
'ionice ... btrfs scrub start ...' or 'ionice ... btrfs scrub resume ...'
(without this patch applied).
The only reason for adding this to the btrfs tool is that it was not
documented and not obvious that it worked like this, that all internal
scrub tasks inherited the IO priority values of the btrfs tool that is
starting or resuming the scrub operation.

Note that after applying the patch it is no longer possible to set
the IO priority using ionice since the btrfs tool always configures
the priority in order to run in the idle class by default.

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

Note that the patch that sets the scrub readahead IO priority to the
idle class is a seperate patch, this needs to be done in the kernel.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
Changes v1->v2:
- Rebase on Chris' current master branch

 cmds-scrub.c   |   40 +++++++++++++++++++++++++++++++++++++---
 man/btrfs.8.in |   23 ++++++++++++++++++-----
 2 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index c4503f4..0c82f76 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -22,6 +22,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/un.h>
+#include <sys/syscall.h>
 #include <poll.h>
 #include <sys/file.h>
 #include <uuid/uuid.h>
@@ -58,6 +59,15 @@ struct scrub_stats {
 	u64 canceled;
 };
 
+/* TBD: replace with #include "linux/ioprio.h" in some years */
+#if !defined (IOPRIO_H)
+#define IOPRIO_WHO_PROCESS 1
+#define IOPRIO_CLASS_SHIFT 13
+#define IOPRIO_PRIO_VALUE(class, data) \
+		(((class) << IOPRIO_CLASS_SHIFT) | (data))
+#define IOPRIO_CLASS_IDLE 3
+#endif
+
 struct scrub_progress {
 	struct btrfs_ioctl_scrub_args scrub_args;
 	int fd;
@@ -67,6 +77,8 @@ struct scrub_progress {
 	struct scrub_file_record *resumed;
 	int ioctl_errno;
 	pthread_mutex_t progress_mutex;
+	int ioprio_class;
+	int ioprio_classdata;
 };
 
 struct scrub_file_record {
@@ -807,6 +819,14 @@ static void *scrub_one_dev(void *ctx)
 	sp->stats.duration = 0;
 	sp->stats.finished = 0;
 
+	ret = syscall(SYS_ioprio_set, IOPRIO_WHO_PROCESS, 0,
+		      IOPRIO_PRIO_VALUE(sp->ioprio_class,
+					sp->ioprio_classdata));
+	if (ret)
+		fprintf(stderr,
+			"WARNING: setting ioprio failed: %s (ignored).\n",
+			strerror(errno));
+
 	ret = ioctl(sp->fd, BTRFS_IOC_SCRUB, &sp->scrub_args);
 	gettimeofday(&tv, NULL);
 	sp->ret = ret;
@@ -1077,6 +1097,8 @@ static int scrub_start(int argc, char **argv, int resume)
 	int do_record = 1;
 	int readonly = 0;
 	int do_stats_per_dev = 0;
+	int ioprio_class = IOPRIO_CLASS_IDLE;
+	int ioprio_classdata = 0;
 	int n_start = 0;
 	int n_skip = 0;
 	int n_resume = 0;
@@ -1102,7 +1124,7 @@ static int scrub_start(int argc, char **argv, int resume)
 	u64 devid;
 
 	optind = 1;
-	while ((c = getopt(argc, argv, "BdqrR")) != -1) {
+	while ((c = getopt(argc, argv, "BdqrRc:n:")) != -1) {
 		switch (c) {
 		case 'B':
 			do_background = 0;
@@ -1121,6 +1143,12 @@ static int scrub_start(int argc, char **argv, int resume)
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
 			usage(resume ? cmd_scrub_resume_usage :
@@ -1229,6 +1257,8 @@ static int scrub_start(int argc, char **argv, int resume)
 		sp[i].skip = 0;
 		sp[i].scrub_args.end = (u64)-1ll;
 		sp[i].scrub_args.flags = readonly ? BTRFS_SCRUB_READONLY : 0;
+		sp[i].ioprio_class = ioprio_class;
+		sp[i].ioprio_classdata = ioprio_classdata;
 	}
 
 	if (!n_start && !n_resume) {
@@ -1478,13 +1508,15 @@ out:
 }
 
 static const char * const cmd_scrub_start_usage[] = {
-	"btrfs scrub start [-Bdqr] <path>|<device>",
+	"btrfs scrub start Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>\n",
 	"Start a new scrub",
 	"",
 	"-B     do not background",
 	"-d     stats per device (-B only)",
 	"-q     be quiet",
 	"-r     read only mode",
+	"-c     set ioprio class (see ionice(1) manpage)",
+	"-n     set ioprio classdata (see ionice(1) manpage)",
 	NULL
 };
 
@@ -1550,13 +1582,15 @@ again:
 }
 
 static const char * const cmd_scrub_resume_usage[] = {
-	"btrfs scrub resume [-Bdqr] <path>|<device>",
+	"btrfs scrub resume [-Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>\n",
 	"Resume previously canceled or interrupted scrub",
 	"",
 	"-B     do not background",
 	"-d     stats per device (-B only)",
 	"-q     be quiet",
 	"-r     read only mode",
+	"-c     set ioprio class (see ionice(1) manpage)",
+	"-n     set ioprio classdata (see ionice(1) manpage)",
 	NULL
 };
 
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index be478e0..ccb2225 100644
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
@@ -319,4 +331,5 @@ and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 .SH SEE ALSO
-.BR mkfs.btrfs (8)
+.BR mkfs.btrfs (8),
+.BR ionice (1)
-- 
1.7.10.2

