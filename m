Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB968C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 18:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF4BF2229F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 18:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549994895;
	bh=8SeN/WKt1+NdN2M0zDqZfqrkiQwLBplmD5rUwrwM7/I=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=AEgYKhbxOdLF1W9OJ0OaU1L4DL2xv4+6LA5Woml254BvknRhNoFz+LR+qa/P4Rr50
	 wcX6lEQvnSBNgAtMhKgb1p0xlIBpEL2NWWfuynfqf9iCkXkHRfgvagfMkI1OVJzp1j
	 0sfm2dm/LhfWwS8ZnO6iaLKFGhv3pw9fUi07B/VY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbfBLSIP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 13:08:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbfBLSIO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 13:08:14 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 144672229F;
        Tue, 12 Feb 2019 18:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549994893;
        bh=8SeN/WKt1+NdN2M0zDqZfqrkiQwLBplmD5rUwrwM7/I=;
        h=From:To:Cc:Subject:Date:From;
        b=m06ztwS//uewfBOUKo/fbUwl0SIT6nkwTqS63Uwk1/tas16PQZLQKILkahud9rOmE
         7BiR6htvfgjCUqkZgzBpslwq2TwjaTkCq0JMzBWaOEIP/hUBMnOwVHut42osM4B4xG
         LMN1Pk3IJp3PekrB6HhJJLVkGXFUjYHc4d+ZHhig=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 1/2] fstests: generic, test fsync after succession of file renames
Date:   Tue, 12 Feb 2019 18:08:07 +0000
Message-Id: <20190212180807.26368-1-fdmanana@kernel.org>
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

This test is motivated by a bug found in btrfs which is fixed by a patch
for the linux kernel titled:

  "Btrfs: fix fsync after succession of renames of different files"

The test passes on ext4, xfs and patched btrfs, however at least in a
5.0-rc5 linux kernel, it fails on f2fs.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/526     | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/526.out |  5 ++++
 tests/generic/group   |  1 +
 3 files changed, 78 insertions(+)
 create mode 100755 tests/generic/526
 create mode 100644 tests/generic/526.out

diff --git a/tests/generic/526 b/tests/generic/526
new file mode 100755
index 00000000..d0b51f87
--- /dev/null
+++ b/tests/generic/526
@@ -0,0 +1,72 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test No. 526
+#
+# Test that after a combination of file renames, linking and creating a new file
+# with the old name of a renamed file, if we fsync the new file, after a power
+# failure we are able to mount the filesystem and all file names correspond to
+# the correct inodes.
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
+# Rename and link files such that one new name corresponds to the name of
+# another renamed file and one new file has the old name of one of the renamed
+# files. Then fsync only the new file.
+mv $SCRATCH_MNT/testdir/fname1 $SCRATCH_MNT/testdir/fname3
+mv $SCRATCH_MNT/testdir/fname2 $SCRATCH_MNT/testdir/fname4
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
+echo "File fname4 data after power failure: $(cat $SCRATCH_MNT/testdir/fname4)"
+
+_unmount_flakey
+
+status=0
+exit
diff --git a/tests/generic/526.out b/tests/generic/526.out
new file mode 100644
index 00000000..83979d28
--- /dev/null
+++ b/tests/generic/526.out
@@ -0,0 +1,5 @@
+QA output created by 526
+File fname1 data after power failure: bar
+File fname2 data after power failure: foo
+File fname3 data after power failure: foo
+File fname4 data after power failure: hello
diff --git a/tests/generic/group b/tests/generic/group
index cfd003d3..492a5875 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -528,3 +528,4 @@
 523 auto quick attr
 524 auto quick
 525 auto quick rw
+526 auto quick log
-- 
2.11.0

