Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:58830 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3G2Sz7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 14:55:59 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 5D6C39A0403
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jul 2013 12:55:59 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>, <jeff.liu@oracle.com>,
        <sandeen@redhat.com>
Subject: [PATCH] xfstests: generic/315: allow a little tolerance for our used check
Date: Mon, 29 Jul 2013 14:55:56 -0400
Message-ID: <1375124156-17620-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So df in btrfs is tricky at best, and relying on it for accurate information is
not great, but it's the best way to verify this test.  To get around btrfs being
inconsistent sometimes just use _within_tolerance to check our new df value to
make sure that our truncate did something.  With this patch I no longer see
transient failures of this test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/generic/315 |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tests/generic/315 b/tests/generic/315
index 7cfc40d..9c01b5e 100644
--- a/tests/generic/315
+++ b/tests/generic/315
@@ -73,7 +73,8 @@ sync
 
 # Preallocated disk space should be released
 avail_done=`df -P $TEST_DIR | awk 'END {print $4}'`
-[ "$avail_done" -eq "$avail_begin" ] || _fail "Available disk space ($avail_done KiB)"
+_within_tolerance "df" $avail_done $avail_begin 1%
+[ $? -eq 0 ] || _fail "Available disk space ($avail_done KiB) wanted ($avail_begin KiB)"
 
 # success, all done
 exit
-- 
1.7.7.6

