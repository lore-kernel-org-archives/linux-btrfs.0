Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63305C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 05:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F112217F5
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 05:05:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qny5trn6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfCNFFC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 01:05:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51442 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbfCNFFB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 01:05:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2E54U5Q068367
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=akZy7fnknabQYhFr0G3A8HiVtFSzy2zRO7P4FCRMct4=;
 b=Qny5trn6FodzB0yQ7OJ6PIo9jcQuQI+zEiVoOd8Ab6gEi0QhknrZNq3CJmaisQgwaMuq
 04q5wHOqX1Z6lckoU+hT1+B6F82RiWRv2Y2E/7lhTt6pfzsaDwq5SOpRCZR1JELFhjIf
 9ag4RRpSJWpEgMqqS579XQMjjWOeFVGqNxMJ7Jllx3AFZNXIePsFPA+Xgb1ZjQ3p1aSF
 YF9Zb4WmE9M27gUq1WOr8zardtuneZxqA0ub80Lk5H9JNkBKmR+7glOZySHZR6vuajho
 xAw7d6/N9dlX9a7d9y2rKLiR292FXCCTZ+fab7mc1naAUWSKTfGzaxBgnM9u6cfG7qh9 /A== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2r44wuesnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:59 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2E54xdq005170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:59 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2E54xUK016566
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:59 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Mar 2019 05:04:58 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs: open code btrfs_set_prop in inherit_prop
Date:   Thu, 14 Mar 2019 13:05:05 +0800
Message-Id: <1552539906-29703-4-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1552539906-29703-1-git-send-email-anand.jain@oracle.com>
References: <1552539906-29703-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9194 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=952 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903140033
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When an inode inherits property from its parent, we call btrfs_set_prop().
btrfs_set_prop() does an elaborate checks, which is not required in the
context of inheriting a property. Instead just open-code only the required
items from btrfs_set_prop() and then call btrfs_setxattr() directly. So
now the only user of btrfs_set_prop() is gone, (except for the wraper
function btrfs_set_prop_trans()).

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 72a06c4d3c70..fb84e76f3b1d 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -367,20 +367,35 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 		if (!value)
 			continue;
 
+		/* may be removed */
+		ret = h->validate(value, strlen(value));
+		if (ret)
+			continue;
+
 		num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
 		ret = btrfs_block_rsv_add(root, trans->block_rsv,
 					  num_bytes, BTRFS_RESERVE_NO_FLUSH);
 		if (ret)
-			goto out;
-		ret = btrfs_set_prop(trans, inode, h->xattr_name, value,
+			return ret;
+
+		ret = btrfs_setxattr(trans, inode, h->xattr_name, value,
 				     strlen(value), 0);
+		if (!ret) {
+			ret = h->apply(inode, value, strlen(value));
+			if (ret)
+				btrfs_setxattr(trans, inode, h->xattr_name,
+					       NULL, 0, 0);
+			else
+				set_bit(BTRFS_INODE_HAS_PROPS,
+					&BTRFS_I(inode)->runtime_flags);
+		}
+
 		btrfs_block_rsv_release(fs_info, trans->block_rsv, num_bytes);
 		if (ret)
-			goto out;
+			return ret;
 	}
-	ret = 0;
-out:
-	return ret;
+
+	return 0;
 }
 
 int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
-- 
1.8.3.1

