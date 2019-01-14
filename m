Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19198C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 08:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6B2F20663
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 08:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfANIUv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 03:20:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:44936 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726092AbfANIUu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 03:20:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0EB4ADC9;
        Mon, 14 Jan 2019 08:20:48 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     josef@toxicpanda.com
Subject: [PATCH RFC] fstests: btrfs: Test if balance takes too long time or return -ENOSPC unexpected
Date:   Mon, 14 Jan 2019 16:20:43 +0800
Message-Id: <20190114082043.31220-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Kernel commit 64403612b73a ("btrfs: rework
btrfs_check_space_for_delayed_refs") is introducing a regression for
btrfs balance performance.

Originally, the workload used in the test case only takes seconds for
balance on v4.20 while now it takes over 400 seconds for balance.

During that 400 seconds balance, it commits over 2000 transactions just
for nothing, compare to original several transactions.

Add test cases to detect such regression.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Extra note:
In fact, without the snapshots created in the test case, it would return
-ENOSPC even we have enough unallocated space.
---
 tests/btrfs/180     | 80 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/180.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 83 insertions(+)
 create mode 100755 tests/btrfs/180
 create mode 100644 tests/btrfs/180.out

diff --git a/tests/btrfs/180 b/tests/btrfs/180
new file mode 100755
index 00000000..534fea01
--- /dev/null
+++ b/tests/btrfs/180
@@ -0,0 +1,80 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test 180
+#
+# Test if metadata balance would take forever to finish or return ENOSPC even
+# there there are tons of space.
+#
+# This is regression caused by upstream commit 64403612b73a
+# ("btrfs: rework btrfs_check_space_for_delayed_refs")
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command falloc
+
+i=0
+loop=16384
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+$BTRFS_UTIL_PROG subvolume create "$SCRATCH_MNT/src" > /dev/null
+
+while [ $i -le $loop ]; do
+	# Use small file to create inline extent
+	_pwrite_byte 0x00 0 2K "$SCRATCH_MNT/src/inline_$i" > /dev/null
+	#$XFS_IO_PROG -f -c "falloc 0 4K" "$SCRATCH_MNT/src/regular_$i" > /dev/null
+	i=$((i + 1))
+done
+
+# Create enough snapshots so at space reservation part of relocation, we could
+# generate enough space pressure
+for i in $(seq -w 0 16); do
+	$BTRFS_UTIL_PROG subvolume snapshot "$SCRATCH_MNT/src" \
+		"$SCRATCH_MNT/snapshot_$i" > /dev/null
+	# touch random files to create some new tree blocks
+	for j in $(seq -w 0 16); do
+		victim="$(ls $SCRATCH_MNT/snapshot_$i | sort -R | head -n1)"
+		touch "$SCRATCH_MNT/snapshot_$i/$victim"
+	done
+done
+
+# Balancing metadata shouldn't be too time consuming, as the amount of metadata
+# is less than 8M, thus normally it should finish very quick.
+#
+# However with that offending commit, it will take forever to finish or return
+# ENOSPC after a long wait.
+$BTRFS_UTIL_PROG balance start -m "$SCRATCH_MNT" > /dev/null
+
+echo "Silence is golden"
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/180.out b/tests/btrfs/180.out
new file mode 100644
index 00000000..50aba766
--- /dev/null
+++ b/tests/btrfs/180.out
@@ -0,0 +1,2 @@
+QA output created by 180
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 46dd3c95..e724968b 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -182,3 +182,4 @@
 177 auto quick swap balance
 178 auto quick send
 179 auto qgroup dangerous
+180 auto balance dangerous
-- 
2.18.0

