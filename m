Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44874 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbbGNPhX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 11:37:23 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: regression test for the btrfs clone ioctl
Date: Tue, 14 Jul 2015 16:37:14 +0100
Message-Id: <1436888234-16254-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

This tests that we can not clone an inline extent into a non-zero file
offset. Inline extents at non-zero offsets is something btrfs is not
prepared for and results in all sorts of corruption and crashes on
future IO operations, such as the following BUG_ON() triggered by the
last write operation done by this test:

  [152154.035903] ------------[ cut here ]------------
  [152154.036424] kernel BUG at mm/page-writeback.c:2286!
  [152154.036424] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
  (...)
  [152154.036424] RIP: 0010:[<ffffffff8111a9d5>]  [<ffffffff8111a9d5>] clear_page_dirty_for_io+0x1e/0x90
  (...)
  [152154.036424] Call Trace:
  [152154.036424]  [<ffffffffa04e97c1>] lock_and_cleanup_extent_if_need+0x147/0x18d [btrfs]
  [152154.036424]  [<ffffffffa04ea82c>] __btrfs_buffered_write+0x245/0x4c8 [btrfs]
  [152154.036424]  [<ffffffffa04ed14b>] ? btrfs_file_write_iter+0x150/0x3e0 [btrfs]
  [152154.036424]  [<ffffffffa04ed15a>] ? btrfs_file_write_iter+0x15f/0x3e0 [btrfs]
  [152154.036424]  [<ffffffffa04ed2c7>] btrfs_file_write_iter+0x2cc/0x3e0 [btrfs]
  [152154.036424]  [<ffffffff81165a4a>] __vfs_write+0x7c/0xa5
  [152154.036424]  [<ffffffff81165f89>] vfs_write+0xa0/0xe4
  [152154.036424]  [<ffffffff81166855>] SyS_pwrite64+0x64/0x82
  [152154.036424]  [<ffffffff81465197>] system_call_fastpath+0x12/0x6f
  (...)
  [152154.242621] ---[ end trace e3d3376b23a57041 ]---

This issue is addressed by the following linux kernel patch for btrfs:
"Btrfs: fix file corruption after cloning inline extents".

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/096     | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/096.out | 12 ++++++++
 tests/btrfs/group   |  1 +
 3 files changed, 93 insertions(+)
 create mode 100755 tests/btrfs/096
 create mode 100644 tests/btrfs/096.out

diff --git a/tests/btrfs/096 b/tests/btrfs/096
new file mode 100755
index 0000000..f5b3a7f
--- /dev/null
+++ b/tests/btrfs/096
@@ -0,0 +1,80 @@
+#! /bin/bash
+# FSQA Test No. 096
+#
+# Test that we can not clone an inline extent into a non-zero file offset.
+#
+#-----------------------------------------------------------------------
+#
+# Copyright (C) 2015 SUSE Linux Products GmbH. All Rights Reserved.
+# Author: Filipe Manana <fdmanana@suse.com>
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_cloner
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+# Create our test files. File foo has the same 2K of data at offset 4K as file
+# bar has at its offset 0.
+$XFS_IO_PROG -f -s -c "pwrite -S 0xaa 0 4K" \
+		-c "pwrite -S 0xbb 4k 2K" \
+		-c "pwrite -S 0xcc 8K 4K" \
+		$SCRATCH_MNT/foo | _filter_xfs_io
+
+# File bar consists of a single inline extent (2K size).
+$XFS_IO_PROG -f -s -c "pwrite -S 0xbb 0 2K" \
+		$SCRATCH_MNT/bar | _filter_xfs_io
+
+# Now call the clone ioctl to clone the extent of file bar into file foo at its
+# offset 4K. This made file foo have an inline extent at offset 4K, something
+# which the btrfs code can not deal with in future IO operations because all
+# inline extents are supposed to start at an offset of 0, resulting in all sorts
+# of chaos.
+# So here we validate that the clone ioctl returns an EOPNOTSUPP, which is what
+# it returns for other cases dealing with inlined extents.
+$CLONER_PROG -s 0 -d $((4 * 1024)) -l $((2 * 1024)) \
+	$SCRATCH_MNT/bar $SCRATCH_MNT/foo
+
+# Because of the inline extent at offset 4K, the following write made the kernel
+# crash with a BUG_ON().
+$XFS_IO_PROG -c "pwrite -S 0xdd 6K 2K" $SCRATCH_MNT/foo | _filter_xfs_io
+
+status=0
+exit
diff --git a/tests/btrfs/096.out b/tests/btrfs/096.out
new file mode 100644
index 0000000..235198d
--- /dev/null
+++ b/tests/btrfs/096.out
@@ -0,0 +1,12 @@
+QA output created by 096
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+clone failed: Operation not supported
+wrote 2048/2048 bytes at offset 6144
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 79feea9..6ff5f3d 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -97,3 +97,4 @@
 093 auto quick clone
 094 auto quick send
 095 auto quick metadata
+096 auto quick clone
-- 
2.1.3

