Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34417 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3BVG7i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 01:59:38 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r1M6xbea001501
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 06:59:37 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r1M6xa0v010243
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 06:59:36 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r1M6xaeA008012
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 00:59:36 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: add correct indentation
Date: Fri, 22 Feb 2013 14:59:24 +0800
Message-Id: <1361516364-25810-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A trivial fix, corrects the indentation.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/utils.c b/utils.c
index d660507..9c2e510 100644
--- a/utils.c
+++ b/utils.c
@@ -1192,12 +1192,13 @@ scan_again:
 		return -ENOENT;
 	}
 	/* skip the header */
-	for(i=0; i < 2 ; i++)
-		if(!fgets(buf, 1023, proc_partitions)){
-		fprintf(stderr, "Unable to read '/proc/partitions' for scanning\n");
-		fclose(proc_partitions);
-		return -ENOENT;
-	}
+	for (i=0; i < 2 ; i++)
+		if (!fgets(buf, 1023, proc_partitions)) {
+			fprintf(stderr,
+				"Unable to read '/proc/partitions' for scanning\n");
+			fclose(proc_partitions);
+			return -ENOENT;
+		}
 
 	strcpy(fullpath,"/dev/");
 	while(fgets(buf, 1023, proc_partitions)) {
-- 
1.8.1.227.g44fe835

