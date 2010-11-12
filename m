From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] 'unused' calculated with wrong sign.
Date: Sat, 13 Nov 2010 00:17:56 +0100
Message-ID: <1289603876-28542-1-git-send-email-sensille@gmx.net>
Cc: josef@redhat.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

'unused' calculated with wrong sign in reserve_metadata_bytes().
This might have lead to unwanted over-reservations.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a541bc8..ddaf634 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3413,7 +3413,7 @@ again:
 	 * our reservation.
 	 */
 	if (unused <= space_info->total_bytes) {
-		unused -= space_info->total_bytes;
+		unused = space_info->total_bytes - unused;
 		if (unused >= num_bytes) {
 			if (!reserved)
 				space_info->bytes_reserved += orig_bytes;
-- 
1.7.2.2

