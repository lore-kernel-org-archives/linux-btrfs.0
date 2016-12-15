Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:23570 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754878AbcLOEdX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Dec 2016 23:33:23 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 5539FAC0160
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Dec 2016 13:33:18 +0900 (JST)
Message-Id: <201612150433.AA00026@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 15 Dec 2016 13:33:05 +0900
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs-progs: tests: add test for --sync option of qgroup show
In-Reply-To: <201612080544.AA00023@WIN-5MHF4RKU941.jp.fujitsu.com>
References: <201612080544.AA00023@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simple test script for the following patch.

   btrfs-progs: qgroup: add sync option to 'qgroup show'

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
v2: dropped the test of --no-sync
---
 tests/cli-tests/005-qgroup-show-sync/test.sh | 30 ++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100755 tests/cli-tests/005-qgroup-show-sync/test.sh

diff --git a/tests/cli-tests/005-qgroup-show-sync/test.sh b/tests/cli-tests/005-qgroup-show-sync/test.sh
new file mode 100755
index 0000000..a325b48
--- /dev/null
+++ b/tests/cli-tests/005-qgroup-show-sync/test.sh
@@ -0,0 +1,30 @@
+#!/bin/bash
+#
+# simple test of qgroup show --sync option
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
+for opt in '' '--' '--sync'; do
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


