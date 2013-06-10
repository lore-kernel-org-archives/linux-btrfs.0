Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50494 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab3FJOw7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 10:52:59 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5AEqtNU028082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:56 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEqvFx016118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:57 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEqv7F016106
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:57 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/9] btrfs-progs: get_label_mounted to return label instead of print
Date: Mon, 10 Jun 2013 22:56:29 +0800
Message-Id: <1370876190-16520-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This would help to reuse the function

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/utils.c b/utils.c
index f9545b8..b205005 100644
--- a/utils.c
+++ b/utils.c
@@ -1313,7 +1313,7 @@ static int get_label_unmounted(const char *dev)
  * mounted path rather than device.  Return the corresponding error
  * the user specified the device path.
  */
-static int get_label_mounted(const char *mount_path)
+static int get_label_mounted(const char *mount_path, char *labelp)
 {
 	char label[BTRFS_LABEL_SIZE];
 	int fd;
@@ -1331,16 +1331,24 @@ static int get_label_mounted(const char *mount_path)
 		return -1;
 	}
 
-	fprintf(stdout, "%s\n", label);
+	strncpy(labelp, label, sizeof(label));
 	close(fd);
 	return 0;
 }
 
 int get_label(const char *btrfs_dev)
 {
-	return is_existing_blk_or_reg_file(btrfs_dev) ?
-		get_label_unmounted(btrfs_dev) :
-		get_label_mounted(btrfs_dev);
+	int ret;
+	char label[BTRFS_LABEL_SIZE];
+
+	if (is_existing_blk_or_reg_file(btrfs_dev))
+		ret = get_label_unmounted(btrfs_dev);
+	else {
+		ret = get_label_mounted(btrfs_dev, label);
+		if (!ret)
+			fprintf(stdout, "%s\n", label);
+	}
+	return ret;
 }
 
 int set_label(const char *btrfs_dev, const char *label)
-- 
1.8.1.227.g44fe835

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
