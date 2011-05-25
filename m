From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't commit the transaction if we dont have enough pinned bytes
Date: Wed, 25 May 2011 13:11:30 -0400
Message-ID: <1306343490-26057-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I noticed when running an enospc test that we would get stuck committing the
transaction in check_data_space even though we truly didn't have enough space.
So check to see if bytes_pinned is bigger than num_bytes, if it's not don't
commit the transaction.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c8c3184..adb6696 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3199,6 +3199,13 @@ alloc:
 			}
 			goto again;
 		}
+
+		/*
+		 * If we have less pinned bytes than we want to allocate then
+		 * don't bother committing the transaction, it won't help us.
+		 */
+		if (data_sinfo->bytes_pinned < num_bytes)
+			committed = 1;
 		spin_unlock(&data_sinfo->lock);
 
 		/* commit the current transaction and try again */
-- 
1.7.2.3

