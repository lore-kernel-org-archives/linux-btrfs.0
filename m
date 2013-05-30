Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28598 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967382Ab3E3DhO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 May 2013 23:37:14 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4U3bCdi002449
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:13 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4U3bC1w008894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:12 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4U3bCfY008891
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:12 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6 v2] btrfs-progs: btrfs_scan_one_dir not to skip links when /dev/mapper is provided
Date: Thu, 30 May 2013 11:40:25 +0800
Message-Id: <1369885226-3640-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1369885226-3640-1-git-send-email-anand.jain@oracle.com>
References: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
 <1369885226-3640-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

we would need btrfs_scan_one_dir to san devs under /dev/mapper,
but /dev/mapper has links to the actual devs and current implementation
of btrfs_scan_one_dir skips links so it does not pick any
links under /dev/mapper. skipping links is fine when scanning whole of
/dev. But when we just want to scan /dev/mapper we want to avoid skipping
links otherwise we would be left with nothing.

This patch just adds the check if we are scanning devs
ONLY under /dev/mapper if when so it will not skip links

Thanks

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index f15136b..6ac7c73 100644
--- a/utils.c
+++ b/utils.c
@@ -1018,6 +1018,7 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
 	struct list_head pending_list;
 	struct btrfs_fs_devices *tmp_devices;
 	u64 num_devices;
+	int skip_link = 1;
 
 	INIT_LIST_HEAD(&pending_list);
 
@@ -1026,6 +1027,9 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
 		return -ENOMEM;
 	strcpy(pending->name, dirname);
 
+	if (!strncmp(dirname, "/dev/mapper", strlen("/dev/mapper")))
+		skip_link = 0;
+
 again:
 	dirname_len = strlen(pending->name);
 	fullpath = malloc(PATH_MAX);
@@ -1057,7 +1061,7 @@ again:
 			fprintf(stderr, "failed to stat %s\n", fullpath);
 			continue;
 		}
-		if (S_ISLNK(st.st_mode))
+		if (skip_link && S_ISLNK(st.st_mode))
 			continue;
 		if (S_ISDIR(st.st_mode)) {
 			struct pending_dir *next = malloc(sizeof(*next));
@@ -1068,7 +1072,7 @@ again:
 			strcpy(next->name, fullpath);
 			list_add_tail(&next->list, &pending_list);
 		}
-		if (!S_ISBLK(st.st_mode)) {
+		if (skip_link && !S_ISBLK(st.st_mode)) {
 			continue;
 		}
 		fd = open(fullpath, O_RDONLY);
-- 
1.8.1.227.g44fe835

