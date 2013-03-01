Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37104 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3CAKKA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2013 05:10:00 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r21A9xCL026949
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2013 10:10:00 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r21A9wuw005192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2013 10:09:59 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r21A9wrn021471
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2013 04:09:58 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: usage should match what is coded
Date: Fri,  1 Mar 2013 18:10:02 +0800
Message-Id: <1362132602-29501-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1362132602-29501-1-git-send-email-anand.jain@oracle.com>
References: <1362132602-29501-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-restore.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 9385042..4a14f93 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -763,10 +763,6 @@ const char * const cmd_restore_usage[] = {
 	"-f <offset>     filesystem location",
 	"-u <block>      super mirror",
 	"-d              find dir",
-	"-r <num>        root objectid",
-	"-c              ignore case in regular expression",
-	"-m <regexp>     regular expression to match",
-	"-l              list roots",
 	NULL
 };
 
-- 
1.8.1.227.g44fe835

