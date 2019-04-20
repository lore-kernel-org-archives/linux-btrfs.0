Return-Path: <SRS0=nucE=SW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FE9C282E2
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B50EA2183F
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="avBDp1DJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbfDTLt0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 20 Apr 2019 07:49:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36956 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbfDTLt0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Apr 2019 07:49:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBnPg9043565
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=T0IBMVpu1iTyOfg0BlRwBqmn8w5gTjIxW16FhjJqO7Y=;
 b=avBDp1DJ8ui8qCJbm+r2eEE3tisyeOlwrOX8eGnJ6VcC88JzvHLGYHOszFUQL4kdhCWW
 HdgFHvj1K8q7JOjwEZy04Bt5zV4xwH/gX7f8EFvik/L1IqmUhkRb19ihcmNVbbHzX+KJ
 KHpM1iPhOGRBLnKc/A7B4UXKPa61O4R9/VmHw67oM9+PFEbYwt0wxeT8jc7bxUXD2//R
 2/s8dK3JFphr+JicmHhE5I7KL8yNi06W/c+fzsYX/cX5GOSvTEYfB052vQHsIOLJsvh6
 M3iXG/aKXslSurIEeuoAvsSFOZg5ym+Hb2MjRoaDecch4d5HwzYlDSMPjNtoB8ZKng5K Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2rytusgw54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBmss6155708
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2rytrh3m3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:24 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3KBnOtJ022440
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:24 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 20 Apr 2019 04:49:23 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 10/10] btrfs: btrfs_set_prop trans is never null
Date:   Sat, 20 Apr 2019 19:49:00 +0800
Message-Id: <20190420114900.15472-11-anand.jain@oracle.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190420114900.15472-1-anand.jain@oracle.com>
References: <20190420114900.15472-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=872
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904200090
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=898 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904200090
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since now the trans argument is never null we don't have to check if
its null. So delete it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index c41ed2a6347e..ca2716917e37 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -84,12 +84,8 @@ int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 		return -EINVAL;
 
 	if (value_len == 0) {
-		if (trans)
-			ret = btrfs_setxattr(trans, inode, handler->xattr_name,
-					     NULL, 0, flags);
-		else
-			ret = btrfs_setxattr_trans(inode, handler->xattr_name,
-						   NULL, 0, flags);
+		ret = btrfs_setxattr(trans, inode, handler->xattr_name,
+				     NULL, 0, flags);
 		if (ret)
 			return ret;
 
@@ -99,23 +95,14 @@ int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 		return ret;
 	}
 
-	if (trans)
-		ret = btrfs_setxattr(trans, inode, handler->xattr_name, value,
-				     value_len, flags);
-	else
-		ret = btrfs_setxattr_trans(inode, handler->xattr_name, value,
-					   value_len, flags);
-
+	ret = btrfs_setxattr(trans, inode, handler->xattr_name, value,
+			     value_len, flags);
 	if (ret)
 		return ret;
 	ret = handler->apply(inode, value, value_len);
 	if (ret) {
-		if (trans)
-			btrfs_setxattr(trans, inode, handler->xattr_name, NULL,
-				       0, flags);
-		else
-			btrfs_setxattr_trans(inode, handler->xattr_name, NULL,
-					     0, flags);
+		btrfs_setxattr(trans, inode, handler->xattr_name, NULL,
+			       0, flags);
 		return ret;
 	}
 
-- 
2.20.1 (Apple Git-117)

