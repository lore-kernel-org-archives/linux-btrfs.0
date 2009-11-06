From: Li Dongyang <jerry87905@gmail.com>
Subject: [PATCH]don't call btrfs_release_path in btrfs_update_root and
 btrfs_del_root
Date: Fri, 6 Nov 2009 22:33:01 +0800
Message-ID: <20091106143301.GB5451@Archlinux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We don't need to call btrfs_release_path because btrfs_free_path will do
that for us.

Signed-off-by: Li Dongyang <Jerry87905@gmail.com>
---
 fs/btrfs/root-tree.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 9351428..67fa2d2 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -159,7 +159,6 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	write_extent_buffer(l, item, ptr, sizeof(*item));
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 out:
-	btrfs_release_path(root, path);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -332,7 +331,6 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	BUG_ON(refs != 0);
 	ret = btrfs_del_item(trans, root, path);
 out:
-	btrfs_release_path(root, path);
 	btrfs_free_path(path);
 	return ret;
 }
