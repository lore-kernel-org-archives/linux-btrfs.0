Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23240 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751646AbdCADSF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:18:05 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 9DB1148A2948
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:21 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 20/20] btrfs-progs: fsck-check: Allow fsck check test to repair in lowmem mode for certain test cases
Date: Wed, 1 Mar 2017 11:14:03 +0800
Message-ID: <20170301031403.23902-21-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Since lowmem mode can repair certain corruptions (mostly in fs tree),
insert a beacon into each fsck test cases to allow some of them be
tested for lowmem mode.

With this patch, fsck option override will check the beacon file
".lowmem_repairbale" in the same directory of the test image, and if the
beacon exists, then it will also run lowmem mode repair to repair the
image.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/common.local                                         | 14 +++++++++++++-
 tests/fsck-tests/004-no-dir-index/.lowmem_repairable       |  0
 .../fsck-tests/009-no-dir-item-or-index/.lowmem_repairable |  0
 .../010-no-rootdir-inode-item/.lowmem_repairable           |  0
 tests/fsck-tests/011-no-inode-item/.lowmem_repairable      |  0
 tests/fsck-tests/016-wrong-inode-nbytes/.lowmem_repairable |  0
 .../017-missing-all-file-extent/.lowmem_repairable         |  0
 7 files changed, 13 insertions(+), 1 deletion(-)
 create mode 100644 tests/fsck-tests/004-no-dir-index/.lowmem_repairable
 create mode 100644 tests/fsck-tests/009-no-dir-item-or-index/.lowmem_repairable
 create mode 100644 tests/fsck-tests/010-no-rootdir-inode-item/.lowmem_repairable
 create mode 100644 tests/fsck-tests/011-no-inode-item/.lowmem_repairable
 create mode 100644 tests/fsck-tests/016-wrong-inode-nbytes/.lowmem_repairable
 create mode 100644 tests/fsck-tests/017-missing-all-file-extent/.lowmem_repairable

diff --git a/tests/common.local b/tests/common.local
index 4f56bb08..af372f16 100644
--- a/tests/common.local
+++ b/tests/common.local
@@ -15,11 +15,23 @@ TEST_ARGS_CHECK=--mode=lowmem
 # gets arguments of a current command and can decide if the argument insertion
 # should happen, eg. if some option combination does not make sense or would
 # break tests
+#
+# Return 0 if we need to skip option override
+# Return 1 if we don't need to skip option override
 _skip_spec()
 {
+	beacon=.lowmem_repairable
+
+	# For loemem repair, only support fs tree repair yet
+	# So we place lowmem repair beacon in the same dir of the
+	# test case
 	if echo "$TEST_ARGS_CHECK" | grep -q 'mode=lowmem' &&
 	   echo "$@" | grep -q -- '--repair'; then
-		return 0
+		dir="$(dirname ${@: -1})"
+		if [ -f ${dir}/${beacon} ]; then
+			return 1;
+		fi
+		return 0;
 	fi
 	return 1
 }
diff --git a/tests/fsck-tests/004-no-dir-index/.lowmem_repairable b/tests/fsck-tests/004-no-dir-index/.lowmem_repairable
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/fsck-tests/009-no-dir-item-or-index/.lowmem_repairable b/tests/fsck-tests/009-no-dir-item-or-index/.lowmem_repairable
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/fsck-tests/010-no-rootdir-inode-item/.lowmem_repairable b/tests/fsck-tests/010-no-rootdir-inode-item/.lowmem_repairable
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/fsck-tests/011-no-inode-item/.lowmem_repairable b/tests/fsck-tests/011-no-inode-item/.lowmem_repairable
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/fsck-tests/016-wrong-inode-nbytes/.lowmem_repairable b/tests/fsck-tests/016-wrong-inode-nbytes/.lowmem_repairable
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/fsck-tests/017-missing-all-file-extent/.lowmem_repairable b/tests/fsck-tests/017-missing-all-file-extent/.lowmem_repairable
new file mode 100644
index 00000000..e69de29b
-- 
2.11.1



