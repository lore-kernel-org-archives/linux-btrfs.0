Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C08CAC10F14
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 08:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90669205ED
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 08:03:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ifSBzTDd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfDLIDV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 04:03:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51250 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbfDLIDU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 04:03:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C7rrJh080242
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=7SZ41kzg2Cov1oF4R0dNJwKsE7IBrcNDDnFNeZiaY9s=;
 b=ifSBzTDdRyjuA8NHqeJRT2TlUZCep5wriHC1EA1PYySYSavlMcSQExSEY5qIfCzREr5T
 awPu7Rmfbe73oLmqrjBJ3Y02DxwLL0+kt5r5qt/UHNH0w2Hpaj9RHRqQC3k5SgDtxVrQ
 BoT+lK9zRM+g8MrnsRB4RWMKUqfGZclCrJVrgxz0EVP5kMjHgaQlBkqmCxiTXmfNCjZ4
 pNTckXeVYxUMEg8AeCyX2VUK1VoepgOEvlY+bip3XI1u/sfS0j4oz6v9Lw3SW4jHOTOZ
 i/WSc0a+EHrzVLNJ8pMw4xvlRGQqayct9EcrNEKR5SpmQx8cRc6pNFRxfLDJaskKAzt4 7g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2rphmew6ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C831fm054718
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2rph7u5aup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:18 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3C83HTr032109
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:17 GMT
Received: from tp.wifi.oracle.com (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Apr 2019 01:03:17 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs: cleanup btrfs_setxattr_trans drop trans arg
Date:   Fri, 12 Apr 2019 16:02:59 +0800
Message-Id: <20190412080259.5192-7-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190412080259.5192-1-anand.jain@oracle.com>
References: <20190412080259.5192-1-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904120055
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904120054
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The previous preparatory
  btrfs: split thread with trans to use btrfs_setxattr
made sure that btrfs_setxattr_trans() is called only when trans arg is
NULL.

Now this patch cleanups btrfs_setxattr_trans() and drops the trans arg.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/acl.c   |  2 +-
 fs/btrfs/props.c | 13 ++++++-------
 fs/btrfs/xattr.c |  9 +++------
 fs/btrfs/xattr.h |  5 ++---
 4 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 7fe6551bc59b..a0af1b952c4d 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -96,7 +96,7 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 	if (trans)
 		ret = btrfs_setxattr(trans, inode, name, value, size, 0);
 	else
-		ret = btrfs_setxattr_trans(NULL, inode, name, value, size, 0);
+		ret = btrfs_setxattr_trans(inode, name, value, size, 0);
 
 out:
 	kfree(value);
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index a73c1bdc7b05..44b7bf647ab3 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -74,9 +74,8 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 			ret = btrfs_setxattr(trans, inode, handler->xattr_name,
 					     NULL, 0, flags);
 		else
-			ret = btrfs_setxattr_trans(NULL, inode,
-						   handler->xattr_name, NULL, 0,
-						   flags);
+			ret = btrfs_setxattr_trans(inode, handler->xattr_name,
+						   NULL, 0, flags);
 		if (ret)
 			return ret;
 
@@ -93,8 +92,8 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 		ret = btrfs_setxattr(trans, inode, handler->xattr_name, value,
 				     value_len, flags);
 	else
-		ret = btrfs_setxattr_trans(NULL, inode, handler->xattr_name,
-					   value, value_len, flags);
+		ret = btrfs_setxattr_trans(inode, handler->xattr_name, value,
+					   value_len, flags);
 
 	if (ret)
 		return ret;
@@ -104,8 +103,8 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 			btrfs_setxattr(trans, inode, handler->xattr_name, NULL,
 				       0, flags);
 		else
-			btrfs_setxattr_trans(NULL, inode, handler->xattr_name,
-					     NULL, 0, flags);
+			btrfs_setxattr_trans(inode, handler->xattr_name, NULL,
+					     0, flags);
 		return ret;
 	}
 
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 623d508f21a6..10da873d11f5 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -221,16 +221,13 @@ int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
 /*
  * @value: "" makes the attribute to empty, NULL removes it
  */
-int btrfs_setxattr_trans(struct btrfs_trans_handle *trans,
-			 struct inode *inode, const char *name,
+int btrfs_setxattr_trans(struct inode *inode, const char *name,
 			 const void *value, size_t size, int flags)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
 	int ret;
 
-	if (trans)
-		return btrfs_setxattr(trans, inode, name, value, size, flags);
-
 	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
@@ -368,7 +365,7 @@ static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
 				   size_t size, int flags)
 {
 	name = xattr_full_name(handler, name);
-	return btrfs_setxattr_trans(NULL, inode, name, buffer, size, flags);
+	return btrfs_setxattr_trans(inode, name, buffer, size, flags);
 }
 
 static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
diff --git a/fs/btrfs/xattr.h b/fs/btrfs/xattr.h
index a95834cc3c04..1cd3fc0a8f17 100644
--- a/fs/btrfs/xattr.h
+++ b/fs/btrfs/xattr.h
@@ -14,9 +14,8 @@ int btrfs_getxattr(struct inode *inode, const char *name,
 		void *buffer, size_t size);
 int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
 		   const char *name, const void *value, size_t size, int flags);
-int btrfs_setxattr_trans(struct btrfs_trans_handle *trans,
-			    struct inode *inode, const char *name,
-			    const void *value, size_t size, int flags);
+int btrfs_setxattr_trans(struct inode *inode, const char *name,
+			 const void *value, size_t size, int flags);
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
 int btrfs_xattr_security_init(struct btrfs_trans_handle *trans,
-- 
2.17.1

