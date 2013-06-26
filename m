Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61166 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3FZWke (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 18:40:34 -0400
Message-ID: <51CB6DDE.8060509@gmail.com>
Date: Thu, 27 Jun 2013 00:40:30 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, Eric Sandeen <sandeen@sandeen.net>
CC: Mark Fasheh <mfasheh@suse.de>, linux-xfs@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [XFSTESTS PATCH] btrfs: Test deduplication
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
The matching kernel patch is here:
https://github.com/g2p/linux/tree/v3.10%2Bextent-same (rebased on 3.10, fixing a small conflict)
Requires the btrfs-extent-same command:

- http://permalink.gmane.org/gmane.comp.file-systems.btrfs/26579
- https://github.com/markfasheh/duperemove


 tests/btrfs/313     | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/313.out | 25 ++++++++++++++
 tests/btrfs/group   |  1 +
 3 files changed, 119 insertions(+)
 create mode 100755 tests/btrfs/313
 create mode 100644 tests/btrfs/313.out

diff --git a/tests/btrfs/313 b/tests/btrfs/313
new file mode 100755
index 0000000..04e4ccb
--- /dev/null
+++ b/tests/btrfs/313
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 313
+#
+# Test the deduplication syscall
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+. ./common/rc
+. ./common/filter
+
+ESAME=`set_prog_path btrfs-extent-same`
+
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_command $ESAME
+_require_command $XFS_IO_PROG
+_require_scratch
+
+_scratch_mkfs &>/dev/null
+_scratch_mount >>$seqres.full 2>&1
+
+fiemap() {
+    xfs_io -r -c fiemap $1 |tail -n+2
+}
+
+dedup() {
+    ! diff -q <(fiemap $1) <(fiemap $2)
+    $ESAME $(stat -c %s $1) $1 0 $2 0
+    diff -u <(fiemap $1) <(fiemap $2)
+}
+
+echo "Silence is golden"
+set -e
+
+v1=$SCRATCH_MNT/v1
+v2=$SCRATCH_MNT/v2
+v3=$SCRATCH_MNT/v3
+
+$BTRFS_UTIL_PROG subvolume create $v1
+$BTRFS_UTIL_PROG subvolume create $v2
+
+dd bs=1M status=none if=/dev/urandom of=$v1/file1 count=1
+dd bs=1M status=none if=/dev/urandom of=$v1/file2 count=1
+dd bs=1M status=none if=$v1/file1 of=$v2/file3
+dd bs=1M status=none if=$v1/file1 of=$v2/file4
+
+$BTRFS_UTIL_PROG subvolume snapshot -r $v2 $v3
+
+# identical, multiple volumes
+dedup $v1/file1 $v2/file3
+
+# not identical, same volume
+! $ESAME $((2**20)) $v1/file1 0 $v1/file2 0
+
+# identical, second file on a frozen volume
+dedup $v1/file1 $v3/file4
+
+_scratch_unmount
+_check_scratch_fs
+status=0
+exit
diff --git a/tests/btrfs/313.out b/tests/btrfs/313.out
new file mode 100644
index 0000000..eabe6be
--- /dev/null
+++ b/tests/btrfs/313.out
@@ -0,0 +1,25 @@
+QA output created by 313
+Silence is golden
+Create subvolume 'sdir/v1'
+Create subvolume 'sdir/v2'
+Create a readonly snapshot of 'sdir/v2' in 'sdir/v3'
+Files /dev/fd/63 and /dev/fd/62 differ
+Deduping 2 total files
+(0, 1048576): sdir/v1/file1
+(0, 1048576): sdir/v2/file3
+1 files asked to be deduped
+i: 0, status: 0, bytes_deduped: 1048576
+1048576 total bytes deduped in this operation
+Deduping 2 total files
+(0, 1048576): sdir/v1/file1
+(0, 1048576): sdir/v1/file2
+1 files asked to be deduped
+i: 0, status: 1, bytes_deduped: 0
+0 total bytes deduped in this operation
+Files /dev/fd/63 and /dev/fd/62 differ
+Deduping 2 total files
+(0, 1048576): sdir/v1/file1
+(0, 1048576): sdir/v3/file4
+1 files asked to be deduped
+i: 0, status: 0, bytes_deduped: 1048576
+1048576 total bytes deduped in this operation
diff --git a/tests/btrfs/group b/tests/btrfs/group
index bc6c256..4c868c8 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -7,5 +7,6 @@
 264 auto
 265 auto
 276 auto rw metadata
 284 auto
 307 auto quick
+313 auto
-- 
1.8.3.1.588.gb04834f

