Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbaBGKfq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 05:35:46 -0500
From: David Disseldorp <ddiss@suse.de>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, David Disseldorp <ddiss@suse.de>
Subject: [PATCH v3 3/3] btrfs/035: add new clone overwrite regression test
Date: Fri,  7 Feb 2014 11:35:41 +0100
Message-Id: <1391769341-20688-4-git-send-email-ddiss@suse.de>
In-Reply-To: <1391769341-20688-1-git-send-email-ddiss@suse.de>
References: <1391769341-20688-1-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test uses the newly added cloner binary to dispatch full file and
range specific clone (reflink) requests.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 tests/btrfs/035     | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/035.out |  3 +++
 tests/btrfs/group   |  1 +
 3 files changed, 81 insertions(+)
 create mode 100755 tests/btrfs/035
 create mode 100644 tests/btrfs/035.out

diff --git a/tests/btrfs/035 b/tests/btrfs/035
new file mode 100755
index 0000000..6808179
--- /dev/null
+++ b/tests/btrfs/035
@@ -0,0 +1,77 @@
+#!/bin/bash
+# FS QA Test No. btrfs/035
+#
+# Regression test for overwriting clones
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
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
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
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+CLONER_PROG=$here/src/cloner
+[ -x $CLONER_PROG ] || _notrun "cloner binary not present at $CLONER_PROG"
+
+src_str="aaaaaaaaaa"
+
+echo -n "$src_str" > $SCRATCH_MNT/src
+
+$CLONER_PROG $SCRATCH_MNT/src  $SCRATCH_MNT/src.clone1
+
+src_str="bbbbbbbbbbcccccccccc"
+
+echo -n "$src_str" > $SCRATCH_MNT/src
+
+$CLONER_PROG $SCRATCH_MNT/src $SCRATCH_MNT/src.clone2
+
+snap_src_sz=`ls -lah $SCRATCH_MNT/src.clone1 | awk '{print $5}'`
+echo "attempting ioctl (src.clone1 src)"
+$CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
+	$SCRATCH_MNT/src.clone1 $SCRATCH_MNT/src
+
+snap_src_sz=`ls -lah $SCRATCH_MNT/src.clone2 | awk '{print $5}'`
+echo "attempting ioctl (src.clone2 src)"
+$CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
+	$SCRATCH_MNT/src.clone2 $SCRATCH_MNT/src
+
+status=0 ; exit
diff --git a/tests/btrfs/035.out b/tests/btrfs/035.out
new file mode 100644
index 0000000..f86cadf
--- /dev/null
+++ b/tests/btrfs/035.out
@@ -0,0 +1,3 @@
+QA output created by 035
+attempting ioctl (src.clone1 src)
+attempting ioctl (src.clone2 src)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index f9f062f..bee57cb 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -37,3 +37,4 @@
 032 auto quick
 033 auto quick
 034 auto quick
+035 auto quick
-- 
1.8.4.5

