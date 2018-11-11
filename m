Return-Path: <SRS0=L0dM=NW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A8AC43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD39421104
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VVn8w+QW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD39421104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbeKLALT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 11 Nov 2018 19:11:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47162 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728331AbeKLALS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Nov 2018 19:11:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wABEJiSW007924
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=WHkQryi+JbGUicouJ0yOiX8JYZ2FOZ8o/KW2l0Mn0kE=;
 b=VVn8w+QWoYns7MqNcDx6NqJACHsAgtjDRrb488avZZzDzHdqyYRmN4DFEiIRSB7HGx0X
 9KEOxuTm3/OPTb2BoG6D3pr0zWnxRZZtSnxbtI784NgmbBo0vUJ4g9vdfeDOx8IukpfI
 JD+Ml+ee1cRp+EJaWSgSh5EP+B6//1CiZ2JXaMQ/mNMLBI1UZpWJY9vcaOjqvW9oFh4L
 2/lOG2uOdhE92npwOJIOOSrVoqc75nUcE5ELmRa6oVVcIku6Ka/sc32UTcwQ5MBQM2ZE
 13bbY9sPspFwwbKfBfRkDiHIv3o3WIWrGjIAHt9nzwCz/ZRO3mkALoggrNAFY268JIeL mw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2nnwg121nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:36 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wABEMZq0002753
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:35 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wABEMZUS006587
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:35 GMT
Received: from tpasj.localdomain (/183.90.37.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 11 Nov 2018 06:22:35 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 7/9] btrfs: quiten warn if the replace is canceled at finish
Date:   Sun, 11 Nov 2018 22:22:22 +0800
Message-Id: <1541946144-8174-8-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9073 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=695
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811110137
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

