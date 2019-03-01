Return-Path: <SRS0=p7dB=RE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DDBC10F03
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1DBF20851
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="1qNkpMAL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbfCAEfR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 23:35:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45296 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbfCAEfO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 23:35:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x214Y0YA006516
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=if8SJPt4cxiaJaF8F/tH319ES5eo8t+tpyB7CLFhaLk=;
 b=1qNkpMALx0gdBD8adcioCdoRy+MPErmGMfFvaKBu7Zq7HQsv8vbrFySC0f2j53bemXE3
 4DOyUl/+UMfarn3BXFQrkALnGLuWDtzTR3Z857fWo9R9bTGH5516nfLFXASDzjg66ufr
 HFfdjVbYctoxbhO7xnC3fUZv7YiO4J7t39yOlCfXmVoPrJKR6Kik137M0p0/L7b1PRGa
 /8MGcxE31g3ZFcXQ4/kmb0fGo7Sd3u/X1Dq0YLw3gfz2dO0da7fq/vz2bQiFooRQOx3Z
 AI1nEB0w6mK62yIjvN1FucqxQwRnefU2LJN1F360ZtHqqyULDcCV1HPGXJ/OVjAeUQhR Hg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2qtxts53q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2019 04:35:12 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x214ZCrT005794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:12 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x214ZC35021540
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:12 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Feb 2019 20:35:11 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5 9/9] btrfs: kill btrfs_setxattr
Date:   Fri,  1 Mar 2019 12:34:55 +0800
Message-Id: <1551414895-22925-10-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
References: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9181 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903010029
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now btrfs_setxattr() is a very small function with just check for
readonly FS and redirect the call to do_setxattr(). So instead
move that checks to the parent functions and call do_setxattr()
directly.  Delete original btrfs_setxattr(), and rename do_setxattr()
to btrfs_setxattr(). Also add few c-style. Kindly note the arguments
of original do_setxattr() and original btrfs_setxattr() are same, so the
diff obliterates the changes as described above.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v5: rename do_setxattr() to btrfs_setxattr(). change log update. fix c-style. 
v4: born
 fs/btrfs/acl.c   |  7 +++++++
 fs/btrfs/props.c | 16 ++++++++++------
 fs/btrfs/xattr.c | 29 +++++++++--------------------
 fs/btrfs/xattr.h |  5 ++---
 4 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2b9c3394fc34..a8a1060c8cbe 100644
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
 
+	if (btrfs_root_readonly(root)) {
+		ret = -EROFS;
+		goto out;
+	}
+
 	ret = btrfs_setxattr(trans, inode, name, value, size, 0);
+
 out:
 	kfree(value);
 
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 75a68d7d39a2..fa85a97fa13e 100644
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
-		ret = btrfs_setxattr(trans, inode, handler->xattr_name,
-				       NULL, 0, flags);
+		ret = btrfs_setxattr(trans, inode, handler->xattr_name, NULL, 0,
+				     flags);
 		if (ret)
 			return ret;
 
@@ -85,14 +89,14 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 	ret = handler->validate(value, value_len);
 	if (ret)
 		return ret;
-	ret = btrfs_setxattr(trans, inode, handler->xattr_name,
-			       value, value_len, flags);
+	ret = btrfs_setxattr(trans, inode, handler->xattr_name, value,
+			     value_len, flags);
 	if (ret)
 		return ret;
 	ret = handler->apply(inode, value, value_len);
 	if (ret) {
-		btrfs_setxattr(trans, inode, handler->xattr_name,
-				 NULL, 0, flags);
+		ret = btrfs_setxattr(trans, inode, handler->xattr_name, NULL, 0,
+				     flags);
 		return ret;
 	}
 
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 2cbde7cac14b..358e6aed01ca 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -76,9 +76,11 @@ int btrfs_getxattr(struct inode *inode, const char *name,
 	return ret;
 }
 
-static int do_setxattr(struct btrfs_trans_handle *trans,
-		       struct inode *inode, const char *name,
-		       const void *value, size_t size, int flags)
+/*
+ * @value: "" makes the attribute to empty, NULL removes it
+ */
+int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
+		   const char *name, const void *value, size_t size, int flags)
 {
 	struct btrfs_dir_item *di = NULL;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -217,22 +219,6 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
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
-	ASSERT(trans);
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
@@ -357,6 +343,9 @@ static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
 
 	name = xattr_full_name(handler, name);
 
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
 	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
@@ -445,7 +434,7 @@ static int btrfs_initxattrs(struct inode *inode,
 		strcpy(name, XATTR_SECURITY_PREFIX);
 		strcpy(name + XATTR_SECURITY_PREFIX_LEN, xattr->name);
 		err = btrfs_setxattr(trans, inode, name, xattr->value,
-				xattr->value_len, 0);
+				     xattr->value_len, 0);
 		kfree(name);
 		if (err < 0)
 			break;
diff --git a/fs/btrfs/xattr.h b/fs/btrfs/xattr.h
index 471fcac6ff55..26ff6c11774f 100644
--- a/fs/btrfs/xattr.h
+++ b/fs/btrfs/xattr.h
@@ -12,9 +12,8 @@
 
 int btrfs_getxattr(struct inode *inode, const char *name,
 		void *buffer, size_t size);
-int btrfs_setxattr(struct btrfs_trans_handle *trans,
-			    struct inode *inode, const char *name,
-			    const void *value, size_t size, int flags);
+int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
+		   const char *name, const void *value, size_t size, int flags);
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
 int btrfs_xattr_security_init(struct btrfs_trans_handle *trans,
-- 
1.8.3.1

