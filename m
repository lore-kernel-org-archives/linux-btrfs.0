Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E93C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 18:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08BF5222C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 18:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549994907;
	bh=EmCwvTqdsZJpyiHtUpQh0jB5kneUv90rtq++zvJdOcU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=mo/qP4hZdJLXasgcEvX5dxAigbFRJvhUgO2/WmgSq5vNa+nYuwlGmp/GXPk8YdKki
	 UG3pDTiqThADms/WVek6nYg/lXVUxt9KZrt4TZU/WVsX3WmGlXioa80mdiVA+BQ9e1
	 JmhyxRcH17kDXeDQWA9uVClzoBGABU6bQPSK5/mQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730216AbfBLSI0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 13:08:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbfBLSI0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 13:08:26 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 923892229F;
        Tue, 12 Feb 2019 18:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549994905;
        bh=EmCwvTqdsZJpyiHtUpQh0jB5kneUv90rtq++zvJdOcU=;
        h=From:To:Cc:Subject:Date:From;
        b=ogh65aVFerqUjwgzIcn+4/d5fgKaqYIV47zdahk45+61ZtD1YavnH1BdzOz9HC4aU
         6qV7ZIcnl1OAJQyxIGNfG9EW2qecz2woc1vJtpJNJRlDbP/6Fq1n+dJM+/DpzXI946
         MSUEvRHgt2g2ngMw2jC0LCM/2hb1lVaL1DVb01B8=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/2] fstests: generic, test fsync after succession of renames and unlink
Date:   Tue, 12 Feb 2019 18:08:20 +0000
Message-Id: <20190212180820.31014-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Test that after a combination of file renames, linking and creating a new
file with the old name of a renamed file, if we fsync the new file, after
a power failure we are able to mount the filesystem and all file names
correspond to the correct inodes.

This test is motivated by a bug found in btrfs, which is fixed by applying
the following two patches to the linux kernel:

 "[PATCH 1/2] Btrfs: fix fsync after succession of renames of different files"
 "[PATCH 2/2] Btrfs: fix fsync after succession of renames and unlink/rmdir"

The test passes on ext4, xfs and patched btrfs, however at least in a
5.0-rc5 linux kernel, it fails on f2fs.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/527     | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/527.out |  4 +++
 tests/generic/group   |  1 +
 3 files changed, 76 insertions(+)
 create mode 100755 tests/generic/527
 create mode 100644 tests/generic/527.out

diff --git a/tests/generic/527 b/tests/generic/527
new file mode 100755
index 00000000..aacccd91
--- /dev/null
+++ b/tests/generic/527
@@ -0,0 +1,71 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test No. 527
+#
+# Test that after a combination of file renames, deletions, linking and creating
+# new files with names that were previously deleted, if we fsync the new file,
+# after a power failure we are able to mount the filesystem and all file names
+# correspond to the correct inodes.
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
+mkdir $SCRATCH_MNT/testdir
+echo -n "foo" > $SCRATCH_MNT/testdir/fname1
+echo -n "hello" > $SCRATCH_MNT/testdir/fname2
+
+# Make sure everything done so far is durably persisted.
+sync
+
+# Rename, remove and link files such that one new name corresponds to the name
+# of a deleted file and one new file has the old name of the renamed file. Then
+# fsync only the new file.
+mv $SCRATCH_MNT/testdir/fname1 $SCRATCH_MNT/testdir/fname3
+rm -f $SCRATCH_MNT/testdir/fname2
+ln $SCRATCH_MNT/testdir/fname3 $SCRATCH_MNT/testdir/fname2
+echo -n "bar" > $SCRATCH_MNT/testdir/fname1
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/testdir/fname1
+
+# Simulate a power failure and mount the filesystem to check that all file names
+# exist and correspond to the correct inodes.
+_flakey_drop_and_remount
+
+echo "File fname1 data after power failure: $(cat $SCRATCH_MNT/testdir/fname1)"
+echo "File fname2 data after power failure: $(cat $SCRATCH_MNT/testdir/fname2)"
+echo "File fname3 data after power failure: $(cat $SCRATCH_MNT/testdir/fname3)"
+
+_unmount_flakey
+
+status=0
+exit
diff --git a/tests/generic/527.out b/tests/generic/527.out
new file mode 100644
index 00000000..3c34e1ff
--- /dev/null
+++ b/tests/generic/527.out
@@ -0,0 +1,4 @@
+QA output created by 527
+File fname1 data after power failure: bar
+File fname2 data after power failure: foo
+File fname3 data after power failure: foo
diff --git a/tests/generic/group b/tests/generic/group
index 492a5875..a38c578a 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -529,3 +529,4 @@
 524 auto quick
 525 auto quick rw
 526 auto quick log
+527 auto quick log
-- 
2.11.0

