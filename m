From: "Dirk Gouders" <gouders@et.bocholt.fh-gelsenkirchen.de>
Subject: [PATCH] btrfs-progs: Double definition of BTRFS_CSUM_TYPE_CRC32
Date: Tue,  6 Oct 2009 12:56:02 +0200
Message-ID: <1254826562-3793-1-git-send-email-gouders@et.bocholt.fh-gelsenkirchen.de>
References: <gifx9x6964.fsf@sora.hank.home>
Cc: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <gifx9x6964.fsf@sora.hank.home>
List-ID: <linux-btrfs.vger.kernel.org>

Clean up multiple definition of BTRFS_CSUM_TYPE_CRC32 in ctree.h.
---
 ctree.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/ctree.h b/ctree.h
index a9062ea..fec0d9e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -108,10 +108,6 @@ struct btrfs_trans_handle;
 /* csum types */
 #define BTRFS_CSUM_TYPE_CRC32	0
 
-
-/* csum types */
-#define BTRFS_CSUM_TYPE_CRC32	0
-
 static int btrfs_csum_sizes[] = { 4, 0 };
 
 /* four bytes for CRC32 */
-- 
1.6.5.rc1

