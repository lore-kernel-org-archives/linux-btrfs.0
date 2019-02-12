Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E15AC282CE
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 02:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C70E21B18
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 02:19:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q7Jbs0iu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfBLCTK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 21:19:10 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37708 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbfBLCTK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 21:19:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1C2J8Tf026821
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=dMrprD0YDRArK19Oxq03j6SG/rygroTuug9GYdzzJX4=;
 b=Q7Jbs0iuRpg9GKYEeIlizSFtKl3cqdoDmfvXSyQzcHDlruDBfpKNxgKoj6Nob5R+OdRA
 MjeRSsx6pabL0uVP61j4s9HN6qqMdeylFbnkWgA+R+6GStkGqI7UAwQxWdxBiFC6k6Oi
 okBhypNdnlZvcP2LWFRN6uy84fyAmL4L6rmR91DAhS5vP6UDTXigS8ZxD1D4tEiHZ1uX
 BsH3tXz4CMoIdFXuvAByRk5qpGF1ZR0z/1/OK3F3g0tHYcEELd/LpBtW+d2S8NV2Zdur
 TGXTJc9DTvAfcLsoJGERwnPyrDzeMYJoDZyYWF2mX/r3xt7UO1+kIxJJFRpE0uj38rYw +g== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2qhrek99pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:08 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1C2J3kt005946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:03 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1C2J3dX000598
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:03 GMT
Received: from tpasj.localdomain (/183.90.37.91)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Feb 2019 18:19:02 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/3] btrfs: kill __btrfs_set_prop()
Date:   Tue, 12 Feb 2019 10:18:49 +0800
Message-Id: <1549937931-15339-2-git-send-email-anand.jain@oracle.com>
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

btrfs_set_prop() is a redirect to __btrfs_set_prop() with the
transaction handler equal to NULL. And __btrfs_set_prop() inturn diectly
uses trans to do_setxattr() which when trans is NULL creates a transaction.

Instead rename __btrfs_set_prop() to btrfs_set_prop(), and update the
caller with NULL argument.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v3: none
v2: none

 fs/btrfs/ioctl.c | 10 ++++++----
 fs/btrfs/props.c | 22 +++++-----------------
 fs/btrfs/props.h |  6 ++----
 fs/btrfs/xattr.c |  2 +-
 4 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3f9d7be30bf4..5a4ed2f66e09 100644
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

