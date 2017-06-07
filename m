Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36458 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbdFGG5U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 02:57:20 -0400
Received: by mail-pf0-f170.google.com with SMTP id x63so2305952pff.3
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 23:57:20 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH] btrfs: test Btrfs delalloc accounting overflow
Date: Tue,  6 Jun 2017 23:57:10 -0700
Message-Id: <e7bcf330422ed18883c9ad8ad4caa57624ed7cc0.1496818581.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

This is a regression test for "[PATCH] Btrfs: fix delalloc accounting
leak caused by u32 overflow". It creates a bunch of delalloc extents and
merges them together to make sure the accounting is done right.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 tests/btrfs/010     | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/010.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 78 insertions(+)
 create mode 100755 tests/btrfs/010
 create mode 100644 tests/btrfs/010.out

diff --git a/tests/btrfs/010 b/tests/btrfs/010
new file mode 100755
index 00000000..a5d10880
--- /dev/null
+++ b/tests/btrfs/010
@@ -0,0 +1,75 @@
+#! /bin/bash
+# FS QA Test 10
+#
+# Test delayed allocation with a large number of extents that are merged.
+# Regression test for patch "Btrfs: fix delalloc accounting leak caused by u32
+# overflow".
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Facebook.  All Rights Reserved.
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+test_file="$TEST_DIR/$seq"
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.* "$test_file"
+}
+
+. ./common/rc
+. ./common/filter
+
+rm -f $seqres.full
+
+_supported_fs btrfs
+_supported_os Linux
+_require_test
+
+# Create 32k extents. All of these extents will be accounted as outstanding and
+# reserved.
+for ((i = 0; i < 32 * 1024; i++)); do
+	xfs_io -f -c "pwrite $((2 * 4096 * i)) 4096" "$test_file" >>"$seqres.full"
+done
+
+# Fill in the gaps between the created extents. The outstanding extents will
+# all be merged into 1, but there will still be 32k reserved.
+for ((i = 0; i < 32 * 1024; i++)); do
+	xfs_io -f -c "pwrite $((2 * 4096 * i + 1)) 4096" "$test_file" >>"$seqres.full"
+done
+
+# Flush the delayed allocations.
+sync
+
+# Make sure that we didn't leak any metadata space.
+uuid="$(findmnt -n -o UUID "$TEST_DIR")"
+cd "/sys/fs/btrfs/$uuid/allocation"
+echo "$(($(cat metadata/bytes_may_use) - $(cat global_rsv_reserved))) bytes leaked" | grep -v '^0 '
+
+echo "Silence is golden"
+
+status=0
+exit
diff --git a/tests/btrfs/010.out b/tests/btrfs/010.out
new file mode 100644
index 00000000..1d83a8d6
--- /dev/null
+++ b/tests/btrfs/010.out
@@ -0,0 +1,2 @@
+QA output created by 010
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 6f19619e..1fa6c781 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -12,6 +12,7 @@
 007 auto quick rw metadata send
 008 auto quick send
 009 auto quick subvol
+010 auto
 011 auto replace
 012 auto convert
 013 auto quick balance
-- 
2.13.0

