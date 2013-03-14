Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43227 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3CNDQt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 23:16:49 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2E3Gl2Z024138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 03:16:48 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2E3Gl0j013625
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 03:16:47 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2E3Gla4007822
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 22:16:47 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: print errno string when /dev/btrfs-control open fails
Date: Thu, 14 Mar 2013 11:17:19 +0800
Message-Id: <1363231039-7580-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Of recently and intermittently I am seeing open fail
for /dev/btrfs-control (btrfs is loaded), and there are no
dmesg errors, this may not be a complete help in digging
this issue but something which is necessary.
Thanks

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index c29861b..17c6553 100644
--- a/utils.c
+++ b/utils.c
@@ -938,7 +938,8 @@ void btrfs_register_one_device(char *fname)
 	fd = open("/dev/btrfs-control", O_RDONLY);
 	if (fd < 0) {
 		fprintf(stderr, "failed to open /dev/btrfs-control "
-			"skipping device registration\n");
+			"%s, skipping device registration\n",
+			strerror(errno));
 		return;
 	}
 	strncpy(args.name, fname, BTRFS_PATH_NAME_MAX);
-- 
1.8.1.227.g44fe835

