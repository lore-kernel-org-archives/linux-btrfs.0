Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21755 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752282AbdHMD4A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 23:56:00 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/4] btrfs: remove unused BTRFS_COMPRESS_LAST
Date: Sun, 13 Aug 2017 12:02:41 +0800
Message-Id: <20170813040244.18841-2-anand.jain@oracle.com>
In-Reply-To: <20170813040244.18841-1-anand.jain@oracle.com>
References: <20170813040244.18841-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We aren't using this define, so removing it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/compression.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 87f6d3332163..e749df6dd39a 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -100,7 +100,6 @@ enum btrfs_compression_type {
 	BTRFS_COMPRESS_ZLIB  = 1,
 	BTRFS_COMPRESS_LZO   = 2,
 	BTRFS_COMPRESS_TYPES = 2,
-	BTRFS_COMPRESS_LAST  = 3,
 };
 
 struct btrfs_compress_op {
-- 
2.13.1

