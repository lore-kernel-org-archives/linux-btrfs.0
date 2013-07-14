Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41831 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3GNIlW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jul 2013 04:41:22 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6E8fKwA029274
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Jul 2013 08:41:21 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6E8fKJg002384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Jul 2013 08:41:20 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6E8fJjl010490
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Jul 2013 08:41:19 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Date: Sun, 14 Jul 2013 16:46:16 +0800
Message-Id: <1373791576-29898-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373410908-2274-1-git-send-email-wangshilong1991@gmail.com>
References: <1373410908-2274-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After calling opendir() successfully, closedir() should be
also called to free memory. Otherwise, memory leak happens.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index d3bec9b..4b3c778 100644
--- a/utils.c
+++ b/utils.c
@@ -1503,7 +1503,7 @@ int open_file_or_dir(const char *fname)
 {
 	int ret;
 	struct stat st;
-	DIR *dirstream;
+	DIR *dirstream = NULL;
 	int fd;
 
 	ret = stat(fname, &st);
@@ -1520,7 +1520,9 @@ int open_file_or_dir(const char *fname)
 		fd = open(fname, O_RDWR);
 	}
 	if (fd < 0) {
-		return -3;
+		fd = -3;
+		if (dirstream)
+			closedir(dirstream);
 	}
 	return fd;
 }
-- 
1.7.7.6

