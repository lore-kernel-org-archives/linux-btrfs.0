Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83514C433DB
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Jan 2021 08:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 531172395B
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Jan 2021 08:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbhAUIU5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 03:20:57 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:39035 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727783AbhAUIUn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jan 2021 03:20:43 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UMPXWIS_1611217189;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMPXWIS_1611217189)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 21 Jan 2021 16:19:55 +0800
From:   Yang Li <abaci-bugfix@linux.alibaba.com>
To:     clm@fb.com
Cc:     josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] btrfs: remove redundant NULL check
Date:   Thu, 21 Jan 2021 16:19:47 +0800
Message-Id: <1611217187-50142-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Fix below warnings reported by coccicheck:
./fs/btrfs/raid56.c:237:2-8: WARNING: NULL check before some freeing
functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
---
 fs/btrfs/raid56.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 93fbf87..5394641 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -233,8 +233,7 @@ int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info)
 	}
 
 	x = cmpxchg(&info->stripe_hash_table, NULL, table);
-	if (x)
-		kvfree(x);
+	kvfree(x);
 	return 0;
 }
 
-- 
1.8.3.1

