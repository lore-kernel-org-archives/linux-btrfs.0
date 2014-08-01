Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:44889 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHAJwL (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 1 Aug 2014 05:52:11 -0400
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] xfstests: add regression test for btrfs send with orphans
Date: Fri,  1 Aug 2014 11:51:53 +0100
Message-Id: <1406890313-11780-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1406848268-20620-1-git-send-email-fdmanana@suse.com>
References: <1406848268-20620-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for a btrfs issue where we create a RO snapshot
to use for a send operation, which fails with a -ESTALE error,
due to the presence of orphan inodes accessible through the
snapshot's commit root but no longer present through the main
root.

This issue is fixed by the following linux kernel btrfs patch:

  Btrfs: update commit root on snapshot creation after orphan cleanup

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Replaced a > redirect with a >> redirect to $seqres.full, and added a
    sleep.

 tests/btrfs/057     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/057.out |  1 +
 tests/btrfs/group   |  1 +
 3 files changed, 86 insertions(+)
 create mode 100755 tests/btrfs/057
 create mode 100644 tests/btrfs/057.out

diff --git a/tests/btrfs/057 b/tests/btrfs/057
new file mode 100755
index 0000000..1e313e9
--- /dev/null
+++ b/tests/btrfs/057
@@ -0,0 +1,84 @@
+#! /bin/bash
+# FS QA Test No. btrfs/057
+#
+# Regression test for a btrfs issue where we create a RO snapshot to use for
+# a send operation which fails with a -ESTALE error, due to the presence of
+# orphan inodes accessible through the snapshot's commit root but no longer
+# present through the main root.
+#
+# This issue is fixed by the following linux kernel btrfs patch:
+#
+#    Btrfs: update commit root on snapshot creation after orphan cleanup
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2014 SUSE Linux Products GmbH. All Rights Reserved.
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
+
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	if [ ! -z $XFS_IO_PID ]; then
+		kill $XFS_IO_PID > /dev/null 2>&1
+	fi
+	rm -fr $tmp
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
+# Requiring flink command tests for the presence of the -T option used
+# to pass O_TMPFILE to open(2).
+_require_xfs_io_command "flink"
+_need_to_be_root
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+# Create a tmpfile file, write some data to it and leave it open, so that our
+# main subvolume has an orphan inode item.
+$XFS_IO_PROG -T $SCRATCH_MNT >>$seqres.full 2>&1 < <(
+	echo "pwrite 0 65536"
+	read
+) &
+XFS_IO_PID=$!
+
+# Give it some time to the xfs_io process to create the tmpfile.
+sleep 3
+
+# With the tmpfile open, create a RO snapshot and use it for a send operation.
+# The send operation used to fail with -ESTALE due to the presence of the
+# orphan inode.
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap -f /dev/null
+
+status=0
+exit
diff --git a/tests/btrfs/057.out b/tests/btrfs/057.out
new file mode 100644
index 0000000..b26eefe
--- /dev/null
+++ b/tests/btrfs/057.out
@@ -0,0 +1 @@
+QA output created by 057
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 2da7127..ebc38c5 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -59,3 +59,4 @@
 054 auto quick
 055 auto quick
 056 auto quick
+057 auto quick
-- 
1.9.1

