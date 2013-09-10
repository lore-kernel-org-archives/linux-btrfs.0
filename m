Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:60851 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3IJNjp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 09:39:45 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 6B7547C069F
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Sep 2013 07:39:45 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: [PATCH] xfstests: generic/274 increase scratch fs size to 2g
Date: Tue, 10 Sep 2013 09:39:02 -0400
Message-ID: <1378820342-6748-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With 1 gig btrfs defaults to mixed block groups, so we ENOSPC in this test
because we run out of metadata space, not data space.  Increasing to 2g allows
us to use our normal setup and allows us to pass this test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/generic/274 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tests/generic/274 b/tests/generic/274
index da45fab..7c4887f 100755
--- a/tests/generic/274
+++ b/tests/generic/274
@@ -57,7 +57,7 @@ echo "------------------------------"
 rm -f $seqres.full
 
 umount $SCRATCH_DEV 2>/dev/null
-_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
 _scratch_mount
 
 # Create a 4k file and Allocate 4M past EOF on that file
-- 
1.7.7.6

