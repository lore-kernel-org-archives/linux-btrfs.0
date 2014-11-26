Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:50029 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750892AbaKZPbT (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Wed, 26 Nov 2014 10:31:19 -0500
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: add btrfs test to stress chunk allocation/removal and fstrim
Date: Wed, 26 Nov 2014 15:30:39 +0000
Message-Id: <1417015839-26985-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stress btrfs' block group allocation and deallocation while running
fstrim in parallel. Part of the goal is also to get data block groups
deallocated so that new metadata block groups, using the same physical
device space ranges, get allocated while fstrim is running. This caused
several issues ranging from invalid memory accesses, kernel crashes,
metadata or data corruption, free space cache inconsistencies and free
space leaks.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/082     | 148 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/082.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 151 insertions(+)
 create mode 100755 tests/btrfs/082
 create mode 100644 tests/btrfs/082.out

diff --git a/tests/btrfs/082 b/tests/btrfs/082
new file mode 100755
index 0000000..8ac9f06
--- /dev/null
+++ b/tests/btrfs/082
@@ -0,0 +1,148 @@
+#! /bin/bash
+# FSQA Test No. 082
+#
+# Stress btrfs' block group allocation and deallocation while running fstrim in
+# parallel. Part of the goal is also to get data block groups deallocated so
+# that new metadata block groups, using the same physical device space ranges,
+# get allocated while fstrim is running. This caused several issues ranging
+# from invalid memory accesses, kernel crashes, metadata or data corruption,
+# free space cache inconsistencies and free space leaks.
+#
+# These issues were fixed by the following btrfs linux kernel patches:
+#
+#   Btrfs: fix invalid block group rbtree access after bg is removed
+#   Btrfs: fix crash caused by block group removal
+#   Btrfs: fix freeing used extents after removing empty block group
+#   Btrfs: fix race between fs trimming and block group remove/allocation
+#   Btrfs: fix race between writing free space cache and trimming
+#   Btrfs: make btrfs_abort_transaction consider existence of new block groups
+#
+# The issues were found on a qemu/kvm guest with 4 virtual CPUs, 4Gb of ram and
+# scsi-hd devices with discard support enabled (that means hole punching in the
+# disk's image file is performed by the host).
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
+tmp=/tmp/$$
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
+_require_scratch_nocheck
+_require_fstrim
+
+rm -f $seqres.full
+
+# Keep allocating and deallocating 2G of data space with the goal of creating
+# and deleting 2 block groups constantly. The intention is to race with the
+# fstrim loop below.
+fallocate_loop()
+{
+	local name=$1
+	while true; do
+		$XFS_IO_PROG -f -c "falloc -k 0 2G" \
+			$SCRATCH_MNT/$name &> /dev/null
+		sleep 3
+		$XFS_IO_PROG -c "truncate 0" \
+			$SCRATCH_MNT/$name &> /dev/null
+		sleep 3
+	done
+}
+
+trim_loop()
+{
+	while true; do
+		$FSTRIM_PROG $SCRATCH_MNT
+	done
+}
+
+# Create a bunch of small files that get their single extent inlined in the
+# btree, so that we consume a lot of metadata space and get a chance of a
+# data block group getting deleted and reused for metadata later. Sometimes
+# the creation of all these files succeeds other times we get ENOSPC failures
+# at some point - this depends on how fast the btrfs' cleaner kthread is
+# notified about empty block groups, how fast it deletes them and how fast
+# the fallocate calls happen. So we don't really care if they all succeed or
+# not, the goal is just to keep metadata space usage growing while data block
+# groups are deleted.
+create_files()
+{
+	local prefix=$1
+
+	for ((i = 1; i <= 400000; i++)); do
+		echo "Creating file ${prefix}_$i" >>$seqres.full 2>&1
+		$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 3900" \
+			$SCRATCH_MNT/"${prefix}_$i" >>$seqres.full 2>&1
+		ret=$?
+		if [ $ret -ne 0 ]; then
+			break
+		fi
+	done
+
+}
+
+fsz=`expr 40 \* 1024 \* 1024 \* 1024`
+_scratch_mkfs_sized $fsz >>$seqres.full 2>&1 || \
+	_fail "size=$fsz mkfs failed"
+_scratch_mount
+
+for ((i = 0; i < 4; i++)); do
+	trim_loop &
+	trim_pids[$i]=$!
+done
+
+fallocate_loop "falloc_file" &
+fallocate_pid=$!
+
+create_files "foobar"
+
+kill $fallocate_pid
+kill ${trim_pids[@]}
+wait
+
+# Sleep a bit, otherwise umount fails often with EBUSY (TODO: investigate why).
+sleep 3
+
+# Check for fs consistency. The trimming was racy and caused some btree nodes
+# to get full of zeroes on disk, which obviously caused fs metadata corruption.
+# The race often lead to missing free space entries in a block group's free
+# space cache too.
+_check_scratch_fs
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/082.out b/tests/btrfs/082.out
new file mode 100644
index 0000000..2977f14
--- /dev/null
+++ b/tests/btrfs/082.out
@@ -0,0 +1,2 @@
+QA output created by 082
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index e79b848..6608005 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -84,3 +84,4 @@
 079 auto
 080 auto
 081 auto quick
+082 auto
-- 
2.1.3

