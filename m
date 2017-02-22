Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34123 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934194AbdBVXH5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 18:07:57 -0500
Received: by mail-wr0-f196.google.com with SMTP id 89so2153089wrr.1
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 15:07:42 -0800 (PST)
From: Benedikt Morbach <benedikt.morbach@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Benedikt Morbach <benedikt.morbach@googlemail.com>
Subject: [PATCH/fstest] btrfs/139: correctly receive clones to mounted subvol
Date: Thu, 23 Feb 2017 00:07:35 +0100
Message-Id: <20170222230735.23437-1-benedikt.morbach@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

clone needs to resolve the paths of the involved subvolumes in the target
fs from their UUIDs. When doing so it might need to strip the prefix
that is mounted as the root of the fs from those paths.

It didn't do so correctly when processing the source of "clone" commands

This is a regression test for
    btrfs-progs: receive: handle root subvol path in clone
---

fstest for the patch mentioned above (see also https://mail-archive.com/linux-btrfs@vger.kernel.org/msg61848.html)

I thought I'd send this to linux-btrfs first as I'm not sure what the policy is
wrt submitting fstests aren't fixed upstream yet.

It's my first fstest and even though the other tests were helpful and it seems
to work, I still assume I've made a couple of mistakes here and there.

But it might be helpful to verify the issue the mentioned patch aims to solve.


 tests/btrfs/139     | 199 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/139.out |  16 +++++
 tests/btrfs/group   |   1 +
 3 files changed, 216 insertions(+)
 create mode 100755 tests/btrfs/139
 create mode 100644 tests/btrfs/139.out

diff --git a/tests/btrfs/139 b/tests/btrfs/139
new file mode 100755
index 00000000..f814eef0
--- /dev/null
+++ b/tests/btrfs/139
@@ -0,0 +1,199 @@
+#! /bin/bash
+# FS QA Test No. btrfs/139
+#
+# Test that an incremental send operation works when in both snapshots there are
+# two directory inodes that have the same number but different generations and
+# have an entry with the same name that corresponds to different inodes in each
+# snapshot.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2017 Benedikt Morbach. All Rights Reserved.
+# Author: Benedikt Morbach <benedikt.morbach@googlemail.com>
+# based on 'btrfs/135', which is:
+# Copyright (C) 2017 Synology Inc. All Rights Reserved.
+# Author: Robbie Ko <robbieko@synology.com>
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
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -fr $send_files_dir
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_test
+_require_scratch
+_require_cloner
+_require_fssum
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
+BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
+
+# create source fs
+
+$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/foo | _filter_scratch
+$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/bar | _filter_scratch
+$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/baz | _filter_scratch
+$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/snap | _filter_scratch
+
+$XFS_IO_PROG -s -f -c "pwrite -S 0xaa -b $((32 * $BLOCK_SIZE)) 0 $((32 * $BLOCK_SIZE))" \
+             $SCRATCH_MNT/foo/file_a | _filter_xfs_io_blocks_modified
+$XFS_IO_PROG -s -f -c "pwrite -S 0xbb -b $((32 * $BLOCK_SIZE)) 0 $((32 * $BLOCK_SIZE))" \
+             $SCRATCH_MNT/bar/file_b | _filter_xfs_io_blocks_modified
+
+$CLONER_PROG $SCRATCH_MNT/{foo/file_a,baz/file_a}
+$CLONER_PROG $SCRATCH_MNT/{bar/file_b,baz/file_b}
+
+# Filesystem looks like:
+#
+# .
+# |--- foo/
+# |       |--- file_a
+# |--- bar/
+# |       |--- file_b
+# |--- baz/
+# |       |--- file_a                   (clone of "foo/file_a")
+# |       |--- file_b                   (clone of "bar/file_b")
+# |--- snap/
+#
+
+# create snapshots and send streams
+
+$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT/foo \
+    $SCRATCH_MNT/snap/foo.0 > /dev/null
+
+$BTRFS_UTIL_PROG send $SCRATCH_MNT/snap/foo.0   \
+    -f $send_files_dir/foo.0.snap               \
+    2>&1 1>/dev/null | _filter_scratch
+
+$BTRFS_UTIL_PROG subvolume snapshot -r          \
+    $SCRATCH_MNT/bar $SCRATCH_MNT/snap/bar.0    \
+    > /dev/null
+
+$BTRFS_UTIL_PROG send $SCRATCH_MNT/snap/bar.0   \
+    -f $send_files_dir/bar.0.snap               \
+    2>&1 1>/dev/null | _filter_scratch
+
+$CLONER_PROG $SCRATCH_MNT/foo/file_a{,.clone}
+rm $SCRATCH_MNT/foo/file_a
+
+$BTRFS_UTIL_PROG subvolume snapshot -r          \
+    $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo.1    \
+    > /dev/null
+
+$BTRFS_UTIL_PROG send                           \
+    -p $SCRATCH_MNT/snap/foo.0                  \
+    -f $send_files_dir/foo.1.snap               \
+    $SCRATCH_MNT/snap/foo.1                     \
+    2>&1 1>/dev/null | _filter_scratch
+
+$BTRFS_UTIL_PROG subvolume snapshot -r          \
+    $SCRATCH_MNT/baz $SCRATCH_MNT/snap/baz.0    \
+    > /dev/null
+
+$BTRFS_UTIL_PROG send                           \
+    -p $SCRATCH_MNT/snap/foo.1                  \
+    -c $SCRATCH_MNT/snap/bar.0                  \
+    -f $send_files_dir/baz.0.snap               \
+    $SCRATCH_MNT/snap/baz.0                     \
+    2>&1 1>/dev/null | _filter_scratch
+
+# Filesystem looks like:
+#
+# .
+# |--- foo/
+# |       |--- file_a.clone             (clone of "foo/file_a")
+# |--- bar/
+# |       |--- file_b
+# |--- baz/
+# |       |--- file_a                   (clone of "foo/file_a")
+# |       |--- file_b                   (clone of "bar/file_b")
+# |--- snap/
+#          |--- bar.0/                  (snapshot of "bar")
+#          |         |--- file_b
+#          |--- foo.0/                  (snapshot of "foo")
+#          |         |--- file_a
+#          |--- foo.1/                  (snapshot of "foo")
+#          |         |--- file_a.clone
+#          |--- baz.0/                  (snapshot of "baz")
+#          |         |--- file_a
+#          |         |--- file_b
+
+run_check $FSSUM_PROG -A -f -w $send_files_dir/foo.0.fssum $SCRATCH_MNT/snap/foo.0
+run_check $FSSUM_PROG -A -f -w $send_files_dir/foo.1.fssum $SCRATCH_MNT/snap/foo.1
+run_check $FSSUM_PROG -A -f -w $send_files_dir/bar.0.fssum $SCRATCH_MNT/snap/bar.0
+run_check $FSSUM_PROG -A -f -w $send_files_dir/baz.0.fssum $SCRATCH_MNT/snap/baz.0
+
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/dest | _filter_scratch
+_scratch_unmount
+_scratch_mount -o subvol=/dest
+
+$BTRFS_UTIL_PROG receive            \
+    -f $send_files_dir/foo.0.snap   \
+    $SCRATCH_MNT                    \
+    2>&1 | _filter_scratch
+$BTRFS_UTIL_PROG receive            \
+    -f $send_files_dir/bar.0.snap   \
+    $SCRATCH_MNT                    \
+    2>&1 | _filter_scratch
+
+# if "dest/" is not correctly stripped from the beginning of the path to "foo.0" in the target fs,
+# we would get an error here because the clone source "foo.0/file_a" for "foo.1/file_a.clone" can't be found.
+$BTRFS_UTIL_PROG receive            \
+    -f $send_files_dir/foo.1.snap   \
+    $SCRATCH_MNT                    \
+    2>&1 | _filter_scratch
+
+# same here, but with send -c instead of -p
+$BTRFS_UTIL_PROG receive            \
+    -f $send_files_dir/baz.0.snap   \
+    $SCRATCH_MNT                    \
+    2>&1 | _filter_scratch
+
+run_check $FSSUM_PROG -r $send_files_dir/foo.0.fssum $SCRATCH_MNT/foo.0
+run_check $FSSUM_PROG -r $send_files_dir/foo.1.fssum $SCRATCH_MNT/foo.1
+run_check $FSSUM_PROG -r $send_files_dir/bar.0.fssum $SCRATCH_MNT/bar.0
+run_check $FSSUM_PROG -r $send_files_dir/baz.0.fssum $SCRATCH_MNT/baz.0
+
+status=0
+exit
diff --git a/tests/btrfs/139.out b/tests/btrfs/139.out
new file mode 100644
index 00000000..8271cd46
--- /dev/null
+++ b/tests/btrfs/139.out
@@ -0,0 +1,16 @@
+QA output created by 139
+Create subvolume 'SCRATCH_MNT/foo'
+Create subvolume 'SCRATCH_MNT/bar'
+Create subvolume 'SCRATCH_MNT/baz'
+Create subvolume 'SCRATCH_MNT/snap'
+Blocks modified: [0 - 31]
+Blocks modified: [0 - 31]
+At subvol SCRATCH_MNT/snap/foo.0
+At subvol SCRATCH_MNT/snap/bar.0
+At subvol SCRATCH_MNT/snap/foo.1
+At subvol SCRATCH_MNT/snap/baz.0
+Create subvolume 'SCRATCH_MNT/dest'
+At subvol foo.0
+At subvol bar.0
+At snapshot foo.1
+At snapshot baz.0
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 76a1181e..3bebffd0 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -141,3 +141,4 @@
 136 auto convert
 137 auto quick send
 138 auto compress
+139 auto quick send
-- 
2.11.1

