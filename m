Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF67C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BCB3206B6
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="il6TElQW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfBVRkS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:40:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39902 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfBVRkR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 12:40:17 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1MHOHCI190044
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=JbaYLvdXahJvA3AfJosLqCH+3S9uz9QGv+iY2FDsDTo=;
 b=il6TElQWWrsWS2KyYM1Z61vmvP3dyCo9IuKfX81FRSi5sPDmEwatlsXzLUe+lvrvAzKN
 Y0WdxW2g0zMs+B24lPJ2m2+dryHKSJsDYvqiDmzRbj+oD15y3Pdf6W2tckmN913kSpRo
 uvVrIhBBHVZ7azGWZle7ES4/EHla3SpQlX/vkfxqmonaZwCdWqPmPKwEboIdzjd44LJJ
 nHuWUKuDAepvnZKuvHRHu2cJtgKGG2BsAh/Pn4ztGJBxM3OGVCbafjWPuzARzapgVf8J
 zh6hQsKKw8tqT6PAALVRWgtCbBn6HYrB53DNVMbyiWF4OjgiULApTR3EG0xHkN6qUI+l Bg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2qp9xugkx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:16 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHeFDL001484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:15 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHeFec019717
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:15 GMT
Received: from tpasj.localdomain (/157.45.233.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Feb 2019 09:40:15 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 09/10] btrfs: btrfs_setxattr argument trans is never NULL
Date:   Sat, 23 Feb 2019 01:39:51 +0800
Message-Id: <1550857192-10513-10-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9175 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902220122
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The following patches
   btrfs: cleanup btrfs_set_acl
   btrfs: start transaction in btrfs_xattr_handler_set
   btrfs: create transaction in btrfs_set_prop_notrans

made the btrfs_setxattr() argument trans to be never NULL, so delete the
code when trans is NULL in btrfs_setxattr(). Also fix the c-code style.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v4: born
 fs/btrfs/xattr.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 8e301a1ae304..b3281d4d95b9 100644
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
+	ASSERT(!trans);
 
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

