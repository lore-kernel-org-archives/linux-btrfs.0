Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaJIKUp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Oct 2014 06:20:45 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v2] btrfs: test mount btrfs subvolume with selinux context
Date: Thu,  9 Oct 2014 18:19:28 +0800
Message-Id: <1412849968-13760-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1412668149-16890-1-git-send-email-eguan@redhat.com>
References: <1412668149-16890-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If one subvolume was mounted with selinux context, other subvolumes
should be able to be mounted with the same selinux context too.

Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Eryu Guan <eguan@redhat.com>
---

v2:
- redirect _scratch_mkfs output to $seqres.full to avoid trim disk message
  if the disk supports trim

 tests/btrfs/075     | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/075.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 73 insertions(+)
 create mode 100755 tests/btrfs/075
 create mode 100644 tests/btrfs/075.out

diff --git a/tests/btrfs/075 b/tests/btrfs/075
new file mode 100755
index 0000000..16ed854
--- /dev/null
+++ b/tests/btrfs/075
@@ -0,0 +1,70 @@
+#! /bin/bash
+# FSQA Test No. btrfs/075
+#
+# If one subvolume was mounted with selinux context, other subvolumes
+# should be able to be mounted with the same selinux context too.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2014 Red Hat Inc. All rights reserved.
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
+status=1
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	$UMOUNT_PROG $subvol_mnt >/dev/null 2>&1
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
+
+# SELINUX_MOUNT_OPTIONS will be set in common/config if selinux is enabled
+if [ "$SELINUX_MOUNT_OPTIONS" == "" ]; then
+	_notrun "Require selinux to be enabled"
+fi
+
+rm -f $seqres.full
+echo "Silence is golden"
+
+# first mount default subvolume with selinux context set
+_scratch_mkfs >$seqres.full 2>&1
+_scratch_mount
+
+# create a new subvolume and mount it with the same selinux context
+subvol_mnt=$TEST_DIR/$seq.mnt
+mkdir -p $subvol_mnt
+$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/subvol >>$seqres.full 2>&1
+$MOUNT_PROG -o subvol=subvol $SELINUX_MOUNT_OPTIONS $SCRATCH_DEV $subvol_mnt
+status=$?
+
+exit
diff --git a/tests/btrfs/075.out b/tests/btrfs/075.out
new file mode 100644
index 0000000..ded801b
--- /dev/null
+++ b/tests/btrfs/075.out
@@ -0,0 +1,2 @@
+QA output created by 075
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index c8ac72c..00ae8ce 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -77,3 +77,4 @@
 072 auto scrub defrag compress
 073 auto scrub remount compress
 074 auto defrag remount compress
+075 auto quick subvol
-- 
1.8.3.1

