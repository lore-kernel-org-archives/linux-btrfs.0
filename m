Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8ABC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 05:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B8A3217F5
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 05:05:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vXCmHxet"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfCNFFA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 01:05:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58348 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfCNFE7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 01:04:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2E54wpX073675
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=+ZZCWdn3UWK+lfN5DjJM3OrVqzGAbf7MNJAvi3t3bVU=;
 b=vXCmHxetDUllyBZkNtDIdV/AgY6sSmmXP/3q2n040XN5ME69xu6C2ga+FL9jB2A2j6EC
 s5dU+VEXvWV7UuNEDq4KoAmkGE1h4iMK3C6fA/3Bbb2dmkx7W+aorRmWTCUjCQnCVlqq
 SsyputanK1pzc9Z0jtVOYqI3WRL54jCx2Y8L9S6tXbIojImmg8MLkpa1KfJf4Z3IWLcb
 +PF+nljDlxzA23cFzgvzlc5NawoDYhiyaf+nZeKi7lcNZeM4fnyCEOItbZtNr8LqHF9P
 RoKlOb3Yy9JL98zcEtn3J1qebs+hXp95rFLgTSVae1CUldPovgkKyA5fX63uQZ9huYeU 6g== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2r464rpqe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:58 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2E54vhE009936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:57 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2E54v43031236
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:57 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Mar 2019 05:04:57 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs: fix vanished compression property after failed set
Date:   Thu, 14 Mar 2019 13:05:04 +0800
Message-Id: <1552539906-29703-3-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1552539906-29703-1-git-send-email-anand.jain@oracle.com>
References: <1552539906-29703-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9194 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903140033
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
index 3cc007e3c7f8..72a06c4d3c70 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -275,11 +275,11 @@ static int prop_compression_validate(const char *value, size_t len)
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

