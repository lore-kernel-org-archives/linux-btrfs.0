Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36962 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728549AbeIXQSK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 12:18:10 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/9] generic/204 open code SIZE for _scratch_mkfs_sized()
Date: Mon, 24 Sep 2018 18:16:30 +0800
Message-Id: <1537784193-24431-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
References: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By open code we could grep to find out FS size being use by this test
case.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/generic/204 | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/generic/204 b/tests/generic/204
index 349f5eff351f..576c4eabd359 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -42,8 +42,7 @@ _scratch_mkfs 2> /dev/null | _filter_mkfs 2> $tmp.mkfs > /dev/null
 # time solves this problem.
 [ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=16m -i maxpct=50"
 
-SIZE=`expr 115 \* 1024 \* 1024`
-_scratch_mkfs_sized $SIZE $dbsize 2> /dev/null > $tmp.mkfs.raw
+_scratch_mkfs_sized $((115 * 1024 * 1024)) $dbsize 2> /dev/null > $tmp.mkfs.raw
 cat $tmp.mkfs.raw | _filter_mkfs 2> $tmp.mkfs > /dev/null
 _scratch_mount
 
-- 
1.8.3.1
