Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37270 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752407AbeDSBDV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 21:03:21 -0400
From: Howard McLauchlan <hmclauchlan@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, <kernel-team@fb.com>,
        Howard McLauchlan <hmclauchlan@fb.com>
Subject: [PATCH v2 3/3] btrfs: remove le_test_bit()
Date: Wed, 18 Apr 2018 18:02:37 -0700
Message-ID: <20180419010237.30960-3-hmclauchlan@fb.com>
In-Reply-To: <20180419010237.30960-1-hmclauchlan@fb.com>
References: <20180419010237.30960-1-hmclauchlan@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With commit b18253ec57c0 ("btrfs: optimize free space tree bitmap
conversion"), there are no more callers to le_test_bit(). This patch
removes le_test_bit().

Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
---
 fs/btrfs/extent_io.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d34416c831bf..c5e80d60d71b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -79,11 +79,6 @@
 #define BITMAP_LAST_BYTE_MASK(nbits) \
 	(BYTE_MASK >> (-(nbits) & (BITS_PER_BYTE - 1)))
 
-static inline int le_test_bit(int nr, const u8 *addr)
-{
-	return 1U & (addr[BIT_BYTE(nr)] >> (nr & (BITS_PER_BYTE-1)));
-}
-
 struct extent_state;
 struct btrfs_root;
 struct btrfs_inode;
-- 
2.17.0

