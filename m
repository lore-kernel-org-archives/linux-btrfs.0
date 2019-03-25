Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B839C10F03
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 09:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 465DC20863
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 09:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbfCYJmD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 05:42:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:49344 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730227AbfCYJmD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 05:42:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E491EAC57;
        Mon, 25 Mar 2019 09:42:01 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     guaneryu@gmail.com
Cc:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] fstests: Verify that removed device has its superblocks deleted
Date:   Mon, 25 Mar 2019 11:42:00 +0200
Message-Id: <20190325094200.18687-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When a device is removed from a btrfs filesystem its superblock copies
must be deleted. This test ensures this is indeed the case.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/btrfs/184     | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/184.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 60 insertions(+)
 create mode 100755 tests/btrfs/184
 create mode 100644 tests/btrfs/184.out

diff --git a/tests/btrfs/184 b/tests/btrfs/184
new file mode 100755
index 000000000000..3bf7d201a145
--- /dev/null
+++ b/tests/btrfs/184
@@ -0,0 +1,57 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 SUSE LLC. All Rights Reserved.
+#
+# FS QA Test 184
+#
+# Verify that when a device is removed from a multi-device
+# filesystem its superblock copies are correctly deleted
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
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_scratch_dev_pool 2
+_require_btrfs_command inspect-internal dump-super
+
+_scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+                                                                            
+# pick last dev in the list
+dev_del=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`
+$BTRFS_UTIL_PROG device delete $dev_del $SCRATCH_MNT || _fail "btrfs device delete failed"
+for i in {0..2}; do
+    output=$($BTRFS_UTIL_PROG inspect-internal dump-super -s $i $dev_del 2>&1)
+    $BTRFS_UTIL_PROG inspect-internal dump-super -s $i $dev_del 2>&1 | grep -q "bad magic"
+    ret=$?
+    if [[ "$output" != "" && $ret -eq 1 ]]; then
+        _fail "Deleted dev superblocks not scratched"
+    fi
+done
+_scratch_unmount
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/184.out b/tests/btrfs/184.out
new file mode 100644
index 000000000000..b4ce96cfc047
--- /dev/null
+++ b/tests/btrfs/184.out
@@ -0,0 +1,2 @@
+QA output created by 184
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index f3227c1708d9..c1d215bf5ff8 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -186,3 +186,4 @@
 181 auto quick balance
 182 auto quick balance
 183 auto quick clone compress punch
+184 auto quick volume
-- 
2.7.4

