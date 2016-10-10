Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4152 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751939AbcJJDLk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 9 Oct 2016 23:11:40 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, lakshmipathi.g@gmail.com
Subject: [PATCH 4/4] btrfs-progs: convert-test: Add test case for common inode flags
Date: Mon, 10 Oct 2016 11:11:21 +0800
Message-Id: <20161010031121.5017-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161010031121.5017-1-quwenruo@cn.fujitsu.com>
References: <20161010031121.5017-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a new test case to check if btrfs-convert copies common inode flags
like append(a), immutable(i).

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/convert-tests/009-common-inode-flags/test.sh | 34 ++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100755 tests/convert-tests/009-common-inode-flags/test.sh

diff --git a/tests/convert-tests/009-common-inode-flags/test.sh b/tests/convert-tests/009-common-inode-flags/test.sh
new file mode 100755
index 0000000..8bbac22
--- /dev/null
+++ b/tests/convert-tests/009-common-inode-flags/test.sh
@@ -0,0 +1,34 @@
+#!/bin/bash
+# Check if btrfs-convert can copy common inode flags like SYNC/IMMUTABLE
+
+source $TOP/tests/common
+source $TOP/tests/common.convert
+
+setup_root_helper
+prepare_test_dev 512M
+check_prereq btrfs-convert
+
+fail=0
+default_mke2fs="mke2fs -t ext4 -b 4096"
+convert_test_preamble '' 'common inode flags test' 16k "$default_mke2fs"
+convert_test_prep_fs $default_mke2fs
+
+# create file with specific flags
+$SUDO_HELPER run_check touch $TEST_MNT/flag_test
+$SUDO_HELPER run_check chattr +aSidA $TEST_MNT/flag_test
+
+run_check_umount_test_dev
+convert_test_do_convert
+run_check_mount_test_dev
+
+# Above flags should be copied to btrfs flags, and lsattr should get them
+run_check_stdout lsattr $TEST_MNT/flag_test | cut -f1 -d\  > tmp_output
+grep -e "S" -e "i" -e "a" -e "d" -e "A" -q tmp_output
+if [ $? -ne 0 ]; then
+	rm tmp_output
+	_fail "no common inode flags are copied after convert"
+fi
+rm tmp_output
+
+run_check_umount_test_dev
+convert_test_post_rollback
-- 
2.10.0



