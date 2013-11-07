Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18011 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3KGCpL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Nov 2013 21:45:11 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rA72j99C016464
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 02:45:10 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rA72j93g002749
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 02:45:09 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rA72j8Nq006264
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 02:45:09 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: use /proc/self/mounts
Date: Thu,  7 Nov 2013 10:53:43 +0800
Message-Id: <1383792823-24594-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-send.c |    2 +-
 utils.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 53e9a53..43ea06b 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -72,7 +72,7 @@ int find_mount_root(const char *path, char **mount_root)
 		return -errno;
 	close(fd);
 
-	mnttab = fopen("/proc/mounts", "r");
+	mnttab = fopen("/proc/self/mounts", "r");
 	if (!mnttab)
 		return -errno;
 
diff --git a/utils.c b/utils.c
index ebd10e5..d2138dd 100644
--- a/utils.c
+++ b/utils.c
@@ -996,7 +996,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 	}
 
 	/* iterate over the list of currently mountes filesystems */
-	if ((f = setmntent ("/proc/mounts", "r")) == NULL)
+	if ((f = setmntent ("/proc/self/mounts", "r")) == NULL)
 		return -errno;
 
 	while ((mnt = getmntent (f)) != NULL) {
-- 
1.7.1

