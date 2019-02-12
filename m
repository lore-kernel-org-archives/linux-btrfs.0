Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF09DC169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 02:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B528C21B18
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 02:19:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WfAx8gsu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbfBLCTM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 21:19:12 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45900 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbfBLCTM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 21:19:12 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1C2J14h034782
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=xlGpTZOI2b19ONlQT6KZqHxF5UoWt3vSSSaakUZoYNg=;
 b=WfAx8gsu3Dd804oGR3Th1Fg/SOQADUXqk7pMPp+D6/fA1XVbquYHzxapMcmENrVKfAa5
 +cX17IWA0AnsA9vnzTyGau0YQNXvyc/iyWVvWhfDz/9bIONjFGpa5rIG2webj/4Fa+5J
 7QwPQOdlH5gcs+HJE6mdBcOi0SWtrWtGYOWXJyd92MqDURLSnMW6eZxYhcAIPgoyup6I
 Q4IzyVamSX7rLopSWO2PwZB8UljpIp5g6rTW0Bz6NlrqbGeWSWqj9mi4WZc+YMxRBrWm
 BrO2e5QpBoT83lVvhSuCG0SpNkQpnG3AiPyWy3EAiORcKTtGJ89anM+c0XYuVHAqgmCb FQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qhre598x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:10 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1C2J44k006018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:04 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1C2J464022651
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:04 GMT
Received: from tpasj.localdomain (/183.90.37.91)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Feb 2019 18:19:04 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/3] btrfs: drop redundant forward declaration in props.c
Date:   Tue, 12 Feb 2019 10:18:50 +0800
Message-Id: <1549937931-15339-3-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1549937931-15339-1-git-send-email-anand.jain@oracle.com>
References: <1549937931-15339-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902120015
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Drop forward declaration of the functions,
prop_compression_validate(), prop_compression_apply() and
prop_compression_extract(). By moving prop_handlers[], btrfs_props_init()
prop_compression_validate(), prop_compression_apply() and
prop_compression_extract() appropriately within the file. No functional
changes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
v3: merge with 2/5 and 3/5 as in v1
v2: none
 fs/btrfs/props.c | 163 +++++++++++++++++++++++++++----------------------------
 1 file changed, 79 insertions(+), 84 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 4525a2a4d1cd..77a03076b18e 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -23,36 +23,6 @@ struct prop_handler {
 	int inheritable;
 };
 
-static int prop_compression_validate(const char *value, size_t len);
-static int prop_compression_apply(struct inode *inode,
-				  const char *value,
-				  size_t len);
-static const char *prop_compression_extract(struct inode *inode);
-
-static struct prop_handler prop_handlers[] = {
-	{
-		.xattr_name = XATTR_BTRFS_PREFIX "compression",
-		.validate = prop_compression_validate,
-		.apply = prop_compression_apply,
-		.extract = prop_compression_extract,
-		.inheritable = 1
-	},
-};
-
-void __init btrfs_props_init(void)
-{
-	int i;
-
-	hash_init(prop_handlers_ht);
-
-	for (i = 0; i < ARRAY_SIZE(prop_handlers); i++) {
-		struct prop_handler *p = &prop_handlers[i];
-		u64 h = btrfs_name_hash(p->xattr_name, strlen(p->xattr_name));
-
-		hash_add(prop_handlers_ht, &p->node, h);
-	}
-}
-
 static const struct hlist_head *find_prop_handlers_by_hash(const u64 hash)
 {
 	struct hlist_head *h;
@@ -271,6 +241,78 @@ int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path)
 	return ret;
 }
 
