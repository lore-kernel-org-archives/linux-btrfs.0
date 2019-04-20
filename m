Return-Path: <SRS0=nucE=SW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769D5C282DD
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44B752183F
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BDaOsqeO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbfDTLtZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 20 Apr 2019 07:49:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36938 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728213AbfDTLtY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Apr 2019 07:49:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBnOA3043562
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=yKkcdIjn8mR2rWrTsassj29uu6bmPvkpkrLjvdE1EsU=;
 b=BDaOsqeOIHIYhe0Ei1kAZl7IG2axfntPy+Eh1wge1UT8rjX5b6PerPNk64TZ9L+PDmOQ
 Gr9hi2e51WutyEhodo7X+Ac5wm4BY31dSYOn6261PUB+XKE3zkGrbc7ml5m9bnNcYZOp
 nNK+doqa+bj8puKoOX/8TOlb5X4MNXgAq8oXpYeB6VxdvDNjw/h1FwtCXWi18rMuQ1h4
 k+DNff0Wr9ttuEn8wCEbsD8OTnDVE5BQH4k03JJ73cn7qO/4No9mKjS+ay4XDfcxvi7/
 4wDZNlHzo70A6lJKAxVLGgk4Oro6Qw7+CKpSM5B9+QcH54YCYoJnBP5oyB5XTD3kKEIR Dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2rytusgw53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBmNZE036947
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ryu803axr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:23 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3KBnMJC005705
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:22 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 20 Apr 2019 04:49:22 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 09/10] btrfs: delete unused function btrfs_set_prop_trans
Date:   Sat, 20 Apr 2019 19:48:59 +0800
Message-Id: <20190420114900.15472-10-anand.jain@oracle.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190420114900.15472-1-anand.jain@oracle.com>
References: <20190420114900.15472-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=983
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904200090
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904200090
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The last consumer of btrfs_set_prop_trans() was taken away by the patch
   btrfs: start transaction in xattr_handler_set_prop
so now this function can be deleted.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c | 6 ------
 fs/btrfs/props.h | 2 --
 2 files changed, 8 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index aedf5a7d69c9..c41ed2a6347e 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -124,12 +124,6 @@ int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 	return 0;
 }
 
-int btrfs_set_prop_trans(struct inode *inode, const char *name,
-			 const char *value, size_t value_len, int flags)
-{
-	return btrfs_set_prop(NULL, inode, name, value, value_len, flags);
-}
-
 static int iterate_object_props(struct btrfs_root *root,
 				struct btrfs_path *path,
 				u64 objectid,
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index 30b99348977d..40b2c65b518c 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -10,8 +10,6 @@
 
 void __init btrfs_props_init(void);
 
-int btrfs_set_prop_trans(struct inode *inode, const char *name,
-			 const char *value, size_t value_len, int flags);
 int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
 		   const char *name, const char *value, size_t value_len,
 		   int flags);
-- 
2.20.1 (Apple Git-117)

