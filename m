Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.clear-code.com ([219.94.234.64]:45974 "EHLO
	mail.clear-code.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992568Ab2KOE6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 23:58:17 -0500
From: Kenji Okimoto <okimoto@clear-code.com>
To: linux-btrfs@vger.kernel.org
Cc: Kenji Okimoto <okimoto@clear-code.com>
Subject: [PATCH 3/3] btrfs-progs: plug memory leaks in btrfs_scan_one_dir() reported by cppcheck.
Date: Thu, 15 Nov 2012 13:47:52 +0900
Message-Id: <1352954872-13770-4-git-send-email-okimoto@clear-code.com>
In-Reply-To: <1352954872-13770-1-git-send-email-okimoto@clear-code.com>
References: <1352954872-13770-1-git-send-email-okimoto@clear-code.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[utils.c:983]: (error) Memory leak: fullpath

Signed-off-by: Kenji Okimoto <okimoto@clear-code.com>
---
 utils.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/utils.c b/utils.c
index 205e667..3efb3af 100644
--- a/utils.c
+++ b/utils.c
@@ -980,6 +980,7 @@ again:
 	dirp = opendir(dirname);
 	if (!dirp) {
 		fprintf(stderr, "Unable to open %s for scanning\n", dirname);
+		free(fullpath);
 		return -ENOENT;
 	}
 	while(1) {
@@ -1030,6 +1031,7 @@ again:
 		free(pending);
 		pending = list_entry(pending_list.next, struct pending_dir,
 				     list);
+		free(fullpath);
 		list_del(&pending->list);
 		closedir(dirp);
 		dirp = NULL;
@@ -1038,6 +1040,7 @@ again:
 	ret = 0;
 fail:
 	free(pending);
+	free(fullpath);
 	if (dirp)
 		closedir(dirp);
 	return ret;
-- 
1.7.10.4

