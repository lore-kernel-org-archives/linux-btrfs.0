Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F74C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 05:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 996B7217F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 05:36:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="avRq/c2r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfCMFgK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 01:36:10 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57334 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfCMFgK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 01:36:10 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2D5TWPX124775
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 05:36:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=rBwNjtxbSBNXWJIfuzknC24UQMw0nC9pwB8519STSjY=;
 b=avRq/c2rNX13RoHKVaUXqGkfK0LNyv0xzgVgOO5MpBU5kCHZOtGZ/Qi72S7y4IHJW+6O
 qkgru1H+X0wp94lyx5YROa2gAsFWQixkRXd2hW8MtOYqUBSVoFhP2DN8nEbF0yADEajI
 bJV/YtUNo4bJGmyGOBRJbuLtG7IZN2nLIZm6CUYFeJZqzKEOXpREbc+tJwnYiRX8f/uS
 0PKAgeumai/etcUmM1ZEP++phWwR16TKwuxRrVXeyjscZKSbaKN1lPdt9BL0RMzrFvmc
 oSWPYOSgDLt6d6yiG272K0dKuwMZ7x7oEAzrPN4L55Jw7Je0o2Fb6808USPiuVS9calt xA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2r430es4hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 05:36:08 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2D5a8i7022612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 05:36:08 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2D5a86w014837
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 05:36:08 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Mar 2019 22:36:08 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix zstd compression parameter
Date:   Wed, 13 Mar 2019 13:36:18 +0800
Message-Id: <1552455379-2311-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9193 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903130039
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We let to pass zstd compression parameter even if its not fully written.
For example:
  btrfs prop set /btrfs compression zst
  btrfs prop get /btrfs compression
     compression=zst

zlib and lzo are fine.

Fix it by using the expected number of char in strncmp().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 8577ea1d4e2b..ef6502a94712 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -306,7 +306,7 @@ static int prop_compression_apply(struct inode *inode, const char *value,
 		btrfs_set_fs_incompat(fs_info, COMPRESS_LZO);
 	} else if (!strncmp("zlib", value, 4)) {
 		type = BTRFS_COMPRESS_ZLIB;
-	} else if (!strncmp("zstd", value, len)) {
+	} else if (!strncmp("zstd", value, 4)) {
 		type = BTRFS_COMPRESS_ZSTD;
 		btrfs_set_fs_incompat(fs_info, COMPRESS_ZSTD);
 	} else {
-- 
1.8.3.1

