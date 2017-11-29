Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:35014 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753764AbdK2JQe (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 29 Nov 2017 04:16:34 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 9/9] btrfs-progs: tests/mkfs: Introduce test case to verify if mkfs.btrfs rootdir shrink behaves correctly
Date: Wed, 29 Nov 2017 17:16:04 +0800
Message-Id: <20171129091604.2194-10-wqu@suse.com>
In-Reply-To: <20171129091604.2194-1-wqu@suse.com>
References: <20171129091604.2194-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/mkfs-tests/012-rootdir-no-shrink/test.sh | 38 ++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100755 tests/mkfs-tests/012-rootdir-no-shrink/test.sh

diff --git a/tests/mkfs-tests/012-rootdir-no-shrink/test.sh b/tests/mkfs-tests/012-rootdir-no-shrink/test.sh
new file mode 100755
index 000000000000..1dfa55b376f6
--- /dev/null
+++ b/tests/mkfs-tests/012-rootdir-no-shrink/test.sh
@@ -0,0 +1,38 @@
+#!/bin/bash
+# Test if mkfs.btrfs --rootdir will skip shrinking correctly
+
+source "$TOP/tests/common"
+
+check_prereq mkfs.btrfs
+
+setup_root_helper
+
+fs_size=$((512 * 1024 * 1024))
+bs=$((1024 * 1024))
+tmp=$(mktemp -d --tmpdir btrfs-progs-mkfs.rootdirXXXXXXX)
+
+prepare_test_dev $fs_size
+
+### no shrink case ###
+
+run_check "$TOP/mkfs.btrfs" -f -r $tmp "$TEST_DEV"
+run_check_mount_test_dev
+
+# We should be able to write at least half of the fs size data since
+# the fs is not shrunk
+run_check $SUDO_HELPER dd if=/dev/zero bs=$bs count=$(($fs_size / $bs / 2)) \
+	of="$TEST_MNT/file"
+
+run_check_umount_test_dev
+
+### shrink case ###
+run_check "$TOP/mkfs.btrfs" -f -r $tmp --shrink "$TEST_DEV"
+run_check_mount_test_dev
+
+run_mustfail "mkfs.btrfs for shrink rootdir" \
+	$SUDO_HELPER dd if=/dev/zero bs=$bs count=$(($fs_size / $bs / 2)) \
+	of="$TEST_MNT/file"
+
+run_check_umount_test_dev
+
+rm -rf -- "$tmp"
-- 
2.15.0

