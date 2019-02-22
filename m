Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD492C4360F
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FF3E206B6
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pWnMqFXm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfBVRkW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:40:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39976 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfBVRkW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 12:40:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1MHOI1C190081
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=2WTTMzOJWAy/TAxFw8P/4kP+pxRvDby4qsi5JKtF8Jw=;
 b=pWnMqFXmP/66aoRBwXOVy6pkCk3GzcINkKcQ2gaOa9cs6yUN58AOO7kwirj9LXAd1DQb
 QYroFRwhnbzkKMKE3G1K5/+1clHctHbsol/kF6H/uKDlQNWGc8ZmeObAzSN5EFECbfGF
 y/B/VCLTzoSGqYQw2OfDG9t8fhpwpuj/KWcSK+XMBM3f7DcueUhOdWqlkY4Lr8wGvsHe
 5vXXtiisA++Kjc5Xxt9Azn8m/VFkycx/wxeHHm2UqIEENaQ6Ib/5Q8PzG9mVtzqs8KmF
 0huQOM6uf9LBCr9po3Dodbu4INh2HF388ltWuiHvuQmgxORvZuD2ri1XwBQv6qeVzp5p Cg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2qp9xugkxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:20 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHeEPK031320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:14 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1MHeD3Z025790
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:40:14 GMT
Received: from tpasj.localdomain (/157.45.233.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Feb 2019 09:40:13 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 08/10] btrfs: start transaction in btrfs_xattr_handler_set
Date:   Sat, 23 Feb 2019 01:39:50 +0800
Message-Id: <1550857192-10513-9-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9175 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902220122
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Generic extended attributes on the inode are set using
btrfs_xattr_handler_set(), and the required transaction for this update
is started by btrfs_setxattr(). For better granulation of the
transaction start and end, do this in btrfs_xattr_handler_set().

Suggested-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v4: born
 fs/btrfs/xattr.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 69126d5b4d62..8e301a1ae304 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -369,8 +369,29 @@ static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
 				   const char *name, const void *buffer,
 				   size_t size, int flags)
 {
+	int ret;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
 	name = xattr_full_name(handler, name);
-	return btrfs_setxattr(NULL, inode, name, buffer, size, flags);
+
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	ret = btrfs_setxattr(trans, inode, name, buffer, size, flags);
+
+	if (!ret) {
+		inode_inc_iversion(inode);
+		inode->i_ctime = current_time(inode);
+		set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
+		ret = btrfs_update_inode(trans, root, inode);
+		ASSERT(!ret);
+	}
+
+	btrfs_end_transaction(trans);
+
+	return ret;
 }
 
 static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
-- 
1.8.3.1

