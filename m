Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41E1C282CE
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 08:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B2AE2171F
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 08:03:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lpyly8WM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfDLIDN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 04:03:13 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51154 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbfDLIDM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 04:03:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C7sIh0080661
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=coclEDqwRQTENiwbo6mj1Kov0tRqPqqXVzKNTizp7vs=;
 b=Lpyly8WMhU2xOk2G6KuQOdfgO5y8vC5K5AinlZKBOFi5xL+yct7pfDTieEgeekHJTA3v
 ULWEouW7sEvx7fjxO3Ai+WMD6/eYf3U0u0SjvBLpnoLGJm6994dudupPF9DPxERL0Qd3
 DboUmLJmcN+2V2hvA2sqyjXZepm998PDiPl8qQ/Td0/mz8d0sKM8IzuQKHD8xFG6mOMj
 ncrAOrKECOL+NHwIt+EDDFI0udZxeJGUwtHgJe8Als8tDk6APz7sY1LdBPuEyuh18vz2
 LBmzx4XRGsoyiYRi0+f/Vpz/cN7b3et6dSSbHl71FQweWvo3wgGw3Rei7th4C9LxaV/T XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2rphmew6qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C831j4099224
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2rtd84dv4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:10 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3C839YC027598
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:10 GMT
Received: from tp.wifi.oracle.com (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Apr 2019 01:03:09 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs: rename btrfs_setxattr to btrfs_setxattr_trans
Date:   Fri, 12 Apr 2019 16:02:54 +0800
Message-Id: <20190412080259.5192-2-anand.jain@oracle.com>
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

Rename btrfs_setxattr() to btrfs_setxattr_trans(), so that do_setxattr()
can be renamed to btrfs_setxattr().
Preparatory patch, no functional changes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/acl.c   |  2 +-
 fs/btrfs/props.c | 20 ++++++++++----------
 fs/btrfs/xattr.c | 12 ++++++------
 fs/btrfs/xattr.h |  2 +-
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 5810463dc6d2..d3b04c6abc61 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -93,7 +93,7 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 			goto out;
 	}
 
-	ret = btrfs_setxattr(trans, inode, name, value, size, 0);
+	ret = btrfs_setxattr_trans(trans, inode, name, value, size, 0);
 out:
 	kfree(value);
 
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 0d1c3485c098..61ced0ebb5ba 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -70,8 +70,8 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 		return -EINVAL;
 
 	if (value_len == 0) {
-		ret = btrfs_setxattr(trans, inode, handler->xattr_name,
-				       NULL, 0, flags);
+		ret = btrfs_setxattr_trans(trans, inode, handler->xattr_name,
+					   NULL, 0, flags);
 		if (ret)
 			return ret;
 
@@ -84,14 +84,14 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 	ret = handler->validate(value, value_len);
 	if (ret)
 		return ret;
-	ret = btrfs_setxattr(trans, inode, handler->xattr_name,
-			       value, value_len, flags);
+	ret = btrfs_setxattr_trans(trans, inode, handler->xattr_name,
+				   value, value_len, flags);
 	if (ret)
 		return ret;
 	ret = handler->apply(inode, value, value_len);
 	if (ret) {
-		btrfs_setxattr(trans, inode, handler->xattr_name,
-				 NULL, 0, flags);
+		btrfs_setxattr_trans(trans, inode, handler->xattr_name,
+				     NULL, 0, flags);
 		return ret;
 	}
 
@@ -358,13 +358,13 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 		if (ret)
 			return ret;
 
-		ret = btrfs_setxattr(trans, inode, h->xattr_name, value,
-				     strlen(value), 0);
+		ret = btrfs_setxattr_trans(trans, inode, h->xattr_name, value,
+					   strlen(value), 0);
 		if (!ret) {
 			ret = h->apply(inode, value, strlen(value));
 			if (ret)
-				btrfs_setxattr(trans, inode, h->xattr_name,
-					       NULL, 0, 0);
+				btrfs_setxattr_trans(trans, inode, h->xattr_name,
+						     NULL, 0, 0);
 			else
 				set_bit(BTRFS_INODE_HAS_PROPS,
 					&BTRFS_I(inode)->runtime_flags);
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index fa820c56ba3e..38eb78aac0a7 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -220,9 +220,9 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 /*
  * @value: "" makes the attribute to empty, NULL removes it
  */
-int btrfs_setxattr(struct btrfs_trans_handle *trans,
-		     struct inode *inode, const char *name,
-		     const void *value, size_t size, int flags)
+int btrfs_setxattr_trans(struct btrfs_trans_handle *trans,
+			 struct inode *inode, const char *name,
+			 const void *value, size_t size, int flags)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
@@ -370,7 +370,7 @@ static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
 				   size_t size, int flags)
 {
 	name = xattr_full_name(handler, name);
-	return btrfs_setxattr(NULL, inode, name, buffer, size, flags);
+	return btrfs_setxattr_trans(NULL, inode, name, buffer, size, flags);
 }
 
 static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
@@ -441,8 +441,8 @@ static int btrfs_initxattrs(struct inode *inode,
 		}
 		strcpy(name, XATTR_SECURITY_PREFIX);
 		strcpy(name + XATTR_SECURITY_PREFIX_LEN, xattr->name);
-		err = btrfs_setxattr(trans, inode, name, xattr->value,
-				xattr->value_len, 0);
+		err = btrfs_setxattr_trans(trans, inode, name, xattr->value,
+					   xattr->value_len, 0);
 		kfree(name);
 		if (err < 0)
 			break;
diff --git a/fs/btrfs/xattr.h b/fs/btrfs/xattr.h
index 471fcac6ff55..36d54a15cbfe 100644
--- a/fs/btrfs/xattr.h
+++ b/fs/btrfs/xattr.h
@@ -12,7 +12,7 @@ extern const struct xattr_handler *btrfs_xattr_handlers[];
 
 int btrfs_getxattr(struct inode *inode, const char *name,
 		void *buffer, size_t size);
-int btrfs_setxattr(struct btrfs_trans_handle *trans,
+int btrfs_setxattr_trans(struct btrfs_trans_handle *trans,
 			    struct inode *inode, const char *name,
 			    const void *value, size_t size, int flags);
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
-- 
2.17.1

