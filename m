Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D69C10F00
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86D0D206B6
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L21pk1pG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfBVRkK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:40:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50010 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfBVRkK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 12:40:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1MHOlgO195529
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=4xzEio/5Or+pHjYgspzj30kqYPPv2YjWnaZtinMbkCA=;
 b=L21pk1pGvn2ukMPZ0qGwImkjKYKZyRr8d3lMUnlI14dzc1jusVs2ShQHkn98mip08WUz
 m6phTO69QiafMIq2k8CF3JikAEkyXRG7AMKe8sXH3a8xd48P5oOu7P0mAmRAAYG4GrMv
 /yoDcbkOefYYEmWUQ/uQS8qADngViWMFEx8ydJFDxqKHQQR+SoJiEBEsQgGqyXrcKKHr
 40IcOzDB1qJUWopqx7o6fJvRvU0hvZbrndqxkJ18o4E0BBD6NZ8lIPDIZ0OkZlC+ZQKh
 XEEE4/JQIRe7aLLBGhu1sJbTN3deJpRXrAzM6fFag+clKTX+ks8btrenmfPDkEnVT/DL Fg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qpb5s0g3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:08 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHe7Jw030137
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:07 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1MHe7kb016201
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:07 GMT
Received: from tpasj.localdomain (/157.45.233.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Feb 2019 09:40:07 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 05/10] btrfs: refactor btrfs_set_prop add btrfs_set_prop_trans
Date:   Sat, 23 Feb 2019 01:39:47 +0800
Message-Id: <1550857192-10513-6-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9175 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=954 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902220122
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_set_prop() accepts transaction pointer as the first argument,
however in ioctl.c for the purpose of setting the compression property,
we call btrfs_set_prop() with NULL transaction pointer. Down in
the call chain  btrfs_setxattr() would start transaction to update the
attribute and also to update the inode. So for better clarity, create
btrfs_set_prop_notrans() with no transaction pointer as argument.

And now btrfs_set_prop() is a static function.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v4: born

Its named btrfs_set_prop_trans() instead of btrfs_set_prop_notrans()
because in the next patch I am starting the transaction in
btrfs_set_prop_trans(). I am ok if this and the next patch are squashed
during integration, as it is separated only for the purpose of easy review.

 fs/btrfs/ioctl.c | 12 ++++++------
 fs/btrfs/props.c | 12 +++++++++---
 fs/btrfs/props.h |  5 ++---
 fs/btrfs/xattr.c |  2 +-
 4 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cb34532960d2..ba58adce4566 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -284,8 +284,8 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		binode->flags &= ~BTRFS_INODE_COMPRESS;
 		binode->flags |= BTRFS_INODE_NOCOMPRESS;
 
-		ret = btrfs_set_prop(NULL, inode, "btrfs.compression", NULL, 0,
-				     0);
+		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
+					     0, 0);
 		if (ret && ret != -ENODATA)
 			goto out_drop;
 	} else if (fsflags & FS_COMPR_FL) {
@@ -303,14 +303,14 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		if (!comp || comp[0] == 0)
 			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
 
-		ret = btrfs_set_prop(NULL, inode, "btrfs.compression", comp,
-				     strlen(comp), 0);
+		ret = btrfs_set_prop_trans(inode, "btrfs.compression", comp,
+					     strlen(comp), 0);
 		if (ret)
 			goto out_drop;
 
 	} else {
-		ret = btrfs_set_prop(NULL, inode, "btrfs.compression", NULL, 0,
-				     0);
+		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
+					     0, 0);
 		if (ret && ret != -ENODATA)
 			goto out_drop;
 		binode->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 3c15f19bfd2f..e581da1bfbb6 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -55,9 +55,9 @@ static const struct hlist_head *find_prop_handlers_by_hash(const u64 hash)
 	return NULL;
 }
 
-int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
-		   const char *name, const char *value, size_t value_len,
-		   int flags)
+static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
+			  const char *name, const char *value, size_t value_len,
+			  int flags)
 {
 	const struct prop_handler *handler;
 	int ret;
@@ -100,6 +100,12 @@ int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 	return 0;
 }
 
+int btrfs_set_prop_trans(struct inode *inode, const char *name,
+			   const char *value, size_t value_len, int flags)
+{
+	return btrfs_set_prop(NULL, inode, name, value, value_len, flags);
+}
+
 static int iterate_object_props(struct btrfs_root *root,
 				struct btrfs_path *path, u64 objectid,
 				void (*iterator)(void *,
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index 9dbdae47cf27..01b3d4bbb207 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -10,9 +10,8 @@
 
 void __init btrfs_props_init(void);
 
-int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
-		   const char *name, const char *value, size_t value_len,
-		   int flags);
+int btrfs_set_prop_trans(struct inode *inode, const char *name,
+			   const char *value, size_t value_len, int flags);
 
 int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path);
 
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 6971cbf286b5..69126d5b4d62 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -379,7 +379,7 @@ static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
 					size_t size, int flags)
 {
 	name = xattr_full_name(handler, name);
-	return btrfs_set_prop(NULL, inode, name, value, size, flags);
+	return btrfs_set_prop_trans(inode, name, value, size, flags);
 }
 
 static const struct xattr_handler btrfs_security_xattr_handler = {
-- 
1.8.3.1

