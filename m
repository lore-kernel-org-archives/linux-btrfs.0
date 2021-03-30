Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9E9C433DB
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Mar 2021 10:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FD54619AA
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Mar 2021 10:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhC3KRz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 06:17:55 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:49054 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231621AbhC3KRY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Mar 2021 06:17:24 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UTrIdsW_1617099435;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UTrIdsW_1617099435)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 30 Mar 2021 18:17:22 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     clm@fb.com
Cc:     josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] btrfs: Remove useless call "zlib_inflateEnd"
Date:   Tue, 30 Mar 2021 18:17:01 +0800
Message-Id: <1617099421-58511-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Fix the following whitescan warning:

Calling "zlib_inflateEnd(&workspace->strm)" is only useful for its
return value, which is ignored.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/btrfs/zlib.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index d524acf..93537cc 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -357,7 +357,6 @@ int zlib_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 	else
 		ret = 0;
 done:
-	zlib_inflateEnd(&workspace->strm);
 	if (data_in)
 		kunmap(pages_in[page_in_index]);
 	if (!ret)
-- 
1.8.3.1

