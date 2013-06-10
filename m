Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50419 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3FJOww (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 10:52:52 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5AEqnak027952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:50 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEqod4007150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:51 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEqo4e015797
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:50 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/9 v2] btrfs-progs: update device scan usage
Date: Mon, 10 Jun 2013 22:56:24 +0800
Message-Id: <1370876190-16520-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
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

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
