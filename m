Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44449 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab3GYRaU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 13:30:20 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6PHUJVr030698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:30:19 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6PHUIqf007068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:30:18 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6PHUIWO007050
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:30:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs-progs: don't have to report ENOMEDIUM error during open
Date: Fri, 26 Jul 2013 01:35:30 +0800
Message-Id: <1374773730-29957-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1374773730-29957-1-git-send-email-anand.jain@oracle.com>
References: <1374773730-29957-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when we scan /proc/partitions the cdrom is scanned
as well, and we don't have to report ENOMEDIUM errors
against it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index 4aeea9c..638cef0 100644
--- a/utils.c
+++ b/utils.c
@@ -1443,8 +1443,9 @@ scan_again:
 
 		fd = open(fullpath, O_RDONLY);
 		if (fd < 0) {
-			fprintf(stderr, "failed to open %s: %s\n",
-				fullpath, strerror(errno));
+			if (errno != ENOMEDIUM)
+				fprintf(stderr, "failed to open %s: %s\n",
+					fullpath, strerror(errno));
 			continue;
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
-- 
1.7.1

