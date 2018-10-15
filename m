Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27139C28CF8
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 08:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA9402064E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 08:51:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnymZym3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA9402064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbeJOQfj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 12:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbeJOQfj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 12:35:39 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 678432054F;
        Mon, 15 Oct 2018 08:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539593480;
        bh=51hkWnWenhCMUScsU9qnouBNbmjslad9Q6/Ui1V9Sak=;
        h=From:To:Cc:Subject:Date:From;
        b=GnymZym3LRoiqnNTPm/0v/BTw5zYWIbd8BOferFzkMDlqX8mlF5ON54mX00IYEBOF
         cdIXzKi+zPs1v/hyJC99bnyXBVgqw3EGoKz0gSSqkba3z1lUovsC8mzqFkZKX7GvRP
         et9VfpYLCU+kb6d2cX2bhTI/c37Lr22wMnWqXGwI=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] generic: test fsync after fallocate on a very small file
Date:   Mon, 15 Oct 2018 09:51:17 +0100
Message-Id: <20181015085117.5767-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Test that if we have a very small file, with a size smaller than the
block size, then fallocate a very small range within the block size but
past the file's current size, fsync the file and then power fail, after
mounting the filesystem all the file data is there and the file size is
correct.

This test is motivated by a failure in btrfs where it triggered an
assertion when using the no-holes feature, that is, when running with
MKFS_OPTIONS="-O no-holes". The btrfs issue is fixed by a patch for the
linux kernel titled:

 "Btrfs: fix assertion on fsync of regular file when using no-holes
  feature"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/512     | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/512.out |  9 ++++++++
 tests/generic/group   |  1 +
 3 files changed, 71 insertions(+)
 create mode 100755 tests/generic/512
 create mode 100644 tests/generic/512.out

diff --git a/tests/generic/512 b/tests/generic/512
new file mode 100755
index 00000000..f4e13c68
--- /dev/null
+++ b/tests/generic/512
@@ -0,0 +1,61 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test No. 512
+#
+# Test that if we have a very small file, with a size smaller than the block
+# size, then fallocate a very small range within the block size but past the
+# file's current size, fsync the file and then power fail, after mounting the
+# filesystem all the file data is there and the file size is correct.
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
+_require_xfs_io_command "falloc"
+_require_dm_target flakey
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_require_metadata_journaling $SCRATCH_DEV
+_init_flakey
+_mount_flakey
+
+$XFS_IO_PROG -f \
+	     -c "pwrite -S 0xb6 0 21" \
+	     -c "falloc 40 40" \
+	     -c "fsync" \
+	     $SCRATCH_MNT/foobar | _filter_xfs_io
+
+# Simulate a power failure and mount the filesystem. We expect no data loss
+# and a correct file size.
+_flakey_drop_and_remount
+
+echo "File content after power failure:"
+od -t x1 -A d $SCRATCH_MNT/foobar
+
+_unmount_flakey
+
+status=0
+exit
diff --git a/tests/generic/512.out b/tests/generic/512.out
new file mode 100644
index 00000000..19a0a1b1
--- /dev/null
+++ b/tests/generic/512.out
@@ -0,0 +1,9 @@
+QA output created by 512
+wrote 21/21 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File content after power failure:
+0000000 b6 b6 b6 b6 b6 b6 b6 b6 b6 b6 b6 b6 b6 b6 b6 b6
+0000016 b6 b6 b6 b6 b6 00 00 00 00 00 00 00 00 00 00 00
+0000032 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0000080
diff --git a/tests/generic/group b/tests/generic/group
index 348214ac..d17a0248 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -514,3 +514,4 @@
 509 auto quick log
 510 auto quick log
 511 auto quick rw zero
+512 auto quick log prealloc
-- 
2.11.0

