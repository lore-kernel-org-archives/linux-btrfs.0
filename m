Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61183C00449
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 10:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E9CF20858
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 10:13:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2JR1AWa5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E9CF20858
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbeJHRYQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 13:24:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbeJHRYP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 13:24:15 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D18F82064E;
        Mon,  8 Oct 2018 10:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1538993597;
        bh=WK6xvagR+mqdH6iTEn9wW5/vzdMJv3mTibgF8YQ2RyA=;
        h=From:To:Cc:Subject:Date:From;
        b=2JR1AWa5ZIC1n6O4fX2UJmN8vpJXfapCLx9hxR0g/CP385W3ZJ0YJSazIUjNXYWKc
         kNcZ3GxUssGSFUcvNyT1Kh0WOqI1qCxe3HAtfS3G8G8tqWGdmjP5wBu5ReZQw5nUZ+
         a38A1Ld3CnA1Ox03jKp2HlMofdomg0+OXLeYMQBA=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] generic: test mounting filesystem after fsync of a tmpfile
Date:   Mon,  8 Oct 2018 11:13:13 +0100
Message-Id: <20181008101313.17156-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Test that if we fsync a tmpfile, without adding a hard link to it, and
then power fail, we will be able to mount the filesystem without
triggering any crashes, warnings or corruptions.

This test is motivated by an issue in btrfs where this scenario triggered
a warning (without any side effects). The following linux kernel patch
fixes the issue in btrfs:

  "Btrfs: fix warning when replaying log after fsync of a tmpfile"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/506     | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/506.out |  3 +++
 tests/generic/group   |  1 +
 3 files changed, 62 insertions(+)
 create mode 100755 tests/generic/506
 create mode 100644 tests/generic/506.out

diff --git a/tests/generic/506 b/tests/generic/506
new file mode 100755
index 00000000..7d28d3b0
--- /dev/null
+++ b/tests/generic/506
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test No. 506
+#
+# Test that if we fsync a tmpfile, without adding a hard link to it, and then
+# power fail, we will be able to mount the filesystem without triggering any
+# crashes, warnings or corruptions.
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
+_require_xfs_io_command "-T"
+_require_dm_target flakey
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_require_metadata_journaling $SCRATCH_DEV
+_init_flakey
+_mount_flakey
+
+# Create our tmpfile, write some data to it and fsync it. We want a power
+# failure to happen after the fsync, so that we have an inode with a link
+# count of 0 in our log/journal.
+$XFS_IO_PROG -T \
+	-c "pwrite -S 0xab 0 64K" \
+	-c "fsync" \
+	$SCRATCH_MNT | _filter_xfs_io
+
+# Simulate a power failure and mount the filesystem to check that it succeeds.
+_flakey_drop_and_remount
+
+_unmount_flakey
+
+status=0
+exit
diff --git a/tests/generic/506.out b/tests/generic/506.out
new file mode 100644
index 00000000..f522e663
--- /dev/null
+++ b/tests/generic/506.out
@@ -0,0 +1,3 @@
+QA output created by 506
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/generic/group b/tests/generic/group
index 4da0e188..2e2a6247 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -508,3 +508,4 @@
 503 auto quick dax punch collapse zero
 504 auto quick locks
 505 shutdown auto quick metadata
+506 auto quick log
-- 
2.11.0

