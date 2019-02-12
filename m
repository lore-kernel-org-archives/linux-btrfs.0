Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4232C282CE
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 02:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74BFE21B18
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 02:19:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rvfwYDWf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfBLCTO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 21:19:14 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45928 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbfBLCTN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 21:19:13 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1C2JCrU034831
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=K6v6P2pJhCwXAsGYUm7xwHX88Em3wPWM60NwSgxWOcc=;
 b=rvfwYDWfasQHaXa3z8bV7O5NxQHvkqjQDAIrz4Qom4W072SVDYuPAa4tjGflO+N1wO6F
 wcFVoV6wF6fKCPPnttBaw00+TFKYnH3opTE6y4rfjM/jZAVJVLJW17xL+E5q07Y6XNWh
 Lt3svFKrSWcqKrYVK46y5kZLnT61uUg8DkChXIBrxkEXLhrNQE5W1SC7+XSbS9a7Kd62
 YuKN0xfKzi4M9EtIO/nvzU0NbxY7aNJsIYzQabUmbV9hqstORfUhHreywDo5ecuDXmyD
 dKD2h+sxic/uuEZRANR5UgWs+JwLwYrro3V7QsFsJ97D9GR6inyhY5C6MMvfM5wTMnJw tA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qhre598x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:12 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1C2J5sZ006986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:06 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1C2J51P025571
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:05 GMT
Received: from tpasj.localdomain (/183.90.37.91)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Feb 2019 18:19:05 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/3] btrfs: trivial, fix c coding style
Date:   Tue, 12 Feb 2019 10:18:51 +0800
Message-Id: <1549937931-15339-4-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1549937931-15339-1-git-send-email-anand.jain@oracle.com>
References: <1549937931-15339-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902120015
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Maintain the lines extented upto 80 char where possible, and indent the
argument.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
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

