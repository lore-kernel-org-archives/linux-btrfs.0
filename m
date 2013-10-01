Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54168 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab3JAM6g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 08:58:36 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 5355C7C069E
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Oct 2013 06:58:36 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id 9yvnTpA5Aj5HcW0S (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 01 Oct 2013 06:58:35 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add a test image for the transid fixer in btrfsck
Date: Tue, 1 Oct 2013 08:58:33 -0400
Message-ID: <1380632313-1240-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a verification test for the transid recow functionality of btrfsck.
I've also adjusted the test script to spit out which image it's testing so I can
be sure the image was getting tested.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/fsck-tests.sh                  |   1 +
 tests/fsck-tests/002-bad-transid.img | Bin 0 -> 4096 bytes
 2 files changed, 1 insertion(+)
 create mode 100644 tests/fsck-tests/002-bad-transid.img

diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
index c1490bf..25c390d 100644
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -17,6 +17,7 @@ rm -f fsck-tests-results.txt
 
 for i in $(find $here/tests/fsck-tests -name '*.img')
 do
+	echo "     [TEST]    $(basename $i)"
 	echo "testing image $i" >> fsck-tests-results.txt
 	$here/btrfs-image -r $i test.img >> fsck-tests-results.txt 2>&1 \
 		|| _fail "restore failed"
diff --git a/tests/fsck-tests/002-bad-transid.img b/tests/fsck-tests/002-bad-transid.img
new file mode 100644
index 0000000000000000000000000000000000000000..85bd87cd625e4c25c40fa9db423525f7af6c23a9
GIT binary patch
literal 4096
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

literal 0
HcmV?d00001

-- 
1.8.3.1

