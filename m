Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C50C4161D
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 11:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B3AB20685
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 11:56:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="5G4X7zbk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B3AB20685
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbeKTWZi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 17:25:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58726 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728035AbeKTWZi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 17:25:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAKBscLY022118
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 11:56:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=0OAMahhDgA+MvRF8B1G7Xg7R0Nph+XBO09v1jIL2gto=;
 b=5G4X7zbk05R0OAoMU19SqH3XHBMy51YX3Xujnt/9KIgnjxjW/YnY2jl3DiMj1lGYMMte
 XPYRYRdPtRQMWHErgY1mhJPXL/mOHk0OQ+6uqSoeJAicbRoMXyIpCbEB5I6ji7/s51dW
 UzCR6ss2lDRiuyCEBBtlnqHa+Sh4bKC6n/CghZ8qGSGWQnoyM82MWUjhCOZ9f0xIgXiI
 N3X61ZlXUXDW5RhflHYJa+F5MLHoYyjbrF3gG958qEwbDMRuFyj0rQZDK8KrGS2APl1F
 cAmeRvpVeEscFpXOO3Cub6n59BW1mQeS6AeIv7VuaBo3P+zUe1fDzrMVPTLETbu8krIo ig== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2ntaxq3fym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 11:56:50 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAKBuj5s022372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 11:56:45 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAKBuig8004282
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 11:56:45 GMT
Received: from tpasj.localdomain (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Nov 2018 03:56:44 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND v2 2/2] btrfs: user requsted replace cancel is not an error
Date:   Tue, 20 Nov 2018 19:56:16 +0800
Message-Id: <1542714976-28502-3-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1542714976-28502-1-git-send-email-anand.jain@oracle.com>
References: <1542714976-28502-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9082 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=850
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811200108
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

As of now only user requested replace cancel can cancel the replace-scrub
so no need to log error for it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: none.

 fs/btrfs/dev-replace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 9031a362921a..40a0942b4659 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -622,7 +622,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 								src_device,
 								tgt_device);
 	} else {
-		btrfs_err_in_rcu(fs_info,
+		if (scrub_ret != -ECANCELED)
+			btrfs_err_in_rcu(fs_info,
 				 "btrfs_scrub_dev(%s, %llu, %s) failed %d",
 				 btrfs_dev_name(src_device),
 				 src_device->devid,
-- 
1.8.3.1

