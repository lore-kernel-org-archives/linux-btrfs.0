Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC99C282D5
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 06:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5117E20989
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 06:45:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fqFJpech"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfA3GpS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 01:45:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45186 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfA3GpR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 01:45:17 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0U6cf5O047806
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 06:45:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=XmP96VGxdHY5zo7TrygYsrSYE1al95jzjDGahrR6iD4=;
 b=fqFJpechEhzP0twX2gqZuRjPiOna+VvLf+ddDqaSMTpXqCuu3PPaZTLdxsgYQZnxXuMk
 oOvORQK+6OTMw3lph04jZNqCN+rJcLHK9zmi5/EY8Gp6GcZ4MsU9ySG1UezoZHixrB7O
 cT6BFvk5dzxId68sC5fIKB1vMFg6oMDvdnDI7dSFIE+p5E7jEYCbt1nkFX38XnBX5L9G
 5mG6bhByWrD2FjzuPZq8vbDnpCMr8ZYARuHWBte6Vdk1L3yy6l84MPsAXX3XYemf/QS5
 vRHaxH3PrNQQcf19kys1v6ux1yjFM9hndp9f627M4Fckb4OmhprvNKWTEFJBQYlHE9uU tw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2q8d2e8vrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 06:45:15 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0U6jENU007554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 06:45:14 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0U6jECF012858
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 06:45:14 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Jan 2019 22:45:14 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 3/3] btrfs: scrub: convert scrub_workers_refcnt to refcount_t
Date:   Wed, 30 Jan 2019 14:45:02 +0800
Message-Id: <1548830702-14676-4-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
References: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9151 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901300051
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Use the refcount_t for fs_info::scrub_workers_refcnt instead of int.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v4: born
 fs/btrfs/ctree.h   | 2 +-
 fs/btrfs/disk-io.c | 2 +-
 fs/btrfs/scrub.c   | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fecc64d8e285..66712610d143 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1074,7 +1074,7 @@ struct btrfs_fs_info {
 	atomic_t scrubs_paused;
 	atomic_t scrub_cancel_req;
 	wait_queue_head_t scrub_pause_wait;
-	int scrub_workers_refcnt;
+	refcount_t scrub_workers_refcnt;
 	struct btrfs_workqueue *scrub_workers;
 	struct btrfs_workqueue *scrub_wr_completion_workers;
 	struct btrfs_workqueue *scrub_nocow_workers;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index de4b7ed02da1..5801e798895f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2109,7 +2109,7 @@ static void btrfs_init_scrub(struct btrfs_fs_info *fs_info)
 	atomic_set(&fs_info->scrubs_paused, 0);
 	atomic_set(&fs_info->scrub_cancel_req, 0);
 	init_waitqueue_head(&fs_info->scrub_pause_wait);
-	fs_info->scrub_workers_refcnt = 0;
+	refcount_set(&fs_info->scrub_workers_refcnt, 0);
 }
 
 static void btrfs_init_balance(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 17925af759ae..ccec3b4bc40b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3743,7 +3743,7 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 
 	lockdep_assert_held(&fs_info->scrub_lock);
 
-	if (fs_info->scrub_workers_refcnt == 0) {
+	if (refcount_read(&fs_info->scrub_workers_refcnt) == 0) {
 		fs_info->scrub_workers = btrfs_alloc_workqueue(fs_info, "scrub",
 				flags, is_dev_replace ? 1 : max_active, 4);
 		if (!fs_info->scrub_workers)
@@ -3761,7 +3761,7 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 		if (!fs_info->scrub_parity_workers)
 			goto fail_scrub_parity_workers;
 	}
-	++fs_info->scrub_workers_refcnt;
+	refcount_inc(&fs_info->scrub_workers_refcnt);
 	return 0;
 
 fail_scrub_parity_workers:
@@ -3927,7 +3927,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 
 	mutex_lock(&fs_info->scrub_lock);
 	dev->scrub_ctx = NULL;
-	if (--fs_info->scrub_workers_refcnt == 0) {
+	if (refcount_dec_and_test(&fs_info->scrub_workers_refcnt)) {
 		scrub_workers = fs_info->scrub_workers;
 		scrub_wr_comp = fs_info->scrub_wr_completion_workers;
 		scrub_parity = fs_info->scrub_parity_workers;
-- 
1.8.3.1

