Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A2BC0044C
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D2972081D
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fyamgvzj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D2972081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbeKGVNn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 16:13:43 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37360 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbeKGVNn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2018 16:13:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA7Bf6wN115005
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=R6PRjOCgYye58CDFbxpEQx84bH604k2qcCGJVIIKaLo=;
 b=FyamgvzjiLNvpaZ37wZa4KTO67w59klwGxCRb1mqlxhwJBomqe++v2/eVKzpTtZYZ0gx
 LvZtRJFHFgQENAW2KAiJk+5M0B42OoFRFT5UJsi3xrZwTjxTtcjhbaiq0D3R6P77dgj4
 DJu3Pko7XdzKaLjmweSlJTh4dxfrkGpXp+XbDZFWzuVfVO6TNA3inGffhltybUOkLrsA
 RwZFszF3M2r3qX8E/Cl8sFwOkaolyXJGMr9lBKnutKFOUdwvts7wCN5Y1yTu+Hef0c2O
 o7YlAMDHoFlGKWebY4D3XynL2xNANZFfoWmlZI4zwqL3B6qDDJeNTZ5iYGtwp/Yy8BZR Bg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2nh4aqtuyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Nov 2018 11:43:42 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wA7BhfiI013481
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:41 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA7BhfiY027505
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:41 GMT
Received: from tpasj.localdomain (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Nov 2018 03:43:40 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 5/9] btrfs: replace cancel is successful if scrub cancel is successful
Date:   Wed,  7 Nov 2018 19:43:26 +0800
Message-Id: <1541591010-29789-6-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
References: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9069 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=696
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811070108
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
index 90c124edec76..c092ed559714 100644
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

