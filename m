Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab3KNOJ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 09:09:57 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: mkfs: enable extended refs by default
Date: Thu, 14 Nov 2013 15:09:53 +0100
Message-Id: <1384438193-13237-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The feature has been introduced in kernel 3.7 and enabling it by
default is desired.

All features enabled by default are marked as such in
'mkfs.btrfs -O list-all' output.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 mkfs.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index cd0af9ef8b4f..bdfc4b170700 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -46,6 +46,8 @@
 
 static u64 index_cnt = 2;
 
+#define DEFAULT_MKFS_FEATURES	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
+
 #define DEFAULT_MKFS_LEAF_SIZE 16384
 
 struct directory_name_entry {
@@ -1155,10 +1157,15 @@ static void list_all_fs_features(void)
 
 	fprintf(stderr, "Filesystem features available at mkfs time:\n");
 	for (i = 0; i < ARRAY_SIZE(mkfs_features) - 1; i++) {
-		fprintf(stderr, "%-20s- %s (0x%llx)\n",
+		char *is_default = "";
+
+		if (mkfs_features[i].flag & DEFAULT_MKFS_FEATURES)
+			is_default = ", default";
+		fprintf(stderr, "%-20s- %s (0x%llx%s)\n",
 				mkfs_features[i].name,
 				mkfs_features[i].desc,
-				mkfs_features[i].flag);
+				mkfs_features[i].flag,
+				is_default);
 	}
 }
 
@@ -1249,7 +1256,7 @@ int main(int ac, char **av)
 	int dev_cnt = 0;
 	int saved_optind;
 	char estr[100];
-	u64 features = 0;
+	u64 features = DEFAULT_MKFS_FEATURES;
 
 	while(1) {
 		int c;
-- 
1.8.4.2

