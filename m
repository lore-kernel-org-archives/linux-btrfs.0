Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4846C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 978A2206B6
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ivDuX3Xs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfBVRkV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:40:21 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56918 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbfBVRkU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 12:40:20 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1MHOR7S194529
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=wSqZhh939PlaoeWdVBUEAxQVq9yIXjCQck7+AR9YIa4=;
 b=ivDuX3XsMZ0tfk5vfk6WkTbd6pGFf9f0tlZviORXu6yEdbJEitqilad3pGZJ+09HPrLQ
 VpzzXNgcJiGFEA5SRM6aYjCNyqkCq9yviya3t71W8P/JXQ9igN8lVLC1aJn00vq4/50t
 edbCAK9HOc1QO9tCzbQ/ymfLRb3WyunWyyCFtSUUUXLCcOLRWmkAn+gt29bQVD23D3q3
 innn3gQcCjyeKBH94yEKdO3uac+pjVrxbvd185QCOVh65O6C/XhpLeDNrQXHTAO/ZeWY
 OqN5eZ69XJCOkqi0V3fIpG5Ct/6byFYUF6zeLMxSql8o7Ox0QF2yPvN4X8IG24F1Tl/6 HA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qp81err3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:18 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHeHAt004367
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:18 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHeHjJ023240
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:17 GMT
Received: from tpasj.localdomain (/157.45.233.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Feb 2019 09:40:17 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 10/10] btrfs: kill btrfs_setxattr
Date:   Sat, 23 Feb 2019 01:39:52 +0800
Message-Id: <1550857192-10513-11-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9175 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902220122
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now btrfs_setxattr() is a very small function with just check for
readonly FS and redirect the call to do_setxattr(). So instead
move that checks to the parent functions.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v4: born
 fs/btrfs/acl.c   |  9 ++++++++-
 fs/btrfs/props.c | 16 ++++++++++------
 fs/btrfs/xattr.c | 30 ++++++++----------------------
 fs/btrfs/xattr.h |  5 ++---
 4 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index e395615dd304..75abe7f0d05d 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -60,6 +60,7 @@ static int do_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
 	int ret, size = 0;
 	const char *name;
 	char *value = NULL;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
@@ -95,7 +96,13 @@ static int do_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
 			goto out;
 	}
 
-	ret = btrfs_setxattr(trans, inode, name, value, size, 0);
+	if (btrfs_root_readonly(root)) {
+		ret = -EROFS;
+		goto out;
+	}
+
+	ret = do_setxattr(trans, inode, name, value, size, 0);
+
 out:
 	kfree(value);
 
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index f878ba3160f0..be6d16ccc738 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -60,6 +60,7 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 			  const char *name, const char *value, size_t value_len,
 			  int flags)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	const struct prop_handler *handler;
 	int ret;
 
@@ -70,9 +71,12 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 	if (!handler)
 		return -EINVAL;
 
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
 	if (value_len == 0) {
-		ret = btrfs_setxattr(trans, inode, handler->xattr_name, NULL, 0,
-				     flags);
+		ret = do_setxattr(trans, inode, handler->xattr_name, NULL, 0,
+				  flags);
 		if (ret)
 			return ret;
 
@@ -85,14 +89,14 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 	ret = handler->validate(value, value_len);
 	if (ret)
 		return ret;
-	ret = btrfs_setxattr(trans, inode, handler->xattr_name,
-			       value, value_len, flags);
+	ret = do_setxattr(trans, inode, handler->xattr_name, value, value_len,
+			  flags);
 	if (ret)
 		return ret;
 	ret = handler->apply(inode, value, value_len);
 	if (ret) {
-		btrfs_setxattr(trans, inode, handler->xattr_name,
-				 NULL, 0, flags);
+		ret = do_setxattr(trans, inode, handler->xattr_name, NULL, 0,
+				  flags);
 		return ret;
 	}
 
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index b3281d4d95b9..4e1ccfbfa44a 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -76,9 +76,8 @@ int btrfs_getxattr(struct inode *inode, const char *name,
 	return ret;
 }
 
-static int do_setxattr(struct btrfs_trans_handle *trans,
-		       struct inode *inode, const char *name,
-		       const void *value, size_t size, int flags)
+int do_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
+		const char *name, const void *value, size_t size, int flags)
 {
 	struct btrfs_dir_item *di = NULL;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -217,22 +216,6 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-/*
- * @value: "" makes the attribute to empty, NULL removes it
- */
-int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
-		   const char *name, const void *value, size_t size, int flags)
-{
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-
-	ASSERT(!trans);
-
-	if (btrfs_root_readonly(root))
-		return -EROFS;
-
-	return do_setxattr(trans, inode, name, value, size, flags);
-}
-
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 {
 	struct btrfs_key key;
@@ -357,11 +340,14 @@ static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
 
 	name = xattr_full_name(handler, name);
 
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
 	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	ret = btrfs_setxattr(trans, inode, name, buffer, size, flags);
+	ret = do_setxattr(trans, inode, name, buffer, size, flags);
 
 	if (!ret) {
 		inode_inc_iversion(inode);
@@ -444,8 +430,8 @@ static int btrfs_initxattrs(struct inode *inode,
 		}
 		strcpy(name, XATTR_SECURITY_PREFIX);
 		strcpy(name + XATTR_SECURITY_PREFIX_LEN, xattr->name);
-		err = btrfs_setxattr(trans, inode, name, xattr->value,
-				xattr->value_len, 0);
+		err = do_setxattr(trans, inode, name, xattr->value,
+				  xattr->value_len, 0);
 		kfree(name);
 		if (err < 0)
 			break;
diff --git a/fs/btrfs/xattr.h b/fs/btrfs/xattr.h
index 471fcac6ff55..276f81a622d5 100644
--- a/fs/btrfs/xattr.h
+++ b/fs/btrfs/xattr.h
@@ -12,9 +12,8 @@
 
 int btrfs_getxattr(struct inode *inode, const char *name,
 		void *buffer, size_t size);
-int btrfs_setxattr(struct btrfs_trans_handle *trans,
-			    struct inode *inode, const char *name,
-			    const void *value, size_t size, int flags);
+int do_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
+		const char *name, const void *value, size_t size, int flags);
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
 int btrfs_xattr_security_init(struct btrfs_trans_handle *trans,
-- 
1.8.3.1

