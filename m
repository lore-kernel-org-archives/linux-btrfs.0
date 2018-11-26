Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DF0C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 09:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9710B20672
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 09:07:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nftxd9w/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9710B20672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbeKZUAs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 15:00:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38572 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbeKZUAr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 15:00:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAQ941Vm113771
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 09:07:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=mFqmAHXwWqavFrl7nPHi8ijJZWawqJaVFwqPa0wAbqw=;
 b=Nftxd9w/GUDrFTmwHKOuDM/CGvsKYfDWP0CreuDR3nLSlPbZug/4QvpE2ZcLBo6yXj+W
 hQqQVr3cRYF/W5k1IQETjDuQN4L4aci+ZkuXeQVEMtwM7O6+zbeopKRvKt9PXHjAQFyJ
 /dBIQ7kzEMzcuW8KX7Tldhd0xGR5E7Bb6/FOX+ZI8wgTL1XFZJMKafBwC1OY8P9+Qo84
 16MnqM/svk45ufuZfaGBk680dc7YaRoAq7kIAjQRUIW03Jf3/gxJ1Q+IIIAlszcWHOUN
 YgJgKSAHfmv7tMNGCA0nE4iI4ZKhdnPw6ymnX4Rh5f1nzPGoqat8PdIj/bboF1/ZnR0N OA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2nxy9qvbq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 09:07:18 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAQ97Ie6012320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 09:07:18 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAQ97HKi008701
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 09:07:18 GMT
Received: from tpasj.sg.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Nov 2018 01:07:17 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: scrub: maintain the unlock order in scrub thread
Date:   Mon, 26 Nov 2018 17:07:07 +0800
Message-Id: <1543223228-28232-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1543223228-28232-1-git-send-email-anand.jain@oracle.com>
References: <1543223228-28232-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9088 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811260085
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The fs_info::device_list_mutex and fs_info::scrub_lock creates a
nested locks in btrfs_scrub_dev(). During the lock acquire the
hierarchy is fs_info::device_list_mutex and then fs_info::scrub_lock,
so following the same reverse order during unlock, that is
fs_info::scrub_lock and then fs_info::device_list_mutex.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/scrub.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 902819d3cf41..b1c2d1cdbd4b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3865,7 +3865,6 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	}
 	sctx->readonly = readonly;
 	dev->scrub_ctx = sctx;
-	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 	/*
 	 * checking @scrub_pause_req here, we can avoid
@@ -3875,15 +3874,14 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	atomic_inc(&fs_info->scrubs_running);
 	mutex_unlock(&fs_info->scrub_lock);
 
-	if (!is_dev_replace) {
-		/*
-		 * by holding device list mutex, we can
-		 * kick off writing super in log tree sync.
-		 */
-		mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	/*
+	 * by holding device list mutex, we can kick off writing super in log
+	 * tree sync.
+	 */
+	if (!is_dev_replace)
 		ret = scrub_supers(sctx, dev);
-		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-	}
+
+	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 	if (!ret)
 		ret = scrub_enumerate_chunks(sctx, dev, start, end);
-- 
1.8.3.1

