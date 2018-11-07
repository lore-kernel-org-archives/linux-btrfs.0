Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36822C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C962081D
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ggzrsBXn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00C962081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbeKGVNq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 16:13:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49518 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbeKGVNq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2018 16:13:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA7BdkQ1157589
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=d4DsyNsZuDJH0DrEjYV9uB1ECwZ5K5cH5J++peZJH10=;
 b=ggzrsBXnb9ilZJOozWU5jVDxpEOimtUWpnjLtCNOO5M2WO1tCJXoVOsvgJP6rLHKGgYK
 Y3IRhZfTAGgkO/k5vM/Z1GgsHyVUNHu8TPMQK9qMR8wVx32kMG19CRLMray7pOe+p/oq
 T7M0vEnonDpzdUGMrb9Rf6ZS1JhVy4yN0/nXcnfcdIMGiU4VySM2tysrvA202nYd4xNW
 U8DnQnfkhNw6EGrROnHy4IUeo5NBvXKZBREWnnWS8tkderrbs0rQcu6Qy0WKz3Do5x9G
 KuWzYJGmhYSP5X6a+8vijQKSEH5uPh5ijrSKQxa5MSyE2JNMiOiYppAzae7MBXgCmGkr 8w== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2nh33u2yqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Nov 2018 11:43:45 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA7Bhj3K028890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:45 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA7Bhj21027928
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:45 GMT
Received: from tpasj.localdomain (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Nov 2018 03:43:44 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 7/9] btrfs: quiten warn if the replace is canceled at finish
Date:   Wed,  7 Nov 2018 19:43:28 +0800
Message-Id: <1541591010-29789-8-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
References: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9069 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=694
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811070108
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When we successfully cancel the replace its scrub returns -ECANCELED,
which then passed to btrfs_dev_replace_finishing(), it cleans up based
on the scrub returned status and propagates the same -ECANCELED back
the parent function. So skip the -ECANCELED error to log the WARN.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index dae2b920f1a9..c14c41b70287 100644
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
 
@@ -956,7 +956,8 @@ static int btrfs_dev_replace_kthread(void *data)
 			      btrfs_device_get_total_bytes(dev_replace->srcdev),
 			      &dev_replace->scrub_progress, 0, 1);
 	ret = btrfs_dev_replace_finishing(fs_info, ret);
-	WARN_ON(ret);
+	if (ret != -ECANCELED)
+		WARN_ON(ret);
 
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 	return 0;
-- 
1.8.3.1

