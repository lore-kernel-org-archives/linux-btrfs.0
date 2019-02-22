Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82613C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53B5A206B6
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0wTb91SQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfBVRkN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:40:13 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50044 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfBVRkM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 12:40:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1MHOI8U195049
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=CcVZZCg/W9b4VDK9VYaxwoCdQAyFhjUWMYDZg9MWjRY=;
 b=0wTb91SQHdEwwar6MSWrrKdZ3L5VinnPEgJjbu0LDnOUysoNMSXUuo0BG1HwuT0F1uJh
 aJFyOC9OBo372tdlUS9Y/OkFrq/x01HtiooKFiWfYeXjskOOtZNywqTZsDJXETeLoke+
 5wVGRZPEYqTB67YA1vUF7xeOyU8D4mS47iX9XvG2qXuNFT6iVLbhP9XLfp4G76eQN3F5
 0JDXUcb3+p2Fn51SoH8bPXb1Mul5rfsuquvhk+6kxBYEAmLJEyvLdopYsdvBZn1QxXvP
 +n/iDJFsRh/R3UXUZBI+KHyVc8x4IBrMsgfhJnsZ+Kz+5n8c4a5ty6tIXD/U/jmUIgdw 5w== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2qpb5s0g3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:11 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHe56S003301
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:05 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1MHe5br025703
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:05 GMT
Received: from tpasj.localdomain (/157.45.233.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Feb 2019 09:40:05 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 04/10] btrfs: rename fs_info argument to fs_private
Date:   Sat, 23 Feb 2019 01:39:46 +0800
Message-Id: <1550857192-10513-5-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9175 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=761 adultscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902220122
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

fs_info is commonly used to represent struct fs_info *, rename
to fs_private to avoid confusion.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v4: born
 fs/btrfs/xattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 499bb79ba135..6971cbf286b5 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -419,10 +419,10 @@ static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
 };
 
 static int btrfs_initxattrs(struct inode *inode,
-			    const struct xattr *xattr_array, void *fs_info)
+			    const struct xattr *xattr_array, void *fs_private)
 {
+	struct btrfs_trans_handle *trans = fs_private;
 	const struct xattr *xattr;
-	struct btrfs_trans_handle *trans = fs_info;
 	unsigned int nofs_flag;
 	char *name;
 	int err = 0;
-- 
1.8.3.1

