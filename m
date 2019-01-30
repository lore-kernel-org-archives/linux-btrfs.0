Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF15C282D5
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 06:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B26720989
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 06:45:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yBEqimaf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfA3GpQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 01:45:16 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49148 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfA3GpQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 01:45:16 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0U6cbqm064369
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 06:45:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=EoKloWVoveGfAdEyFFFIUrNT7uCxEfm1kLE3Nf6BATU=;
 b=yBEqimafjk86XRz6KdsTZAwTJ9zRjjS5pBaNA/Sd4aFp7T8v8eFCzSMkMg778UY0aba1
 Pb0ikuCpx+XTXAGQygcpgRcmJkq37+r6GFs4IMbptPoKfTp6lsYbyU5Fz1ffhp/cYKY1
 9UpJy10RTEB5XMjEN+CGyim/He+5c+/TrHOnoC/Jnx/S5oLFpYOno62csgWKlhmXskiC
 gDgWDw9hh50RnAHvy1c6n0axznwJa/GgvNenTZcrEaD8YYFAw6dCV3VlEtVHps/9EFVR
 h7TaKlGuiNomOjrsqpD1D2kQa4u3dNk2hhtIQmbOafeWR0EHHhVq2ZsmZak7zKkTfSaL Gw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2q8g6r8k6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 06:45:14 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0U6jD1O025609
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 06:45:13 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0U6jDp8012796
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 06:45:13 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Jan 2019 22:45:12 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 2/3] btrfs: scrub: add scrub_lock lockdep check in scrub_workers_get
Date:   Wed, 30 Jan 2019 14:45:01 +0800
Message-Id: <1548830702-14676-3-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
References: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9151 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=993
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901300051
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

scrub_workers_refcnt is protected by scrub_lock, add lockdep_assert_held()
in scrub_workers_get().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Suggested-by: Nikolay Borisov <nborisov@suse.com>
---
v4: none
v3: none
v2: born
 fs/btrfs/scrub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f2f0be7864b8..17925af759ae 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3741,6 +3741,8 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 	unsigned int flags = WQ_FREEZABLE | WQ_UNBOUND;
 	int max_active = fs_info->thread_pool_size;
 
+	lockdep_assert_held(&fs_info->scrub_lock);
+
 	if (fs_info->scrub_workers_refcnt == 0) {
 		fs_info->scrub_workers = btrfs_alloc_workqueue(fs_info, "scrub",
 				flags, is_dev_replace ? 1 : max_active, 4);
-- 
1.8.3.1

