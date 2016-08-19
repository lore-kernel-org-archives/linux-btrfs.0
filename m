Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28015 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753614AbcHSIOe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 04:14:34 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 2B98342BC52D
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Aug 2016 16:13:17 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/4] btrfs-progs: convert-test: Check if the ext2_save/image is read only
Date: Fri, 19 Aug 2016 16:13:06 +0800
Message-ID: <20160819081308.21348-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160819081308.21348-1-quwenruo@cn.fujitsu.com>
References: <20160819081308.21348-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Old convert codes uses both 0400 permission and INODE_READONLY flag to
make the converted ext2 image readonly.

While new convert treat the inode just as normal inode, with no special
inode flag and uses 0600 permission.
This makes user able to modify converted image unintentionally and make
rollback fails.

This test case will test the regression.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/convert-tests/008-readonly-image/test.sh | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100755 tests/convert-tests/008-readonly-image/test.sh

diff --git a/tests/convert-tests/008-readonly-image/test.sh b/tests/convert-tests/008-readonly-image/test.sh
new file mode 100755
index 0000000..4e42237
--- /dev/null
+++ b/tests/convert-tests/008-readonly-image/test.sh
@@ -0,0 +1,26 @@
+#!/bin/bash
+# Check if the converted ext2 image is readonly
+
+source $TOP/tests/common
+source $TOP/tests/common.convert
+
+setup_root_helper
+prepare_test_dev 512M
+check_prereq btrfs-convert
+
+default_mke2fs="mke2fs -t ext4 -b 4096"
+convert_test_preamble '' 'readonly image test' 16k "$default_mke2fs"
+convert_test_prep_fs $default_mke2fs
+run_check_umount_test_dev
+convert_test_do_convert
+run_check_mount_test_dev
+
+# It's expected to fail
+$SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/ext2_save/image bs=1M count=1 \
+	&> /dev/null
+if [ $? -ne 1 ]; then
+	echo "after convert ext2_save/image is not read-only"
+	exit 1
+fi
+run_check_umount_test_dev
+convert_test_post_rollback
-- 
2.9.3



