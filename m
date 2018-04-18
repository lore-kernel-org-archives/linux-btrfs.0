Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43770 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751256AbeDRVb7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 17:31:59 -0400
From: Howard McLauchlan <hmclauchlan@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, <kernel-team@fb.com>,
        Howard McLauchlan <hmclauchlan@fb.com>
Subject: [PATCH 1/2] btrfs: remove le_bitmap_clear()
Date: Wed, 18 Apr 2018 14:30:58 -0700
Message-ID: <20180418213059.8025-1-hmclauchlan@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

le_bitmap_clear() was implemented as a parallel to le_bitmap_set() but
is actually not being used. This patch removes it.

Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
---
 fs/btrfs/extent_io.c | 20 --------------------
 fs/btrfs/extent_io.h |  1 -
 2 files changed, 21 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e99b329002cf..cf50278f1c59 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5640,26 +5640,6 @@ void le_bitmap_set(u8 *map, unsigned int start, int len)
 	}
 }
 
-void le_bitmap_clear(u8 *map, unsigned int start, int len)
-{
-	u8 *p = map + BIT_BYTE(start);
-	const unsigned int size = start + len;
-	int bits_to_clear = BITS_PER_BYTE - (start % BITS_PER_BYTE);
-	u8 mask_to_clear = BITMAP_FIRST_BYTE_MASK(start);
-
-	while (len - bits_to_clear >= 0) {
-		*p &= ~mask_to_clear;
-		len -= bits_to_clear;
-		bits_to_clear = BITS_PER_BYTE;
-		mask_to_clear = ~0;
-		p++;
-	}
-	if (len) {
-		mask_to_clear &= BITMAP_LAST_BYTE_MASK(size);
-		*p &= ~mask_to_clear;
-	}
-}
-
 /*
  * eb_bitmap_offset() - calculate the page and offset of the byte containing the
  * given bit number
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a53009694b16..4b8b072d9594 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -85,7 +85,6 @@ static inline int le_test_bit(int nr, const u8 *addr)
 }
 
 void le_bitmap_set(u8 *map, unsigned int start, int len);
-void le_bitmap_clear(u8 *map, unsigned int start, int len);
 
 struct extent_state;
 struct btrfs_root;
-- 
2.17.0

