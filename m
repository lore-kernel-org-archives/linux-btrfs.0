From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't map extent buffer if path->skip_locking is set
Date: Wed,  8 Jun 2011 14:45:50 -0400
Message-ID: <1307558750-19721-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Arne's scrub stuff exposed a problem with mapping the extent buffer in
reada_for_search.  He searches the commit root with multiple threads and with
skip_locking set, so we can race and overwrite node->map_token since node isn't
locked.  So fix this so that we only map the extent buffer if we don't already
have a map_token and skip_locking isn't set.  Without this patch scrub would
panic almost immediately, with the patch it doesn't panic anymore.  Thanks,

Reported-by: Arne Jansen <sensille@gmx.net>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d840893..2e66786 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1228,6 +1228,7 @@ static void reada_for_search(struct btrfs_root *root,
 	u32 nr;
 	u32 blocksize;
 	u32 nscan = 0;
+	bool map = true;
 
 	if (level != 1)
 		return;
@@ -1249,8 +1250,11 @@ static void reada_for_search(struct btrfs_root *root,
 
 	nritems = btrfs_header_nritems(node);
 	nr = slot;
+	if (node->map_token || path->skip_locking)
+		map = false;
+
 	while (1) {
-		if (!node->map_token) {
+		if (map && !node->map_token) {
 			unsigned long offset = btrfs_node_key_ptr_offset(nr);
 			map_private_extent_buffer(node, offset,
 						  sizeof(struct btrfs_key_ptr),
@@ -1277,7 +1281,7 @@ static void reada_for_search(struct btrfs_root *root,
 		if ((search <= target && target - search <= 65536) ||
 		    (search > target && search - target <= 65536)) {
 			gen = btrfs_node_ptr_generation(node, nr);
-			if (node->map_token) {
+			if (map && node->map_token) {
 				unmap_extent_buffer(node, node->map_token,
 						    KM_USER1);
 				node->map_token = NULL;
@@ -1289,7 +1293,7 @@ static void reada_for_search(struct btrfs_root *root,
 		if ((nread > 65536 || nscan > 32))
 			break;
 	}
-	if (node->map_token) {
+	if (map && node->map_token) {
 		unmap_extent_buffer(node, node->map_token, KM_USER1);
 		node->map_token = NULL;
 	}
-- 
1.7.5.2

