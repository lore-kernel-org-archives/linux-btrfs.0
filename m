From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: check return value of btrfs_search_slot properly
Date: Wed, 16 Mar 2011 14:01:27 -0400
Message-ID: <1300298487-5638-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Doing an audit of where we use btrfs_search_slot only showed one place where we
don't check the return value of btrfs_search_slot properly.  Just fix
mark_extent_written to see if btrfs_search_slot failed and act accordingly.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3786eca..a85b044 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -608,6 +608,8 @@ again:
 	key.offset = split;
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret < 0)
+		goto out;
 	if (ret > 0 && path->slots[0] > 0)
 		path->slots[0]--;
 
-- 
1.7.2.3

