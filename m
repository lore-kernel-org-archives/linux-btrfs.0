Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93499C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 10:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6027320856
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 10:08:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yuT1NQD2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbfDBKIG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 06:08:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45968 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728710AbfDBKIF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 06:08:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x329hUVD123790
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:08:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=akZy7fnknabQYhFr0G3A8HiVtFSzy2zRO7P4FCRMct4=;
 b=yuT1NQD2EcuLqPuGJabzw9yOVhyQUrl1uu+l+VzmLHKSpo2wORk9WeTCtLVHBvei7TdD
 v6SJqbIIOLEIvDE4dIDoBrocmLSqz8XOBiMRBGw+lvVdZjrIIhvmCXs5OsYDX6pHcRO1
 3WaiVPjN5Co1Og5BIzbM3chv/KaOEkq38wd4P1ZpYJKfiGn54rqqXaXgV320PmQvRhmT
 x4/uYnMbY47cYHmoPoRfGvAExS0dVpn9Ur6Eak3GH8F6lt8xfunJv5GCQ+TrKRoz9KI2
 OIx7QxPXKP4jYjLgcNTdeFPCRgFuRN6/MTB03CDgh51wR177Plc34/ak5zFPch7eSn9h 6w== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2rj13q43r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2019 10:08:04 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x32A84hO012357
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:08:04 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x32A831P001691
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:08:04 GMT
Received: from tp.wifi.oracle.com (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Apr 2019 03:08:03 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4 RESEND] btrfs: open code btrfs_set_prop in inherit_prop
Date:   Tue,  2 Apr 2019 18:07:41 +0800
Message-Id: <20190402100742.8355-5-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190402100742.8355-1-anand.jain@oracle.com>
References: <20190402100742.8355-1-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9214 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=993 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904020070
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

