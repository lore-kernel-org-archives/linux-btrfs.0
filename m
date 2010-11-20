From: Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] btrfs: make 1-bit signed fileds unsigned
Date: Sat, 20 Nov 2010 13:03:07 +0100
Message-ID: <1290254587-12185-1-git-send-email-mk@lab.zgora.pl>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mariusz Kozlowski <mk@lab.zgora.pl>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fixes these sparse warnings:
fs/btrfs/ctree.h:811:17: error: dubious one-bit signed bitfield
fs/btrfs/ctree.h:812:20: error: dubious one-bit signed bitfield
fs/btrfs/ctree.h:813:19: error: dubious one-bit signed bitfield

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 fs/btrfs/ctree.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8db9234..af52f6d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -808,9 +808,9 @@ struct btrfs_block_group_cache {
 	int extents_thresh;
 	int free_extents;
 	int total_bitmaps;
-	int ro:1;
-	int dirty:1;
-	int iref:1;
+	unsigned int ro:1;
+	unsigned int dirty:1;
+	unsigned int iref:1;
 
 	int disk_cache_state;
 
-- 
1.7.0.4
