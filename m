From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 3/7] check open_ctree() right after it returned
Date: Tue,  1 Feb 2011 14:54:46 +0100
Message-ID: <1296568490-13264-4-git-send-email-list.btrfs@jan-o-sch.net>
References: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
Cc: chris.mason@oracle.com, sensille@gmx.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 mkfs.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index d1dd4a3..0a80d1c 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -430,7 +430,13 @@ int main(int ac, char **av)
 		fprintf(stderr, "error during mkfs %d\n", ret);
 		exit(1);
 	}
+
 	root = open_ctree(file, 0, O_RDWR);
+	if (!root) {
+		fprintf(stderr, "ctree init failed\n");
+		return -1;
+	}
+
 	root->fs_info->alloc_start = alloc_start;
 
 	ret = make_root_dir(root);
@@ -445,10 +451,6 @@ int main(int ac, char **av)
 		goto raid_groups;
 
 	btrfs_register_one_device(file);
-	if (!root) {
-		fprintf(stderr, "ctree init failed\n");
-		return -1;
-	}
 
 	zero_end = 1;
 	while(ac-- > 0) {
-- 
1.7.2.2

