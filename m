Return-Path: <SRS0=nucE=SW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E06E0C282E3
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFAD82183F
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hrZaLVjO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfDTLtX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 20 Apr 2019 07:49:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36916 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728213AbfDTLtX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Apr 2019 07:49:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBn5q9043489
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=6jaHeKABB2OTAO1dOZRx/yIc0VoNbfFbXqcj0NC+7p8=;
 b=hrZaLVjOlB1s1Ka7Dsm8mIC/BuHj8RfReSN9emY8waajCbCVeM7No+wH+eGq27pdhCAk
 QAP9nhYLZZvi7Xa6eYqqv+ezjxFOQ5okTCbmzua5aZOEe8+F98uRE28sQGiwErB9J8eG
 O4qNldZYvPKi+VaimFXzMRAhwpq9CIwY0q5ngBTrYJZjUzlyDLqvawLH3dKAiHhRcr2S
 6ccyjybmg9bWtza8iqoaNRGA+NorVAUHCaS81VaXcfcnT2K7DMInkpT6nEvgujyepEmd
 MyygIKIYzRVNiQ9sHMuFRnMDwLKLho0idYBRcg7onR8atA6efkokFPf1rcn7qXQig4dK 8Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2rytusgw51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBn8Sh002572
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ryrhqxf5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:21 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3KBnLd0016636
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:21 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 20 Apr 2019 04:49:20 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 08/10] btrfs: start transaction in xattr_handler_set_prop
Date:   Sat, 20 Apr 2019 19:48:58 +0800
Message-Id: <20190420114900.15472-9-anand.jain@oracle.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190420114900.15472-1-anand.jain@oracle.com>
References: <20190420114900.15472-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=944
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904200090
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=970 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904200090
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs specific extended attributes on the inode are set using
btrfs_xattr_handler_set_prop(), and the required transaction for this
update is started by btrfs_setxattr(). For better visibility of the
transaction start and end, do this in btrfs_xattr_handler_set_prop().
For which this patch copied code of btrfs_setxattr() as it is in the
original, which needs proper error handling.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/xattr.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 807cc24dc885..46ad7b5cf209 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -374,12 +374,31 @@ static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
 					size_t size, int flags)
 {
 	int ret;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	name = xattr_full_name(handler, name);
 	ret = btrfs_validate_prop(name, value, size);
 	if (ret)
 		return ret;
-	return btrfs_set_prop_trans(inode, name, value, size, flags);
+
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	ret = btrfs_set_prop(trans, inode, name, value, size, flags);
+	if (!ret) {
+		inode_inc_iversion(inode);
+		inode->i_ctime = current_time(inode);
+		set_bit(BTRFS_INODE_COPY_EVERYTHING,
+			&BTRFS_I(inode)->runtime_flags);
+		ret = btrfs_update_inode(trans, root, inode);
+		BUG_ON(ret);
+	}
+
+	btrfs_end_transaction(trans);
+
+	return ret;
 }
 
 static const struct xattr_handler btrfs_security_xattr_handler = {
-- 
2.20.1 (Apple Git-117)

