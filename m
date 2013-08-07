Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23711 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681Ab3HGMFk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 08:05:40 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r77C5dYo000789
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Aug 2013 12:05:40 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r77C5cmv014756
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Aug 2013 12:05:39 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r77C5cpe022760
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Aug 2013 12:05:38 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: let user know that devid can be used if path is missing
Date: Wed,  7 Aug 2013 20:11:23 +0800
Message-Id: <1375877485-12105-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1375877485-12105-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1375877485-12105-1-git-send-email-anand.jain@oracle.com>

When the device disappear the path goes missing,
and that will be the one of the reason that user
will replace the device.

The devid of the missing btrfs device can be
obtained using the new cli option
 btrfs fi show --kernel (coming soon)

And which can be used in the replace command.
---
 cmds-replace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index e409e11..25e8c7f 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -245,6 +245,7 @@ static int cmd_start_replace(int argc, char **argv)
 		if (fdsrcdev < 0) {
 			fprintf(stderr, "Error: Unable to open device '%s'\n",
 				srcdev);
+			fprintf(stderr, "\tTry using the devid instead of the path\n");
 			goto leave_with_error;
 		}
 		ret = fstat(fdsrcdev, &st);
-- 
1.7.1

