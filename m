Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40122 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab3LBGmo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Dec 2013 01:42:44 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: sbehrens@giantdisaster.de
Subject: [PATCH] Btrfs-progs: add option to skip whether a scrub has started/resumed in userspace
Date: Mon, 2 Dec 2013 14:42:25 +0800
Message-Id: <1385966545-5018-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I hit a problem that i can not start scrub when i am trying to track
superblock generation mismatch problems.

The fact is that we are trying to check whether we have started a scrub operation
in userspace, this will make us can't start scrub if that record file is damaged
itself. By adding a option to skip that check, everything will be fine.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-scrub.c   | 12 +++++++++---
 man/btrfs.8.in |  5 ++++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 605af45..9f614bc 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1096,9 +1096,10 @@ static int scrub_start(int argc, char **argv, int resume)
 	void *terr;
 	u64 devid;
 	DIR *dirstream = NULL;
+	int force = 0;
 
 	optind = 1;
-	while ((c = getopt(argc, argv, "BdqrRc:n:")) != -1) {
+	while ((c = getopt(argc, argv, "BdqrRc:n:f")) != -1) {
 		switch (c) {
 		case 'B':
 			do_background = 0;
@@ -1123,6 +1124,9 @@ static int scrub_start(int argc, char **argv, int resume)
 		case 'n':
 			ioprio_classdata = (int)strtol(optarg, NULL, 10);
 			break;
+		case 'f':
+			force = 1;
+			break;
 		case '?':
 		default:
 			usage(resume ? cmd_scrub_resume_usage :
@@ -1195,7 +1199,7 @@ static int scrub_start(int argc, char **argv, int resume)
 	 * is a normal mode of operation to start scrub on multiple
 	 * single devices, there is no reason to prevent this.
 	 */
-	if (is_scrub_running_on_fs(&fi_args, di_args, past_scrubs)) {
+	if (!force && is_scrub_running_on_fs(&fi_args, di_args, past_scrubs)) {
 		ERR(!do_quiet,
 		    "ERROR: scrub is already running.\n"
 		    "To cancel use 'btrfs scrub cancel %s'.\n"
@@ -1507,7 +1511,7 @@ out:
 }
 
 static const char * const cmd_scrub_start_usage[] = {
-	"btrfs scrub start [-BdqrR] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
+	"btrfs scrub start [-BdqrRf] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
 	"Start a new scrub",
 	"",
 	"-B     do not background",
@@ -1517,6 +1521,8 @@ static const char * const cmd_scrub_start_usage[] = {
 	"-R     raw print mode, print full data instead of summary"
 	"-c     set ioprio class (see ionice(1) manpage)",
 	"-n     set ioprio classdata (see ionice(1) manpage)",
+	"-f     force to skip checking whether scrub has started/resumed in userspace ",
+	"       this is useful when scrub stats record file is damaged",
 	NULL
 };
 
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index de356b0..68aa42e 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -58,7 +58,7 @@ btrfs \- control a btrfs filesystem
 \fBbtrfs\fP \fBdevice stats\fP [-z] {\fI<path>\fP|\fI<device>\fP}
 .PP
 .PP
-\fBbtrfs\fP \fBscrub start\fP [-BdqrR] [-c \fIioprio_class\fP -n \fIioprio_classdata\fP] {\fI<path>\fP|\fI<device>\fP}
+\fBbtrfs\fP \fBscrub start\fP [-BdqrRf] [-c \fIioprio_class\fP -n \fIioprio_classdata\fP] {\fI<path>\fP|\fI<device>\fP}
 .PP
 \fBbtrfs\fP \fBscrub cancel\fP {\fI<path>\fP|\fI<device>\fP}
 .PP
@@ -457,6 +457,9 @@ manpage).
 Set IO priority classdata (see
 .BR ionice (1)
 manpage).
+.IP "\fB-f\fP" 5
+force to check whether scrub has started or resumed in userspace.
+this is useful when scrub stat record file is damaged.
 .RE
 .TP
 
-- 
1.8.3.1

