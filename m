Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB47FC282DC
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFA6921919
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:02:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TDnVrN8E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfBHHCx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:02:53 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54342 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfBHHCx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2019 02:02:53 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x186x4Hj163398
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=Q4R7ARNDsY4GvQRxP4VdACcKcTHUhMGmOdNisFi9ue0=;
 b=TDnVrN8EQ0w2DEy/gMLvEw83BWUYhdZbIHsfflSzGjhMY71pjMXKSJfSEJmCqzVPCbJ1
 8YFUeSammmjlTCNo0ZO06VU4OAyK8Cc0UhwHdi8fiL7VLnPNxQjyBmqcgEqqRa6LQn1o
 kvXlSBXctHUfcg2bktHYyGF5HdykAlei/Z57SYW+uenx49s4hlPiyDbxfdF4gPwrk78j
 2MvevDH/dizSSbVsNe1sLerjBtrJ0Epow6W1yspIK7PYBFTm3ughGKugW/hwiihPHE4U
 LrBvo3U4y43AGH5Ra59JMqHXWLqwJbAE7VWj+sQMCZl2W5xhf+NQ+7/SKaQ6hAXjeUdL eA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2qd98njy4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2019 07:02:51 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1872oqc029351
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:50 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1872oAu021509
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:50 GMT
Received: from tpasj.sg.oracle.com (/10.186.49.135)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Feb 2019 23:02:50 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] btrfs: reorg functions to drop forward declaration
Date:   Fri,  8 Feb 2019 15:02:33 +0800
Message-Id: <1549609355-11053-4-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1549609355-11053-1-git-send-email-anand.jain@oracle.com>
References: <1549609355-11053-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9160 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902080051
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In preparation to drop forward declaration of the functions,
prop_compression_validate(), prop_compression_apply() and
prop_compression_extract(). Move prop_handlers[], btrfs_props_init()
prop_compression_validate(), prop_compression_apply() and
prop_compression_extract() appropriately with in the file. No functional
changes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c | 157 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 79 insertions(+), 78 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 4525a2a4d1cd..6f52e3d21012 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -29,30 +29,6 @@ static int prop_compression_apply(struct inode *inode,
 				  size_t len);
 static const char *prop_compression_extract(struct inode *inode);
 
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
@@ -271,6 +247,78 @@ int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path)
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
@@ -352,64 +400,17 @@ int btrfs_subvol_inherit_props(struct btrfs_trans_handle *trans,
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

