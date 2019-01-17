Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DED5C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DEC720652
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:32:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TFHCPF9l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbfAQPcv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:32:51 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47720 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfAQPcu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 10:32:50 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0HFSq1U006918
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=E3+IYU+gzByyN2qJUANqCsiMnU+zhIyfrz0Id1P7KYc=;
 b=TFHCPF9lIVGU9u72LNiP6VIutJw6QyEu8IvAj9J2i3vgtz/2tZmsM2niClNI0RrZB6qg
 NEl3YvJBqQeJ7eTto2wsTCwDacF3UVVuhQUT3OgdVMudL3FtUMldJ7U/QituxU4rtObY
 O6zdZNOBFR3CcXDy6/Io+BMDH4l5C/FdanVwYrOnhS4tX3HfYj/0u4MtiJbNYatOc2dL
 bDa8bCv+otgr2QJO+C50P3JWKedBM/bEOeGpy6p/Fh3DAuaIu+LoTR0oiGUyzosDzmro
 XDm7WdxdRtjEu3iAjSfw4bGqg8X0/J8S6UjI0AtWLP6eBMjMR9tuc6gU0BsPu59RMWm+ cQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2pybjsgm7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:49 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0HFWhDH005250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:44 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0HFWhFM015005
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:43 GMT
Received: from tpasj.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Jan 2019 07:32:43 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs: merge btrfs_find_device_missing_or_by_path() into parent
Date:   Thu, 17 Jan 2019 23:32:28 +0800
Message-Id: <1547739153-6916-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
References: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9138 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=709
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901170111
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_find_device_missing_or_by_path() is relatively small function, and
its only parent btrfs_find_device_by_devspec() is small as well. Besides
there are a number of find_device functions. Merge
btrfs_find_device_missing_or_by_path() into its parent.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 24ce4ef41139..e92404081e25 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2431,32 +2431,6 @@ static struct btrfs_device *btrfs_find_device_by_path(
 	return device;
 }
 
-static struct btrfs_device *btrfs_find_device_missing_or_by_path(
-		struct btrfs_fs_info *fs_info, const char *device_path)
-{
-	struct btrfs_device *device = NULL;
-	if (strcmp(device_path, "missing") == 0) {
-		struct list_head *devices;
-		struct btrfs_device *tmp;
-
-		devices = &fs_info->fs_devices->devices;
-		list_for_each_entry(tmp, devices, dev_list) {
-			if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
-					&tmp->dev_state) && !tmp->bdev) {
-				device = tmp;
-				break;
-			}
-		}
-
-		if (!device)
-			return ERR_PTR(-ENOENT);
-	} else {
-		device = btrfs_find_device_by_path(fs_info, device_path);
-	}
-
-	return device;
-}
-
 /*
  * Lookup a device given by device id, or the path if the id is 0.
  */
@@ -2472,7 +2446,19 @@ struct btrfs_device *btrfs_find_device_by_devspec(
 	} else {
 		if (!devpath || !devpath[0])
 			return ERR_PTR(-EINVAL);
-		device = btrfs_find_device_missing_or_by_path(fs_info, devpath);
+
+		if (strcmp(devpath, "missing") == 0) {
+			list_for_each_entry(device, &fs_info->fs_devices->devices,
+					    dev_list) {
+				if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+					     &device->dev_state) &&
+					     !device->bdev)
+					return device;
+			}
+			return ERR_PTR(-ENOENT);
+		} else {
+			device = btrfs_find_device_by_path(fs_info, devpath);
+		}
 	}
 	return device;
 }
-- 
1.8.3.1

