Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61075 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab3LLHqx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 02:46:53 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] Btrfs-progs: make sure we are opening a file or dir with open_file_or_dir()
Date: Thu, 12 Dec 2013 15:46:18 +0800
Message-Id: <1386834378-876-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously, open_file_or_dir() will open block device successfully, however,
we should enhance such checks to make sure we are really opening a file or dir.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
v1->v2:
	this is more nature to fix the problem.
---
 utils.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/utils.c b/utils.c
index f499023..bf81704 100644
--- a/utils.c
+++ b/utils.c
@@ -1568,13 +1568,20 @@ int open_file_or_dir(const char *fname, DIR **dirstream)
 	if (S_ISDIR(st.st_mode)) {
 		*dirstream = opendir(fname);
 		if (!*dirstream)
-			return -2;
+			return -1;
 		fd = dirfd(*dirstream);
-	} else {
+	} else if (S_ISREG(st.st_mode) || S_ISLNK(st.st_mode)) {
 		fd = open(fname, O_RDWR);
+	} else {
+		/*
+		 * we set this on purpose, in case the caller output
+		 * strerror(errno) as success
+		 */
+		errno = EINVAL;
+		return -1;
 	}
 	if (fd < 0) {
-		fd = -3;
+		fd = -1;
 		if (*dirstream)
 			closedir(*dirstream);
 	}
-- 
1.8.3.1

