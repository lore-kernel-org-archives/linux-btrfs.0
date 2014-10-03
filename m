Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13088 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752541AbaJCO7k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Oct 2014 10:59:40 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s93ExBCq010429
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Oct 2014 07:59:39 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1psverg8wt-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Oct 2014 07:59:39 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: skip extent rebuild test if no testdev
Date: Fri, 3 Oct 2014 10:59:36 -0400
Message-ID: <1412348376-6771-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is highly obnoxious to have to go put in a testdev when all you really want
is to run the quick image tests.  Make this part optional so if we don't have a
testdev specified we just don't run that particular test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 tests/fsck-tests.sh | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
index b783b78..867366b 100644
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -24,10 +24,6 @@ run_check()
 
 rm -f $RESULT
 
-if [ -z $TEST_DEV ] || [ -z $TEST_MNT ];then
-	_fail "please set TEST_DEV and TEST_MNT"
-fi
-
 # test rely on corrupting blocks tool
 run_check make btrfs-corrupt-block
 
@@ -45,6 +41,11 @@ do
 	run_check $here/btrfsck test.img
 done
 
+if [ -z $TEST_DEV ] || [ -z $TEST_MNT ];then
+	echo "     [NOTRUN] extent tree rebuild"
+	exit 0
+fi
+
 # test whether fsck can rebuild a corrupted extent tree
 test_extent_tree_rebuild()
 {
-- 
1.8.3.1

