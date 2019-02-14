Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB41C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 15:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68147222D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 15:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550157527;
	bh=/NzQUm/6/j4Jzm15sIwwj8v0NsWqah1ECbIzXcmmu+8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=WS/5AhAK6yuExAkh7Do34xBCJWwQLqtOgse0gmvsqoJwny3u+YKZmyk1qqc+zXcIR
	 A0puYwrnWYTMoaCyj9JKO+VuzmzMm6cczsJPa07XoPmI19sWy/m9znzqH7M6XtQNV7
	 2M32mPpv1NN4JUF4a8QK4vyPOxxOtyqHk8W8BSS8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395326AbfBNPSq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 10:18:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390720AbfBNPSq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 10:18:46 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33248222C9;
        Thu, 14 Feb 2019 15:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550157525;
        bh=/NzQUm/6/j4Jzm15sIwwj8v0NsWqah1ECbIzXcmmu+8=;
        h=From:To:Cc:Subject:Date:From;
        b=FVUy+sM4gmvHChXrTxlfEysE3YHfh/2rcAs0ZqcFRGWHvYyvrWKFaeG6JDRUg0ao6
         IETY4uOiIDuiT/tWjuPhEylTbWM5KfwQ2MjYJLmDdySpyo+8qFIqc6tnzhToOTW1j7
         6GZkdzHjVTMtMxgImjZAmywTzVJkxXK9pnJp11Z8=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: btrfs, test for corruption when reading compressed files
Date:   Thu, 14 Feb 2019 15:18:39 +0000
Message-Id: <20190214151839.23619-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Regression test for read corruption of compressed and shared extents after
punching holes into a file. The same extent is shared by the same file in
consecutive ranges (without other extents in between).

This is motivated by a bug recently found in btrfs for which there is a
patch for the linux kernel titled:

  "Btrfs: fix corruption reading shared and compressed extents after hole
   punching"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/183     | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/183.out | 21 +++++++++++++++
 tests/btrfs/group   |  1 +
 3 files changed, 98 insertions(+)
 create mode 100755 tests/btrfs/183
 create mode 100644 tests/btrfs/183.out

diff --git a/tests/btrfs/183 b/tests/btrfs/183
new file mode 100755
index 00000000..ddd83c2d
--- /dev/null
+++ b/tests/btrfs/183
@@ -0,0 +1,76 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FSQA Test No. 183
+#
+# Regression test for read corruption of compressed and shared extents after
+# punching holes into a file.
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
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "fpunch"
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount "-o compress"
+
+# Create a file with 3 consecutive compressed extents, each corresponds to 128Kb
+# of data (uncompressed size) and each is stored on disk as a 4Kb extent
+# (compressed size, regardless of compression algorithm used).
+# Each extent starts with 4Kb of zeroes, while the remaining bytes all have a
+# value of 0xff.
+$XFS_IO_PROG -f -c "pwrite -S 0xff 0 384K" \
+	     -c "pwrite -S 0x00 0 4K" \
+	     -c "pwrite -S 0x00 128K 4K" \
+	     -c "pwrite -S 0x00 256K 4K" \
+	     $SCRATCH_MNT/foobar | _filter_xfs_io
+
+echo "File digest after initial creation:"
+md5sum $SCRATCH_MNT/foobar | _filter_scratch
+
+# Clone the first extent into offsets 128K and 256K.
+$XFS_IO_PROG -c "reflink $SCRATCH_MNT/foobar 0 128K 128K" \
+	     -c "reflink $SCRATCH_MNT/foobar 0 256K 128K" \
+	     $SCRATCH_MNT/foobar | _filter_xfs_io
+
+echo "File digest after reflinking:"
+md5sum $SCRATCH_MNT/foobar | _filter_scratch
+
+# Punch holes into the regions that are already full of zeroes.
+$XFS_IO_PROG -c "fpunch 0 4K" \
+	     -c "fpunch 128K 4K" \
+	     -c "fpunch 256K 4K" \
+	     $SCRATCH_MNT/foobar
+
+echo "File digest after punching holes:"
+md5sum $SCRATCH_MNT/foobar | _filter_scratch
+
+echo 1 > /proc/sys/vm/drop_caches
+
+echo "File digest after dropping page cache:"
+md5sum $SCRATCH_MNT/foobar | _filter_scratch
+
+status=0
+exit
diff --git a/tests/btrfs/183.out b/tests/btrfs/183.out
new file mode 100644
index 00000000..36fe3ba8
--- /dev/null
+++ b/tests/btrfs/183.out
@@ -0,0 +1,21 @@
+QA output created by 183
+wrote 393216/393216 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 131072
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 262144
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest after initial creation:
+5a0888d80d7ab1fd31c229f83a3bbcc8  SCRATCH_MNT/foobar
+linked 131072/131072 bytes at offset 131072
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+linked 131072/131072 bytes at offset 262144
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest after reflinking:
+5a0888d80d7ab1fd31c229f83a3bbcc8  SCRATCH_MNT/foobar
+File digest after punching holes:
+5a0888d80d7ab1fd31c229f83a3bbcc8  SCRATCH_MNT/foobar
+File digest after dropping page cache:
+5a0888d80d7ab1fd31c229f83a3bbcc8  SCRATCH_MNT/foobar
diff --git a/tests/btrfs/group b/tests/btrfs/group
index e32c84e4..d1eeb90a 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -185,3 +185,4 @@
 180 auto quick qgroup limit
 181 auto quick balance
 182 auto quick balance
+183 auto quick clone compress punch
-- 
2.11.0

