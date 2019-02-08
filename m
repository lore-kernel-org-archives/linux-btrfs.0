Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6698C282DA
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8379121917
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:02:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uaVSbaQF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfBHHC4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:02:56 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54390 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbfBHHCz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2019 02:02:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x186xU2O163491
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=BOU1fH8FcehEgYL3YY7QxfKwH3DidODfjqJTE2s6gUc=;
 b=uaVSbaQFCr5Du+a9r//P2la8Mn0yx1+jGznu0Tho2tC7nOORttkLWv+WrouKX9X/tAHt
 m1NocRp5F+OrRGA5Q92L7I+7TdOBuLEE7Y5YbXhjdgzxnOadvcOBpCKnfhdz4CDazRpn
 VFHec8ifW5kE92OQ6CZ6g1C9kNqoOMiG3KSgTKSJKvX0s/En51yJSKYODts9ayrLJrp9
 YDR6QC71MRJGMcSbnuOl9zuzgZVGnjgv8sgMLHeWZyKrkiOR+iLzbRePtxX/++r9b7zy
 NkbrKqX6+MXppk9eXqfowARc52OkTwwNDAEwdqZT+x4OWpnyq1fkcnt+NbhL2kJl7M1F RQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2qd98njy59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2019 07:02:53 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1872rbP029437
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:53 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1872qfV023074
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:53 GMT
Received: from tpasj.sg.oracle.com (/10.186.49.135)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Feb 2019 23:02:52 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 5/5] btrfs: trivial, fix c coding style
Date:   Fri,  8 Feb 2019 15:02:35 +0800
Message-Id: <1549609355-11053-6-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1549609355-11053-1-git-send-email-anand.jain@oracle.com>
References: <1549609355-11053-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9160 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=922 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902080051
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
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

