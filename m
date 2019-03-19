Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A583DC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FB1D20857
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:00:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dCSgimgn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfCSKAP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:00:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57982 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfCSKAO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 06:00:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2J9wx0a186178
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=lGvfOq153aKR2IeqhILLafZwQYpDRLY7NBZeUiLMwCA=;
 b=dCSgimgneoD1kiZx7DI4NuIqneHaswX0p75RCt+FwdfbgTwqVZ/fVZRnLvFmmUzVngmD
 60/raPtztPm43Wp+ZRZg/G1FgUHVCqKrP4q76pDM4lKhs/635jkYV68wvlmr2CO0tNK/
 Z+cdOq3bozUYsa8txDvYg+jF02gbQbfhk0Lwx2s6+YQVfIKMbf8e6E2F5vbMIh0pPl+q
 a9zLq8i3Rn0rszvtH6ENlKxy2+1laf/xjm5CU+gO+pI7KZUxA6esjuR1k6jgkShRfyy8
 r4Xa2KTp923iB6kczDUhcnruGxXMi2ImkS10yuTYKSzsoP5b8iDMc+548vuQVU/EduOi hA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2r8rjukmrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:12 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2JA0Bik027845
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:11 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2JA0B7C000488
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:11 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Mar 2019 03:00:11 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 1/5] btrfs: add inode pointer to prop_handler::validate()
Date:   Tue, 19 Mar 2019 18:00:20 +0800
Message-Id: <1552989624-29577-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
References: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9199 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903190076
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In preparation to add the readmirror devid property, pass inode in the
prop_handler::validate() function vector, so that it can fetch
corresponding fs_devices.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 99fa2459ba61..1a13f10a6ef5 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -18,7 +18,7 @@
 struct prop_handler {
 	struct hlist_node node;
 	const char *xattr_name;
-	int (*validate)(const char *value, size_t len);
+	int (*validate)(struct inode *inode, const char *value, size_t len);
 	int (*apply)(struct inode *inode, const char *value, size_t len);
 	const char *(*extract)(struct inode *inode);
 	int inheritable;
@@ -89,7 +89,7 @@ int btrfs_set_prop(struct inode *inode, const char *name, const char *value,
 		goto out;
 	}
 
-	ret = handler->validate(value, value_len);
+	ret = handler->validate(inode, value, value_len);
 	if (ret)
 		return ret;
 
@@ -263,7 +263,8 @@ int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path)
 	return ret;
 }
 
-static int prop_compression_validate(const char *value, size_t len)
+static int prop_compression_validate(struct inode *inode, const char *value,
+				     size_t len)
 {
 	if (!value)
 		return 0;
@@ -361,7 +362,7 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 			continue;
 
 		/* may be removed */
-		ret = h->validate(value, strlen(value));
+		ret = h->validate(inode, value, strlen(value));
 		if (ret)
 			continue;
 
-- 
1.8.3.1

