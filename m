Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2FDC169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 08:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEC1320863
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 08:38:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="4QmMhOpu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfBKIid (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 03:38:33 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41048 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfBKIid (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 03:38:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1B8YMTm117101
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 08:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=dUGQiFSJ4HUQmWLyS4Rj9Ndoox9+iEEMnTuTtTUjbfI=;
 b=4QmMhOpu0JWcVLp/oqHWXL0EeppitsKpem3bnYXN+PHv3+Z3YfnpS/3rVsnGklfzGtxV
 zxWg5EcTDL+/8ohjc0JXXAbPF7zVF8Xjy6KOcbsknZwhPLq3KDwVeuNPRNhNOzyAuXJO
 2OckK6Ho2gA8nY+9Ef2PnA0wWSEsYWU6ngVVAG9VSVy+eQ+kLG1Brbvkb66/kAS6gBlc
 hy+liFjKS2viU6g1pU1XAWf6AQUSu7HaiRsSZjgnp9QcKY/Aey4YnUctfZ/IdPOsEsxt
 PptwR+yyH3L0hhdLhT/1ZKva9VVJfCvNjVEmw3/qSljDUNnjubg+cahH4UM94oE52uYI ww== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2qhrek49ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 08:38:31 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1B8cUx8004465
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 08:38:30 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1B8cUwi016102
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 08:38:30 GMT
Received: from tpasj.localdomain (/183.90.37.91)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Feb 2019 00:38:30 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5 3/3] btrfs: scrub: convert scrub_workers_refcnt to refcount_t
Date:   Mon, 11 Feb 2019 16:38:19 +0800
Message-Id: <1549874299-15799-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
References: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9163 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902110067
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Use the refcount_t for fs_info::scrub_workers_refcnt instead of int.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v5: Fix refcount validation warning.
    Use refcount_set() instead of refcount_inc() when count is 0.
v4: born
 fs/btrfs/ctree.h   |  2 +-
 fs/btrfs/disk-io.c |  2 +-
 fs/btrfs/scrub.c   | 10 +++++++---
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2399f56d8a54..d53fb37aaed0 100644
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
index 4047867473e1..76701b21ab77 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2111,7 +2111,7 @@ static void btrfs_init_scrub(struct btrfs_fs_info *fs_info)
 	atomic_set(&fs_info->scrubs_paused, 0);
 	atomic_set(&fs_info->scrub_cancel_req, 0);
 	init_waitqueue_head(&fs_info->scrub_pause_wait);
-	fs_info->scrub_workers_refcnt = 0;
+	refcount_set(&fs_info->scrub_workers_refcnt, 0);
 }
 
 static void btrfs_init_balance(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 17925af759ae..bf2294798b6c 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3743,7 +3743,7 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 
 	lockdep_assert_held(&fs_info->scrub_lock);
 
-	if (fs_info->scrub_workers_refcnt == 0) {
+	if (refcount_read(&fs_info->scrub_workers_refcnt) == 0) {
 		fs_info->scrub_workers = btrfs_alloc_workqueue(fs_info, "scrub",
 				flags, is_dev_replace ? 1 : max_active, 4);
 		if (!fs_info->scrub_workers)
@@ -3760,8 +3760,12 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 					      max_active, 2);
 		if (!fs_info->scrub_parity_workers)
 			goto fail_scrub_parity_workers;
+
+		refcount_set(&fs_info->scrub_workers_refcnt, 1);
+	} else {
+		refcount_inc(&fs_info->scrub_workers_refcnt);
 	}
-	++fs_info->scrub_workers_refcnt;
+
 	return 0;
 
 fail_scrub_parity_workers:
@@ -3927,7 +3931,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 
 	mutex_lock(&fs_info->scrub_lock);
 	dev->scrub_ctx = NULL;
-	if (--fs_info->scrub_workers_refcnt == 0) {
+	if (refcount_dec_and_test(&fs_info->scrub_workers_refcnt)) {
 		scrub_workers = fs_info->scrub_workers;
 		scrub_wr_comp = fs_info->scrub_wr_completion_workers;
 		scrub_parity = fs_info->scrub_parity_workers;
-- 
1.8.3.1

