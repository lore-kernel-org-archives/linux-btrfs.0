Return-Path: <SRS0=W6bw=RH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9B4C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 14:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7736208E4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 14:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551708389;
	bh=A/+VXyg8RmeBDVbEZHQZSJk6NOtA2HEwinqyxjvMV84=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=KbGIKuppzXyF4KnUG8ZARTXyTv/BneZ4KTobmzpAbEh469atzvtzwemx0PVEUqbLq
	 fHxwztD5jhgklUWKhwUyxStXL+waNMnaz3U2OEb82yWfg37WrQ2hbD6u5tfDJeZ9AY
	 NbWTCA6tuCTfgLAZBeiu8fq9hQOIqK4v4ljGpPu0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbfCDOG3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Mar 2019 09:06:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:43946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbfCDOG3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Mar 2019 09:06:29 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B25B520815;
        Mon,  4 Mar 2019 14:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551708387;
        bh=A/+VXyg8RmeBDVbEZHQZSJk6NOtA2HEwinqyxjvMV84=;
        h=From:To:Cc:Subject:Date:From;
        b=reoznzFDgP3jJlnNTjotQTalgNlMKX+6bP6BYhgnzgA4gPUBa3T7Ad6XvVc1fFpHb
         hDwPwEkWufdvNAhYL4TMe1zUFeOsIU0UgfxKfDsrWP3QvBufevwfIiuUCFXiJqvRa+
         3jg+jsE7Xy+aHVxE8fu6/ux4WVCg7t+2cO8zbRUE=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] generic: add test for fsync after shrinking truncate and rename
Date:   Mon,  4 Mar 2019 14:06:22 +0000
Message-Id: <20190304140622.23997-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
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
 tests/generic/532     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/532.out |  8 +++++++
 tests/generic/group   |  1 +
 3 files changed, 75 insertions(+)
 create mode 100755 tests/generic/532
 create mode 100644 tests/generic/532.out

diff --git a/tests/generic/532 b/tests/generic/532
new file mode 100755
index 00000000..64992d85
--- /dev/null
+++ b/tests/generic/532
@@ -0,0 +1,66 @@
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
+
+# Simulate a power failure and mount the filesystem to check that the file was
+# persisted with the new name and has a size of 3000 bytes.
+_flakey_drop_and_remount
+
+[ -f $SCRATCH_MNT/bar ] || echo "file name 'bar' is missing"
+[ -f $SCRATCH_MNT/foo ] && echo "file name 'foo' still exists"
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

