Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:36582 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933579AbeEICNt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 22:13:49 -0400
Received: by mail-it0-f49.google.com with SMTP id e20-v6so18753304itc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 May 2018 19:13:49 -0700 (PDT)
From: Howard McLauchlan <linux@hmclauchlan.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@osandov.com>,
        Filipe Manana <fdmanana@gmail.com>,
        Howard McLauchlan <linux@hmclauchlan.com>
Subject: [PATCH 2/2] xfstests: btrfs, test send's ability to punch holes and prealloc extents
Date: Tue,  8 May 2018 22:13:21 -0400
Message-Id: <20180509021321.8515-2-linux@hmclauchlan.com>
In-Reply-To: <20180509021321.8515-1-linux@hmclauchlan.com>
References: <20180509021321.8515-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@gmail.com>

This test verifies that after an incremental btrfs send the
replicated file has the same exact hole and data structure as in
the origin filesystem. This didn't use to be the case before the
send stream version 2 - holes were sent as write operations of 0
valued bytes instead of punching holes with the fallocate system
call, and pre-allocated extents were sent as well as write
operations of 0 valued bytes instead of intructions for the
receiver to use the fallocate system call.

It also checks that prealloc extents that lie beyond the file's
size are replicated by an incremental send.

[Howard: rebased on kernel v4.17-rc4, btrfs progs v4.16.1]
Signed-off-by: Howard McLauchlan <linux@hmclauchlan.com>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 common/rc           |  10 ++++
 tests/btrfs/160     | 121 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/160.out |  42 +++++++++++++++
 tests/btrfs/group   |   1 +
 4 files changed, 174 insertions(+)
 create mode 100755 tests/btrfs/160
 create mode 100644 tests/btrfs/160.out

diff --git a/common/rc b/common/rc
index 9ffab7fd..e2e9904a 100644
--- a/common/rc
+++ b/common/rc
@@ -3802,6 +3802,16 @@ _require_scratch_feature()
 	esac
 }
 
+_require_btrfs_stream_version_2()
+{
+	$BTRFS_UTIL_PROG send 2>&1 | \
+		grep '^[ \t]*\--stream-version[ \t]\+.*' > /dev/null 2>&1
+	if [ $? -ne 0 ]; then
+		_notrun "Missing btrfs-progs send -a command line option, skipped this test"
+	fi
+}
+
+
 init_rc
 
 ################################################################################
diff --git a/tests/btrfs/160 b/tests/btrfs/160
new file mode 100755
index 00000000..e4b7264c
--- /dev/null
+++ b/tests/btrfs/160
@@ -0,0 +1,121 @@
+#! /bin/bash
+# FS QA Test No. btrfs/160
+#
+# Verify that after an incremental btrfs send the replicated file has
+# the same exact hole and data structure as in the origin filesystem.
+# This didn't use to be the case before the send stream version 2 -
+# holes were sent as write operations of 0 valued bytes instead of punching
+# holes with the fallocate system call, and pre-allocated extents were sent
+# as well as write operations of 0 valued bytes instead of intructions for
+# the receiver to use the fallocate system call. Also check that prealloc
+# extents that lie beyond the file's size are replicated by an incremental
+# send.
+#
+# More specifically, this structure preserving guarantee was added by the
+# following linux kernel commits:
+#
+#    Btrfs: send, use fallocate command to punch holes
+#    Btrfs: send, use fallocate command to allocate extents
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Filipe Manana.  All Rights Reserved.
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    rm -fr $send_files_dir
+    rm -fr $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/punch
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_fssum
+_require_xfs_io_command "fiemap"
+_require_btrfs_stream_version_2
+
+send_files_dir=$TEST_DIR/btrfs-test-$seq
+
+rm -f $seqres.full
+rm -fr $send_files_dir
+mkdir $send_files_dir
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+$XFS_IO_PROG -f -c "pwrite -S 0x01 -b 300000 0 300000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+$XFS_IO_PROG -c "fpunch 100000 50000" $SCRATCH_MNT/foo
+$XFS_IO_PROG -c "falloc 100000 50000" $SCRATCH_MNT/foo
+$XFS_IO_PROG -c "pwrite -S 0xff -b 1000 120000 1000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "fpunch 250000 20000" $SCRATCH_MNT/foo
+
+$XFS_IO_PROG -c "falloc -k 300000 1000000" $SCRATCH_MNT/foo
+$XFS_IO_PROG -c "falloc -k 9000000 2000000" $SCRATCH_MNT/foo
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send --stream-version 2 -f $send_files_dir/1.snap \
+$SCRATCH_MNT/mysnap1
+_run_btrfs_util_prog send --stream-version 2 -p $SCRATCH_MNT/mysnap1 \
+-f $send_files_dir/2.snap $SCRATCH_MNT/mysnap2
+
+md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+# List all hole and data segments.
+$XFS_IO_PROG -r -c "seek -r -a 0" $SCRATCH_MNT/mysnap2/foo
+# List all extents, we're interested here in prealloc extents that lie beyond
+# the file's size.
+$XFS_IO_PROG -r -c "fiemap -v" $SCRATCH_MNT/mysnap2/foo | _filter_fiemap
+
+_scratch_unmount
+_check_scratch_fs
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive -f $send_files_dir/1.snap $SCRATCH_MNT
+_run_btrfs_util_prog receive -f $send_files_dir/2.snap $SCRATCH_MNT
+
+md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+# List all hole and data segments.
+$XFS_IO_PROG -r -c "seek -r -a 0" $SCRATCH_MNT/mysnap2/foo
+# List all extents, we're interested here in prealloc extents that lie beyond
+# the file's size.
+$XFS_IO_PROG -r -c "fiemap -v" $SCRATCH_MNT/mysnap2/foo | _filter_fiemap
+
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/btrfs/160.out b/tests/btrfs/160.out
new file mode 100644
index 00000000..020f1356
--- /dev/null
+++ b/tests/btrfs/160.out
@@ -0,0 +1,42 @@
+QA output created by 160
+wrote 300000/300000 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1000/1000 bytes at offset 120000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+5a88aa0da62c8999c16515050947a70a  SCRATCH_MNT/mysnap2/foo
+Whence	Result
+DATA	0
+HOLE	102400
+DATA	118784
+HOLE	122880
+DATA	147456
+HOLE	253952
+DATA	266240
+HOLE	300000
+0: [0..199]: data
+1: [200..231]: unwritten
+2: [232..239]: data
+3: [240..287]: unwritten
+4: [288..495]: data
+5: [496..519]: hole
+6: [520..591]: data
+7: [592..2543]: unwritten
+8: [2544..17575]: hole
+9: [17576..21487]: unwritten
+5a88aa0da62c8999c16515050947a70a  SCRATCH_MNT/mysnap2/foo
+Whence	Result
+DATA	0
+HOLE	102400
+DATA	118784
+HOLE	122880
+DATA	147456
+HOLE	253952
+DATA	266240
+HOLE	300000
+0: [0..199]: data
+1: [200..231]: unwritten
+2: [232..239]: data
+3: [240..287]: unwritten
+4: [288..495]: data
+5: [496..519]: hole
+6: [520..591]: data
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 939f1f7e..28d06840 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -162,4 +162,5 @@
 157 auto quick raid
 158 auto quick raid scrub
 159 auto quick
+160 auto quick send
 161 auto quick send
-- 
2.17.0

