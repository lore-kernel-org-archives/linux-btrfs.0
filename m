Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F87EC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 18:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61BD32243E
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 18:33:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHFNkEBX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61BD32243E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbeKOEhW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 23:37:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727830AbeKOEhW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 23:37:22 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F38223DD;
        Wed, 14 Nov 2018 18:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542220381;
        bh=IoJvNqCHGCVEUTF9GwTxSpjiNhjfeL+BYUTeCseHGy8=;
        h=From:To:Cc:Subject:Date:From;
        b=kHFNkEBX0sktzX4prOY6VfcKzYTXP27NJuMWJEwFcWR4wJeYZ81/TwGxW0tfojnul
         iIfgUXKbl8bTHj7+JPBzwFm1m169yrxAwUYJf7KfRAM1t16W6dsKfdprM43F5TtdTs
         62Yflr+kMDRQCyDTiRjEJHKeCmIXM4rs5WeFnYgY=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, robbieko@synology.com,
        Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: test send after radical changes in a complex directory hierarchy
Date:   Wed, 14 Nov 2018 18:32:56 +0000
Message-Id: <20181114183256.19947-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Test an incremental send operation in a scenario where the relationship
of ancestor-descendant between multiple directories is inversed, and
where multiple directories that were previously ancestors of another
directory now become descendents of multiple directories that used to be
their ancestors in the parent snapshot. This used to trigger an
infinite loop in the kernel code.

This is motivated by a bug found in btrfs which is fixed by the following
patch for the linux kernel:

  "Btrfs: send, fix infinite loop due to directory rename dependencies"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/178     | 190 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/178.out |   6 ++
 tests/btrfs/group   |   1 +
 3 files changed, 197 insertions(+)
 create mode 100755 tests/btrfs/178
 create mode 100644 tests/btrfs/178.out

