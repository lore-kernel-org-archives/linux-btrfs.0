Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:41849 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752029AbcLHFoo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 00:44:44 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id DE3F5AC01AC
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Dec 2016 14:44:37 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
        by m3050.s.css.fujitsu.com (Postfix) with SMTP id BE053288
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Dec 2016 14:44:37 +0900 (JST)
Message-Id: <201612080544.AA00023@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 08 Dec 2016 14:44:23 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: tests: add test for --sync option of qgroup show
In-Reply-To: <201612070307.AA00021@WIN-5MHF4RKU941.jp.fujitsu.com>
References: <201612070307.AA00021@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simple test script for the following patch.

   btrfs-progs: qgroup: add sync option to 'qgroup show'

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 tests/cli-tests/005-qgroup-show-sync/test.sh | 30 ++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100755 tests/cli-tests/005-qgroup-show-sync/test.sh

diff --git a/tests/cli-tests/005-qgroup-show-sync/test.sh b/tests/cli-tests/005-qgroup-show-sync/test.sh
new file mode 100755
index 0000000..2be684d
--- /dev/null
+++ b/tests/cli-tests/005-qgroup-show-sync/test.sh
@@ -0,0 +1,30 @@
+#!/bin/bash
+#
+# simple test of qgroup show --sync and --no-sync options
+
+source $TOP/tests/common
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev 1g
+
+run_check $TOP/mkfs.btrfs -f $IMAGE
+run_check_mount_test_dev
+
+run_check $SUDO_HELPER $TOP/btrfs subvolume create $TEST_MNT/Sub
+run_check $SUDO_HELPER $TOP/btrfs quota enable $TEST_MNT/Sub
+
+for opt in '' '--' '--sync' '--no-sync'; do
+	run_check $SUDO_HELPER $TOP/btrfs qgroup limit 300M $TEST_MNT/Sub
+	run_check $SUDU_HELPER dd if=/dev/zero of=$TEST_MNT/Sub/file bs=1M count=200
+
+	run_check $SUDO_HELPER $TOP/btrfs qgroup show -re $opt $TEST_MNT/Sub
+
+	run_check $SUDO_HELPER $TOP/btrfs qgroup limit none $TEST_MNT/Sub
+	run_check rm -f $TEST_MNT/Sub/file
+	run_check $TOP/btrfs filesystem sync $TEST_MNT/Sub
+done
+
+run_check_umount_test_dev
-- 
2.9.3
