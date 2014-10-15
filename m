Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:39559 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaJORiU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 13:38:20 -0400
From: Filipe Manana <fdmanana@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: btrfs: regression test for ro snapshot creation
Date: Wed, 15 Oct 2014 19:37:56 +0100
Message-Id: <1413398276-17365-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for a btrfs issue where creation of readonly snapshots caused
the filesystem to get into an inconsistent state.

This regression was introduced in the 3.17 kernel and fixed by reverting the
following linux kernel commit:

     Btrfs: race free update of commit root for ro snapshots
     9c3b306e1c9e6be4be09e99a8fe2227d1005effc

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/078     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/078.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 88 insertions(+)
 create mode 100755 tests/btrfs/078
 create mode 100644 tests/btrfs/078.out

diff --git a/tests/btrfs/078 b/tests/btrfs/078
new file mode 100755
index 0000000..48de357
--- /dev/null
+++ b/tests/btrfs/078
@@ -0,0 +1,85 @@
+#! /bin/bash
+# FSQA Test No. 078
+#
+# Regression test for a btrfs issue where creation of readonly snapshots caused
+# the filesystem to get into an inconsistent state.
+#
+# This regression was introduced in the 3.17 kernel and fixed by reverting the
+# following linux kernel commit:
+#
+#     Btrfs: race free update of commit root for ro snapshots
+#     9c3b306e1c9e6be4be09e99a8fe2227d1005effc
+#
+#-----------------------------------------------------------------------
+#
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
+tmp=`mktemp -d`
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -fr $tmp
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
+
+rm -f $seqres.full
+
+workout()
+{
+	ops=$1
+	procs=$2
+	num_snapshots=$3
+
+	_scratch_mkfs >> $seqres.full 2>&1
+	_scratch_mount
+
+	snapshot_cmd="$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT"
+	snapshot_cmd="$snapshot_cmd $SCRATCH_MNT/snap_\`date +'%H_%M_%S_%N'\`"
+	run_check $FSSTRESS_PROG -p $procs \
+	    -x "$snapshot_cmd" -X $num_snapshots -d $SCRATCH_MNT -n $ops
+}
+
+ops=8000
+procs=4
+snapshots=100
+workout $ops $procs $snapshots
+
+# The fstests framework runs a file system check against the scratch device
+# automatically when a test case finishes (if the test calls _require_scratch).
+# That filesystem check (btrfsck, btrfs.fsck) failed reporting several fs
+# inconsistencies. Therefore there's no need to call _check_scratch_fs here.
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/078.out b/tests/btrfs/078.out
new file mode 100644
index 0000000..b8acea8
--- /dev/null
+++ b/tests/btrfs/078.out
@@ -0,0 +1,2 @@
+QA output created by 078
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 9adf862..40e7430 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -80,3 +80,4 @@
 075 auto quick subvol
 076 auto quick
 077 auto quick
+078 auto
-- 
1.9.1

