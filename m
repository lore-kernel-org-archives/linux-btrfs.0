Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDE3C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 10:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 239E820856
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 10:08:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jVBVoZvQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbfDBKIJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 06:08:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46000 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728710AbfDBKII (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 06:08:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x329hUEp123779
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:08:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=X6hFceoyiVfuG5lZ43F/nqqVmsNjfVpfEkuCBmUzsuk=;
 b=jVBVoZvQbhIp6v2Mh2WZnxbzIWgx8RkWCDnnUMQESddT5KWljcxe3zRKel7CvR7FkWEx
 vKa1oymrWN6yY/JUbUO4gqLpuKAw1vAU/JxjM1MIOvN96c4Az1HXlPF3gA3Xxf+XngIs
 lsQS2nvtPdqY1tgy22xnQaMib+Y5T/mJGlmAJo+EpL2IX7gUnqxOCjqUGr+S6AiNRi5X
 n9cELtzY4IU3J+2FKkwPAbWNwyyBNrk45F+ys4imH8tY81b+qSzltBQb39CU4Bucwc+C
 cu+NXtM6YbmiP55w3GMcAymXgkJKIpi9Uiba363S2pQ2dNFIWC62RflB5EGlgkGosRsb Ug== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2rj13q43re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2019 10:08:07 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x32A86ZA018153
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:08:06 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x32A86In006965
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:08:06 GMT
Received: from tp.wifi.oracle.com (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Apr 2019 03:08:05 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4 RESEND] btrfs: fix property validate fail should not increment generation
Date:   Tue,  2 Apr 2019 18:07:42 +0800
Message-Id: <20190402100742.8355-6-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190402100742.8355-1-anand.jain@oracle.com>
References: <20190402100742.8355-1-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9214 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904020070
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When the property fails to pass the prop_handlers::validate() check, the
thread should exit with no changes in the kernel, but as we are starting
the transaction too early, we have just updated the generation even if
there is no change.

For example:
btrfs prop get /btrfs compression
 compression=lzo
sync
btrfs in dump-super /dev/sdb | grep "^generation"
 generation		32

Try to set an incomplete compression type

btrfs prop set /btrfs compression zli
  ERROR: failed to set compression for /btrfs: Invalid argument
sync

Set failed but generation is incremented
btrfs in dump-super /dev/sdb | grep "^generation"
 generation		33  <--

Fix it by collapsing btrfs_set_prop_trans() into btrfs_set_prop(), which
provides flexibility to start the transaction after the
prop_handlers::validate() has been checked.

As of now if the prop_handlers::apply() fails then we still increment
the generation, but if there is strong prop_handlers::validate() then
the prop_handlers::apply() can never fail.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c | 10 ++++------
 fs/btrfs/props.c | 59 +++++++++++++++++++++++++-------------------------------
 fs/btrfs/props.h |  4 ++--
 fs/btrfs/xattr.c |  2 +-
 4 files changed, 33 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 28ee9fe6edb4..0eeaf9a68082 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -284,8 +284,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		binode->flags &= ~BTRFS_INODE_COMPRESS;
 		binode->flags |= BTRFS_INODE_NOCOMPRESS;
 
-		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
-					   0, 0);
+		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
 		if (ret && ret != -ENODATA)
 			goto out_drop;
 	} else if (fsflags & FS_COMPR_FL) {
@@ -303,14 +302,13 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		if (!comp || comp[0] == 0)
 			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
 
-		ret = btrfs_set_prop_trans(inode, "btrfs.compression", comp,
-					   strlen(comp), 0);
+		ret = btrfs_set_prop(inode, "btrfs.compression", comp,
+				     strlen(comp), 0);
 		if (ret)
 			goto out_drop;
 
 	} else {
-		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
-					   0, 0);
+		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
 		if (ret && ret != -ENODATA)
 			goto out_drop;
 		binode->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index fb84e76f3b1d..99fa2459ba61 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -56,11 +56,12 @@ static const struct hlist_head *find_prop_handlers_by_hash(const u64 hash)
 	return NULL;
 }
 
-static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
-			  const char *name, const char *value, size_t value_len,
-			  int flags)
+int btrfs_set_prop(struct inode *inode, const char *name, const char *value,
+		   size_t value_len, int flags)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	const struct prop_handler *handler;
+	struct btrfs_trans_handle *trans;
 	int ret;
 
 	if (btrfs_root_readonly(BTRFS_I(inode)->root))
@@ -74,50 +75,40 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 		return -EINVAL;
 
 	if (value_len == 0) {
+		/* Its called to reset the property */
+		trans = btrfs_start_transaction(root, 2);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
+
 		ret = btrfs_setxattr(trans, inode, handler->xattr_name,
 				       NULL, 0, flags);
-		if (ret)
-			return ret;
-
-		ret = handler->apply(inode, NULL, 0);
-		ASSERT(ret == 0);
-
-		return ret;
+		if (!ret) {
+			ret = handler->apply(inode, NULL, 0);
+			ASSERT(ret == 0);
+		}
+		goto out;
 	}
 
 	ret = handler->validate(value, value_len);
 	if (ret)
 		return ret;
+
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	ret = btrfs_setxattr(trans, inode, handler->xattr_name,
 			       value, value_len, flags);
 	if (ret)
-		return ret;
+		goto out;
+
 	ret = handler->apply(inode, value, value_len);
 	if (ret) {
+		/* Apply failed. Reset the property. */
 		btrfs_setxattr(trans, inode, handler->xattr_name,
 				 NULL, 0, flags);
-		return ret;
-	}
-
-	set_bit(BTRFS_INODE_HAS_PROPS, &BTRFS_I(inode)->runtime_flags);
-
-	return 0;
-}
-
-int btrfs_set_prop_trans(struct inode *inode, const char *name,
-			 const char *value, size_t value_len, int flags)
-{
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_trans_handle *trans;
-	int ret;
-
-	trans = btrfs_start_transaction(root, 2);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
-
-	ret = btrfs_set_prop(trans, inode, name, value, value_len, flags);
-
-	if (!ret) {
+	} else {
+		set_bit(BTRFS_INODE_HAS_PROPS, &BTRFS_I(inode)->runtime_flags);
 		inode_inc_iversion(inode);
 		inode->i_ctime = current_time(inode);
 		set_bit(BTRFS_INODE_COPY_EVERYTHING,
@@ -125,6 +116,8 @@ int btrfs_set_prop_trans(struct inode *inode, const char *name,
 		ret = btrfs_update_inode(trans, root, inode);
 		BUG_ON(ret);
 	}
+
+out:
 	btrfs_end_transaction(trans);
 	return ret;
 }
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index b1a6b233b774..72bca072f9ba 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -10,8 +10,8 @@
 
 void __init btrfs_props_init(void);
 
-int btrfs_set_prop_trans(struct inode *inode, const char *name,
-			 const char *value, size_t value_len, int flags);
+int btrfs_set_prop(struct inode *inode, const char *name,
+		   const char *value, size_t value_len, int flags);
 
 int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path);
 
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 58579a4d2f22..abc150a56f8b 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -371,7 +371,7 @@ static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
 					size_t size, int flags)
 {
 	name = xattr_full_name(handler, name);
-	return btrfs_set_prop_trans(inode, name, value, size, flags);
+	return btrfs_set_prop(inode, name, value, size, flags);
 }
 
 static const struct xattr_handler btrfs_security_xattr_handler = {
-- 
1.8.3.1

