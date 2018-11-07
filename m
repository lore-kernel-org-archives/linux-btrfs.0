Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD75EC0044C
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 963CB2081D
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pq3t6aWx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 963CB2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbeKGVNk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 16:13:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45952 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbeKGVNj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2018 16:13:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA7Bd8c0166948
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=1ouPbWN6PZlfU8eihvRNQyfllWYw0wAR0PokKHqAh44=;
 b=pq3t6aWxn+3qwnek7s+RnjyQxKGhBDaLAf3qVA8yroZeQcr4M09m2gXADMvexQh57mqH
 lmxzHwDEYDIMKOeQS6zCsiBD8jUFyOYvBgeSpgUqMV+acUyJK4TsCpeF7V/2fdXlQV9M
 iukNe4dVqbJ76bBoria4rqNM19MWzYR0I8e84VQvzLVr8rx+RIy8v+rK34mAyFhf9On3
 uI9MsSSB0ab+TdIqeFMos0o+NTZYMAb/WM2/GvOT33BVmrsBHzApTzJzv4CV9+YlIYvL
 a+Hj3tizVq7uEOlbwgojgJmqyoZ9agRSdSMkY+faJI2tI8dfhLtacmHO4wPgijoMoGtq Lg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2nh3mpty7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Nov 2018 11:43:39 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wA7BhcoE013281
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:38 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA7Bhc2L027493
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:38 GMT
Received: from tpasj.localdomain (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Nov 2018 03:43:37 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/9] btrfs: replace back to suspend state if EXCL OP is running
Date:   Wed,  7 Nov 2018 19:43:24 +0800
Message-Id: <1541591010-29789-4-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
References: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9069 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=776
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811070108
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
 fs/btrfs/dev-replace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 47d6768a9cde..e001c2418940 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -898,6 +898,11 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 	 * dev-replace to start anyway.
 	 */
 	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
+		btrfs_dev_replace_write_lock(dev_replace);
+		dev_replace->replace_state =
+					BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
+		dev_replace->item_needs_writeback = 1;
+		btrfs_dev_replace_write_unlock(dev_replace);
 		btrfs_info(fs_info,
 		"cannot resume dev-replace, other exclusive operation running");
 		return 0;
-- 
1.8.3.1

