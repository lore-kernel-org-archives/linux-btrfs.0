Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35136 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab2HXBl6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Aug 2012 21:41:58 -0400
Message-ID: <5036DBC8.9000207@cn.fujitsu.com>
Date: Fri, 24 Aug 2012 09:41:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
CC: anand.jain@oracle.com
Subject: [PATCH 1/3] xfstests: fix interference output of the balance program
 in case 265
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The balance program of btrfs outputs the result after it is done, but it
will make the test program fail because the test program thinks it is
not the expected result. So we just throw that information away to fix this
problem.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 265 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/265 b/265
index 10f214f..ec8410c 100755
--- a/265
+++ b/265
@@ -110,7 +110,7 @@ _test_add()
 	for i in `seq 1 $n`; do
 		btrfs device add ${devs[$i]} $SCRATCH_MNT > /dev/null 2>&1 || _fail "device add failed"
 	done
-	btrfs filesystem balance $SCRATCH_MNT || _fail "balance failed"
+	btrfs filesystem balance $SCRATCH_MNT 1> /dev/null || _fail "balance failed"
 	umount $SCRATCH_MNT
 }
 
@@ -153,7 +153,7 @@ _test_replace()
 	# in some system balance fails if there is no delay (a bug)
 	# putting sleep 10 to work around as of now
 	# sleep 10
-	btrfs fi balance $SCRATCH_MNT || _fail "dev balance failed"
+	btrfs fi balance $SCRATCH_MNT 1> /dev/null || _fail "dev balance failed"
 
 	# cleaup. add the removed disk
 	umount $SCRATCH_MNT
-- 
1.7.6.5
