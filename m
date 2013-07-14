Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42028 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3GNInr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jul 2013 04:43:47 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6E8hkRf030266
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Jul 2013 08:43:47 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6E8hjqc028119
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Jul 2013 08:43:46 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6E8hjKb017273
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Jul 2013 08:43:45 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs-progs: fix memory leak in open_file_or_dir()
Date: Sun, 14 Jul 2013 16:48:42 +0800
Message-Id: <1373791722-29998-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373410908-2274-1-git-send-email-wangshilong1991@gmail.com>
References: <1373410908-2274-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

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

