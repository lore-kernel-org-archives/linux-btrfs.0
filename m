From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/3] Btrfs: do not release more reserved bytes to the global_block_rsv than we need
Date: Mon, 24 Jan 2011 16:43:19 -0500
Message-ID: <1295905400-1417-3-git-send-email-josef@redhat.com>
References: <1295905400-1417-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1295905400-1417-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

When we do btrfs_block_rsv_release, if global_block_rsv is not full we will
release all the extra bytes to global_block_rsv, even if it's only a little
short of the amount of space that we need to reserve.  This causes us to starve
ourselves of reservable space during the transaction which will force us to
shrink delalloc bytes and commit the transaction more often than we should.  So
instead just add the amount of bytes we need to add to the global reserve so
reserved == size, and then add the rest back into the space_info for general
use.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7ad7bf2..7aed7bf 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3599,8 +3599,20 @@ void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
 
 	if (num_bytes > 0) {
 		if (dest) {
-			block_rsv_add_bytes(dest, num_bytes, 0);
-		} else {
+			spin_lock(&dest->lock);
+			if (!dest->full) {
+				u64 bytes_to_add;
+
+				bytes_to_add = dest->size - dest->reserved;
+				bytes_to_add = min(num_bytes, bytes_to_add);
+				dest->reserved += bytes_to_add;
+				if (dest->reserved >= dest->size)
+					dest->full = 1;
+				num_bytes -= bytes_to_add;
+			}
+			spin_unlock(&dest->lock);
+		}
+		if (num_bytes) {
 			spin_lock(&space_info->lock);
 			space_info->bytes_reserved -= num_bytes;
 			spin_unlock(&space_info->lock);
-- 
1.6.6.1

