Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C11CC43612
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 05:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04EFB21874
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 05:33:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VV3fkJI6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfADFcC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 00:32:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43070 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfADFcC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jan 2019 00:32:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x045U9Q8100237
        for <linux-btrfs@vger.kernel.org>; Fri, 4 Jan 2019 05:32:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=IoyuY7SuQUnMs010vIZx3+ojEQyDmUIOU25nANNXZPE=;
 b=VV3fkJI6LovLnhRxviLhgdc8f824z3tbw+PZEAJDqQ7UC6OAqfrruSFWIa5drVz6pqUi
 6XKRShuti/Ek/pKjW3A/du2CFXG31vKt8JNZ7pBwSNP4n39eNH00a62VlHtnSrKHNyZm
 KWcHUntrRj1bNs/jUIWz9HYfn9FiSuzXA+V4ACGuIm8rjdTXzuCICeUM+TxkkLplBOGu
 DNODezFlXSodlcRPQiqqs183n5PhMp96PPJDsu0y5qZmBwRgb4ysqD6CUcBIMN+WPdO2
 aYZiH7GpzxmYRzv0PUDg77EM8bmQjFp/Yn3Ngo0l/3LgpjSCq4Sv2UPgxBThKab89c48 Nw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2pp1jrac8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Jan 2019 05:32:01 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x045VxZk000660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 4 Jan 2019 05:32:00 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x045Vx4h008443
        for <linux-btrfs@vger.kernel.org>; Fri, 4 Jan 2019 05:31:59 GMT
Received: from tpasj.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Jan 2019 21:31:59 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2 v14] btrfs: refactor btrfs_free_stale_devices() to get return value
Date:   Fri,  4 Jan 2019 13:31:53 +0800
Message-Id: <1546579914-14971-3-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1546579914-14971-1-git-send-email-anand.jain@oracle.com>
References: <1546579914-14971-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9125 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901040048
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Preparatory patch to add forget cli.

Re-factors btrfs_free_stale_devices() to obtain return status. As
this function can fail if it can't find the given path (returns -ENOENT)
or trying to delete a mounted device (returns -EBUSY).

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v14: born.
 A split from the patch 2/2.
 Use -ENOENT.
 Document return value in the function btrfs_free_stale_devices() header.
 Adds a code comment.
 Ensures it still returns 0 if it was able to delete a device but followed
  by a path matched to a mounted device (a very remote corner case).
      if (path && ret != 0)
             ret = -EBUSY;

 fs/btrfs/volumes.c | 48 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2576b1a379c9..d8ac63e3666d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -734,6 +734,19 @@ static void pending_bios_fn(struct btrfs_work *work)
 	run_scheduled_bios(device);
 }
 
+static bool device_path_matched(const char *path, struct btrfs_device *device)
+{
+	int found;
+
+	rcu_read_lock();
+	found = strcmp(rcu_str_deref(device->name), path);
+	rcu_read_unlock();
+
+	if (!found)
+		return true;
+	return false;
+}
+
 /*
  *  Search and remove all stale (devices which are not mounted) devices.
  *  When both inputs are NULL, it will search and release all stale devices.
@@ -741,45 +754,52 @@ static void pending_bios_fn(struct btrfs_work *work)
  *		matching this path only.
  *  skip_dev:	Optional. Will skip this device when searching for the stale
  *		devices.
+ *  Return:	0 for success or if path is NULL.
+ * 		-EBUSY if path is a mounted device.
+ * 		-ENOENT if path does not match with any device in the list.
  */
-static void btrfs_free_stale_devices(const char *path,
+static int btrfs_free_stale_devices(const char *path,
 				     struct btrfs_device *skip_device)
 {
 	struct btrfs_fs_devices *fs_devices, *tmp_fs_devices;
 	struct btrfs_device *device, *tmp_device;
+	int ret;
+
+	if (path)
+		ret = -ENOENT;
+	else
+		ret = 0;
 
 	list_for_each_entry_safe(fs_devices, tmp_fs_devices, &fs_uuids, fs_list) {
+
 		mutex_lock(&fs_devices->device_list_mutex);
-		if (fs_devices->opened) {
-			mutex_unlock(&fs_devices->device_list_mutex);
-			continue;
-		}
 
 		list_for_each_entry_safe(device, tmp_device,
 					 &fs_devices->devices, dev_list) {
-			int not_found = 0;
 
 			if (skip_device && skip_device == device)
 				continue;
 			if (path && !device->name)
 				continue;
-
-			rcu_read_lock();
-			if (path)
-				not_found = strcmp(rcu_str_deref(device->name),
-						   path);
-			rcu_read_unlock();
-			if (not_found)
+			if (path && !device_path_matched(path, device))
 				continue;
+			if (fs_devices->opened) {
+				/* if already deleted a device return 0 */
+				if (path && ret != 0)
+					ret = -EBUSY;
+				break;
+			}
 
 			/* delete the stale device */
 			fs_devices->num_devices--;
 			list_del(&device->dev_list);
 			btrfs_free_device(device);
 
+			ret = 0;
 			if (fs_devices->num_devices == 0)
 				break;
 		}
+
 		mutex_unlock(&fs_devices->device_list_mutex);
 		if (fs_devices->num_devices == 0) {
 			btrfs_sysfs_remove_fsid(fs_devices);
@@ -787,6 +807,8 @@ static void btrfs_free_stale_devices(const char *path,
 			free_fs_devices(fs_devices);
 		}
 	}
+
+	return ret;
 }
 
 static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
-- 
1.8.3.1

