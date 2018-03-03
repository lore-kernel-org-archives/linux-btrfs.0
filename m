Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56240 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965093AbeCCCIy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Mar 2018 21:08:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2327jRh058209
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 02:08:54 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2gfh4s05sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Mar 2018 02:08:54 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2328q7p021222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 02:08:53 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2328q7b025297
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 02:08:52 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: send: fix typo in TLV_PUT
Date: Fri,  2 Mar 2018 18:05:49 -0700
Message-Id: <20180303010549.4621-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

According to tlv_put()'s prototype, data and attrlen needs to be
exchanged in the macro, but seems all callers are already aware of
this misorder and are therefore not affected.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/send.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index f306c60..ee9ce67 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -611,9 +611,9 @@ static int tlv_put_btrfs_timespec(struct send_ctx *sctx, u16 attr,
 }
 
 
-#define TLV_PUT(sctx, attrtype, attrlen, data) \
+#define TLV_PUT(sctx, attrtype, data, attrlen) \
 	do { \
-		ret = tlv_put(sctx, attrtype, attrlen, data); \
+		ret = tlv_put(sctx, attrtype, data, attrlen); \
 		if (ret < 0) \
 			goto tlv_put_failure; \
 	} while (0)
-- 
2.9.4

