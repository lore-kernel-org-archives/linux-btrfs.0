From: Danny Kukawka <danny.kukawka@bisect.de>
Subject: [PATCH 4/4] fix indentation
Date: Thu, 12 Jan 2012 16:17:47 +0100
Message-ID: <1326381467-19848-5-git-send-email-danny.kukawka@bisect.de>
References: <1326381467-19848-1-git-send-email-danny.kukawka@bisect.de>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326381467-19848-1-git-send-email-danny.kukawka@bisect.de>
List-ID: <linux-btrfs.vger.kernel.org>

Fixed indentation, replace spaces with tabs.
---
 btrfslabel.c |   52 ++++++++++++++++++++++++++--------------------------
 1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/btrfslabel.c b/btrfslabel.c
index 29b00bf..50050ec 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -48,45 +48,45 @@
 
 static int change_label_unmounted(char *dev, char *nLabel)
 {
-       struct btrfs_root *root;
-       struct btrfs_trans_handle *trans;
-
-       /* Open the super_block at the default location
-        * and as read-write.
-        */
-       root = open_ctree(dev, 0, 1);
-       if (!root) {
+	struct btrfs_root *root;
+	struct btrfs_trans_handle *trans;
+
+	/* Open the super_block at the default location
+	 * and as read-write.
+	 */
+	root = open_ctree(dev, 0, 1);
+	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
 		return -1;
-       }
+	}
 
-       trans = btrfs_start_transaction(root, 1);
-       strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
-       btrfs_commit_transaction(trans, root);
+	trans = btrfs_start_transaction(root, 1);
+	strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
+	btrfs_commit_transaction(trans, root);
 
-       /* Now we close it since we are done. */
-       close_ctree(root);
-       return 0;
+	/* Now we close it since we are done. */
+	close_ctree(root);
+	return 0;
 }
 
 static int get_label_unmounted(char *dev)
 {
-       struct btrfs_root *root;
+	struct btrfs_root *root;
 
-       /* Open the super_block at the default location
-        * and as read-only.
-        */
-       root = open_ctree(dev, 0, 0);
-       if (!root) {
+	/* Open the super_block at the default location
+	* and as read-only.
+	*/
+	root = open_ctree(dev, 0, 0);
+	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
 		return -1;
-       }
+	}
 
-       fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
+	fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
 
-       /* Now we close it since we are done. */
-       close_ctree(root);
-       return 0;
+	/* Now we close it since we are done. */
+	close_ctree(root);
+	return 0;
 }
 
 int get_label(char *btrfs_dev)
-- 
1.7.8

