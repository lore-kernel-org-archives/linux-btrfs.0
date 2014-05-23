Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38448 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaEWSPm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 14:15:42 -0400
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: add test for btrfs send with large xattrs
Date: Fri, 23 May 2014 20:15:30 +0100
Message-Id: <1400872530-7706-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Verify that btrfs send is able to replicate xattrs larger than
PATH_MAX. This is possible if the b+tree leaf size is larger
than 4Kb (mkfs.btrfs's default is max(16Kb, PAGE_SIZE) as of
btrfs-progs v3.12, and max(4Kb, PAGE_SIZE in older versions).

This issue is fixed by the following linux kernel btrfs patch:

   Btrfs: send, use the right limits for xattr names and values

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/053     | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/053.out |   1 +
 tests/btrfs/group   |   1 +
 3 files changed, 110 insertions(+)
 create mode 100755 tests/btrfs/053
 create mode 100644 tests/btrfs/053.out

diff --git a/tests/btrfs/053 b/tests/btrfs/053
new file mode 100755
index 0000000..4dbdf59
--- /dev/null
+++ b/tests/btrfs/053
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test No. btrfs/053
+#
+# Verify that btrfs send is able to replicate xattrs larger than PATH_MAX.
+# This is possible if the b+tree leaf size is larger than 4Kb (mkfs.btrfs's
+# default is max(16Kb, PAGE_SIZE) as of btrfs-progs v3.12, and max(4Kb,
+# PAGE_SIZE in older versions).
+#
+# This issue is fixed by the following linux kernel btrfs patch:
+#
+#   Btrfs: send, use the right limits for xattr names and values
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
+. ./common/attr
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_fssum
+_require_attrs
+_need_to_be_root
+
+# max(16384, PAGE_SIZE) is the default leaf/node size on btrfs-progs v3.12+.
+# Older versions just use max(4096, PAGE_SIZE).
+# mkfs.btrfs can't create an fs with a leaf/node size smaller than PAGE_SIZE.
+leaf_size=$(echo -e "16384\n`getconf PAGE_SIZE`" | sort -nr | head -1)
+
+send_files_dir=$TEST_DIR/btrfs-test-$seq
+
+rm -f $seqres.full
+rm -fr $send_files_dir
+mkdir $send_files_dir
+
+_scratch_mkfs "-l $leaf_size" >/dev/null 2>&1
+_scratch_mount
+
+echo "hello world" > $SCRATCH_MNT/foobar
+
+$SETFATTR_PROG -n user.xattr_name_1 -v `$PERL_PROG -e 'print "A" x 6000;'` \
+	$SCRATCH_MNT/foobar
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+run_check $FSSUM_PROG -A -f -w $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+
+# Update existing xattr value and add a new xattr too.
+$SETFATTR_PROG -n user.xattr_name_1 -v `$PERL_PROG -e 'print "Z" x 6666;'` \
+	$SCRATCH_MNT/foobar
+$SETFATTR_PROG -n user.xattr_name_2 -v `$PERL_PROG -e 'print "U" x 5555;'` \
+	$SCRATCH_MNT/foobar
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+run_check $FSSUM_PROG -A -f -w $send_files_dir/2.fssum \
+	-x $SCRATCH_MNT/mysnap2/mysnap1 $SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap2 -f $send_files_dir/2.snap
+
+_scratch_unmount
+_check_scratch_fs
+
+_scratch_mkfs "-l $leaf_size" >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+run_check $FSSUM_PROG -r $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
+run_check $FSSUM_PROG -r $send_files_dir/2.fssum $SCRATCH_MNT/mysnap2
+
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/btrfs/053.out b/tests/btrfs/053.out
new file mode 100644
index 0000000..4c61638
--- /dev/null
+++ b/tests/btrfs/053.out
@@ -0,0 +1 @@
+QA output created by 053
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 5ff9b8e..ea49c5c 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -55,3 +55,4 @@
 050 auto
 051 auto quick
 052 auto quick
+053 auto quick
-- 
1.9.1

