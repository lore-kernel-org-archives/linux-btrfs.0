Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7746C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 956A8206B6
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ixzbw7vk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfBVRkM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:40:12 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56776 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfBVRkL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 12:40:11 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1MHOOr5194503
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=WlGi6WikB48N8Igw4JwqMm9qkZlKZrGg6aUvKvEE6vA=;
 b=Ixzbw7vkqYuU9pc/twgnxKzkQyKc/6PI/KCnj17FbdpQYutldM1QKTZvt95fDbtfu4s6
 AStBwPeaSj7ymzvAauUC21P4SVesjZ9ko5GhkMdBVrwUVoaGTxVl1uqxCjtXLRSdY2Xj
 ouOn9jA5I4DrYp2ESKWQcuhXgK4ca+zzdepbMOjCFh4Qxt4HdyVHVnVZ6U4pZ8hXwZEa
 cJ2sTouASyG8hvIZewd089OABngl3vCsYGYq7krZYSPlcm9q1bXREy1RQy1wrCjfO4Oo
 WKml/5bDldklesqbZoSgm5qNvCSMxGE7G7i55a+xhdJsPtlbEtzl6raBxFnMf5VuWonf cg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2qp81err31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:10 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHe4oU029729
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:04 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHe42x019604
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:04 GMT
Received: from tpasj.localdomain (/157.45.233.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Feb 2019 09:40:03 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 03/10] btrfs: trivial, fix c coding style
Date:   Sat, 23 Feb 2019 01:39:45 +0800
Message-Id: <1550857192-10513-4-git-send-email-anand.jain@oracle.com>
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

Maintain the lines extented upto 80 char where possible, and indent the
argument.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
v4: none.
v3: changelog added.
 fs/btrfs/props.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 77a03076b18e..3c15f19bfd2f 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -70,8 +70,8 @@ int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 		return -EINVAL;
 
 	if (value_len == 0) {
-		ret = btrfs_setxattr(trans, inode, handler->xattr_name,
-				       NULL, 0, flags);
+		ret = btrfs_setxattr(trans, inode, handler->xattr_name, NULL, 0,
+				     flags);
 		if (ret)
 			return ret;
 
@@ -101,12 +101,10 @@ int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 }
 
 static int iterate_object_props(struct btrfs_root *root,
-				struct btrfs_path *path,
-				u64 objectid,
+				struct btrfs_path *path, u64 objectid,
 				void (*iterator)(void *,
 						 const struct prop_handler *,
-						 const char *,
-						 size_t),
+						 const char *, size_t),
 				void *ctx)
 {
 	int ret;
@@ -211,10 +209,8 @@ static int iterate_object_props(struct btrfs_root *root,
 	return ret;
 }
 
-static void inode_prop_iterator(void *ctx,
-				const struct prop_handler *handler,
-				const char *value,
-				size_t len)
+static void inode_prop_iterator(void *ctx, const struct prop_handler *handler,
+				const char *value, size_t len)
 {
 	struct inode *inode = ctx;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-- 
1.8.3.1

