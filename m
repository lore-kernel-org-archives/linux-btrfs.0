Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58725 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaBQAgR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 19:36:17 -0500
Received: by mail-wi0-f171.google.com with SMTP id cc10so1887948wib.4
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 16:36:16 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] xfstests: add test for btrfs data corruption when using compression
Date: Mon, 17 Feb 2014 00:35:30 +0000
Message-Id: <1392597330-14200-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1391874609-19721-1-git-send-email-fdmanana@gmail.com>
References: <1391874609-19721-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test for a btrfs data corruption when using compressed files/extents.
Under certain cases, it was possible for reads to return random data
(content from a previously used page) instead of zeroes. This also
caused partial updates to those regions that were supposed to be filled
with zeroes to save random (and invalid) data into the file extents.

This is fixed by the commit for the linux kernel titled:

   Btrfs: fix data corruption when reading/updating compressed extents
   (https://patchwork.kernel.org/patch/3610391/)

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---

V2: Removed use of run_check with xfs_io and filter xfs_io instead.

 tests/btrfs/036     |  111 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/036.out |    3 ++
 tests/btrfs/group   |    1 +
 3 files changed, 115 insertions(+)
 create mode 100755 tests/btrfs/036
 create mode 100644 tests/btrfs/036.out

diff --git a/tests/btrfs/036 b/tests/btrfs/036
new file mode 100755
index 0000000..73e166c
--- /dev/null
+++ b/tests/btrfs/036
@@ -0,0 +1,111 @@
+#! /bin/bash
+# FS QA Test No. btrfs/036
+#
+# Test for a btrfs data corruption when using compressed files/extents.
+# Under certain cases, it was possible for reads to return random data
+# (content from a previously used page) instead of zeroes. This also
+# caused partial updates to those regions that were supposed to be filled
+# with zeroes to save random (and invalid) data into the file extents.
+#
+# This is fixed by the commit for the linux kernel titled:
+#
+#   Btrfs: fix data corruption when reading/updating compressed extents
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
+
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
+_need_to_be_root
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount "-o compress-force=lzo"
+
+$XFS_IO_PROG -f -c "pwrite -S 0x06 -b 18670 266978 18670" \
+    $SCRATCH_MNT/foobar | _filter_xfs_io
+$XFS_IO_PROG -c "falloc 26450 665194" $SCRATCH_MNT/foobar | _filter_xfs_io
+$XFS_IO_PROG -c "truncate 542872" $SCRATCH_MNT/foobar | _filter_xfs_io
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foobar | _filter_xfs_io
+
+# Expected file items in the fs tree are (from btrfs-debug-tree):
+#
+#   item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
+#       inode generation 6 transid 6 size 542872 block group 0 mode 100600
+#   item 5 key (257 INODE_REF 256) itemoff 15863 itemsize 16
+#       inode ref index 2 namelen 6 name: foobar
+#   item 6 key (257 EXTENT_DATA 0) itemoff 15810 itemsize 53
+#       extent data disk byte 0 nr 0 gen 6
+#       extent data offset 0 nr 24576 ram 266240
+#       extent compression 0
+#   item 7 key (257 EXTENT_DATA 24576) itemoff 15757 itemsize 53
+#       prealloc data disk byte 12849152 nr 241664 gen 6
+#       prealloc data offset 0 nr 241664
+#   item 8 key (257 EXTENT_DATA 266240) itemoff 15704 itemsize 53
+#       extent data disk byte 12845056 nr 4096 gen 6
+#       extent data offset 0 nr 20480 ram 20480
+#       extent compression 2
+#   item 9 key (257 EXTENT_DATA 286720) itemoff 15651 itemsize 53
+#       prealloc data disk byte 13090816 nr 405504 gen 6
+#       prealloc data offset 0 nr 258048
+#
+# The on disk extent at 266240, contains 5 compressed chunks of file data.
+# Each of the first 4 chunks compress 4096 bytes of file data, while the last
+# one compresses only 3024 bytes of file data. Because this extent item is not
+# the last one in the file, as it followed by a prealloc extent, reads into
+# the region [285648 ; 286720[ (length = 4096 - 3024) should return zeroes.
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+
+EXPECTED_MD5="b8b0dbb8e02f94123c741c23659a1c0a"
+
+for i in `seq 1 27`
+do
+    _scratch_mount "-o ro"
+    MD5=`md5sum $SCRATCH_MNT/foobar | cut -f 1 -d ' '`
+    _scratch_unmount
+    if [ "${MD5}x" != "${EXPECTED_MD5}x" ]
+    then
+	echo "Unexpected file digest (wanted $EXPECTED_MD5, got $MD5)"
+    fi
+done
+
+status=0
+exit
diff --git a/tests/btrfs/036.out b/tests/btrfs/036.out
new file mode 100644
index 0000000..6c06a86
--- /dev/null
+++ b/tests/btrfs/036.out
@@ -0,0 +1,3 @@
+QA output created by 036
+wrote 18670/18670 bytes at offset 266978
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index f9f062f..2ca2225 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -37,3 +37,4 @@
 032 auto quick
 033 auto quick
 034 auto quick
+036 auto quick
-- 
1.7.9.5

