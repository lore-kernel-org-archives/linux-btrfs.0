Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26413 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3L0Fr4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Dec 2013 00:47:56 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBR5ltdj019334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Dec 2013 05:47:56 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBR5ls45022795
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Dec 2013 05:47:55 GMT
Received: from ubhmt115.oracle.com (ubhmt115.oracle.com [156.151.24.20])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBR5lsDH022792
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Dec 2013 05:47:54 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: test_skip_this_disk() isn't needed anymore
Date: Fri, 27 Dec 2013 13:56:29 +0800
Message-Id: <1388123789-20522-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

add_seen_fsid() which was introduced lately will eliminate
the mounted disks, so we don't need test_skip_this_disk()
anymore

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/utils.c b/utils.c
index d505184..de513b6 100644
--- a/utils.c
+++ b/utils.c
@@ -1968,21 +1968,6 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 	return 0;
 }
 
-static int test_skip_this_disk(char *path)
-{
-	int fd;
-
-	/*
-	 * this will eliminate disks which are mounted (btrfs)
-	 * and non-dm disk path when dm is enabled
-	 */
-	fd = open(path, O_RDWR|O_EXCL);
-	if (fd < 0)
-		return 1;
-	close(fd);
-	return 0;
-}
-
 int btrfs_scan_lblkid(int update_kernel)
 {
 	int fd = -1;
@@ -2007,8 +1992,6 @@ int btrfs_scan_lblkid(int update_kernel)
 			continue;
 		/* if we are here its definitely a btrfs disk*/
 		strncpy(path, blkid_dev_devname(dev), PATH_MAX);
-		if (test_skip_this_disk(path))
-			continue;
 
 		fd = open(path, O_RDONLY);
 		if (fd < 0) {
-- 
1.7.1

