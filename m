Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42463 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaEaXsp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 19:48:45 -0400
Received: by mail-we0-f174.google.com with SMTP id k48so3638697wev.33
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 16:48:44 -0700 (PDT)
From: Philip Worrall <philip.worrall@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Philip Worrall <philip.worrall@googlemail.com>
Subject: [PATCH 1/8] Btrfs: Add kernel config options for LZ4
Date: Sat, 31 May 2014 23:48:29 +0000
Message-Id: <1401580116-10458-2-git-send-email-philip.worrall@googlemail.com>
In-Reply-To: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
References: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add two kernel configuration options for LZ4 compress
and decompress.

Signed-off-by: Philip Worrall <philip.worrall@googlemail.com>
---
 fs/btrfs/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index a66768e..fb93d9e 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -6,6 +6,8 @@ config BTRFS_FS
 	select ZLIB_DEFLATE
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
+	select LZ4_COMPRESS
+	select LZ4_DECOMPRESS
 	select RAID6_PQ
 	select XOR_BLOCKS
 
-- 
1.9.1

