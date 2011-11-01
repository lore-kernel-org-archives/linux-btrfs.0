From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs-progs: fail gracefully on error from open_ctree()
Date: Tue,  1 Nov 2011 23:47:22 +0200
Message-ID: <1320184042-5188-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Error checking block got moved mistakenly exposing us to a potential
segmentation fault.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 mkfs.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index e3ced19..a6f6b1f 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1328,7 +1328,12 @@ int main(int ac, char **av)
 		fprintf(stderr, "error during mkfs %d\n", ret);
 		exit(1);
 	}
+
 	root = open_ctree(file, 0, O_RDWR);
+	if (!root) {
+		fprintf(stderr, "ctree init failed\n");
+		return -1;
+	}
 	root->fs_info->alloc_start = alloc_start;
 
 	ret = make_root_dir(root, mixed);
@@ -1343,10 +1348,6 @@ int main(int ac, char **av)
 		goto raid_groups;
 
 	btrfs_register_one_device(file);
-	if (!root) {
-		fprintf(stderr, "ctree init failed\n");
-		return -1;
-	}
 
 	zero_end = 1;
 	while(ac-- > 0) {
-- 
1.7.6.3

