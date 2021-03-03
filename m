Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5501BC4161F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2286864E68
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383097AbhCDATO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:19:14 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:58887 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356728AbhCCKsO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Mar 2021 05:48:14 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UQELT1u_1614764730;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UQELT1u_1614764730)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Mar 2021 17:45:37 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     clm@fb.com
Cc:     josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] btrfs: Assign boolean values to a bool variable
Date:   Wed,  3 Mar 2021 17:45:28 +0800
Message-Id: <1614764728-14857-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Fix the following coccicheck warnings:

./fs/btrfs/volumes.c:1462:10-11: WARNING: return of 0/1 in function
'dev_extent_hole_check_zoned' with return type bool.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bc3b33e..995920f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1458,8 +1458,8 @@ static bool dev_extent_hole_check_zoned(struct btrfs_device *device,
 		/* Given hole range was invalid (outside of device) */
 		if (ret == -ERANGE) {
 			*hole_start += *hole_size;
-			*hole_size = 0;
-			return 1;
+			*hole_size = false;
+			return true;
 		}
 
 		*hole_start += zone_size;
-- 
1.8.3.1

