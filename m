Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47106 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554AbbAIWSs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 17:18:48 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <sage@newdream.net>, <jack@suse.cz>,
        <david@fromorbit.com>
Subject: [RFC][PATCH] fstests: add dm-log-writes test and supporting code
Date: Fri, 9 Jan 2015 17:18:25 -0500
Message-ID: <1420841905-2455-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a proof of concept that I've gotten working with my dm-log-writes
target.  I'd like to get feedback on this test and my approach in general.
Currently this test fails on XFS because of either the ZERO RANGE or COLLAPSE
RANGE operations in fsx.  If I turn those off it passes fine as do all the other
file systems.  This depends on the target I've posted in dm-devel and you can
find here

https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/log/?h=dm-log-writes

My goal is to do this, to do an fsstress one that simply walks through each
individual FUA and verify the consistency of the fs, and then add a bunch of
btrfs specific ones for btrfs's weird things, like balance and such.  Thanks,

Josef

Subject: [PATCH] fstests: add dm-log-writes test and supporting code

This patch adds the supporting code for using the dm-log-writes target.  The
bash stuff is similar to the dmflakey code, it just gives us functions to build
and tear down a dm-log-writes target.  We add a new LOGWRITES_DEV variable to
take in the device we will use as the log and add checks for that.

I've rigged up fsx to have an integrity check mode.  Basically it works like it
normally works, but when it fsync()'s it marks the log with a unique mark and
dumps it's buffer to a file with the mark in the filename.  I did this with a
system() call simply because it was the fastest.  I can link the device-mapper
libraries and do it programatically if that would be preferred, but this works
pretty well.

The test itself just runs 200 ops and exits, then finds all of the good buffers
in the directory we provided and replays up to the mark given, mounts the file
system and compares the md5sum, unmounts and fsck's to check for metadata
integrity.  dm-log-writes will pretend to do discard and the replay tool will
replay it properly depending on the underlying device, either by writing 0's or
actually calling the discard ioctl, so I've enabled discard in the test for
maximum fun.

This test relies on the supporting userspace code I've written for
dm-logs-writes.  It can be found here

https://github.com/josefbacik/log-writes.git

Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 README                |   2 +
 common/dmlogwrites    |  80 ++++++++++++++++++++++++++++++
 common/rc             |  17 +++++++
 ltp/fsx.c             | 132 ++++++++++++++++++++++++++++++++++++++++++--------
 tests/generic/039     |  99 +++++++++++++++++++++++++++++++++++++
 tests/generic/039.out |   2 +
 tests/generic/group   |   1 +
 7 files changed, 314 insertions(+), 19 deletions(-)
 create mode 100644 common/dmlogwrites
 create mode 100644 tests/generic/039
 create mode 100644 tests/generic/039.out

diff --git a/README b/README
index 0c9449a..112478e 100644
--- a/README
+++ b/README
@@ -78,6 +78,8 @@ Preparing system for tests (IRIX and Linux):
                added to the end of fsstresss and fsx invocations, respectively,
                in case you wish to exclude certain operational modes from these
                tests.
+             - setenv LOGWRITES_DEV to a block device to use for power fail
+               testing.
 
         - or add a case to the switch in common/config assigning
           these variables based on the hostname of your test
diff --git a/common/dmlogwrites b/common/dmlogwrites
new file mode 100644
index 0000000..3c8e8da
--- /dev/null
+++ b/common/dmlogwrites
@@ -0,0 +1,80 @@
+##/bin/bash
+#
+# Copyright (c) 2015 Facebook, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#
+# common functions for setting up and tearing down a dm log-writes device
+
+_init_log_writes()
+{
+	local BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
+	LOGWRITES_NAME=logwrites-test
+	LOGWRITES_DMDEV=/dev/mapper/$LOGWRITES_NAME
+	LOGWRITES_TABLE="0 $BLK_DEV_SIZE log-writes $SCRATCH_DEV $LOGWRITES_DEV"
+	$DMSETUP_PROG create $LOGWRITES_NAME --table "$LOGWRITES_TABLE" || \
+		_fatal "failed to create log-writes device"
+	$DMSETUP_PROG mknodes > /dev/null 2>&1
+}
+
+_log_writes_mark()
+{
+	[ $# -ne 1 ] && _fatal "_log_writes_mark takes one argument"
+	$DMSETUP_PROG message $LOGWRITES_NAME 0 mark $1
+}
+
+_log_writes_mkfs()
+{
+	_scratch_options mkfs
+	_mkfs_dev $SCRATCH_OPTIONS $LOGWRITES_DMDEV
+	_log_writes_mark mkfs
+}
+
+_mount_log_writes()
+{
+	mount -t $FSTYP $MOUNT_OPTIONS $* $LOGWRITES_DMDEV $SCRATCH_MNT
+}
+
+_unmount_log_writes()
+{
+	$UMOUNT_PROG $SCRATCH_MNT
+}
+
+# _replay_log <mark>
+#
+# This replays the log contained on $INTEGRITY_DEV onto $SCRATCH_DEV upto the
+# mark passed in.
+_replay_log()
+{
+	_mark=$1
+
+	/root/log-writes/replay-log --log $LOGWRITES_DEV --replay $SCRATCH_DEV \
+		--end-mark $_mark > /dev/null 2>&1
+	[ $? -ne 0 ] && _fatal "replay failed"
+}
+
+_log_writes_remove()
+{
+	$DMSETUP_PROG remove $LOGWRITES_NAME > /dev/null 2>&1
+	$DMSETUP_PROG mknodes > /dev/null 2>&1
+}
+
+_cleanup_log_writes()
+{
+	# If dmsetup load fails then we need to make sure to do resume here
+	# otherwise the umount will hang
+	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	_log_writes_remove
+}
diff --git a/common/rc b/common/rc
index 5ce3322..6a7fc79 100644
--- a/common/rc
+++ b/common/rc
@@ -1311,6 +1311,23 @@ _require_dm_flakey()
     fi
 }
 
