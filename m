Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA7DC10F00
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 13:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54C0920663
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 13:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfBYNYc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 08:24:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:52246 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727224AbfBYNYb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 08:24:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E9736B014
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 13:24:29 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 2/2] btrfs: warn if extent buffer mapping crosses a page boundary in csum_tree_block
Date:   Mon, 25 Feb 2019 14:24:16 +0100
Message-Id: <20190225132416.15840-2-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190225132416.15840-1-jthumshirn@suse.de>
References: <20190225132416.15840-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since commit d2e174d5d3ee ("btrfs: document extent mapping assumptions in
checksum") we have a comment in place why map_private_extent_buffer() 
can't return 1 in the csum_tree_block() case.

Make this a bit more explicit and WARN_ON() in case this this assumption
breaks.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8090e8f4ccc2..21407252eb44 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -285,7 +285,7 @@ static int csum_tree_block(struct extent_buffer *buf,
 		 */
 		err = map_private_extent_buffer(buf, offset, 32,
 					&kaddr, &map_start, &map_len);
-		if (err)
+		if (WARN_ON(err))
 			return err;
 		cur_len = min(len, map_len - (offset - map_start));
 		crc = btrfs_csum_data(kaddr + offset - map_start,
-- 
2.16.4

