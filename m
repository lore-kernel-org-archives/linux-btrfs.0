Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C798C282C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 06:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23ADF2147A
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 06:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfA1GW6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 01:22:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:37688 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726150AbfA1GW6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 01:22:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E5C94AF18;
        Mon, 28 Jan 2019 06:22:55 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     fstests@vger.kernel.org
Subject: [PATCH] btrfs: Test if btrfs will commit too many transaction for balance
Date:   Mon, 28 Jan 2019 14:22:49 +0800
Message-Id: <20190128062249.22242-1-wqu@suse.com>
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

Since that commit will cause btrfs to commit transaction for nothing
during transaction, it will slow balance dramatically even we only need
to relocate several megabytes.

This test case will catch the problem by using super block generation as
failure criteria.
For small chunk relocated, we will commit 6 transaction for each block
group, and the test case should only have 2 block groups, it should only
commit 12 transactions.

This test case will use 120 as the threshold to detect the failure.

And in my test environment, with kernel fix btrfs committed 14
transactions and finished in 6s.
While without the fix btrfs committed 1734 transactions and takes 25s to
finish.

So the test case should be more than enough to detect the regression,
while still keep the runtime small enough for failure.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/181     | 111 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/181.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 114 insertions(+)
 create mode 100755 tests/btrfs/181
 create mode 100644 tests/btrfs/181.out

diff --git a/tests/btrfs/181 b/tests/btrfs/181
new file mode 100755
index 00000000..052cdba9
--- /dev/null
+++ b/tests/btrfs/181
@@ -0,0 +1,111 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test 181
+#
+# Test if btrfs will commit too many transactions for nothing and cause
+# performance regression during balance.
+#
+# This bug is going to be fixed by a patch for kenerl title
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
+# Need to use inline file extents to bump up tree size
+_scratch_mount -o max_inline=2048
+
+nr_files=1024
+nr_snapshots=8
+
+get_super_gen()
+{
+	$BTRFS_UTIL_PROG inspect dump-super "$SCRATCH_DEV" | grep ^generation |\
+		awk '{print $2}'
+}
+
+$BTRFS_UTIL_PROG subv create "$SCRATCH_MNT/subvol" > /dev/null
+
+# Create some small files to bump tree size
+for ((i = 0; i < $nr_files; i++)) do
+	_pwrite_byte 0xcd 0 2K "$SCRATCH_MNT/subvol/file_$i" > /dev/null
+done
+
+# Work around ENOSPC error
+#
+# Without these snapshots, btrfs balance will just return ENOSPC even
+# we have enough unallocated space.
+for ((i = 0; i < $nr_snapshots; i++)) do
+	$BTRFS_UTIL_PROG subv snapshot "$SCRATCH_MNT/subvol" \
+		"$SCRATCH_MNT/snapshots_$i" > /dev/null
+done
+
+# Commit the fs so we can get a stable super generation
+sync
+
+before_gen=$(get_super_gen)
+if [ -z $before_gen ]; then
+	_fail "failed to get super block genreation"
+fi
+
+$BTRFS_UTIL_PROG balance start -m "$SCRATCH_MNT" > /dev/null
+
+after_gen=$(get_super_gen)
+
+# Since the fs is pretty small, we should have only 1 small metadata chunk and
+# one tiny system chunk.
+# Relocating such small chunks only need 6 commits for each, thus 12 commits for
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
index 00000000..a5a93be6
--- /dev/null
+++ b/tests/btrfs/181.out
@@ -0,0 +1,2 @@
+QA output created by 181
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 03eb62f9..0db485cb 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -183,3 +183,4 @@
 178 auto quick send
 179 auto qgroup dangerous
 180 auto quick qgroup limit
+181 auto quick balance
-- 
2.18.0

