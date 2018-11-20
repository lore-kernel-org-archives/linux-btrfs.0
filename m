Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7658C4161D
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 11:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9206820685
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 11:56:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XI77w8vd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9206820685
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbeKTWZc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 17:25:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58416 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728035AbeKTWZc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 17:25:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAKBsMBj055896
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 11:56:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=8YHcpIVCIAy5BG7ob35GErd6KnEqCmFYGQMax9uZlok=;
 b=XI77w8vdqlxbsPQNjT0nrOMnD4YCCncdYcMlh1N3C4pCSV0h2H76zmvbXsF/2Fzp2VHC
 T5i1mOfwD1/H/R8khEIhjM7xh4Vz6UioUi5R8uDhvw9OnEZzsH1DtdXaxBdfr44kz6Fj
 hmOJpJAXG3Xuv0rvrF6o1qhUSCO4Gs6OVqShGl81u43EjI1rie18O2yWUtDZF8g9wY3v
 IlHpElcT7X0OMdNfnW2iCBEuIH1fIfp3YUkVa5ihjHPNMTS45jW3AuK9UziVRBu3bEfR
 jgOH8uJx3vdzDSx/jij+76Ik3zxV5yRFi7A0HyvLmk+9UshBAgl9z47rlknEGlK3kX6W zw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2ntadtuh11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 11:56:44 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAKBuhBK022321
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 11:56:44 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAKBuhEa004274
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 11:56:43 GMT
Received: from tpasj.localdomain (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Nov 2018 03:56:43 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND v2 1/2] btrfs: quieten warn if replace is canceled at finish
Date:   Tue, 20 Nov 2018 19:56:15 +0800
Message-Id: <1542714976-28502-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1542714976-28502-1-git-send-email-anand.jain@oracle.com>
References: <1542714976-28502-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9082 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=831
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811200108
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When we successfully cancel the replace its scrub returns -ECANCELED,
which then passed to btrfs_dev_replace_finishing(), it cleans up based
on the scrub returned status and propagates the same -ECANCELED back
the parent function. As of now only user can cancel the replace-scrub,
so its ok to quieten the warn here.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
[fix: quieten spelling]
v1->v2: Use the condition within the WARN_ON()

 fs/btrfs/dev-replace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 1dc8e86546db..9031a362921a 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -497,7 +497,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	ret = btrfs_dev_replace_finishing(fs_info, ret);
 	if (ret == -EINPROGRESS) {
 		ret = BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS;
-	} else {
+	} else if (ret != -ECANCELED) {
 		WARN_ON(ret);
 	}
 
@@ -954,7 +954,7 @@ static int btrfs_dev_replace_kthread(void *data)
 			      btrfs_device_get_total_bytes(dev_replace->srcdev),
 			      &dev_replace->scrub_progress, 0, 1);
 	ret = btrfs_dev_replace_finishing(fs_info, ret);
-	WARN_ON(ret);
+	WARN_ON(ret && ret != -ECANCELED);
 
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 	return 0;
-- 
1.8.3.1