+static int prop_compression_validate(const char *value, size_t len)
+{
+	if (!value)
+		return 0;
+
+	if (!strncmp("lzo", value, len))
+		return 0;
+	else if (!strncmp("zlib", value, len))
+		return 0;
+	else if (!strncmp("zstd", value, len))
+		return 0;
+
+	return -EINVAL;
+}
+
+static int prop_compression_apply(struct inode *inode, const char *value,
+				  size_t len)
+{
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	int type;
+
+	if (len == 0) {
+		BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_COMPRESS;
+		BTRFS_I(inode)->prop_compress = BTRFS_COMPRESS_NONE;
+
+		return 0;
+	}
+
+	if (!strncmp("lzo", value, 3)) {
+		type = BTRFS_COMPRESS_LZO;
+		btrfs_set_fs_incompat(fs_info, COMPRESS_LZO);
+	} else if (!strncmp("zlib", value, 4)) {
+		type = BTRFS_COMPRESS_ZLIB;
+	} else if (!strncmp("zstd", value, len)) {
+		type = BTRFS_COMPRESS_ZSTD;
+		btrfs_set_fs_incompat(fs_info, COMPRESS_ZSTD);
+	} else {
+		return -EINVAL;
+	}
+
+	BTRFS_I(inode)->flags &= ~BTRFS_INODE_NOCOMPRESS;
+	BTRFS_I(inode)->flags |= BTRFS_INODE_COMPRESS;
+	BTRFS_I(inode)->prop_compress = type;
+
+	return 0;
+}
+
+static const char *prop_compression_extract(struct inode *inode)
+{
+	switch (BTRFS_I(inode)->prop_compress) {
+	case BTRFS_COMPRESS_ZLIB:
+	case BTRFS_COMPRESS_LZO:
+	case BTRFS_COMPRESS_ZSTD:
+		return btrfs_compress_type2str(BTRFS_I(inode)->prop_compress);
+	default:
+		break;
+	}
+
+	return NULL;
+}
+
+static struct prop_handler prop_handlers[] = {
+	{
+		.xattr_name = XATTR_BTRFS_PREFIX "compression",
+		.validate = prop_compression_validate,
+		.apply = prop_compression_apply,
+		.extract = prop_compression_extract,
+		.inheritable = 1
+	},
+};
+
 static int inherit_props(struct btrfs_trans_handle *trans,
 			 struct inode *inode,
 			 struct inode *parent)
@@ -352,64 +394,17 @@ int btrfs_subvol_inherit_props(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int prop_compression_validate(const char *value, size_t len)
-{
-	if (!strncmp("lzo", value, len))
-		return 0;
-	else if (!strncmp("zlib", value, len))
-		return 0;
-	else if (!strncmp("zstd", value, len))
-		return 0;
-
-	return -EINVAL;
-}
-
-static int prop_compression_apply(struct inode *inode,
-				  const char *value,
-				  size_t len)
+void __init btrfs_props_init(void)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	int type;
-
-	if (len == 0) {
-		BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
-		BTRFS_I(inode)->flags &= ~BTRFS_INODE_COMPRESS;
-		BTRFS_I(inode)->prop_compress = BTRFS_COMPRESS_NONE;
-
-		return 0;
-	}
-
-	if (!strncmp("lzo", value, 3)) {
-		type = BTRFS_COMPRESS_LZO;
-		btrfs_set_fs_incompat(fs_info, COMPRESS_LZO);
-	} else if (!strncmp("zlib", value, 4)) {
-		type = BTRFS_COMPRESS_ZLIB;
-	} else if (!strncmp("zstd", value, len)) {
-		type = BTRFS_COMPRESS_ZSTD;
-		btrfs_set_fs_incompat(fs_info, COMPRESS_ZSTD);
-	} else {
-		return -EINVAL;
-	}
+	int i;
 
-	BTRFS_I(inode)->flags &= ~BTRFS_INODE_NOCOMPRESS;
-	BTRFS_I(inode)->flags |= BTRFS_INODE_COMPRESS;
-	BTRFS_I(inode)->prop_compress = type;
+	hash_init(prop_handlers_ht);
 
-	return 0;
-}
+	for (i = 0; i < ARRAY_SIZE(prop_handlers); i++) {
+		struct prop_handler *p = &prop_handlers[i];
+		u64 h = btrfs_name_hash(p->xattr_name, strlen(p->xattr_name));
 
-static const char *prop_compression_extract(struct inode *inode)
-{
-	switch (BTRFS_I(inode)->prop_compress) {
-	case BTRFS_COMPRESS_ZLIB:
-	case BTRFS_COMPRESS_LZO:
-	case BTRFS_COMPRESS_ZSTD:
-		return btrfs_compress_type2str(BTRFS_I(inode)->prop_compress);
-	default:
-		break;
+		hash_add(prop_handlers_ht, &p->node, h);
 	}
-
-	return NULL;
 }
 
-
-- 
1.8.3.1

