Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:31872 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760512AbcKDIfo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Nov 2016 04:35:44 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 161ECAC01D6
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Nov 2016 17:35:40 +0900 (JST)
Message-Id: <201611040835.AA00012@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Fri, 04 Nov 2016 17:35:18 +0900
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: send-test: add checking of clone-src option
In-Reply-To: <201610190235.AA00003@WIN-5MHF4RKU941.jp.fujitsu.com>
References: <201610190235.AA00003@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sending stream size of clone-src(-c) option is checked.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 tests/misc-tests/016-send-clone-src/test.sh | 54 +++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100755 tests/misc-tests/016-send-clone-src/test.sh

diff --git a/tests/misc-tests/016-send-clone-src/test.sh b/tests/misc-tests/016-send-clone-src/test.sh
new file mode 100755
index 0000000..dddd16d
--- /dev/null
+++ b/tests/misc-tests/016-send-clone-src/test.sh
@@ -0,0 +1,54 @@
+#!/bin/bash
+#
+# test for sending stream size of clone-src option
+
+source $TOP/tests/common
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+prepare_test_dev 2g
+
+run_check $TOP/mkfs.btrfs -f $IMAGE
+run_check_mount_test_dev
+
+here=`pwd`
+cd "$TEST_MNT" || _fail "cannot chdir to TEST_MNT"
+
+run_check $SUDO_HELPER btrfs subvolume create subv-parent1
+run_check $SUDO_HELPER dd if=/dev/urandom of=subv-parent1/file1_1 bs=1M count=10
+run_check $SUDO_HELPER btrfs subvolume snapshot -r subv-parent1 subv-snap1_1
+run_check $SUDO_HELPER dd if=/dev/urandom of=subv-parent1/file1_2 bs=1M count=10
+run_check $SUDO_HELPER btrfs subvolume snapshot -r subv-parent1 subv-snap1_2
+run_check $SUDO_HELPER dd if=/dev/urandom of=subv-parent1/file1_3 bs=1M count=10
+run_check $SUDO_HELPER btrfs subvolume snapshot -r subv-parent1 subv-snap1_3
+
+run_check $SUDO_HELPER btrfs subvolume create subv-parent2
+run_check $SUDO_HELPER dd if=/dev/urandom of=subv-parent2/file2_1 bs=1M count=10
+run_check $SUDO_HELPER btrfs subvolume snapshot -r subv-parent2 subv-snap2_1
+run_check $SUDO_HELPER dd if=/dev/urandom of=subv-parent2/file2_2 bs=1M count=10
+run_check $SUDO_HELPER btrfs subvolume snapshot -r subv-parent2 subv-snap2_2
+run_check $SUDO_HELPER dd if=/dev/urandom of=subv-parent2/file2_3 bs=1M count=10
+run_check $SUDO_HELPER btrfs subvolume snapshot -r subv-parent2 subv-snap2_3
+
+run_check $SUDO_HELPER btrfs send -f "$here"/send.stream.before \
+	-c subv-snap1_1 -c subv-snap2_1 subv-snap1_[23] subv-snap2_[23]
+
+run_check $SUDO_HELPER $TOP/btrfs send -f "$here"/send.stream.after \
+	-c subv-snap1_1 -c subv-snap2_1 subv-snap1_[23] subv-snap2_[23]
+
+before_size=`ls -l "$here"/send.stream.before | awk '{print $5}'`
+after_size=`ls -l "$here"/send.stream.after | awk '{print $5}'`
+
+if [ $before_size -lt $after_size ]; then
+	run_check ls -l "$here"/send.stream.*
+	_fail "sending stream size is bigger than old stream"
+fi
+
+run_check rm -f "$here"/send.stream.*
+
+cd "$here" || _fail "cannot chdir back to test directory"
+
+run_check_umount_test_dev
+
-- 
2.9.3
