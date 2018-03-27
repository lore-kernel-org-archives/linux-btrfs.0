Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56162 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752087AbeC0HHV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:07:21 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 4E4F648AE772
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 15:07:11 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 09/10] btrfs-progs: tests: add testcase for undelete-subvol
Date: Tue, 27 Mar 2018 15:06:57 +0800
Message-ID: <20180327070658.13064-10-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The testcase checks the functionality of "btrfs rescue undelete-subvol",
including recovering an intact subvolume, and handling correctly
incomplete subvolume.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
v2: add shell quoting to test script.

 .../030-undelete-subvol/deleted_subvolume.img      | Bin 0 -> 4096 bytes
 .../030-undelete-subvol/drop_progress.raw.xz       | Bin 0 -> 23452 bytes
 tests/misc-tests/030-undelete-subvol/test.sh       |  34 +++++++++++++++++++++
 3 files changed, 34 insertions(+)
 create mode 100644 tests/misc-tests/030-undelete-subvol/deleted_subvolume.img
 create mode 100644 tests/misc-tests/030-undelete-subvol/drop_progress.raw.xz
 create mode 100755 tests/misc-tests/030-undelete-subvol/test.sh

diff --git a/tests/misc-tests/030-undelete-subvol/deleted_subvolume.img b/tests/misc-tests/030-undelete-subvol/deleted_subvolume.img
new file mode 100644
index 0000000000000000000000000000000000000000..9168a8e33fbbb14f9ea78514721a52191b94d1a0
GIT binary patch
literal 4096
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
ZeM(;pZJdD++rKZroo*A@Ch+ek@Fx_v;e7xA

literal 0
HcmV?d00001

diff --git a/tests/misc-tests/030-undelete-subvol/drop_progress.raw.xz b/tests/misc-tests/030-undelete-subvol/drop_progress.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..3db2c80e61fa9bb99db374509dbb95910965d467
GIT binary patch
literal 23452
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
F{{akY3)=ty

literal 0
HcmV?d00001

diff --git a/tests/misc-tests/030-undelete-subvol/test.sh b/tests/misc-tests/030-undelete-subvol/test.sh
new file mode 100755
index 000000000000..d3dfa5008601
--- /dev/null
+++ b/tests/misc-tests/030-undelete-subvol/test.sh
@@ -0,0 +1,34 @@
+#!/bin/bash
+# Test undelete-subvol can recover the intact subvolume, and can skip the
+# incomplete subvolume.
+
+source "$TOP/tests/common"
+
+check_prereq btrfs
+check_prereq btrfs-image
+
+setup_root_helper
+
+check_image()
+{
+	TEST_DEV="$1"
+
+	run_check_stdout "$TOP/btrfs" rescue undelete-subvol "$TEST_DEV" \
+		| grep -q "Recovered 1 subvols" \
+		|| _fail "failed to undelete subvol $image" >&2
+
+	run_check "$TOP/btrfs" check "$TEST_DEV"
+
+	# check whether the recovered image can be mounted normally
+	run_check_mount_test_dev
+
+	run_check_stdout $SUDO_HELPER "$TOP/btrfs" subvolume list "$TEST_MNT" \
+		| grep -q "lost+found" \
+		|| _fail "failed to find the recovered subvol $image" >&2
+
+	run_check_umount_test_dev "$TEST_MNT"
+
+	rm "$TEST_DEV"
+}
+
+check_all_images
-- 
2.16.2



