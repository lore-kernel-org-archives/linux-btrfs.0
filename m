Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50453 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3FJOwz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 10:52:55 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5AEqq3R028015
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:52 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEqrjY007288
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:54 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEqrIb007273
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:53 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/9 v2] btrfs-progs: btrfs_scan_one_dir not to skip links when /dev/mapper is provided
Date: Mon, 10 Jun 2013 22:56:26 +0800
Message-Id: <1370876190-16520-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
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
index 6b2344d..a329b7a 100644
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

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