+# this test requires the device mapper log-writes target
+#
+_require_dm_log_writes()
+{
+	[ -z $LOGWRITES_DEV ] && _notrun "This test requires a logwrites dev"
+	_require_block_device $SCRATCH_DEV
+	_require_block_device $LOGWRITES_DEV
+	_require_command $DMSETUP_PROG
+
+	modprobe dm-log-writes >/dev/null 2>&1
+	$DMSETUP_PROG targets | grep "log-writes" > /dev/null 2>&1
+	if [ $? -ne 0 ]
+	then
+		_notrun "This test requires dm log-writes support"
+	fi
+}
+
 # this test requires the projid32bit feature to be available in mkfs.xfs.
 #
 _require_projid32bit()
diff --git a/ltp/fsx.c b/ltp/fsx.c
index 3709419..bfcea68 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -61,15 +61,17 @@ int			logcount = 0;	/* total ops */
  * be careful in how we select the different operations. The active operations
  * are mapped to numbers as follows:
  *
- *		lite	!lite
- * READ:	0	0
- * WRITE:	1	1
- * MAPREAD:	2	2
- * MAPWRITE:	3	3
- * TRUNCATE:	-	4
- * FALLOCATE:	-	5
- * PUNCH HOLE:	-	6
- * ZERO RANGE:	-	7
+ *			lite	!lite	integrity
+ * READ:		0	0	0
+ * WRITE:		1	1	1
+ * MAPREAD:		2	2	2
+ * MAPWRITE:		3	3	3
+ * TRUNCATE:		-	4	4
+ * FALLOCATE:		-	5	5
+ * PUNCH HOLE:		-	6	6
+ * ZERO RANGE:		-	7	7
+ * COLLAPSE RANGE:	-	8	8
+ * FSYNC:		-	-	9
  *
  * When mapped read/writes are disabled, they are simply converted to normal
  * reads and writes. When fallocate/fpunch calls are disabled, they are
@@ -97,6 +99,10 @@ int			logcount = 0;	/* total ops */
 #define OP_COLLAPSE_RANGE	8
 #define OP_MAX_FULL		9
 
+/* integrity operations */
+#define OP_FSYNC		9
+#define OP_MAX_INTEGRITY	10
+
 /* operation modifiers */
 #define OP_CLOSEOPEN	100
 #define OP_SKIPPED	101
@@ -110,6 +116,9 @@ char	*original_buf;			/* a pointer to the original data */
 char	*good_buf;			/* a pointer to the correct data */
 char	*temp_buf;			/* a pointer to the current data */
 char	*fname;				/* name of our test file */
+char	*bname;				/* basename of our test file */
+char	*logdev;			/* -I flag */
+char	dname[1024];			/* -P flag */
 int	fd;				/* fd for our test file */
 
 blksize_t	block_size = 0;
@@ -146,9 +155,11 @@ int     punch_hole_calls = 1;           /* -H flag disables */
 int     zero_range_calls = 1;           /* -z flag disables */
 int	collapse_range_calls = 1;	/* -C flag disables */
 int 	mapped_reads = 1;		/* -R flag disables it */
+int	integrity = 0;			/* -I flag */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
 int	aio = 0;
+int	mark_nr = 0;
 
 int page_size;
 int page_mask;
@@ -339,6 +350,9 @@ logdump(void)
 						     lp->args[0] + lp->args[1])
 				prt("\t******CCCC");
 			break;
