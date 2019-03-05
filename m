Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D6FC43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 09:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA5D62082C
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 09:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551777992;
	bh=beJfQs02kujt1+lXJyBpPIOR075Rs3C1Gwlf0Bv8F34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mkLeC+5MkAgOqr5z1FcZc5QQ2Cb1GZK3idYi8Te2o5FQdbCkkpmRbz0r8IDD72HN2
	 80caPjlbidZ9ZJQ8DY6VP/GqCVM6D9ZZBY2S4Qgxr1g8M2vTRxNkm+dik28ciSw/TV
	 xBiCuepENF8+/sWHbZmqxp0PYLB4HkfLVt/W+1gc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfCEJ0b (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Mar 2019 04:26:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfCEJ0b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Mar 2019 04:26:31 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 028FE206DD;
        Tue,  5 Mar 2019 09:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551777989;
        bh=beJfQs02kujt1+lXJyBpPIOR075Rs3C1Gwlf0Bv8F34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slwQjP82cZGPQaVjM2BYbHK4JEmMZGk8ThKEkBVheiC3LHCJxvEA+WvJGaUhFQFth
         pBvy8Nt5u6BFqODIzhGr9QVTR7tKOOhPY7cf/O4hpfzsHL+thysZUIKcZ0SOKxHhno
         JsS/H6qB+2F8/FyYjn/Amh9g5Fvt6acMIvsp6H+Q=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] generic: add test for fsync after shrinking truncate and rename
Date:   Tue,  5 Mar 2019 09:26:23 +0000
Message-Id: <20190305092623.23047-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190304140622.23997-1-fdmanana@kernel.org>
References: <20190304140622.23997-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Test that if we truncate a file to reduce its size, rename it and then
fsync it, after a power failure the file has a correct size and name.

This test is motivated by a bug found in btrfs, which is fixed by a
patch for the linux kernel titled:

  "Btrfs: fix incorrect file size after shrinking truncate and fsync"

This test currently passes on ext4, xfs, f2fs and patched btrfs.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Added fsync on directory after the rename, to ensure the rename is
    persisted for filesystem that don't guarantee strictly ordered
    metadata (ext4, xfs and f2fs provide that, even old reiserfs).

 tests/generic/532     | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/532.out |  8 +++++++
 tests/generic/group   |  1 +
 3 files changed, 74 insertions(+)
 create mode 100755 tests/generic/532
 create mode 100644 tests/generic/532.out

diff --git a/tests/generic/532 b/tests/generic/532
new file mode 100755
index 00000000..9a9f9deb
--- /dev/null
+++ b/tests/generic/532
@@ -0,0 +1,65 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test No. 532
+#
+# Test that if we truncate a file to reduce its size, rename it and then fsync
+# it, after a power failure the file has a correct size and name.
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
+# Create our test file with an initial size of 8000 bytes, then fsync it,
+# followed by a truncate that reduces its size down to 3000 bytes.
+$XFS_IO_PROG -f -c "pwrite -S 0xab 0 8000" \
+	     -c "fsync" \
+	     -c "truncate 3000" \
+	     $SCRATCH_MNT/foo | _filter_xfs_io
+
+# Now rename the file and fsync it again.
+mv $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
+# Fsync the parent directory to ensure the rename is persisted.
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/
+
+# Simulate a power failure and mount the filesystem to check that the file was
+# persisted with the new name and has a size of 3000 bytes.
+_flakey_drop_and_remount
+
+echo "File content after power failure:"
+od -A d -t x1 $SCRATCH_MNT/bar
+
+_unmount_flakey
+
+status=0
+exit
diff --git a/tests/generic/532.out b/tests/generic/532.out
new file mode 100644
index 00000000..554fbe2a
--- /dev/null
+++ b/tests/generic/532.out
@@ -0,0 +1,8 @@
+QA output created by 532
+wrote 8000/8000 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File content after power failure:
+0000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab
+*
+0002992 ab ab ab ab ab ab ab ab
+0003000
diff --git a/tests/generic/group b/tests/generic/group
index 31011ac8..7d63f303 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -534,3 +534,4 @@
 529 auto quick attr
 530 auto quick unlink
 531 auto quick unlink
+532 auto quick log
-- 
2.11.0

