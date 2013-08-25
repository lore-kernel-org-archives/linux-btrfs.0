Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:35168 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3HYPGQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Aug 2013 11:06:16 -0400
Received: from /spool/local
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 26 Aug 2013 00:59:00 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id B8EDD2BB0054
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 01:06:08 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r7PEo5ME1769806
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 00:50:06 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r7PF67fJ032152
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 01:06:08 +1000
From: chandan <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: david@fromorbit.com, sekharan@linux.vnet.ibm.com
Subject: [PATCH] xfstests: generic/255: Execute only if blocksize <= 4096
Date: Sun, 25 Aug 2013 20:36 +0530
Message-ID: <2909046.09LYLQvZ6q@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patch adds the function _require_le_4k_blocksize to perform the
block size check on $TEST_DEV and $SCRATCH_DEV.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 common/rc         | 10 ++++++++++
 tests/generic/255 |  1 +
 2 files changed, 11 insertions(+)

diff --git a/common/rc b/common/rc
index ae80b12..d8ee132 100644
--- a/common/rc
+++ b/common/rc
@@ -2106,6 +2106,16 @@ _require_dumpe2fs()
 	fi
 }
 
+_require_le_4k_blocksize()
+{
+	test_dev_bs=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
+	scratch_dev_bs=`stat -f $SCRATCH_DEV | grep "Block size" | cut -d " " -f3`
+
+	if (( $test_dev_bs > 4096 || $scratch_dev_bs > 4096 )); then
+		_notrun "This test requires a filesystem with a block size less than or equal to 4k."
+	fi
+}
+
 _create_loop_device()
 {
 	file=$1
diff --git a/tests/generic/255 b/tests/generic/255
index dd329b4..763e861 100755
--- a/tests/generic/255
+++ b/tests/generic/255
@@ -49,6 +49,7 @@ _supported_os Linux
 _require_xfs_io_falloc_punch
 _require_xfs_io_falloc
 _require_xfs_io_fiemap
+_require_le_4k_blocksize
 
 testfile=$TEST_DIR/255.$$
 
-- 
1.8.3.1


