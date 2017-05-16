Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:28490 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbdEPDNZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 23:13:25 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 6B1EAAC00F2
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 12:02:13 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.101.65])
        by m3051.s.css.fujitsu.com (Postfix) with SMTP id 4D509DE
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 12:02:13 +0900 (JST)
Message-Id: <201705160301.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Tue, 16 May 2017 12:01:53 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: tests: remove variable quotation from convert-tests
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs-progs-v4.11-rc1, the following convert-tests failed.

    [TEST/conv]   008-readonly-image
    [TEST/conv]     readonly image test, btrfs defaults
failed: mke2fs -t ext4 -b 4096 -F /Build/btrfs-progs-v4.11-rc1/tests/test.img
test failed for case 008-readonly-image
Makefile:271: recipe for target 'test-convert' failed
make: *** [test-convert] Error 1
    [TEST/conv]   009-common-inode-flags
    [TEST/conv]     common inode flags test, btrfs defaults
failed: mke2fs -t ext4 -b 4096 -F /Build/btrfs-progs-v4.11-rc1/tests/test.img
test failed for case 009-common-inode-flags
Makefile:271: recipe for target 'test-convert' failed
make: *** [test-convert] Error 1

So, remove quotes from $default_mke2fs.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 tests/convert-tests/008-readonly-image/test.sh     | 2 +-
 tests/convert-tests/009-common-inode-flags/test.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/convert-tests/008-readonly-image/test.sh b/tests/convert-tests/008-readonly-image/test.sh
index b2f1ae37..27c9373e 100755
--- a/tests/convert-tests/008-readonly-image/test.sh
+++ b/tests/convert-tests/008-readonly-image/test.sh
@@ -10,7 +10,7 @@ check_prereq btrfs-convert
 
 default_mke2fs="mke2fs -t ext4 -b 4096"
 convert_test_preamble '' 'readonly image test' 16k "$default_mke2fs"
-convert_test_prep_fs "$default_mke2fs"
+convert_test_prep_fs $default_mke2fs
 run_check_umount_test_dev
 convert_test_do_convert
 run_check_mount_test_dev
diff --git a/tests/convert-tests/009-common-inode-flags/test.sh b/tests/convert-tests/009-common-inode-flags/test.sh
index a5828790..02823e14 100755
--- a/tests/convert-tests/009-common-inode-flags/test.sh
+++ b/tests/convert-tests/009-common-inode-flags/test.sh
@@ -11,7 +11,7 @@ check_prereq btrfs-convert
 fail=0
 default_mke2fs="mke2fs -t ext4 -b 4096"
 convert_test_preamble '' 'common inode flags test' 16k "$default_mke2fs"
-convert_test_prep_fs "$default_mke2fs"
+convert_test_prep_fs $default_mke2fs
 
 # create file with specific flags
 run_check $SUDO_HELPER touch "$TEST_MNT/flag_test"
-- 
2.12.2

----
Tsutomu Itoh  t-itoh@jp.fujitsu.com
