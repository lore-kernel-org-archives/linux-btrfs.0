Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29187 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967449Ab3E3DhL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 May 2013 23:37:11 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4U3b8HM029336
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:09 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4U3b9TT006757
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:10 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4U3b9Qe008834
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:09 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6 v2] btrfs-progs: update device scan usage
Date: Thu, 30 May 2013 11:40:23 +0800
Message-Id: <1369885226-3640-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1369885226-3640-1-git-send-email-anand.jain@oracle.com>
References: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
 <1369885226-3640-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

the btrfs device scan usage does not publish --all-devices
option so add it

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-device.c b/cmds-device.c
index 41e79d3..d25159b 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -178,7 +178,7 @@ static int cmd_rm_dev(int argc, char **argv)
 }
 
 static const char * const cmd_scan_dev_usage[] = {
-	"btrfs device scan [<device>...]",
+	"btrfs device scan [<--all-devices>|<device> [<device>...]]",
 	"Scan devices for a btrfs filesystem",
 	NULL
 };
-- 
1.8.1.227.g44fe835

