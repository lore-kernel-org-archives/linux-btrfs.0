Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41913 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbaCMMLG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 08:11:06 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi5so3783122wib.5
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Mar 2014 05:11:04 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH RESEND] xfstests: add regression test for btrfs incremental send
Date: Thu, 13 Mar 2014 12:10:42 +0000
Message-Id: <1394712642-9256-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for a btrfs incremental send issue where invalid paths for
utimes, chown and chmod operations were sent to the send stream, causing
btrfs receive to fail.

If a directory had a move/rename operation delayed, and none of its parent
directories, except for the immediate one, had delayed move/rename operations,
after processing the directory's references, the incremental send code would
issue invalid paths for utimes, chown and chmod operations.

This issue is fixed by the following linux kernel btrfs patch:

    Btrfs: fix send issuing outdated paths for utimes, chown and chmod

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---

Resending since Dave Chinner asked to do it for any patches he might have
missed in his last merge.

Originally submitted with the title:
    "xfstests: add test btrfs/042 for btrfs incremental send"

 tests/btrfs/044     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/044.out |    1 +
 tests/btrfs/group   |    1 +
 3 files changed, 131 insertions(+)
 create mode 100644 tests/btrfs/044
 create mode 100644 tests/btrfs/044.out

diff --git a/tests/btrfs/044 b/tests/btrfs/044
new file mode 100644
index 0000000..dae189e
--- /dev/null
+++ b/tests/btrfs/044
@@ -0,0 +1,129 @@
+#! /bin/bash
+# FS QA Test No. btrfs/044
+#
+# Regression test for a btrfs incremental send issue where under certain
+# scenarios invalid paths for utimes, chown and chmod operations were sent
+# to the send stream, causing btrfs receive to fail.
+#
+# If a directory had a move/rename operation delayed, and none of its parent
+# directories, except for the immediate one, had delayed move/rename operations,
+# after processing the directory's references, the incremental send code would
+# issue invalid paths for utimes, chown and chmod operations.
+#
+# This issue is fixed by the following linux kernel btrfs patch:
+#
+#   Btrfs: fix send issuing outdated paths for utimes, chown and chmod
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
+tmp=`mktemp -d`
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
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
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+umask 0
+mkdir -p $SCRATCH_MNT/a/b/c/d/e
+mkdir $SCRATCH_MNT/a/b/c/f
+echo 'ola ' > $SCRATCH_MNT/a/b/c/d/e/file.txt
+chmod 0777 $SCRATCH_MNT/a/b/c/d/e
+
+# Filesystem looks like:
+#
+# .                                   (ino 256)
+# |-- a/                              (ino 257)
+#     |-- b/                          (ino 258)
+#         |-- c/                      (ino 259)
+#             |-- d/                  (ino 260)
+#             |   |-- e/              (ino 261)
+#             |       |-- file.txt    (ino 262)
+#             |
+#             |-- f/                  (ino 263)
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+echo 'mundo' >> $SCRATCH_MNT/a/b/c/d/e/file.txt
+mv $SCRATCH_MNT/a/b/c/d/e/file.txt $SCRATCH_MNT/a/b/c/d/e/file2.txt
+mv $SCRATCH_MNT/a/b/c/f $SCRATCH_MNT/a/b/f2
+mv $SCRATCH_MNT/a/b/c/d/e $SCRATCH_MNT/a/b/f2/e2
+mv $SCRATCH_MNT/a/b/c $SCRATCH_MNT/a/b/c2
+mv $SCRATCH_MNT/a/b/c2/d $SCRATCH_MNT/a/b/c2/d2
+chmod 0700 $SCRATCH_MNT/a/b/f2/e2
+
+# Filesystem now looks like:
+#
+# .                              (ino 256)
+# |-- a/                         (ino 257)
+#     |-- b/                     (ino 258)
+#         |-- c2/                (ino 259)
+#         |   |-- d2/            (ino 260)
+#         |
+#         |-- f2/                (ino 263)
+#             |-- e2             (ino 261)
+#                 |-- file2.txt  (ino 263)
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+run_check $FSSUM_PROG -A -f -w $tmp/1.fssum $SCRATCH_MNT/mysnap1
+run_check $FSSUM_PROG -A -f -w $tmp/2.fssum -x $SCRATCH_MNT/mysnap2/mysnap1 \
+	$SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+	-f $tmp/2.snap
+
+_check_scratch_fs
+
+_scratch_unmount
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/1.snap
+run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/2.snap
+run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2
+
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/btrfs/044.out b/tests/btrfs/044.out
new file mode 100644
index 0000000..ef9885b
--- /dev/null
+++ b/tests/btrfs/044.out
@@ -0,0 +1 @@
+QA output created by 044
diff --git a/tests/btrfs/group b/tests/btrfs/group
index fabe3b5..4589043 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -46,3 +46,4 @@
 041 auto quick
 042 auto quick
 043 auto quick
+044 auto quick
-- 
1.7.10.4

