From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] btrfs-progs: cleanup: remove the redundant BTRFS_CSUM_TYPE_CRC32
 macro definition in ctree.h
Date: Mon, 05 Mar 2012 13:33:59 +0800
Message-ID: <4F545047.3040404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 ctree.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/ctree.h b/ctree.h
index 54748c8..1b17577 100644
--- a/ctree.h
+++ b/ctree.h
@@ -118,10 +118,6 @@ struct btrfs_trans_handle;
 /* csum types */
 #define BTRFS_CSUM_TYPE_CRC32	0
 
-
-/* csum types */
-#define BTRFS_CSUM_TYPE_CRC32	0
-
 static int btrfs_csum_sizes[] = { 4, 0 };
 
 /* four bytes for CRC32 */
-- 
1.7.1
