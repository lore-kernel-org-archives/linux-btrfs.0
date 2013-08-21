Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:42433 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3HUQDi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Aug 2013 12:03:38 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id CFC5B9A06AB
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2013 10:03:37 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: [PATCH] xfstests: btrfs/003: stat the dev we're removing to make sure its' really gone
Date: Wed, 21 Aug 2013 12:03:35 -0400
Message-ID: <1377101015-3070-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been periodically failing btrfs/003 because my box sometimes takes a little
longer to unregister the device when we remove it and so the output from btrfs
dev show doesn't match what we are wanting since it still sees the device.  To
fix this just stat and sleep if we still see the device node and only continue
once udev or whatever actually removes the device node so that we don't get
random failures.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/003 |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tests/btrfs/003 b/tests/btrfs/003
index 5c88651..dba1a32 100755
--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -145,6 +145,12 @@ _test_replace()
 	_devmgt_remove ${DEVHTL}
 	dev_removed=1
 
+	stat $ds >> $seqres.full 2>&1
+	while [ $? -eq 0 ]; do
+		sleep 1
+		stat $ds >> $seqres.full 2>&1
+	done
+
 	$BTRFS_UTIL_PROG fi show $SCRATCH_DEV | grep "Some devices missing" >> $seqres.full || _fail \
 							"btrfs did not report device missing"
 
-- 
1.7.7.6

