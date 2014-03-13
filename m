Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3901 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaCMFJb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 01:09:31 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2D56Gxs003962
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Mar 2014 13:09:27 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: skip erroneous free before initialization
Date: Thu, 13 Mar 2014 13:01:31 +0800
Message-Id: <1394686891-23271-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1394686891-23271-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1394686891-23271-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the list is not initialized, don't try to free it.
Otherwise it will cause segmentfault.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 mkfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index d7049c9..df22c3a 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -965,7 +965,7 @@ static int make_image(char *source_dir, struct btrfs_root *root, int out_fd)
 	ret = lstat(source_dir, &root_st);
 	if (ret) {
 		fprintf(stderr, "unable to lstat the %s\n", source_dir);
-		goto fail;
+		goto out;
 	}
 
 	INIT_LIST_HEAD(&dir_head.list);
@@ -987,6 +987,7 @@ fail:
 		list_del(&dir_entry->list);
 		free(dir_entry);
 	}
+out:
 	fprintf(stderr, "Making image is aborted.\n");
 	return -1;
 }
-- 
1.8.1.4

