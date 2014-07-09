Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaGIWlw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Jul 2014 18:41:52 -0400
Date: Wed, 9 Jul 2014 15:41:50 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
Subject: [PATCH] xfstests/btrfs: add test for quota groups and drop snapshot
Message-ID: <20140709224150.GA5484@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test btrfs quota group consistency operations during snapshot delete.  Btrfs
has had long standing issues with drop snapshot failing to properly account
for quota groups. This test crafts a snapshot tree with shared and exclusive
elements. The tree is removed and then quota group consistency is checked.

This issue is fixed by the linux kernel btrfs patch series:
   [PATCH 0/3] btrfs: qgroup fixes for btrfs_drop_snapshot
   [PATCH 1/3] btrfs: add trace for qgroup accounting
   [PATCH 2/3] btrfs: qgroup: account shared subtrees during snapshot delete
   [PATCH 3/3] Btrfs: __btrfs_mod_ref should always use no_quota

The following btrfsprogs patch set is needed for the actual check of qgroup
consistency:
   [PATCH 1/5] btrfs-progs: print qgroup excl as unsigned
   [PATCH 2/5] btrfs-progs: import ulist
   [PATCH 3/5] btrfs-progs: add quota group verify code
   [PATCH 4/5] btrfs-progs: show extent state for a subvolume
   [PATCH 5/5] btrfs-progs: ignore orphaned qgroups by default

The btrfsprogs patches can be found in the following repo:

https://github.com/markfasheh/btrfs-progs-patches/tree/qgroup-verify

This patch to xfstests can be found in the following repo:

https://github.com/markfasheh/xfstests-patches/tree/qgroup-drop-snapshot

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 tests/btrfs/057     | 117 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/057.out |   7 ++++
 tests/btrfs/group   |   1 +
 3 files changed, 125 insertions(+)
 create mode 100755 tests/btrfs/057
 create mode 100644 tests/btrfs/057.out

diff --git a/tests/btrfs/057 b/tests/btrfs/057
new file mode 100755
index 0000000..0aca2ca
--- /dev/null
+++ b/tests/btrfs/057
@@ -0,0 +1,117 @@
+#! /bin/bash
+# FS QA Test No. btrfs/057
+#
+# Test btrfs quota group consistency operations during snapshot
+# delete. Btrfs has had long standing issues with drop snapshot
+# failing to properly account for quota groups. This test crafts a
+# snapshot tree with shared and exclusive elements. The tree is
+# removed and then quota group consistency is checked.
+#
+# This issue is fixed by the linux kernel btrfs patch series:
+#
+#    [PATCH 0/3] btrfs: qgroup fixes for btrfs_drop_snapshot
+#    [PATCH 1/3] btrfs: add trace for qgroup accounting
+#    [PATCH 2/3] btrfs: qgroup: account shared subtrees during snapshot delete
+#    [PATCH 3/3] Btrfs: __btrfs_mod_ref should always use no_quota
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2014 SUSE Linux Products GmbH. All Rights Reserved.
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_flakey
+	rm -fr $tmp
+}
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
+_need_to_be_root
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+# This always reproduces level 1 trees
+maxfiles=100
+
+echo "create file set"
+
+# Make a bunch of small files in a directory. This is designed to expand
+# the filesystem tree to something more than zero levels.
+mkdir $SCRATCH_MNT/files
+for i in `seq -w 0 $maxfiles`;
+do
+    dd status=none if=/dev/zero of=$SCRATCH_MNT/files/file$i bs=4096 count=4
+done
+
+# create a snapshot of what we just did
+$BTRFS_UTIL_PROG fi sy $SCRATCH_MNT
+$BTRFS_UTIL_PROG su sna $SCRATCH_MNT $SCRATCH_MNT/snap1
+mv $SCRATCH_MNT/snap1/files $SCRATCH_MNT/snap1/old
+
+# same thing as before but on the snapshot. this way we can generate
+# some exclusively owned tree nodes.
+echo "create file set on snapshot"
+mkdir $SCRATCH_MNT/snap1/files
+for i in `seq -w 0 $maxfiles`;
+do
+    dd status=none if=/dev/zero of=$SCRATCH_MNT/snap1/files/file$i bs=4096 count=4
+done
+
+# Enable qgroups now that we have our filesystem prepared. This
+# will kick off a scan which we will have to wait for below.
+$BTRFS_UTIL_PROG qu en $SCRATCH_MNT
+sleep 30
+
+_scratch_unmount
+_scratch_mount
+
+# Ok, delete the snapshot we made previously. Since btrfs drop
+# snapshot is a delayed action with no way to force it, we have to
+# impose another sleep here.
+$BTRFS_UTIL_PROG su de $SCRATCH_MNT/snap1
+sleep 45
+
+_scratch_unmount
+
+# generate a qgroup report and look for inconsistent groups
+$BTRFS_UTIL_PROG check --qgroup-report $SCRATCH_DEV | grep -q "Counts for qgroup.*different"
+RETVAL=$?
+if [ $RETVAL -eq 0 ]; then
+    status=1
+fi
+
+status=0
+exit
diff --git a/tests/btrfs/057.out b/tests/btrfs/057.out
new file mode 100644
index 0000000..b8a146c
--- /dev/null
+++ b/tests/btrfs/057.out
@@ -0,0 +1,7 @@
+QA output created by 057
+create file set
+FSSync '/xfstest2'
+Create a snapshot of '/xfstest2' in '/xfstest2/snap1'
+create file set on snapshot
+Transaction commit: none (default)
+Delete subvolume '/xfstest2/snap1'
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 2da7127..ebc38c5 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -59,3 +59,4 @@
 054 auto quick
 055 auto quick
 056 auto quick
+057 auto quick
-- 
1.8.4.5


