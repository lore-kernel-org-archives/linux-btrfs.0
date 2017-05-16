Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42882 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752653AbdEPRLm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:11:42 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 65536AB5F
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:11:41 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 08/10] btrfs: scrub: clean up division in __scrub_mark_bitmap
Date: Tue, 16 May 2017 19:10:44 +0200
Message-Id: <5c884ff04ced7f2a8e52fc7ca96e32c6d344b9de.1494954480.git.dsterba@suse.com>
In-Reply-To: <cover.1494954480.git.dsterba@suse.com>
References: <cover.1494954480.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use proper helpers for 64bit division and then cast to narrower type.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 5b135df691fa..a2366f041f47 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2627,7 +2627,8 @@ static inline void __scrub_mark_bitmap(struct scrub_parity *sparity,
 				       u64 start, u64 len)
 {
 	u64 offset;
-	int nsectors;
+	u64 nsectors64;
+	u32 nsectors;
 	int sectorsize = sparity->sctx->fs_info->sectorsize;
 
 	if (len >= sparity->stripe_len) {
@@ -2638,7 +2639,10 @@ static inline void __scrub_mark_bitmap(struct scrub_parity *sparity,
 	start -= sparity->logic_start;
 	start = div64_u64_rem(start, sparity->stripe_len, &offset);
 	offset = div_u64(offset, sectorsize);
-	nsectors = (int)len / sectorsize;
+	nsectors64 = div_u64(len, sectorsize);
+
+	ASSERT(nsectors64 < UINT_MAX);
+	nsectors = (u32)nsectors64;
 
 	if (offset + nsectors <= sparity->nsectors) {
 		bitmap_set(bitmap, offset, nsectors);
-- 
2.12.0