+		case OP_FSYNC:
+			prt("FSYNC");
+			break;
 		case OP_SKIPPED:
 			prt("SKIPPED (no operation)");
 			break;
@@ -418,6 +432,42 @@ report_failure(int status)
 				        *(((unsigned char *)(cp)) + 1)))
 
 void
+mark_log(void)
+{
+	char command[256];
+	int ret;
+
+	snprintf(command, 256, "dmsetup message %s 0 mark mark%d", logdev,
+		 mark_nr);
+	ret = system(command);
+	if (ret) {
+		prterr("dmsetup mark failed");
+		exit(1);
+	}
+}
+
+void
+dump_fsync_buffer(void)
+{
+	char fname_buffer[1024];
+	int good_fd;
+
+	if (!good_buf)
+		return;
+
+	snprintf(fname_buffer, 1024, "%s%s.mark%d", dname,
+		 bname, mark_nr);
+	good_fd = open(fname_buffer, O_WRONLY|O_CREAT|O_TRUNC, 0666);
+	if (good_fd < 0) {
+		prterr(fname_buffer);
+		exit(1);
+	}
+
+	save_buffer(good_buf, file_size, good_fd);
+	close(good_fd);
+}
+
+void
 check_buffers(unsigned offset, unsigned size)
 {
 	unsigned char c, t;
@@ -1117,6 +1167,27 @@ docloseopen(void)
 	}
 }
 
