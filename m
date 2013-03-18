Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41312 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3CRH26 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 03:28:58 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2I7SuV3006301
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 07:28:57 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2I7StjU004747
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 07:28:56 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2I7St0X020459
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 02:28:55 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: defrag return zero on success
Date: Mon, 18 Mar 2013 15:29:38 +0800
Message-Id: <1363591778-6430-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 2210020..f3d3130 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -446,7 +446,7 @@ static int cmd_defrag(int argc, char **argv)
 		exit(1);
 	}
 
-	return errors + 20;
+	return errors;
 }
 
 static const char * const cmd_resize_usage[] = {
-- 
1.8.1.227.g44fe835

