Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36912 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbeIXQSG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 12:18:06 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/9] geneirc/077 fix min size for btrfs
Date: Mon, 24 Sep 2018 18:16:27 +0800
Message-Id: <1537784193-24431-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
References: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If btrfs need to be tested at its default blockgroup which is non-mixed,
then it needs at least ~200mb (upward round off to nearest 100'),
instead of 50mb use 200mb to test this test case.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/generic/077 | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/generic/077 b/tests/generic/077
index ef6af18c83e3..60c3493451c7 100755
--- a/tests/generic/077
+++ b/tests/generic/077
@@ -49,8 +49,7 @@ rm -f $seqres.full
 _scratch_unmount >/dev/null 2>&1
 echo "*** MKFS ***"                         >>$seqres.full
 echo ""                                     >>$seqres.full
-SIZE=`expr 50 \* 1024 \* 1024`
-_scratch_mkfs_sized $SIZE                   >>$seqres.full 2>&1 \
+_scratch_mkfs_sized $((200 * 1024 *1024))   >>$seqres.full 2>&1 \
 	|| _fail "mkfs failed"
 _scratch_mount
 mkdir $SCRATCH_MNT/subdir
-- 
1.8.3.1
