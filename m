From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfsprogs: Fix use after free in close_ctree
Date: Wed, 26 May 2010 11:40:02 -0400
Message-ID: <4BFD40D2.9090800@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 After the roots are closed, root is freed. Yet close_ctree continues
 to use it. It works generally because no new memory is allocated in
 the interim, but with glibc malloc perturbing enabled, it crashes
 every time. This is because root->fs_info points to garbage.

 This patch uses the already-cached fs_info variable for the rest of
 the accesses and fixes the crash.

 This issue was reported at:
 https://bugzilla.novell.com/show_bug.cgi?id=603620

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 disk-io.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/disk-io.c
+++ b/disk-io.c
@@ -971,13 +971,13 @@ int close_ctree(struct btrfs_root *root)
 	if (fs_info->csum_root->node)
 		free_extent_buffer(fs_info->csum_root->node);
 
-	if (root->fs_info->log_root_tree) {
-		if (root->fs_info->log_root_tree->node)
-			free_extent_buffer(root->fs_info->log_root_tree->node);
-		free(root->fs_info->log_root_tree);
+	if (fs_info->log_root_tree) {
+		if (fs_info->log_root_tree->node)
+			free_extent_buffer(fs_info->log_root_tree->node);
+		free(fs_info->log_root_tree);
 	}
 
-	close_all_devices(root->fs_info);
+	close_all_devices(fs_info);
 	extent_io_tree_cleanup(&fs_info->extent_cache);
 	extent_io_tree_cleanup(&fs_info->free_space_cache);
 	extent_io_tree_cleanup(&fs_info->block_group_cache);
-- 
Jeff Mahoney
SUSE Labs
