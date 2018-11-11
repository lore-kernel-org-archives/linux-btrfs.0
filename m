Return-Path: <SRS0=L0dM=NW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B0CC43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78FFD208A3
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GOBIIVD3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78FFD208A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbeKLALQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 11 Nov 2018 19:11:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50352 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbeKLALQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Nov 2018 19:11:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wABEJFCs171503
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=M2KTVR4qnHwU9F4Dv+JacIY9Jcag5DqWCm0Osonf1CU=;
 b=GOBIIVD3hlpVK4L6fitEa8bKKEiwt6H4sLDuw4+4b2QHt+UMLAX7xTZVKK82Q0lgEgv+
 HOQoFqZewBrnkjXuCHU3HLEpXL5eEK50EwSyYBI8YqglvsToW4IL3WTtHA/u9+HQv/nd
 zjIj/DxXeoPGLPasQryep77yWTyvGwj20ysgLUNocWAmTz28nI1v8AFdDcB59mnuFqPv
 nW1n761I60/RgNA5WFBqoURv93Wr2rT4GjrIMCd5aqIf1ry4+6CSYqkXHus7YTyhe+O+
 grnnHKgQL6Os24SubJ5G8XvxX5VsECVGpwXRMyWywQ3AZGNiHzycQmrziPCiCi8U2bHc GA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2nnw6ea4a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:33 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wABEMW7k010367
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:32 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wABEMWtV005099
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:32 GMT
Received: from tpasj.localdomain (/183.90.37.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 11 Nov 2018 06:22:31 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 5/9] btrfs: replace cancel is successful if scrub cancel is successful
Date:   Sun, 11 Nov 2018 22:22:20 +0800
Message-Id: <1541946144-8174-6-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9073 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=686
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811110137
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In btrfs_dev_replace_cancel() we should check if the
btrfs_scrub_cancel() is successful. If the btrfs_scrub_cancel() fails, return
BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED so that user can try to
cancel the replace again.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index d32d696d931c..9fc3cb8d3918 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -799,18 +799,22 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		btrfs_dev_replace_write_unlock(dev_replace);
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
-		result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
 		tgt_device = dev_replace->tgtdev;
 		src_device = dev_replace->srcdev;
 		btrfs_dev_replace_write_unlock(dev_replace);
-		btrfs_scrub_cancel(fs_info);
-		/*
-		 * btrfs_dev_replace_finishing() will handle the cleanup part
-		 */
-		btrfs_info_in_rcu(fs_info,
-			"dev_replace from %s (devid %llu) to %s canceled",
-			btrfs_dev_name(src_device), src_device->devid,
-			btrfs_dev_name(tgt_device));
+		ret = btrfs_scrub_cancel(fs_info);
+		if (ret) {
+			result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED;
+		} else {
+			result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
+			/*
+			 * btrfs_dev_replace_finishing() will handle the cleanup part
+			 */
+			btrfs_info_in_rcu(fs_info,
+				"dev_replace from %s (devid %llu) to %s canceled",
+				btrfs_dev_name(src_device), src_device->devid,
+				btrfs_dev_name(tgt_device));
+		}
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
 		/*
-- 
1.8.3.1

