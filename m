Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB93C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 03:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEF2120883
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 03:15:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nGkLoJFc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbeLQDPO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 16 Dec 2018 22:15:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44992 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbeLQDPN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Dec 2018 22:15:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBH3Db67005952
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 03:15:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=eB8jum8l24Z9vDns4aAzJddbDXvNFxg/jGCBhUKEMLI=;
 b=nGkLoJFcEIhiWrdFrd75HHkz5GfV/ALry+aOzickl+RpD+cRMaT5vZ3IsF3o5j7rwDct
 iraKzO94TI3FdKjP1PmE7tqvz2hAkscYMzuIQHZUhpTAKh3eliBnFdDwd+eIeE5uBvCL
 LInrHWbCJ3nG66YaWUOyP2QZlSFAYroo/Uu990jQgDjv8zONOXTPiHU/nXWuLp8Tbuc0
 VHP7xXnc54C6YYvPVa0n95wJWCP8muMMUA4/9kDqo1GVN2qEO74LDK2ryMiLJWKTcZ7l
 cvG+JbflfGbOzwyMwp1PeQBGkV+RtR22SkSyLcsS+TZxrK8rOxGmylTIr/LWn8ylQH6F 9A== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2pcs1tbkpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 03:15:12 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wBH3FBlf029366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 03:15:11 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wBH3FB0h007037
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 03:15:11 GMT
Received: from tpasj.localdomain (/157.49.189.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 16 Dec 2018 19:15:11 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs: add kernel scrub log messages
Date:   Mon, 17 Dec 2018 11:15:12 +0800
Message-Id: <1545016512-4336-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9109 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812170029
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

scrub kernel messages helps debug and audit, add them to the log.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/scrub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 902819d3cf41..d7a92521019e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3876,6 +3876,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	mutex_unlock(&fs_info->scrub_lock);
 
 	if (!is_dev_replace) {
+		btrfs_info(fs_info, "scrub: devid %llu %s", devid, "started");
 		/*
 		 * by holding device list mutex, we can
 		 * kick off writing super in log tree sync.
@@ -3897,6 +3898,10 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	if (progress)
 		memcpy(progress, &sctx->stat, sizeof(*progress));
 
+	if (!is_dev_replace)
+		btrfs_info(fs_info, "scrub: devid %llu %s:%d",
+			   devid, ret ? "not finished":"finished", ret);
+
 	mutex_lock(&fs_info->scrub_lock);
 	dev->scrub_ctx = NULL;
 	scrub_workers_put(fs_info);
-- 
1.8.3.1

