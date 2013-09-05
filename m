Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62090 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757203Ab3IECkj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Sep 2013 22:40:39 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r852eZQ5014035
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Sep 2013 10:40:36 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 4/5] btrfs-progs:free the local list pending_list in btrfs_scan_one_dir
Date: Thu, 5 Sep 2013 10:38:57 +0800
Message-Id: <1378348738-14451-5-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1378348738-14451-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1378348738-14451-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally the local pending_list is not guaranteed to be freed upon fails, it should be emptyed and the elements should be freed.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 utils.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index d022d58..134bf80 100644
--- a/utils.c
+++ b/utils.c
@@ -1066,8 +1066,8 @@ again:
 	dirp = opendir(dirname);
 	if (!dirp) {
 		fprintf(stderr, "Unable to open %s for scanning\n", dirname);
-		free(fullpath);
-		return -ENOENT;
+		ret = -ENOENT;
+		goto fail;
 	}
 	while(1) {
 		dirent = readdir(dirp);
@@ -1133,6 +1133,12 @@ again:
 fail:
 	free(pending);
 	free(fullpath);
+	while (!list_empty(&pending_list)) {
+		pending = list_entry(pending_list.next, struct pending_dir,
+				     list);
+		list_del(&pending->list);
+		free(pending);
+	}
 	if (dirp)
 		closedir(dirp);
 	return ret;
-- 
1.8.0.1