diff --git a/tests/btrfs/178 b/tests/btrfs/178
new file mode 100755
index 00000000..e277fbee
--- /dev/null
+++ b/tests/btrfs/178
@@ -0,0 +1,190 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2017 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test No. btrfs/178
+#
+# Test an incremental send operation in a scenario where the relationship of
+# ancestor-descendant between multiple directories is inversed, and where
+# multiple directories that were previously ancestors of another directory now
+# become descendents of multiple directories that used to be their ancestors in
+# the parent snapshot. This used to trigger an infinite loop in the kernel code.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -fr $send_files_dir
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_test
+_require_scratch
+_require_fssum
+
+send_files_dir=$TEST_DIR/btrfs-test-$seq
+
+rm -f $seqres.full
+rm -fr $send_files_dir
+mkdir $send_files_dir
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+# The name of each directory corresponds to its inode number, to make it easier
+# to debug since btrfs' send processes inodes in ascending order according to
+# their number.
+mkdir $SCRATCH_MNT/257
+mkdir $SCRATCH_MNT/258
+mv $SCRATCH_MNT/257 $SCRATCH_MNT/258/257
+mkdir $SCRATCH_MNT/259
+mkdir $SCRATCH_MNT/260
+mkdir $SCRATCH_MNT/261
+mkdir $SCRATCH_MNT/262
+mkdir $SCRATCH_MNT/263
+mkdir $SCRATCH_MNT/264
+mv $SCRATCH_MNT/258 $SCRATCH_MNT/264/258
+mkdir $SCRATCH_MNT/265
+mkdir $SCRATCH_MNT/266
+mv $SCRATCH_MNT/259 $SCRATCH_MNT/266/259
+mv $SCRATCH_MNT/260 $SCRATCH_MNT/266/260
+mv $SCRATCH_MNT/264 $SCRATCH_MNT/266/264
+mv $SCRATCH_MNT/265 $SCRATCH_MNT/266/265
+mkdir $SCRATCH_MNT/266/260/267
+mkdir $SCRATCH_MNT/266/268
+mkdir $SCRATCH_MNT/266/269
+mv $SCRATCH_MNT/262 $SCRATCH_MNT/266/269/262
+mkdir $SCRATCH_MNT/266/270
+mkdir $SCRATCH_MNT/271
+mv $SCRATCH_MNT/266 $SCRATCH_MNT/271/266
+mkdir $SCRATCH_MNT/271/266/272
+mv $SCRATCH_MNT/263 $SCRATCH_MNT/271/266/272/263
+mkdir $SCRATCH_MNT/273
+mkdir $SCRATCH_MNT/271/266/274
+mv $SCRATCH_MNT/273 $SCRATCH_MNT/271/266/274/273
+mkdir $SCRATCH_MNT/271/266/272/275
+mv $SCRATCH_MNT/271 $SCRATCH_MNT/261/271
+
+# Filesystem looks like:
+#
+# .
+# |--- 261/
+#       |--- 271/
+#             |--- 266/
+#                   |--- 259/
+#                   |--- 260/
+#                   |     |--- 267
+#                   |
+#                   |--- 264/
+#                   |     |--- 258/
+#                   |           |--- 257/
+#                   |
+#                   |--- 265/
+#                   |--- 268/
+#                   |--- 269/
+#                   |     |--- 262/
+#                   |
+#                   |--- 270/
+#                   |--- 272/
+#                   |     |--- 263/
+#                   |     |--- 275/
+#                   |
+#                   |--- 274/
+#                         |--- 273/
+#
+$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+	$SCRATCH_MNT/mysnap1 > /dev/null
+
+$BTRFS_UTIL_PROG send -f $send_files_dir/1.snap \
+	$SCRATCH_MNT/mysnap1 2>&1 1>/dev/null | _filter_scratch
+
+mv $SCRATCH_MNT/261/271/266/272/275 $SCRATCH_MNT/275
+mv $SCRATCH_MNT/261/271/266/274 $SCRATCH_MNT/275/274
+mv $SCRATCH_MNT/261/271/266/269/262 $SCRATCH_MNT/275/274/273/262
+mv $SCRATCH_MNT/261/271/266/269 $SCRATCH_MNT/275/274/273/262/269
+mv $SCRATCH_MNT/261/271/266/264/258/257 $SCRATCH_MNT/261/271/266/272
+mv $SCRATCH_MNT/261/271/266/264/258 $SCRATCH_MNT/275/274/273/262/269/258
+mv $SCRATCH_MNT/261/271 $SCRATCH_MNT/275/274/273/262/269/258/271
+mv $SCRATCH_MNT/275/274/273/262/269/258/271/266/268 \
+	$SCRATCH_MNT/275/274/273/262/269/258/271/268
+mv $SCRATCH_MNT/275/274/273/262/269/258/271/266/260/267 \
+	$SCRATCH_MNT/275/274/273/262/269/258/271/268/267
+mv $SCRATCH_MNT/275/274/273/262/269/258/271/266/270 \
+	$SCRATCH_MNT/275/274/273/262/269/258/271/268/267/270
+mv $SCRATCH_MNT/275/274/273/262/269/258/271/266/265 \
+	$SCRATCH_MNT/275/274/273/262/269/258/271/266/259/265
+mv $SCRATCH_MNT/275/274/273/262/269/258/271/266/259 \
+	$SCRATCH_MNT/275/274/273/262/269/258/271/268/267/270/259
+mv $SCRATCH_MNT/275/274/273/262/269/258/271/266/272/263 \
+	$SCRATCH_MNT/275/274/273/262/269/258/271/266/264/263
+mv $SCRATCH_MNT/275/274/273/262/269/258/271/266/272 \
+	$SCRATCH_MNT/275/274/273/262/269/258/271/268/267/270/272
+mv $SCRATCH_MNT/275/274/273/262/269/258/271/266/260 \
+	$SCRATCH_MNT/275/274/273/262/269/258/271/268/267/270/272/257/260
+mv $SCRATCH_MNT/275/274/273/262/269/258/271/266/264 \
+	$SCRATCH_MNT/275/274/273/262/269/258/271/268/267/270/272/257/264
+mv $SCRATCH_MNT/261 \
+	$SCRATCH_MNT/275/274/273/262/269/258/271/268/267/270/272/257/264/263/261
+mv $SCRATCH_MNT/275/274/273/262/269/258/271/266 \
+	$SCRATCH_MNT/275/274/273/262/269/258/271/268/267/270/272/257/264/263/261/266
+
+# Filesystem now looks like:
+#
+# .
+# |-- 275/
+#      |-- 274/
+#           |-- 273/
+#                |-- 262/
+#                     |-- 269/
+#                          |-- 258/
+#                               |-- 271/
+#                                    |-- 268/
+#                                         |-- 267/
+#                                              |-- 270/
+#                                                   |-- 259/
+#                                                   |    |-- 265/
+#                                                   |
+#                                                   |-- 272/
+#                                                        |-- 257/
+#                                                             |-- 260/
+#                                                             |-- 264/
+#                                                                  |-- 263/
+#                                                                       |-- 261/
+#                                                                            |-- 266/
+#
+$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+		 $SCRATCH_MNT/mysnap2 > /dev/null
+$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 -f $send_files_dir/2.snap \
+		 $SCRATCH_MNT/mysnap2 2>&1 1>/dev/null | _filter_scratch
+
+$FSSUM_PROG -A -f -w $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+$FSSUM_PROG -A -f -w $send_files_dir/2.fssum \
+	-x $SCRATCH_MNT/mysnap2/mysnap1 $SCRATCH_MNT/mysnap2
+
+# Now recreate the filesystem by receiving both send streams and verify we get
+# the same content that the original filesystem had.
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+$BTRFS_UTIL_PROG receive -f $send_files_dir/1.snap $SCRATCH_MNT > /dev/null
+$BTRFS_UTIL_PROG receive -f $send_files_dir/2.snap $SCRATCH_MNT > /dev/null
+$FSSUM_PROG -r $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+$FSSUM_PROG -r $send_files_dir/2.fssum $SCRATCH_MNT/mysnap2
+
+status=0
+exit
diff --git a/tests/btrfs/178.out b/tests/btrfs/178.out
new file mode 100644
index 00000000..575ac457
--- /dev/null
+++ b/tests/btrfs/178.out
@@ -0,0 +1,6 @@
+QA output created by 178
+At subvol SCRATCH_MNT/mysnap1
+At subvol SCRATCH_MNT/mysnap2
+At subvol mysnap1
+OK
+OK
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 24c4fb35..b78ed37f 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -180,3 +180,4 @@
 175 auto quick swap volume
 176 auto quick swap volume
 177 auto quick swap balance
+178 auto quick send
-- 
2.11.0

