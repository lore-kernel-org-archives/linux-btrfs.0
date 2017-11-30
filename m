Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56469 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752676AbdK3QLC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 11:11:02 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B14E4AE7A
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 16:11:01 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: prop: use common helper for type to string conversion
Date: Thu, 30 Nov 2017 17:09:04 +0100
Message-Id: <1490b6426ee2552947ecf4b57779dd4f6011f032.1512058075.git.dsterba@suse.com>
In-Reply-To: <cover.1512058075.git.dsterba@suse.com>
References: <cover.1512058075.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the helper for conversion, keep the semantics.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/props.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index c39a940d0c75..b30a056963ab 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -423,11 +423,11 @@ static const char *prop_compression_extract(struct inode *inode)
 {
 	switch (BTRFS_I(inode)->prop_compress) {
 	case BTRFS_COMPRESS_ZLIB:
-		return "zlib";
 	case BTRFS_COMPRESS_LZO:
-		return "lzo";
 	case BTRFS_COMPRESS_ZSTD:
-		return "zstd";
+		return btrfs_compress_type2str(BTRFS_I(inode)->prop_compress);
+	default:
+		break;
 	}
 
 	return NULL;
-- 
2.15.0

