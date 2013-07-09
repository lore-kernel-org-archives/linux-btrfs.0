Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45504 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3GIXBz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jul 2013 19:01:55 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj3so6096529pad.28
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jul 2013 16:01:54 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([223.65.188.212])
        by mx.google.com with ESMTPSA id te9sm16309985pab.6.2013.07.09.16.01.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Tue, 09 Jul 2013 16:01:53 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix memory leak in open_file_or_dir()
Date: Wed, 10 Jul 2013 07:01:48 +0800
Message-Id: <1373410908-2274-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

After calling opendir() successfully, closedir() should be
also called to free memory. Otherwise, memory leak happens.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 utils.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/utils.c b/utils.c
index 7b4cd74..0afff55 100644
--- a/utils.c
+++ b/utils.c
@@ -1480,7 +1480,7 @@ int open_file_or_dir(const char *fname)
 {
 	int ret;
 	struct stat st;
-	DIR *dirstream;
+	DIR *dirstream = NULL;
 	int fd;
 
 	ret = stat(fname, &st);
@@ -1496,9 +1496,10 @@ int open_file_or_dir(const char *fname)
 	} else {
 		fd = open(fname, O_RDWR);
 	}
-	if (fd < 0) {
-		return -3;
-	}
+	if (fd < 0)
+		fd = -3;
+	if (dirstream)
+		closedir(dirstream);
 	return fd;
 }
 
-- 
1.7.11.7

