Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:57678 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752186AbbANB3f (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Tue, 13 Jan 2015 20:29:35 -0500
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2 2/2] fstests: add another generic test for fsync on inode with many hard links
Date: Wed, 14 Jan 2015 01:29:09 +0000
Message-Id: <1421198949-31137-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1421166664-15208-2-git-send-email-fdmanana@suse.com>
References: <1421166664-15208-2-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test is motivated by an fsync issue discovered in btrfs.
The steps to trigger the issue were:

1) remove an hard link from an inode with a large number of hard links;
2) add a new hard link;
3) add another hard link with the same name as the one removed in step 1;
4) fsync the inode.

These steps made the btrfs fsync log replay fail (with the -EOVERFLOW
error), making the filesystem unmountable, requiring the use of
btrfs-zero-log (it wipes the fsync log) in order to make the filesystem
mountable again (but losing some data/metadata).

The btrfs issue was fixed by the following linux kernel patches:

  Btrfs: fix fsync when extend references are added to an inode
  Btrfs: fix fsync log replay for inodes with a mix of regular refs and extrefs

This issue was present in btrfs since the extrefs (extend references)
feature was added (2012).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Updated the test to remove and add more links after the sync.
    This triggered an additional issue in btrfs that I failed to
    observe initially.

 tests/generic/041     | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/041.out |   3 ++
 tests/generic/group   |   1 +
 3 files changed, 137 insertions(+)
 create mode 100755 tests/generic/041
 create mode 100644 tests/generic/041.out

diff --git a/tests/generic/041 b/tests/generic/041
new file mode 100755
index 0000000..36a6f42
--- /dev/null
+++ b/tests/generic/041
@@ -0,0 +1,133 @@
+#! /bin/bash
+# FS QA Test No. 041
+#
+# This test is motivated by an fsync issue discovered in btrfs.
+# The steps to trigger the issue were:
+#
+# 1) remove an hard link from an inode with a large number of hard links;
+# 2) add a new hard link;
+# 3) add another hard link with the same name as the one removed in step 1;
+# 4) fsync the inode.
+#
+# These steps made the btrfs fsync log replay fail (with the -EOVERFLOW error),
+# making the filesystem unmountable, requiring the use of btrfs-zero-log (it
+# wipes the fsync log) in order to make the filesystem mountable again (but
+# losing some data/metadata).
+#
+# The btrfs issue was fixed by the following linux kernel patches:
+#
+#  Btrfs: fix fsync when extend references are added to an inode
+#  Btrfs: fix fsync log replay for inodes with a mix of regular refs and extrefs
+#
+# This issue was present in btrfs since the extrefs (extend references)
+# feature was added (2012).
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
+
+rm -f $seqres.full
+
+# If the test filesystem is btrfs, make sure we create a filesystem with
+# the extend references (extrefs) feature enabled (it's enabled by default
+# in recent versions of btrfs-progs).
+if [ "$FSTYP" = "btrfs" ]; then
+	_scratch_mkfs "-O extref" >> $seqres.full 2>&1
+else
+	_scratch_mkfs >> $seqres.full 2>&1
+fi
+
+_init_flakey
+_mount_flakey
+
+# Create a test file with 3001 hard links. This number is large enough to
+# make btrfs start using extrefs at some point even if the fs has the maximum
+# possible leaf/node size (64Kb).
+echo "hello world" > $SCRATCH_MNT/foo
+for i in `seq 1 3000`; do
+	ln $SCRATCH_MNT/foo $SCRATCH_MNT/foo_link_`printf "%04d" $i`
+done
+
+# Make sure all metadata and data are durably persisted.
+sync
+
+# Now remove one link, add a new one with a new name, add another new one with
+# the same name as the one we just removed and fsync the inode.
+rm -f $SCRATCH_MNT/foo_link_0001
+ln $SCRATCH_MNT/foo $SCRATCH_MNT/foo_link_3001
+ln $SCRATCH_MNT/foo $SCRATCH_MNT/foo_link_0001
+rm -f $SCRATCH_MNT/foo_link_0002
+ln $SCRATCH_MNT/foo $SCRATCH_MNT/foo_link_3002
+ln $SCRATCH_MNT/foo $SCRATCH_MNT/foo_link_3003
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
+
+# Simulate a crash/power loss. This makes sure the next mount
+# will see an fsync log and will replay that log.
+
+_load_flakey_table $FLAKEY_DROP_WRITES
+_unmount_flakey
+
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+# Check that the number of hard links is correct, we are able to remove all
+# the hard links and read the file's data. This is just to verify we don't
+# get stale file handle errors (due to dangling directory index entries that
+# point to inodes that no longer exist).
+echo "Link count: $(stat --format=%h $SCRATCH_MNT/foo)"
+[ -f $SCRATCH_MNT/foo ] || echo "Link foo is missing"
+for ((i = 1; i <= 3003; i++)); do
+	name=foo_link_`printf "%04d" $i`
+	if [ $i -eq 2 ]; then
+		[ -f $SCRATCH_MNT/$name ] && echo "Link $name found"
+	else
+		[ -f $SCRATCH_MNT/$name ] || echo "Link $name is missing"
+	fi
+done
+rm -f $SCRATCH_MNT/foo_link_*
+cat $SCRATCH_MNT/foo
+rm -f $SCRATCH_MNT/foo
+
+status=0
+exit
diff --git a/tests/generic/041.out b/tests/generic/041.out
new file mode 100644
index 0000000..577c525
--- /dev/null
+++ b/tests/generic/041.out
@@ -0,0 +1,3 @@
+QA output created by 041
+Link count: 3003
+hello world
diff --git a/tests/generic/group b/tests/generic/group
index 0ea8916..fb67b57 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -43,6 +43,7 @@
 038 auto stress
 039 metadata auto quick
 040 metadata auto quick
+041 metadata auto quick
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
2.1.3

