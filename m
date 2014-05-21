Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38551 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaEUPac (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 11:30:32 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so2136488wgh.4
        for <linux-btrfs@vger.kernel.org>; Wed, 21 May 2014 08:30:30 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: add test for btrfs send with long paths
Date: Wed, 21 May 2014 17:30:18 +0100
Message-Id: <1400689818-14400-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for btrfs send where long paths (exceeding 230 characters)
made send produce paths with random characters from a memory buffer returned
by kmalloc, as send forgot to populate the new buffer with the path string.

This issue is fixed by the following linux kernel btrfs patch:

   Btrfs: send, fix corrupted path strings for long paths

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/051     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/051.out |  1 +
 tests/btrfs/group   |  1 +
 3 files changed, 87 insertions(+)
 create mode 100755 tests/btrfs/051
 create mode 100644 tests/btrfs/051.out

diff --git a/tests/btrfs/051 b/tests/btrfs/051
new file mode 100755
index 0000000..53df664
--- /dev/null
+++ b/tests/btrfs/051
@@ -0,0 +1,85 @@
+#! /bin/bash
+# FS QA Test No. btrfs/051
+#
+# Regression test for btrfs send where long paths (exceeding 230 characters)
+# made send produce paths with random characters from a memory buffer returned
+# by kmalloc, as send forgot to populate the new buffer with the path string.
+#
+# This issue is fixed by the following linux kernel btrfs patch:
+#
+#   Btrfs: send, fix corrupted path strings for long paths
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
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_fssum
+_need_to_be_root
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
+TEST_PATH="$SCRATCH_MNT/fdmanana/.config/google-chrome-mysetup/Default/Pepper_Data/Shockwave_Flash/WritableRoot/#SharedObjects/JSHJ4ZKN/s.wsj.net/[[IMPORT]]/players.edgesuite.net/flash/plugins/osmf/advanced-streaming-plugin/v2.7/osmf1.6/Ak#"
+
+mkdir -p $TEST_PATH
+echo "hello world" > $TEST_PATH/amaiAdvancedStreamingPlugin.txt
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+run_check $FSSUM_PROG -A -f -w $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
+
+_scratch_unmount
+_check_scratch_fs
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+run_check $FSSUM_PROG -r $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/btrfs/051.out b/tests/btrfs/051.out
new file mode 100644
index 0000000..636dcef
--- /dev/null
+++ b/tests/btrfs/051.out
@@ -0,0 +1 @@
+QA output created by 051
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 69a80e0..0673449 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -53,3 +53,4 @@
 048 auto quick
 049 auto quick
 050 auto
+051 auto quick
-- 
1.9.1

