Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2668 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755031AbbB0I0n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 03:26:43 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1R8Ponw019926
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 16:25:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/7] btrfs-progs: Allow parse_qgroupid() to resolve subvolume path into qgroupid.
Date: Fri, 27 Feb 2015 16:26:36 +0800
Message-ID: <1425025599-30048-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now parse_qgroupid() can resolve subvolume path into qgroupid.
This is quite handy for handling level 0 qgroupid, and user don't need
to resolve rootid by hand now.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 46 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/utils.c b/utils.c
index fc2791b..509c5ec 100644
--- a/utils.c
+++ b/utils.c
@@ -1708,6 +1708,25 @@ scan_again:
 }
 
 /*
+ * Unsafe subvolume check.
+ *
+ * This only checks ino == BTRFS_FIRST_FREE_OBJECTID, even it is not in a
+ * btrfs mount point.
+ * Must use together with other reliable method like btrfs ioctl.
+ */
+static int __is_subvol(char *path)
+{
+	struct stat st;
+	int ret;
+
+	ret = lstat(path, &st);
+	if (ret < 0)
+		return ret;
+
+	return st.st_ino == BTRFS_FIRST_FREE_OBJECTID;
+}
+
+/*
  * A not-so-good version fls64. No fascinating optimization since
  * no one except parse_size use it
  */
@@ -1802,24 +1821,43 @@ u64 parse_qgroupid(char *p)
 	char *ptr_parse_end = NULL;
 	u64 level;
 	u64 id;
+	int fd;
+	int ret = 0;
 
+	if (p[0] == '/')
+		goto path;
+
+	/* Numeric format like '0/257' is the primary case */
 	if (!s) {
 		id = strtoull(p, &ptr_parse_end, 10);
 		if (ptr_parse_end != ptr_src_end)
-			goto err;
+			goto path;
 		return id;
 	}
 	level = strtoull(p, &ptr_parse_end, 10);
 	if (ptr_parse_end != s)
-		goto err;
+		goto path;
 
 	id = strtoull(s+1, &ptr_parse_end, 10);
 	if (ptr_parse_end != ptr_src_end)
-		goto  err;
+		goto path;
 
 	return (level << BTRFS_QGROUP_LEVEL_SHIFT) | id;
+path:
+	/* Path format like subv at 'my_subvol' is the fallback case */
+	ret = __is_subvol(p);
+	if (ret < 0 || !ret)
+		goto err;
+	fd = open(p, O_RDONLY);
+	if (fd < 0)
+		goto err;
+	ret = lookup_ino_rootid(fd, &id);
+	close(fd);
+	if (ret < 0)
+		goto err;
+	return id;
 err:
-	fprintf(stderr, "ERROR:invalid qgroupid\n");
+	fprintf(stderr, "ERROR:invalid qgroupid or subvolume path\n");
 	exit(-1);
 }
 
-- 
2.3.0

