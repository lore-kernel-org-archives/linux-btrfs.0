Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37090 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3CAKJ7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2013 05:09:59 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r21A9wPT026926
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2013 10:09:59 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r21A9vR8018968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2013 10:09:58 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r21A9v4h005571
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2013 04:09:57 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: from troubleshooting point of view messages must be unique
Date: Fri,  1 Mar 2013 18:10:01 +0800
Message-Id: <1362132602-29501-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From the below, we won't readily know from where the error is generated
-----
cmds-device.c:                  fprintf(stderr, "ERROR: unable to scan the device '%s' - %s\n",
utils.c:                fprintf(stderr, "ERROR: unable to scan the device '%s' - %s\n",
-----

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 1813dda..71da787 100644
--- a/utils.c
+++ b/utils.c
@@ -945,7 +945,7 @@ void btrfs_register_one_device(char *fname)
 	ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
 	e = errno;
 	if(ret<0){
-		fprintf(stderr, "ERROR: unable to scan the device '%s' - %s\n",
+		fprintf(stderr, "ERROR: device scan failed '%s' - %s\n",
 			fname, strerror(e));
 	}
 	close(fd);
-- 
1.8.1.227.g44fe835

