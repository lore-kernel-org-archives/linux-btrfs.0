Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06077C64EBC
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 05:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA90E213A2
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 05:01:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA90E213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbeJDLxB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 07:53:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13596 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726735AbeJDLxA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Oct 2018 07:53:00 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A106D93D90F1B;
        Thu,  4 Oct 2018 13:00:50 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.399.0; Thu, 4 Oct 2018 13:00:48 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <dsterba@suse.cz>
CC:     <osandov@osandov.com>, <dsterba@suse.com>, <jbacik@fb.com>,
        <clm@fb.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCHv2] btrfs: list usage cleanup
Date:   Thu, 4 Oct 2018 12:48:27 +0800
Message-ID: <1538628507-32593-1-git-send-email-zhongjiang@huawei.com>
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
 fs/btrfs/send.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 094cc144..30e7e12 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2075,8 +2075,8 @@ static struct name_cache_entry *name_cache_search(struct send_ctx *sctx,
  */
 static void name_cache_used(struct send_ctx *sctx, struct name_cache_entry *nce)
 {
-	list_del(&nce->list);
-	list_add_tail(&nce->list, &sctx->name_cache_list);
+	/* delete from sctx->name_cache_list and add as its tail */
+	list_move_tail(&nce->list, &sctx->name_cache_list);
 }
 
 /*
-- 
1.7.12.4

