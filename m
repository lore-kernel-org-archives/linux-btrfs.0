Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C12C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 05:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 774CC217F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 05:36:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T7Tk3zjs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfCMFgM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 01:36:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42440 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfCMFgM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 01:36:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2D5UFiD094359
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 05:36:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=/iWxFWXeBR2QQ+io8j0TWt/Ymv55IlIrSYcm3gotyEE=;
 b=T7Tk3zjsP+SG35NsV4vUmX6eq/ILH2WxyG6a4DbE6U+Laye8vANSWbokNSW03Yi1Ve9W
 7n2mSBMP02MRKjw5is3ncS7RGc2CHHzQkJ2y6jl3gC62rmyiuqHUfvoElVeSJ070Qr3A
 r8OLwPUutHM/jrVtEJAwamnQl9QeVdT5VND41a5m15KXv26cGhqKxnIE5YitGI8uHLY9
 V27YjR/bOaFLOUTX7em1azqa+5GA5qXpH/yAf/hOs1FRTjE+S+uqejalgKdt/bTZggAN
 NNC3XIpVO/VixoQyryk+UL9OVO2AAb7Vb3foEjmcqzcyXs5VMkgIrXCLTEqZ/KDcHLKS ZA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2r464rgm6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 05:36:10 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2D5a9mV016327
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 05:36:10 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2D5a9ak014851
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 05:36:09 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Mar 2019 22:36:09 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: fix vanished compression property after failed set
Date:   Wed, 13 Mar 2019 13:36:19 +0800
Message-Id: <1552455379-2311-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1552455379-2311-1-git-send-email-anand.jain@oracle.com>
References: <1552455379-2311-1-git-send-email-anand.jain@oracle.com>
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

The compression property resets to NULL, instead of the old value if we
fail to set the new compression parameter.

btrfs prop get /btrfs compression
  compression=lzo
btrfs prop set /btrfs compression zli
  ERROR: failed to set compression for /btrfs: Invalid argument
btrfs prop get /btrfs compression

This is because the compression property ->validate() is successful for
'zli' as the strncmp() used the len passed from the userland.

Fix it by using the expected string length in strncmp().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/props.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index ef6502a94712..7aa362c2fbcf 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -277,11 +277,11 @@ static int prop_compression_validate(struct inode *inode, const char *value,
 	if (!value)
 		return 0;
 
-	if (!strncmp("lzo", value, len))
+	if (!strncmp("lzo", value, 3))
 		return 0;
-	else if (!strncmp("zlib", value, len))
+	else if (!strncmp("zlib", value, 4))
 		return 0;
-	else if (!strncmp("zstd", value, len))
+	else if (!strncmp("zstd", value, 4))
 		return 0;
 
 	return -EINVAL;
-- 
1.8.3.1

