Return-Path: <SRS0=p7dB=RE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F347AC43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C00EF20851
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TQJbxx6j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbfCAEfF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 23:35:05 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45162 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727945AbfCAEfF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 23:35:05 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x214Y6sb006550
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=fM2LXO2aGTxuJKNQA/45HZPyPrG4S/vZsYN7TU1bopE=;
 b=TQJbxx6j9ISUjNyIEt0LlgovGnbCm1qmszAQz1bpxhYsFsXyXEf54TdVqNBRzN08TaPq
 V4ytZ7JfnKHS52J420BmpwiiGyGCaUAswmOpqmyxV12bjVoFCwtouFVAG2KAI+qlvxny
 bHDiAD2TxUd1YOSh6jNUzxlF884N73wHltOpRY9caYbOQxcGCYLrAbNX4oA8+tvrHfgY
 GEFX/lUcgcJEDyZaxnx1gaG137KIlQAYLqCCeJ/aYuIU8symYVEPmuauLKySbrHhbJso
 y470yQHOrtQEcP9PVwzKgkIHjrmBEJNCF/Mv5drL04TgEhiWFFXdssp7HeogPEsiMHNH hg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qtxts53py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2019 04:35:04 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x214Z2d5014213
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:03 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x214Z2IA023512
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:02 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Feb 2019 20:35:02 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5 3/9] btrfs: rename fs_info argument to fs_private
Date:   Fri,  1 Mar 2019 12:34:49 +0800
Message-Id: <1551414895-22925-4-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
References: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9181 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=814 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903010029
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

fs_info is commonly used to represent struct fs_info *, rename
to fs_private to avoid confusion.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
---
v5: none
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

