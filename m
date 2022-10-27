Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65028FA3740
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Oct 2022 05:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbiJ0FoT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 01:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbiJ0Fnz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2022 01:43:55 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EA6148FDF;
        Wed, 26 Oct 2022 22:43:54 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VT9o96n_1666849430;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VT9o96n_1666849430)
          by smtp.aliyun-inc.com;
          Thu, 27 Oct 2022 13:43:51 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     clm@fb.com
Cc:     josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next 3/3] btrfs: Remove duplicated include in delayed-inode.c
Date:   Thu, 27 Oct 2022 13:43:43 +0800
Message-Id: <20221027054343.9709-3-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
In-Reply-To: <20221027054343.9709-1-yang.lee@linux.alibaba.com>
References: <20221027054343.9709-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

./fs/btrfs/delayed-inode.c: fs.h is included more than once.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2602
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/btrfs/delayed-inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index a935709f2a29..f93d2695e423 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -17,7 +17,6 @@
 #include "locking.h"
 #include "inode-item.h"
 #include "space-info.h"
-#include "fs.h"
 #include "accessors.h"
 
 #define BTRFS_DELAYED_WRITEBACK		512
-- 
2.20.1.7.g153144c

