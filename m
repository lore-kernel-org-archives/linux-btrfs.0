Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D51B9C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BC752073D
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IG161PAl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbfACIRq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 03:17:46 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60592 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfACIRq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2019 03:17:46 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x038DdgE125795
        for <linux-btrfs@vger.kernel.org>; Thu, 3 Jan 2019 08:17:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=xUtTg4NSQ6DEPQbEz/UWCvjHVXHbIwH9Ap9AkOVDLcY=;
 b=IG161PAlV1HxibsR4PtXq7teM2gJj2AJc888wTY+AeKNT7dLG+tU9Cc+/dJMbMCTlGOV
 uqnuNe0YtBtC6/KD7qUBRiMujOdVvuNq1lfo6DvH1UH8IlvNnpONNYyFZbtCiuk5/qlu
 eOQwpbctoVj1dccLXVw1zMS9oBxZvw931Yw454t5JDKPXnqFDzXWm5f+JsPP4KcEvbFk
 +YNAkti1kKrKcyJ2vtIfjxYgcye1h87GDqIAMjbo20oWfKvzGTklAhCqtqHzGrTqGA2y
 EJN2YZjJ8sG0nOblfOo163/OAB8/MupWUN+dpu2NcmHpIkduoFkwe2ktogr2PUAlVUxc XQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2pnxee5w7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jan 2019 08:17:44 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x038HhQ7016075
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 3 Jan 2019 08:17:44 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x038HhFs003089
        for <linux-btrfs@vger.kernel.org>; Thu, 3 Jan 2019 08:17:43 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Jan 2019 00:17:43 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: add kernel scrub log messages
Date:   Thu,  3 Jan 2019 16:17:40 +0800
Message-Id: <1546503460-3183-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9124 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901030074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

scrub kernel messages helps debug and audit, add them to the log.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: fix btrfs_info, using string directly. Add spacing.
 fs/btrfs/scrub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6dcd36d7b849..aadafc3e52c7 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3903,6 +3903,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	 */
 	nofs_flag = memalloc_nofs_save();
 	if (!is_dev_replace) {
+		btrfs_info(fs_info, "scrub: devid %llu started", devid);
 		/*
 		 * by holding device list mutex, we can
 		 * kick off writing super in log tree sync.
@@ -3925,6 +3926,10 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	if (progress)
 		memcpy(progress, &sctx->stat, sizeof(*progress));
 
+	if (!is_dev_replace)
+		btrfs_info(fs_info, "scrub: devid %llu %s:%d",
+			devid, ret ? "not finished" : "finished", ret);
+
 	mutex_lock(&fs_info->scrub_lock);
 	dev->scrub_ctx = NULL;
 	scrub_workers_put(fs_info);
-- 
1.8.3.1

