Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25824 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765525Ab3DEFxs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 01:53:48 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r355rl2Q032399
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:48 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r355rljF011927
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:47 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r355rk1t015090
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 00:53:47 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/9] btrfs-progs: no pending balance is not an error
Date: Fri,  5 Apr 2013 13:54:56 +0800
Message-Id: <1365141303-10571-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Having no balance running/ paused/completed is a normal
situation, so the current output message should be positive
with return val zero.

As of now:

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-balance.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index f5dc317..a690301 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -662,8 +662,12 @@ static int cmd_balance_status(int argc, char **argv)
 	close(fd);
 
 	if (ret < 0) {
+		if (e == ENOTCONN) {
+			printf("No balance found on '%s'\n", path);
+			return 0;
+		}
 		fprintf(stderr, "ERROR: balance status on '%s' failed - %s\n",
-			path, (e == ENOTCONN) ? "Not in progress" : strerror(e));
+			path, strerror(e));
 		return 19;
 	}
 
-- 
1.8.1.227.g44fe835

