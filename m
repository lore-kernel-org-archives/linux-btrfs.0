Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbcDNV67 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 17:58:59 -0400
Date: Thu, 14 Apr 2016 14:58:54 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH V2] btrfs: test snapshot create with invalid parent qgroup
Message-ID: <20160414215854.GN2187@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test that an invalid parent qgroup does not cause snapshot create to           
force the FS readonly.                                                         
                                                                                
In btrfs, create_pending_snapshot() will go readonly on _any_ error return
from 
btrfs_qgroup_inherit(). If qgroups are enabled, a user can crash their fs by    
just making a snapshot and asking it to inherit from an invalid qgroup.         
                                                                                
This patch does exactly that test. If the FS goes readonly that will be         
reported and we will know that a regression was introduced.                     
                                                                                
The btrfs fix this patch relates to can be found at the following url:          
http://thread.gmane.org/gmane.comp.file-systems.btrfs/54755                     
                                                                                
Thanks,                                                                         
	--Mark

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

>From V1-V2:
- update test name
- don't manually unmount
- add this test to the snapshot group too

---
 tests/btrfs/121     | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/121.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 71 insertions(+)
 create mode 100755 tests/btrfs/121
 create mode 100644 tests/btrfs/121.out

diff --git a/tests/btrfs/121 b/tests/btrfs/121
new file mode 100755
index 0000000..011c5a8
--- /dev/null
+++ b/tests/btrfs/121
@@ -0,0 +1,68 @@
+#! /bin/bash
+# FS QA Test No. btrfs/121
+#
+# Test that an invalid parent qgroup does not cause snapshot create to
+# force the FS readonly.
+#
+# This issue is fixed by the following btrfs patch:
+#  [PATCH] btrfs: handle non-fatal errors in btrfs_qgroup_inherit()
+#  http://thread.gmane.org/gmane.comp.file-systems.btrfs/54755
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2016 SUSE Linux Products GmbH. All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+_scratch_mkfs
+_scratch_mount
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+# The qgroup '1/10' does not exist and should be silently ignored
+_run_btrfs_util_prog subvolume snapshot -i 1/10 $SCRATCH_MNT $SCRATCH_MNT/snap1
+
+echo "Silence is golden"
+
+status=0
+exit
diff --git a/tests/btrfs/121.out b/tests/btrfs/121.out
new file mode 100644
index 0000000..b71250d
--- /dev/null
+++ b/tests/btrfs/121.out
@@ -0,0 +1,2 @@
+QA output created by 121
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 13aa1e5..ef6c260 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -121,3 +121,4 @@
 118 auto quick snapshot metadata
 119 auto quick snapshot metadata qgroup
 120 auto quick snapshot metadata
+121 auto quick snapshot qgroup
-- 
2.1.4

