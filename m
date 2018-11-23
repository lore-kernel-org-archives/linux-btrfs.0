Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E0BC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 01:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 144E1206B2
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 01:06:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 144E1206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439232AbeKWLsn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 06:48:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:36600 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439228AbeKWLsn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 06:48:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A1595AE25;
        Fri, 23 Nov 2018 01:06:39 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: Don't check max block group size as current max chunk size limit is unreliable
Date:   Fri, 23 Nov 2018 09:06:36 +0800
Message-Id: <20181123010636.19363-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
A completely valid btrfs will refuse to mount, with error message like:
  BTRFS critical (device sdb2): corrupt leaf: root=2 block=239681536 slot=172 \
    bg_start=12018974720 bg_len=10888413184, invalid block group size, \
    have 10888413184 expect (0, 10737418240]

Btrfs check returns no error, and all kernels used on this fs is later
than 2011, which should all have the 10G size limit commit.

[CAUSE]
For a 12 devices btrfs, we could allocate a chunk larger than 10G due to
stripe stripe bump up.

__btrfs_alloc_chunk()
|- max_stripe_size = 1G
|- max_chunk_size = 10G
|- data_stripe = 11
|- if (1G * 11 > 10G) {
       stripe_size = 976128930;
       stripe_size = round_up(976128930, SZ_16M) = 989855744

However the final stripe_size (989855744) * 11 = 10888413184, which is
still larger than 10G.

[FIX]
For the comprehensive check, we need to do the full check at chunk
read time, and rely on bg <-> chunk mapping to do the check.

We could just skip the length check for now.

Fixes: fce466eab7ac ("btrfs: tree-checker: Verify block_group_item")
Cc: stable@vger.kernel.org # v4.19+
Reported-by: Wang Yugui <wangyugui@e16-tech.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index cab0b1f1f741..d8bd5340fbbc 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -389,13 +389,11 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 
 	/*
 	 * Here we don't really care about alignment since extent allocator can
-	 * handle it.  We care more about the size, as if one block group is
-	 * larger than maximum size, it's must be some obvious corruption.
+	 * handle it.  We care more about the size.
 	 */
-	if (key->offset > BTRFS_MAX_DATA_CHUNK_SIZE || key->offset == 0) {
+	if (key->offset == 0) {
 		block_group_err(fs_info, leaf, slot,
-			"invalid block group size, have %llu expect (0, %llu]",
-				key->offset, BTRFS_MAX_DATA_CHUNK_SIZE);
+				"invalid block group size 0");
 		return -EUCLEAN;
 	}
 
-- 
2.19.1

