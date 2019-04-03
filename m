Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66BEAC4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 16:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17AE3206DF
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 16:51:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E128W4sj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfDCQvv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 12:51:51 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44498 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfDCQvv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2019 12:51:51 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x33Ghj9E136420;
        Wed, 3 Apr 2019 16:51:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=m3SpdUHiHrksRK+VGXqoejRKa73cuwT9GAx8JhauHYE=;
 b=E128W4sjkvkWKhmBbqyuz/Nw5OESRvLt1vdvdEOg2+wVNuZ1mSfD6ewhkKY1O7TCcl8d
 zmeMZXoBrJYSxGKt//pbGNF6oHABmbHFR0JbJlQ9gKxTgLgl/TDk720dpyeU3jYp3b8T
 zLJU9Zu6OCFlxlzGhbEJHxwHGNPBLfpyUc7qPWaAJjh4Dg9mJBRft3hOlW09HJ1yP6N/
 JSDIDdNXDUx14D/hpIjpgIYVeVtRtrptUzP4EU0kdAem8Rqe5mNKgQ3bMBeXpIz6RDGw
 xPxOEDWRBHM6WTvAT/eSTY3MfO7I9o8IUz0QCe5sD3nD36nWBy8CeSLlBHJ+DP9bHXBh yQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2rhwydaeya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 16:51:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x33GpMH1040385;
        Wed, 3 Apr 2019 16:51:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2rm9mj5tbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 16:51:47 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x33Gpjpc003807;
        Wed, 3 Apr 2019 16:51:46 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Apr 2019 09:51:45 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz
Subject: [PATCH 1/4] btrfs: rename __btrfs_set_prop to btrfs_set_prop_trans
Date:   Thu,  4 Apr 2019 00:51:31 +0800
Message-Id: <20190403165134.12378-2-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190403165134.12378-1-anand.jain@oracle.com>
References: <20190403165134.12378-1-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904030114
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904030114
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

__btrfs_set_prop() accepts trans an argument, which when NULL,
the trans is created further down at btrfs_setxattr().
So btrfs_set_prop() is a redirect to __btrfs_set_prop() with the
transaction handle equal to NULL. No functional changes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 7466ffd33ba6..0939554ffa63 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -55,12 +55,9 @@ find_prop_handler(const char *name,
 	return NULL;
 }
 
-static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
-			    struct inode *inode,
-			    const char *name,
-			    const char *value,
-			    size_t value_len,
-			    int flags)
+static int btrfs_set_prop_trans(struct btrfs_trans_handle *trans,
+				struct inode *inode, const char *name,
+				const char *value, size_t value_len, int flags)
 {
 	const struct prop_handler *handler;
 	int ret;
@@ -109,7 +106,7 @@ int btrfs_set_prop(struct inode *inode,
 		   size_t value_len,
 		   int flags)
 {
-	return __btrfs_set_prop(NULL, inode, name, value, value_len, flags);
+	return btrfs_set_prop_trans(NULL, inode, name, value, value_len, flags);
 }
 
 static int iterate_object_props(struct btrfs_root *root,
@@ -355,8 +352,8 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 					  num_bytes, BTRFS_RESERVE_NO_FLUSH);
 		if (ret)
 			goto out;
-		ret = __btrfs_set_prop(trans, inode, h->xattr_name,
-				       value, strlen(value), 0);
+		ret = btrfs_set_prop_trans(trans, inode, h->xattr_name, value,
+					   strlen(value), 0);
 		btrfs_block_rsv_release(fs_info, trans->block_rsv, num_bytes);
 		if (ret)
 			goto out;
-- 
2.17.1

