From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: check unused against how much space we actually want
Date: Thu, 22 Sep 2011 14:30:44 -0400
Message-ID: <1316716244-15936-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There is a bug that may lead to early ENOSPC in our reservation code.  We've
been checking against num_bytes which may be above and beyond what we want to
actually reserve, which could give us a false ENOSPC.  Fix this by making sure
the unused space is above how much we want to reserve and not how much we're
trying to flush.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5498bda..fd65f6b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3472,7 +3472,7 @@ again:
 	 */
 	if (unused <= space_info->total_bytes) {
 		unused = space_info->total_bytes - unused;
-		if (unused >= num_bytes) {
+		if (unused >= orig_bytes) {
 			space_info->bytes_may_use += orig_bytes;
 			ret = 0;
 		} else {
-- 
1.7.5.2

