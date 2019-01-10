Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A77DC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 06:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 752DE20879
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 06:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbfAJGOe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 01:14:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:59802 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727218AbfAJGOd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 01:14:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AB443AC4E;
        Thu, 10 Jan 2019 06:14:31 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 2/2] fstests: btrfs: Introduce stress test for deadlock between snapshot delete and other read-write operations
Date:   Thu, 10 Jan 2019 14:14:15 +0800
Message-Id: <20190110061415.32045-2-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190110061415.32045-1-wqu@suse.com>
References: <20190110061415.32045-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit fb235dc06fac ("btrfs: qgroup: Move half of the qgroup accounting
time out of commit trans") could cause ABBA deadlock between backref
lookup with write lock hold (subvolume deletion) and other read/write
operations.

It's going to be fixed by "btrfs: qgroup: Don't trigger backref walk at
delayed ref insert time".

This test will generate pwrite background workload, along with
constantly subvolume creation and deletion to trigger the bug.

It needs some time to generate enough files to bump the tree height to
trigger the bug.
In my test environment, with 'unsafe' cache mode for the VM, it triggers
the bug at around 70~90 seconds. So I leave the default runtime to 120s
to make sure the bug will be triggered.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/179     | 121 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/179.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 124 insertions(+)
 create mode 100755 tests/btrfs/179
 create mode 100644 tests/btrfs/179.out

diff --git a/tests/btrfs/179 b/tests/btrfs/179
new file mode 100755
index 000000000000..771d12fc49e3
--- /dev/null
+++ b/tests/btrfs/179
@@ -0,0 +1,121 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test 179
+#
+# Test if btrfs will lockup at subvolume deletion.
+#
+# The bug is caused by commit fb235dc06fac ("btrfs: qgroup: Move half of the
+# qgroup accounting time out of commit trans").
+# Backref lookup with write lock hold (subvolue deletion) could cause ABBA lock
+# with normal top-down tree locking sequence.
+#
+# This bug deadlock is going to be fixed by "btrfs: qgroup: Don't trigger
+# backref walk at delayed ref insert time" which reverts above commit.
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
+
+# default sleep interval
+sleep_time=1
+
+# stress test runtime
+runtime=120
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+mkdir -p "$SCRATCH_MNT/snapshots"
+$BTRFS_UTIL_PROG subvolume create "$SCRATCH_MNT/src" > /dev/null
+$BTRFS_UTIL_PROG quota enable "$SCRATCH_MNT" > /dev/null
+$BTRFS_UTIL_PROG quota rescan -w "$SCRATCH_MNT" > /dev/null
+
+fill_workload()
+{
+	local i=0
+	while true; do
+		_pwrite_byte 0xcd 0 8K "$SCRATCH_MNT/src/large_$i" > /dev/null
+		_pwrite_byte 0xcd 0 2K "$SCRATCH_MNT/src/inline_$i" > /dev/null
+
+		# Randomly remove some files for every 5 loop
+		if [ $(( $i % 5 )) -eq 0 ]; then
+			victim=$(ls "$SCRATCH_MNT/src" | sort -R | head -n1)
+			rm "$SCRATCH_MNT/src/$victim"
+		fi
+		i=$((i + 1))
+	done
+}
+
+snapshot_workload()
+{
+	local i=0
+	while true; do
+		sleep $sleep_time
+		$BTRFS_UTIL_PROG subvolume snapshot "$SCRATCH_MNT/src" \
+			"$SCRATCH_MNT/snapshots/$i" > /dev/null
+		i=$((i + 1))
+	done
+}
+
+delete_workload()
+{
+	while true; do
+		sleep $((sleep_time * 2))
+		victim=$(ls "$SCRATCH_MNT/snapshots" | sort -R | head -n1)
+		$BTRFS_UTIL_PROG subvolume delete \
+			"$SCRATCH_MNT/snapshots/$victim" > /dev/null
+	done
+}
+
+fill_workload &
+fill_pid=$!
+
+sleep $((sleep_time * 2))
+snapshot_workload &
+snapshot_pid=$!
+delete_workload &
+delete_pid=$!
+
+sleep $runtime
+kill $fill_pid
+wait $fill_pid
+kill $snapshot_pid
+wait $snapshot_pid
+kill $delete_pid
+wait $delete_pid
+
+# Workaround to handle killed workload with unreturned syscall
+sync
+
+# success, all done
+echo "Silence is golden"
+
+status=0
+exit
diff --git a/tests/btrfs/179.out b/tests/btrfs/179.out
new file mode 100644
index 000000000000..cb9eba3d34b1
--- /dev/null
+++ b/tests/btrfs/179.out
@@ -0,0 +1,2 @@
+QA output created by 179
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 04c0254aa4bf..46dd3c9523c2 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -181,3 +181,4 @@
 176 auto quick swap volume
 177 auto quick swap balance
 178 auto quick send
+179 auto qgroup dangerous
-- 
2.20.1

