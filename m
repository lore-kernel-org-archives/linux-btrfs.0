Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22036 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaBEMrw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Feb 2014 07:47:52 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s15Clo0c012630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Feb 2014 12:47:51 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s15Clnvo028663
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Feb 2014 12:47:50 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s15Clnpl019908
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Feb 2014 12:47:49 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fix typo in reported error
Date: Wed,  5 Feb 2014 20:57:51 +0800
Message-Id: <1391605071-15225-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index a045ffd..1e72b77 100644
--- a/utils.c
+++ b/utils.c
@@ -1340,7 +1340,7 @@ static int set_label_mounted(const char *mount_path, const char *label)
 
 	fd = open(mount_path, O_RDONLY | O_NOATIME);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: unable access to '%s'\n", mount_path);
+		fprintf(stderr, "ERROR: unable to access '%s'\n", mount_path);
 		return -1;
 	}
 
@@ -1397,7 +1397,7 @@ int get_label_mounted(const char *mount_path, char *labelp)
 
 	fd = open(mount_path, O_RDONLY | O_NOATIME);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: unable access to '%s'\n", mount_path);
+		fprintf(stderr, "ERROR: unable to access '%s'\n", mount_path);
 		return -1;
 	}
 
-- 
1.7.1

