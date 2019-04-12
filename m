Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED0EC10F14
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 08:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BF0D2171F
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 08:03:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qBoBGzfH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfDLIDS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 04:03:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60308 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbfDLIDQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 04:03:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C7s1Cr084742
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=gLpHSiWplZJryWcSuLimwCd5a2ldmftYZC7VXIuwqX4=;
 b=qBoBGzfHBx5QId1+cgEPPM1MMLQxNTu+VetkhGUGgMtkUl3xuBhIliafs7j7c8NNXbnf
 aB+YYppZs+pSzmu8eXUnJC1LvOsziqkmQfqoUl2Z5i9p4tEcYuhqejwb4W8+WpoIJ07I
 hL+DSIB+cObBuPyUnIeeINYab4yRTiMAztCpn/Y5PFQPvt9Joj1wr+7WhO55mGQmktBV
 0lAEe3+8nhMbFKIfKh4XlYUpeunvyEst5ga0q8DQcE4GbnkgmndSVwzBm6xLALmszJZM
 K3h3eAvCU1Ozatinb+N7R6eAqKu+ATlSBmtTBr9DZ/Cv7sgcCHGroPfnx/3S5Ab0KpKb oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2rpmrqmy79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C830qE169317
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2rpytd6fd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:14 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3C83Eqj009074
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:14 GMT
Received: from tp.wifi.oracle.com (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Apr 2019 01:03:14 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs: remove redundant readonly root check in btrfs_setxattr_trans
Date:   Fri, 12 Apr 2019 16:02:57 +0800
Message-Id: <20190412080259.5192-5-anand.jain@oracle.com>
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

btrfs_setxattr_trans() is called by 5 threads as below and all of them are
write based threads, which won't run for a readonly root. So its ok to
remove the readonly root check here.

1.
__btrfs_set_acl()
btrfs_init_acl()
btrfs_init_inode_security()

2.
__btrfs_set_acl()
btrfs_set_acl()

3.
btrfs_set_prop()
btrfs_set_prop_trans()
  /                   \
btrfs_ioctl_setflags()   btrfs_xattr_handler_set_prop()

4.
btrfs_xattr_handler_set()

5.
btrfs_initxattrs()
btrfs_xattr_security_init()
btrfs_init_inode_security()

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/xattr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index b2b68676ec52..4c447b1f32e5 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -226,9 +226,6 @@ int btrfs_setxattr_trans(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
-	if (btrfs_root_readonly(root))
-		return -EROFS;
-
 	if (trans)
 		return btrfs_setxattr(trans, inode, name, value, size, flags);
 
-- 
2.17.1

