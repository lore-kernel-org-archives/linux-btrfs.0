Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay105.isp.belgacom.be ([195.238.20.132]:26474 "EHLO
        mailrelay105.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1432713AbdDYSLK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 14:11:10 -0400
From: Fabian Frederick <fabf@skynet.be>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, fabf@skynet.be
Subject: [PATCH 1/1 linux-next] btrfs: kmap() can't fail
Date: Tue, 25 Apr 2017 20:11:02 +0200
Message-Id: <20170425181102.2326-1-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove NULL test on kmap()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/btrfs/check-integrity.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index ab14c2e..496eb00 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1668,14 +1668,8 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 		dev_bytenr += (j - i) * PAGE_SIZE;
 		i = j;
 	}
-	for (i = 0; i < num_pages; i++) {
+	for (i = 0; i < num_pages; i++)
 		block_ctx->datav[i] = kmap(block_ctx->pagev[i]);
-		if (!block_ctx->datav[i]) {
-			pr_info("btrfsic: kmap() failed (dev %s)!\n",
-			       block_ctx->dev->name);
-			return -1;
-		}
-	}
 
 	return block_ctx->len;
 }
-- 
2.9.3