+void
+dofsync(void)
+{
+	int ret;
+
+	if (testcalls <= simulatedopcount)
+		return;
+	if (debug)
+		prt("%lu fsync\n", testcalls);
+	log4(OP_FSYNC, 0, 0, 0);
+	ret = fsync(fd);
+	if (ret < 0) {
+		prterr("dofsync");
+		report_failure(190);
+	}
+	mark_log();
+	dump_fsync_buffer();
+	printf("Dumped fsync buffer mark %d\n", mark_nr);
+	mark_nr++;
+}
+
 #define TRIM_OFF_LEN(off, len, size)	\
 do {					\
 	if (size)			\
@@ -1156,8 +1227,10 @@ test(void)
 	/* calculate appropriate op to run */
 	if (lite)
 		op = rv % OP_MAX_LITE;
-	else
+	else if (!integrity)
 		op = rv % OP_MAX_FULL;
+	else
+		op = rv % OP_MAX_INTEGRITY;
 
 	switch (op) {
 	case OP_MAPREAD:
@@ -1244,6 +1317,9 @@ test(void)
 		}
 		do_collapse_range(offset, size);
 		break;
+	case OP_FSYNC:
+		dofsync();
+		break;
 	default:
 		prterr("test: unknown operation");
 		report_failure(42);
@@ -1273,7 +1349,7 @@ void
 usage(void)
 {
 	fprintf(stdout, "usage: %s",
-		"fsx [-dnqxAFLOWZ] [-b opnum] [-c Prob] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
+		"fsx [-dnqxAFLOWZ] [-b opnum] [-c Prob] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] [-I logdev] fname\n\
 	-b opnum: beginning operation number (default 1)\n\
 	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
 	-d: debug output for all operations\n\
@@ -1315,6 +1391,7 @@ usage(void)
 	-W: mapped write operations DISabled\n\
         -R: read() system calls only (mapped reads disabled)\n\
         -Z: O_DIRECT (use -R, -W, -r and -w too)\n\
+	-I logdev: do integrity testing, logdev is the dm log writes device\n\
 	fname: this filename is REQUIRED (no default)\n");
 	exit(90);
 }
@@ -1478,13 +1555,14 @@ int
 main(int argc, char **argv)
 {
 	int	i, style, ch;
-	char	*endp;
+	char	*endp, *tmp;
 	char goodfile[1024];
 	char logfile[1024];
 	struct stat statbuf;
 
 	goodfile[0] = 0;
 	logfile[0] = 0;
+	dname[0] = 0;
 
 	page_size = getpagesize();
 	page_mask = page_size - 1;
@@ -1493,7 +1571,7 @@ main(int argc, char **argv)
 
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
-	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzCLN:OP:RS:WZ"))
+	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHzCLN:OP:RS:WZI:"))
 	       != EOF)
 		switch (ch) {
 		case 'b':
@@ -1611,10 +1689,11 @@ main(int argc, char **argv)
 			randomoplen = 0;
 			break;
 		case 'P':
-			strncpy(goodfile, optarg, sizeof(goodfile));
-			strcat(goodfile, "/");
-			strncpy(logfile, optarg, sizeof(logfile));
-			strcat(logfile, "/");
+			strncpy(dname, optarg, sizeof(dname));
+			strcat(dname, "/");
+
+			strncpy(goodfile, dname, sizeof(goodfile));
+			strncpy(logfile, dname, sizeof(logfile));
 			break;
                 case 'R':
                         mapped_reads = 0;
@@ -1636,6 +1715,14 @@ main(int argc, char **argv)
 		case 'Z':
 			o_direct = O_DIRECT;
 			break;
+		case 'I':
+			integrity = 1;
+			logdev = strdup(optarg);
+			if (!logdev) {
+				prterr("malloc");
+				exit(1);
+			}
+			break;
 		default:
 			usage();
 			/* NOTREACHED */
@@ -1645,6 +1732,12 @@ main(int argc, char **argv)
 	if (argc != 1)
 		usage();
 	fname = argv[0];
+	tmp = strdup(fname);
+	if (!tmp) {
+		prterr("strdup");
+		exit(1);
+	}
+	bname = basename(tmp);
 
 	signal(SIGHUP,	cleanup);
 	signal(SIGINT,	cleanup);
@@ -1687,14 +1780,14 @@ main(int argc, char **argv)
 		}
 	}
 #endif
-	strncat(goodfile, fname, 256);
+	strncat(goodfile, bname, 256);
 	strcat (goodfile, ".fsxgood");
 	fsxgoodfd = open(goodfile, O_RDWR|O_CREAT|O_TRUNC, 0666);
 	if (fsxgoodfd < 0) {
 		prterr(goodfile);
 		exit(92);
 	}
-	strncat(logfile, fname, 256);
+	strncat(logfile, bname, 256);
 	strcat (logfile, ".fsxlog");
 	fsxlogf = fopen(logfile, "w");
 	if (fsxlogf == NULL) {
@@ -1762,6 +1855,7 @@ main(int argc, char **argv)
 	while (numops == -1 || numops--)
 		test();
 
+	free(tmp);
 	if (close(fd)) {
 		prterr("close");
 		report_failure(99);
diff --git a/tests/generic/039 b/tests/generic/039
new file mode 100644
index 0000000..d8b88da
--- /dev/null
+++ b/tests/generic/039
@@ -0,0 +1,99 @@
+#! /bin/bash
+# FS QA Test No. 039
+#
+# Run fsx with log writes to verify power fail safeness.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Facebook. All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+status=1	# failure is the default!
+
+_cleanup()
+{
+	_cleanup_log_writes
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmlogwrites
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch_nocheck
+_require_dm_log_writes
+
+rm -f $seqres.full
+rm -rf $TEST_DIR/fsxtests
+
+SANITY_DIR=$TEST_DIR/fsxtests
+mkdir $SANITY_DIR
+
+# Create the log
+_init_log_writes
+
+_log_writes_mkfs >> $seqres.full 2>&1
+
+# Log writes emulates discard support, turn it on for maximum crying.
+_mount_log_writes -o discard
+
+# Run fsx for a while
+run_check $here/ltp/fsx -P $SANITY_DIR -N 200 -S 0 -I $LOGWRITES_DMDEV \
+	$SCRATCH_MNT/testfile
+end_md5=$(md5sum $SCRATCH_MNT/testfile | cut -f 1 -d ' ')
+
+# Unmount the scratch dir and tear down the log writes target
+_unmount_log_writes
+_log_writes_mark end
+_log_writes_remove
+
+# Now look for our files
+for i in $(find $SANITY_DIR -type f | grep mark)
+do
+	filename=$(basename $i)
+	mark="${filename##*.}"
+	echo "checking $filename" >> $seqres.full
+	_replay_log $mark
+	_scratch_mount
+	expected_md5=$(md5sum $i | cut -f 1 -d ' ')
+	md5=$(md5sum $SCRATCH_MNT/testfile | cut -f 1 -d ' ')
+	[ "${md5}x" != "${expected_md5}x" ] && _fatal "md5sum mismatched"
+	_scratch_unmount
+	_check_scratch_fs
+done
+
+# Check the end 
+_replay_log end
+_scratch_mount
+md5=$(md5sum $SCRATCH_MNT/testfile | cut -f 1 -d ' ')
+[ "${md5}x" != "${end_md5}x" ] && _fatal "end md5sum mismatched"
+_scratch_unmount
+_check_scratch_fs
+
+echo "Silence is golden"
+status=0
+exit
+
diff --git a/tests/generic/039.out b/tests/generic/039.out
new file mode 100644
index 0000000..d4e7ef6
--- /dev/null
+++ b/tests/generic/039.out
@@ -0,0 +1,2 @@
+QA output created by 039
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 1e89848..d3c2059 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -41,6 +41,7 @@
 036 auto aio rw stress
 037 metadata auto quick
 038 auto stress
+039 auto log
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.8.3.1

