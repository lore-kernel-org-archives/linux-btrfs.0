Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:35550 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369AbaJNRqW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 13:46:22 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: [RFC 1/1 linux-next] btrfs: don't opencode zero_user_segment
Date: Tue, 14 Oct 2014 19:46:14 +0200
Message-Id: <1413308774-9985-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

use function defined in include/linux/highmem.h
Note that this reverts 2 last function call order

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/btrfs/scrub.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index efa0831..fa063cd 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1503,13 +1503,9 @@ static int scrub_write_page_to_dev_replace(struct scrub_block *sblock,
 	struct scrub_page *spage = sblock->pagev[page_num];
 
 	BUG_ON(spage->page == NULL);
-	if (spage->io_error) {
-		void *mapped_buffer = kmap_atomic(spage->page);
+	if (spage->io_error)
+		zero_user_segment(spage->page, 0, PAGE_CACHE_SIZE);
 
-		memset(mapped_buffer, 0, PAGE_CACHE_SIZE);
-		flush_dcache_page(spage->page);
-		kunmap_atomic(mapped_buffer);
-	}
 	return scrub_add_page_to_wr_bio(sblock->sctx, spage);
 }
 
-- 
1.9.3

