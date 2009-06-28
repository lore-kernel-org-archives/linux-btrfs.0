From: Joe Perches <joe@perches.com>
Subject: [PATCH 55/62] fs/btrfs/tree-log.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:27:00 -0700
Message-ID: <34cccfc85bd4e32bfcc1f345d9fdb087f1afc015.1246173683.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1246173664.git.joe@perches.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/btrfs/tree-log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c139222..ab326dd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2605,7 +2605,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 								extent);
 				cs = btrfs_file_extent_offset(src, extent);
 				cl = btrfs_file_extent_num_bytes(src,
-								extent);;
+								extent);
 				if (btrfs_file_extent_compression(src,
 								  extent)) {
 					cs = 0;
-- 
1.6.3.1.10.g659a0.dirty

