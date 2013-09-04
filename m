Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47886 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab3IDLpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 07:45:39 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r84BjSQi023869
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Sep 2013 19:45:28 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix compile warning in is_ssd()
Date: Wed, 4 Sep 2013 19:43:20 +0800
Message-Id: <1378295000-19509-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mkfs.c: In function ‘is_ssd’:
mkfs.c:1168:26: warning: ignoring return value of ‘blkid_devno_to_wholedisk’,
declared with attribute warn_unused_result [-Wunused-result]
  blkid_devno_to_wholedisk(devno, wholedisk, sizeof(wholedisk), NULL);

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 mkfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index 6d340cb..bcaca43 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1209,6 +1209,7 @@ static int is_ssd(const char *file)
 	dev_t devno;
 	int fd;
 	char rotational;
+	int ret;
 
 	probe = blkid_new_probe_from_filename(file);
 	if (!probe)
@@ -1220,7 +1221,12 @@ static int is_ssd(const char *file)
 		return 0;
 
 	/* Get whole disk name (not full path) for this devno */
-	blkid_devno_to_wholedisk(devno, wholedisk, sizeof(wholedisk), NULL);
+	ret = blkid_devno_to_wholedisk(devno,
+			wholedisk, sizeof(wholedisk), NULL);
+	if (ret) {
+		blkid_free_probe(probe);
+		return 0;
+	}
 
 	snprintf(sysfs_path, PATH_MAX, "/sys/block/%s/queue/rotational",
 		 wholedisk);
-- 
1.8.3.1

