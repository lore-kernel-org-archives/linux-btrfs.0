Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E23C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2720020652
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:32:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jo3+fRqC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfAQPct (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:32:49 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57516 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfAQPcs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 10:32:48 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0HFT13j191745
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=nJbmKAcS3qj0GOwpXx3Y1iZswJkZ7NxkCrU3kGtY4NE=;
 b=Jo3+fRqCZjXa4Er1NpKn/HXwauowBrH/SSnyYErHyuDx154AMeFcb/w2vJvbSQjW06h4
 dN/Jv8BRSM4I2NChrxvtbfOkw5tnEgc54E8U2AWWAwYbf5BJOaQolZtJMN1J1ue1GvnJ
 It95hquv8ZR3EMbMEYXB+uhFtAI4SN5mxkFk/+eOwEKCBDqVGhsFHgpBDBsok1N73c+1
 DGiwc0UBgATCmODdARugaTnNlPg81iqdZEmS/SL9aGSmC1Y3e8d/FWW5ka4SBYPaX+mL
 ay4mq4gBuDcJvSGU4Y/Sb0WhF4Q0cNQwZ9VA3J/TEZoF1OSz14pnq9JFdTiFgCsFDuHX sA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2pybjp0jyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:47 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0HFWlHT009574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:47 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0HFWlEV021222
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:47 GMT
Received: from tpasj.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Jan 2019 07:32:46 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] btrfs: rename btrfs_find_device_by_path()
Date:   Thu, 17 Jan 2019 23:32:30 +0800
Message-Id: <1547739153-6916-4-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
References: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9138 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=884
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901170111
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_find_device_by_path() is a helper function, drop the btrfs prefix
and the suffix _path is too generic, in fact as it reads superblock to
find the btrfs_device, so rename it to find_device_by_superblock()

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8b5201c734b9..a307d76c8926 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2399,7 +2399,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev)
 	call_rcu(&tgtdev->rcu, free_device_rcu);
 }
 
-static struct btrfs_device *btrfs_find_device_by_path(
+static struct btrfs_device *find_device_by_superblock(
 		struct btrfs_fs_info *fs_info, const char *device_path)
 {
 	int ret = 0;
@@ -2460,7 +2460,7 @@ struct btrfs_device *btrfs_find_device_by_devspec(
 		return ERR_PTR(-ENOENT);
 	}
 
-	return btrfs_find_device_by_path(fs_info, device_path);
+	return find_device_by_superblock(fs_info, device_path);
 }
 
 /*
-- 
1.8.3.1

