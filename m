Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332BBC10F14
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 08:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 013EE2171F
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 08:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ny94MsRj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfDLIDQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 04:03:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60286 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbfDLIDP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 04:03:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C7s1Km084739
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=5hEnEJNSpvNb2VT0bgeJ7XZiDVws4/zArj8kCwtuQUo=;
 b=Ny94MsRjaTCwqVKJU+gpAYFNYNVbQV9BeTxyRpL69+fvDgpsIlKkv7bxUo/ecyA4fyBe
 ksRv2zuZFfz4Arzy5BKZUtQfuhijOBIjKCv6fbaRZwxE3DgGiPL2NPrgQ+3XoMacYbX8
 My2cE8R8zfrV7S8svei5JwoQPU8thb5omOi/Cjb/4feGat5bxl/SqWyLeTHDmKY+zDTK
 dylWANL6/DovLpXzmK38P0wvVaq6fMNLBMpECYSnCI9xEAaYqfKMVK1+oSUvHbEJbiv1
 TGqtEm/NusA26RbcSm/AJFFOj5jE7nWM7r/UlGpIFaFrwVD8yGEDay3Ncx8U1MxIVcv8 BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2rpmrqmy76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C830PS054472
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2rph7u5asx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:13 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3C83CSJ032082
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:13 GMT
Received: from tp.wifi.oracle.com (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Apr 2019 01:03:12 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] btrfs: declare btrfs_setxattr as a non static function
Date:   Fri, 12 Apr 2019 16:02:56 +0800
Message-Id: <20190412080259.5192-4-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190412080259.5192-1-anand.jain@oracle.com>
References: <20190412080259.5192-1-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=956
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904120055
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=978 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904120054
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Preparatory patch, as we are going split the threads with transaction and
threads without transaction to use the respective btrfs_setxattr() and
btrfs_setxattr_trans() functions. Declare btrfs_setxattr() as non static
function.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/xattr.c | 5 ++---
 fs/btrfs/xattr.h | 2 ++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index fd1469ef55d6..b2b68676ec52 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -76,9 +76,8 @@ int btrfs_getxattr(struct inode *inode, const char *name,
 	return ret;
 }
 
-static int btrfs_setxattr(struct btrfs_trans_handle *trans,
-			  struct inode *inode, const char *name,
-			  const void *value, size_t size, int flags)
+int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
+		   const char *name, const void *value, size_t size, int flags)
 {
 	struct btrfs_dir_item *di = NULL;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
diff --git a/fs/btrfs/xattr.h b/fs/btrfs/xattr.h
index 36d54a15cbfe..a95834cc3c04 100644
--- a/fs/btrfs/xattr.h
+++ b/fs/btrfs/xattr.h
@@ -12,6 +12,8 @@ extern const struct xattr_handler *btrfs_xattr_handlers[];
 
 int btrfs_getxattr(struct inode *inode, const char *name,
 		void *buffer, size_t size);
+int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
+		   const char *name, const void *value, size_t size, int flags);
 int btrfs_setxattr_trans(struct btrfs_trans_handle *trans,
 			    struct inode *inode, const char *name,
 			    const void *value, size_t size, int flags);
-- 
2.17.1

