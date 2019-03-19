Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6225C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76BEC2133D
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uRx3TelS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfCSKCG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:02:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59884 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfCSKCE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 06:02:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2J9wxI8186207
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=ngDpWvpNEeyfWePElqY+V2nvbBvkPOOCKyLHybH7bEY=;
 b=uRx3TelSSCXRa0cEC+plPfxOr9R+5C3FGeGeavzvbvESJY31kabCcXoTQWKRLjvM3ARB
 Blvion+3dTYPGOb/Q2JPU6HtuowYiWWRcyjscYuwX69O6d1Set1+5tT8LTKfv6l4JARz
 KutdXXU4o+lXRpicSVwM2zWqMR+Qc80Arqlff/OePcCqRJxg9AGm1cjCIQxmN0o8wbg1
 YPbZS55jBtxk19Bx80FQX0AIXKImeT0eEP+CKvd2QBnujdrbJ8gBYv3VTS0QZ3FFBTer
 B/g45ih2InXehEAq0/TPGsyIpjj/r0vluaC8lrdS3XkmvUvHteufmGBOtrM3LJOPmV/9 4A== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2r8rjukn5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:02:03 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2JA1v0C019092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:01:57 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2JA1vZR019949
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:01:57 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Mar 2019 03:01:56 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 1/2] btrfs-progs: add helper to create xattr name
Date:   Tue, 19 Mar 2019 18:02:11 +0800
Message-Id: <1552989732-30310-1-git-send-email-anand.jain@oracle.com>
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

This is a preparatory patch to add more xattr attributes, care a helper
function to alloc xattr name.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 props.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/props.c b/props.c
index efa11180d4c5..3a498bd9e904 100644
--- a/props.c
+++ b/props.c
@@ -94,6 +94,21 @@ static int prop_label(enum prop_object_type type,
 	return ret;
 }
 
+static char *alloc_xattr_name(const char *name)
+{
+	char *xattr_name;
+
+	xattr_name = malloc(XATTR_BTRFS_PREFIX_LEN + strlen(name) + 1);
+	if (!xattr_name)
+		ERR_PTR(-ENOMEM);
+
+	memcpy(xattr_name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN);
+	memcpy(xattr_name + XATTR_BTRFS_PREFIX_LEN, name, strlen(name));
+	xattr_name[XATTR_BTRFS_PREFIX_LEN + strlen(name)] = '\0';
+
+	return xattr_name;
+}
+
 static int prop_compression(enum prop_object_type type,
 			    const char *object,
 			    const char *name,
@@ -114,14 +129,11 @@ static int prop_compression(enum prop_object_type type,
 		goto out;
 	}
 
-	xattr_name = malloc(XATTR_BTRFS_PREFIX_LEN + strlen(name) + 1);
-	if (!xattr_name) {
-		ret = -ENOMEM;
-		goto out;
+	xattr_name = alloc_xattr_name(name);
+	if (IS_ERR(xattr_name)) {
+		error("failed to alloc xattr_name %s: %m", object);
+		return PTR_ERR(xattr_name);
 	}
-	memcpy(xattr_name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN);
-	memcpy(xattr_name + XATTR_BTRFS_PREFIX_LEN, name, strlen(name));
-	xattr_name[XATTR_BTRFS_PREFIX_LEN + strlen(name)] = '\0';
 
 	if (value) {
 		if (strcmp(value, "no") == 0 || strcmp(value, "none") == 0)
-- 
1.8.3.1

