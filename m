Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8CBC10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 08:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F71A205ED
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 08:03:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bEPmBE0q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbfDLIDU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 04:03:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60364 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbfDLIDT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 04:03:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C7rfRn084285
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=PehDrGFZgiOmvFe2YQQejsHpFyEmT7KoG7pWSGTuBPA=;
 b=bEPmBE0qCRHcQtxzKAqpuEmdnGI2bEJiUiJRLeOffgU9RIO+MXi53nvFzo5g0bOFJFYj
 Uz0sr54EOFgPi0VTUWgJZVvgj2cXyeKtkiZO0/X/PlEIkiv0Q3pFzXw+mTZQnWvyY3S0
 OmLh3HYrr0VcdyhdLuwyfX/a1Z5X6xxxs4lnRlhriPcZHkV0gnnEXJTF2P6B5Fu1rTxG
 NNalf+ZTo0Zh17d1g4WYPRlDK8N59YKN2J3YHLYYo8Vd8EYIEhEUSeMx7qm73XN3uK1K
 f0An50nlHrz8nwQikVyX63fi3yQo+PtmX7OSxckU3n6jdkNf89QZ4GF6afbxSCOTVl46 fA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2rpmrqmy7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C831r8139895
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2rt9uq1ggm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3C83G83023263
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:16 GMT
Received: from tp.wifi.oracle.com (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Apr 2019 01:03:15 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs: split thread with trans to use btrfs_setxattr
Date:   Fri, 12 Apr 2019 16:02:58 +0800
Message-Id: <20190412080259.5192-6-anand.jain@oracle.com>
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

When the parent thread has already created the transaction call
btrfs_setxattr() directly. Also adds assert in btrfs_setxattr()
to check if trans is not null.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/acl.c   |  6 +++++-
 fs/btrfs/props.c | 34 ++++++++++++++++++++++++----------
 fs/btrfs/xattr.c |  6 ++++--
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index d3b04c6abc61..7fe6551bc59b 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -93,7 +93,11 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 			goto out;
 	}
 
-	ret = btrfs_setxattr_trans(trans, inode, name, value, size, 0);
+	if (trans)
+		ret = btrfs_setxattr(trans, inode, name, value, size, 0);
+	else
+		ret = btrfs_setxattr_trans(NULL, inode, name, value, size, 0);
+
 out:
 	kfree(value);
 
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 61ced0ebb5ba..a73c1bdc7b05 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -70,8 +70,13 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 		return -EINVAL;
 
 	if (value_len == 0) {
-		ret = btrfs_setxattr_trans(trans, inode, handler->xattr_name,
-					   NULL, 0, flags);
+		if (trans)
+			ret = btrfs_setxattr(trans, inode, handler->xattr_name,
+					     NULL, 0, flags);
+		else
+			ret = btrfs_setxattr_trans(NULL, inode,
+						   handler->xattr_name, NULL, 0,
+						   flags);
 		if (ret)
 			return ret;
 
@@ -84,14 +89,23 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 	ret = handler->validate(value, value_len);
 	if (ret)
 		return ret;
-	ret = btrfs_setxattr_trans(trans, inode, handler->xattr_name,
-				   value, value_len, flags);
+	if (trans)
+		ret = btrfs_setxattr(trans, inode, handler->xattr_name, value,
+				     value_len, flags);
+	else
+		ret = btrfs_setxattr_trans(NULL, inode, handler->xattr_name,
+					   value, value_len, flags);
+
 	if (ret)
 		return ret;
 	ret = handler->apply(inode, value, value_len);
 	if (ret) {
-		btrfs_setxattr_trans(trans, inode, handler->xattr_name,
-				     NULL, 0, flags);
+		if (trans)
+			btrfs_setxattr(trans, inode, handler->xattr_name, NULL,
+				       0, flags);
+		else
+			btrfs_setxattr_trans(NULL, inode, handler->xattr_name,
+					     NULL, 0, flags);
 		return ret;
 	}
 
@@ -358,13 +372,13 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 		if (ret)
 			return ret;
 
-		ret = btrfs_setxattr_trans(trans, inode, h->xattr_name, value,
-					   strlen(value), 0);
+		ret = btrfs_setxattr(trans, inode, h->xattr_name, value,
+				     strlen(value), 0);
 		if (!ret) {
 			ret = h->apply(inode, value, strlen(value));
 			if (ret)
-				btrfs_setxattr_trans(trans, inode, h->xattr_name,
-						     NULL, 0, 0);
+				btrfs_setxattr(trans, inode, h->xattr_name,
+					       NULL, 0, 0);
 			else
 				set_bit(BTRFS_INODE_HAS_PROPS,
 					&BTRFS_I(inode)->runtime_flags);
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 4c447b1f32e5..623d508f21a6 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -86,6 +86,8 @@ int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
 	size_t name_len = strlen(name);
 	int ret = 0;
 
+	ASSERT(trans);
+
 	if (name_len + size > BTRFS_MAX_XATTR_SIZE(root->fs_info))
 		return -ENOSPC;
 
@@ -437,8 +439,8 @@ static int btrfs_initxattrs(struct inode *inode,
 		}
 		strcpy(name, XATTR_SECURITY_PREFIX);
 		strcpy(name + XATTR_SECURITY_PREFIX_LEN, xattr->name);
-		err = btrfs_setxattr_trans(trans, inode, name, xattr->value,
-					   xattr->value_len, 0);
+		err = btrfs_setxattr(trans, inode, name, xattr->value,
+				     xattr->value_len, 0);
 		kfree(name);
 		if (err < 0)
 			break;
-- 
2.17.1

