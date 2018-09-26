Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AFBC43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 08:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A5BE206B2
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 08:48:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A5BE206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbeIZPAJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 11:00:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13120 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726593AbeIZPAJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 11:00:09 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3871D644D8620;
        Wed, 26 Sep 2018 16:48:15 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.399.0; Wed, 26 Sep 2018 16:48:12 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <dsterba@suse.com>
CC:     <jbacik@fb.com>, <clm@fb.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs: list usage cleanup
Date:   Wed, 26 Sep 2018 16:35:45 +0800
Message-ID: <1537950945-5627-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Trival cleanup, list_move_tail will implement the same function that
list_del() + list_add_tail() will do. hence just replace them.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 fs/btrfs/send.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 094cc144..d87f416 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2075,8 +2075,7 @@ static struct name_cache_entry *name_cache_search(struct send_ctx *sctx,
  */
 static void name_cache_used(struct send_ctx *sctx, struct name_cache_entry *nce)
 {
-	list_del(&nce->list);
-	list_add_tail(&nce->list, &sctx->name_cache_list);
+	list_move_tail(&nce->list, &sctx->name_cache_list);
 }
 
 /*
-- 
1.7.12.4

