Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26051 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950AbbCSUdB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 16:33:01 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <dm-devel@redhat.com>, <zab@redhat.com>, <fstests@vger.kernel.org>
Subject: [PATCH 2/3] fstests: add dm-log-writes test and supporting code
Date: Thu, 19 Mar 2015 16:31:09 -0400
Message-ID: <1426797070-27463-3-git-send-email-jbacik@fb.com>
In-Reply-To: <1426797070-27463-1-git-send-email-jbacik@fb.com>
References: <1426797070-27463-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
 common/config         |   1 +
 common/dmlogwrites    |  80 ++++++++++++++++++++++++++++++
 common/rc             |  46 ++++++++++++++++++
 ltp/fsx.c             | 131 ++++++++++++++++++++++++++++++++++++++++++--------
 tests/generic/326     | 130 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/326.out |   2 +
 tests/generic/group   |   1 +
 8 files changed, 374 insertions(+), 19 deletions(-)
 create mode 100644 common/dmlogwrites
 create mode 100644 tests/generic/326
 create mode 100644 tests/generic/326.out

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
diff --git a/common/config b/common/config
index e5c3579..563e48e 100644
--- a/common/config
+++ b/common/config
@@ -190,6 +190,7 @@ export DMSETUP_PROG="`set_prog_path dmsetup`"
 export WIPEFS_PROG="`set_prog_path wipefs`"
 export DUMP_PROG="`set_prog_path dump`"
 export RESTORE_PROG="`set_prog_path restore`"
+export REPLAYLOG_PROG="`set_prog_path replay-log`"
 
 # Generate a comparable xfsprogs version number in the form of
 # major * 10000 + minor * 100 + release
diff --git a/common/dmlogwrites b/common/dmlogwrites
new file mode 100644
index 0000000..4df9ea7
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
+	$REPLAYLOG_PROG --log $LOGWRITES_DEV --replay $SCRATCH_DEV \
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
index 857308a..c6c2059 100644
--- a/common/rc
+++ b/common/rc
@@ -1311,6 +1311,24 @@ _require_dm_flakey()
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
+	_require_command $REPLAYLOG_PROG
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
@@ -1545,6 +1563,34 @@ _require_xfs_io_command()
 		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
 }
 
