Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501BFC10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 12:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1415C2084B
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 12:01:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yJehmRVK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfDYMBC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 08:01:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53894 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfDYMBC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 08:01:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3PBxJKo062879
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 12:01:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=ngDpWvpNEeyfWePElqY+V2nvbBvkPOOCKyLHybH7bEY=;
 b=yJehmRVKBYzNWSb5EcV9KwUemnCOJuKHS1jvHvRoI1L2nKrIGL0aK2evwDLXed8vgNWE
 3Ur0Hx/oWEkyoG46RrqpI/JZe/OEdXrigpcVAfYYbR5OfnxepbM0lVMlLvqqKKO6yKg5
 Kb5tdgiaKj+uCE+AksY0SPxHte52rxzFgWPHLppw4kZQc/8nKWTOReL/G6DnBeUj2GBn
 ZjPjrojJ/uSGb3lGHx3ZeSkpIrTknh+QgJV+Th/jnSswFNHAEOOF8Qhi/4hOufnxZa+r
 RGljbOSxDIDI7ZCqTNODYiAyeU8dI/G5gWqHggkLpuwuBBLxDlqO4Se+45vTN03bM49w yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2rytut7vay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 12:01:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3PBxNRa181654
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 12:01:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ryrht5ttt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 12:01:00 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3PC0xod008091
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 12:00:59 GMT
Received: from localhost.localdomain (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Apr 2019 05:00:59 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: add helper to create xattr name
Date:   Thu, 25 Apr 2019 20:00:54 +0800
Message-Id: <20190425120055.2604-1-anand.jain@oracle.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190425115946.2550-1-anand.jain@oracle.com>
References: <20190425115946.2550-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9237 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904250077
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9237 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904250077
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

