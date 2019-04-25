Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10CCC10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 11:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFC822084B
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 11:59:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="1omVxvHW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfDYL75 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:59:57 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58734 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfDYL74 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 07:59:56 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3PBxMeo071761
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=uJ9iFLXrH9aID1v0/X9Ru8OBfcfwqRWFNGvhPxqbQvM=;
 b=1omVxvHWmMxA+YWVF/5G2BX8Rwu0NGEjQ8o9IG6hevSigwbxf9wPKPD+C5xqpAy8V3oO
 tQB0ziSxExBI2meNNQBmgzPOOEPFrIqk83+AbXapEWIjpy9fnmw9KPKviLqVspOf07Kd
 5U3tPNxk76ZO7eOo+Vgyte57bCMvmS0VQ9OVTTQmnlrmYoaksn3KsrTCBMumWEXjucb1
 PRakhEVleayFAERXAKsuL7vkcWin6z5C/iUt46XVRBZao9qC2K70vjWeS8kDaey6Gm0L
 OxmMbu2/WD1htCPoaOIeQOqEDo3pEglPPwYzlNVjDTB1QWyXiKxjU3ZJj4o+lrEyVbSa NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2ryrxd8303-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3PBwUUx188644
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2s0f0wkp6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:54 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3PBxrVX023035
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 11:59:54 GMT
Received: from localhost.localdomain (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Apr 2019 04:59:53 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: add inode pointer to prop_handler::validate()
Date:   Thu, 25 Apr 2019 19:59:44 +0800
Message-Id: <20190425115946.2550-2-anand.jain@oracle.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190425115946.2550-1-anand.jain@oracle.com>
References: <20190425115946.2550-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9237 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904250077
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9237 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904250077
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In preparation to add the readmirror property, pass inode in the
prop_handler::validate() function vector, so that it can fetch
corresponding fs_devices.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c | 12 +++++++-----
 fs/btrfs/props.h |  4 ++--
 fs/btrfs/xattr.c |  2 +-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index ca2716917e37..5c1fccc32b43 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -17,7 +17,7 @@ static DEFINE_HASHTABLE(prop_handlers_ht, BTRFS_PROP_HANDLERS_HT_BITS);
 struct prop_handler {
 	struct hlist_node node;
 	const char *xattr_name;
-	int (*validate)(const char *value, size_t len);
+	int (*validate)(struct inode *inode, const char *value, size_t len);
 	int (*apply)(struct inode *inode, const char *value, size_t len);
 	const char *(*extract)(struct inode *inode);
 	int inheritable;
@@ -55,7 +55,8 @@ find_prop_handler(const char *name,
 	return NULL;
 }
 
-int btrfs_validate_prop(const char *name, const char *value, size_t value_len)
+int btrfs_validate_prop(struct inode *inode, const char *name,
+			const char *value, size_t value_len)
 {
 	const struct prop_handler *handler;
 
@@ -69,7 +70,7 @@ int btrfs_validate_prop(const char *name, const char *value, size_t value_len)
 	if (value_len == 0)
 		return 0;
 
-	return handler->validate(value, value_len);
+	return handler->validate(inode, value, value_len);
 }
 
 int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
@@ -252,7 +253,8 @@ int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path)
 	return ret;
 }
 
-static int prop_compression_validate(const char *value, size_t len)
+static int prop_compression_validate(struct inode *inode, const char *value,
+				     size_t len)
 {
 	if (!value)
 		return 0;
@@ -353,7 +355,7 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 		 * This is not strictly necessary as the property should be
 		 * valid, but in case it isn't, don't propagate it futher.
 		 */
-		ret = h->validate(value, strlen(value));
+		ret = h->validate(inode, value, strlen(value));
 		if (ret)
 			continue;
 
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index 40b2c65b518c..5b1e39136f7f 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -13,8 +13,8 @@ void __init btrfs_props_init(void);
 int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 		   const char *name, const char *value, size_t value_len,
 		   int flags);
-int btrfs_validate_prop(const char *name, const char *value, size_t value_len);
-
+int btrfs_validate_prop(struct inode *inode, const char *name,
+			const char *value, size_t value_len);
 int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path);
 
 int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 46ad7b5cf209..4e4f0edd4968 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -378,7 +378,7 @@ static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	name = xattr_full_name(handler, name);
-	ret = btrfs_validate_prop(name, value, size);
+	ret = btrfs_validate_prop(inode, name, value, size);
 	if (ret)
 		return ret;
 
-- 
2.20.1 (Apple Git-117)

