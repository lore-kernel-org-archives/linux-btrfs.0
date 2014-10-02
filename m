Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:60440 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaJBRT6 (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 2 Oct 2014 13:19:58 -0400
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: regression test for btrfs incremental send
Date: Thu,  2 Oct 2014 19:18:45 +0100
Message-Id: <1412273925-23182-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a regression test for a btrfs incremental send issue.
If between two snapshots we rename an existing directory named X to Y and
make it a child (direct or not) of a new inode named X, we were delaying
the move/rename of the former directory unnecessarily, which would result
in attempting to rename the new directory from its orphan name to name X
prematurely. This made btrfs receive fail with an error message like the
following:

   rename o261-7-0 -> merlin/RC/OSD failed

This issue was a regression in the 3.16 kernel and got fixed by the
following linux kernel btrfs patch:

   Btrfs: send, don't delay dir move if there's a new parent inode

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/060     | 148 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/060.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 151 insertions(+)
 create mode 100755 tests/btrfs/060
 create mode 100644 tests/btrfs/060.out

diff --git a/tests/btrfs/060 b/tests/btrfs/060
new file mode 100755
index 0000000..20dc0ad
--- /dev/null
+++ b/tests/btrfs/060
@@ -0,0 +1,148 @@
+#! /bin/bash
+# FS QA Test No. btrfs/060
+#
+# Regression test for a btrfs incremental send issue.
+# If between two snapshots we rename an existing directory named X to Y and
+# make it a child (direct or not) of a new inode named X, we were delaying
+# the move/rename of the former directory unnecessarily, which would result
+# in attempting to rename the new directory from its orphan name to name X
+# prematurely. This made btrfs receive fail with an error message like the
+# following:
+#
+#   rename o261-7-0 -> merlin/RC/OSD failed
+#
+# This issue was a regression in the 3.16 kernel and got fixed by the following
+# linux kernel btrfs patch:
+#
+#   Btrfs: send, don't delay dir move if there's a new parent inode
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
+tmp=`mktemp -d`
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
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+mkdir -p $SCRATCH_MNT/merlin/RC/OSD/Source
+mkdir -p $SCRATCH_MNT/fdm/RCz/OSDz/Sourcez
+mkdir -p $SCRATCH_MNT/Z/Z2
+
+# Filesystem looks like:
+#
+# .                                                 (ino 256)
+# |---- merlin/                                     (ino 257)
+# |        |---- RC/                                (ino 258)
+# |              |----- OSD/                        (ino 259)
+# |                      |---- Source/              (ino 260)
+# |
+# |---- fdm/                                        (ino 261)
+# |       |---- RCz/                                (ino 262)
+# |             |----- OSDz/                        (ino 263)
+# |                     |---- Sourcez/              (ino 264)
+# |
+# |---- Z/                                          (ino 265)
+#       |---- Z2/                                   (ino 266)
+#
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+mkdir $SCRATCH_MNT/OSD
+mv $SCRATCH_MNT/merlin/RC/OSD $SCRATCH_MNT/OSD/OSD-Plane_788
+mv $SCRATCH_MNT/OSD $SCRATCH_MNT/merlin/RC
+
+mkdir $SCRATCH_MNT/OSDz
+mv $SCRATCH_MNT/Z/Z2 $SCRATCH_MNT/OSDz/xz2
+mv $SCRATCH_MNT/Z $SCRATCH_MNT/OSDz/xz2/xz
+mv $SCRATCH_MNT/fdm/RCz/OSDz $SCRATCH_MNT/OSDz/xz2/xz/OSD-Plane_788z
+mv $SCRATCH_MNT/OSDz $SCRATCH_MNT/fdm/RCz
+
+# Filesystem now looks like:
+#
+#
+# .                                                                  (ino 256)
+# |---- merlin/                                                      (ino 257)
+# |       |---- RC/                                                  (ino 258)
+# |             |----- OSD/                                     (ino 267) (new)
+# |                     |---- OSD-Plane_788/                         (ino 259)
+# |                                    |---- Source/                 (ino 260)
+# |
+# |---- fdm/                                                         (ino 261)
+#         |---- RCz/                                                 (ino 262)
+#                |----- OSDz/                                   (ino 268) (new)
+#                        |--- xz2/                                   (ino 266)
+#                              |---- xz/                             (ino 265)
+#                                    |---- OSD-Plane_788z/           (ino 263)
+#                                                    |---- Sourcez/  (ino 264)
+#
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+run_check $FSSUM_PROG -A -f -w $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+run_check $FSSUM_PROG -A -f -w $send_files_dir/2.fssum \
+	-x $SCRATCH_MNT/mysnap2/mysnap1 $SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+	-f $send_files_dir/2.snap
+
+_check_scratch_fs
+
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+run_check $FSSUM_PROG -r $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
+run_check $FSSUM_PROG -r $send_files_dir/2.fssum $SCRATCH_MNT/mysnap2
+
+echo "Silence is golden"
+
+status=0
+exit
diff --git a/tests/btrfs/060.out b/tests/btrfs/060.out
new file mode 100644
index 0000000..8ffce4d
--- /dev/null
+++ b/tests/btrfs/060.out
@@ -0,0 +1,2 @@
+QA output created by 060
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 68b5c79..d06c163 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -62,3 +62,4 @@
 057 auto quick
 058 auto quick
 059 auto quick
+060 auto quick
-- 
1.9.1

