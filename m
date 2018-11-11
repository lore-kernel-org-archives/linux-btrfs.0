Return-Path: <SRS0=L0dM=NW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FCFC43610
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90112208A3
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tuIYtCSB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90112208A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbeKLALJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 11 Nov 2018 19:11:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50280 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbeKLALI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Nov 2018 19:11:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wABEJW1j171533
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=3IbYJInXoU7/tyXlBmEbEPc9es5hkSpxzQoCm4x/RLU=;
 b=tuIYtCSBFTHkJwfXesL1FjyjncAz2+29/2P4FFTpsnkCAHZr99ckY1BqungEmpONr6sC
 8LluT9zbVAs21bX9CB1dXxaRvHrO33FEe6b3TJX7pBjixWLfXPZub4xskIa7PlXXqCa9
 A9crb8WLXqJlo14gn711YN+adXhl9YXA4p0OlRgR86P9scE0OsVqEAY30scZnFrSe7DN
 EBnLH1eNqSSGnio30vioUgrq5kuluR32dPFAhFPWRbAoKHn5QTI0yp0lgMh0rR0mu5Ut
 S2wBkxl9e4A/l7X0qcatQEOUATF1fuBgVnnISiqmD73gbm4HEoOeS/U28DaZfd4OTeb1 GA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2nnw6ea49x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:25 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wABEMPbk025588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:25 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wABEMPn8004181
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:25 GMT
Received: from tpasj.localdomain (/183.90.37.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 11 Nov 2018 06:22:24 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/9] btrfs: mark btrfs_dev_replace_start() as static
Date:   Sun, 11 Nov 2018 22:22:16 +0800
Message-Id: <1541946144-8174-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9073 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=917
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811110137
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There isn't any other consumer other than in its own file dev-replace.c.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/dev-replace.c | 2 +-
 fs/btrfs/dev-replace.h | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 2aa48aecc52b..59991165e126 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -390,7 +390,7 @@ static char* btrfs_dev_name(struct btrfs_device *device)
 		return rcu_str_deref(device->name);
 }
 
-int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
+static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 		const char *tgtdev_name, u64 srcdevid, const char *srcdev_name,
 		int read_src)
 {
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index 795c551f5b5e..27e3bb0cca11 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -13,9 +13,6 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 			  struct btrfs_fs_info *fs_info);
 int btrfs_dev_replace_by_ioctl(struct btrfs_fs_info *fs_info,
 			    struct btrfs_ioctl_dev_replace_args *args);
-int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
-		const char *tgtdev_name, u64 srcdevid, const char *srcdev_name,
-		int read_src);
 void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 			      struct btrfs_ioctl_dev_replace_args *args);
 int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info);
-- 
1.8.3.1

