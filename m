Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:39979 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966060AbdIYUSd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 16:18:33 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/2] get_partition_size() doens't require root privileges
Date: Mon, 25 Sep 2017 22:18:14 +0200
Message-Id: <20170925201815.10161-2-kreijack@libero.it>
In-Reply-To: <20170925201815.10161-1-kreijack@libero.it>
References: <20170925201815.10161-1-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Allow the get_partition_size() to be called without
root privileges.

Signed-off-by: Goffredo baroncelli <kreijack@inwind.it>
---
 utils.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/utils.c b/utils.c
index 7a2710fe..ee3ed544 100644
--- a/utils.c
+++ b/utils.c
@@ -2080,18 +2080,29 @@ u64 disk_size(const char *path)
 
 u64 get_partition_size(const char *dev)
 {
-	u64 result;
-	int fd = open(dev, O_RDONLY);
+	struct stat statbuf;
+	int r;
+	int fd;
+	char buf[100];
 
-	if (fd < 0)
-		return 0;
-	if (ioctl(fd, BLKGETSIZE64, &result) < 0) {
-		close(fd);
+	r = stat(dev, &statbuf);
+	if (r != 0)
 		return 0;
-	}
+
+	snprintf(buf, sizeof(buf),
+		"/sys/dev/block/%d:%d/size", major(statbuf.st_rdev),
+		 minor(statbuf.st_rdev));
+
+	fd = open(buf, O_RDONLY);
+	BUG_ON(fd < 0);
+
+	r = read(fd, buf, sizeof(buf)-1);
 	close(fd);
 
-	return result;
+	BUG_ON(r < 0);
+	buf[r] = 0;
+
+	return atoll(buf) * 512;
 }
 
 /*
-- 
2.14.1