+_test_falloc_support()
+{
+	if [ $# -ne 1 ]
+	then
+		echo "Usage: _test_falloc_support command" 1>&2
+		exit 1
+	fi
+	command=$1
+
+	testfile=$TEST_DIR/$$.xfs_io
+	case $command in
+	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" )
+		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
+			-c "$command 4k 8k" $testfile 2>&1`
+		;;
+	*)
+		echo "Not a valid falloc command" 1>&2
+		exit 1
+	esac
+
+	rm -f $testfile 2>&1 > /dev/null
+	echo $testio | grep -q "not found" && \
+		return 0
+	echo $testio | grep -q "Operation not supported" && \
+		return 0
+	return 1
+}
+
 # check that kernel and filesystem support direct I/O
 _require_odirect()
 {
diff --git a/ltp/fsx.c b/ltp/fsx.c
index 6da51e9..47ac865 100644
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
@@ -98,6 +100,10 @@ int			logcount = 0;	/* total ops */
 #define OP_INSERT_RANGE	9
 #define OP_MAX_FULL		10
 
+/* integrity operations */
+#define OP_FSYNC		10
+#define OP_MAX_INTEGRITY	11
+
 /* operation modifiers */
 #define OP_CLOSEOPEN	100
 #define OP_SKIPPED	101
@@ -111,6 +117,9 @@ char	*original_buf;			/* a pointer to the original data */
 char	*good_buf;			/* a pointer to the correct data */
 char	*temp_buf;			/* a pointer to the current data */
 char	*fname;				/* name of our test file */
+char	*bname;				/* basename of our test file */
+char	*logdev;			/* -I flag */
+char	dname[1024];			/* -P flag */
 int	fd;				/* fd for our test file */
 
 blksize_t	block_size = 0;
@@ -149,9 +158,11 @@ int     zero_range_calls = 1;           /* -z flag disables */
 int	collapse_range_calls = 1;	/* -C flag disables */
 int	insert_range_calls = 1;		/* -I flag disables */
 int 	mapped_reads = 1;		/* -R flag disables it */
+int	integrity = 0;			/* -I flag */
 int	fsxgoodfd = 0;
 int	o_direct;			/* -Z */
 int	aio = 0;
+int	mark_nr = 0;
 
 int page_size;
 int page_mask;
@@ -350,6 +361,9 @@ logdump(void)
 						     lp->args[0] + lp->args[1])
 				prt("\t******IIII");
 			break;
+		case OP_FSYNC:
+			prt("FSYNC");
+			break;
 		case OP_SKIPPED:
 			prt("SKIPPED (no operation)");
 			break;
@@ -429,6 +443,42 @@ report_failure(int status)
 				        *(((unsigned char *)(cp)) + 1)))
 
 void
+mark_log(void)
+{
+	char command[256];
+	int ret;
+
+	snprintf(command, 256, "dmsetup message %s 0 mark %s.mark%d", logdev,
+		 bname, mark_nr);
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
@@ -1183,6 +1233,26 @@ docloseopen(void)
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
 
 #define TRIM_OFF(off, size)			\
 do {						\
@@ -1233,8 +1303,10 @@ test(void)
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
@@ -1343,6 +1415,9 @@ test(void)
 
 		do_insert_range(offset, size);
 		break;
+	case OP_FSYNC:
+		dofsync();
+		break;
 	default:
 		prterr("test: unknown operation");
 		report_failure(42);
@@ -1372,7 +1447,7 @@ void
 usage(void)
 {
 	fprintf(stdout, "usage: %s",
-		"fsx [-dnqxAFLOWZ] [-b opnum] [-c Prob] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] fname\n\
+		"fsx [-dnqxAFLOWZ] [-b opnum] [-c Prob] [-l flen] [-m start:end] [-o oplen] [-p progressinterval] [-r readbdy] [-s style] [-t truncbdy] [-w writebdy] [-D startingop] [-N numops] [-P dirpath] [-S seed] [-I logdev] fname\n\
 	-b opnum: beginning operation number (default 1)\n\
 	-c P: 1 in P chance of file close+open at each op (default infinity)\n\
 	-d: debug output for all operations\n\
@@ -1417,6 +1492,7 @@ usage(void)
 	-W: mapped write operations DISabled\n\
         -R: read() system calls only (mapped reads disabled)\n\
         -Z: O_DIRECT (use -R, -W, -r and -w too)\n\
+	-i logdev: do integrity testing, logdev is the dm log writes device\n\
 	fname: this filename is REQUIRED (no default)\n");
 	exit(90);
 }
@@ -1580,13 +1656,14 @@ int
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
@@ -1595,7 +1672,7 @@ main(int argc, char **argv)
 
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
-	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WZ"))
+	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FKHzCILN:OP:RS:WZi:"))
 	       != EOF)
 		switch (ch) {
 		case 'b':
@@ -1719,10 +1796,11 @@ main(int argc, char **argv)
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
@@ -1744,6 +1822,14 @@ main(int argc, char **argv)
 		case 'Z':
 			o_direct = O_DIRECT;
 			break;
+		case 'i':
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
@@ -1753,6 +1839,12 @@ main(int argc, char **argv)
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
@@ -1795,14 +1887,14 @@ main(int argc, char **argv)
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
@@ -1874,6 +1966,7 @@ main(int argc, char **argv)
 	while (numops == -1 || numops--)
 		test();
 
+	free(tmp);
 	if (close(fd)) {
 		prterr("close");
 		report_failure(99);
diff --git a/tests/generic/326 b/tests/generic/326
new file mode 100644
index 0000000..b4346e6
--- /dev/null
+++ b/tests/generic/326
@@ -0,0 +1,130 @@
+#! /bin/bash
+# FS QA Test No. 326
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
+_check_files()
+{
+	_name=$1
+	# Now look for our files
+	for i in $(find $SANITY_DIR -type f | grep $_name | grep mark)
+	do
+		filename=$(basename $i)
+		mark="${filename##*.}"
+		echo "checking $filename" >> $seqres.full
+		_replay_log $filename
+		_scratch_mount
+		expected_md5=$(md5sum $i | cut -f 1 -d ' ')
+		md5=$(md5sum $SCRATCH_MNT/$_name | cut -f 1 -d ' ')
+		[ "${md5}x" != "${expected_md5}x" ] && _fatal "md5sum mismatched"
+		_scratch_unmount
+		_check_scratch_fs
+	done
+}
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
+FSX_OPTS=""
+[ $(_test_falloc_support "fpunch") ] || FSX_OPTS="-H"
+[ $(_test_falloc_support "fcollapse") ] || FSX_OPTS="$FSX_OPTS -C"
+[ $(_test_falloc_support "fzero") ] || FSX_OPTS="$FSX_OPTS -z"
+[ $(_test_falloc_support "finsert") ] || FSX_OPTS="$FSX_OPTS -I"
+
+# Run fsx for a while
+run_check $here/ltp/fsx -P $SANITY_DIR -N 300 -S 0 -i $LOGWRITES_DMDEV \
+	$FSX_OPTS $SCRATCH_MNT/testfile1 &
+run_check $here/ltp/fsx -P $SANITY_DIR -N 300 -S 0 -i $LOGWRITES_DMDEV \
+	$FSX_OPTS $SCRATCH_MNT/testfile2 &
+run_check $here/ltp/fsx -P $SANITY_DIR -N 300 -S 0 -i $LOGWRITES_DMDEV \
+	$FSX_OPTS $SCRATCH_MNT/testfile3 &
+run_check $here/ltp/fsx -P $SANITY_DIR -N 300 -S 0 -i $LOGWRITES_DMDEV \
+	$FSX_OPTS $SCRATCH_MNT/testfile4 &
+wait
+test1_md5=$(md5sum $SCRATCH_MNT/testfile1 | cut -f 1 -d ' ')
+test2_md5=$(md5sum $SCRATCH_MNT/testfile2 | cut -f 1 -d ' ')
+test3_md5=$(md5sum $SCRATCH_MNT/testfile3 | cut -f 1 -d ' ')
+test4_md5=$(md5sum $SCRATCH_MNT/testfile4 | cut -f 1 -d ' ')
+
+# Unmount the scratch dir and tear down the log writes target
+_unmount_log_writes
+_log_writes_mark end
+_log_writes_remove
+
+for i in testfile1 testfile2 testfile3 testfile4
+do
+	_check_files $i
+done
+
+# Check the end
+_replay_log end
+_scratch_mount
+md5=$(md5sum $SCRATCH_MNT/testfile1 | cut -f 1 -d ' ')
+[ "${md5}x" != "${test1_md5}x" ] && _fatal "testfile1 end md5sum mismatched"
+md5=$(md5sum $SCRATCH_MNT/testfile2 | cut -f 1 -d ' ')
+[ "${md5}x" != "${test2_md5}x" ] && _fatal "testfile2 end md5sum mismatched"
+md5=$(md5sum $SCRATCH_MNT/testfile3 | cut -f 1 -d ' ')
+[ "${md5}x" != "${test3_md5}x" ] && _fatal "testfile3 end md5sum mismatched"
+md5=$(md5sum $SCRATCH_MNT/testfile4 | cut -f 1 -d ' ')
+[ "${md5}x" != "${test4_md5}x" ] && _fatal "testfile4 end md5sum mismatched"
+_scratch_unmount
+_check_scratch_fs
+
+echo "Silence is golden"
+status=0
+exit
+
diff --git a/tests/generic/326.out b/tests/generic/326.out
new file mode 100644
index 0000000..4ac0db5
--- /dev/null
+++ b/tests/generic/326.out
@@ -0,0 +1,2 @@
+QA output created by 326
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index d56d3ce..31e5f7d 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -183,3 +183,4 @@
 323 auto aio stress
 324 auto fsr quick
 325 auto quick data log
+326 auto log
-- 
1.8.3.1

