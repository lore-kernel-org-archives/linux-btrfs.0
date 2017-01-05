Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq5.tb.mail.iss.as9143.net ([212.54.42.168]:44650 "EHLO
        smtpq5.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938892AbdAEVYG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jan 2017 16:24:06 -0500
Received: from [212.54.42.117] (helo=lsmtp3.tb.mail.iss.as9143.net)
        by smtpq5.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <laks@webminal.org>)
        id 1cPFW0-0005dz-2D
        for linux-btrfs@vger.kernel.org; Thu, 05 Jan 2017 22:24:04 +0100
Received: from dhcp-077-251-197-105.chello.nl ([77.251.197.105] helo=webminal.org)
        by lsmtp3.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <laks@webminal.org>)
        id 1cPFVp-00024z-Q0
        for linux-btrfs@vger.kernel.org; Thu, 05 Jan 2017 22:24:04 +0100
Received: from localhost.localdomain (fedori [127.0.0.1])
        by webminal.org (8.14.4/8.14.4) with ESMTP id v05JQkat011664
        for <linux-btrfs@vger.kernel.org>; Thu, 5 Jan 2017 20:26:57 +0100
Received: (from root@localhost)
        by localhost.localdomain (8.14.4/8.14.4/Submit) id v05JQaif011633
        for linux-btrfs@vger.kernel.org; Thu, 5 Jan 2017 20:26:36 +0100
Date: Thu, 5 Jan 2017 20:26:36 +0100
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fsck-tests: missing csum test script
Message-ID: <20170105192636.GA11297@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 tests/fsck-tests/027-missing-data-csum/test.sh | 39 ++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100755 tests/fsck-tests/027-missing-data-csum/test.sh

diff --git a/tests/fsck-tests/027-missing-data-csum/test.sh b/tests/fsck-tests/027-missing-data-csum/test.sh
new file mode 100755
index 0000000..6d1dc97
--- /dev/null
+++ b/tests/fsck-tests/027-missing-data-csum/test.sh
@@ -0,0 +1,39 @@
+#!/bin/bash
+
+source $TOP/tests/common
+
+check_prereq btrfs-corrupt-block
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev 512M
+
+
+# simulate missing csum error and repair using init-csum option
+test_csum_corruption()
+{
+	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
+
+	run_check_mount_test_dev
+
+	export DATASET_SIZE=1
+	generate_dataset small
+
+	run_check_umount_test_dev
+
+	# find bytenr
+	bytenr=`$SUDO_HELPER $TOP/btrfs-debug-tree $TEST_DEV | \
+	grep "EXTENT_CSUM EXTENT_CSUM" | \
+	cut -f1 -d')' | awk '{print $6}'`
+
+	# corrupt csum bytenr
+	run_check $SUDO_HELPER $TOP/btrfs-corrupt-block -C $bytenr $TEST_DEV
+
+	$SUDO_HELPER $TOP/btrfs check $TEST_DEV >& /dev/null && \
+			_fail "btrfs check failed to detect missing csum."
+	run_check $SUDO_HELPER $TOP/btrfs check --repair --init-csum $TEST_DEV
+	run_check $SUDO_HELPER $TOP/btrfs check  $TEST_DEV
+}
+
+test_csum_corruption
-- 
2.7.4

