Return-Path: <SRS0=nucE=SW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECFDC282DD
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 489DE20645
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ofoUtO6k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfDTLtM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 20 Apr 2019 07:49:12 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49008 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfDTLtM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Apr 2019 07:49:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBmfjM049322
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=xU77kcrfuqK0EA4mW1ULTXOQxefSWVlXRmTqWA189l0=;
 b=ofoUtO6ktUavszaFfPrahZBISiaycxgDOzBk4rjfxf/MXZ5mnvLoZOjp2xctTMaxJjgM
 1Ooyr0kmhbMX9aqe7/gpSUDQyEwijN40kge1hAw8QEbKJw3gpUOC4+Tccqu/iTR5bGgD
 3gy9KVlyKgdunNY8qcPAJ0WIM3DVcMapfHNXwt61Vz9uBnhdxyTnxAcwV1mkNUG7ZrBr
 1nL2kKNXyiKAzTz3OXN9XzoHatji4RJSLteXnqznnsmTaM6AyBpSTt6zQ/kIfGpocm+1
 lfCMEB4UCyW7ZAR4CM8ZB3FEMTcls1X/Xqwv38YM3MkeSzBQZdXrtKfDMufP1NS9gEBm Qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2ryrxch2s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBn4O6037537
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ryu803awf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:10 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3KBnAWD027898
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:10 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 20 Apr 2019 04:49:09 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 01/10] btrfs: refactor btrfs_set_props to validate externally
Date:   Sat, 20 Apr 2019 19:48:51 +0800
Message-Id: <20190420114900.15472-2-anand.jain@oracle.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190420114900.15472-1-anand.jain@oracle.com>
References: <20190420114900.15472-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904200090
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904200090
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In preparation to merge multiple transactions when setting the
compression flags, split btrfs_set_props() validation part
outside of it.

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
2.20.1 (Apple Git-117)

