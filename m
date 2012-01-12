From: Danny Kukawka <danny.kukawka@bisect.de>
Subject: [PATCH 2/4] return error code from change/get_label_unmounted
Date: Thu, 12 Jan 2012 16:17:45 +0100
Message-ID: <1326381467-19848-3-git-send-email-danny.kukawka@bisect.de>
References: <1326381467-19848-1-git-send-email-danny.kukawka@bisect.de>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326381467-19848-1-git-send-email-danny.kukawka@bisect.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: David Sterba <dsterba@suse.cz>

Return error code from change/get_label_unmounted caused by
caused by open_ctree()
---
 btrfslabel.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/btrfslabel.c b/btrfslabel.c
index 2e5d539..29b00bf 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -46,7 +46,7 @@
 #define GET_LABEL                      3
 #define SET_LABEL                      4
 
-static void change_label_unmounted(char *dev, char *nLabel)
+static int change_label_unmounted(char *dev, char *nLabel)
 {
        struct btrfs_root *root;
        struct btrfs_trans_handle *trans;
@@ -57,7 +57,7 @@ static void change_label_unmounted(char *dev, char *nLabel)
        root = open_ctree(dev, 0, 1);
        if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
-		return;
+		return -1;
        }
 
        trans = btrfs_start_transaction(root, 1);
@@ -66,9 +66,10 @@ static void change_label_unmounted(char *dev, char *nLabel)
 
        /* Now we close it since we are done. */
        close_ctree(root);
+       return 0;
 }
 
-static void get_label_unmounted(char *dev)
+static int get_label_unmounted(char *dev)
 {
        struct btrfs_root *root;
 
@@ -78,13 +79,14 @@ static void get_label_unmounted(char *dev)
        root = open_ctree(dev, 0, 0);
        if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
-		return;
+		return -1;
        }
 
        fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
 
        /* Now we close it since we are done. */
        close_ctree(root);
+       return 0;
 }
 
 int get_label(char *btrfs_dev)
@@ -103,8 +105,7 @@ int get_label(char *btrfs_dev)
 	       fprintf(stderr, "FATAL: the filesystem has to be unmounted\n");
 	       return -2;
 	}
-	get_label_unmounted(btrfs_dev);
-	return 0;
+	return get_label_unmounted(btrfs_dev);
 }
 
 
@@ -124,6 +125,5 @@ int set_label(char *btrfs_dev, char *nLabel)
 	       fprintf(stderr, "FATAL: the filesystem has to be unmounted\n");
 	       return -2;
 	}
-	change_label_unmounted(btrfs_dev, nLabel);
-	return 0;
+	return change_label_unmounted(btrfs_dev, nLabel);
 }
-- 
1.7.8

