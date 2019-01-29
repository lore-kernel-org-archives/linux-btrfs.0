Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC289C282C7
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 12:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A86092083B
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 12:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbfA2Mcf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 07:32:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:45518 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727964AbfA2Mce (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 07:32:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B4FB7B102;
        Tue, 29 Jan 2019 12:32:32 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v3 2/3] btrfs: Test if btrfs will commit too many transactions for balance
Date:   Tue, 29 Jan 2019 20:32:21 +0800
Message-Id: <20190129123222.8698-2-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190129123222.8698-1-wqu@suse.com>
References: <20190129123222.8698-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Kernel commit 64403612b73a ("btrfs: rework
btrfs_check_space_for_delayed_refs") is introducing a regression for
btrfs balance performance.

Since that commit will cause btrfs to commit too many transactions for
nothing during balance/relocation, it will slow balance dramatically even
we only need to relocate several megabytes.

This test case will catch the problem by using super block generation as
failure criteria.
For small chunk relocated, we will commit 6 transactions for each block
group, and the test case should only have 2 block groups, it should only
commit 12 transactions.

This test case will use 120 as the threshold to detect the failure.

And in my test environment, with kernel fix btrfs committed 14
transactions.
While without the fix btrfs committed 209 transactions.

So the test case should be enough to detect the regression, while still
keep the runtime small enough for failure.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
---
changelog:
v2:
- Remove the unnecessary workaround for ENOSPC balance
  Since we know the cause of that false ENOSPC error, a simple sync
  would be enough to take care of the problem

- Remove unnecessary mount option of max_inline
  The same reason above.

v3:
- Remove unused variable.
- Grammar and type fixes.
- Full subcommand name for 'btrfs' command.
- Always check output for get_super_gen().
---
 tests/btrfs/181     | 101 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/181.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 104 insertions(+)
 create mode 100755 tests/btrfs/181
 create mode 100644 tests/btrfs/181.out

diff --git a/tests/btrfs/181 b/tests/btrfs/181
new file mode 100755
index 000000000000..323216e4fa0a
--- /dev/null
+++ b/tests/btrfs/181
@@ -0,0 +1,101 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test 181
+#
+# Test if btrfs will commit too many transactions for nothing and cause
+# performance regression during balance.
+#
+# This bug is going to be fixed by a patch for kernel title
+# "btrfs: don't end the transaction for delayed refs in throttle"
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
+_require_btrfs_command inspect-internal dump-super
+
+_scratch_mkfs > /dev/null
+
+_scratch_mount
+
+nr_files=1024
+
+get_super_gen()
+{
+	local ret=$($BTRFS_UTIL_PROG inspect dump-super "$SCRATCH_DEV" |\
+		grep ^generation | awk '{print $2}')
+	if [ -z $ret ]; then
+		_fail "failed to get super block generation"
+	fi
+	echo "$ret"
+}
+
+$BTRFS_UTIL_PROG subvolume create "$SCRATCH_MNT/subvol" > /dev/null
+
+# Create some small files to take up enough metadata reserved space 
+for ((i = 0; i < $nr_files; i++)) do
+	_pwrite_byte 0xcd 0 1K "$SCRATCH_MNT/subvol/file_$i" > /dev/null
+done
+
+# Commit the fs so we can get a stable super generation
+sync
+
+before_gen=$(get_super_gen)
+
+$BTRFS_UTIL_PROG balance start -m "$SCRATCH_MNT" > /dev/null
+
+after_gen=$(get_super_gen)
+
+# Since the fs is pretty small, we should have only 1 small metadata chunk and
+# one tiny system chunk.
+# Relocating such small chunks only needs 6 commits for each, thus 12 commits for
+# 2 chunks.
+# Here we use 10x the theoretic value as threshold.
+theoretic_gen=$(( 6 * 2 ))
+threshold_gen=$(( 10 * $theoretic_gen ))
+if [ $(( $after_gen - $before_gen )) -gt 120 ]; then
+	echo "balance committed too many transactions"
+	echo "super generation before balance: ${before_gen}"
+	echo "super generation after balance:  ${after_gen}"
+	echo "super generation difference:     $((after_gen - before_gen))"
+	echo "theoretic generation difference: ${theoretic_gen}"
+	echo "threshold generation difference: ${threshold_gen}"
+fi
+
+echo "super generation before balance: ${before_gen}" >> $seqres.full
+echo "super generation after balance:  ${after_gen}" >> $seqres.full
+echo "super generation difference:     $((after_gen - before_gen))" >> $seqres.full
+echo "theoretic generation difference: ${theoretic_gen}" >> $seqres.full
+echo "threshold generation difference: ${threshold_gen}" >> $seqres.full
+
+# success, all done
+echo "Silence is golden"
+
+status=0
+exit
diff --git a/tests/btrfs/181.out b/tests/btrfs/181.out
new file mode 100644
index 000000000000..a5a93be663eb
--- /dev/null
+++ b/tests/btrfs/181.out
@@ -0,0 +1,2 @@
+QA output created by 181
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 03eb62f98332..0db485cbe834 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -183,3 +183,4 @@
 178 auto quick send
 179 auto qgroup dangerous
 180 auto quick qgroup limit
+181 auto quick balance
-- 
2.20.1

