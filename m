Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF3AC10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 12:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6C382084B
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 12:00:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O2nImnT8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfDYMAA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 08:00:00 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58772 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfDYL77 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 07:59:59 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3PBxOc8071777
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=QuTpJ3r71WxM/+eGbeBDh4MrxuuyokvaPZMMNyZIi0c=;
 b=O2nImnT8pEG/z4JH29vmR0eghagE5rb2ykRICKgcno1kpgJjsuJW/4vY6q1GjL7AhLUV
 m5YqWMVMSQx0kKYzEbbsbvNbMW8jgELx3Zxxh0R7xBJ0RkX70UJ+igvVERZlAr3mb++Q
 x+q7m4EE3e8QnIeTm6zD6QxB3sKi3mZlbs05Gc62BiJoN7nlHmA1KtvZdEN85Kxoxalu
 DVRwn3rZ8D34N+VwJAsVGBJJ9wsarAXxkkySn3ap25Lqsn5chMJ7t7diNdy5uHDXSwJB
 tw5KGG3PQCRgs4ceb4pMucmA95HsCxMmFasyhf6f1Qmru6Pbz/fgyKSQP4CwEbBPmZD/ rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2ryrxd8308-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3PBwtFX022680
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2s0fv43a14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:57 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3PBxuDe007168
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:57 GMT
Received: from localhost.localdomain (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Apr 2019 04:59:56 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: add readmirror devid property
Date:   Thu, 25 Apr 2019 19:59:46 +0800
Message-Id: <20190425115946.2550-4-anand.jain@oracle.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190425115946.2550-1-anand.jain@oracle.com>
References: <20190425115946.2550-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9237 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904250077
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9237 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904250077
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Introduces devid readmirror property, to direct read IO to the specified
device(s).

The readmirror property is stored as extended attribute on the root
inode. The readmirror input format is devid1,2,3.. etc. And for the
each devid provided, a new flag BTRFS_DEV_STATE_READ_OPTIMISED is set.

As of now readmirror by devid supports only raid1s. Raid10 support has
to leverage device grouping feature, which is yet to be implemented.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c   | 69 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c | 16 +++++++++++
 fs/btrfs/volumes.h |  2 ++
 3 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 1d44fbdd5891..c5d17e29ab4e 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -320,7 +320,10 @@ static const char *prop_compression_extract(struct inode *inode)
 static int prop_readmirror_validate(struct inode *inode, const char *value,
 				    size_t len)
 {
+	char *value_dup;
+	char *devid_str;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 
 	if (root->root_key.objectid != BTRFS_FS_TREE_OBJECTID)
 		return -EINVAL;
@@ -328,16 +331,80 @@ static int prop_readmirror_validate(struct inode *inode, const char *value,
 	if (!len)
 		return 0;
 
-	return -EINVAL;
+	if (len <= 5 || strncmp("devid", value, 5))
+		return -EINVAL;
+
+	value_dup = kstrndup(value + 5, len - 5, GFP_KERNEL);
+	if (!value_dup)
+		return -ENOMEM;
+
+	while ((devid_str = strsep(&value_dup, ",")) != NULL) {
+		u64 devid;
+		struct btrfs_device *device;
+
+		if (kstrtoull(devid_str, 10, &devid)) {
+			kfree(value_dup);
+			return -EINVAL;
+		}
+
+		device = btrfs_find_device(fs_devices, devid, NULL, NULL, false);
+		if (!device) {
+			kfree(value_dup);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
 }
 
 static int prop_readmirror_apply(struct inode *inode, const char *value,
 				 size_t len)
 {
+	char *value_dup;
+	char *devid_str;
+	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices = btrfs_sb(inode->i_sb)->fs_devices;
 
+	if (value) {
+		value_dup = kstrndup(value + 5, len - 5, GFP_KERNEL);
+		if (!value_dup)
+			return -ENOMEM;
+	}
+
+	/* Both set and reset has to clear the exisiting values */
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		if (test_bit(BTRFS_DEV_STATE_READ_OPTIMISED,
+			     &device->dev_state)) {
+			clear_bit(BTRFS_DEV_STATE_READ_OPTIMISED,
+				  &device->dev_state);
+		}
+	}
 	fs_devices->readmirror_policy = BTRFS_READMIRROR_DEFAULT;
 
+	/* Its only reset so just return */
+	if (!value)
+		return 0;
+
+	while ((devid_str = strsep(&value_dup, ",")) != NULL) {
+		u64 devid;
+
+		/* Has been verified in validate() this will not fail */
+		if (kstrtoull(devid_str, 10, &devid)) {
+			kfree(value_dup);
+			return -EINVAL;
+		}
+
+		device = btrfs_find_device(fs_devices, devid, NULL, NULL, false);
+		if (!device) {
+			kfree(value_dup);
+			return -EINVAL;
+		}
+
+		set_bit(BTRFS_DEV_STATE_READ_OPTIMISED, &device->dev_state);
+		fs_devices->readmirror_policy = BTRFS_READMIRROR_DEVID;
+	}
+
+	kfree(value_dup);
 	return 0;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 64c3a2d8b264..90cbc03a20f6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5495,6 +5495,7 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 	int preferred_mirror;
 	int tolerance;
 	struct btrfs_device *srcdev;
+	bool found = false;
 
 	ASSERT((map->type &
 		 (BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10)));
@@ -5505,6 +5506,21 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 		num_stripes = map->num_stripes;
 
 	switch(fs_info->fs_devices->readmirror_policy) {
+	case BTRFS_READMIRROR_DEVID:
+		/* skip raid10 for now */
+		if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
+			for (i = first; i < first + num_stripes; i++) {
+				if (test_bit(BTRFS_DEV_STATE_READ_OPTIMISED,
+					     &map->stripes[i].dev->dev_state)) {
+					preferred_mirror = i;
+					found = true;
+					break;
+				}
+			}
+			if (found)
+				break;
+		}
+		/* fall through */
 	case BTRFS_READMIRROR_DEFAULT:
 		/* fall through */
 	default:
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 5dffaa6f9d18..6c223790dc4c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -41,6 +41,7 @@ struct btrfs_pending_bios {
 #define BTRFS_DEV_STATE_MISSING		(2)
 #define BTRFS_DEV_STATE_REPLACE_TGT	(3)
 #define BTRFS_DEV_STATE_FLUSH_SENT	(4)
+#define BTRFS_DEV_STATE_READ_OPTIMISED	(5)
 
 struct btrfs_device {
 	struct list_head dev_list;
@@ -206,6 +207,7 @@ BTRFS_DEVICE_GETSET_FUNCS(bytes_used);
 
 enum btrfs_readmirror_policy {
 	BTRFS_READMIRROR_DEFAULT,
+	BTRFS_READMIRROR_DEVID,
 };
 
 struct btrfs_fs_devices {
-- 
2.20.1 (Apple Git-117)

