Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD768C04EB8
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 05:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A044D20863
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 05:15:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bu4lrHr/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A044D20863
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbeK3QX7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 11:23:59 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54318 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbeK3QX7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 11:23:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAU5EA8s116496
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 05:15:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=FWdlc5d43H8ZCI1iFEEDqdt3SetZZGt5ScNJJZsEQK0=;
 b=Bu4lrHr/JnXL7y11Ub+o8k7D3gr9NE2HxPyemEhVkQu0p+1U9+jFiNQdnnXkFP3ArOk6
 8jnYGUOeljjoxugPJChw/H2gp+1myuD3uDeu5ArehnGCw8QKqOQs47n43lMJZ/H2VPwQ
 mC0/AJ1wwq7FEHa48iEZGxEIIQBaPDmFbiCKBsTB0TRH622X7OiF232ELW+QX7pDHbgB
 ajdQvnzFr7tWwV4ePajXeH+W6fwe0d60B6Kk8LaohENLwiw3KcBF1kknEkMyRemaRwjE
 Mv1bSZS/QDgVqzKGalsVgCnTZs2CSmvCeikaaPulrTYlAJ6ehtJ+cLM1fsl0jHKTbJj8 xg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2nxy9rkxrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 05:15:54 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAU5FrTd003076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 05:15:53 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAU5Fr5u029612
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 05:15:53 GMT
Received: from tpasj.localdomain (/202.156.140.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Nov 2018 21:15:52 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/2] btrfs: scrub: add scrub_lock lockdep check in scrub_workers_get
Date:   Fri, 30 Nov 2018 13:15:24 +0800
Message-Id: <1543554924-17397-3-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1543554924-17397-1-git-send-email-anand.jain@oracle.com>
References: <1543554924-17397-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9092 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=972
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811300043
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

scrub_workers_refcnt is protected by scrub_lock, add lockdep_assert_held()
function in scrub_workers_get().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Suggested-by: Nikolay Borisov <nborisov@suse.com>
---
v3: none
v2: born
 fs/btrfs/scrub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9ade0659f017..84ef1f0d371e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3726,6 +3726,8 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 	unsigned int flags = WQ_FREEZABLE | WQ_UNBOUND;
 	int max_active = fs_info->thread_pool_size;
 
+	lockdep_assert_held(&fs_info->scrub_lock);
+
 	if (fs_info->scrub_workers_refcnt == 0) {
 		fs_info->scrub_workers = btrfs_alloc_workqueue(fs_info, "scrub",
 				flags, is_dev_replace ? 1 : max_active, 4);
-- 
1.8.3.1

