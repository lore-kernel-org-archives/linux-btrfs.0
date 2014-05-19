Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31275 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbaESRBm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 13:01:42 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s4JH1f2X019734
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 17:01:42 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4JH1eMZ009084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 17:01:40 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s4JH1cjV015348
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 17:01:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: label should not contain return char
Date: Tue, 20 May 2014 01:04:30 +0800
Message-Id: <1400519071-5580-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

generally if you use
  echo "test" > /sys/fs/btrfs/<fsid>/label
it would introduce return char at the end and it can not
be part of the label. The correct command is
  echo -n "test" > /sys/fs/btrfs/<fsid>/label

This patch will check for this user error

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 fs/btrfs/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index c5eb214..63c2907 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -374,7 +374,7 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	struct btrfs_root *root = fs_info->fs_root;
 	int ret;
 
-	if (len >= BTRFS_LABEL_SIZE) {
+	if (len >= BTRFS_LABEL_SIZE || strchr(buf, '\n')) {
 		pr_err("BTRFS: unable to set label with more than %d bytes\n",
 		       BTRFS_LABEL_SIZE - 1);
 		return -EINVAL;
-- 
1.8.5.3

