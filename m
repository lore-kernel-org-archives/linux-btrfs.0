From: Harshavardhana <harsha@gluster.com>
Subject: [PATCH] btfs-progs: Add null pointer checks
Date: Tue,  6 Apr 2010 19:04:37 -0700
Message-ID: <1270605877-26779-1-git-send-email-harsha@gluster.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

root tree is NULL in case of non btrfs devices, resulting in segfault.
This patch fixes such issue.

Signed-off-by: Harshavardhana <harsha@gluster.com>
---
 btrfs-image.c |    5 +++++
 btrfstune.c   |    7 +++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index f2bbcc8..b3cafbb 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -491,6 +491,11 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 	int ret;
 
 	root = open_ctree(input, 0, 0);
+        if (!root) {
+                fprintf (stderr, "unable to open ctree for %s\n", input);
+                return 1;
+        }
+
 	BUG_ON(root->nodesize != root->leafsize);
 
 	ret = metadump_init(&metadump, root, out, num_threads,
diff --git a/btrfstune.c b/btrfstune.c
index 47830c5..d2c3d51 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -108,6 +108,13 @@ int main(int argc, char *argv[])
 
 	root = open_ctree(device, 0, 1);
 
+        /* root is NULL if btrfs not found */
+        if (!root) {
+                fprintf(stderr, "Unable to open ctree for device: %s\n",
+                        device);
+                return 1;
+        }
+
 	if (seeding_flag) {
 		ret = update_seeding_flag(root, seeding_value);
 		if (!ret)
-- 
1.6.6.1

