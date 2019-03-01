Return-Path: <SRS0=p7dB=RE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D335C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D46AA20851
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RUDBNb2G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbfCAEfG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 23:35:06 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45178 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbfCAEfG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 23:35:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x214YM1c006610
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=acwO6jBjzcvGlZRODIduV2IcJ8xCwWnDLFlyZBpQh6w=;
 b=RUDBNb2GPi9YPLLHSeU+ASa0gouk1m8Bv7CaRyW2M+zKcSV6l4QtlywipVEWt1+8ZobY
 ApaLJq4/0Kc1VPVxghkSY5TOufLYBUbUvFuc7GyCYHv/Vh1vI9nhcuZ4Z1cUZmf4YWwr
 O6h9wTxXY+HCQoVtaL+XrQm+XC4Edb90foZDyQrD2kslHuEMKuCfKhBbGaMNM5uIAVXU
 cylHN1Ct/7f51PGZcA+nm5i8c84Sxuw51MaviDq+fNUCUpj7WHH39Ys0lSN8Z8Bx0KPm
 GSg+ORTZnF7dYIvRY8P7pm4mguasS6fmJQyiwc3XYDSFBv8ajuJn1IoQS+vPbAZNS50N 4w== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qtxts53q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2019 04:35:05 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x214Z4BU014378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:04 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x214Z49q011453
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:04 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Feb 2019 20:35:03 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5 4/9] btrfs: refactor btrfs_set_prop add btrfs_set_prop_trans
Date:   Fri,  1 Mar 2019 12:34:50 +0800
Message-Id: <1551414895-22925-5-git-send-email-anand.jain@oracle.com>
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

btrfs_set_prop() accepts transaction pointer as the first argument,
however in ioctl.c for the purpose of setting the compression property,
we call btrfs_set_prop() with NULL transaction pointer. Down in
the call chain  btrfs_setxattr() starts transaction to update the
attribute and also to update the inode. So for better clarity, create
btrfs_set_prop_trans() with no transaction pointer as argument, in
preparation to start transaction here instead of doing it down the
call chain at btrfs_setxattr().

Also now the btrfs_set_prop() is a static function.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v5: change log updated, fix c-style.
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
index 77a03076b18e..ca4af745fb90 100644
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
+			 const char *value, size_t value_len, int flags)
+{
+	return btrfs_set_prop(NULL, inode, name, value, value_len, flags);
+}
+
 static int iterate_object_props(struct btrfs_root *root,
 				struct btrfs_path *path,
 				u64 objectid,
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

