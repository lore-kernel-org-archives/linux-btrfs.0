Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4A5C282E1
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 12:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63C192084B
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 12:00:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PAKvA1VE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfDYL77 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:59:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52784 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfDYL76 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 07:59:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3PBxGsl062823
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=c87tFbIYphrskFwViywAYFUo91vohFohWmpuvfruh+E=;
 b=PAKvA1VE0FRI5JupeLh1HkSFfO4oDsv8xMaRcvpnLsPvGbvEc8MZteJ3hW0KVjoHCGnq
 4I0qLxMK6BLDomAeH09LeJetG6lqJxSd8RUeAjR28icEPNVeijEE87Kav28yx4hq0EOt
 jWnnMx1udgxKBOC6TbwT8zfixWQDi7UlF8Vgs42FpqOMWSZ6tK1+yqPwz1a+6BZOOPLQ
 DXTeV9e0yP5m4FGu3Xqb+IR4QS2ol42S35wqhBrFh8ehEc8HASPGSg8qqv0mbFoUzM+1
 eGs1fJH9yVNU+T0Q1OwgNDZStx+Rb4+BnyHqeJD2aTPnrDuIop2DFnoWEMhJVtxRTl62 gQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2rytut7v55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3PBwhiS022454
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2s0fv43a10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:55 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3PBxtO0018145
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:55 GMT
Received: from localhost.localdomain (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Apr 2019 04:59:54 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: add readmirror property framework
Date:   Thu, 25 Apr 2019 19:59:45 +0800
Message-Id: <20190425115946.2550-3-anand.jain@oracle.com>
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

Function call chain  __btrfs_map_block()->find_live_mirror() uses
thread %pid to determine the %mirror_num for the read when mirror_num=0
in the argument.

This patch introduces a framework so that readmirror is a configurable
parameter, with default set to pid.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c   | 41 +++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c |  9 ++++++++-
 fs/btrfs/volumes.h |  6 ++++++
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 5c1fccc32b43..1d44fbdd5891 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -10,6 +10,7 @@
 #include "ctree.h"
 #include "xattr.h"
 #include "compression.h"
+#include "volumes.h"
 
 #define BTRFS_PROP_HANDLERS_HT_BITS 8
 static DEFINE_HASHTABLE(prop_handlers_ht, BTRFS_PROP_HANDLERS_HT_BITS);
@@ -316,6 +317,39 @@ static const char *prop_compression_extract(struct inode *inode)
 	return NULL;
 }
 
+static int prop_readmirror_validate(struct inode *inode, const char *value,
+				    size_t len)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
+	if (root->root_key.objectid != BTRFS_FS_TREE_OBJECTID)
+		return -EINVAL;
+
+	if (!len)
+		return 0;
+
+	return -EINVAL;
+}
+
+static int prop_readmirror_apply(struct inode *inode, const char *value,
+				 size_t len)
+{
+	struct btrfs_fs_devices *fs_devices = btrfs_sb(inode->i_sb)->fs_devices;
+
+	fs_devices->readmirror_policy = BTRFS_READMIRROR_DEFAULT;
+
+	return 0;
+}
+
+static const char *prop_readmirror_extract(struct inode *inode)
+{
+	/*
+	 * readmirror policy is applied for the whole FS, inheritance is not
+	 * applicable.
+	 */
+	return NULL;
+}
+
 static struct prop_handler prop_handlers[] = {
 	{
 		.xattr_name = XATTR_BTRFS_PREFIX "compression",
@@ -324,6 +358,13 @@ static struct prop_handler prop_handlers[] = {
 		.extract = prop_compression_extract,
 		.inheritable = 1
 	},
+	{
+		.xattr_name = XATTR_BTRFS_PREFIX "readmirror",
+		.validate = prop_readmirror_validate,
+		.apply = prop_readmirror_apply,
+		.extract = prop_readmirror_extract,
+		.inheritable = 0
+	},
 };
 
 static int inherit_props(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 78bab7803bda..64c3a2d8b264 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5504,7 +5504,14 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 	else
 		num_stripes = map->num_stripes;
 
-	preferred_mirror = first + current->pid % num_stripes;
+	switch(fs_info->fs_devices->readmirror_policy) {
+	case BTRFS_READMIRROR_DEFAULT:
+		/* fall through */
+	default:
+		/* readmirror as per thread pid */
+		preferred_mirror = first + current->pid % num_stripes;
+		break;
+	}
 
 	if (dev_replace_is_ongoing &&
 	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index b3a89d767512..5dffaa6f9d18 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -204,6 +204,10 @@ BTRFS_DEVICE_GETSET_FUNCS(total_bytes);
 BTRFS_DEVICE_GETSET_FUNCS(disk_total_bytes);
 BTRFS_DEVICE_GETSET_FUNCS(bytes_used);
 
+enum btrfs_readmirror_policy {
+	BTRFS_READMIRROR_DEFAULT,
+};
+
 struct btrfs_fs_devices {
 	u8 fsid[BTRFS_FSID_SIZE]; /* FS specific uuid */
 	u8 metadata_uuid[BTRFS_FSID_SIZE];
@@ -249,6 +253,8 @@ struct btrfs_fs_devices {
 	struct kobject fsid_kobj;
 	struct kobject *device_dir_kobj;
 	struct completion kobj_unregister;
+
+	int readmirror_policy;
 };
 
 #define BTRFS_BIO_INLINE_CSUM_SIZE	64
-- 
2.20.1 (Apple Git-117)

