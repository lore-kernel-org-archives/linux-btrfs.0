Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8730BC10F03
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56F2520857
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:00:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rSX2WrVm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfCSKAQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:00:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58010 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfCSKAQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 06:00:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2J9wwgl186161
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=G31YDQJr6bDjTxaGgQLxg6ph+qVLEg0OJNBHWWy0kww=;
 b=rSX2WrVm6uhUea9m+DRi+0u+7Vj9nYycLQA7G5sZ5h1TdPBixd1KO6/aKjKcpT2qKLgU
 sZaKeBuRfRHdLSrl98WRdXVrDqRnGuYxhK8Zvr8IkYIu3jRL2rDQiMUdLlxMI28yB8BB
 8AydtDiYXq9+KMX3YAI8iusSVC4RtSomrnAwyuTKjDDoduWlZvZF0rk0GDVnsXkNypiC
 X7LtBAHO/Zwp2pO7DX1Wd7R/KJ8A6g2A+/zzHijmHRsm56bGmyOSWnoreaMigLMs18tz
 EJR8PqXB7mKCZrU1LouzvMFnNArIJoh0b8tlw4ep5knb3E+GvQt03ClN1aOc4JtI2NVP Jg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2r8rjukms0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:14 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2JA0EZw005045
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:14 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2JA0Ep7002912
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:14 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Mar 2019 03:00:13 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 3/5] btrfs: add readmirror devid property
Date:   Tue, 19 Mar 2019 18:00:22 +0800
Message-Id: <1552989624-29577-4-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
References: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9199 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903190076
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Introduces devid readmirror property, which directs all read IO to a
device.

For example:
  btrfs property set <mnt> readmirror devid<n>

As of now readmirror by devid supports only raid1s. Raid10 support has
to leverage device grouping feature to facilitate the setting of
readmirror by device set.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c   | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.c | 16 ++++++++++++++++
 fs/btrfs/volumes.h |  3 +++
 3 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 776cdf099f93..a17c5a69bcb3 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -338,8 +338,28 @@ static int prop_readmirror_validate(struct inode *inode, const char *value,
 	if (!len)
 		return 0;
 
-	if (!strncmp("pid", value, 3))
+	if (!strncmp("pid", value, 3)) {
 		return 0;
+	} else if (!strncmp("devid", value, 5)) {
+		u64 devid;
+		char *value_dup;
+
+		if (len <= 5)
+			return -EINVAL;
+
+		value_dup = kstrndup(value, len, GFP_KERNEL);
+		if (!value_dup)
+			return -ENOMEM;
+		if (kstrtoull(value_dup + 5, 10, &devid)) {
+			kfree(value_dup);
+			return -EINVAL;
+		}
+		kfree(value_dup);
+
+		if (btrfs_find_device(root->fs_info->fs_devices, devid,
+				      NULL, NULL, false))
+			return 0;
+	}
 
 	return -EINVAL;
 }
@@ -349,10 +369,33 @@ static int prop_readmirror_apply(struct inode *inode, const char *value,
 {
 	struct btrfs_fs_devices *fs_devices = btrfs_sb(inode->i_sb)->fs_devices;
 
-	if (!value)
+	if (!value) {
 		fs_devices->readmirror_policy = BTRFS_READMIRROR_DEFAULT;
-	else if (!strncmp("pid", value, 3))
+	} else if (!strncmp("pid", value, 3)) {
 		fs_devices->readmirror_policy = BTRFS_READMIRROR_PID;
+	} else if (!strncmp("devid", value, 5)) {
+		u64 devid;
+		char *value_dup;
+		struct btrfs_device *device;
+		struct btrfs_root *root = BTRFS_I(inode)->root;
+
+		value_dup = kstrndup(value, len, GFP_KERNEL);
+		if (!value_dup)
+			return -ENOMEM;
+		if (kstrtoull(value_dup + 5, 10, &devid)) {
+			kfree(value_dup);
+			return -EINVAL;
+		}
+		kfree(value_dup);
+
+		fs_devices->readmirror_policy = BTRFS_READMIRROR_DEVID;
+		device = btrfs_find_device(root->fs_info->fs_devices, devid,
+					   NULL, NULL, false);
+		if (!device)
+			return -ENODEV;
+
+		device->type = BTRFS_DEVICE_TYPE_READ_OPTIMIZED;
+	}
 
 	return 0;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e5072d46e181..d3b7427d6d96 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5553,6 +5553,7 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 	int preferred_mirror;
 	int tolerance;
 	struct btrfs_device *srcdev;
+	bool found = false;
 
 	ASSERT((map->type &
 		 (BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10)));
@@ -5563,6 +5564,21 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 		num_stripes = map->num_stripes;
 
 	switch(fs_info->fs_devices->readmirror_policy) {
+	case BTRFS_READMIRROR_DEVID:
+		/* skip raid10 for now */
+		if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
+			for (i = first; i < first + num_stripes; i++) {
+				if (map->stripes[i].dev->type ==
+				    BTRFS_DEVICE_TYPE_READ_OPTIMIZED) {
+					preferred_mirror = i;
+					found = true;
+					break;
+				}
+			}
+			if (found)
+				break;
+		}
+		/* fall through */
 	case BTRFS_READMIRROR_PID:
 		/* fall through */
 	case BTRFS_READMIRROR_DEFAULT:
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 27dce9242b55..9c2e64548a11 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -208,9 +208,12 @@ struct btrfs_device {
 BTRFS_DEVICE_GETSET_FUNCS(disk_total_bytes);
 BTRFS_DEVICE_GETSET_FUNCS(bytes_used);
 
+#define BTRFS_DEVICE_TYPE_READ_OPTIMIZED  1ULL
+
 enum btrfs_readmirror_policy {
 	BTRFS_READMIRROR_DEFAULT,
 	BTRFS_READMIRROR_PID,
+	BTRFS_READMIRROR_DEVID,
 };
 
 struct btrfs_fs_devices {
-- 
1.8.3.1

