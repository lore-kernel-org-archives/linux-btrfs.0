Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8252FC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5143220652
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:32:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="1EBPAw4q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727760AbfAQPcy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:32:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47766 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbfAQPcw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 10:32:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0HFSqKH006897
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=ug7EPWfwLR2u3TfzbzEKTrakQBbWq983uQxY+NGzVSo=;
 b=1EBPAw4qgJqKHSZJraqpg3vApz4VnZJ5tXnUZLNZ+e9i+3v+H3V8IwFKJCha2MYn9XKa
 mnZgY9DnEcecryGO9AAamWTrRdScx7SKTvot1aXWt0VMvZ2uE1g3lUfJFWkLC4IMXNpE
 ZR93Z9hmQOmGyroqIaQpf+yT1+wnWaW20rxlBrES0gFL0v1jibIWqaJ7BIcGfoaqPZj8
 Ai8CaP19eqyRk6/vlvefyKvkeZVwKB3+o1RvgeVaYOkHALGhlgB/adeM24po1oGXvsVM
 CaZtd4Js3tW3roYZpvIL3rH+YcREWp/SE1wx2Puqdm9pQoRaZ4J4zLOhA+aIJA9tKBs+ ng== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2pybjsgm7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:51 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0HFWjDr001306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:45 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0HFWjaE030845
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:45 GMT
Received: from tpasj.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Jan 2019 07:32:44 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: cleanup btrfs_find_device_by_devspec()
Date:   Thu, 17 Jan 2019 23:32:29 +0800
Message-Id: <1547739153-6916-3-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
References: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9138 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=835
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901170111
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_find_device_by_devspec() finds the device by @devid or by
@device_path. This patch makes code flow easy to read by open
coding the else part and renames devpath to device_path.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
If the else is preferred, I am ok to keep them. Nikolay?

 fs/btrfs/volumes.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e92404081e25..8b5201c734b9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2435,7 +2435,8 @@ static struct btrfs_device *btrfs_find_device_by_path(
  * Lookup a device given by device id, or the path if the id is 0.
  */
 struct btrfs_device *btrfs_find_device_by_devspec(
-		struct btrfs_fs_info *fs_info, u64 devid, const char *devpath)
+		struct btrfs_fs_info *fs_info, u64 devid,
+		const char *device_path)
 {
 	struct btrfs_device *device;
 
@@ -2443,24 +2444,23 @@ struct btrfs_device *btrfs_find_device_by_devspec(
 		device = btrfs_find_device(fs_info, devid, NULL, NULL);
 		if (!device)
 			return ERR_PTR(-ENOENT);
-	} else {
-		if (!devpath || !devpath[0])
-			return ERR_PTR(-EINVAL);
-
-		if (strcmp(devpath, "missing") == 0) {
-			list_for_each_entry(device, &fs_info->fs_devices->devices,
-					    dev_list) {
-				if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
-					     &device->dev_state) &&
-					     !device->bdev)
-					return device;
-			}
-			return ERR_PTR(-ENOENT);
-		} else {
-			device = btrfs_find_device_by_path(fs_info, devpath);
+		return device;
+	}
+
+	if (!device_path || !device_path[0])
+		return ERR_PTR(-EINVAL);
+
+	if (strcmp(device_path, "missing") == 0) {
+		list_for_each_entry(device, &fs_info->fs_devices->devices,
+				    dev_list) {
+			if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+				     &device->dev_state) && !device->bdev)
+				return device;
 		}
+		return ERR_PTR(-ENOENT);
 	}
-	return device;
+
+	return btrfs_find_device_by_path(fs_info, device_path);
 }
 
 /*
-- 
1.8.3.1

