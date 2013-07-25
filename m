Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44393 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab3GYRaO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 13:30:14 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6PHUEwS030629
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:30:14 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6PHUDbh006830
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:30:13 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6PHUDse026875
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:30:13 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs-progs: let user know that devid can be used if path is missing
Date: Fri, 26 Jul 2013 01:35:26 +0800
Message-Id: <1374773730-29957-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1374773730-29957-1-git-send-email-anand.jain@oracle.com>
References: <1374773730-29957-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the device disappear the path goes missing,
and that will be the one of the reason that user
will replace the device.

The devid of the missing btrfs device can be
obtained using the new cli option
 btrfs fi show --kernel

And which can be used in the replace command.

---
btrfs replace start /dev/sdc /dev/sde /btrfs
Error: Unable to open device '/dev/sdc'
	Try using the devid instead of the path
---

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-replace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 6397bb5..08a369a 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -244,6 +244,7 @@ static int cmd_start_replace(int argc, char **argv)
 		if (fdsrcdev < 0) {
 			fprintf(stderr, "Error: Unable to open device '%s'\n",
 				srcdev);
+			fprintf(stderr, "\tTry using the devid instead of the path\n");
 			goto leave_with_error;
 		}
 		ret = fstat(fdsrcdev, &st);
-- 
1.7.1

