Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26832 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933852Ab3HHIDk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 04:03:40 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7883dtm006475
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:03:40 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7883chh015860
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:03:39 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7883cUX015854
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:03:38 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: btrfs_scan_one_dir not to skip links when /dev/mapper is provided
Date: Thu,  8 Aug 2013 16:09:27 +0800
Message-Id: <1375949368-23798-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1375949368-23798-1-git-send-email-anand.jain@oracle.com>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
 <1375949368-23798-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is preparatory work to introduce /dev/mapper path usage

we need btrfs_scan_one_dir to san devs under /dev/mapper,
but /dev/mapper has links to the actual devs and current implementation
of btrfs_scan_one_dir skips links so it does not pick any
dev under /dev/mapper. skip the links are fine when scanning whole of
/dev But not when we just want to scan /dev/mapper

This patch just adds to check if we are scanning devs or
/dev/mapper only, if when latter it will not skip links

Thanks

v2: changes as per David review

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/utils.c b/utils.c
index 8a57967..038e599 100644
--- a/utils.c
+++ b/utils.c
@@ -1039,13 +1039,26 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
 	struct list_head pending_list;
 	struct btrfs_fs_devices *tmp_devices;
 	u64 num_devices;
+	int skip_link = 1;
+	char rdir[PATH_MAX];
+	char rdirp = NULL;
 
 	INIT_LIST_HEAD(&pending_list);
 
 	pending = malloc(sizeof(*pending));
 	if (!pending)
 		return -ENOMEM;
-	strcpy(pending->name, dirname);
+
+	rdirp = realpath(dirname, rdir);
+	if (!rdirp) {
+		free(pending);
+		return -errno;
+	}
+
+	strcpy(pending->name, rdir);
+
+	if (!strcmp(rdir, "/dev/mapper"))
+		skip_link = 0;
 
 again:
 	dirname_len = strlen(pending->name);
@@ -1078,7 +1091,7 @@ again:
 			fprintf(stderr, "failed to stat %s\n", fullpath);
 			continue;
 		}
-		if (S_ISLNK(st.st_mode))
+		if (skip_link && S_ISLNK(st.st_mode))
 			continue;
 		if (S_ISDIR(st.st_mode)) {
 			struct pending_dir *next = malloc(sizeof(*next));
@@ -1089,7 +1102,7 @@ again:
 			strcpy(next->name, fullpath);
 			list_add_tail(&next->list, &pending_list);
 		}
-		if (!S_ISBLK(st.st_mode)) {
+		if (skip_link && !S_ISBLK(st.st_mode)) {
 			continue;
 		}
 		fd = open(fullpath, O_RDONLY);
-- 
1.8.1.191.g414c78c

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
