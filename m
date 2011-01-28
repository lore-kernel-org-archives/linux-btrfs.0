From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: do error checking in btrfs_del_csums
Date: Fri, 28 Jan 2011 13:44:44 -0500
Message-ID: <1296240284-3166-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Got a report of a box panicing because we got a NULL eb in read_extent_buffer.
His fs was borked and btrfs_search_path returned EIO, but we don't check for
errors so the box paniced.  Yes I know this will just make something higher up
the stack panic, but that's a problem for future Josef.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file-item.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a562a25..4f19a3e 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -536,6 +536,8 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 	root = root->fs_info->csum_root;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	while (1) {
 		key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
@@ -548,7 +550,10 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 			if (path->slots[0] == 0)
 				goto out;
 			path->slots[0]--;
+		} else if (ret < 0) {
+			goto out;
 		}
+
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 
-- 
1.6.6.1

