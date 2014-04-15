Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:58345 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaDOSuZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 14:50:25 -0400
Received: by mail-wi0-f177.google.com with SMTP id cc10so231625wib.16
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 11:50:24 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: btrfs, add test for btrfs properties
Date: Tue, 15 Apr 2014 20:50:24 +0100
Message-Id: <1397591424-25439-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test case verifies the btrfs properties feature, a new feature
introduced in the linux kernel version 3.14.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 common/rc           |   9 +++
 tests/btrfs/048     | 220 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/048.out |  78 +++++++++++++++++++
 tests/btrfs/group   |   1 +
 4 files changed, 308 insertions(+)
 create mode 100755 tests/btrfs/048
 create mode 100644 tests/btrfs/048.out

diff --git a/common/rc b/common/rc
index acf419b..d4ba74f 100644
--- a/common/rc
+++ b/common/rc
@@ -2262,6 +2262,15 @@ _run_btrfs_util_prog()
 	run_check $BTRFS_UTIL_PROG $*
 }
 
+_require_btrfs_properties()
+{
+	$BTRFS_UTIL_PROG | grep 'btrfs property ' > /dev/null 2>&1
+	if [ $? -ne 0 ]
+	then
+		_notrun "Missing btrfs-progs with properties support, skipped this test"
+	fi
+}
+
 init_rc()
 {
 	if [ "$iam" == new ]
diff --git a/tests/btrfs/048 b/tests/btrfs/048
new file mode 100755
index 0000000..7e2ff50
--- /dev/null
+++ b/tests/btrfs/048
@@ -0,0 +1,220 @@
+#! /bin/bash
+# FS QA Test No. btrfs/048
+#
+# Btrfs properties test. The btrfs properties feature was introduced in the
+# linux kernel 3.14.
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
+here="`pwd`"
+tmp=/tmp/$$
+
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+send_files_dir=$TEST_DIR/btrfs-test-$seq
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
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_btrfs_properties
+_need_to_be_root
+
+rm -f $seqres.full
+rm -fr $send_files_dir
+mkdir $send_files_dir
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+echo "Testing label property"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT label
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT label foobar
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT label
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT label ''
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT label
+echo "***"
+mkdir $SCRATCH_MNT/testdir
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir label
+echo "***"
+
+echo -e "\nTesting subvolume ro property"
+_run_btrfs_util_prog subvolume create $SCRATCH_MNT/sv1
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1 ro
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/sv1 ro foo
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/sv1 ro true
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1 ro
+echo "***"
+touch $SCRATCH_MNT/sv1/foobar 2>&1 | _filter_scratch
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/sv1 ro false
+touch $SCRATCH_MNT/sv1/foobar 2>&1 | _filter_scratch
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1
+echo "***"
+
+echo -e "\nTesting compression property"
+mkdir $SCRATCH_MNT/testdir/subdir1
+touch $SCRATCH_MNT/testdir/file1
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1 compression
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/file1 compression \
+	foo 2>&1 | _filter_scratch
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/file1 compression lzo
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
+
+# Verify property was persisted.
+_scratch_unmount
+_check_scratch_fs
+_scratch_mount
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/file1 compression zlib
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/file1 compression ''
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
+
+# Test compression property inheritance.
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/subdir1 compression lzo
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1 compression
+echo "***"
+mkdir $SCRATCH_MNT/testdir/subdir1/subsubdir
+touch $SCRATCH_MNT/testdir/subdir1/some_file
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/subsubdir compression
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/some_file compression
+echo "***"
+mkdir $SCRATCH_MNT/testdir/subdir1/subsubdir/foo
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/subsubdir/foo \
+	compression
+echo "***"
+
+# Verify property was persisted.
+_scratch_unmount
+_check_scratch_fs
+_scratch_mount
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/subsubdir compression
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/subsubdir/foo \
+	compression
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/some_file compression
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/subdir1/subsubdir \
+	compression ''
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/subdir1/some_file \
+	compression ''
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/subdir1 compression ''
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/subsubdir compression
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/some_file compression
+echo "***"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1 compression
+echo "***"
+touch $SCRATCH_MNT/testdir/subdir1/some_file_2
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/some_file_2 \
+	compression
+echo "***"
+
+# Verify send is able to replicate properties.
+echo -e "\nTesting properties with send"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/testdir/subdir1 compression lzo
+touch $SCRATCH_MNT/testdir/subdir1/foobar
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1 compression
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/subdir1/foobar compression
+echo "***"
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+touch $SCRATCH_MNT/testdir/subdir1/foobar2
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+	-f $send_files_dir/2.snap
+
+_scratch_unmount
+_check_scratch_fs
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/mysnap2/testdir/subdir1 compression
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/mysnap2/testdir/subdir1/foobar \
+	compression
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/mysnap2/testdir/subdir1/foobar2 \
+	compression
+echo "***"
+
+_scratch_unmount
+_check_scratch_fs
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+echo -e "\nTesting subvolume properties"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lzo'
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT compression
+echo "***"
+touch $SCRATCH_MNT/file1
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/file1 compression
+echo "***"
+mkdir $SCRATCH_MNT/dir1
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/dir1 compression
+echo "***"
+mkdir $SCRATCH_MNT/dir1/subdir1
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/dir1/subdir1 compression
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/dir1/subdir1 compression 'zlib'
+touch $SCRATCH_MNT/dir1/subdir1/foo
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/dir1/subdir1/foo compression
+
+echo -e "\nTesting subvolume property inheritance"
+_run_btrfs_util_prog subvolume create $SCRATCH_MNT/sv1
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1 compression
+touch $SCRATCH_MNT/sv1/file2
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1/file2 compression
+
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/btrfs/048.out b/tests/btrfs/048.out
new file mode 100644
index 0000000..0b20d0b
--- /dev/null
+++ b/tests/btrfs/048.out
@@ -0,0 +1,78 @@
+QA output created by 048
+Testing label property
+label=
+***
+label=foobar
+***
+ro=false
+label=foobar
+***
+label=
+***
+ERROR: object is not compatible with property
+***
+
+Testing subvolume ro property
+ro=false
+***
+ERROR: invalid value for property.
+***
+***
+ro=true
+***
+touch: cannot touch 'SCRATCH_MNT/sv1/foobar': Read-only file system
+***
+ro=false
+***
+
+Testing compression property
+***
+ERROR: failed to set compression for SCRATCH_MNT/testdir/file1. Invalid argument
+***
+compression=lzo
+compression=lzo
+compression=zlib
+***
+compression=lzo
+***
+compression=lzo
+***
+compression=lzo
+***
+compression=lzo
+***
+compression=lzo
+***
+compression=lzo
+***
+compression=lzo
+***
+***
+***
+***
+***
+***
+
+Testing properties with send
+compression=lzo
+compression=lzo
+***
+compression=lzo
+compression=lzo
+compression=lzo
+***
+
+Testing subvolume properties
+compression=lzo
+***
+compression=lzo
+***
+compression=lzo
+***
+compression=lzo
+***
+compression=zlib
+
+Testing subvolume property inheritance
+compression=lzo
+compression=lzo
diff --git a/tests/btrfs/group b/tests/btrfs/group
index d4e3fc1..af60c79 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -50,3 +50,4 @@
 045 auto quick
 046 auto quick
 047 auto quick
+048 auto quick
-- 
1.9.1

