Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34908 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727505AbeICOW3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Sep 2018 10:22:29 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 16686AF64
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Sep 2018 10:03:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs-progs: tests: Add test for missing device delete error value
Date: Mon,  3 Sep 2018 13:02:57 +0300
Message-Id: <20180903100257.5789-1-nborisov@suse.com>
In-Reply-To: <20180903094614.2667-1-nborisov@suse.com>
References: <20180903094614.2667-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a test which ensures the kernel returns the correct error value
when missing device removal is requested. This test verifies that kernel
refactoring didn't broken the return value.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/misc-tests/011-delete-missing-device/test.sh | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tests/misc-tests/011-delete-missing-device/test.sh b/tests/misc-tests/011-delete-missing-device/test.sh
index 4c976421c091..b799a25c201d 100755
--- a/tests/misc-tests/011-delete-missing-device/test.sh
+++ b/tests/misc-tests/011-delete-missing-device/test.sh
@@ -44,6 +44,21 @@ test_delete_missing()
 	run_check_umount_test_dev
 }
 
+test_missing_error()
+{
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check_mount_test_dev
+	local out
+	out=$(run_mustfail_stdout "Unexpected success" \
+		$SUDO_HELPER "$TOP/btrfs" device remove missing "$TEST_MNT")
+
+	if ! echo "$out" | grep -q "no missing devices found to remove"; then
+		_fail "IOCTL returned unexpected error value"
+	fi
+
+	run_check_umount_test_dev
+}
+
 setup_loopdevs 4
 prepare_loopdevs
 dev1=${loopdevs[1]}
@@ -53,5 +68,7 @@ TEST_DEV=$dev1
 test_do_mkfs -m raid1 -d raid1
 test_wipefs
 test_delete_missing
+test_missing_error
+
 
 cleanup_loopdevs
-- 
2.7.4
