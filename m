Return-Path: <SRS0=ITJn=CR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 058E2C43461
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Sep 2020 07:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB62D20C09
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Sep 2020 07:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgIHHww (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 03:52:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:50938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbgIHHws (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Sep 2020 03:52:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 60014AE25
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2020 07:52:48 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 03/17] btrfs: remove the open-code to read disk-key
Date:   Tue,  8 Sep 2020 15:52:16 +0800
Message-Id: <20200908075230.86856-4-wqu@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908075230.86856-1-wqu@suse.com>
References: <20200908075230.86856-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is some ancient code from the old days where we handle the
disk_key read manually when the disk key is in one page.

But that's totally unnecessary, as we have read_extent_buffer() to
handle everything.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index cd1cd673bc0b..e204e1320745 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1697,7 +1697,6 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
 	}
 
 	while (low < high) {
-		unsigned long oip;
 		unsigned long offset;
 		struct btrfs_disk_key *tmp;
 		struct btrfs_disk_key unaligned;
@@ -1705,17 +1704,9 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
 
 		mid = (low + high) / 2;
 		offset = p + mid * item_size;
-		oip = offset_in_page(offset);
 
-		if (oip + key_size <= PAGE_SIZE) {
-			const unsigned long idx = offset >> PAGE_SHIFT;
-			char *kaddr = page_address(eb->pages[idx]);
-
-			tmp = (struct btrfs_disk_key *)(kaddr + oip);
-		} else {
-			read_extent_buffer(eb, &unaligned, offset, key_size);
-			tmp = &unaligned;
-		}
+		read_extent_buffer(eb, &unaligned, offset, key_size);
+		tmp = &unaligned;
 
 		ret = comp_keys(tmp, key);
 
-- 
2.28.0

