Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92868EB64DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Jun 2023 06:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbjFNGkZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 02:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243307AbjFNGkP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Jun 2023 02:40:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9927F19A
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Jun 2023 23:40:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5B0921FDD0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Jun 2023 06:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686724813; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=q6EflSwVaCCgERqFCix7EZAsY6euS8uKgjjHp8GqABQ=;
        b=bLemwJXLyBjmrLeJ24YbDUSmCT1OyXDWCNcO1MsA2aoqjEckZpg/s3g2RfH6QBOd65z2Xp
        j0gJ/18Qp/SbM7WWDOJ843yUMhYAD21pU3vOj0uMOGxAKwny5Q29bRmLHftD1eVNUEga7I
        TIpWPVB87xe2yTH8ZFF0R5Jq5Bxgibg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B5EC11357F
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Jun 2023 06:40:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VoU+IMxgiWStBAAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Jun 2023 06:40:12 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: scrub: remove unused btrfs_path in scrub_simple_mirror()
Date:   Wed, 14 Jun 2023 14:39:55 +0800
Message-ID: <9a09b2850b25de2eb9142d95bcdb1b46ff0207af.1686724789.git.wqu@suse.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The @path in scrub_simple_mirror() is no longer utilized after commit
e02ee89baa66 ("btrfs: scrub: switch scrub_simple_mirror() to scrub_stripe
infrastructure").

Before that commit, we call find_first_extent_item() directly, which
needs a path and that path can be reused.

But after that switch commit, the extent search is done inside
queue_scrub_stripe(), which will no longer accept a path from outside.

So the @path variable can be removed safed.

Fixes: e02ee89baa66 ("btrfs: scrub: switch scrub_simple_mirror() to scrub_stripe infrastructure")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/scrub.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 7bd446720104..be6efe9f3b55 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1958,15 +1958,12 @@ static int scrub_simple_mirror(struct scrub_ctx *sctx,
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	const u64 logical_end = logical_start + logical_length;
 	/* An artificial limit, inherit from old scrub behavior */
-	struct btrfs_path path = { 0 };
 	u64 cur_logical = logical_start;
 	int ret;
 
 	/* The range must be inside the bg */
 	ASSERT(logical_start >= bg->start && logical_end <= bg->start + bg->length);
 
-	path.search_commit_root = 1;
-	path.skip_locking = 1;
 	/* Go through each extent items inside the logical range */
 	while (cur_logical < logical_end) {
 		u64 cur_physical = physical + cur_logical - logical_start;
@@ -2010,7 +2007,6 @@ static int scrub_simple_mirror(struct scrub_ctx *sctx,
 		/* Don't hold CPU for too long time */
 		cond_resched();
 	}
-	btrfs_release_path(&path);
 	return ret;
 }
 
-- 
2.41.0

