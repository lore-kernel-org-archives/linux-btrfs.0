Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28158 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbcBBCot (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 21:44:49 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 733314056401
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Feb 2016 10:44:25 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 1/4] fstests: Add support to check btrfs sysfs features
Date: Tue,  2 Feb 2016 10:44:16 +0800
Message-Id: <1454381059-27870-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454381059-27870-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454381059-27870-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs has its sysfs interface showing what features current kernel/btrfs
module support.

Add _require_btrfs_kernel_feature() to check such interface.

Also rename _require_btrfs() to _require_btrfs_subcommand() to avoid
confusion.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 common/rc       | 12 +++++++++++-
 tests/btrfs/004 |  2 +-
 tests/btrfs/048 |  2 +-
 tests/btrfs/059 |  2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/common/rc b/common/rc
index 5135260..f95cd34 100644
--- a/common/rc
+++ b/common/rc
@@ -2583,7 +2583,7 @@ _require_deletable_scratch_dev_pool()
 }
 
 # We check for btrfs and (optionally) features of the btrfs command
-_require_btrfs()
+_require_btrfs_subcommand()
 {
 	cmd=$1
 	_require_command "$BTRFS_UTIL_PROG" btrfs
@@ -2594,6 +2594,16 @@ _require_btrfs()
 	[ $? -eq 0 ] || _notrun "$BTRFS_UTIL_PROG too old (must support $cmd)"
 }
 
+# We check if the kernel support given btrfs feature from its sysfs interface
+_require_btrfs_kernel_feature()
+{
+	feat=$1
+	# Use /dev/btrfs-control to ensure btrfs is loaded
+	touch /dev/btrfs-control
+	[[ ! -f /sys/fs/btrfs/features/$feat ]] && \
+		_notrun "kernel does not support $feat feature"
+}
+
 # Check that fio is present, and it is able to execute given jobfile
 _require_fio()
 {
diff --git a/tests/btrfs/004 b/tests/btrfs/004
index d588c5b..b5686ec 100755
--- a/tests/btrfs/004
+++ b/tests/btrfs/004
@@ -52,7 +52,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_scratch
 _require_no_large_scratch_dev
-_require_btrfs inspect-internal
+_require_btrfs_subcommand inspect-internal
 _require_command "/usr/sbin/filefrag" filefrag
 
 rm -f $seqres.full
diff --git a/tests/btrfs/048 b/tests/btrfs/048
index dc7386d..9ddd23f 100755
--- a/tests/btrfs/048
+++ b/tests/btrfs/048
@@ -47,7 +47,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_test
 _require_scratch
-_require_btrfs "property"
+_require_btrfs_subcommand "property"
 _need_to_be_root
 
 send_files_dir=$TEST_DIR/btrfs-test-$seq
diff --git a/tests/btrfs/059 b/tests/btrfs/059
index 3379ead..21d246c 100755
--- a/tests/btrfs/059
+++ b/tests/btrfs/059
@@ -50,7 +50,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_test
 _require_scratch
-_require_btrfs "property"
+_require_btrfs_subcommand "property"
 _need_to_be_root
 
 rm -f $seqres.full
-- 
2.7.0



