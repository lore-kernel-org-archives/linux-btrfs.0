Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC52EC4360F
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 05:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9F3221773
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 05:50:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F5gcevTt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbfC2FuC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 01:50:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41230 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727294AbfC2FuB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 01:50:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2T5mukp181905
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 05:50:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=yzJLdcpX7tX2JrgTkyNBBdl3hdj/JhoLxJ+SUKb8FPY=;
 b=F5gcevTtqOLJNU01esxFFxuKGE7kqUU4qrIY+ISCSyPvZcJ7uLE7ydXA4kz+BN33/U1r
 2gbdJCfYvnhcudetfV8hJbvq5nPj/DNWWFzbuMDBvyGcoKWtPEaGoA1NDhkzVV7cym3u
 9m7uc8GrwZ9vkaZJ0PD8++WOuzd8C9aqBNCzzuauViHwYViOlNM7U737eRY7q2OCfmW7
 WspMsXYl/bBt/16lhXCrRhotlZUDxj4Waqj32BM3eUV05H8YoxlUtviCUI0siwo53jLj
 BPDTJuEUTG1GgeG0lGiGlAGR2I7zqMjmMGI8vqmC7EP3NhBAYxokjuonqbOKOeuz0biJ 3g== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2re6djteee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 05:50:00 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2T5nx4J020395
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 05:49:59 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2T5nxAJ029360
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 05:49:59 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 22:49:59 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: scan: pass blkid_get_cache error code
Date:   Fri, 29 Mar 2019 13:49:54 +0800
Message-Id: <1553838594-26013-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1553838594-26013-1-git-send-email-anand.jain@oracle.com>
References: <1553838594-26013-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9210 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903290043
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

blkid_get_cache() returns error code which is -errno. So we can use them
directly.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
Ref:
blkid_get_cache() code:
https://github.com/karelzak/util-linux/blob/master/libblkid/src/cache.c#L93
https://github.com/karelzak/util-linux/blob/master/libblkid/src/blkidP.h#L307
 utils.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/utils.c b/utils.c
index 9e26c884cc6c..c6cdc8f01dc1 100644
--- a/utils.c
+++ b/utils.c
@@ -1994,9 +1994,11 @@ int btrfs_scan_devices(void)
 	if (btrfs_scan_done)
 		return 0;
 
-	if (blkid_get_cache(&cache, NULL) < 0) {
-		error("blkid cache get failed");
-		return 1;
+	ret = blkid_get_cache(&cache, NULL);
+	if (ret < 0) {
+		errno = -ret;
+		error("blkid cache get failed: %m");
+		return ret;
 	}
 	blkid_probe_all(cache);
 	iter = blkid_dev_iterate_begin(cache);
-- 
1.8.3.1

