Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:40575 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932098AbaJUJOx (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Tue, 21 Oct 2014 05:14:53 -0400
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: btrfs, add test for snapshoting after file write + truncate
Date: Tue, 21 Oct 2014 11:13:09 +0100
Message-Id: <1413886389-16144-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for a btrfs issue where if right after the snapshot
creation ioctl started, a file write followed by a file truncate
happened, with both operations increasing the file's size, the created
snapshot would capture an inconsistent state of the file system tree.
That state reflected the file truncation but it didn't reflect the
write operation, and left a gap between two file extent items (and
that gap corresponded to the total or a partial area of the write
operation's range).

This issue was fixed by the following linux kernel patch:

    Btrfs: fix snapshot inconsistency after a file write followed by truncate

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/080     | 152 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/080.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 155 insertions(+)
 create mode 100755 tests/btrfs/080
 create mode 100644 tests/btrfs/080.out

diff --git a/tests/btrfs/080 b/tests/btrfs/080
new file mode 100755
index 0000000..a73e534
--- /dev/null
+++ b/tests/btrfs/080
@@ -0,0 +1,152 @@
+#! /bin/bash
+# FSQA Test No. 080
+#
+# Regression test for a btrfs issue where if right after the snapshot creation
+# ioctl started, a file write followed by a file truncate happened, with both
+# operations increasing the file's size, the created snapshot would capture an
+# inconsistent state of the file system tree. That state reflected the file
+# truncation but it didn't reflect the write operation, and left a gap between
+# two file extent items (and that gap corresponded to the total or a partial
+# area of the write operation's range).
+#
+# This issue was fixed by the following linux kernel patch:
+#
+#     Btrfs: fix snapshot inconsistency after a file write followed by truncate
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
+_require_scratch_nocheck
+
+rm -f $seqres.full
+
+create_snapshots()
+{
+	count=$1
+	ts=`date +'%H_%M_%S_%N'`
+
+	for ((i = 1; i <= $count; i++)); do
+		_run_btrfs_util_prog subvolume snapshot -r \
+			$SCRATCH_MNT $SCRATCH_MNT/"${ts}_snap_$i"
+	done
+}
+
+create_file()
+{
+	name=$1
+
+	run_check $XFS_IO_PROG -f \
+		-c "pwrite -S 0xaa -b 32K 0 32K" \
+		-c "fsync" \
+		-c "pwrite -S 0xbb -b 32770 16K 32770" \
+		-c "truncate 90123" \
+		$SCRATCH_MNT/$name
+}
+
+workout()
+{
+	name=$1
+	snapshots=$2
+
+	create_file $name &
+	fpid=$!
+	create_snapshots $snapshots &
+	spid=$!
+	wait $fpid
+	create_ret=$?
+	wait $spid
+	snap_ret=$?
+	if [ $create_ret != 0 -o $snap_ret != 0 ]; then
+		_fail "Failure creating file or snapshots, check $seqres.full for details"
+	fi
+}
+
+# If the installed btrfs mkfs supports the no-holes feature, make sure the
+# created fs doesn't get that feature enabled. With it enabled, the below fsck
+# call wouldn't fail. This feature hasn't been enabled by default since it was
+# introduced, but be safe and explicitly disable it.
+_scratch_mkfs -O list-all 2>&1 | grep -q '\bno\-holes\b'
+if [ $? -eq 0 ]; then
+	mkfs_options="-O ^no-holes"
+fi
+_scratch_mkfs "$mkfs_options" >>$seqres.full 2>&1
+
+_scratch_mount
+for ((i = 1; i <= 100; i++)); do
+	workout "foobar_$i" 1
+done
+
+for f in $(find $SCRATCH_MNT -name 'foobar_*'); do
+	digest=`md5sum $f | cut -d ' ' -f 1`
+	case $digest in
+	"d41d8cd98f00b204e9800998ecf8427e")
+		# ok, empty file
+		;;
+	"c28418534a020122aca59fd3ff9581b5")
+		# ok, only first write captured
+		;;
+	"cd0032da89254cdc498fda396e6a9b54")
+		# ok, only 2 first writes captured
+		;;
+	"a1963f914baf4d2579d643425f4e54bc")
+		# ok, the 2 writes and the truncate were captured
+		;;
+	*)
+		# not ok, truncate captured but not one or both writes
+		_fail "Unexpected digest for file $f"
+	esac
+done
+
+# Check the filesystem for inconsistencies.
+# Before the btrfs kernel fix mentioned above, we would very often get fsck
+# error messages like: "root 306 inode 338 errors 100, file extent discount".
+#
+# This was because if right after the snapshot creation ioctl started, a file
+# write followed by a file truncate, with both operations increasing the file's
+# size, we would get a snapshot that reflected a state where the file truncation
+# was visible but the previous file write was not visible, breaking expected
+# total ordering of operations and causing a gap between 2 file extents, where a
+# file extent item representing the range [32K .. ALIGN(16K + 32770, 4096)] was
+# missing in the snapshot's btree.
+_check_scratch_fs
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/080.out b/tests/btrfs/080.out
new file mode 100644
index 0000000..11a4a1a
--- /dev/null
+++ b/tests/btrfs/080.out
@@ -0,0 +1,2 @@
+QA output created by 080
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 40e7430..801fc73 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -81,3 +81,4 @@
 076 auto quick
 077 auto quick
 078 auto
+080 auto
-- 
1.9.1

