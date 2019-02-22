Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498B1C10F00
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18E5F206B6
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n448UWLV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfBVRkT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:40:19 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56872 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbfBVRkS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 12:40:18 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1MHOKH8194475
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=hZXPEtCYPz9ulVauqM1uiuUtqA2xKaeVIRMONm6HsZc=;
 b=n448UWLV+DOrmrc9OP4vXe5jLykKIWEsYmGak9GPFkrDmtCjlCbA438or/kIgjWBWq8J
 TCz0UoqZJEtDyT373RNMc313L4V4UZpRt2SjSX572CBXnW3mBdUo4qmbJS4mo+NWxPt5
 pOv/4CPURhY9dFNbrrYBa3sZYd9oNQkBpaRruUdyO7qoGrIl8myQq+0kDWdyzli8jsuO
 w/JCvT9C8anUExw+qRnb0V45L1v95Rt6OsjJWtl7RD5IS+d1w4V8vTUp9dyuYjv3wnBQ
 2iIJYN1OhuU7sqmRCo7I90cv41TysiYBfOfATQv/DJnYPSEwh370s3+RUQ81jz5Ac8uQ PA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qp81err3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:16 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHeAis003702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:10 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHeAoQ019661
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:10 GMT
Received: from tpasj.localdomain (/157.45.233.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Feb 2019 09:40:09 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 06/10] btrfs: start transaction in btrfs_set_prop_trans
Date:   Sat, 23 Feb 2019 01:39:48 +0800
Message-Id: <1550857192-10513-7-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9175 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=995 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902220122
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In preparation to make trans argument of btrfs_setxattr() a mandatory,
start the transaction in btrfs_set_prop_trans.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v4: born
 fs/btrfs/props.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index e581da1bfbb6..f878ba3160f0 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/hashtable.h>
+#include <linux/iversion.h>
 #include "props.h"
 #include "btrfs_inode.h"
 #include "transaction.h"
@@ -103,7 +104,25 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 int btrfs_set_prop_trans(struct inode *inode, const char *name,
 			   const char *value, size_t value_len, int flags)
 {
-	return btrfs_set_prop(NULL, inode, name, value, value_len, flags);
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	ret = btrfs_set_prop(trans, inode, name, value, value_len, flags);
+
+	if (!ret) {
+		inode_inc_iversion(inode);
+		inode->i_ctime = current_time(inode);
+		set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
+		ret = btrfs_update_inode(trans, root, inode);
+		ASSERT(!ret);
+	}
+	btrfs_end_transaction(trans);
+	return ret;
 }
 
 static int iterate_object_props(struct btrfs_root *root,
-- 
1.8.3.1

