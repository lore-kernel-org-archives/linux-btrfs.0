Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49477 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaEaXst (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 19:48:49 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so2858432wiw.2
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 16:48:48 -0700 (PDT)
From: Philip Worrall <philip.worrall@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Philip Worrall <philip.worrall@googlemail.com>
Subject: [PATCH 5/8] Btrfs: Add feature flags for LZ4 support
Date: Sat, 31 May 2014 23:48:33 +0000
Message-Id: <1401580116-10458-6-git-send-email-philip.worrall@googlemail.com>
In-Reply-To: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
References: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add various feature flags for LZ4 so that older kernels refuse
to mount btrfs filesystems that have been used with LZ4

Signed-off-by: Philip Worrall <philip.worrall@googlemail.com>
---
 fs/btrfs/ctree.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d8a669e..b5118cfa 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -523,6 +523,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZ4     (1ULL << 10)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
@@ -540,7 +541,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES	|	\
+	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZ4)
 
 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
 	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
@@ -709,8 +711,10 @@ enum btrfs_compression_type {
 	BTRFS_COMPRESS_NONE  = 0,
 	BTRFS_COMPRESS_ZLIB  = 1,
 	BTRFS_COMPRESS_LZO   = 2,
-	BTRFS_COMPRESS_TYPES = 2,
-	BTRFS_COMPRESS_LAST  = 3,
+	BTRFS_COMPRESS_LZ4   = 3,
+	BTRFS_COMPRESS_TYPES = 3,
+	BTRFS_COMPRESS_LAST  = 4,
+
 };
 
 struct btrfs_inode_item {
-- 
1.9.1

