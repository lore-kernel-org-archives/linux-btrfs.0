Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbeIYKaM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 06:30:12 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/9] generic/083 fix btrfs fs size for default mode
Date: Tue, 25 Sep 2018 12:24:17 +0800
Message-Id: <1537849462-619-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
References: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs needs at least 256mb to create a FS with the defaults options.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/generic/083 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/083 b/tests/generic/083
index 63d96ba2ab88..eabff02a36eb 100755
--- a/tests/generic/083
+++ b/tests/generic/083
@@ -71,7 +71,7 @@ workout()
 
 echo "*** test out-of-space handling for random write operations"
 
-filesize=`expr 100 \* 1024 \* 1024`
+filesize=`expr 256 \* 1024 \* 1024`
 agcount=6
 numprocs=15
 numops=1500
-- 
1.8.3.1
