Return-Path: <SRS0=iNTY=DP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D74C4363A
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Oct 2020 12:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5212B20659
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Oct 2020 12:24:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="TjnRFR6r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgJHMYf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 08:24:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:59524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729822AbgJHMYe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Oct 2020 08:24:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1602159873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7sZzHF12dVjWQvyAo2v4Tr9ckMm/xZXm5B0nhIiKano=;
        b=TjnRFR6rTHH70BtN84Gfs2glhYr5+Q7zBPCh9BOzoD5Xy4DynBvffiZ/s5NPT2wPuyZBsq
        R0NjWdOZUbHgyH/4RfrlbLd2MwUE+e6BQ4zApRwokyDwMbnXal7odV6SsMhfxH+gAF2iIY
        sLelvSb9L49mdGpbYIyImVk+WeO72Cg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 73A31AFDF;
        Thu,  8 Oct 2020 12:24:33 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/4] btrfs: Be smarter when sleeping in transaction_kthread
Date:   Thu,  8 Oct 2020 15:24:30 +0300
Message-Id: <20201008122430.93433-5-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201008122430.93433-1-nborisov@suse.com>
References: <20201008122430.93433-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If transaction_kthread is woken up before
btrfs_fs_info::commit_interval seconds have elapsed it will sleep for a
fixed period of 5 seconds. This is not a problem per-se but is not
accuaret, instead the code should sleep for an interval which guarantees
on next wakeup commit_interval would have passed. Since time tracking is
not accurate add 1 second to ensure next wake up would be after
commit_interval.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c5d3e7f75066..a1fe99cf0831 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1735,7 +1735,7 @@ static int transaction_kthread(void *arg)
 		if (cur->state < TRANS_STATE_COMMIT_START &&
 		    delta < fs_info->commit_interval) {
 			spin_unlock(&fs_info->trans_lock);
-			delay = msecs_to_jiffies(5000);
+			delay = msecs_to_jiffies((1+delta) * 1000);
 			goto sleep;
 		}
 		transid = cur->transid;
-- 
2.17.1

