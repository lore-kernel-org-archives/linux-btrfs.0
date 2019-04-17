Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB50FC282DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 15:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98B7220674
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 15:37:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d+Kz/to9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732697AbfDQPhW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 11:37:22 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58060 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732689AbfDQPhW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 11:37:22 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HFJ4ba174395;
        Wed, 17 Apr 2019 15:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=7Aj+pjzOaO20yDNNAFzsIh3kgQDImmpCLwkYW+JNLyw=;
 b=d+Kz/to9oQSrRAfaJjXm3RHegRfgec96xsFRpJ9GFtYP6Jbis2wo3AsfepysEI7j/ERZ
 +e21xsHNl/u9s8M8bqzE3u/BtEvTwjNFQIREzH24ypOFRHKJQ6gnIfbVcsX59GkppsXK
 koT/M4OntfRF+/5EKGrcmM7aHkO43QOTYUC8CmCMRLE9rqoyWYxk7c92cUIufojy2c8M
 XrwkGE+RkqxoaUpYDp3iXX/sodZUekQPjpHuldZ19wereucaW3LDfuq09lt3623HR6Ih
 MgFFySzv5ztOOHCy87E1/aUvqBekEoLZdnByljAHTAjQu3vzyeNU83TpDIydroPqog06 8g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2ru59dbt0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 15:37:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HFaBwe038842;
        Wed, 17 Apr 2019 15:37:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2rv2tvenyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 15:37:17 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3HFbGjP012863;
        Wed, 17 Apr 2019 15:37:16 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Apr 2019 08:37:16 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz
Subject: [PATCH 1/2 RFC] btrfs: refactor btrfs_set_props to validate externally
Date:   Wed, 17 Apr 2019 23:37:05 +0800
Message-Id: <20190417153706.29942-2-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190417153706.29942-1-anand.jain@oracle.com>
References: <20190417153706.29942-1-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904170104
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904170104
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In preparation to merge multiple transactions when setting the
inode attribute flags, move btrfs_set_props()'s validation part
to outside.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c |  3 +++
 fs/btrfs/props.c | 23 +++++++++++++++++------
 fs/btrfs/props.h |  1 +
 fs/btrfs/xattr.c |  5 +++++
 4 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8c9a908d3acc..63e6e2f5b659 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -284,6 +284,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		binode->flags &= ~BTRFS_INODE_COMPRESS;
 		binode->flags |= BTRFS_INODE_NOCOMPRESS;
 
+		/* set no-compression no need to validate prop here */
 		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
 					   0, 0);
 		if (ret && ret != -ENODATA)
@@ -299,6 +300,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		binode->flags |= BTRFS_INODE_COMPRESS;
 		binode->flags &= ~BTRFS_INODE_NOCOMPRESS;
 
+		/* compress_type is already validated during mount options */
 		comp = btrfs_compress_type2str(fs_info->compress_type);
 		if (!comp || comp[0] == 0)
 			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
@@ -309,6 +311,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 			goto out_drop;
 
 	} else {
+		/* reset prop, no need of validate prop here */
 		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
 					   0, 0);
 		if (ret && ret != -ENODATA)
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 44b7bf647ab3..e356dd2a0f73 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -55,6 +55,23 @@ find_prop_handler(const char *name,
 	return NULL;
 }
 
+int btrfs_validate_prop(const char *name, const char *value, size_t value_len)
+{
+	const struct prop_handler *handler;
+
+	if (strlen(name) <= XATTR_BTRFS_PREFIX_LEN)
+		return -EINVAL;
+
+	handler = find_prop_handler(name, NULL);
+	if (!handler)
+		return -EINVAL;
+
+	if (value_len == 0)
+		return 0;
+
+	return handler->validate(value, value_len);
+}
+
 static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 			  const char *name, const char *value, size_t value_len,
 			  int flags)
@@ -62,9 +79,6 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 	const struct prop_handler *handler;
 	int ret;
 
-	if (strlen(name) <= XATTR_BTRFS_PREFIX_LEN)
-		return -EINVAL;
-
 	handler = find_prop_handler(name, NULL);
 	if (!handler)
 		return -EINVAL;
@@ -85,9 +99,6 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 		return ret;
 	}
 
-	ret = handler->validate(value, value_len);
-	if (ret)
-		return ret;
 	if (trans)
 		ret = btrfs_setxattr(trans, inode, handler->xattr_name, value,
 				     value_len, flags);
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index b1a6b233b774..01d2c1899bc7 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -12,6 +12,7 @@ void __init btrfs_props_init(void);
 
 int btrfs_set_prop_trans(struct inode *inode, const char *name,
 			 const char *value, size_t value_len, int flags);
+int btrfs_validate_prop(const char *name, const char *value, size_t value_len);
 
 int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path);
 
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 10da873d11f5..807cc24dc885 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -373,7 +373,12 @@ static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
 					const char *name, const void *value,
 					size_t size, int flags)
 {
+	int ret;
+
 	name = xattr_full_name(handler, name);
+	ret = btrfs_validate_prop(name, value, size);
+	if (ret)
+		return ret;
 	return btrfs_set_prop_trans(inode, name, value, size, flags);
 }
 
-- 
2.17.1

