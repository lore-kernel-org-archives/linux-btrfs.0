Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbbCYS6V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 14:58:21 -0400
Message-ID: <55130547.6090907@suse.com>
Date: Wed, 25 Mar 2015 14:58:15 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: fstests@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: xfstests: btrfs: test for orphan item cleanup
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test tests three conditions where orphan items need to be cleaned up:
1) Default subvolume is fs tree root (mkfs default)
2) Default subvolume has been set explicitly to another subvolume (set-default)
3) Looking up a subvolume during a traversal

In the kernel, these three cases use separate mechanisms to look up
the subvolumes. There was a bug in the kernel where case #2 wasn't getting
handled and so orphan items would never be cleaned up if the default
subvolume was explicitly set. This issue was fixed with the upstream commit:
btrfs: cleanup orphans while looking up default subvolume

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 tests/btrfs/083     | 155 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/083.out |   5 ++
 tests/btrfs/group   |   1 +
 3 files changed, 161 insertions(+)
 create mode 100755 tests/btrfs/083
 create mode 100644 tests/btrfs/083.out

diff --git a/tests/btrfs/083 b/tests/btrfs/083
new file mode 100755
index 0000000..12416d9
--- /dev/null
+++ b/tests/btrfs/083
@@ -0,0 +1,155 @@
+#!/bin/bash
+# FS QA Test No. btrfs/083
+#
+# Tests to ensure that orphan items are properly created and cleaned up
+# on next mount.
+#
+# There are three cases where orphan items may be cleaned up:
+# 1) Default subvolume is fs tree root (mkfs default)
+# 2) Default subvolume is explicitly created subvolume
+#    (i.e. btrfs subvol set-default)
+# 3) Non-default subvolume lookup
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 SUSE.  All Rights Reserved.
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
+#
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
+
+_cleanup()
+{
+    _cleanup_flakey
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_dm_flakey
+_need_to_be_root
+
+rm -f $seqres.full
+
+has_orphan_item() {
+	INO=$1
+	if btrfs-debug-tree $SCRATCH_DEV | \
+		grep -q "key (ORPHAN ORPHAN_ITEM $INO)"; then
+		return 0
+	fi
+	return 1
+}
+
+test_orphan() {
+	PRECMD=$1
+	SUB=0
+
+	_scratch_mkfs >> $seqres.full 2>&1
+	_init_flakey
+
+	_mount_flakey
+
+	$PRECMD
+
+	TESTPATH=$SCRATCH_MNT/testdir/testfile
+	DIR=$(dirname $TESTPATH)
+
+	[ -d "$DIR" ] || mkdir -p $DIR
+
+	SIZE=$(( 1024 * 1024 ))
+	run_check dd if=/dev/zero of=$TESTPATH bs=$SIZE count=1
+
+	INO=$(stat -c %i $TESTPATH)
+
+	# Orphan item won't be created if the file doesn't make it to disk
+	sync
+
+	# Open and delete the file
+	exec 27<$TESTPATH
+	rm -f $TESTPATH
+
+	# Ensure the unlink (and orphan item creation) hits the disk
+	sync
+
+	# Turn off writes before closing so the orphan item will be left behind
+	_load_flakey_table $FLAKEY_DROP_WRITES
+
+	# Close the file so we can umount
+	exec 27>&-
+
+	# Orphan item should be on disk if operating correctly
+	_unmount_flakey
+	_load_flakey_table $FLAKEY_ALLOW_WRITES
+	if ! has_orphan_item $INO; then
+		echo "ERROR: No orphan item found after umount."
+		return
+	fi
+	_mount_flakey
+
+	# If $DIR is a subvolume, this will cause a lookup and orphan cleanup
+	(cd $DIR; true)
+
+	# Orphan item will be cleaned up during mount but won't be on
+	# disk until there's a sync.
+	sync
+
+	_unmount_flakey
+	if has_orphan_item $INO; then
+		echo "ERROR: Orphan item found after successful mount/sync."
+	fi
+	_cleanup_flakey
+}
+
+new_subvolume() {
+	_run_btrfs_util_prog subvol create $SCRATCH_MNT/testdir
+}
+
+new_default() {
+	new_subvolume
+	SUB=$(btrfs subvol list $SCRATCH_MNT |awk '{print $2}')
+	_run_btrfs_util_prog subvol set-default $SUB $SCRATCH_MNT
+
+	_unmount_flakey
+	_mount_flakey
+}
+
+echo "Testing with fs root as default subvolume"
+test_orphan true
+
+echo "Testing with explicit default subvolume"
+test_orphan new_default
+
+echo "Testing with orphan on non-default subvolume"
+test_orphan new_subvolume
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/083.out b/tests/btrfs/083.out
new file mode 100644
index 0000000..c3c99f1
--- /dev/null
+++ b/tests/btrfs/083.out
@@ -0,0 +1,5 @@
+QA output created by 083
+Testing with fs root as default subvolume
+Testing with explicit default subvolume
+Testing with orphan on non-default subvolume
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index fd2fa76..c48fc0c 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -85,3 +85,4 @@
 080 auto snapshot
 081 auto quick clone
 082 auto quick remount
+083 auto quick metadata subvol
-- 
1.8.5.2


-- 
Jeff Mahoney
SUSE Labs
