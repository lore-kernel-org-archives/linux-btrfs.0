Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21039 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab3DPIkd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 04:40:33 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3G8eVTf015886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 08:40:32 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3G8eVq0008343
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 08:40:31 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3G8eVSK019629
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 08:40:31 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: record errno for ioctl DEFRAG_RANGE
Date: Tue, 16 Apr 2013 16:40:52 +0800
Message-Id: <1366101652-26571-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In order to sparse exact error message, we need to record errno here.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 cmds-filesystem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 2210020..3f386e2 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -431,6 +431,7 @@ static int cmd_defrag(int argc, char **argv)
 				close(fd);
 				break;
 			}
+			e = errno;
 		}
 		if (ret) {
 			fprintf(stderr, "ERROR: defrag failed on %s - %s\n",
-- 
1.7.7

