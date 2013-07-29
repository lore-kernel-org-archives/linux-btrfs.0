Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:57736 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3G2RVH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 13:21:07 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 1F6F59A0368
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jul 2013 11:21:06 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>, <jeff.liu@oracle.com>
Subject: [PATCH] xfstests: generic/315: add one more sync and more output
Date: Mon, 29 Jul 2013 13:21:03 -0400
Message-ID: <1375118463-29654-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So df in btrfs is tricky at best, and relying on it for accurate information is
not great, but it's the best way to verify this test.  So we need to add another
sync to make sure the pinned blocks are all freed up and the df space is really
really accurate, otherwise we end up with this test failling because the df
after the test is slightly off (in my case it was like 36kb off).  With this
patch I'm not seeing random failures of this test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/generic/315 |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tests/generic/315 b/tests/generic/315
index 7cfc40d..7c55b8a 100644
--- a/tests/generic/315
+++ b/tests/generic/315
@@ -70,10 +70,11 @@ fsize=`ls -l $TEST_DIR/testfile.$seq | awk '{print $5}'`
 # Truncate the file size back to 0
 truncate -s 0 $TEST_DIR/testfile.$seq
 sync
+sync
 
 # Preallocated disk space should be released
 avail_done=`df -P $TEST_DIR | awk 'END {print $4}'`
-[ "$avail_done" -eq "$avail_begin" ] || _fail "Available disk space ($avail_done KiB)"
+[ "$avail_done" -eq "$avail_begin" ] || _fail "Available disk space ($avail_done KiB) wanted ($avail_begin KiB)"
 
 # success, all done
 exit
-- 
1.7.7.6

