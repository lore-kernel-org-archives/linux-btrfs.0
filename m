Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39ECC169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 12:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD7D02083B
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 12:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfA2Mc3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 07:32:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:45496 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727215AbfA2Mc3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 07:32:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6BB1DB0FD;
        Tue, 29 Jan 2019 12:32:27 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2 1/3] btrfs: Test if btrfs hits EDQUOT without trying to reclaim some space
Date:   Tue, 29 Jan 2019 20:32:20 +0800
Message-Id: <20190129123222.8698-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit a514d63882c3 ("btrfs: qgroup: Commit transaction in advance to reduce
early EDQUOT") is no longer forcing transaction commit to reclaim space,
and only commits transaction asynchronously in advance to address it.

However the criteria used in async transaction commit is not
comprehensive, thus it doesn't reclaim space automatically.

This test case will check the behavior by:
1) Falloc a large padding file
   This file will take 90% of the qgroup limit

2) Sync the fs
   To reflect the qgroup changes

3) Delete the file
   Qgroup won't reclaim the space until transaction committed.

4) Try to write a file
   If kernel not fixed, qgroup will not automatically commit transaction
   to reclaim the freed space and hit EDQUOT.

This bug is going to be fixed by a patch for kernel titled:
"btrfs: qgroup: Make qgroup async transaction commit more aggressive".

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
---
changelog:
v2:
- Grammar and typo fixes.
- Remove unnecessary filter for falloc.
- Append '-f' option for rm.
---
 tests/btrfs/180     | 62 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/180.out |  3 +++
 tests/btrfs/group   |  1 +
 3 files changed, 66 insertions(+)
 create mode 100755 tests/btrfs/180
 create mode 100644 tests/btrfs/180.out

diff --git a/tests/btrfs/180 b/tests/btrfs/180
new file mode 100755
index 000000000000..2b4cfcc92e25
--- /dev/null
+++ b/tests/btrfs/180
@@ -0,0 +1,62 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test 180
+#
+# Test if btrfs hits EDQUOT without reclaiming already freed extents when quota
+# is enabled.
+#
+# This bug is going to be fxied by a patch for kernel titled
+# "btrfs: qgroup: Make qgroup async transaction commit more aggressive"
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
+_scratch_mkfs > /dev/null
+_scratch_mount
+
+$BTRFS_UTIL_PROG quota enable "$SCRATCH_MNT" > /dev/null
+$BTRFS_UTIL_PROG quota rescan -w "$SCRATCH_MNT" > /dev/null
+$BTRFS_UTIL_PROG qgroup limit -e 1G "$SCRATCH_MNT"
+
+$XFS_IO_PROG -f -c "falloc 0 900M" "$SCRATCH_MNT/padding"
+
+# Commit transaction to reflect the quota usage
+sync
+
+rm -f "$SCRATCH_MNT/padding"
+
+# Without the kernel fix, this will trigger EDQUOT.
+_pwrite_byte 0xcd 0 512M "$SCRATCH_MNT/real_file" | _filter_xfs_io
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/180.out b/tests/btrfs/180.out
new file mode 100644
index 000000000000..17187477fc12
--- /dev/null
+++ b/tests/btrfs/180.out
@@ -0,0 +1,3 @@
+QA output created by 180
+wrote 536870912/536870912 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 46dd3c9523c2..03eb62f98332 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -182,3 +182,4 @@
 177 auto quick swap balance
 178 auto quick send
 179 auto qgroup dangerous
+180 auto quick qgroup limit
-- 
2.20.1

