Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2395BC10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 08:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E58D520874
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 08:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555317042;
	bh=pdG4diIX+XFHkecP1ImvKqqS1ZleUclLWPq69oarY1k=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=mxxxTtXOCqF3RJYYkm7luQUVa+mmAWE9cekBP2G9N+TfB0OpesvkaICG8nCQkv6em
	 Ef5eFz2N9mSFRDoJPcTSvV4S9IWlg89UzUc1Zd4oSnyKIzLbKu35vCYPbguH4060NH
	 i7Sr9U0B7UHPFYdFkt6iIqSnUCqFrz8tCWqpRFEo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfDOIal (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 04:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfDOIal (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 04:30:41 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96CDD20651;
        Mon, 15 Apr 2019 08:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555317040;
        bh=pdG4diIX+XFHkecP1ImvKqqS1ZleUclLWPq69oarY1k=;
        h=From:To:Cc:Subject:Date:From;
        b=kfLXnTsGe7JfTPKTL7PudED03q4QyrteFD/ohaRFIBzre96xO/9QLhIHs+UT77o17
         U4Cp3Wcx3LUTp0K+C3JSfLcwuZk0vEIeeyqKL/HO1gRPG1efPku8K681G3+ggsOx83
         GnL+jZ40A6ZDsKldGc0bL4YoDJ0XrGGogdIWoGIM=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: test send on subvolume with delalloc after setting it to RO mode
Date:   Mon, 15 Apr 2019 09:30:35 +0100
Message-Id: <20190415083035.2271-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Test that if we have a subvolume/snapshot that is writable, has a file
with unflushed delalloc (buffered writes not yet flushed), turn the
subvolume to readonly mode and then use it for send a operation, the send
stream will contain the delalloc data - that is, no data loss happens.

This currently files on btrfs (data loss) but is fixed by a patch for
the linux kernel titled:

  "Btrfs: send, flush dellaloc in order to avoid data loss"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/185     | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/185.out | 14 ++++++++++
 tests/btrfs/group   |  1 +
 3 files changed, 88 insertions(+)
 create mode 100755 tests/btrfs/185
 create mode 100644 tests/btrfs/185.out

diff --git a/tests/btrfs/185 b/tests/btrfs/185
new file mode 100755
index 00000000..8ccffd1e
--- /dev/null
+++ b/tests/btrfs/185
@@ -0,0 +1,73 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test No. 185
+#
+# Test that if we have a subvolume/snapshot that is writable, has a file with
+# unflushed delalloc (buffered writes not yet flushed), turn the subvolume to
+# readonly mode and then use it for send a operation, the send stream will
+# contain the delalloc data - that is, no data loss happens.
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
+	cd /
+	rm -f $tmp.*
+	rm -fr $send_files_dir
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
+_require_btrfs_command "property"
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
+# Create our test subvolume.
+$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/sv | _filter_scratch
+
+# Create our test file with some delalloc data.
+$XFS_IO_PROG -f -c "pwrite -S 0xea 0 108K" $SCRATCH_MNT/sv/foo | _filter_xfs_io
+
+# Turn our subvolume to RO so that it can be used for a send operation.
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT/sv ro true
+
+# Create the send stream.
+$BTRFS_UTIL_PROG send -f $send_files_dir/sv.send $SCRATCH_MNT/sv 2>&1 \
+    | _filter_scratch
+
+echo "File content in the original filesystem:"
+od -t x1 -A d $SCRATCH_MNT/sv/foo
+
+# Recreate the filesystem and apply the send stream and verify no data was lost.
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+$BTRFS_UTIL_PROG receive -f $send_files_dir/sv.send $SCRATCH_MNT
+
+echo "File content in the new filesystem:"
+od -t x1 -A d $SCRATCH_MNT/sv/foo
+
+status=0
+exit
diff --git a/tests/btrfs/185.out b/tests/btrfs/185.out
new file mode 100644
index 00000000..eb432982
--- /dev/null
+++ b/tests/btrfs/185.out
@@ -0,0 +1,14 @@
+QA output created by 185
+Create subvolume 'SCRATCH_MNT/sv'
+wrote 110592/110592 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+At subvol SCRATCH_MNT/sv
+File content in the original filesystem:
+0000000 ea ea ea ea ea ea ea ea ea ea ea ea ea ea ea ea
+*
+0110592
+At subvol sv
+File content in the new filesystem:
+0000000 ea ea ea ea ea ea ea ea ea ea ea ea ea ea ea ea
+*
+0110592
diff --git a/tests/btrfs/group b/tests/btrfs/group
index c1d215bf..6b81ecce 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -187,3 +187,4 @@
 182 auto quick balance
 183 auto quick clone compress punch
 184 auto quick volume
+185 auto quick send volume
-- 
2.11.0

