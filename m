Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 353DCC10F0B
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 16:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 043E8206DF
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 16:51:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VEIVTB0e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfDCQvx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 12:51:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49754 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfDCQvw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2019 12:51:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x33GhvSh140349;
        Wed, 3 Apr 2019 16:51:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=MbNFh7yIKykfiHky1TcNtM2Ymowh92fAu/saz5+bbJY=;
 b=VEIVTB0eVw0j08UGwATKy+pvuzBtezvVFkVHM5dWFnf1MRNr5UZTG7N9eboNIJaVuXIt
 mUcKTlWHoXoXxcMIedNVyB+hlTqxtfozSyHLGtinNlgTbZto6z5ISHo/uX2TJgDAyeKg
 /BhL7jp93a/tZHQwz6mBboZZoO/o66K+LTuge66PPZY0Y96MGlIob6Yc04Yp9ORomxty
 toEvieI+DBq1ehPWg+H9n42ncURGnz42EUp/u4UZki5vmY+zYjvcZHHuKFMFFgEKTarl
 TUitpe1J4Z1LsaZzTzoeXZg31N93SvGYIPQD9YRifNy8lj2O8zbHaCid3QSdFQLE51tr 5A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2rj13qa6nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 16:51:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x33Gpb4t171968;
        Wed, 3 Apr 2019 16:51:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2rm8f678nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 16:51:48 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x33Gplr1032217;
        Wed, 3 Apr 2019 16:51:47 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Apr 2019 09:51:47 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz
Subject: [PATCH 2/4] btrfs: rename __btrfs_set_acl to do_set_acl
Date:   Thu,  4 Apr 2019 00:51:32 +0800
Message-Id: <20190403165134.12378-3-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190403165134.12378-1-anand.jain@oracle.com>
References: <20190403165134.12378-1-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904030114
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904030114
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

__btrfs_set_acl() is helper function of btrfs_set_acl(), rename it to
do_set_acl(). No functional changes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/acl.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 5810463dc6d2..a22ebb04d9ca 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -52,8 +52,8 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
-static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
-			 struct inode *inode, struct posix_acl *acl, int type)
+static int do_set_acl(struct btrfs_trans_handle *trans, struct inode *inode,
+		      struct posix_acl *acl, int type)
 {
 	int ret, size = 0;
 	const char *name;
@@ -113,7 +113,7 @@ int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		if (ret)
 			return ret;
 	}
-	ret = __btrfs_set_acl(NULL, inode, acl, type);
+	ret = do_set_acl(NULL, inode, acl, type);
 	if (ret)
 		inode->i_mode = old_mode;
 	return ret;
@@ -134,15 +134,13 @@ int btrfs_init_acl(struct btrfs_trans_handle *trans,
 		return ret;
 
 	if (default_acl) {
-		ret = __btrfs_set_acl(trans, inode, default_acl,
-				      ACL_TYPE_DEFAULT);
+		ret = do_set_acl(trans, inode, default_acl, ACL_TYPE_DEFAULT);
 		posix_acl_release(default_acl);
 	}
 
 	if (acl) {
 		if (!ret)
-			ret = __btrfs_set_acl(trans, inode, acl,
-					      ACL_TYPE_ACCESS);
+			ret = do_set_acl(trans, inode, acl, ACL_TYPE_ACCESS);
 		posix_acl_release(acl);
 	}
 
-- 
2.17.1

