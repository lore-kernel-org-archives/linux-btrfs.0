Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:54416 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbaEaXsr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 19:48:47 -0400
Received: by mail-wi0-f181.google.com with SMTP id n15so2860618wiw.2
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 16:48:46 -0700 (PDT)
From: Philip Worrall <philip.worrall@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Philip Worrall <philip.worrall@googlemail.com>
Subject: [PATCH 3/8] Btrfs: Add lz4 compression to avaialble compression ops
Date: Sat, 31 May 2014 23:48:31 +0000
Message-Id: <1401580116-10458-4-git-send-email-philip.worrall@googlemail.com>
In-Reply-To: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
References: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add lz4 compression structure to available btrfs compression
operations.

Signed-off-by: Philip Worrall <philip.worrall@googlemail.com>
---
 fs/btrfs/compression.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ed1ff1c..35b3268 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -747,6 +747,7 @@ static wait_queue_head_t comp_workspace_wait[BTRFS_COMPRESS_TYPES];
 static struct btrfs_compress_op *btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
 	&btrfs_lzo_compress,
+	&btrfs_lz4_compress,
 };
 
 void __init btrfs_init_compress(void)
-- 
1.9.1

