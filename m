From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 11/21] Btrfs: virtual address space subset filter
Date: Fri,  6 Jan 2012 16:30:59 +0200
Message-ID: <1325860269-15013-12-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Select chunks which have at least one byte located inside a given
[vstart, vend) virtual address space range.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   20 ++++++++++++++++++++
 fs/btrfs/volumes.h |    1 +
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a5a2d65..719e61d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2206,6 +2206,20 @@ static int chunk_drange_filter(struct extent_buffer *leaf,
 	return 1;
 }
 
+/* [vstart, vend) */
+static int chunk_vrange_filter(struct extent_buffer *leaf,
+			       struct btrfs_chunk *chunk,
+			       u64 chunk_offset,
+			       struct btrfs_balance_args *bargs)
+{
+	if (chunk_offset < bargs->vend &&
+	    chunk_offset + btrfs_chunk_length(leaf, chunk) > bargs->vstart)
+		/* at least part of the chunk is inside this vrange */
+		return 0;
+
+	return 1;
+}
+
 static int should_balance_chunk(struct btrfs_root *root,
 				struct extent_buffer *leaf,
 				struct btrfs_chunk *chunk, u64 chunk_offset)
@@ -2251,6 +2265,12 @@ static int should_balance_chunk(struct btrfs_root *root,
 		return 0;
 	}
 
+	/* vrange filter */
+	if ((bargs->flags & BTRFS_BALANCE_ARGS_VRANGE) &&
+	    chunk_vrange_filter(leaf, chunk, chunk_offset, bargs)) {
+		return 0;
+	}
+
 	return 1;
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 75fb5f2..879afcb 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -203,6 +203,7 @@ struct map_lookup {
 #define BTRFS_BALANCE_ARGS_USAGE	(1ULL << 1)
 #define BTRFS_BALANCE_ARGS_DEVID	(1ULL << 2)
 #define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
+#define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
 
 struct btrfs_balance_args;
 struct btrfs_balance_control {
-- 
1.7.6.3

