Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1937 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753294AbaA3WBb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 17:01:31 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: [PATCH] xfstests: generic/299 can have truncate fail
Date: Thu, 30 Jan 2014 17:01:23 -0500
Message-ID: <1391119283-11116-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So this test does lots of fallocate/truncate noise while doing aio overwrites to
try and exercise a deadlock found in ext4.  Because it runs so hard with ENOSPC
it can sometimes cause truncate to fail on btrfs.  This is ok and doesn't affect
the validity of the test, we just need to catch the output so it doesn't cause
the test to fail.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 tests/generic/299 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/299 b/tests/generic/299
index 14cce96..bf02c94 100755
--- a/tests/generic/299
+++ b/tests/generic/299
@@ -130,7 +130,7 @@ _workout()
 	    done
 	    for ((k=1; k <= NUM_JOBS; k++))
 	    do
-		truncate -s 0 $SCRATCH_MNT/direct_aio.$k.0
+		truncate -s 0 $SCRATCH_MNT/direct_aio.$k.0 >> $seqres.full 2>&1
 	    done
 	    # Following like will check that pid is still run.
 	    # Once fio exit we can stop fallocate/truncate loop
-- 
1.8.3.1

