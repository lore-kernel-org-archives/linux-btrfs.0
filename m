Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42908 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752838AbdEPRLz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:11:55 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 73B4DAD23
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:11:44 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 09/10] btrfs: scrub: clean up division in scrub_find_csum
Date: Tue, 16 May 2017 19:10:47 +0200
Message-Id: <f615ad73d675d47f6ac297484293f8647da23aa5.1494954480.git.dsterba@suse.com>
In-Reply-To: <cover.1494954480.git.dsterba@suse.com>
References: <cover.1494954480.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use proper helpers for 64bit division.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a2366f041f47..6c8c4535dc43 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2715,7 +2715,9 @@ static int scrub_find_csum(struct scrub_ctx *sctx, u64 logical, u8 *csum)
 	if (!sum)
 		return 0;
 
-	index = ((u32)(logical - sum->bytenr)) / sctx->fs_info->sectorsize;
+	index = div_u64(logical - sum->bytenr, sctx->fs_info->sectorsize);
+	ASSERT(index < UINT_MAX);
+
 	num_sectors = sum->len / sctx->fs_info->sectorsize;
 	memcpy(csum, sum->sums + index, sctx->csum_size);
 	if (index == num_sectors - 1) {
-- 
2.12.0

