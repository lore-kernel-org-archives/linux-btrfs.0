Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo103.cox.net ([68.230.241.215]:37514 "EHLO
	eastrmfepo103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3AXPxD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 10:53:03 -0500
Received: from eastrmimpo306 ([68.230.241.238]) by eastrmfepo103.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130124155302.RPEF23841.eastrmfepo103.cox.net@eastrmimpo306>
          for <linux-btrfs@vger.kernel.org>;
          Thu, 24 Jan 2013 10:53:02 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>, Danny Kukawka <danny.kukawka@bisect.de>
Subject: [PATCH] Btrfs-progs: Fix minor problems with btrfslabel.c
Date: Thu, 24 Jan 2013 10:52:18 -0500
Message-Id: <1359042738-14522-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fixed indentation, replace spaces with tabs.
Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Rebased, also fixed compiler warnings
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 btrfslabel.c | 57 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/btrfslabel.c b/btrfslabel.c
index 88a5196..bea1f89 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -48,42 +48,43 @@
 
 static int change_label_unmounted(char *dev, char *nLabel)
 {
-       struct btrfs_root *root;
-       struct btrfs_trans_handle *trans;
-
-       /* Open the super_block at the default location
-        * and as read-write.
-        */
-       root = open_ctree(dev, 0, 1);
-       if (!root) /* errors are printed by open_ctree() */
-         return;
-
-       trans = btrfs_start_transaction(root, 1);
-       strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
-       root->fs_info->super_copy.label[BTRFS_LABEL_SIZE-1] = 0;
-       btrfs_commit_transaction(trans, root);
-
-       /* Now we close it since we are done. */
-       close_ctree(root);
+	struct btrfs_root *root;
+	struct btrfs_trans_handle *trans;
+
+	/* Open the super_block at the default location
+	 * and as read-write.
+	 */
+	root = open_ctree(dev, 0, 1);
+	if (!root) /* errors are printed by open_ctree() */
+	  return -1;
+
+	trans = btrfs_start_transaction(root, 1);
+	strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
+	root->fs_info->super_copy.label[BTRFS_LABEL_SIZE-1] = 0;
+	btrfs_commit_transaction(trans, root);
+
+	/* Now we close it since we are done. */
+	close_ctree(root);
+	return 0;
 }
 
 int get_label_unmounted(char *dev)
 {
-       struct btrfs_root *root;
+	struct btrfs_root *root;
 
-       /* Open the super_block at the default location
-        * and as read-only.
-        */
-       root = open_ctree(dev, 0, 0);
+	/* Open the super_block at the default location
+	 * and as read-only.
+	 */
+	root = open_ctree(dev, 0, 0);
 
-       if(!root)
-         return -1;
+	if(!root)
+	  return -1;
 
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
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
