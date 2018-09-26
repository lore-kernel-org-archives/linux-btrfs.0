Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10765C43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 07:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE7772089D
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 07:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vNJjvx9j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE7772089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbeIZNsQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 09:48:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39636 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbeIZNsP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 09:48:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8Q7YIgS137843
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 07:36:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=rLlvuh70iEGInbX2K/k5GzChfpblR65AbjZBXQgLKoE=;
 b=vNJjvx9j9xfjOF7fFwz40fnpBHJaP2JUDMA44lUdKKFhrinP766qK4bADHOtNuR8pH4R
 31g532urPzPfS0gv9aufjr8dvfPzAp/ZsZXZqX87XNGTzLfARdzH8qK0tjH4CqHInC4X
 gJ2VgriMTlY7IHxlrftr9p4eyYL5HCUutlPsBGiGxHZCFWf8u5kwUXsISFqx6qmlvWE1
 LpUJj9hT3oLWvf+iKNHc1jOtjzNN2JPl6fafVCUieB3CR6Bgy+8OMdw/bB+TXgldnEJ4
 eVl67x0BGx23+ZVjUyS3PdcswKkpcPwMcrHdkbEmfJFBXePIVJDu16ldpaV9f1zrQ29j Jg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2mndppgmpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 07:36:40 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8Q7aZhc020863
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 07:36:35 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8Q7aZmR004902
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 07:36:35 GMT
Received: from tpasj.sg.oracle.com (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Sep 2018 00:36:34 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: delete unused is_vol_small() and BTRFS_MKFS_SMALL_VOLUME_SIZE
Date:   Wed, 26 Sep 2018 15:36:28 +0800
Message-Id: <1537947388-10396-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9027 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1809260078
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since commit c11e36a29e84 (Btrfs-progs: Do not force mixed block group
creation unless '-M' option is specified) we don't have automatic
mixed mode, and the function is_vol_small() and the define
BTRFS_MKFS_SMALL_VOLUME_SIZE was obsolete since then so clean it up.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs/common.c | 29 -----------------------------
 mkfs/common.h |  1 -
 2 files changed, 30 deletions(-)

diff --git a/mkfs/common.c b/mkfs/common.c
index 0ace262b0e5f..c59e1d8eda4a 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -772,35 +772,6 @@ int test_status_for_mkfs(const char *file, bool force_overwrite)
 	return 0;
 }
 
-int is_vol_small(const char *file)
-{
-	int fd = -1;
-	int e;
-	struct stat st;
-	u64 size;
-
-	fd = open(file, O_RDONLY);
-	if (fd < 0)
-		return -errno;
-	if (fstat(fd, &st) < 0) {
-		e = -errno;
-		close(fd);
-		return e;
-	}
-	size = btrfs_device_size(fd, &st);
-	if (size == 0) {
-		close(fd);
-		return -1;
-	}
-	if (size < BTRFS_MKFS_SMALL_VOLUME_SIZE) {
-		close(fd);
-		return 1;
-	} else {
-		close(fd);
-		return 0;
-	}
-}
-
 int test_minimum_size(const char *file, u64 min_dev_size)
 {
 	int fd;
diff --git a/mkfs/common.h b/mkfs/common.h
index 28912906d0a9..18f5c3b66270 100644
--- a/mkfs/common.h
+++ b/mkfs/common.h
@@ -26,7 +26,6 @@
 #include "common-defs.h"
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE SZ_4M
-#define BTRFS_MKFS_SMALL_VOLUME_SIZE SZ_1G
 
 /*
  * Tree root blocks created during mkfs
-- 
1.8.3.1

