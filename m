Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19234 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbcCIIg0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 03:36:26 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH v4 6/6] fstests: btrfs: Test for btrfs dedup tree balance bug
Date: Wed,  9 Mar 2016 16:33:44 +0800
Message-Id: <1457512424-9215-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1457512424-9215-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1457512424-9215-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs in-band de-duplication has a bug when dedup tree metadata is
balanced, it will corrupted btrfs delayed ref and cause the following
kernel warning:

BTRFS error (device sdb6): unable to find ref byte nr 29736960 parent 0
root 11  owner 0 offset 0
------------[ cut here ]------------
WARNING: CPU: 1 PID: 19113 at fs/btrfs/extent-tree.c:6636
__btrfs_free_extent.isra.66+0xb6d/0xd20 [btrfs]()
BTRFS: Transaction aborted (error -2)
Modules linked in: btrfs(O) xor zlib_deflate raid6_pq xfs [last
unloaded: btrfs]
CPU: 1 PID: 19113 Comm: btrfs Tainted: G        W  O    4.5.0-rc5+ #2
Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox
12/01/2006
 0000000000000000 ffff880035b0ba18 ffffffff813771ff ffff880035b0ba60
 ffffffffa06a810a ffff880035b0ba50 ffffffff810bcb81 ffff88003c45c528
 0000000001c5c000 00000000fffffffe ffff88003dc8c520 0000000000000000
Call Trace:
 [<ffffffff813771ff>] dump_stack+0x67/0x98
 [<ffffffff810bcb81>] warn_slowpath_common+0x81/0xc0
 [<ffffffff810bcc07>] warn_slowpath_fmt+0x47/0x50
 [<ffffffffa06028fd>] __btrfs_free_extent.isra.66+0xb6d/0xd20 [btrfs]
 [<ffffffffa0606d4d>] __btrfs_run_delayed_refs.constprop.71+0x96d/0x1560
[btrfs]
 [<ffffffff81202ad9>] ? cmpxchg_double_slab.isra.68+0x149/0x160
 [<ffffffff81106a1d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa060a5ce>] btrfs_run_delayed_refs+0x8e/0x2d0 [btrfs]
 [<ffffffffa06209fe>] btrfs_commit_transaction+0x3e/0xb50 [btrfs]
 [<ffffffffa069f26e>] ? btrfs_dedup_disable+0x28e/0x2c0 [btrfs]
 [<ffffffff812035c3>] ? kfree+0x223/0x270
 [<ffffffffa069f27a>] btrfs_dedup_disable+0x29a/0x2c0 [btrfs]
 [<ffffffffa065e403>] btrfs_ioctl+0x2363/0x2a40 [btrfs]
 [<ffffffff8116b12a>] ? __audit_syscall_entry+0xaa/0xf0
 [<ffffffff81137ce6>] ? current_kernel_time64+0x56/0xa0
 [<ffffffff8122080e>] do_vfs_ioctl+0x8e/0x690
 [<ffffffff8116b12a>] ? __audit_syscall_entry+0xaa/0xf0
 [<ffffffff8122c181>] ? __fget_light+0x61/0x90
 [<ffffffff81220e84>] SyS_ioctl+0x74/0x80
 [<ffffffff8180ad57>] entry_SYSCALL_64_fastpath+0x12/0x6f
---[ end trace 618d5a5bc21d6a7c ]---

Add regression test case for it.

Reported-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/204     | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/204.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 77 insertions(+)
 create mode 100755 tests/btrfs/204
 create mode 100644 tests/btrfs/204.out

diff --git a/tests/btrfs/204 b/tests/btrfs/204
new file mode 100755
index 0000000..5baecf8
--- /dev/null
+++ b/tests/btrfs/204
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test 204
+#
+# Regression test for dedup tree metadata balance
+# If btrfs balanced dedup tree block twice, delayed ref will be corrupted
+# and cause kernel warning with RO fs.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Fujitsu.  All Rights Reserved.
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
+. ./common/reflink
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_btrfs_subcommand dedup
+_require_btrfs_fs_feature dedup
+_require_btrfs_mkfs_feature dedup
+
+_scratch_mkfs "-O dedup" >> $seqres.full 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog dedup enable $SCRATCH_MNT
+
+# Balance btrfs metadata twice, this will ensure the second balance
+# to drop refence on old dedup root bytenr if kernel has the dedup bug
+_run_btrfs_util_prog balance start -m $SCRATCH_MNT
+_run_btrfs_util_prog balance start -m $SCRATCH_MNT
+
+# Disable will force a sync_fs() and cause kernel warning
+_run_btrfs_util_prog dedup disable $SCRATCH_MNT
+
+echo "Silence is golden"
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/204.out b/tests/btrfs/204.out
new file mode 100644
index 0000000..1035eae
--- /dev/null
+++ b/tests/btrfs/204.out
@@ -0,0 +1,2 @@
+QA output created by 204
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index fa90f33..089e4a8 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -123,3 +123,4 @@
 201 auto dedup
 202 auto dedup
 203 auto dedup balance
+204 auto quick dedup
-- 
2.7.2



