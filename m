Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38989 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3GOF0M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 01:26:12 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 05/11] btrfs-progs: btrfs_scan_one_dir not to skip links when /dev/mapper is provided
Date: Mon, 15 Jul 2013 13:30:51 +0800
Message-Id: <1373866257-10519-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>

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
 utils.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index 345bfdc..59010c9 100644
--- a/utils.c
+++ b/utils.c
@@ -1040,6 +1040,7 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
 	struct list_head pending_list;
 	struct btrfs_fs_devices *tmp_devices;
 	u64 num_devices;
+	int skip_link = 1;
 
 	INIT_LIST_HEAD(&pending_list);
 
@@ -1048,6 +1049,9 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
 		return -ENOMEM;
 	strcpy(pending->name, dirname);
 
+	if (!strncmp(dirname, "/dev/mapper", strlen("/dev/mapper")))
+		skip_link = 0;
+
 again:
 	dirname_len = strlen(pending->name);
 	fullpath = malloc(PATH_MAX);
@@ -1079,7 +1083,7 @@ again:
 			fprintf(stderr, "failed to stat %s\n", fullpath);
 			continue;
 		}
-		if (S_ISLNK(st.st_mode))
+		if (skip_link && S_ISLNK(st.st_mode))
 			continue;
 		if (S_ISDIR(st.st_mode)) {
 			struct pending_dir *next = malloc(sizeof(*next));
@@ -1090,7 +1094,7 @@ again:
 			strcpy(next->name, fullpath);
 			list_add_tail(&next->list, &pending_list);
 		}
-		if (!S_ISBLK(st.st_mode)) {
+		if (skip_link && !S_ISBLK(st.st_mode)) {
 			continue;
 		}
 		fd = open(fullpath, O_RDONLY);
-- 
1.7.7.6

