Return-Path: <SRS0=NtSv=ZH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CA1C43215
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Nov 2019 16:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A5A720692
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Nov 2019 16:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbfKOQRm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 11:17:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:36966 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727823AbfKOQRm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Nov 2019 11:17:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 78F42AC4A;
        Fri, 15 Nov 2019 16:17:40 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, hch@infradead.org,
        darrick.wong@oracle.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 7/7] btrfs: Wait for extent bits to release page
Date:   Fri, 15 Nov 2019 10:17:00 -0600
Message-Id: <20191115161700.12305-8-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191115161700.12305-1-rgoldwyn@suse.de>
References: <20191115161700.12305-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

While trying to release a page, the extent containing the page may be locked
which would stop the page from being released. Wait for the
extent lock to be cleared, if blocking is allowed and then clear
the bits.

This is avoid warnings coming iomap->dio_rw() ->
invalidate_inode_pages2_range() -> invalidate_complete_page2() ->
try_to_release_page() results in stale pagecache warning.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

---
 fs/btrfs/extent_io.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cceaf05aada2..57b37463da48 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4370,8 +4370,14 @@ static int try_release_extent_state(struct extent_io_tree *tree,
 	int ret = 1;
 
 	if (test_range_bit(tree, start, end, EXTENT_LOCKED, 0, NULL)) {
-		ret = 0;
+		if (gfpflags_allow_blocking(mask)) {
+			wait_extent_bit(tree, start, end, EXTENT_LOCKED);
+			goto clear_bits;
+		} else {
+			ret = 0;
+		}
 	} else {
+clear_bits:
 		/*
 		 * at this point we can safely clear everything except the
 		 * locked bit and the nodatasum bit
-- 
2.16.4

