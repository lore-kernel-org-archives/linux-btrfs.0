Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36358 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728549AbeIXQSH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 12:18:07 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/9] generic/083 create at least 200mb fs
Date: Mon, 24 Sep 2018 18:16:28 +0800
Message-Id: <1537784193-24431-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
References: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs needs at least ~200mb to create a FS with the defaults options,
so instead of 100mb create 200mb sized fs.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/generic/083 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/083 b/tests/generic/083
index 63d96ba2ab88..e5f0a88ef221 100755
--- a/tests/generic/083
+++ b/tests/generic/083
@@ -71,7 +71,7 @@ workout()
 
 echo "*** test out-of-space handling for random write operations"
 
-filesize=`expr 100 \* 1024 \* 1024`
+filesize=`expr 200 \* 1024 \* 1024`
 agcount=6
 numprocs=15
 numops=1500
-- 
1.8.3.1
