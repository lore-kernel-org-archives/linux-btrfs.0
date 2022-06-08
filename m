Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF39AC433EF
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Jun 2022 04:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbiFHEIA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 00:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236752AbiFHEGQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jun 2022 00:06:16 -0400
Received: from out199-13.us.a.mail.aliyun.com (out199-13.us.a.mail.aliyun.com [47.90.199.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E1829C13F;
        Tue,  7 Jun 2022 18:24:28 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VFhsKWe_1654651319;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VFhsKWe_1654651319)
          by smtp.aliyun-inc.com;
          Wed, 08 Jun 2022 09:22:00 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     clm@fb.com
Cc:     josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] btrfs: Remove the unused function scrub_calc_parity_bitmap_len()
Date:   Wed,  8 Jun 2022 09:21:58 +0800
Message-Id: <20220608012158.109334-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

bitmap_len = scrub_calc_parity_bitmap_len(), the only call point of this
function has been deleted, so it should also be removed.

Fix the following W=1 kernel warning:
fs/btrfs/scrub.c:2857:19: warning: unused function 'scrub_calc_parity_bitmap_len'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/btrfs/scrub.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 46cac7c7f292..db700e6ec5a9 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2854,11 +2854,6 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 	scrub_free_parity(sparity);
 }
 
-static inline int scrub_calc_parity_bitmap_len(int nsectors)
-{
-	return DIV_ROUND_UP(nsectors, BITS_PER_LONG) * sizeof(long);
-}
-
 static void scrub_parity_get(struct scrub_parity *sparity)
 {
 	refcount_inc(&sparity->refs);
-- 
2.20.1.7.g153144c

