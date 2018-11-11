Return-Path: <SRS0=L0dM=NW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2D6C43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 284DA208A3
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g0FHmn61"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 284DA208A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbeKLALM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 11 Nov 2018 19:11:12 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47084 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbeKLALM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Nov 2018 19:11:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wABEJVuF007850
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=vYzDJ/Af1O+XPlZo5fffBMdWX+WbZV9c3MAqLJ8rmbo=;
 b=g0FHmn61fqTZMixXoTDPQ64SgCEaVbuMnRNoWgUQkFPsuXpvDf4dzp7U+eTZcKDSA1iO
 sC+69Ht2nKRrSrwOTLvr0nNz6Ny2iqXoFQ8oeuuqoXhmkKMzE4F3Zeorpg5TPVTLywkm
 EbYc8yA2nFZb0VQiWPJeDMq4UezTEuludl1jgx352VdKR6MvcpVg+y26x6EKqrKmCjMz
 0PJcpPugof5llTkxf7vE0W6/zJ82HfB8cRyVfAHAHK7RSva48O12Nu0t1rxc4nR/cGJL
 pN6klE1qPpRcu7GMfdlQSzFH95dhrhnaZs6sufoKwV7yOoo/wkHetVUvQ65FDUX3xrSO Zw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2nnwg121np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:29 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wABEMTh8010325
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:29 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wABEMSve005095
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:28 GMT
Received: from tpasj.localdomain (/183.90.37.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 11 Nov 2018 06:22:28 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/9] btrfs: replace back to suspend state if EXCL OP is running
Date:   Sun, 11 Nov 2018 22:22:18 +0800
Message-Id: <1541946144-8174-4-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9073 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=728
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811110137
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In a secnario where balance and replace co-exists as below,
  start balance; pause balance; start replace; reboot
and when system restarts balance restarts first and the
replace restart will fail as EXCL OP lock is already held by
the balance. If so place the replace state back to
BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED state.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 3c29b0976087..35ce10f18607 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -897,6 +897,10 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 	 * dev-replace to start anyway.
 	 */
 	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
+		btrfs_dev_replace_write_lock(dev_replace);
+		dev_replace->replace_state =
+					BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
+		btrfs_dev_replace_write_unlock(dev_replace);
 		btrfs_info(fs_info,
 		"cannot resume dev-replace, other exclusive operation running");
 		return 0;
-- 
1.8.3.1

