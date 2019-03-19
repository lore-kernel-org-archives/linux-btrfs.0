Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C1AC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 014D520857
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:00:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V3OJ0Wxb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfCSKAQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:00:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41660 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbfCSKAP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 06:00:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2J9wxgX026904
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=4P3onIx9J6wUX1eKT/4TREnzzsbDLMk87ROF1CJOOcw=;
 b=V3OJ0WxboP5fEUXRvBhQP2PfnevrJTpKeqaYIGNFGZ7hXwxScpMIs1Sm5mZOJQbyq368
 V3qWjWwt1021IyngvBZetEOsmpK8i45u0QwlxEKwxusR3QQZFtZ+a9Gsh9GEpPiKcS5U
 KvxJ85yNKACjpk82x1oosnmZc3Y6c4tq/tPnyDTzVl2RwzJT+1jouYA90OikUnMb1KSs
 5MS54z9yonmEt36Ta7gBoT9oTOwnEgMDZTkO037adE37TL4N+ebKdbsEggFMTy5LelVK
 Vu1q58KQyzvmL3TAjUXp5wr3vmAAKIBfYcpqKfUQ05ZTCYrhP21ojGE/paoTHt6VvVPB 1g== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2r8pnektpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:13 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2JA0CEP027958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:13 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2JA0CiK000520
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:12 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Mar 2019 03:00:12 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 2/5] btrfs: add readmirror pid property
Date:   Tue, 19 Mar 2019 18:00:21 +0800
Message-Id: <1552989624-29577-3-git-send-email-anand.jain@oracle.com>
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

Function call chain  __btrfs_map_block()->find_live_mirror() uses
thread %pid to determine the %mirror_num for the read when the
mirror_num=0 in the argument.

This pid based mirror_num extrapolation has following disadvantages
 A single-process large read IO will read only from one disk.
 In a worst scenario all processes read accessing the FS could have
   either odd or even pid, the read IO gets skewed.
 There is no deterministic way of knowing/controlling which copy will
   be used for reading.
 May see performance variations for a given set of multi process
   workload ran at different times.

So we need other types of readmirror policies.

This patch introduces a framework so that we can add more policies, and
converts the existing %pid into as a configurable parameter using the
property.

 For example:
  btrfs property set /btrfs readmirror pid
  btrfs property set /btrfs readmirror ""

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c   | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c | 11 ++++++++++-
 fs/btrfs/volumes.h |  7 +++++++
 3 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 1a13f10a6ef5..776cdf099f93 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -11,6 +11,7 @@
 #include "ctree.h"
 #include "xattr.h"
 #include "compression.h"
+#include "volumes.h"
 
 #define BTRFS_PROP_HANDLERS_HT_BITS 8
 static DEFINE_HASHTABLE(prop_handlers_ht, BTRFS_PROP_HANDLERS_HT_BITS);
@@ -326,6 +327,45 @@ static const char *prop_compression_extract(struct inode *inode)
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
+	if (!strncmp("pid", value, 3))
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
+	if (!value)
+		fs_devices->readmirror_policy = BTRFS_READMIRROR_DEFAULT;
+	else if (!strncmp("pid", value, 3))
+		fs_devices->readmirror_policy = BTRFS_READMIRROR_PID;
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
@@ -334,6 +374,13 @@ static const char *prop_compression_extract(struct inode *inode)
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
index 9024eee889b9..e5072d46e181 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5562,7 +5562,16 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 	else
 		num_stripes = map->num_stripes;
 
-	preferred_mirror = first + current->pid % num_stripes;
+	switch(fs_info->fs_devices->readmirror_policy) {
+	case BTRFS_READMIRROR_PID:
+		/* fall through */
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
index 3ad9d58d1b66..27dce9242b55 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -208,6 +208,11 @@ struct btrfs_device {
 BTRFS_DEVICE_GETSET_FUNCS(disk_total_bytes);
 BTRFS_DEVICE_GETSET_FUNCS(bytes_used);
 
+enum btrfs_readmirror_policy {
+	BTRFS_READMIRROR_DEFAULT,
+	BTRFS_READMIRROR_PID,
+};
+
 struct btrfs_fs_devices {
 	u8 fsid[BTRFS_FSID_SIZE]; /* FS specific uuid */
 	u8 metadata_uuid[BTRFS_FSID_SIZE];
@@ -254,6 +259,8 @@ struct btrfs_fs_devices {
 	struct kobject fsid_kobj;
 	struct kobject *device_dir_kobj;
 	struct completion kobj_unregister;
+
+	int readmirror_policy;
 };
 
 #define BTRFS_BIO_INLINE_CSUM_SIZE	64
-- 
1.8.3.1

