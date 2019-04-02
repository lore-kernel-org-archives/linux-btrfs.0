Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9C3C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 10:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D0C120856
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 10:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MYpT0rQg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbfDBKIE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 06:08:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45948 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728710AbfDBKID (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 06:08:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x329hUBl123794
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:08:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=+ZZCWdn3UWK+lfN5DjJM3OrVqzGAbf7MNJAvi3t3bVU=;
 b=MYpT0rQgjEVTDprLE93AVZRXCVOQ/oz8zd5wK+t2+nMV9H/mHc49rbNIoOGpcfGtrAbg
 tbZLLtxqIQ//2gMSyEr88dPS0hzyXvRcTCRhzMP6ONU3Yu7HoNk/BhIhAAGr119qUTSb
 wUDcfMUAjpBdEp/y8IAFXp6gCjtndhw/ueY+ujT+uM6O+qZYxVjpqliyi530cO6d5Fx8
 kRWQhgAd8mfbOGqo9fqmSPNzD0l05tKKXH/lAKo2lZXNVovV+vHIDRztKtVvlHVLucrM
 dvFD3GLTlc0StbVQV7D+/YQe9cx70xvARf5N4E3C9Krs07UscH3Vt7NMg9DUAJCu/O1k 0Q== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2rj13q43r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2019 10:08:02 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x32A81J1017847
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:08:01 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x32A81RP006876
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:08:01 GMT
Received: from tp.wifi.oracle.com (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Apr 2019 03:08:01 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4 RESEND] btrfs: fix vanished compression property after failed set
Date:   Tue,  2 Apr 2019 18:07:40 +0800
Message-Id: <20190402100742.8355-4-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190402100742.8355-1-anand.jain@oracle.com>
References: <20190402100742.8355-1-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9214 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904020070
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

