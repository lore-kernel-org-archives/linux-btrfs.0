Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:55224 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754142AbbBOWkw (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Sun, 15 Feb 2015 17:40:52 -0500
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: generic test for fsync after punching hole
Date: Sun, 15 Feb 2015 22:39:12 +0000
Message-Id: <1424039952-9679-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test is motivated by an fsync issue discovered in btrfs.
The issue was that after punching a hole for a small range, which
affected only a partial page, an fsync operation would have no effect
at all. This was because for this particular case the btrfs hole
punching implementation did not update some btrfs specific inode
metadata that is required to determine if an fsync operation needs
to update the fsync log. For this to happen, it was also necessary
that in the transaction where the hole punching was performed, and
before the fsync operation, no other operation that modified the file
(or its metadata) was performed.

The btrfs issue was fixed by the following linux kernel patch:

  Btrfs: add missing inode update when punching hole

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/045     | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/045.out |  31 +++++++++++++
 tests/generic/group   |   1 +
 3 files changed, 152 insertions(+)
 create mode 100755 tests/generic/045
 create mode 100644 tests/generic/045.out

diff --git a/tests/generic/045 b/tests/generic/045
new file mode 100755
index 0000000..d75b6b1
--- /dev/null
+++ b/tests/generic/045
@@ -0,0 +1,120 @@
+#! /bin/bash
+# FS QA Test No. 045
+#
+# This test is motivated by an fsync issue discovered in btrfs.
+# The issue was that after punching a hole for a small range, which affected
+# only a partial page, an fsync operation would have no effect at all. This was
+# because for this particular case the btrfs hole punching implementation did
+# not update some btrfs specific inode metadata that is required to determine
+# if an fsync operation needs to update the fsync log. For this to happen, it
+# was also necessary that in the transaction where the hole punching was
+# performed, and before the fsync operation, no other operation that modified
+# the file (or its metadata) was performed.
+#
+# The btrfs issue was fixed by the following linux kernel patch:
+#
+#  Btrfs: add missing inode update when punching hole
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2015 SUSE Linux Products GmbH. All Rights Reserved.
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
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+	_cleanup_flakey
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+_require_dm_flakey
+_require_xfs_io_command "fpunch"
+
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1
+_init_flakey
+_mount_flakey
+
+# Create our test file.
+$XFS_IO_PROG -f -c "pwrite -S 0x22 -b 16K 0 16K" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+# Fsync the file, this makes btrfs update some btrfs inode specific fields
+# that are used to track if the inode needs to be written/updated to the fsync
+# log or not. After this fsync, the new values for those fields indicate that
+# a subsequent fsync does not need to touch the fsync log.
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
+
+# Force a commit of the current transaction. After this point, any operation
+# that modifies the data or metadata of our file, should update those fields in
+# the btrfs inode with values that make the next fsync operation write to the
+# fsync log.
+sync
+
+# Punch a hole in our file. This small range affects only 1 page.
+# This made the btrfs hole punching implementation write only some zeroes in
+# one page, but it did not update the btrfs inode fields used to determine if
+# the next fsync needs to write to the fsync log.
+$XFS_IO_PROG -c "fpunch 8000 4K" $SCRATCH_MNT/foo
+
+# Another variation of the previously mentioned case.
+$XFS_IO_PROG -c "fpunch 15000 100" $SCRATCH_MNT/foo
+
+# Now fsync the file. This was a no-operation because the previous hole punch
+# operation didn't update the inode's fields mentioned before, so they remained
+# with the values they had after the first fsync - that is, they indicate that
+# it is not needed to write to fsync log.
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
+
+echo "File content before:"
+od -t x1 $SCRATCH_MNT/foo
+
+# Simulate a crash/power loss.
+_load_flakey_table $FLAKEY_DROP_WRITES
+_unmount_flakey
+
+# Enable writes and mount the fs. This makes the fsync log replay code run.
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+# Because the last fsync didn't do anything, here the file content matched what
+# it was after the first fsync, before the holes were punched, and not what it
+# was after the holes were punched.
+echo "File content after:"
+od -t x1 $SCRATCH_MNT/foo
+
+status=0
+exit
diff --git a/tests/generic/045.out b/tests/generic/045.out
new file mode 100644
index 0000000..820e7ce
--- /dev/null
+++ b/tests/generic/045.out
@@ -0,0 +1,31 @@
+QA output created by 045
+wrote 16384/16384 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File content before:
+0000000 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22
+*
+0017500 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0027500 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22
+*
+0035220 22 22 22 22 22 22 22 22 00 00 00 00 00 00 00 00
+0035240 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0035360 00 00 00 00 00 00 00 00 00 00 00 00 22 22 22 22
+0035400 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22
+*
+0040000
+File content after:
+0000000 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22
+*
+0017500 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0027500 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22
+*
+0035220 22 22 22 22 22 22 22 22 00 00 00 00 00 00 00 00
+0035240 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0035360 00 00 00 00 00 00 00 00 00 00 00 00 22 22 22 22
+0035400 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22 22
+*
+0040000
diff --git a/tests/generic/group b/tests/generic/group
index dc16972..6ab4447 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -47,6 +47,7 @@
 042 metadata auto quick
 043 metadata auto quick
 044 metadata auto quick
+045 metadata auto quick
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
2.1.3

