From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH] Fix segmentation fault when opening invalid file system
Date: Sun, 19 Feb 2012 21:11:46 +0100
Message-ID: <1329682306-21681-1-git-send-email-kario@wit.edu.pl>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Hubert Kario <kario@wit.edu.pl>
---
 btrfslabel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/btrfslabel.c b/btrfslabel.c
index c9f4684..3c3566b 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -55,6 +55,8 @@ static void change_label_unmounted(char *dev, char *nLabel)
         * and as read-write.
         */
        root = open_ctree(dev, 0, 1);
+       if (!root) /* errors are printed by open_ctree() */
+         return;
 
        trans = btrfs_start_transaction(root, 1);
        strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
-- 
1.7.9

