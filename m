Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61818 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760009Ab3IECki (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Sep 2013 22:40:38 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r852eZ3v014030
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Sep 2013 10:40:35 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/5] btrfs-progs:local variable memory freed
Date: Thu, 5 Sep 2013 10:38:55 +0800
Message-Id: <1378348738-14451-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1378348738-14451-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1378348738-14451-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The local probe variable in is_ssd() freed upon unsuccessful return;
The local dir_head list in make_image() freed upon unsuccessful return.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 mkfs.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index 1701783..415889e 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1024,6 +1024,8 @@ static int make_image(char *source_dir, struct btrfs_root *root, int out_fd)
 
 	struct directory_name_entry dir_head;
 
+	struct directory_name_entry *dir_entry = NULL;
+
 	ret = lstat(source_dir, &root_st);
 	if (ret) {
 		fprintf(stderr, "unable to lstat the %s\n", source_dir);
@@ -1043,6 +1045,12 @@ static int make_image(char *source_dir, struct btrfs_root *root, int out_fd)
 	printf("Making image is completed.\n");
 	return 0;
 fail:
+	while (!list_empty(&dir_head.list)) {
+		dir_entry = list_entry(dir_head.list.next,
+				       struct directory_name_entry, list);
+		list_del(&dir_entry->list);
+		free(dir_entry);
+	}
 	fprintf(stderr, "Making image is aborted.\n");
 	return -1;
 }
@@ -1161,8 +1169,10 @@ static int is_ssd(const char *file)
 
 	/* Device number of this disk (possibly a partition) */
 	devno = blkid_probe_get_devno(probe);
-	if (!devno)
+	if (!devno) {
+		blkid_free_probe(probe);
 		return 0;
+	}
 
 	/* Get whole disk name (not full path) for this devno */
 	blkid_devno_to_wholedisk(devno, wholedisk, sizeof(wholedisk), NULL);
-- 
1.8.0.1

