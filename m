Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C19C64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 14:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A83AC2086D
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 14:05:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1Wc21fSd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A83AC2086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbeJIVWt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 17:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbeJIVWt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 17:22:49 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BF102086D;
        Tue,  9 Oct 2018 14:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539093941;
        bh=TDOhHO8o2oGNfO/hRVZcQxcYmgr7O2t59qASsNg3KA0=;
        h=From:To:Cc:Subject:Date:From;
        b=1Wc21fSdn7M3R7JpXZxoEvHvILeefMA1Q28/5f4konHRmY3WSlV/FAv2cQLmiCifq
         xV+KFUpEpIT4gFdgkgh8g20gQJnpwxc1IixW3K3fq3/qb+YOw1h4wUKWcTmFDLVYzL
         h0gr/dfWlHbxcFHlCQw0sejg1J1TeKeZ4I1n4SLQ=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] generic: test for file fsync after moving it to a new parent directory
Date:   Tue,  9 Oct 2018 15:05:35 +0100
Message-Id: <20181009140535.31264-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Test that if we move a file from a directory B to a directory A, replace
directory B with directory A, fsync the file and then power fail, after
mounting the filesystem the file has a single parent, named B and there
is no longer any directory with the name A.

This test is motivated by a bug found in btrfs which is fixed by a patch
for the linux kernel titled:

  "Btrfs: fix wrong dentries after fsync of file that got its parent
   replaced"

This test passes on ext4, xfs and patched btrfs but it hangs on f2fs (the
fsck.f2fs process seems stuck).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/507     | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/507.out |  7 +++++
 tests/generic/group   |  1 +
 3 files changed, 79 insertions(+)
 create mode 100755 tests/generic/507
 create mode 100644 tests/generic/507.out

diff --git a/tests/generic/507 b/tests/generic/507
new file mode 100755
index 00000000..f23db677
--- /dev/null
+++ b/tests/generic/507
@@ -0,0 +1,71 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test No. 507
+#
+# Test that if we move a file from a directory B to a directory A, replace
+# directory B with directory A, fsync the file and then power fail, after
+# mounting the filesystem the file has a single parent, named B and there
+# is no longer any directory with the name A.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_flakey
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_dm_target flakey
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_require_metadata_journaling $SCRATCH_DEV
+_init_flakey
+_mount_flakey
+
+# Create our test directories and file.
+mkdir $SCRATCH_MNT/testdir
+mkdir $SCRATCH_MNT/testdir/A
+mkdir $SCRATCH_MNT/testdir/B
+touch $SCRATCH_MNT/testdir/B/bar
+
+# Make sure everything done so far is durably persisted.
+sync
+
+# Now move our file bar from directory B to directory A and then replace
+# directory B with directory A, also renaming directory A to B. Finally
+# fsync file bar.
+mv $SCRATCH_MNT/testdir/B/bar $SCRATCH_MNT/testdir/A/bar
+mv -T $SCRATCH_MNT/testdir/A $SCRATCH_MNT/testdir/B
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/testdir/B/bar
+
+# Simulate a power failure and mount the filesystem. We expect file bar
+# to exist and have a single parent directory, named B, and that no
+# directory named A exists.
+_flakey_drop_and_remount
+
+echo "Filesystem content after power failure:"
+ls -R $SCRATCH_MNT/testdir | _filter_scratch
+
+_unmount_flakey
+
+status=0
+exit
diff --git a/tests/generic/507.out b/tests/generic/507.out
new file mode 100644
index 00000000..49877654
--- /dev/null
+++ b/tests/generic/507.out
@@ -0,0 +1,7 @@
+QA output created by 507
+Filesystem content after power failure:
+SCRATCH_MNT/testdir:
+B
+
+SCRATCH_MNT/testdir/B:
+bar
diff --git a/tests/generic/group b/tests/generic/group
index 2e2a6247..f4d1524b 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -509,3 +509,4 @@
 504 auto quick locks
 505 shutdown auto quick metadata
 506 auto quick log
+507 auto quick log
-- 
2.11.0

