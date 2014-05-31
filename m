Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57636 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbaEaXss (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 19:48:48 -0400
Received: by mail-wi0-f171.google.com with SMTP id cc10so2779813wib.10
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 16:48:47 -0700 (PDT)
From: Philip Worrall <philip.worrall@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Philip Worrall <philip.worrall@googlemail.com>
Subject: [PATCH 4/8] Btrfs: Add definition for external lz4 compression struct
Date: Sat, 31 May 2014 23:48:32 +0000
Message-Id: <1401580116-10458-5-git-send-email-philip.worrall@googlemail.com>
In-Reply-To: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
References: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Philip Worrall <philip.worrall@googlemail.com>
---
 fs/btrfs/compression.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 0c803b4..c39b86a 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -77,5 +77,5 @@ struct btrfs_compress_op {
 
 extern struct btrfs_compress_op btrfs_zlib_compress;
 extern struct btrfs_compress_op btrfs_lzo_compress;
-
+extern struct btrfs_compress_op btrfs_lz4_compress;
 #endif
-- 
1.9.1

