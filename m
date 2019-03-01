Return-Path: <SRS0=p7dB=RE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC25C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EE0320851
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pfW6M2yj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbfCAEfP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 23:35:15 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58560 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbfCAEfM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 23:35:12 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x214YD54004540
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=/YsW2Fl3tuHFvRqtschTzuE5cSRKi/+vupTQixenLe8=;
 b=pfW6M2yjPllfk6keWwPtq8ff3h9CRTvxNTWtygGc+duiQo5q9ssU2l4tvJBzVWN3lDTH
 O3jEqyHqFzTFEwNc5VeLawyzdZ4brpQKsg6CSOV9X2oUbA59/sxAp43Z1v8BU+0rZ+2Y
 Y1BFqwEyc53Di+TB4GUes9euxh7ppagD19jCg7D0OE/7eup0QB7t/wCnHefh8qfd840B
 5w4NpH//V0eOAnbyvLMCosDlgKXWpgK78m4xQ1S22g6FXeHTNREGRq0pOQBmkqdW244v
 PYoffMEZQLyD1ZoXQo17Mxcwrfz6KXzDE5aV+phOOlOrpvuBk0ZeBIcdN7QBcu0/5Nyj Nw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2qtupencv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2019 04:35:11 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x214ZABg014705
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:10 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x214ZANG021528
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:10 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Feb 2019 20:35:09 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5 8/9] btrfs: btrfs_setxattr argument trans is never NULL
Date:   Fri,  1 Mar 2019 12:34:54 +0800
Message-Id: <1551414895-22925-9-git-send-email-anand.jain@oracle.com>
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

The following patches
	btrfs: start transaction in btrfs_xattr_handler_set
	btrfs: start transaction in btrfs_set_acl
	btrfs: start transaction in btrfs_set_prop_trans

brought changes so that btrfs_setxattr() argument trans is never NULL, so
delete the part of the code when trans is NULL. Also fix the c-code style.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v5: Fix ASSERT, assert on trans == NULL. Fix change log.
v4: born
 fs/btrfs/xattr.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index e96b0096eaca..2cbde7cac14b 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -220,35 +220,17 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 /*
  * @value: "" makes the attribute to empty, NULL removes it
  */
-int btrfs_setxattr(struct btrfs_trans_handle *trans,
-		     struct inode *inode, const char *name,
-		     const void *value, size_t size, int flags)
+int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
+		   const char *name, const void *value, size_t size, int flags)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	int ret;
+
+	ASSERT(trans);
 
 	if (btrfs_root_readonly(root))
 		return -EROFS;
 
-	if (trans)
-		return do_setxattr(trans, inode, name, value, size, flags);
-
-	trans = btrfs_start_transaction(root, 2);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
-
-	ret = do_setxattr(trans, inode, name, value, size, flags);
-	if (ret)
-		goto out;
-
-	inode_inc_iversion(inode);
-	inode->i_ctime = current_time(inode);
-	set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
-	ret = btrfs_update_inode(trans, root, inode);
-	BUG_ON(ret);
-out:
-	btrfs_end_transaction(trans);
-	return ret;
+	return do_setxattr(trans, inode, name, value, size, flags);
 }
 
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
-- 
1.8.3.1

