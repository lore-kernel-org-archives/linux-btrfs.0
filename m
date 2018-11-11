Return-Path: <SRS0=L0dM=NW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9FAC43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34068208A3
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zEQ7PnAj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 34068208A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbeKLALX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 11 Nov 2018 19:11:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47198 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbeKLALX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Nov 2018 19:11:23 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wABEIu2J007495
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=x7DTj6+a06P8mBvG7dCWlhyV2jPAbcBQ27BLBj87V90=;
 b=zEQ7PnAjXaPDzGEAKY36GrOpW607DzW0D2BhfDQVH6DLwnO+u/aWVN4sdzcoWUoGxtgS
 5FAn/w4tMoMNmb2uExwPwbhcCyzRtBfIHqpEPoaF/pTWDBVxpvGgeHTayZJZiT2e5NLZ
 5S9t3RPrBnu6YHFuGgT7Fu59tfx7rZ+KLAKwFbpkxLWnbDwdoLo4VOZRVUHmdCdkI7L9
 O/B6kv9Mwhc6W3i6CZEjgOMH66ZWwa7lYzXMtarJAw2WM80hNIAsPEYSrQ9dJl/+6hT5
 RhEcPfvERWVHCY6bF3/7eGlKvAqcBwSI+9Yf/OmI1a9BRlyF/e71ANkXiFpR2GlSrR1Y vQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2nnwg121ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:40 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wABEMd9d025734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:40 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wABEMdjH006590
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:39 GMT
Received: from tpasj.localdomain (/183.90.37.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 11 Nov 2018 06:22:38 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 9/9] btrfs: add explicit check for replace result no error
Date:   Sun, 11 Nov 2018 22:22:24 +0800
Message-Id: <1541946144-8174-10-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9073 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=791
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811110137
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We recast the replace return status
BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS to 0, to indicate no
error.
And since BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR should also return 0,
which is also declared as 0, so we just return. Instead add it to the if
statement so that there is enough clarity while reading the code.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 40a0942b4659..cc25a34f87b0 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -533,8 +533,9 @@ int btrfs_dev_replace_by_ioctl(struct btrfs_fs_info *fs_info,
 					args->start.cont_reading_from_srcdev_mode);
 	args->result = ret;
 	/* don't warn if EINPROGRESS, someone else might be running scrub */
-	if (ret == BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS)
-		ret = 0;
+	if (ret == BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS ||
+	    ret == BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR)
+		return 0;
 
 	return ret;
 }
-- 
1.8.3.1

