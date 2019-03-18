Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F485C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 15:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECB2220872
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 15:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfCRPp0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:45:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:44280 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbfCRPpZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 11:45:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1713AAED5
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 15:45:24 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/3] btrfs: Remove unused -EIO assignment in end_bio_extent_readpage
Date:   Mon, 18 Mar 2019 17:45:18 +0200
Message-Id: <20190318154520.4086-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190318154520.4086-1-nborisov@suse.com>
References: <20190318154520.4086-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In case we hit the error case for a metadata buffer in
end_bio_extent_readpage then 'ret' won't really be checked before it's
written again to. This means the -EIO in this case will never be
checked, just remove it.

Fixes-coverity-id: 1442513
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a04e0328f1bb..49af6d2a2a11 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2705,8 +2705,6 @@ static void end_bio_extent_readpage(struct bio *bio)
 			if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD,
 					       &eb->bflags))
 				btree_readahead_hook(eb, -EIO);
-
-			ret = -EIO;
 		}
 readpage_ok:
 		if (likely(uptodate)) {
-- 
2.17.1

