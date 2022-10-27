Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F3FC38A2D
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Oct 2022 05:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbiJ0Fnz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 01:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbiJ0Fnx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2022 01:43:53 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E158813C1DA;
        Wed, 26 Oct 2022 22:43:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VTA368G_1666849427;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VTA368G_1666849427)
          by smtp.aliyun-inc.com;
          Thu, 27 Oct 2022 13:43:49 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     clm@fb.com
Cc:     josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next 2/3] btrfs: Remove duplicated include in free-space-cache.c
Date:   Thu, 27 Oct 2022 13:43:42 +0800
Message-Id: <20221027054343.9709-2-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
In-Reply-To: <20221027054343.9709-1-yang.lee@linux.alibaba.com>
References: <20221027054343.9709-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

./fs/btrfs/free-space-cache.c: fs.h is included more than once.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2601
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/btrfs/free-space-cache.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 7a182cc6dab7..26ff1a5100b9 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -26,7 +26,6 @@
 #include "discard.h"
 #include "subpage.h"
 #include "inode-item.h"
-#include "fs.h"
 #include "accessors.h"
 
 #define BITS_PER_BITMAP		(PAGE_SIZE * 8UL)
-- 
2.20.1.7.g153144c

