Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:64386 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaAWXi3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 18:38:29 -0500
Received: by mail-we0-f182.google.com with SMTP id w62so1940170wes.41
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jan 2014 15:38:27 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v3] xfstests: add test for btrfs incremental send infinite loop issue
Date: Thu, 23 Jan 2014 23:38:00 +0000
Message-Id: <1390520280-19282-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1390348610-8098-1-git-send-email-fdmanana@gmail.com>
References: <1390348610-8098-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for btrfs' incremental send feature:

1) Create several nested directories;

2) Create a read only snapshot;

3) Change the parentship of some of the deepest directories in a reverse
   way, so that parents become children and children become parents;

4) Create another read only snapshot and use it for an incremental send
   relative to the first snapshot.

At step 4 btrfs' send entered an infinite loop, increasing the memory it
used while building path strings until a krealloc was unable to allocate
more memory, which caused a warning dump in dmesg.

The following linux kernel patch fixes this issue.

   Btrfs: fix infinite path build loops in incremental send
   (https://patchwork.kernel.org/patch/3522361/)

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Updated test to trigger one more code path in the corresponding
    btrfs linux kernel patch that fixes this issue.
V3: Addressed Josef's comments, make the test not depend on 'btrfs send'
    and fssum output, as it changed often in the past and can change again.

 tests/btrfs/030     |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/030.out |    1 +
 tests/btrfs/group   |    1 +
 3 files changed, 151 insertions(+)
 create mode 100755 tests/btrfs/030
 create mode 100644 tests/btrfs/030.out

diff --git a/tests/btrfs/030 b/tests/btrfs/030
new file mode 100755
index 0000000..6678ed8
--- /dev/null
+++ b/tests/btrfs/030
@@ -0,0 +1,149 @@
+#! /bin/bash
+# FS QA Test No. btrfs/030
+#
+# Regression test for btrfs' incremental send feature:
+#
+# 1) Create several nested directories;
+# 2) Create a read only snapshot;
+# 3) Change the parentship of some of the deepest directories in a reverse
+#    way, so that parents become children and children become parents;
+# 4) Create another read only snapshot and use it for an incremental send
+#    relative to the first snapshot.
+#
+# At step 4 btrfs' send entered an infinite loop, increasing the memory it
+# used while building path strings until a krealloc was unable to allocate
+# more memory, which caused a warning dump in dmesg.
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
+here=`pwd`
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
+_need_to_be_root
+
+FSSUM_PROG=$here/src/fssum
+[ -x $FSSUM_PROG ] || _notrun "fssum not built"
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+
+mkdir -p $SCRATCH_MNT/a/b/c
+echo "hello" > $SCRATCH_MNT/a/b/c/file.txt
+mkdir $SCRATCH_MNT/a/b/c/d
+mkdir $SCRATCH_MNT/a/b/c2
+mkdir $SCRATCH_MNT/a/b/www
+echo "hey" > $SCRATCH_MNT/a/b/foobar.txt
+mkdir -p $SCRATCH_MNT/a/b/c3/x/y
+
+# Directory tree looks like:
+#
+# .                         (ino 256)
+# |-- a/                    (ino 257)
+#     |-- b/                (ino 258)
+#         |-- c/            (ino 259)
+#         |   |-- file.txt  (ino 260)
+#         |   |-- d/        (ino 261)
+#         |
+#         |-- c2/           (ino 262)
+#         |-- www/          (ino 263)
+#         |-- foobar.txt    (ino 264)
+#         |
+#         |-- c3/           (ino 265)
+#             |-- x/        (ino 266)
+#                 |-- y/    (ino 267)
+
+run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+    $SCRATCH_MNT/mysnap1
+
+echo " world" >> $SCRATCH_MNT/a/b/c/file.txt
+mv $SCRATCH_MNT/a/b/c/d $SCRATCH_MNT/a/b/c2/d2
+mv $SCRATCH_MNT/a/b/c $SCRATCH_MNT/a/b/c2/d2/cc
+mv $SCRATCH_MNT/a/b/c3/x/y $SCRATCH_MNT/a/b/c2/y2
+mv $SCRATCH_MNT/a/b/c3/x $SCRATCH_MNT/a/b/c2/y2/x2
+mv $SCRATCH_MNT/a/b/c3 $SCRATCH_MNT/a/b/c2/y2/x2/Z
+mv $SCRATCH_MNT/a/b/www $SCRATCH_MNT/a/b/c2/y2/x2/WWW
+mv $SCRATCH_MNT/a/b/foobar.txt $SCRATCH_MNT/a/b/c2/y2/x2/qwerty.txt
+ln $SCRATCH_MNT/a/b/c2/d2/cc/file.txt $SCRATCH_MNT/a/b/c2/y2/x2/Z/file_link.txt
+mv $SCRATCH_MNT/a/b/c2/d2/cc/file.txt $SCRATCH_MNT/a/b/c2/y2/x2
+
+# Directory tree now looks like:
+#
+# .                                         (ino 256)
+# |-- a/                                    (ino 257)
+#     |-- b/                                (ino 258)
+#         |-- c2/                           (ino 262)
+#             |-- d2/                       (ino 261)
+#             |   |-- cc/                   (ino 259)
+#             |        |-- file.txt         (ino 260)
+#             |-- y2/                       (ino 267)
+#                 |-- x2/                   (ino 266)
+#                     |-- qwerty.txt        (ino 264)
+#                     |-- WWW/              (ino 263)
+#                     |-- Z/                (ino 265)
+#                         |-- file_link.txt
+
+run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+    $SCRATCH_MNT/mysnap2
+
+run_check $FSSUM_PROG -A -f -w $tmp/1.fssum $SCRATCH_MNT/mysnap1
+run_check $FSSUM_PROG -A -f -w $tmp/2.fssum -x $SCRATCH_MNT/mysnap2/mysnap1 \
+    $SCRATCH_MNT/mysnap2
+
+run_check $BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
+run_check $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+    -f $tmp/2.snap
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/1.snap
+run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1 2>> $seqres.full
+
+run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/2.snap
+run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2 2>> $seqres.full
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+
+status=0
+exit
diff --git a/tests/btrfs/030.out b/tests/btrfs/030.out
new file mode 100644
index 0000000..d0fe5a9
--- /dev/null
+++ b/tests/btrfs/030.out
@@ -0,0 +1 @@
+QA output created by 030
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 8eb8c4f..3f61799 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -32,3 +32,4 @@
 027 auto quick
 028 auto quick
 029 auto quick
+030 auto quick
-- 
1.7.9.5

