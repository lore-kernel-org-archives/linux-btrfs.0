Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9522C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 08:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A17C205ED
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 08:03:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="y51bd/of"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfDLIDO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 04:03:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60270 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbfDLIDN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 04:03:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C7sKD7084819
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=qCb2PJpp3rUAIISRHuN/flKtwN8Pn9sizG1uY4AUkZE=;
 b=y51bd/of8igPBJpU5sCEksdKhvM4S3PkhWivn9JIiMnaYyFYmcNwIHhMEDx91g30J4vj
 gCxGSPStUHagVwZkjV5JqbBbeVygh3NQHLhkrc7KDsGxp9YmN0ND+5sYhSm5COmTIUy/
 yvySbKHkwzxGgpgEDEmj5t9y8KrSPFx8EnEgqzY1bQRSHMeHBWzBa1//Nen6tbffEMpi
 A+JD78sGu1ANGt7CqDrUfazS6saKqJVRFbteIGDCqNnLBJvw1l+Lzfm674IX0kN6Xh4+
 GKYX/d9qarB9Wc9EIr9bq+jzJp+EWaS5mU9m0WuKWbi4fYhkp4KptMFRzNyA1Y6Hwex/ AA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2rpmrqmy72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C831Jx099251
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2rtd84dv5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:11 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3C83B95023239
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:11 GMT
Received: from tp.wifi.oracle.com (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Apr 2019 01:03:10 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: rename do_setxattr to btrfs_setxattr
Date:   Fri, 12 Apr 2019 16:02:55 +0800
Message-Id: <20190412080259.5192-3-anand.jain@oracle.com>
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

When trans is not NULL btrfs_setxattr() calls do_setxattr()  directly
with a check for readonly root. Rename do_setxattr() btrfs_setxattr() in
preparation to call do_setxattr() directly instead.
Preparatory patch, no functional changes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/xattr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 38eb78aac0a7..fd1469ef55d6 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -76,9 +76,9 @@ int btrfs_getxattr(struct inode *inode, const char *name,
 	return ret;
 }
 
-static int do_setxattr(struct btrfs_trans_handle *trans,
-		       struct inode *inode, const char *name,
-		       const void *value, size_t size, int flags)
+static int btrfs_setxattr(struct btrfs_trans_handle *trans,
+			  struct inode *inode, const char *name,
+			  const void *value, size_t size, int flags)
 {
 	struct btrfs_dir_item *di = NULL;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -231,13 +231,13 @@ int btrfs_setxattr_trans(struct btrfs_trans_handle *trans,
 		return -EROFS;
 
 	if (trans)
-		return do_setxattr(trans, inode, name, value, size, flags);
+		return btrfs_setxattr(trans, inode, name, value, size, flags);
 
 	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	ret = do_setxattr(trans, inode, name, value, size, flags);
+	ret = btrfs_setxattr(trans, inode, name, value, size, flags);
 	if (ret)
 		goto out;
 
-- 
2.17.1

