Return-Path: <SRS0=p7dB=RE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2CAC4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB8902186A
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rvrDiXwn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfCAEfD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 23:35:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45120 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727945AbfCAEfC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 23:35:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x214Y6sa006550
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=FGtQYMFNYgQcqKbBrpxY377Iidoyu04Q9R7r+elKo4k=;
 b=rvrDiXwn8+wkxsdFtCBSZgJL2WAfwuqCUo1Pr8BB/+loL5/yg836BmZ/I1AWq9YWVrsf
 yPZOI6WExlcsB2JFEgdmJEiTEnxqtnH25QfJmpYUlLmpOq7kxg4Xfl3R5YcAqr1B//qW
 XSTw6nIVH1ETZV3AhzaY6RPzBXIla7N0AKfBGZvRjp8uUvZEnGnsdJXKpH8x7kQP2rz3
 KO6dIhwLUIdu7U5te2LmXg6AappSKQS+wY+XLodzLW48xf7aPYJYwvZWQaHUCN8PfNgx
 JRBmDZMzRnGWO7aTynnCqM1OlhCaJ5X/jfEbKghE8Aw8Ux1XW9DEBLO7fdtb7aPTKH+G Lw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qtxts53pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2019 04:35:00 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x214YxhA014116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:00 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x214YxFo005480
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:34:59 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Feb 2019 20:34:59 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5 1/9] btrfs: kill __btrfs_set_prop()
Date:   Fri,  1 Mar 2019 12:34:47 +0800
Message-Id: <1551414895-22925-2-git-send-email-anand.jain@oracle.com>
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

btrfs_set_prop() is a redirect to __btrfs_set_prop() with the
transaction handler equal to NULL.  __btrfs_set_prop() inturn passes this
NULL trans to do_setxattr() which then transaction is actually created.

Instead rename __btrfs_set_prop() to btrfs_set_prop(), and update the
caller with NULL argument.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v5: none
v4: none
v3: none
v2: none

 fs/btrfs/ioctl.c | 10 ++++++----
 fs/btrfs/props.c | 22 +++++-----------------
 fs/btrfs/props.h |  6 ++----
 fs/btrfs/xattr.c |  2 +-
 4 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 494f0f10d70e..cb34532960d2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -284,7 +284,8 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		binode->flags &= ~BTRFS_INODE_COMPRESS;
 		binode->flags |= BTRFS_INODE_NOCOMPRESS;
 
-		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
+		ret = btrfs_set_prop(NULL, inode, "btrfs.compression", NULL, 0,
+				     0);
 		if (ret && ret != -ENODATA)
 			goto out_drop;
 	} else if (fsflags & FS_COMPR_FL) {
@@ -302,13 +303,14 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		if (!comp || comp[0] == 0)
 			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
 
-		ret = btrfs_set_prop(inode, "btrfs.compression",
-				     comp, strlen(comp), 0);
+		ret = btrfs_set_prop(NULL, inode, "btrfs.compression", comp,
+				     strlen(comp), 0);
 		if (ret)
 			goto out_drop;
 
 	} else {
-		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
+		ret = btrfs_set_prop(NULL, inode, "btrfs.compression", NULL, 0,
+				     0);
 		if (ret && ret != -ENODATA)
 			goto out_drop;
 		binode->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index dc6140013ae8..4525a2a4d1cd 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -85,12 +85,9 @@ static const struct hlist_head *find_prop_handlers_by_hash(const u64 hash)
 	return NULL;
 }
 
-static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
-			    struct inode *inode,
-			    const char *name,
-			    const char *value,
-			    size_t value_len,
-			    int flags)
+int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
+		   const char *name, const char *value, size_t value_len,
+		   int flags)
 {
 	const struct prop_handler *handler;
 	int ret;
@@ -133,15 +130,6 @@ static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-int btrfs_set_prop(struct inode *inode,
-		   const char *name,
-		   const char *value,
-		   size_t value_len,
-		   int flags)
-{
-	return __btrfs_set_prop(NULL, inode, name, value, value_len, flags);
-}
-
 static int iterate_object_props(struct btrfs_root *root,
 				struct btrfs_path *path,
 				u64 objectid,
@@ -313,8 +301,8 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 					  num_bytes, BTRFS_RESERVE_NO_FLUSH);
 		if (ret)
 			goto out;
-		ret = __btrfs_set_prop(trans, inode, h->xattr_name,
-				       value, strlen(value), 0);
+		ret = btrfs_set_prop(trans, inode, h->xattr_name, value,
+				     strlen(value), 0);
 		btrfs_block_rsv_release(fs_info, trans->block_rsv, num_bytes);
 		if (ret)
 			goto out;
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index 618815b4f9d5..9dbdae47cf27 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -10,10 +10,8 @@
 
 void __init btrfs_props_init(void);
 
-int btrfs_set_prop(struct inode *inode,
-		   const char *name,
-		   const char *value,
-		   size_t value_len,
+int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
+		   const char *name, const char *value, size_t value_len,
 		   int flags);
 
 int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path);
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index f141b45ce349..499bb79ba135 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -379,7 +379,7 @@ static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
 					size_t size, int flags)
 {
 	name = xattr_full_name(handler, name);
-	return btrfs_set_prop(inode, name, value, size, flags);
+	return btrfs_set_prop(NULL, inode, name, value, size, flags);
 }
 
 static const struct xattr_handler btrfs_security_xattr_handler = {
-- 
1.8.3.1

