Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD6DC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BB1C206B6
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cBfLG96l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfBVRkU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:40:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39942 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfBVRkT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 12:40:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1MHOH8O190058
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=cQjEdT+kI7Z4txlJ/m7od9NhfLrIax18IPC2fFmQzwc=;
 b=cBfLG96ljEcdHqX24BEmRV5k+haBZ7EPVbZpAChYCn2uCHTJfVbelrjH4cZWfcTnWsuD
 gfPeZSLkjIbrQq3//5ltINO8rGQBnbjfZIN8Au+mUnFpL976f28nGmWRbhR3r3jPRpbQ
 EP0btwClcbgON6ksImJZsD8WHxvdfvGF1Q+4XEowOEwF4QrqQHYYO4vKtoIJiytbzwV+
 I5tHnEC2bJDSfMqkMiHaBuyVwvTU5jaiGoBkIwMrfdEkcovVGr1N2yv+/4GlBgnAj6gU
 sI01hytcz0hHjpoq6dvNcAhAKvJv3vOyCY0aoViLsA1Fve8UfTONt33SzVDurItZjTTS SA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2qp9xugkxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:18 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHeCCt003937
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:12 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1MHeBYw016234
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:11 GMT
Received: from tpasj.localdomain (/157.45.233.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Feb 2019 09:40:11 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 07/10] btrfs: start transaction in btrfs_set_acl
Date:   Sat, 23 Feb 2019 01:39:49 +0800
Message-Id: <1550857192-10513-8-git-send-email-anand.jain@oracle.com>
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

The main motivation is to avoid NULL for the trans argument reaching
btrfs_set_xattr(). This patch does the following in btrfs_set_acl().
  Create transaction and handle the inode changes update.
  Rename __btrfs_set_acl to do_set_acl as this is a helper function.
  Fix a c-code style, expand function declaration to max length 80 char.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v4: born
 fs/btrfs/acl.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 5810463dc6d2..e395615dd304 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -11,10 +11,12 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
+#include <linux/iversion.h>
 
 #include "ctree.h"
 #include "btrfs_inode.h"
 #include "xattr.h"
+#include "transaction.h"
 
 struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 {
@@ -52,8 +54,8 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
-static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
-			 struct inode *inode, struct posix_acl *acl, int type)
+static int do_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
+		      struct posix_acl *acl, int type)
 {
 	int ret, size = 0;
 	const char *name;
@@ -107,20 +109,36 @@ int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	int ret;
 	umode_t old_mode = inode->i_mode;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	if (type == ACL_TYPE_ACCESS && acl) {
 		ret = posix_acl_update_mode(inode, &inode->i_mode, &acl);
 		if (ret)
 			return ret;
 	}
-	ret = __btrfs_set_acl(NULL, inode, acl, type);
-	if (ret)
+
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	ret = do_set_acl(trans, inode, acl, type);
+	if (ret) {
 		inode->i_mode = old_mode;
+	} else {
+		inode_inc_iversion(inode);
+		inode->i_ctime = current_time(inode);
+		set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
+		ret = btrfs_update_inode(trans, root, inode);
+		ASSERT(!ret);
+	}
+
+	btrfs_end_transaction(trans);
 	return ret;
 }
 
-int btrfs_init_acl(struct btrfs_trans_handle *trans,
-		   struct inode *inode, struct inode *dir)
+int btrfs_init_acl(struct btrfs_trans_handle *trans, struct inode *inode,
+		   struct inode *dir)
 {
 	struct posix_acl *default_acl, *acl;
 	int ret = 0;
@@ -134,15 +152,13 @@ int btrfs_init_acl(struct btrfs_trans_handle *trans,
 		return ret;
 
 	if (default_acl) {
-		ret = __btrfs_set_acl(trans, inode, default_acl,
-				      ACL_TYPE_DEFAULT);
+		ret = do_set_acl(trans, inode, default_acl, ACL_TYPE_DEFAULT);
 		posix_acl_release(default_acl);
 	}
 
 	if (acl) {
 		if (!ret)
-			ret = __btrfs_set_acl(trans, inode, acl,
-					      ACL_TYPE_ACCESS);
+			ret = do_set_acl(trans, inode, acl, ACL_TYPE_ACCESS);
 		posix_acl_release(acl);
 	}
 
-- 
1.8.3.1

