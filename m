Return-Path: <SRS0=p7dB=RE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F0CC10F03
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17AAE2186A
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fhsoMu1D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbfCAEfJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 23:35:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41570 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbfCAEfI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 23:35:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x214Z6UF007290
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=+x6vaA1D+Ser6HxNKrCOkxoXVr8cuhi8x7EcybGTxMI=;
 b=fhsoMu1DajH1JP1qI+sVBXKCXQ4yTwpQDUehyF8txSQCO+u0DgixmfhLMbFcRYAaFisY
 h4F4GZwqhrRUbgj7anmQWD4+TJKoDHl7LDTKy4/A1R3zoSxEnURD+BGk2Z2VRA/qvuVZ
 b9pOJQnCf17F0YW88Yu7xlEXvwGkhX3HPTZKWNQ66fmILnA6F2f0hHyKb3jYmlZts3oK
 j1MTUGttP3xzfPb4OuJUCTXUc1B1fBCu5NmzGPKxzZwOiSSDXmEghtatwdrcgayKUOkv
 iDO0anH9pnDJTokPA32aeDWKgHV4f+G3FgyPsxu40JheMJv9xOQ/hgKxTArEw7jgWTKB dw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2qtwkun8bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2019 04:35:06 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x214Z5v6007176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:05 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x214Z5C4005525
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:05 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Feb 2019 20:35:05 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5 5/9] btrfs: start transaction in btrfs_set_prop_trans
Date:   Fri,  1 Mar 2019 12:34:51 +0800
Message-Id: <1551414895-22925-6-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
References: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9181 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903010029
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In preparation to make trans argument of btrfs_setxattr() a mandatory,
start the transaction in btrfs_set_prop_trans(). And pass the started
transaction to btrfs_set_prop() instead of NULL. This patch copies the
inode update part from btrfs_setxattr() to btrfs_set_prop_trans(),
as it is from the original code.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v5: fix c-style. Used BUG_ON, instead of ASSERT. Change log update.
v4: born
 fs/btrfs/props.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index ca4af745fb90..75a68d7d39a2 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/hashtable.h>
+#include <linux/iversion.h>
 #include "props.h"
 #include "btrfs_inode.h"
 #include "transaction.h"
@@ -103,7 +104,26 @@ static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
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
+		set_bit(BTRFS_INODE_COPY_EVERYTHING,
+			&BTRFS_I(inode)->runtime_flags);
+		ret = btrfs_update_inode(trans, root, inode);
+		BUG_ON(ret);
+	}
+	btrfs_end_transaction(trans);
+	return ret;
 }
 
 static int iterate_object_props(struct btrfs_root *root,
-- 
1.8.3.1

